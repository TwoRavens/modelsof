/*
*************
********

est_placebo.do
First version: August 3, 2016
Last Updated: November 6, 2016
By: Brenton Peterson

Summary: Performs placebo test using 1924 elections results

********
*************
*/



*Change working directory
cd "\MSFlood\MSFloodRep_Nov2016"


*Load + prep
set more off
set matsize 10000
set scheme s1mono
do "reg_extract.ado"
use "placebo_data.dta", clear



*Pre-Treatment Trends

keep if south == 1
collapse (mean) r_2party, by(treat year)

twoway line r_2party year if treat == 1 || line r_2party year if treat == 0, xline(1928, lwidth(vthin)) lpattern(dash) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") xtitle("") ylabel(10 "10%" 20 "20%" 30 "30%" 40 "40%", ang(horizontal)) ytitle("Republican Vote Share") legend(order(1 "Treated Counties" 2 "Control Counties") region(lwidth(none)))

graph export "Figures\FigA16Panel1.png", width(3900) replace


*Show pre-treatment gaps
reshape wide r_2party, i(year) j(treat)
gen diff = r_2party1 - r_2party0

twoway line diff year, xline(1928, lwidth(vthin)) yline(0, lwidth(vthin)) xlabel(1896 "1896" 1904 "1904" 1912 "1912" 1920 "1920" 1928 "1928" 1936 "1936") xtitle("") ylabel(-15 "-15%" -10 "-10%" -5 "-5%" 0 "0%" 5 "5%", ang(horizontal)) ytitle("Difference in Republican Vote Share," "Treated and Control Units")

graph export "Figures\FigA16Panel2.png", width(3900) replace




*Estimate Placebo Regression Models - 1924 Election
	*Place all in a single figure
use "Placebo_data.dta", clear
keep if south == 1


*drop counties in which prot1 is too high to be reasonable
drop if prot1>140 & prot1!=.


*Difference outcome
gen r_diff = r_2party - vote_l1


*Estimate models
	*Binary treatment category
reg r_diff treat if year == 1924
eststo m1

reg r_diff treat black_1920 prot1 if year == 1924
eststo m2

esttab m1 m2 using "Figures\TableA10.tex", style(tab) ar2 nogap stats(N) cells(b(star fmt(3)) se(par fmt(2))) nostar noconstant replace
eststo clear



*Estimate Placebo Synthetic Control Models -- 1924 Election

use "Placebo_data.dta", clear


replace treat_id_n = . if year!=1924
replace treat_id_s = . if year!=1924
replace synth_id = . if year!=1924


*Variables to hold synth results
gen rmspe1 = .
gen black_treat1 = .
gen black_synth1 = .
gen prot_treat1 = .
gen prot_synth1 = .
gen black_weight1 = .
gen prot_weight1 = .

foreach j of numlist 1896(4)1936{
	gen out_treat1_`j' = .
	gen out_synth1_`j' = .
}

	
*Placebo synthetic control - estimating treatment effects in 1924
	*Donor pool trimming by pre-treatment vote share

