/*
*************
********

inf_rand.do
First version: July 30, 2016
Last Updated: July 30, 2016
By: Brenton Peterson

Summary: Performs randomization inference for all synthetic control runs

********
*************
*/


*Change working directory
cd "\MSFlood\MSFloodRep_Nov2016"


*Load + prep
set more off
set matsize 2000
use "ResultsData\res_synth_suppapp.dta", clear


sort county_id year

keep out_treat*1928 out_synth*1928 south
keep if out_treat1_1928 != .
gsort -south 
gen case_id = _n 
gen s_case_id = _n in 1/95



*Prep for reshape
rename out_treat1_1928 s1_1
rename out_synth1_1928 s1_2
rename out_treat2_1928 s2_1
rename out_synth2_1928 s2_2
rename out_treat3_1928 s3_1
rename out_synth3_1928 s3_2
rename out_treat4_1928 s4_1
rename out_synth4_1928 s4_2
rename out_treat5_1928 s5_1
rename out_synth5_1928 s5_2
rename out_treat6_1928 s6_1
rename out_synth6_1928 s6_2


*Reshape
reshape long s1_ s2_ s3_ s4_ s5_ s6_, i(case_id) j(true_treat)


*Cleanup
rename s*_ s*
replace true_treat = 0 if true_treat == 2


*Prep
set obs 10000
gen perm_id = _n
gen est_s1_s = .
gen est_s2_s = .
gen est_s3_s = .
gen est_s4_s = .
gen est_s5_s = .
gen est_s6_s = .
gen est_s1_full = .
gen est_s2_full = .
gen est_s3_full = .
gen est_s4_full = .
gen est_s5_full = .
gen est_s6_full = .
order perm_id case_id s_case_id true_treat south s* est*


*Perform rand inf in batches
	*All southern iterations first
	*In order: s1, s2, s3, s4, s5, s6
	*Randomize treatment assignment *within pairs*
	*Set seed for each to ease replication

*Donor Pool 1, southern cases
set seed 974

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



*Donor Pool 2, southern cases
set seed 334

forvalues i = 1/10000{
	sort s_case_id true_treat
	gen random = uniform() in 1/190
	
	bysort s_case_id: egen max_random = max(random) if s_case_id != .
	gen treat = 0 if s_case_id!=.
	replace treat = 1 if random == max_random & s_case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s2 treat if s_case_id!=.
	matrix b = e(b)
	replace est_s2_s = b[1,1] in `i'	
	
	drop random max_random treat
}


*Donor Pool 3, southern cases
set seed 632

forvalues i = 1/10000{
	sort s_case_id true_treat
	gen random = uniform() in 1/190
	
	bysort s_case_id: egen max_random = max(random) if s_case_id != .
	gen treat = 0 if s_case_id!=.
	replace treat = 1 if random == max_random & s_case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s3 treat if s_case_id!=.
	matrix b = e(b)
	replace est_s3_s = b[1,1] in `i'	
	
	drop random max_random treat
}


*Donor Pool 4, southern cases
set seed 66432

forvalues i = 1/10000{
	sort s_case_id true_treat
	gen random = uniform() in 1/190
	
	bysort s_case_id: egen max_random = max(random) if s_case_id != .
	gen treat = 0 if s_case_id!=.
	replace treat = 1 if random == max_random & s_case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s4 treat if s_case_id!=.
	matrix b = e(b)
	replace est_s4_s = b[1,1] in `i'	
	
	drop random max_random treat
}



*Donor Pool 5, southern cases
set seed 9582

forvalues i = 1/10000{
	sort s_case_id true_treat
	gen random = uniform() in 1/190
	
	bysort s_case_id: egen max_random = max(random) if s_case_id != .
	gen treat = 0 if s_case_id!=.
	replace treat = 1 if random == max_random & s_case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s5 treat if s_case_id!=.
	matrix b = e(b)
	replace est_s5_s = b[1,1] in `i'	
	
	drop random max_random treat
}



*Donor Pool 6, southern cases
set seed 3236

forvalues i = 1/10000{
	sort s_case_id true_treat
	gen random = uniform() in 1/190
	
	bysort s_case_id: egen max_random = max(random) if s_case_id != .
	gen treat = 0 if s_case_id!=.
	replace treat = 1 if random == max_random & s_case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s6 treat if s_case_id!=.
	matrix b = e(b)
	replace est_s6_s = b[1,1] in `i'	
	
	drop random max_random treat
}




*Now full sample

*Donor Pool 1, all cases
set seed 352

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



*Donor Pool 2, all cases
set seed 6765

forvalues i = 1/10000{
	sort case_id true_treat
	gen random = uniform() in 1/260
	
	bysort case_id: egen max_random = max(random) if case_id != .
	gen treat = 0 if case_id!=.
	replace treat = 1 if random == max_random & case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s2 treat if case_id!=.
	matrix b = e(b)
	replace est_s2_full = b[1,1] in `i'	
	
	drop random max_random treat
}


*Donor Pool 3, all cases
set seed 435

forvalues i = 1/10000{
	sort case_id true_treat
	gen random = uniform() in 1/260
	
	bysort case_id: egen max_random = max(random) if case_id != .
	gen treat = 0 if case_id!=.
	replace treat = 1 if random == max_random & case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s3 treat if case_id!=.
	matrix b = e(b)
	replace est_s3_full = b[1,1] in `i'	
	
	drop random max_random treat
}


*Donor Pool 4, all cases
set seed 452

forvalues i = 1/10000{
	sort case_id true_treat
	gen random = uniform() in 1/260
	
	bysort case_id: egen max_random = max(random) if case_id != .
	gen treat = 0 if case_id!=.
	replace treat = 1 if random == max_random & case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s4 treat if case_id!=.
	matrix b = e(b)
	replace est_s4_full = b[1,1] in `i'	
	
	drop random max_random treat
}



*Donor Pool 5, all cases
set seed 166

forvalues i = 1/10000{
	sort case_id true_treat
	gen random = uniform() in 1/260
	
	bysort case_id: egen max_random = max(random) if case_id != .
	gen treat = 0 if case_id!=.
	replace treat = 1 if random == max_random & case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s5 treat if case_id!=.
	matrix b = e(b)
	replace est_s5_full = b[1,1] in `i'	
	
	drop random max_random treat
}



*Donor Pool 6, all cases
set seed 865

forvalues i = 1/10000{
	sort case_id true_treat
	gen random = uniform() in 1/260
	
	bysort case_id: egen max_random = max(random) if case_id != .
	gen treat = 0 if case_id!=.
	replace treat = 1 if random == max_random & case_id!=.
	
	*Calculate difference & extract estimate
	sort perm_id
	quietly reg s6 treat if case_id!=.
	matrix b = e(b)
	replace est_s6_full = b[1,1] in `i'	
	
	drop random max_random treat
}



tab est_s1_s if est_s1_s < -19.77
tab est_s2_s if est_s2_s < -12.02
tab est_s3_s if est_s3_s < -16.34
tab est_s4_s if est_s4_s < -15.95
tab est_s5_s if est_s5_s < -5.29 
tab est_s6_s if est_s6_s < -9.91 

tab est_s1_full if est_s1_full < -15.46
tab est_s2_full if est_s2_full < -9.88 
tab est_s3_full if est_s3_full < -12.12
tab est_s4_full if est_s4_full < -11.72
tab est_s5_full if est_s5_full < -4.09  
tab est_s6_full if est_s6_full < -8.21  


save "res_randinf.dta", replace




*The End