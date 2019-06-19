*-----------------------------------AA_ASSESSOR_DATA.DO-------------------------------------
*This script assembles the panel of SEV and TV information obtained from the A2 Assessor's Office
*and merges this with her sale and general property information to produce a cross-section of sold homes in Ann Arbor for all years 1997-2008.

*Sebastien Bradley 6/6/10

clear all
capture cd "C:/Users/sjb355/Documents/Research/PropertyTaxes/Ann_Arbor/AA_proptaxdata19972008"
capture log close
log using AA_data_results.txt, text replace
*set more on
set more off

/**/
*INPUT, MERGE, AND STACK SEV AND TV VALUES
foreach fdate in 19972000 20012004 20052008 {
  	insheet using "Values_`fdate'.txt", clear tab names
  	*tab class
  	drop if class~=201 & class~=301 & class~=401	/*Exclude vacant land/unimproved properties and non-taxable properties*/
	rename parcelnumber pid
    	save Values_`fdate'.dta, replace
  }

*Merge
merge pid using Values_20012004.dta, sort _merge(m0104)
merge pid using Values_19972000.dta, sort _merge(m9700)
*tab m0104
*tab m9700
drop m0104 m9700

label define classlbl 201 "Commercial" 301 "Industrial" 401 "Residential"
label values class classlbl

*Stack
reshape long sev tv, i(pid) j(year)

*tab class if sev==0
drop if sev==0	/*Exclude remaining parcels which do not pay property taxes*/

*Compute annual average SEV growth and construct corresponding assessment index:
sort pid year
by pid: gen sev_pct = sev/sev[_n-1]
bysort year: egen avg_sev_pct = mean(sev_pct)
gen ai = 100 if year==1997
sort pid year
replace ai = ai[_n-1]*avg_sev_pct if year>1997 
drop *pct

save Values_19972008.dta, replace
erase Values_19972000.dta 
erase Values_20012004.dta
erase Values_20052008.dta
/**/

*INPUT SALES HISTORY
insheet using Sale_data.txt, clear tab names
rename parcelnumber pid
rename propertyclass class
rename saleprice saleamt
drop if class~=201 & class~=301 & class~=401

*Reformat sale dates
drop if saledate=="/  /" | saledate==""
gen saleyear_str = substr(saledate,length(saledate)-4+1,4)
gen salemonth_str = substr(saledate,1,strpos(saledate,"/")-1)
gen saleday_str = substr(saledate,strpos(saledate,"/")+1,length(saledate)-length(saleyear_str)-length(salemonth_str)-2)
destring saleyear_str, gen(saleyear)
destring salemonth_str, gen(salemonth)
destring saleday_str, gen(saleday)
drop *_str
gen tmp = date(saledate, "MDY")
drop saledate
rename tmp saledate 
format saledate %tdDDMonCCYY

*tab saleyear
drop if saleyear==993
drop if regexm(upper(propaddresscombined),"VACANT")==1	/*Vacant properties*/

*Recode homes with 0 bedrooms or 0 feet of square footage to missing.
replace resnumbed = . if resnumbed==0
replace resfloorarea = . if resfloorarea==0

*Recode homes with year built of 0 or 200 to missing.
replace resyearbuilt = . if resyearbuilt < 1492

*Eliminate duplicate sale observations
duplicates drop
sort pid saledate saleamt
*drop if pid==pid[_n-1] & saledate==saledate[_n-1] & saleamt==saleamt[_n-1]	/*Somehow misses two exact duplicates*/

save AA_data.dta, replace


*MERGE WITH MONTHLY U.S. HOUSING PRICE INDEX DATA (POST PROPOSAL A) ALONG WITH CPI AND AN IRM INDEX (computed myself using IRM figures from MI Tax Commission--see below).
*Data is nationwide and for East North Central Census Division (MI, WI, IL, IN, OH) for 1995Q1 onward.
*Prior HPI data is not used since it would fail to account for price changes due to Prop A implementation.
insheet using ../../USHPI.txt, clear tab names
merge saleyear salemonth using AA_data.dta, sort uniqmaster
drop if _merge==1
drop _merge
save AA_data.dta, replace

insheet using ../../USCPI.txt, clear tab names
merge saleyear using AA_data.dta, sort uniqmaster
drop if _merge==1
drop _merge


*MERGE SALES AND PROPERTY INFO W/ SEV AND TV DATA
gen year = saleyear
sort pid year
merge pid year using Values_19972008.dta
sort pid year saledate saleamt		/*Sort to account consistently for multiple sales within year (and in some cases, same day)*/
tab _merge

*Identify occurrence of renovations from jumps in TV in excess of the IRM
*(Using reductions in effective ages that potentially reflect renovations that fall under general maintenance and repair without triggering 
*fractional uncapping is infeasible in this data given the absence of effective age information).
*In the absence of evidence regarding these types of renovations, last renovations are assumed to have occurred when the home was previously
*purchased (i.e. assumes all new owners perform renovations/repairs in year of purchase; some owners perform additional renovations/repairs
*in subsequent years).

*Inflation Rate Multipliers provided by Michigan Tax Commission for computing maximum increases in taxable 
*values throughout the state:
local y = "1998"
gen irm = 2.7 if year==`y'
foreach i in 1.6 1.9 3.2 3.2 1.5 2.3 2.3 3.3 3.7 2.3 4.4 -0.3 {
	local y = `y'+1
	replace irm = `i' if year==`y'
}

by pid: gen tv_pct = ((tv/tv[_n-1])-1)*100
gen renov = saleyear
replace tv_pct = round(tv_pct,0.1)		
by pid: replace renov = year if irm[_n+1]<tv_pct[_n+1] & saleyear~=year	/*For some reason, irm<round(tv_pct,0.1) does not yield the right results directly*/
gen lastrenov = renov
by pid: replace lastrenov = lastrenov[_n-1] if lastrenov==.
by pid: gen renovage = renov-lastrenov[_n-1] if saleyear==year

*Added 4/13/15:
*Divide tax roll panel into ownership histories and compute aggregate renovation amounts by owner (allowing amounts to be positive or negative)
*Note that downward renovation amounts could also reflect property tax appeals.
gen tmp_sold = (saleyear==year)
by pid: gen tmp_owners = sum(tmp_sold)
sort pid tmp_owners year saledate saleamt
by pid: gen tmp_renovamt = ((tv_pct[_n+1]-irm[_n+1])/100)*tv*2 if irm[_n+1]~=tv_pct[_n+1] & saleyear~=year		/*Multiply renovation amounts by 2 to reoover market value*/
by pid tmp_owners: gen renovamt = sum(tmp_renovamt) 															/*Add up value of additions since last sale*/
by pid: replace renovamt = renovamt[_n-1] if saleyear==year & renovamt[_n-1]~=.
sort pid year saledate saleamt
drop tmp*

summ renovamt if saleyear==year & class==401, detail

save AA_data_panel.dta, replace						/*Save complete data panel for future use*/
drop renov lastrenov


*Retain prior-year, contemporaneous (i.e. pre-sale) and post-sale SEV and TV info and drop all other SEV and TV data for inter-sale periods.
foreach v in sev tv {
	by pid: gen f_`v' = `v'[_n+1] if propaddresscombined~=""
	by pid: gen l_`v' = `v'[_n-1] if propaddresscombined~=""
	by pid: gen ff_`v' = `v'[_n+2] if propaddresscombined~=""
	by pid: gen ll_`v' = `v'[_n-2] if propaddresscombined~=""
}
gen f_ai = ai[_n+1] if propaddresscombined~=""		/*Note asymmetry of next period assessed values index and "lagged"*/
drop if propaddresscombined==""

*Record date and price of previous sale, then drop all pre-1997 sales (for which no SEV or TV info).
sort pid saledate
foreach v in saledate saleyear saleamt us_hpi enc_hpi cpi irmi ai {
	by pid: gen l_`v' = `v'[_n-1]
}
format l_saledate %tdDDMonCCYY
drop if saleyear<1997
drop if _merge~=3			/*Drop properties with missing contemporaneous SEV and TV info in 1997-2008 sale window*/
drop _merge


gen yearsheld = saleyear-l_saleyear
tab renovage yearsheld if yearsheld < 16, col
corr renovage yearsheld

log close


sort pid saledate
aorder
order pid propaddresscombined saledate sale* l_sale* sev tv tv_pct irm f_sev-ff_tv l_sev l_tv ll_sev ll_tv us_hpi l_us_hpi enc_hpi l_enc_hpi cpi l_cpi irmi l_irmi ai l_ai f_ai
save AA_data.dta, replace


*MERGE AA SALES AND ASSESSED VALUES DATA with neighborhood, school attendance, and Census tract information identified through
*geocoding of sale addresses using GIS software in a previous step (after invoking format_AA_sale_addresses.do).
insheet using AA_sale_addresses_w_neighborhoods.txt, clear tab names
sort pid
merge pid using AA_data.dta
drop _merge
destring neighborhood, replace

save AA_GIS_data.dta, replace

foreach level in elem mid high {
	insheet using AA_sale_pid_w_`level'_sch.txt, clear tab names
	merge pid using AA_GIS_data.dta, uniqmaster sort
	tab _merge
	drop _merge
	if "`level'"~="high" {
		save AA_GIS_data.dta, replace
	}
}

