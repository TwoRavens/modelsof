**********************************************************************************************88
**********************************************************************************************88
**********************************************************************************************88
*Combined Time Series, True Relationship
**********************************************************************************************88
**********************************************************************************************88
**********************************************************************************************88

*Show current version
version
*Set to Stata version 13.1
version 13.1
*************************
**T=50; x1, rho=.2, .5, .8
*************************
set seed 4545

******
*rho=.2
*****
*program drop combined
program define combined
drop _all
set obs 50
gen t = _n
*gen stationary time series (x1)
gen e1=invnorm(uniform())
gen x1=e1 if t==1
replace x1=.2*x1[_n-1] + e1 if t>1
*gen integrated time series (x2)
gen u=invnorm(uniform())
gen x2=u if t==1
replace x2=x2[_n-1] + u if t>1
*gen combined times series (z) that his a function of x1 and x2
gen q=invnorm(uniform())
gen z = .5*x1 + .5*x2 + q
tsset t
reg z l.z x1 l.x1 
end

*Simulate the program "combined" N times and save the betas and standard errors.
*Test whether an equation with mixed orders of integration (combined z, stationary x1, integrated x2)
*can correctly identify TRUE relationships
simulate _b _se, reps(1000) nodots: combined

sum

*Generate t-statistic for each simulated regression and evaluate how many regressions we gen tstat_x1 = abs(_b_x1/_se_x1)
gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

 
******
*rho=.5
*****
program drop combined
program define combined
drop _all
set obs 50
gen t = _n
*gen stationary time series (x1)
gen e1=invnorm(uniform())
gen x1=e1 if t==1
replace x1=.5*x1[_n-1] + e1 if t>1
*gen integrated time series (x2)
gen u=invnorm(uniform())
gen x2=u if t==1
replace x2=x2[_n-1] + u if t>1
*gen combined times series (z) that his a function of x1 and x2
gen q=invnorm(uniform())
gen z = .5*x1 + .5*x2 + q
tsset t
reg z l.z x1 l.x1 
end

simulate _b _se, reps(1000) nodots: combined

sum

gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

 
******
*rho=.8
*****
program drop combined
program define combined
drop _all
set obs 50
gen t = _n
*gen stationary time series (x1)
gen e1=invnorm(uniform())
gen x1=e1 if t==1
replace x1=.8*x1[_n-1] + e1 if t>1
*gen integrated time series (x2)
gen u=invnorm(uniform())
gen x2=u if t==1
replace x2=x2[_n-1] + u if t>1
*gen combined times series (z) that his a function of x1 and x2
gen q=invnorm(uniform())
gen z = .5*x1 + .5*x2 + q
tsset t
reg z l.z x1 l.x1 
end

simulate _b _se, reps(1000) nodots: combined

sum

gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96


 
*************************
**T=100; x1, rho=.2, .5, .8
*************************

******
*rho=.2
*****
program drop combined
program define combined
drop _all
set obs 100
gen t = _n
*gen stationary time series (x1)
gen e1=invnorm(uniform())
gen x1=e1 if t==1
replace x1=.2*x1[_n-1] + e1 if t>1
*gen integrated time series (x2)
gen u=invnorm(uniform())
gen x2=u if t==1
replace x2=x2[_n-1] + u if t>1
*gen combined times series (z) that his a function of x1 and x2
gen q=invnorm(uniform())
gen z = .5*x1 + .5*x2 + q
tsset t
reg z l.z x1 l.x1 
end

*Simulate the program "combined" N times and save the betas and standard errors.
*Test whether an equation with mixed orders of integration (combined z, stationary x1, integrated x2)
*can correctly identify TRUE relationships
simulate _b _se, reps(1000) nodots: combined

sum

*Generate t-statistic for each simulated regression and evaluate how many regressions we gen tstat_x1 = abs(_b_x1/_se_x1)
gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

 
******
*rho=.5
*****
program drop combined
program define combined
drop _all
set obs 100
gen t = _n
*gen stationary time series (x1)
gen e1=invnorm(uniform())
gen x1=e1 if t==1
replace x1=.5*x1[_n-1] + e1 if t>1
*gen integrated time series (x2)
gen u=invnorm(uniform())
gen x2=u if t==1
replace x2=x2[_n-1] + u if t>1
*gen combined times series (z) that his a function of x1 and x2
gen q=invnorm(uniform())
gen z = .5*x1 + .5*x2 + q
tsset t
reg z l.z x1 l.x1 
end

simulate _b _se, reps(1000) nodots: combined

sum

gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

 
******
*rho=.8
*****
program drop combined
program define combined
drop _all
set obs 100
gen t = _n
*gen stationary time series (x1)
gen e1=invnorm(uniform())
gen x1=e1 if t==1
replace x1=.8*x1[_n-1] + e1 if t>1
*gen integrated time series (x2)
gen u=invnorm(uniform())
gen x2=u if t==1
replace x2=x2[_n-1] + u if t>1
*gen combined times series (z) that his a function of x1 and x2
gen q=invnorm(uniform())
gen z = .5*x1 + .5*x2 + q
tsset t
reg z l.z x1 l.x1 
end

simulate _b _se, reps(1000) nodots: combined

sum

gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

 
*************************
**T=5,000; x1, rho=.2, .5, .8
*************************

******
*rho=.2
*****
program drop combined
program define combined
drop _all
set obs 5000
gen t = _n
*gen stationary time series (x1)
gen e1=invnorm(uniform())
gen x1=e1 if t==1
replace x1=.2*x1[_n-1] + e1 if t>1
*gen integrated time series (x2)
gen u=invnorm(uniform())
gen x2=u if t==1
replace x2=x2[_n-1] + u if t>1
*gen combined times series (z) that his a function of x1 and x2
gen q=invnorm(uniform())
gen z = .5*x1 + .5*x2 + q
tsset t
reg z l.z x1 l.x1 
end

*Simulate the program "combined" N times and save the betas and standard errors.
*Test whether an equation with mixed orders of integration (combined z, stationary x1, integrated x2)
*can correctly identify TRUE relationships
simulate _b _se, reps(1000) nodots: combined

sum

*Generate t-statistic for each simulated regression and evaluate how many regressions we gen tstat_x1 = abs(_b_x1/_se_x1)
gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

 
******
*rho=.5
*****
program drop combined
program define combined
drop _all
set obs 5000
gen t = _n
*gen stationary time series (x1)
gen e1=invnorm(uniform())
gen x1=e1 if t==1
replace x1=.5*x1[_n-1] + e1 if t>1
*gen integrated time series (x2)
gen u=invnorm(uniform())
gen x2=u if t==1
replace x2=x2[_n-1] + u if t>1
*gen combined times series (z) that his a function of x1 and x2
gen q=invnorm(uniform())
gen z = .5*x1 + .5*x2 + q
tsset t
reg z l.z x1 l.x1 
end

simulate _b _se, reps(1000) nodots: combined

sum

gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

 
******
*rho=.8
*****
program drop combined
program define combined
drop _all
set obs 5000
gen t = _n
*gen stationary time series (x1)
gen e1=invnorm(uniform())
gen x1=e1 if t==1
replace x1=.8*x1[_n-1] + e1 if t>1
*gen integrated time series (x2)
gen u=invnorm(uniform())
gen x2=u if t==1
replace x2=x2[_n-1] + u if t>1
*gen combined times series (z) that his a function of x1 and x2
gen q=invnorm(uniform())
gen z = .5*x1 + .5*x2 + q
tsset t
reg z l.z x1 l.x1 
end

simulate _b _se, reps(1000) nodots: combined

sum

gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

