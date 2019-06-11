*Milwaukee - Table 4
use "../Data/Full_Spatial_Data_Estimation.dta", replace

*Full Geographic Ignorability - Assumption 1
reg turnout08 treat, cluster(block) ro

*Conditional Geographic Ignorability - Assumption 2
xi: reg turnout08 treat male age age_sq minority_pct black18_pct income house_value_median ///
owner_pct hs_pct college_pct pres_dem_voteshare04 ush_dem_voteshare04 gov_dem_voteshare06 ///
uss_dem_voteshare06 i.assembly i.senate i.congress, cluster(block) ro


use "./Buffer_Spatial_Data_Clean.dta", replace


reg turnout08 treat if buffer1000==1, cluster(block) ro

reg turnout08 treat if buffer500==1, cluster(block) ro

reg turnout08 treat if buffer200==1, cluster(block) ro

reg turnout08 treat if buffer100==1, cluster(block) ro

reg turnout08 treat if buffer50==1, cluster(block) ro

*Table 5
use "./turn-map.dta", replace
gen est=turn08_hcctest*100
		
*Average Estimate and Q-value
sum est 
sum est_qval 

*Table 7 Column 1
*Average Estimate and Q-value Conditional On Housing Placebo
sum est if hse_qval_ind==1 & hse_est_abs<=5000
sum est_qval if hse_qval_ind==1 & hse_est_abs<=5000

*Table 7 Column 2
use "./Full_Spatial_Data_Estimation.dta", replace

*Conditional RD Design Estimates
drop if buffer_band==0
set more off

gen dist_city_sq = dist_to_city^2
gen dist_city_cb = dist_to_city^3

xi: reg turnout08 treat dist_to_city dist_city_sq dist_city_cb ///
male age age_sq minority_pct black18_pct income house_value_median ///
owner_pct hs_pct college_pct pres_dem_voteshare04 ush_dem_voteshare04 gov_dem_voteshare06 ///
uss_dem_voteshare06 i.assembly i.senate i.congress if buffer_band<=500, cluster(block) ro

