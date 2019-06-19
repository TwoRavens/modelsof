
clear 
set more off
set mem 200m

capture program drop add_param
program define add_param, eclass
 ereturn scalar `1' = `2'
end


clear
drop _all
use aha_final_state.dta



keep if year >= 1970  & year <= 1990 & log_exptot < . & log_payroll < .

**
* Merge in HCFA data
**
sort  fipsStateCode year
capture drop _merge
merge fipsStateCode year using ./dta/hcfa_all, uniqusing uniqmaster
tab year _merge, missing
tab fipsStateCode _merge, missing

** keep if _merge == 3 but note that we lose a few DC and one other state-year obs
drop if _merge == 2

desc, full

replace hcfa_Total = population * percapitapersonalhealthcareexpen / 1e6 if year == 1979

replace exptot = exptot / 1e6
bys year: summ exptot hcfa_HospitalCare hcfa_Total

gen log_exptot_onlynf = log(exptot_onlynf / population)

foreach var of varlist hcfa_* {
 gen log_`var' = log(`var' * 1e6 / population)
}


**
* How does avg aha hosp expend at state level for those years compare 
*  to avg hcfa hosp expend at state level for those years?
**
summ hcfa_HospitalCare exptot ///
 if hcfa_HospitalCare < . & south == 1  & year >= 1970 & year <= 1990

summ hcfa_* ///
 if hcfa_HospitalCare < . & south == 1  & year >= 1970 & year <= 1990



est clear

foreach geo in "sth" "usa" {

preserve

capture drop *Prescription*

if ("`geo'" == "sth") {
 keep if south == 1
}
xi i.year i.fipsStateCode

areg log_payroll sizeXlogoil _Iy* [aw=wgt] if log_hcfa_HospitalCare < ., absorb(fipsStateCode) cluster(fipsStateCode)
test sizeXlogoil
add_param Fstat r(F)
est store fs_yrs_`geo'

ivreg log_hcfa_Total  (log_payroll = sizeXlogoil) _I* [aw=wgt] if log_hcfa_HospitalCare < ., cluster(fipsStateCode)
est store hcfa_total2_`geo'

rename hcfa_Total hcfaTotal

foreach var of varlist hcfa_* {
 di "var = `var' ..."
 qui ivreg log_`var' (log_payroll = sizeXlogoil) _I* [aw=wgt], cluster(fipsStateCode)
 gen `var'_share = `var' / hcfaTotal
 summ `var'_share
 add_param "share" r(mean)
 est store `var'_`geo'
}


ivreg log_exptot   (log_payroll = sizeXlogoil) _I* [aw=wgt] if log_hcfa_HospitalCare < ., cluster(fipsStateCode)
est store exptot_yrs2_`geo'

**ivreg log_exptot_onlynf   (log_payroll = sizeXlogoil) _I* [aw=wgt] if log_hcfa_HospitalCare < ., cluster(fipsStateCode)
**est store hcfa_yrs_nf_`geo'

restore

** end FOR south/us
}

estout *sth ///
 using tableA6_hcfa_sth.txt, ///
    stats(r2 N Fstat share, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")

estout *usa ///
 using tableA6_hcfa_usa.txt, ///
    stats(r2 N Fstat share, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")

exit

