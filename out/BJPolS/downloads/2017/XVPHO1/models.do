
*** TABLE 1: Run models, save output

clear all

set more off
set seed 123456

set maxvar 32767

cd replication
use data.dta, clear


forvalues bot = 1(1)500{
	local num = `bot'
	sqreg coopscore_`num' gdppcgrowth openness population_log elec nparties events coopscore_mean_`num' if type==3, quantiles(0.01 0.05 0.25 0.5 0.75 0.95 0.99)
	matrix coef_`num'_ = e(b)
	svmat coef_`num'_
	matrix vcov_`num'_ = e(V)
	svmat vcov_`num'_
}
	* Note: It may be necessary to break this loop up into chunks of 100 and then combine the outputs

keep coef* vcov*
drop if vcov_1_1==.
save coefs.dta
	* Note: I provide an .rda version of this file in the replication data
	

*** TABLE 2, Panel 1: Run models, save output

clear all

set more off
set seed 123456

set maxvar 32767

cd replication
use data.dta, clear


forvalues bot = 1(1)500{
	local num = `bot'
	xi: sqreg coopscore_`num' gdppcgrowth openness population_log elec nparties events coopscore_mean_`num' i.country if type==3, quantiles(0.01 0.05 0.25 0.5 0.75 0.95 0.99)
	matrix coef_`num'_ = e(b)
	svmat coef_`num'_
	matrix vcov_`num'_ = e(V)
	svmat vcov_`num'_
}
	* Note: It may be necessary to break this loop up into chunks of 100 and then combine the outputs

keep coef* vcov*
drop if vcov_1_1==.
save coefs_fe.dta
	* Note: I provide an .rda version of this file in the replication data



*** TABLE 2, Panel 2: Run models, save output

clear all

set more off
set seed 123456

set maxvar 32767

cd replication
use data.dta, clear


forvalues bot = 1(1)500{
	local num = `bot'
	xi: sqreg coopscore_`num' gdppcgrowth openness population_log elec nparties events coopscore_mean_`num' i.country i.year if type==3, quantiles(0.01 0.05 0.25 0.5 0.75 0.95 0.99)
	matrix coef_`num'_ = e(b)
	svmat coef_`num'_
	matrix vcov_`num'_ = e(V)
	svmat vcov_`num'_
}
	* Note: It may be necessary to break this loop up into chunks of 100 (or even 50) and then combine the outputs

keep coef* vcov*
drop if vcov_1_1==.
save coefs_2fe.dta
	* Note: I provide an .rda version of this file in the replication data
