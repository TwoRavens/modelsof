****************************************
**Peter K. Enns and Christopher Wlezien
**Understanding Equation Balance in Time Series Regression: An Extension
**Political Science Research Methods
**Simulation Code to Replicate Tables 1 and 2
**and results reported in footnotes 15 & 16
****************************************

**All simulations are conducted in Stata 13

**********************
**********************
*TABLE 1
**********************
**********************

*\subsection{\textbf{No Relationship, $\theta_y = 1, \theta_x = 0$, T=50}}

*\begin{verbatim}
*Show current version
version
*Set to Stata version 13.1
version 13.1
set seed 4545
program define unitroot, rclass
	drop _all
	set obs 50
	gen t = _n
	gen u=invnorm(uniform())
	gen y=u if t==1
	replace y=y[_n-1] + u if t>1
	gen e1=invnorm(uniform())
	gen x1=e1
		tsset t
		reg y l.y x1 l.x1
		estat bgodfrey
		mat P = r(p)
		return scalar pvalue_bg = P[1,1] 
end

*Simulate the program "unitroot" N times and save the betas and standard errors.
simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: unitroot

*Generate t-statistic for each simulated regression and evaluate how many 
*regressions we would incorrectly reject the null hypothesis

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

**********
***TABLE 1, T=50, \theta_x=0
**********

*T=50, \beta_1
sum _b_x1
*%
gen tstat_x1 = abs(_b_x1/_se_x1)
*critical value set to 2.01 because T=50
sum tstat_x1 if tstat_x1>=2.01 

*T=50, \beta_2
sum _sim_3
*%
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=2.01

*alpha (Foonote 16)
sum _sim_1
*\end{verbatim}

*\subsection{\textbf{No Relationship, $\theta_y = 1, \theta_x = 0$, T=1,000}}

*\begin{verbatim}
set seed 4545
program drop unitroot
program define unitroot, rclass
	drop _all
	set obs 1000
	gen t = _n
	gen u=invnorm(uniform())
	gen y=u if t==1
	replace y=y[_n-1] + u if t>1
	gen e1=invnorm(uniform())
	gen x1=e1
		tsset t
		reg y l.y x1 l.x1
		estat bgodfrey
		mat P = r(p)
		return scalar pvalue_bg = P[1,1] 
end

*Simulate the program "unitroot" N times and save the betas and standard errors.
simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: unitroot

*Generate t-statistic for each simulated regression and evaluate how many 
*regressions we would incorrectly reject the null hypothesis

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

**********
***TABLE 1, T=1,000, \theta_x=0
**********

*T=1,000, \beta_1
sum _b_x1
*%
gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96

*T=1,000 \beta_2
sum _sim_3
*%
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

*alpha (Footnote 16)
sum _sim_1
*\end{verbatim}


*\subsection{\textbf{No Relationship, $\theta_y = 1, \theta_x = .5$, T=50}}
*\begin{verbatim}

set seed 4545
program drop unitroot
program define unitroot, rclass
	drop _all
	set obs 50
	gen t = _n
	gen u=invnorm(uniform())
	gen y=u if t==1
	replace y=y[_n-1] + u if t>1
	gen e1=invnorm(uniform())
	gen x1=e1 if t==1
    replace x1=.5*x[_n-1] + e1 if t>1
		tsset t
		reg y l.y x1 l.x1
		estat bgodfrey
		mat P = r(p)
		return scalar pvalue_bg = P[1,1] 
end

*Simulate the program "unitroot" N times and save the betas and standard errors.
simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: unitroot

*Generate t-statistic for each simulated regression and evaluate how many 
*regressions we would incorrectly reject the null hypothesis

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

**********
***TABLE 1, T=50, \theta_x=0.5
**********

*T=50, \beta_1, \theta_x=0.5
sum _b_x1
*%
gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=2.01

*T=50, \beta_2, \theta_x=0.5
sum _sim_3
*%
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=2.01

*alpha (Footnote 16)
sum _sim_1
*\end{verbatim}


*\subsection{\textbf{No Relationship, $\theta_y = 1, \theta_x = .5$, T=1000}}
*\begin{verbatim}
set seed 4545
program drop unitroot
program define unitroot, rclass
	drop _all
	set obs 1000
	gen t = _n
	gen u=invnorm(uniform())
	gen y=u if t==1
	replace y=y[_n-1] + u if t>1
	gen e1=invnorm(uniform())
	gen x1=e1 if t==1
    replace x1=.5*x[_n-1] + e1 if t>1
		tsset t
		reg y l.y x1 l.x1
		estat bgodfrey
		mat P = r(p)
		return scalar pvalue_bg = P[1,1] 
end

*Simulate the program "unitroot" N times and save the betas and standard errors.
simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: unitroot

*Generate t-statistic for each simulated regression and evaluate how many 
*regressions we would incorrectly reject the null hypothesis

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

**********
***TABLE 1, T=1,000, \theta_x=0.5
**********

*T=1,000, \beta_1, \theta_x=0.5
sum _b_x1
*%
gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96

*T=1,000, \beta_2, \theta_x=0.5
sum _sim_3
*%
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

*alpha (Footnote 16)
sum _sim_1
*\end{verbatim}

**********************
**********************
*TABLE 2
**********************
**********************

