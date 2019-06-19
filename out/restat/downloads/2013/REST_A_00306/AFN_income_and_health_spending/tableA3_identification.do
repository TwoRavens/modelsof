
clear
set more off
set mem 200m

est clear




use aha_final_esr.dta

keep if south == 1
keep if year >= 1969 & year <= 1990

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
* Baseline
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store fs_baseline
**areg log_`aha_var' `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
** est store `aha_var'_rf_z1s
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store iv_baseline
restore


preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
areg log_payroll sizeXlogoil sizeXlogoil_post5 _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_tp5_r
** areg log_`aha_var' sizeXlogoil sizeXlogoil_post5 _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
** est store `aha_var'_rf_tp5_r
ivreg log_`aha_var' (log_payroll = `instrument') sizeXlogoil_post5 _I* [aw=wgt], cluster(`clusterVariable') 
 est store `aha_var'_iv_tp5_r
restore



**
* Horse race
**
preserve
keep if year >= 1969
sort `absorbVariable' year

** NOTE: divided by HUWP in 1970
by `absorbVariable': gen log_exptot_1969 = log(exptot[1] / population[2])
by `absorbVariable': gen log_bdtot_1969 = log(bdtot[1] / population[2])
by `absorbVariable': gen log_pop_1970 = log_population[2]
by `absorbVariable': gen log_payroll_1970 = log_payroll[2]
by `absorbVariable': gen log_emp_1970 = log_num_employees[2]

sort `absorbVariable' year
by `absorbVariable': keep if year[1] == 1969
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990 & log_exptot_1969 < .

foreach var of varlist log_exptot_1969 log_bdtot_1969 log_pop_1970 log_payroll_1970 log_emp_1970 manufShare1970 {
 capture drop `var'Xlogoil
 summ `var'
 replace `var' = `var' - r(mean)
 gen `var'Xlogoil = `var' * log(oilprice_prev)

 areg log_payroll `instrument' `var'Xlogoil _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
  test `instrument'
  do add_fs_params `instrument'
  est store fs_ihrace_`var'
** areg log_`aha_var' `instrument' `var'Xlogoil _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
**  est store rf_hrace_`var'
 ivreg log_`aha_var' (log_payroll = `instrument') `var'Xlogoil _I* [aw=wgt], cluster(`clusterVariable')
  est store iv_ihrace_`var'
}


areg log_payroll `instrument' *1969Xlogoil manufShare1970Xlogoil _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
  test `instrument'
  do add_fs_params `instrument'
 est store fs_hrace_some
ivreg log_`aha_var' (log_payroll = `instrument') *1969Xlogoil manufShare1970Xlogoil _I* [aw=wgt], cluster(`clusterVariable')
 est store iv_hrace_some

areg log_payroll `instrument' *1969Xlogoil log_pop_1970Xlogoil manufShare1970Xlogoil _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
  test `instrument'
  do add_fs_params `instrument'
 est store fs_hrace_some2
ivreg log_`aha_var' (log_payroll = `instrument') *1969Xlogoil log_pop_1970Xlogoil manufShare1970Xlogoil _I* [aw=wgt], cluster(`clusterVariable')
 est store iv_hrace_some2

areg log_payroll `instrument' *1969Xlogoil log_pop_1970Xlogoil log_emp_1970Xlogoil manufShare1970Xlogoil _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
  test `instrument'
  do add_fs_params `instrument'
 est store fs_hrace_some3
ivreg log_`aha_var' (log_payroll = `instrument') *1969Xlogoil log_pop_1970Xlogoil log_emp_1970Xlogoil manufShare1970Xlogoil _I* [aw=wgt], cluster(`clusterVariable')
 est store iv_hrace_some3

areg log_payroll `instrument' *1969Xlogoil *1970Xlogoil _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
  test `instrument'
  do add_fs_params `instrument'
 est store fs_hrace_all
ivreg log_`aha_var' (log_payroll = `instrument') *1969Xlogoil *1970Xlogoil _I* [aw=wgt], cluster(`clusterVariable')
 est store iv_hrace_all

drop manufShare1970Xlogoil
areg log_payroll `instrument' *1969Xlogoil *1970Xlogoil _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
  test `instrument'
  do add_fs_params `instrument'
 est store fs_main_hrace
ivreg log_`aha_var' (log_payroll = `instrument') *1969Xlogoil *1970Xlogoil _I* [aw=wgt], cluster(`clusterVariable')
 est store iv_main_hrace

restore



**
* Region-specific trends
**
preserve
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
xi i.year i.stateEconArea i.region*t
reg log_payroll sizeXlogoil _I* [aw=wgt], cluster(`clusterVariable')
  test `instrument'
  do add_fs_params `instrument'
est store fs_region_trend_r
ivreg log_`aha_var' (log_payroll = sizeXlogoil) _I* [aw=wgt], cluster(`clusterVariable')
est store iv_region_strend_r
restore

**
* State-specific trends
**
preserve
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
xi i.year i.stateEconArea i.fipsStateCode*t
reg log_payroll sizeXlogoil _I* [aw=wgt], cluster(`clusterVariable')
  test `instrument'
  do add_fs_params `instrument'
est store fs_st_trend_r
ivreg log_`aha_var' (log_payroll = sizeXlogoil) _I* [aw=wgt], cluster(`clusterVariable')
est store iv_st_strend_r
restore

preserve
keep if log_payroll < . & log_exptot < . & year >= 1970 & year <= 1984 & south == 1
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
  test `instrument'
  do add_fs_params `instrument'
 est store `aha_var'_fs_esr_7084
restore

preserve
keep if log_payroll < . & log_exptot < . & year >= 1970 & year <= 1984 & south == 1
areg log_`aha_var' `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 est store `aha_var'_rf_esr_7084
restore

preserve
drop _all
use ./dta/aha_falsification_esr.dta
xi i.year i.stateEconArea
reg log_exptot sizeXlogoil _I*, cluster(fipsStateCode)
est store falsification
restore


/**
 **
 estout fs_baseline fs_ihrace* fs*_hrace_* ///
 using table_fs_hrace.txt , ///
    stats(r2 N fstat $fs_stats, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")

estout iv_baseline iv_ihrace* iv*_hrace_* ///
 using table_iv_hrace.txt , ///
    stats(r2 N fstat $fs_stats, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")
 **
 **/

est drop fs_*hrace_*
est drop iv_*hrace_*


estout *fs_* ///
 using tableA3_fs.txt , ///
    stats(r2 N , fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I* *1969X* *1970X*) title("`title_str'")

est drop *fs_*

estout * ///
 using tableA3_iv.txt , ///
    stats(r2 N fstat, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I* *1969X* *1970X*) title("`title_str'")

