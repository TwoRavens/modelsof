clear all

local max_dist = 50
* set maximum number of connected units

local obs = 400
* set number of observations

local regions = `obs'/`max_dist'

local beta = 1
* coefficient on second-stage x

set matsize 1000

local obs = `obs'

set seed 20

matrix W = J(`obs',`obs',0)
local i = 1 
while `i' <= `regions' {
local a = `i'*`max_dist'
local s = (`i'-1)*`max_dist'
local r = 1
while `r' <= `obs' {
local c = 1 
while `c' <= `obs' {
local cs = `c'*`s'
local rs = `r'*`s'
if `r' <= `a' & `c' <= `a' & `r' > `s' & `c' > `s' matrix W[`r',`c'] = 1
if `r' == `c'  matrix W[`r',`c'] = 0
local c = `c' + 1
}
local r = `r' + 1
}
local i = `i' + 1
}

***** row-normalize
local obs = `obs'
mata : st_matrix("Wrow", rowsum(st_matrix("W")))
matrix W_normalized = J(`obs',`obs',0)

local r = 1
while `r' <= `obs' {
local c = 1 
while `c' <= `obs' {
scalar multiply = Wrow[`r',1]
matrix W[`r',`c'] = W[`r',`c']/multiply
local c = `c' + 1
}
local r = `r' + 1
}
***


set more off
capture program drop spatial
qui program define spatial, rclass
syntax [, delta(real 0) beta(real 0) obs(real 200)]

drop _all

set obs `obs'

matrix C = (1 , `delta' \ `delta', 1)
drawnorm e v, corr(C)

mkmat e, nomissing
mkmat v, nomissing
matrix I = I(`obs')

matrix multiple = inv(I - .5*W)

matrix x = multiple*(v)

matrix z = W*x

matrix y = (`beta'*x + e)

svmat y, names(y)
rename y1 y

svmat x, names(x)
rename x1 x

svmat z, names(z)
rename z1 z

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

local obs = 400

simulate b_first = r(b_first) t_first = r(t_first) b_2sls = r(b_2sls) se_2sls = r(se_2sls), reps(1000) seed(50): spatial, delta(`delta') beta(1) obs(400)

save `delta'_delta.dta, replace
local i = `i' + 1
}

