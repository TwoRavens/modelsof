/*
*************
********

est_perm.do
First version: August 2, 2016
Last Updated: August 3, 2016
By: Brenton Peterson

Summary: Estimates models for permutation inference

********
*************
*/



*Change working directory
cd "\MSFlood\MSFloodRep_Nov2016"


*Load + prep
set more off
set matsize 10000
set scheme s1mono
use "perm_data.dta", clear


*Prep permutation IDs
replace perm_id_main = . if year != 1928
replace perm_id5 = . if year != 1928
replace perm_id6 = . if year != 1928


*Variables to hold synth results
foreach i of numlist 1/6{
	gen placebo`i'_1928 = .
	gen placebo_synth`i'_1928 = .
}


	
*Synthetic control model #1
	*Donor pool trimming by pre-treatment vote share

sort perm_id_main
local v "1"
forvalues i = 1/2298{
	timer on 1
	display `i'
	sort perm_id_main
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = p_counits1[`i']

	local synth_x = "synth r_2party black_1920(1924) prot1(1924) r_2party(1896) r_2party(1900) r_2party(1904) r_2party(1908) r_2party(1912) r_2party(1916) r_2party(1920) r_2party(1924), trunit(`trunit_x') trperiod(1928) counit(`counit_x') mspeperiod(1896(4)1924) resultsperiod(1896(4)1936)"
	
	sort county_id year
	tsset county_id year
	`synth_x'
	
	*Extract results	
	matrix b = e(RMSPE)
	matrix c = e(V_matrix)
	matrix d = e(X_balance)
	matrix e = e(W_weights)
	matrix f = e(Y_synthetic)
	matrix g = e(Y_treated)
	
	sort perm_id_main
	replace placebo`v'_1928 = f[9,1] in `i'
	replace placebo_synth`v'_1928 = g[9,1] in `i'


	clear programs
	ereturn clear	
	timer off 1
	timer list 1
	timer clear 1
}



*Synthetic control model #2
	*Donor pool trimming by pct. black and pct. protestant

sort perm_id_main
local v "2"
forvalues i = 1/2298{
	timer on 1
	display `i'
	sort perm_id_main
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = p_counits2[`i']

	local synth_x = "synth r_2party black_1920(1924) prot1(1924) r_2party(1896) r_2party(1900) r_2party(1904) r_2party(1908) r_2party(1912) r_2party(1916) r_2party(1920) r_2party(1924), trunit(`trunit_x') trperiod(1928) counit(`counit_x') mspeperiod(1896(4)1924) resultsperiod(1896(4)1936)"
	
	sort county_id year
	tsset county_id year
	`synth_x'
	
	*Extract results	
	matrix b = e(RMSPE)
	matrix c = e(V_matrix)
	matrix d = e(X_balance)
	matrix e = e(W_weights)
	matrix f = e(Y_synthetic)
	matrix g = e(Y_treated)
	
	sort perm_id_main
	replace placebo`v'_1928 = f[9,1] in `i'
	replace placebo_synth`v'_1928 = g[9,1] in `i'


	clear programs
	ereturn clear	
	timer off 1
	timer list 1
	timer clear 1
}




*Synthetic control model #3
	*Donor pool trimming by pre-treatment vote share
	*500 donor pool units

sort perm_id_main
local v "3"
forvalues i = 1/2298{
	timer on 1
	display `i'
	sort perm_id_main
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = p_counits3[`i']

	local synth_x = "synth r_2party black_1920(1924) prot1(1924) r_2party(1896) r_2party(1900) r_2party(1904) r_2party(1908) r_2party(1912) r_2party(1916) r_2party(1920) r_2party(1924), trunit(`trunit_x') trperiod(1928) counit(`counit_x') mspeperiod(1896(4)1924) resultsperiod(1896(4)1936)"
	
	sort county_id year
	tsset county_id year
	`synth_x'
	
	*Extract results	
	matrix b = e(RMSPE)
	matrix c = e(V_matrix)
	matrix d = e(X_balance)
	matrix e = e(W_weights)
	matrix f = e(Y_synthetic)
	matrix g = e(Y_treated)
	
	sort perm_id_main
	replace placebo`v'_1928 = f[9,1] in `i'
	replace placebo_synth`v'_1928 = g[9,1] in `i'


	clear programs
	ereturn clear	
	timer off 1
	timer list 1
	timer clear 1
}




