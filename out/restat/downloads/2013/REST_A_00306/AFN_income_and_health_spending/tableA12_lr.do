
clear
clear mata
set more off
set matsize 8000
set mem 200m
est clear

use aha_final_esr.dta

keep if year >= 1970 & year <= 1990 & south == 1

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
* baseline RF, IV
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_z1s
areg log_`aha_var' `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 est store `aha_var'_rf_z1s
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_z1s
restore



**
* 10-year panel (take averages)
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1
replace year = 1970 if year == 1971
replace year = 1970 if year == 1972
replace year = 1980 if year == 1979
replace year = 1980 if year == 1981
replace year = 1990 if year == 1988
replace year = 1990 if year == 1989
keep if ///
 year == 1970 | year == 1980 | year == 1990
collapse (mean) wgt tot_size oilprice_prev payroll population exptot , by(`clusterVariable' stateEconArea year)
gen sizeXlogoil = tot_size * log(oilprice_prev)
gen log_payroll = log(payroll / population)
gen log_exptot = log(exptot / population)
xi i.year i.stateEconArea
reg log_payroll sizeXlogoil _I* [aw=wgt], cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
est store `aha_var'_fs_fe10_r
reg log_`aha_var' sizeXlogoil _I* [aw=wgt], cluster(`clusterVariable')
est store `aha_var'_rf_fe10_r
ivreg log_`aha_var' (log_payroll = sizeXlogoil) _I* [aw=wgt], cluster(`clusterVariable')
est store `aha_var'_iv_fe10_r
restore



**
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990

drop log_payroll `instrument' log_`aha_var'
rename log_payroll3 log_payroll
rename `instrument'3 `instrument'
rename log_`aha_var'3 log_`aha_var'

 ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt] if use3 == 1, cluster(`clusterVariable') 
 est store iv3

restore





estout * ///
 using tableA12_lr.txt, ///
    stats(r2 N fstat, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")

