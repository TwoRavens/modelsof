/*
*************
********

inf_perm.do
First version: August 2, 2016
Last Updated: August 3, 2016
By: Brenton Peterson

Summary: Calculates p-values from permutation inference (ADH 2010)

********
*************
*/



*Change working directory
cd "\MSFlood\MSFloodRep_Nov2016"


*Load + prep
set more off
set scheme s1mono
use "ResultsData\res_perm.dta", clear
set seed 88731



forvalues i = 1/6{
	gen perm`i' = 1 if diff`i' != .
}


keep if perm1 == 1 | perm2 == 1 | perm3 == 1 | perm4 == 1 | perm5 == 1 | perm6 == 1
keep diff* perm* south

set obs 10000
gen perm_id = _n



*Variables to hold results
forvalues i = 1/6{
	gen diff_s`i' = .
	gen diff_full`i' = .
}



*Southern Samples First
	*Donor Pool 1
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	gsort -south perm1 random
	gen treat = 1 in 1/95

	sort perm_id 	
	quietly sum diff1 if treat == 1
	replace diff_s1 = r(mean) in `i'

	drop random treat
}



	*Donor Pool 2
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	gsort -south perm2 random
	gen treat = 1 in 1/95

	sort perm_id 	
	quietly sum diff2 if treat == 1
	replace diff_s2 = r(mean) in `i'

	drop random treat
}



	*Donor Pool 3
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	gsort -south perm3 random
	gen treat = 1 in 1/95

	sort perm_id 	
	quietly sum diff3 if treat == 1
	replace diff_s3 = r(mean) in `i'

	drop random treat
}



	*Donor Pool 4
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	gsort -south perm4 random
	gen treat = 1 in 1/95

	sort perm_id 	
	quietly sum diff4 if treat == 1
	replace diff_s4 = r(mean) in `i'

	drop random treat
}



	*Donor Pool 5
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	gsort -south perm5 random
	gen treat = 1 in 1/95

	sort perm_id 	
	quietly sum diff5 if treat == 1
	replace diff_s5 = r(mean) in `i'

	drop random treat
}



	*Donor Pool 6
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	gsort -south perm6 random
	gen treat = 1 in 1/95

	sort perm_id 	
	quietly sum diff6 if treat == 1
	replace diff_s6 = r(mean) in `i'

	drop random treat
}




*Full Samples
	*Donor Pool 1
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	sort perm1 random
	gen treat = 1 in 1/130

	sort perm_id 	
	quietly sum diff1 if treat == 1
	replace diff_full1 = r(mean) in `i'

	drop random treat
}



	*Donor Pool 2
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	sort perm2 random
	gen treat = 1 in 1/130

	sort perm_id 	
	quietly sum diff2 if treat == 1
	replace diff_full2 = r(mean) in `i'

	drop random treat
}



	*Donor Pool 3
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	sort perm3 random
	gen treat = 1 in 1/130

	sort perm_id 	
	quietly sum diff3 if treat == 1
	replace diff_full3 = r(mean) in `i'

	drop random treat
}



	*Donor Pool 4
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	sort perm4 random
	gen treat = 1 in 1/130

	sort perm_id 	
	quietly sum diff4 if treat == 1
	replace diff_full4 = r(mean) in `i'

	drop random treat
}



	*Donor Pool 5
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	sort perm5 random
	gen treat = 1 in 1/130

	sort perm_id 	
	quietly sum diff5 if treat == 1
	replace diff_full5 = r(mean) in `i'

	drop random treat
}



	*Donor Pool 6
forvalues i = 1/10000{
	sort perm_id
	gen random = uniform()
	sort perm6 random
	gen treat = 1 in 1/130

	sort perm_id 	
	quietly sum diff6 if treat == 1
	replace diff_full6 = r(mean) in `i'

	drop random treat
}




tab diff_s1 if diff_s1 < -19.77
tab diff_s2 if diff_s2 < -12.02
tab diff_s3 if diff_s3 < -16.34
tab diff_s4 if diff_s4 < -15.95
tab diff_s5 if diff_s5 < -5.29 
tab diff_s6 if diff_s6 < -9.91 

tab diff_full1 if diff_full1 < -15.46
tab diff_full2 if diff_full2 < -9.88 
tab diff_full3 if diff_full3 < -12.12
tab diff_full4 if diff_full4 < -11.72
tab diff_full5 if diff_full5 < -4.09  
tab diff_full6 if diff_full6 < -8.21  



save "res_perminf.dta", replace




*The End