*Synthetic control model #4
	*Donor pool trimming by pct. black and pct. protestant
	*500 donor pool units

sort perm_id_main
local v "4"
forvalues i = 1/2298{
	timer on 1
	display `i'
	sort perm_id_main
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = p_counits4[`i']

	local synth_x = "synth r_2party black_1920(1924) prot1(1924) r_2party(1896) r_2party(1900) r_2party(1904) r_2party(1908) r_2party(1912) r_2party(1916) r_2party(1920) r_2party(1924), trunit(`trunit_x') trperiod(1928) counit(`counit_x') mspeperiod(1896(4)1924) resultsperiod(1896(4)1936)"
	
	sort county_id year
	tsset county_id year
	`synth_x'
	
	*Extract results	
	matrix b = e(RMSPE)
	matrix c = e(V_matrix)
	matrix d = e(X_balance)
	matrix e = e(W_weights)
	matrix f = e(Y_synthetic)
	matrix g = e(Y_treated)
	
	sort perm_id_main
	replace placebo`v'_1928 = f[9,1] in `i'
	replace placebo_synth`v'_1928 = g[9,1] in `i'


	clear programs
	ereturn clear	
	timer off 1
	timer list 1
	timer clear 1
}




*Synthetic control model #5
	*Donor pool = contiguous counties in same region (N/S)

sort perm_id5
local v "5"
forvalues i = 1/133{
	timer on 1
	display `i'
	sort perm_id5
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = p_counits5[`i']

	local synth_x = "synth r_2party black_1920(1924) prot1(1924) r_2party(1896) r_2party(1900) r_2party(1904) r_2party(1908) r_2party(1912) r_2party(1916) r_2party(1920) r_2party(1924), trunit(`trunit_x') trperiod(1928) counit(`counit_x') mspeperiod(1896(4)1924) resultsperiod(1896(4)1936)"
	
	sort county_id year
	tsset county_id year
	`synth_x'
	
	*Extract results	
	matrix b = e(RMSPE)
	matrix c = e(V_matrix)
	matrix d = e(X_balance)
	matrix e = e(W_weights)
	matrix f = e(Y_synthetic)
	matrix g = e(Y_treated)
	
	sort perm_id5
	replace placebo`v'_1928 = f[9,1] in `i'
	replace placebo_synth`v'_1928 = g[9,1] in `i'


	clear programs
	ereturn clear	
	timer off 1
	timer list 1
	timer clear 1
}




*Synthetic control model #6
	*Donor pool = non-treated, non-contiguous counties in flooded states in same region (N/S)

sort perm_id6
local v "6"
forvalues i = 1/380{
	timer on 1
	display `i'
	sort perm_id6
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = p_counits6[`i']

	local synth_x = "synth r_2party black_1920(1924) prot1(1924) r_2party(1896) r_2party(1900) r_2party(1904) r_2party(1908) r_2party(1912) r_2party(1916) r_2party(1920) r_2party(1924), trunit(`trunit_x') trperiod(1928) counit(`counit_x') mspeperiod(1896(4)1924) resultsperiod(1896(4)1936)"
	
	sort county_id year
	tsset county_id year
	`synth_x'
	
	*Extract results	
	matrix b = e(RMSPE)
	matrix c = e(V_matrix)
	matrix d = e(X_balance)
	matrix e = e(W_weights)
	matrix f = e(Y_synthetic)
	matrix g = e(Y_treated)
	
	sort perm_id6
	replace placebo`v'_1928 = f[9,1] in `i'
	replace placebo_synth`v'_1928 = g[9,1] in `i'


	clear programs
	ereturn clear	
	timer off 1
	timer list 1
	timer clear 1
}





*Calculate placebo-treatment effect estimates
foreach i of numlist 1/6{
	gen diff`i' = placebo`i'_1928 - placebo_synth`i'_1928
}


*Save data
save "res_perm.dta", replace







