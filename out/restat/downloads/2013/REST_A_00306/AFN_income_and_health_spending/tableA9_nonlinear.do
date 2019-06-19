

clear
set more off
set mem 200m
set matsize 8000 
est clear

capture program drop add_stat
program define add_stat, eclass
  ereturn scalar `1' = `2'
end

use aha_final_state.dta
xi i.year i.stateEconArea

**
* set-up
** 
local clusterVariable = "fipsStateCode"
local absorbVariable  = "stateEconArea"

local aha_var = "exptot"
local instrument = "sizeXlogoil"

global fs_stats = "effect_1sd_size effect_2sd_size"






use aha_final_esr.dta

keep if year >= 1970 & year <= 1990

xi i.year i.stateEconArea


**
* Baseline + nonlinear results
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
sort `absorbVariable' year
**by `absorbVariable': keep if _N == 21
by `absorbVariable': gen log_payroll_1970 = log_payroll[1] if year[1] == 1970 & log_payroll[1] < . 
drop if log_payroll_1970 == .

capture drop log_oil
gen log_oil = log(oilprice_prev)
foreach var of varlist log_payroll tot_size log_oil log_payroll_1970 {
 summ `var'
 replace `var' = `var' - r(mean)
}

capture drop log_payroll2
capture drop sizeXlogoil
capture drop sizeXlogoil2
gen log_payroll2 = log_payroll * log_payroll
gen sizeXlogoil = tot_size * log_oil
gen sizeXlogoil2 = (tot_size * tot_size) * log_oil

gen log_pXlog_p1970 = log_payroll * log_payroll_1970
gen sizeXlogoilXlog_p1970 = sizeXlogoil * log_payroll_1970


ivreg log_`aha_var' (log_payroll = sizeXlogoil ) _I* [aw=wgt], cluster(`clusterVariable')  
 add_stat "me_1sd_down" _b[log_payroll]
 add_stat "me_at_mean" _b[log_payroll]
 add_stat "me_1sd_up" _b[log_payroll]
 est store iv_baseline

ivreg log_`aha_var' (log_payroll log_pXlog_p1970 = sizeXlogoil sizeXlogoilXlog_p1970) _I* [aw=wgt], cluster(`clusterVariable')  
 summ log_payroll_1970
 local me_1sd_down = _b[log_payroll] - _b[log_pXlog_p1970] * r(sd) 
 local me_1sd_up = _b[log_payroll] + _b[log_pXlog_p1970] * r(sd) 
 add_stat "me_1sd_down" `me_1sd_down'
 add_stat "me_at_mean" _b[log_payroll]
 add_stat "me_1sd_up" `me_1sd_up'
 est store iv_1970inter
restore




preserve
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990

capture drop log_oil
gen log_oil = log(oilprice_prev)
foreach var of varlist log_payroll tot_size log_oil {
 summ `var'
 replace `var' = `var' - r(mean)
}

capture drop log_payroll2
capture drop sizeXlogoil
capture drop sizeXlogoil2
gen log_payroll2 = log_payroll * log_payroll
gen sizeXlogoil = tot_size * log_oil
gen sizeXlogoil2 = (tot_size * tot_size) * log_oil

areg log_`aha_var' sizeXlogoil _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')  
 add_stat "me_1sd_down" _b[`instrument']
 add_stat "me_at_mean" _b[`instrument']
 add_stat "me_1sd_up" _b[`instrument']
 est store rf_baseline

areg log_`aha_var' sizeXlogoil sizeXlogoil2 _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')  
 summ sizeXlogoil
 local me_1sd_down = _b[sizeXlogoil] - 2 * _b[sizeXlogoil2] * r(sd) 
 local me_1sd_up = _b[sizeXlogoil] + 2 * _b[sizeXlogoil2] * r(sd) 
 add_stat "me_1sd_down" `me_1sd_down'
 add_stat "me_at_mean" _b[`instrument']
 add_stat "me_1sd_up" `me_1sd_up'
 est store rf_nl

restore




estout * ///
 using tableA9_nonlinear.txt, ///
    stats(r2 N me_1sd_down me_at_mean me_1sd_up, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")

