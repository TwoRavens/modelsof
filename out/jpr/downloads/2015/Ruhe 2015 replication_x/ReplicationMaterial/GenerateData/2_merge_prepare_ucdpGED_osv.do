clear
set more off
cd "`w_dir'"

*save government osv in separate file
local sysdate = c(current_date)
use "ucdpGED_dyadmonth_osv_`sysdate'.dta"
drop if side_b_id==1391

keep dyad_unique month conflict_id dyad_id side_a_id /*
*/ side_b_id isonumber isonumbermin distance_min /*
*/ distance_mean civilian_deaths unknown best_est /*
*/ high_est low_est fatal_events civilian_deaths_split /*
*/ unknown_split best_est_split high_est_split low_est_split

foreach var of varlist distance_min-low_est_split {
rename `var' c_`var'a
}

keep if side_a_id < 1000
sort month
sort side_a_id, stable
save "ucdpGED_dyadmonth_osv_`sysdate'_a.dta", replace


*save rebel osv in separate file
clear
use "ucdpGED_dyadmonth_osv_`sysdate'.dta"
drop if side_b_id==1391

keep dyad_unique month conflict_id dyad_id side_a_id /*
*/ side_b_id isonumber isonumbermin distance_min /*
*/ distance_mean civilian_deaths unknown best_est /*
*/ high_est low_est fatal_events civilian_deaths_split /*
*/ unknown_split best_est_split high_est_split low_est_split

foreach var of varlist distance_min-low_est_split {
rename `var' c_`var'b
}

keep if side_a_id > 1000

*prepare to merge with complete data in which side b=rebels
drop side_b_id
rename side_a_id side_b_id
sort month
sort side_b_id, stable
save "ucdpGED_dyadmonth_osv_`sysdate'_b.dta", replace

