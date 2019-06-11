
// This file produces Table 2 in Beraja-Hurst-Fuster-Vavra. //
//////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////
///// Build dataset
////////////////////////////////////////////////////////////////////

cd [DIRECTORY]

// Monthly average 30-year fixed mortgage rate:
freduse MORTG , clear 
g datem = mofd(daten)
format datem %tm
keep datem MORTG*  

// HMDA data on monthly originations (by application month):
rename datem datem_app
merge 1:1 datem_app using data/hmda_origbyappmonth_1990to2016.dta,  nogen
rename datem_app datem

replace refi_HI_loanvol = refi_HI_loanvol*1000

/* This requires access to the Fed-internal HMDA version, via RADAR.
Pull as follows:
SELECT year,agency_code,respondent_id,action_date,application_date,loan_amount,loan_purpose,loan_type,msa_md,property_type,state_code 
FROM chmda.view_lar_chmda WHERE (view_ lar_chmda.year BETWEEN 1990 AND 2016 AND view_lar_chmda.action_type =1)
and then:
drop if agency_code=="8" // PMI
drop if state_code =="72" // Puerto Rico
drop if property_type==3 // multifamily
drop if loan_purpose<1 | loan_purpose>3 // 4 is multifamily pre 2004; <1 are errors
g x = regexm(application_date , "/")
g appdate = date(application_date, "MDY", 2050) if x==1
replace appdate = date(application_date, "YMD") if x==0
format appdate %td
g datem_app = mofd(appdate)
format datem_app %tm
drop if datem_app<m(1990m1)|datem_app>m(2016m12)
 
rename loan_amount loanamt
gen refiamt = loanamt 
replace refiamt = 0 if loan_purp==1 
g refi_code = refiamt<. & refiamt>0
g loan_code = loanamt<. & loanamt>0
collapse (sum) total_loanvol=loanamt refi_HI_loanvol = refiamt ///
	 (sum) count_loans=loan_code count_refi_HI = refi_code ///
	 , by(datem_app) fast	 
save data/hmda_origbyappmonth_1990to2016.dta, replace
*/


// Flow of Funds data on amount of mortgages outstanding
merge 1:1 datem using data/outstanding_FoF.dta, nogen keep(1 3)

/* This comes from Haver (but can also be downloaded directly from Flow of Funds website); interpolated between quarterly data points:
import haver ol15hom5@ffunds, clear

g datem = mofd(dofq(time))
format datem %tm
replace datem = datem + 2 // end of quarter
tsset datem
tsfill
ipolate ol15 datem, generate(x)
replace ol15 = x if ol15==.
rename ol15 mtg_out_FF
keep datem mtg_out_FF
save data/outstanding_FoF.dta, replace
*/

merge 1:1 datem using data/hpsd_real.tmp, nogen keep(1 3)
/*
freduse CPIAUCSL, clear
g month = mofd(daten)
format month %tm
rename CPI cpi
keep cpi month
save cpi_monthly.dta, replace

use "SMcl.dta", replace // same proprietary state-level CoreLogic HPI file as in Fig. 7
cap rename cl cl_SM
keep cl_SM state month
merge m:1 month using cpi_monthly.dta
replace cl_SM=cl_SM/cpi
replace cl_SM=log(cl_SM)
rename cl_SM loghp
keep loghp month state

gen date = dofm(month)
gen year=year(date)
drop date

rename state statename
merge m:1 state using data/statenametostate, nogen
merge m:1 state year using data/statepopulation_annual
keep if _merge==3
drop _merge

egen s=group(state)
tsset s month
gen hpgrowth=loghp-l12.loghp
replace hpgrowth=hpgrowth*100

collapse (mean) mean_hp=hpgrowth (sd) sd_hp=hpgrowth [aweight=pop], by(month)

use data/hp_sd_monthly.dta, clear 
rename month datem
renvars *hp, postfix(_real)
save data/hpsd_real.tmp, replace
*/

merge 1:1 datem using data/WAC_agencies_embs.dta, nogen keep(1 3) // see above
/* This is based on data from eMBS, available via RADAR:
import delimited embs062682_5921518293442.csv, clear // the full view_aggrhist_embs from RADAR
keep if aggrlvl ==3 // at the agency level (FHL, FNM, GNM)
keep if colltype =="LOAN"
g datem = mofd(date(substr(effdt,1,10),"YMD"))
format datem %tm
br datem avgwac  rpb if agency =="FHL" // 1994m5 and 1997m1 are misreported for FHL
encode agency, gen(agnr)
xtset agnr datem
foreach x in avgwac rpb {
replace `x'=. if (datem==m(1994m5) | datem==m(1997m1)) & agency =="FHL"
ipolate `x' datem , generate(aa) by(agnr)
replace `x'=aa if `x'==.
drop aa
}
collapse avgwac [aw=rpb], by(datem) // weighted average of market
save data/WAC_agencies_embs.dta, replace
*/

