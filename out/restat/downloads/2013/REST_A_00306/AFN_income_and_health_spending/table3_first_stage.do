
clear
set more off
set mem 200m

est clear

use aha_final_esr.dta
xi i.year i.stateEconArea


**
* set-up
** 
local clusterVariable = "fipsStateCode"
local absorbVariable  = "stateEconArea"

local aha_var = "exptot"
local instrument = "sizeXlogoil"

global fs_stats = "effect_1sd_size effect_90_10 effect_95_5"



**keep log_payroll_percap log_payroll log_payroll_raw payroll south year stateEconArea sizeXlogoil




**
* unadjusted
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
drop log_payroll
gen log_payroll = log(payroll)
drop log_`aha_var'
rename log_`aha_var'_raw log_`aha_var' 
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_unadj_r
restore



local vars = "num_employees pop_unweighted"
foreach var of local vars {

preserve
keep if log_payroll < . & log_`var'_raw < . & south == 1 & year >= 1970 & year <= 1990
areg log_`var'_raw `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `var'_fs_r
restore  

}




**
* per capita ...
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
drop log_payroll
rename log_payroll_percap log_payroll
drop log_`aha_var'
rename log_`aha_var'_percap log_`aha_var' 
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_percap_r
restore



local vars = "p_u55 p_55plus"
foreach var of local vars {

preserve
keep if log_payroll < . & log_`var'_raw < . & south == 1 & year >= 1970 & year <= 1990
areg log_`var'_raw `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `var'_fs_r
restore  

}



/**
 **
**
* Wage Bill per employee
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
drop log_payroll
gen log_payroll = log(payroll / num_employees)
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_peremp_r
restore
 **
 **/



**
* baseline
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_z1s
restore


drop _all
use aha_final_state.dta
xi i.year i.stateEconArea

**
* CBP, South, State-level
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_st_z1s
restore


estout * ///
 using table3_first_stage.txt, ///
    stats(r2 N fstat $fs_stats, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")