replace elem_sch = "Allen" if elem_sch=="Bused to Allen"
replace elem_sch = "King" if elem_sch=="Bused to King, Logan & Thurston"	/*Cheating slightly - affects 6 obs only*/

save AA_GIS_data.dta, replace

insheet using AA_sale_pid_w_censustract.txt, clear tab names
merge pid using AA_GIS_data.dta, uniqmaster sort
tab _merge
drop _merge
foreach v of varlist census_* {
	destring `v', replace
}

*order pid propaddresscombined saledate sale* l_sale* sev tv tv_pct irm f_sev-ff_tv l_sev l_tv ll_sev ll_tv us_hpi l_us_hpi enc_hpi l_enc_hpi cpi l_cpi irmi l_irmi *ai* neighborhood elem_sch mid_sch high_sch census_*
save AA_GIS_data.dta, replace



*CONSTRUCT NEIGHBORHOOD-SPECIFIC MEASURES OF AVERAGE ASSESSED VALUE GROWTH FROM THE FULL PANEL
insheet using AA_sale_addresses_w_neighborhoods.txt, clear tab names
sort pid
merge pid using AA_data_panel.dta, uniqmaster _merge(m_gis)
drop if m_gis~=3
drop if year<1997

sort pid year
by pid: gen sev_pct = sev/sev[_n-1]
sort neighborhood year
by neighborhood year: egen avg_sev_pct_hood = mean(sev_pct)
by neighborhood year: egen ma_sev_pct_hood = mean((((sev_pct[_n-1]+sev_pct+sev_pct[_n+1])/3)-1)*100)
gen ai_hood = 100 if year==1997
sort pid year
replace ai_hood = ai_hood[_n-1]*avg_sev_pct_hood if year>1997
by pid: gen f_ai_hood = ai_hood[_n+1]

drop if _merge~=3
keep pid year saledate saleamt ai_hood ma_sev_pct_hood
merge pid saledate saleamt using AA_GIS_data.dta, sort
drop if _merge~=3
drop _merge

sort pid year
by pid: gen l_ai_hood = ai_hood[_n-1]					/*Note asymmetry of next period assessed values index and "lagged"*/
drop year

save AA_GIS_data.dta, replace


*MERGE WITH CENSUS TRACT-LEVEL DEMOGRAPHIC DATA
*Flag census tracts with above-vs-below median education, proportion of long-time Michigan residents, Michigan natives, etc.
insheet using "..\Michigan_Census_Tracts\AA_EducMigration.txt", clear tab names
gen educ_colldeg_pct = educ_ba_pct + educ_gtma_pct	/*Captures proportion of population 25+ with at least bachelor's degree*/
gen educ_lt12_pct = educ_lt8_pct + educ_9_12_pct	/*Captures proportion of population 25+ without even high school diploma*/
gen res_nonmi_pct = res_usnonmi_pct + res_nonus_pct	/*Proportion of population 5+ having moved from out-of-state (and possibly country) since 1995*/
gen res_mi_pct = res_wa_pct + res_minonwa_pct		/*Proportion of population 5+ having moved within state since 1995*/
									/*res_same_pct = proportion of pop having not moved since 1995*/
foreach v in educ_colldeg_pct educ_lt12_pct res_nonmi_pct res_nonus_pct res_mi_pct res_same_pct nat_mi_pct nat_noncitizen_pct {
	egen tmpmed_`v' = median(`v')
}
gen I_H_educ = (educ_colldeg_pct >= tmpmed_educ_colldeg_pct) if educ_colldeg_pct~=.		/*High proportion of bachelor's degrees (and beyond)*/
gen I_L_educ = (educ_lt12_pct >= tmpmed_educ_lt12_pct) if educ_lt12_pct~=.				/*High proportion of drop-outs*/
gen I_H_nonmi_mob = (res_nonmi_pct >= tmpmed_res_nonmi_pct) if res_nonmi_pct~=.		/*High proportion of movers from out-of-state*/
gen I_H_nonus_mob = (res_nonus_pct >= tmpmed_res_nonus_pct) if res_nonus_pct~=.		/*High proportion of movers from abroad*/
gen I_H_mi_mob = (res_mi_pct >= tmpmed_res_mi_pct) if res_mi_pct~=.				/*High proportion of movers within state*/
gen I_L_mob = (res_same_pct >= tmpmed_res_same_pct) if res_same_pct~=.				/*High proportion of non-movers*/
gen I_H_mi_native = (nat_mi_pct >= tmpmed_nat_mi_pct) if nat_mi_pct~=.				/*High proportion of MI natives*/
gen I_H_for = (nat_noncitizen_pct >= tmpmed_nat_noncitizen_pct) if nat_noncitizen_pct~=.	/*High proportion of foreign citizens*/
drop tmp*

merge census_tract using AA_GIS_data.dta, sort uniqmaster
tab _merge
drop _merge

#delimit ;
order pid propaddresscombined saledate sale* l_sale* sev tv tv_pct irm f_sev-ff_tv l_sev l_tv ll_sev ll_tv us_hpi l_us_hpi enc_hpi l_enc_hpi cpi l_cpi 
	irmi l_irmi *ai* ma_sev_pct_hood address-zoning neighborhood elem_sch mid_sch high_sch census_* enroll_n-lang_weak_eng_pct I_H* I_L*;
#delimit cr
save AA_GIS_data.dta, replace

/**/