merge 1:1 datem using data/ramey.tmp, nogen keep(1 3) keepusing(ff4_tc)
/* import excel data/raw/Ramey_Monetarydat.xlsx, sheet("Monthly") firstrow clear // comes from http://econweb.ucsd.edu/~vramey/research/Ramey_HOM_monetary.zip
gen datem= m(1959m1) + _n-1
format datem %tm
order datem
renvars *, l
keep datem rr* *tc ff4_vr
save data/ramey.tmp, replace
*/


g year = year(dofm(datem))

tsset datem 

g refiprop = refi_HI_loanvol /10^9/l.mtg_out_FF * 100 // monthly refi propensity, in percent
label var refiprop "Monthly Refi Propensity vs. Oustanding (%)"


////////////////////////////////////////////////////////////////////
///// Analysis
////////////////////////////////////////////////////////////////////


program drop _all
program add_stats
	capture estadd scalar r2_a=r2_a
	qui sum mdy if e(sample)
	local min_max_mdy = year(r(min))*100 + month(r(min)) + ///
	  year(r(max))/10000 + month(r(max)) / 1000000

	estadd scalar  min_max_mdy = `min_max_mdy'
	cap estadd scalar  NWlags = `e(lag)'
	cap estadd scalar  NWlags = `e(bw)'

end
 
g inc_wac = avgwac - MORTG // refinance incentive on outstanding stock
label var inc_wac "Rate incentive vs Agency MBS WAC"

tsset datem

tssmooth ma ff4_cum = ff4_tc , window(11 1 0) // the 12-month past average
replace ff4_cum = 12 * ff4_cum
replace ff4_cum = . if ff4_tc==.
replace ff4_cum = . if datem<m(1991m1) // need to have at least 12 obs

// Table:
keep if datem <=m(2012m6)
g mdy=dofm(datem)

eststo clear

egen sd_hp_mean = mean(sd_hp_real) if datem>=m(1991m1)
gen sd_hp_norm = sd_hp_real - sd_hp_mean // demean for interaction

// incentive variable for table
g Xinc = -1*inc_wac

ivreg2 refiprop Xinc, bw(5) rob small // bw(5) rob small is the same as newey...lag(4); see https://www.stata.com/statalist/archive/2012-09/msg00439.html
add_stats
eststo

qui reg refiprop c.Xinc##c.l.mean_hp_real c.Xinc##c.sd_hp_norm  
scalar r2_a = `e(r2_a)'
ivreg2 refiprop c.Xinc##c.l.mean_hp_real c.Xinc##c.sd_hp_norm , bw(5) rob small
add_stats
eststo

// changes:
replace Xinc = s12.MORTG

ivreg2  s12.refiprop Xinc  , kernel(tru) bw(12)
add_stats
eststo

ivreg2   s12.refiprop c.Xinc##c.l.mean_hp_real c.Xinc##c.sd_hp_norm  , kernel(tru) bw(12)
add_stats
eststo
sum Xinc if e(sample)


// G-K shocks:
replace Xinc = ff4_cum
ivreg2   s12.refiprop Xinc  , kernel(tru) bw(12)
add_stats
eststo

ivreg2  s12.refiprop c.Xinc##c.l.mean_hp_real c.Xinc##c.sd_hp_norm  , kernel(tru) bw(12)
add_stats
eststo
sum Xinc if e(sample)

esttab , replace compress b(3) se(3) starl(* 0.1 ** 0.05 *** 0.01) stats(r2_a N min_max_mdy NWlags, fmt(2 0 6 0) ///
labels("Adj. R2" "Obs." "Dates" "Kernel BW"))   coeflabels(_cons Constant Xinc "Interest rate" ///
L.mean_hp_real "HPA" c.Xinc#cL.mean_hp_real "Int. Rate $\times$ HPA" sd_hp_norm "SD(HPA)" c.Xinc#c.sd_hp_norm "Int. Rate $\times$ SD(HPA)") 

