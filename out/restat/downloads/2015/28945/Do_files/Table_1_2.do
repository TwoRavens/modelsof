*-----------------------------------------------------------------------------------------------------------------------------*
* This do-file generates Tables 1 and 2 of Berman and Couttenier (2014) 													  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
*
cd "$Results"
*
log using Table_1_2.log, replace

						*--------------------------------------------*
						*--------------------------------------------*
						*  TABLE 1 - DESCRIPTIVE STATISTICS SAMPLES  *    
						*--------------------------------------------*
						*--------------------------------------------*
*
/* count how many countries, years, grid cells and events */
foreach c in c3 c1 c2{
use "$Output_data\data_BC_Restat2014", clear
keep if conflict_`c' != .
di "time period"
tab year
di "number of countries"
distinct iso3 
di "number of cells"
distinct gid
di "number of events"
egen sum_`c'=sum(nbconflict_`c')
di sum_`c'
}
*
						*--------------------------------------------*
						*--------------------------------------------*
						* TABLE 2 - DETAILED DESCRIPTIVE STATISTICS *    
						*--------------------------------------------*
						*--------------------------------------------*
						
/* produce table of descriptive stats for all three samples */
foreach c in c3 c1 c2{
	foreach var in conflict_`c' nbconflict_`c' nbconflict_pos_`c' distance_cp bdist1 capdist distance_res distance_cp_r bdist1_r capdist_r distance_res_r lshock_fao exposure_crisis{
	use "$Output_data\data_BC_Restat2014", clear
	keep if conflict_`c' != .
	g nbconflict_pos_`c' = nbconflict_`c' if nbconflict_`c' > 0
	collapse (count) N = `var' (mean) mean = `var' (median) median = `var' (sd) sd = `var' (p25) p25 = `var' (p75) p75 = `var'
	g name = "`var'" 
	save "$Results\stats_`c'_`var'", replace
	}
}
use "$Results\stats_c1_conflict_c1", clear
foreach c in c3 c1 c2{
	foreach var in conflict_`c' nbconflict_`c' nbconflict_pos_`c' distance_cp bdist1 capdist distance_res distance_cp_r bdist1_r capdist_r distance_res_r lshock_fao exposure_crisis{
	append using "$Results\stats_`c'_`var'"
	}
}
*
drop  if _n == 1
order name N mean sd p25 median p75
save "$Results/Table2", replace
*
/* clean folder */
foreach c in c3 c1 c2{
	foreach var in conflict_`c' nbconflict_`c' nbconflict_pos_`c' distance_cp bdist1 capdist distance_res distance_cp_r bdist1_r capdist_r distance_res_r lshock_fao exposure_crisis{
	erase "$Results\stats_`c'_`var'.dta"
	}
}

log close