sort synth_id
local v "1"
foreach i of numlist 1/130{
	timer on 1
	display `i'
	sort synth_id
	
	*Grab values
	local trunit_x = county_id[`i']
	local counit_x = counits1[`i']

	local synth_x = "synth r_2party black_1920(1924) prot1(1924) r_2party(1896) r_2party(1900) r_2party(1904) r_2party(1908) r_2party(1912) r_2party(1916) r_2party(1920), trunit(`trunit_x') trperiod(1924) counit(`counit_x') mspeperiod(1896(4)1920) resultsperiod(1896(4)1936)"
	
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
	
	sort synth_id
	replace rmspe`v' = b[1,1] in `i'
	replace black_weight`v' = c[1,1] in `i'
	replace prot_weight`v' = c[3,3] in `i'
	replace black_treat`v' = d[1,1] in `i'
	replace prot_treat`v' = d[3,1] in `i'
	replace black_synth`v' = d[1,2] in `i'
	replace prot_synth`v' = d[3,2] in `i'

	foreach j of numlist 1/11{
		local y = 1892 + (`j'*4)	
		replace out_synth`v'_`y' = f[`j',1] in `i'
		replace out_treat`v'_`y' = g[`j',1] in `i'
	}

	clear programs
	ereturn clear	
	timer off 1
	timer list 1
	timer clear 1
}



foreach i of numlist 1896(4)1936{
	gen diff`i' = out_treat1_`i' - out_synth1_`i'
}

sum diff1924

save "res_placebo.dta", replace





*Placebo test - statistical inference
	*Fisher randomization first
	*ADH inference second

use "res_placebo.dta", clear
sort county_id year

keep out_treat*1924 out_synth*1924 south
keep if out_treat1_1924 != .
gsort -south 
gen case_id = _n 
gen s_case_id = _n in 1/95


*Prep for reshape
rename out_treat1_1924 s1_1
rename out_synth1_1924 s1_2


*Reshape
reshape long s1_ s2_ s3_ s4_ s5_ s6_, i(case_id) j(true_treat)


*Cleanup
rename s*_ s*
replace true_treat = 0 if true_treat == 2


*Prep
set obs 10000
gen perm_id = _n
gen est_s1_s = .
gen est_s1_full = .
order perm_id case_id s_case_id true_treat south s* est*


*Perform rand inf in batches
	*All southern iterations first
	*In order: s1, s2, s3, s4, s5, s6
	*Randomize treatment assignment *within pairs*
	*Set seed for each to ease replication

	
*Donor Pool 1, southern cases
set seed 82723

forvalues i = 1/10000{
	sort s_case_id true_treat
	gen random = uniform() in 1/190
	
	bysort s_case_id: egen max_random = max(random) if s_case_id != .
	gen treat = 0 if s_case_id!=.
	replace treat = 1 if random == max_random & s_case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s1 treat if s_case_id!=.
	matrix b = e(b)
	replace est_s1_s = b[1,1] in `i'	
	
	drop random max_random treat
}


*Now full sample

*Donor Pool 1, all cases
set seed 655

forvalues i = 1/10000{
	sort case_id true_treat
	gen random = uniform() in 1/260
	
	bysort case_id: egen max_random = max(random) if case_id != .
	gen treat = 0 if case_id!=.
	replace treat = 1 if random == max_random & case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s1 treat if case_id!=.
	matrix b = e(b)
	replace est_s1_full = b[1,1] in `i'	
	
	drop random max_random treat
}


tab est_s1_s if est_s1_s > 2.228813
tab est_s1_full if est_s1_full > 1.054884


save "res_placebo_inf.dta", replace



*/



*Performing permutation inference

use "perm_data.dta", clear


*Prep permutation IDs & clean up
replace perm_id_main = . if year != 1924
drop p_counits2 p_counits3 p_counits4 p_counits5 p_counits6 perm_id5 perm_id6 control5_n control5_s control6_n control6_s control5_n_id control5_s_id control6_n_id control6_s_id


*Variables to hold synth results
gen placebo_1924 = .
gen placebo_synth_1924 = .

	
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

	local synth_x = "synth r_2party black_1920(1924) prot1(1924) r_2party(1896) r_2party(1900) r_2party(1904) r_2party(1908) r_2party(1912) r_2party(1916) r_2party(1920), trunit(`trunit_x') trperiod(1924) counit(`counit_x') mspeperiod(1896(4)1920) resultsperiod(1896(4)1936)"
	
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
	replace placebo_1924 = f[8,1] in `i'
	replace placebo_synth_1924 = g[8,1] in `i'


	clear programs
	ereturn clear	
	timer off 1
	timer list 1
	timer clear 1	
}


*Calculate effects and save
gen diff = placebo_1924 - placebo_synth_1924
save "res_placebo_perm.dta", replace



*Then perform permutation inference

set seed 88254
gen perm = 1 if diff != .
keep if perm == 1
keep diff perm south

set obs 10000
gen perm_id = _n


*Variables to hold results
gen diff_s = .
gen diff_full = .



*Southern Samples First
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	gsort -south perm random
	gen treat = 1 in 1/95

	sort perm_id 	
	quietly sum diff if treat == 1
	replace diff_s = r(mean) in `i'

	drop random treat
}



*Full Samples
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	sort perm random
	gen treat = 1 in 1/130

	sort perm_id 	
	quietly sum diff if treat == 1
	replace diff_full = r(mean) in `i'

	drop random treat
}



*Check results
tab diff_s if diff_s > 1.054884
tab diff_full if diff_full > 2.228813


save "res_placebo_perm_inf.dta", replace




*The End



