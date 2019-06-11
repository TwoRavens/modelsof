********************************
*** Monte Carlos for Table 1 ***
********************************

**all Monte Carlos with 5,000 iterations


*binary instrument, 250 observations

clear all
set seed 50
set more off
set mem 8000m
capture program drop ivsim
program define ivsim, rclass
syntax [, obs(integer 1)]
drop _all
set obs `obs'
drawnorm u v, cov(1, 0.7 \ 0.7, 1) n(`obs')
generate z = rnormal(0,1)
replace z = 0 if z < 0
replace z = 1 if z > 0
generate x = 1 + 2*z + v
generate y = -0.5 + 3*x + u
ivregress 2sls y (x = z)
return scalar bx_iv = _coef[x]
return scalar se_iv = _se[x]
HL_rank_p y x z, lower(2) upper(4) tolerance(0.0005)
return scalar bx_HL = beta
return scalar se_HL = se
return scalar lower_HL = conf_low
return scalar upper_HL = conf_up
end
simulate b1iv = r(bx_iv) seiv = r(se_iv)  b1HL = r(bx_HL) seHL = r(se_HL) lowerHL = r(lower_HL) upperHL = r(upper_HL), reps(5000): ivsim, obs(250)

save ~/table/B_250.dta, replace
su


*continuous instrument, 250 observations

clear all
set seed 50
set more off
set mem 8000m
capture program drop ivsim
program define ivsim, rclass
syntax [, obs(integer 1)]
drop _all
set obs `obs'
drawnorm u v, cov(1, 0.7 \ 0.7, 1) n(`obs')
generate z = rnormal(0,1)
generate x = 1 + 2*z + v
generate y = -0.5 + 3*x + u
ivregress 2sls y (x = z)
return scalar bx_iv = _coef[x]
return scalar se_iv = _se[x]
HL_spcorr_p y x z, lower(2) upper(4) tolerance(0.0005)
return scalar bx_HL = beta
return scalar se_HL = se
return scalar lower_HL = conf_low
return scalar upper_HL = conf_up
end

simulate b1iv = r(bx_iv) seiv = r(se_iv)  b1HL = r(bx_HL) seHL = r(se_HL) lowerHL = r(lower_HL) upperHL = r(upper_HL), reps(5000): ivsim, obs(250)

save ~/table/C_250.dta, replace
su


*binary instrument, 10,000 observations

clear all
set seed 50
set more off
set mem 8000m
capture program drop ivsim
program define ivsim, rclass
syntax [, obs(integer 1)]
drop _all
set obs `obs'
drawnorm u v, cov(1, 0.7 \ 0.7, 1) n(`obs')
generate z = rnormal(0,1)
replace z = 0 if z < 0
replace z = 1 if z > 0
generate x = 1 + 2*z + v
generate y = -0.5 + 3*x + u
ivregress 2sls y (x = z)
return scalar bx_iv = _coef[x]
return scalar se_iv = _se[x]
HL_rank_p y x z, lower(2.5) upper(3.5) tolerance(0.0005)
return scalar bx_HL = beta
return scalar se_HL = se
return scalar lower_HL = conf_low
return scalar upper_HL = conf_up
end
simulate b1iv = r(bx_iv) seiv = r(se_iv)  b1HL = r(bx_HL) seHL = r(se_HL) lowerHL = r(lower_HL) upperHL = r(upper_HL), reps(5000): ivsim, obs(10000)

save ~/table/B_10k.dta, replace
su


*continuous instrument, 10,000 observations

clear all
set seed 50
set more off
set mem 18000m
capture program drop ivsim
program define ivsim, rclass
syntax [, obs(integer 1)]
drop _all
set obs `obs'
drawnorm u v, cov(1, 0.7 \ 0.7, 1) n(`obs')
generate z = rnormal(0,1)
generate x = 1 + 2*z + v
generate y = -0.5 + 3*x + u
ivregress 2sls y (x = z)
return scalar bx_iv = _coef[x]
return scalar se_iv = _se[x]
HL_spcorr_p y x z, lower(2.5) upper(3.5) tolerance(0.0005)
return scalar bx_HL = beta
return scalar se_HL = se
return scalar lower_HL = conf_low
return scalar upper_HL = conf_up
end
simulate b1iv = r(bx_iv) seiv = r(se_iv)  b1HL = r(bx_HL) seHL = r(se_HL) lowerHL = r(lower_HL) upperHL = r(upper_HL), reps(5000): ivsim, obs(10000)

save ~/table/C_10k.dta, replace
su