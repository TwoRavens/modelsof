clear all

local obs = 400
* set number of observations

local beta = 1
* coefficient on second-stage x

set matsize 1000

local obs = `obs'

set seed 20

set more off
capture program drop spatial
qui program define spatial, rclass
syntax [, delta(real 0) beta(real 0) obs(real 200)]

drop _all

set obs `obs'

matrix C = (1 , `delta' \ `delta', 1)
drawnorm e v, corr(C)

gen z = rnormal()
gen x = z + v

gen y = `beta'*x + e

ivreg y (x = z) 
return scalar b_2sls = _b[x]
return scalar se_2sls = _se[x] 

reg x z
return scalar t_first = _b[z]/_se[z]
return scalar b_first = _b[z]
end 


local i = 0
while `i' < 11 {
local delta = `i'/10

simulate b_first = r(b_first) t_first = r(t_first) b_2sls = r(b_2sls) se_2sls = r(se_2sls), reps(1000) seed(50): spatial, delta(`delta') beta(1) obs(400)

save `delta'_delta_z.dta, replace
local i = `i' + 1
}

