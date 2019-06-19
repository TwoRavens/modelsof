
clear
set more off
set mem 200m

est clear

use aha_final_esr.dta

keep if south == 1
xi i.year i.stateEconArea


**
* set-up
** 
local clusterVariable = "fipsStateCode"
local absorbVariable  = "stateEconArea"

local aha_var = "exptot"

local instrument = "sizeXlogoil"

global fs_stats = "effect_1sd_size effect_2sd_size"



**
* baseline
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
reg log_`aha_var' log_payroll _I* [aw=wgt], cluster(`clusterVariable')
 est store `aha_var'_ols_esr

reg log_`aha_var' log_payroll _Iy* [aw=wgt], cluster(`clusterVariable')
 est store `aha_var'_ols_esr_noFE

areg log_`aha_var' `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 est store `aha_var'_rf_z1s
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_z1s
restore



**
* unadjusted LHS/RHS
**
preserve
keep if year >= 1970 & year <= 1990 & log_payroll < . & log_`aha_var' < . & south == 1
drop log_payroll
gen log_payroll = log(payroll)
drop log_exptot
gen log_exptot = log(exptot)
ivreg log_exptot (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
est store exptot_iv_unadj_r
restore



**
* per-cap LHS/RHS
**
preserve 
keep if year >= 1970 & year <= 1990 & log_payroll < . & log_`aha_var' < . & south == 1
replace log_payroll = log(payroll / pop_unweighted)
replace log_`aha_var' = log(`aha_var' / pop_unweighted)
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_percap_r
restore




drop _all
use aha_final_state.dta
xi i.year i.stateEconArea

**
* CBP, South, State-level
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990

*reg log_`aha_var' log_payroll _I* [aw=wgt], cluster(`clusterVariable')
* est store `aha_var'_ols_state

ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_state
restore





estout * ///
 using table4_main_results.txt, ///
    stats(r2 N fstat $fs_stats, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")
