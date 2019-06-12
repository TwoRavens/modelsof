/* PrepChettyJAMA.do */
* This preps geographic health variables from the Chetty et al. (2016) JAMA article here: https://healthinequality.org/

/* Get county data */
insheet using $Externals/Data/ChettyJAMA/health_ineq_online_table_11.csv, comma names clear

gen LifeExpectancy =  (le_agg_q1_f * count_q1_f ///
					+le_agg_q2_f * count_q2_f ///
					+le_agg_q3_f * count_q3_f ///
					+le_agg_q4_f * count_q4_f ///
					+le_agg_q1_m * count_q1_m ///
 					+le_agg_q2_m * count_q2_m ///
					+le_agg_q3_m * count_q3_m ///
					+le_agg_q4_m * count_q4_m ) / /// 
					( count_q1_f+count_q2_f+count_q3_f+count_q4_f + ///
					  count_q1_m+count_q2_m+count_q3_m+count_q4_m)
keep cty LifeExpectancy	
rename cty state_countyFIPS	  
saveold $Externals/Calculations/ChettyJAMA/Ct.dta, replace

/*
insheet using $Externals/Data/ChettyJAMA/health_ineq_online_table_12.csv, comma names clear
foreach var in cur_smoke bmi_obese exercise_any {
	egen `var' = rowmean(`var'_q?)
}
keep cty cur_smoke bmi_obese exercise_any

rename cty state_countyFIPS
merge 1:1 state_countyFIPS using Calculations/ChettyJAMA/Ct.dta, keep(match master using) nogen

saveold $Externals/Calculations/ChettyJAMA/Ct.dta, replace
