****************************************
**Peter K. Enns and Christopher Wlezien
**Understanding Equation Balance in Time Series Regression: An Extension
**Political Science Research Methods
**Simulation Code to Replicate Table 3
****************************************

*\section[\hspace{.8in}Replication Code for Table 3]{Replication Code for Table 3: Combined Time Series, True Relationship}

*********************
*TABLE 3
*********************

*************************
**T=50; x1, rho=.2, .5, .8
*************************
set seed 4545

******
*rho=.2
*****
*program drop combined_noq
program define combined_noq, rclass
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
gen z = x1 + x2
tsset t
reg z l.z x1 l.x1
	estat bgodfrey
	mat P = r(p)
	return scalar pvalue_bg = P[1,1] 
end

*Simulate the program "combined" N times and save the betas and standard errors.
*Test whether an equation with mixed orders of integration (combined z, I(0) x1, I(1) x2)
*can correctly identify TRUE relationships
simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: combined_noq

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

*****************
**Column 1 (coef)
*****************
sum _sim_1 _b_x1 _sim_3

*****************
**Column 2 (%)
*****************
*Generate t-statistic for each simulated regression
gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=2.01
gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=2.01
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=2.01

******
*\rho=.5
*****
program drop combined_noq
program define combined_noq, rclass
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
gen z = x1 + x2
tsset t
reg z l.z x1 l.x1
	estat bgodfrey
	mat P = r(p)
	return scalar pvalue_bg = P[1,1] 
end

simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: combined_noq

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

*****************
**Column 3 (coef)
*****************
sum _sim_1 _b_x1 _sim_3

*****************
**Column 4 (%)
*****************
gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=2.01

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=2.01
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=2.01

******
*rho=.8
*****
program drop combined_noq
program define combined_noq, rclass
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
gen z = x1 + x2
tsset t
reg z l.z x1 l.x1
	estat bgodfrey
	mat P = r(p)
	return scalar pvalue_bg = P[1,1] 
end

simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: combined_noq

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

*****************
**Column 5 (coef)
*****************
sum _sim_1 _b_x1 _sim_3

*****************
**Column 6 (%)
*****************
gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=2.01

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=2.01
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=2.01


*************************
**T=100; x1, rho=.2, .5, .8
*************************

******
*rho=.2
*****
program drop combined_noq
program define combined_noq, rclass
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
gen z = x1 + x2
tsset t
reg z l.z x1 l.x1
	estat bgodfrey
	mat P = r(p)
	return scalar pvalue_bg = P[1,1] 
end

*Simulate the program "combined" N times and save the betas and standard errors.
*Test whether an equation with mixed orders of integration (combined z, I(0) x1, I(1) x2)
*can correctly identify TRUE relationships
simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: combined_noq


*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

*****************
**Column 7 (coef)
*****************
sum _sim_1 _b_x1 _sim_3

*****************
**Column 8 (%)
*****************
*Generate t-statistic for each simulated regression
gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96

gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

******
*rho=.5
*****
program drop combined_noq
program define combined_noq, rclass
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
gen z = x1 + x2
tsset t
reg z l.z x1 l.x1
	estat bgodfrey
	mat P = r(p)
	return scalar pvalue_bg = P[1,1] 
end

simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: combined_noq

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

*****************
**Column 9 (coef)
*****************
sum _sim_1 _b_x1 _sim_3

*****************
**Column 10 (%)
*****************
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
program drop combined_noq
program define combined_noq, rclass
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
gen z = x1 + x2
tsset t
reg z l.z x1 l.x1
	estat bgodfrey
	mat P = r(p)
	return scalar pvalue_bg = P[1,1] 
end

simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: combined_noq

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

*****************
**Column 11 (coef)
*****************
sum _sim_1 _b_x1 _sim_3

*****************
**Column 12 (%)
*****************
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
program drop combined_noq
program define combined_noq, rclass
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
gen z = x1 + x2
tsset t
reg z l.z x1 l.x1
	estat bgodfrey
	mat P = r(p)
	return scalar pvalue_bg = P[1,1] 
end

*Simulate the program "combined" N times and save the betas and standard errors.
*Test whether an equation with mixed orders of integration (combined z, I(0) x1, I(1) x2)
*can correctly identify TRUE relationships
simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: combined_noq

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

*****************
**Column 13 (coef)
*****************
sum _sim_1 _b_x1 _sim_3

*****************
**Column 14 (%)
*****************
*Generate t-statistic for each simulated regression
gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96

gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96
*
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96


******
*rho=.5
*****
program drop combined_noq
program define combined_noq, rclass
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
gen z = x1 + x2
tsset t
reg z l.z x1 l.x1
	estat bgodfrey
	mat P = r(p)
	return scalar pvalue_bg = P[1,1] 
end

simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: combined_noq

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

*****************
**Column 15 (coef)
*****************
sum _sim_1 _b_x1 _sim_3

*****************
**Column 16 (%)
*****************
gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96

gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96


******
*rho=.8
*****
program drop combined_noq
program define combined_noq, rclass
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
gen z = x1 + x2
tsset t
reg z l.z x1 l.x1
	estat bgodfrey
	mat P = r(p)
	return scalar pvalue_bg = P[1,1] 
end

simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: combined_noq

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

*****************
**Column 17 (coef)
*****************
sum _sim_1 _b_x1 _sim_3

*****************
**Column 18 (%)
*****************
gen tstat_ly = abs(_sim_1/_sim_5)
sum tstat_ly if tstat_ly>=1.96

gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96

gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96
