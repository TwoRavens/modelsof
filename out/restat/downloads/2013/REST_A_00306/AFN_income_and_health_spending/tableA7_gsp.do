
clear
set more off
set mem 200m
set matsize 8000 
est clear


**
* set-up
** 
local clusterVariable = "fipsStateCode"
local absorbVariable  = "stateEconArea"

local aha_var = "exptot"
local instrument = "sizeXlogoil"

global fs_stats = "effect_1sd_size effect_2sd_size"





use aha_final_state.dta
keep if year >= 1970 & year <= 1990

xi i.year i.stateEconArea



**
* Merge in GSP data
**
sort  fipsStateCode year
capture drop _merge
merge fipsStateCode year using ./dta/state_GSP, uniqusing uniqmaster
list fipsStateCode year if _merge != 3
keep if _merge == 3



**
* CBP, South, State-level
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_st_z1s
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_st_z1s
restore


**
* GSP south
**
preserve 

replace log_payroll = log(gsp / population)

keep if year >= 1970 & year <= 1990 & log_payroll < . & log_`aha_var' < . & south == 1

areg log_payroll `instrument' _Iy* [aw=wgt],  cluster(`clusterVariable') absorb(`absorbVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_gsps
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_gsps
restore

**
* CBP, All US, State-level
**
preserve 
keep if log_payroll < . & log_exptot < . & year >= 1970 & year <= 1990
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_st_us
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_st_us
restore

**
* GSP, USA
**
preserve 

replace log_payroll = log(gsp / population)

keep if year >= 1970 & year <= 1990 & log_payroll < . & log_`aha_var' < .

areg log_payroll `instrument' _Iy* [aw=wgt],  cluster(`clusterVariable') absorb(`absorbVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_gspus
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_gspus
restore



estout *_fs_* ///
 using tableA7_alt_income_fs.txt, ///
    stats(r2 N fstat, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")

estout *_iv_* ///
 using tableA7_alt_income_iv.txt, ///
    stats(r2 N , fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")


