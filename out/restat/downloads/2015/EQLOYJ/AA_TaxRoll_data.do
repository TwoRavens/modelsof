*--------------------------------------------------------------------AA_TAXROLL_DATA.DO---------------------------------------------------------------------------------
*This script merges and formats tax roll data obtained from the AA City Assessor.  These data are analogous to the Values + Sales datasets from 1997-2008, except that
*transactions must be inferred from the last sale data in each static tax roll file, which are compiled at different points in time (as given by the dates in the file names).
*Sebastien Bradley

clear all
capture cd "C:/Users/Sebastien/Documents/Research/PropertyTaxes/Ann_Arbor"
capture log close
log using AA_data_results.txt, text replace
set more off


foreach fdate in 3-7-10 10-6-09 6-2-08 12-18-07 10-02-06 05 04 {
  insheet using "AA_tax_roll`fdate'.txt", clear tab names

  renpfix mst_	/*Drop meaningless variable name prefixes*/
  renpfix par_
  renpfix summary

  *Modify certain variable names which are not consistent across datasets
  if "`fdate'"=="3-7-10" | "`fdate'"=="10-6-09" | "`fdate'"=="6-2-08" | "`fdate'"=="04" | "`fdate'"=="05" {
	egen propaddresscombined = concat(propaddressnumber propaddressdir propaddressstreet propaddressapt), punct(" ")
	replace propaddresscombined = ltrim(itrim(propaddresscombined))
	drop propaddressnumber propaddressstreet propaddressapt propaddressdir
  }

  if "`fdate'"~="10-02-06" {
	rename pre_year1_may pre
	rename sev_year1_mbor sev
	rename tax_year1_mbor tv
  }
  else {
	rename pre_year2_final pre		/*According to Mike Courtney, different mnemonics have no significance*/
	rename sev_year2_final sev
	rename tax_year2_final tv
  }
  *The preliminary 2010 file also lists sev_year2_mbor and tv_year2_mbor.  These are lagged values, while the 2010 figures
  *must be pre-appeal (i.e. they may not reflect Board decisions vis-a-vis contested assessments).
  if "`fdate'"=="3-7-10" {
	drop sev_year2_mbor tax_year2_mbor
  }

  *Rename variables with suffix to denote year of data
  order parcelnumber propaddresscombined ownername1, first
  order schooldistrict, last
  local yy = substr("`fdate'",length("`fdate'")-1,2)
  foreach var of varlist ownername1-schooldistrict {
	rename `var' `var'20`yy'
  }

  drop if parcelnumber==""
  save AA_tax_roll`fdate'.dta, replace
}


*MERGE DATAFILES AND STACK DATA
merge 1:1 parcelnumber using AA_tax_roll05.dta, gen(merge05)
merge 1:1 parcelnumber using AA_tax_roll10-02-06.dta, gen(merge06)
merge 1:1 parcelnumber using AA_tax_roll12-18-07.dta, gen(merge07)
merge 1:1 parcelnumber using AA_tax_roll6-2-08.dta, gen(merge08)
merge 1:1 parcelnumber using AA_tax_roll10-6-09.dta, gen(merge09)
merge 1:1 parcelnumber using AA_tax_roll3-7-10.dta, gen(merge10)
tab merge05 merge06
tab merge06 merge07
tab merge07 merge08
tab merge08 merge09
tab merge09 merge10
drop if merge10~=3 & merge09~=3 & merge08~=3 & merge07~=3 & merge06~=3 & merge05~=3	/*Exclude parcels that do not appear at least twice across years of files*/
drop merge*


*STACK:
#delimit ;
drop ci*;
local vl = "ownername1 ownername2 ownerstreetaddress ownercity ownerstate ownerzipcode lastsaledate lastsaleamt";
local vl1 = "pre sev tv landvalue";
local vl2 = "ffactual averagedepth ffeffective totalacreage resoccupancy resstylealph resnumbed resbsmntarea
	resfullbaths reshalfbaths resyearbuilt reseffecage resfloorarea resgaragearea";
local vl3 = "propertyclass zoning_primary schooldistrict resclass";
#delimit cr

reshape long `vl' `vl1' `vl2' `vl3', i(parcelnumber) j(year)

sort parcelnumber year
save AA_tax_roll.dta, replace

*Erase temporary tax roll datasets
foreach fdate in 3-7-10 10-6-09 6-2-08 12-18-07 10-02-06 05 04 {
	erase AA_tax_roll`fdate'.dta
}


*CLEAN-UP
*Reformat sale dates
drop if lastsaledate=="/  /" | lastsaledate==""
gen saledate = date(lastsaledate, "MDY")
format saledate %tdDDMonCCYY
gen saleyear_str = substr(lastsaledate,length(lastsaledate)-4+1,4)
gen salemonth_str = substr(lastsaledate,1,strpos(lastsaledate,"/")-1)
gen saleday_str = substr(lastsaledate,strpos(lastsaledate,"/")+1, length(lastsaledate)-length(saleyear_str)-length(salemonth_str)-2)
destring saleyear_str, gen(saleyear)
destring salemonth_str, gen(salemonth)
destring saleday_str, gen(saleday)
drop *_str
gen saledayofyear = doy(saledate)

tab propertyclass if sev==0
*Exclude non-profit organizations which do not pay property taxes:
drop if sev==0
drop if saleyear==.

tab propertyclass
tab resclass
*Exclude vacant land/unimproved properties:
drop if regexm(upper(propaddresscombined),"VACANT")==1
drop if propertyclass~=201 & propertyclass~=301 & propertyclass~=401
label define propclasslbl 201 "Commercial" 301 "Industrial" 401 "Residential"
label values propertyclass propclasslbl
	/*Note that commercial property includes e.g. Geddes Lake and other co-ops which do not conform
	to the general tax rules (i.e. co-ops face proportional uncapping on 12/31 of each year to 
	account for fraction of units/shares which changed hands).*/

*Recode homes with 0 bedrooms to missing.
*Apparently, number of bedrooms is not a protected field (i.e. not used) by AA Assessor
*Added 1/22/10 following discussion with Mike Courtney, AA Appraiser
replace resnumbed = . if resnumbed==0

*Recode homes with 0 square footage to missing.
*Unlike bedrooms, not clear that this is a protected field.
replace resfloorarea = . if resfloorarea==0

*Recode homes with year built of 0 or 200 to missing.
replace resyearbuilt = . if resyearbuilt < 1492


*EVALUATE COMMON FEATURES OF PROPERTIES WITH SEV=TV
sort parcelnumber year
encode parcelnumber, gen(pid)
xtset pid year
rename pid pid_long
rename parcelnumber pid
sort pid year

gen I_uncap = (sev==tv)
label define uncaplbl 0 "SEV!=TV" 1 "SEV==TV"
label values I_uncap uncaplbl
tab year I_uncap
tab saleyear year if I_uncap==1

by pid: gen I_apprec = (sev>sev[_n-1]) if sev~=. & sev[_n-1]~=.
label define appreclbl 0 "Depreciating" 1 "Appreciating"
label values I_apprec appreclbl
bysort year: tab I_uncap I_apprec if year~=2006 & saleyear~=year-1
tab year I_apprec

*Compute SEV and TV growth rates
sort pid year
by pid: gen sev_pct = ((sev/sev[_n-1])-1)*100
by pid: gen tv_pct = ((tv/tv[_n-1])-1)*100
gen irm = -0.3 if year==2010
replace irm = 4.4 if year==2009
replace irm = 2.3 if year==2008	/*Inflation Rate Multipliers provided by Michigan Tax Commission*/
replace irm = 3.7 if year==2007	/*for computing maximum increases in taxable values throughout the state.*/
replace irm = 3.3 if year==2006
replace irm = 2.3 if year==2005
replace irm = 2.3 if year==2004
replace tv_pct = round(tv_pct,0.1)
gen I_max_tv_pct = (tv_pct==irm) if tv_pct~=.
replace I_max_tv_pct = 2 if tv_pct>irm & tv_pct~=.
label define maxtvlbl 0 "< Max" 1 "Max" 2 "> Max"
label values I_max_tv_pct maxtvlbl


*Identify occurrence of renovations from jumps in TV in excess of the IRM or from reductions in effective ages (potentially reflecting 
*renovations that fall under general maintenance and repair without triggering fractional uncapping).
*In the absence of evidence regarding these types of renovations, last renovations are assumed to have occurred when the home was previously
*purchased (i.e. assumes all new owners perform renovations/repairs in year of purchase; some owners perform additional renovations/repairs
*in subsequent years).
*Modified 8/8/10
sort pid year
gen renov = saleyear
by pid: replace renov = year if (irm[_n+1]<tv_pct[_n+1] | reseffecage > reseffecage[_n+1]) & saleyear~=year & tv_pct[_n+1]~=. & reseffecage[_n+1]~=. & irm[_n+1]~=.
by pid: replace renov = max(renov,renov[_n-1])
replace renov = max(renov,resyearbuilt) if year~=2004
by pid: gen renovage = year-renov[_n-1]								/*Produces all missing observations for 2004*/
by pid: replace renovage = year-renov if renov<year & year==2004	/*Update missing 2004 observations if no contemporaneous sale recorded in 2004*/


sort pid year
save AA_tax_roll.dta, replace

log close


/**/
