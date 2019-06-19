
clear
set more off
set mem 200m

est clear

**use aha_final_esr_backup.dta
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



** payroll X% of expenditures
preserve
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
egen sum_paytot = sum(paytot)
egen sum_exptot = sum(exptot)
summ sum_paytot sum_exptot
restore

** frac years for frac_ern
bys year: summ log_frac_ern



**
* baseline result for frac_ern years
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990 & log_frac_ern < .
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
restore


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

capture drop log_tech_max
capture drop log_exp_tech_max
capture drop log_exp_tech_max_adj

gen log_tech_max = log(tech_max)
gen log_tech_max_adj = log(tech_max / (population / 1e6) )
gen log_exp_tech_max = tech_max 
gen log_exp_tech_max_adj = tech_max / (population / 1e6)

** num hosp should not be adjusted
replace log_num_hosp = log(num_hosp)

local aha_vars = " paytot fte frac_ern admtot ipdtot bdtot num_hosp tech_max"

foreach var of local aha_vars {

**
* AHA variables
**
preserve 
keep if log_payroll < . & log_`var' < . & south == 1 & year >= 1970 & year <= 1990
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `var'_fs_r
ivreg log_`var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store `var'_iv_r
restore

** END for each
}


estout *_iv_* ///
 using table5_alt_depvars.txt, ///
    stats(r2 N fstat $fs_stats, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")
