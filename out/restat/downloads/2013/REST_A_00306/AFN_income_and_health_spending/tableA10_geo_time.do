
clear
set more off
set mem 200m
set matsize 2000
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

global fs_stats = "effect_1sd_size effect_2sd_size"





**
* generate oil state and oil state X south
** 
capture drop oil_state
gen oil_state = 0
replace oil_state = 1 if tot_size_state > 0 & tot_size_state < .

capture drop oilXsouth
gen oilXsouth = oil_state * south





**
* baseline
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_z1s
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_z1s
restore



**
* oilXsouth
**
preserve 
keep if log_payroll < . & log_exptot < . & oilXsouth == 1 & year >= 1970 & year <= 1990
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_oilXsouth_r
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_oilXsouth_r
restore

**
* all U.S.
**
preserve 
keep if log_payroll < . & log_exptot < . & year >= 1970 & year <= 1990
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_7090us_r
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_7090us_r
restore





**
* all years (1970-2005)
**
preserve 

keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970

areg log_payroll `instrument' _Iy* [aw=wgt] $if_opts ,  cluster(`clusterVariable')  absorb(`absorbVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_7005_r
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_7005_r

xi i.year i.stateEconArea i.fipsStateCode*t
reg log_payroll `instrument' _I* [aw=wgt] $if_opts ,  cluster(`clusterVariable') 
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_7005_stXt_r
ivreg log_`aha_var' (log_payroll = sizeXlogoil) _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_7005_stXt_r

restore





estout *_fs_* ///
 using tableA10_fs.txt, ///
    stats(r2 N fstat, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")

estout *_iv_* ///
 using tableA10_iv.txt, ///
    stats(r2 N , fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")

