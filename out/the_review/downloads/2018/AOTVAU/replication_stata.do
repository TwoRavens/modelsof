
** This code runs the 1000 models (one for every posterior draw) and writes the coefficients out into a file


* Model (1)
clear all

set more off
set seed 123456
set maxvar 32767

use ~/Desktop/replication/data.dta, clear

forvalues bot = 1(1)1000{
	local num = `bot'
	reg coopscore_`num' coalition opposition cmp_rile_diff cmp_multcult_diff voteshare_diff elec nparties population_log events coopscore_mean_`num', r cluster(dyadid)
	matrix coef_`num'_ = e(b)
	svmat coef_`num'_
	matrix vcov_`num'_ = e(V)
	svmat vcov_`num'_
	matrix r2_`num'_ = e(r2)
	svmat r2_`num'_	
}

keep coef* vcov* r2*
drop if vcov_1_1==.
save ~/Desktop/replication/m1.dta, replace



* Model (2). Split up in two runs of 500 due to constratints in saving variables
clear all

set more off
set seed 123456
set maxvar 32767

use ~/Desktop/replication/data.dta, clear

forvalues bot = 1(1)500{
	local num = `bot'
	xi: areg coopscore_`num' coalition opposition cmp_rile_diff cmp_multcult_diff voteshare_diff elec nparties population_log events coopscore_mean_`num' i.year, a(country) r cluster(dyadid)
	matrix coef_`num'_ = e(b)
	svmat coef_`num'_
	matrix vcov_`num'_ = e(V)
	svmat vcov_`num'_
	matrix r2_`num'_ = e(r2)
	svmat r2_`num'_	
}

keep coef* vcov* r2*
drop if vcov_1_1==.
save ~/Desktop/replication/m2_1.dta, replace


clear all

set more off
set seed 123456
set maxvar 32767

use ~/Desktop/replication/data.dta, clear

forvalues bot = 501(1)1000{
	local num = `bot'
	xi: areg coopscore_`num' coalition opposition cmp_rile_diff cmp_multcult_diff voteshare_diff elec nparties population_log events coopscore_mean_`num' i.year, a(country) r cluster(dyadid)
	matrix coef_`num'_ = e(b)
	svmat coef_`num'_
	matrix vcov_`num'_ = e(V)
	svmat vcov_`num'_
	matrix r2_`num'_ = e(r2)
	svmat r2_`num'_	
}

keep coef* vcov* r2*
drop if vcov_501_1==.
save ~/Desktop/replication/m2_2.dta, replace


* Model (3)
clear all

set more off
set seed 123456
set maxvar 32767

use ~/Desktop/replication/data.dta, clear

forvalues bot = 1(1)1000{
	local num = `bot'
	areg coopscore_`num' coalition opposition cmp_rile_diff cmp_multcult_diff voteshare_diff, a(ctyyr) r cluster(dyadid)
	matrix coef_`num'_ = e(b)
	svmat coef_`num'_
	matrix vcov_`num'_ = e(V)
	svmat vcov_`num'_
	matrix r2_`num'_ = e(r2)
	svmat r2_`num'_	
}

keep coef* vcov* r2*
drop if vcov_1_1==.
saveold ~/Desktop/replication/m3.dta, replace




