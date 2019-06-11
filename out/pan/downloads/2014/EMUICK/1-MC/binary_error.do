clear all
set obs 1000
gen n = (_n-1)*2
gen b1iv_avg = .
gen b1iv_min = .
gen b1iv_max = .
gen b1hl_avg = .
gen b1hl_min = .
gen b1hl_max = .

save ~/binary_error.dta, replace

clear all
set mem 8000m
set more off
capture program drop ivsim
program define ivsim, rclass
version 11.2
syntax [, obs(integer 1) wrong(integer 0)]
drop _all
set obs `obs'
drawnorm u v, n(`obs') corr(1, 0.7 \ 0.7, 1)
generate z = rnormal(0,1)
generate w = rnormal(0,1) - 2*z
replace z = 0 if z < 0
replace z = 1 if z > 0
generate x = 1 + 2*z + v
generate y = - 0.5 + 3*x + u
replace x = x + 2*w if _n <= `wrong'
ivregress 2sls y (x = z)
return scalar bx_iv = _coef[x]
HL_rank_p y x z, lower(-10) upper(100) tolerance(0.01)
return scalar bx_HL = beta
end


forvalues i = 0(2)120 {
simulate b1iv = r(bx_iv) b1HL = r(bx_HL), reps(1000): ivsim, obs(250) wrong(`i')

su b1iv
scalar b1iv_avg_s =  r(mean)
scalar b1iv_min_s =  r(min)
scalar b1iv_max_s =  r(max)
su b1HL
scalar b1hl_avg_s =  r(mean)
scalar b1hl_min_s =  r(min)
scalar b1hl_max_s =  r(max)

use ~/binary_error.dta, clear

replace b1iv_avg = b1iv_avg_s if n == `i'
replace b1iv_min = b1iv_min_s if n == `i'
replace b1iv_max = b1iv_max_s if n == `i'
replace b1hl_avg = b1hl_avg_s if n == `i'
replace b1hl_min = b1hl_min_s if n == `i'
replace b1hl_max = b1hl_max_s if n == `i'

save ~/binary_error.dta, replace
}

exit, clear