*\subsection{\textbf{No Relationship, $\theta_y = 0, \theta_x = 1$, T=50}}

*\begin{verbatim}
set seed 5656
program drop unitroot
program define unitroot, rclass
	drop _all
	set obs 50
	gen t = _n
	gen u=invnorm(uniform())
	gen y=u
	gen e1=invnorm(uniform())
	gen x1=e1 if t==1
    replace x1=x1[_n-1] + e1 if t>1
		tsset t
		reg y l.y x1 l.x1
		estat bgodfrey
		mat P = r(p)
		return scalar pvalue_bg = P[1,1] 
end

*Simulate the program "unitroot" N times and save the betas and standard errors.
simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: unitroot

*Generate t-statistic for each simulated regression and evaluate how many 
*regressions we would incorrectly reject the null hypothesis

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation (Footnote 15)
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

**********
***TABLE 2, T=50, \theta_y=0
**********

*T=50, \beta_1, \theta_y=0
sum _b_x1
*%
gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=2.01

*T=50, \beta_2, \theta_y=0
sum _sim_3
*%
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=2.01

*alpha (Footnote 16)
sum _sim_1
*\end{verbatim}


*\subsection{\textbf{No Relationship, $\theta_y = 0, \theta_x = 1$, T=1,000}}

*\begin{verbatim}
set seed 5656
program drop unitroot
program define unitroot, rclass
	drop _all
	set obs 1000
	gen t = _n
	gen u=invnorm(uniform())
	gen y=u
	gen e1=invnorm(uniform())
	gen x1=e1 if t==1
    replace x1=x1[_n-1] + e1 if t>1
		tsset t
		reg y l.y x1 l.x1
		estat bgodfrey
		mat P = r(p)
		return scalar pvalue_bg = P[1,1] 
end

*Simulate the program "unitroot" N times and save the betas and standard errors.
simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: unitroot

*Generate t-statistic for each simulated regression and evaluate how many 
*regressions we would incorrectly reject the null hypothesis

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation (Footnote 15)
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

**********
***TABLE 2, T=1,000, \theta_Y=0
**********

*T=1,000, \beta_1, \theta_y=0
sum _b_x1
*%
gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96

*T=1,000, \beta_2, \theta_y=0
sum _sim_3
*%
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

*alpha (Footnote 16)
sum _sim_1
*\end{verbatim}


*\subsection{\textbf{No Relationship, $\theta_y = 0.5, \theta_x = 1$, T=50}}

*\begin{verbatim}
set seed 5656
program drop unitroot
program define unitroot, rclass
	drop _all
	set obs 50
	gen t = _n
	gen u=invnorm(uniform())
	gen y=u if t==1
	replace y=.5*y[_n-1] + u if t>1
	gen e1=invnorm(uniform())
	gen x1=e1 if t==1
    replace x1=x[_n-1] + e1 if t>1
		tsset t
		reg y l.y x1 l.x1
		estat bgodfrey
		mat P = r(p)
		return scalar pvalue_bg = P[1,1] 
end

*Simulate the program "unitroot" N times and save the betas and standard errors.
simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: unitroot

*Generate t-statistic for each simulated regression and evaluate how many 
*regressions we would incorrectly reject the null hypothesis

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation (Footnote 15)
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

**********
***TABLE 2, T=50, \theta_y=0.5
**********

*T=50, \beta_1, \theta_y=0.5
sum _b_x1
*%
gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=2.01

*T=50, \beta_2, \theta_y=0.5
sum _sim_3
*%
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=2.01

*alpha (Footnote 16)
sum _sim_1
*\end{verbatim}


*\subsection{\textbf{No Relationship, $\theta_y = 0.5, \theta_x = 1$, T=1,000}}

*\begin{verbatim}
set seed 5656
program drop unitroot
program define unitroot, rclass
	drop _all
	set obs 1000
	gen t = _n
	gen u=invnorm(uniform())
	gen y=u if t==1
	replace y=.5*y[_n-1] + u if t>1
	gen e1=invnorm(uniform())
	gen x1=e1 if t==1
    replace x1=x[_n-1] + e1 if t>1
		tsset t
		reg y l.y x1 l.x1
		estat bgodfrey
		mat P = r(p)
		return scalar pvalue_bg = P[1,1] 
end

*Simulate the program "unitroot" N times and save the betas and standard errors.
simulate pvalue_bg=r(pvalue_bg) _b _se, reps(1000) nodots: unitroot

*Generate t-statistic for each simulated regression and evaluate how many 
*regressions we would incorrectly reject the null hypothesis

*Percent of simulations which a Breusch-Godfrey test rejects teh null of 
*no serial correlation (Footnote 15)
sum _eq2_pvalue_bg if _eq2_pvalue_bg<0.05

**********
***TABLE 2, T=1,000, \theta_y=0.5
**********

*T=1,000, \beta_1, \theta_y=0.5
sum _b_x1
*%
gen tstat_x1 = abs(_b_x1/_se_x1)
sum tstat_x1 if tstat_x1>=1.96

*T=1,000, \beta_2, \theta_y=0.5
sum _sim_3
*%
gen tstat_lx1 = abs(_sim_3/_sim_7)
sum tstat_lx1 if tstat_lx1>=1.96

*alpha (Footnote 16)
sum _sim_1
*\end{verbatim}

