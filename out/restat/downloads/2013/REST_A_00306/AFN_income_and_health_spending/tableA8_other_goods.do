
clear
set more off
set mem 200m
est clear


**
* set-up
** 
local clusterVariable = "fipsStateCode"
local absorbVariable  = "stateEconArea"

local aha_var = "exptot"
local instrument = "sizeXlogoil"

global fs_stats = "effect_1sd_size effect_2sd_size"




drop _all
use aha_final_state.dta

keep if year >= 1970 & year <= 1990

xi i.year i.stateEconArea


gen log_hospital_episodes = log(hospital_episodes / population)
gen log_hospital_days = log(hospital_days / population)
gen log_doctor_visits = log(doctor_visits / population)

preserve
foreach var of varlist gdp_amuse_servs gdp_hotels gdp_legal_servs gdp_other_servs gdp_food gdp_health_servs {
 ivreg log_`var' (log_payroll = sizeXlogoil) _I* [aw=wgt], cluster(`clusterVariable') 
  est store `var'_usa_iv
 ivreg log_`var' (log_payroll = sizeXlogoil) _I* [aw=wgt] if south == 1, cluster(`clusterVariable') 
  est store `var'_sth_iv
}
restore



estout *_sth_iv ///
 using tableA8_sth.txt, ///
    stats(r2 N fstat, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")

est drop *_sth_iv

estout * ///
 using tableA8_us.txt, ///
    stats(r2 N fstat, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")
