*********************************************************************
*** Replication file to analyze Monte Carlo experiments 
***
*** Created: 9-28-15
*** Modified: 1-21-16 
***
*** NOTE: these files need to be created first with the "Monte Carlo Experiments.R" file!
***
*** Any questions, email williamslaro@missouri.edu
*********************************************************************


cap log close
log using "Monte Carlo Experiments.smcl", replace

*********************************************************************
*** Negative temporal dependence
*** Weibull (B-S Jones p. 25): 
***
*** Sims: 1,000
*** N: varies based on scenario
*** Betas: (c, 1), where c varies by scenario
*** Knot location: c(1, 4, 7)
*** X: uniformly drawn from [-2, 2]
***
*** Lambda: 1
*** Rho: 0.25
*** Formula: h = lambda*rho*(lambda*t)^(rho-1)
*** Modification to hazard: 12*h
*********************************************************************
cd "G:\Temporal Dependence Monte Carlos--Replication\Negative"

local scen "Negative"

qui foreach i of numlist 1(1)6 {
	*** Sample characteristics 
	use `scen'_Sample_`i'.dta, clear
	
	foreach v of varlist N - t_Mean {
		egen mn_`v' = mean(`v')
	}
	
	preserve
		use "`scen'_Hazard_Coverage_`i'.dta", clear
		
		keep in 1
		keep t b_0 b_1
	
		rename t No_Sim
		sort No_Sim
		tempfile beta
		save `beta', replace
	restore
	
	sort No_Sim
	merge No_Sim using `beta'
	drop _merge
	
	keep in 1
	keep b_0 b_1 mn_*
	qui sum b_1
	local b_1 = r(mean)	
	
	nois di _newline(2) "`scen': Scenario # " `i'
	nois list _all
	
	*** Performance of betas and standard errors
	use "`scen'_Beta_`i'.dta", clear
	
	foreach m in Exp TD CP S ASS {
		egen mn_`m' = mean(B_`m')
		egen ab_`m' = mean(abs(B_`m' - `b_1'))
		egen mse_`m' = mean((B_`m' - `b_1')^2)
		
		egen mnse_`m' = mean(SE_`m')
		egen sdb_`m' = sd(B_`m')
		
		nois list mn_`m' ab_`m' mse_`m' mnse_`m' sdb_`m' in 1
	}
}

*********************************************************************
*** Positive temporal dependence
*** Weibull (B-S Jones p. 25): 
***
*** Sims: 1,000
*** N: varies by scenario
*** Betas: (c, 1), where c varies by scenario
*** Knot location: c(1, 4, 7)
*** X: uniformly drawn from [-2, 2]
***
*** Lambda: 0.15
*** Rho: 2.5
*** Formula: h = lambda*rho*(lambda*t)^(rho-1)
*** Modification to hazard: none
*********************************************************************
cd "G:\Temporal Dependence Monte Carlos--Replication\Positive"

local scen "Positive"

qui foreach i of numlist 1(1)6 {
	*** Sample characteristics 
	use `scen'_Sample_`i'.dta, clear
	
	foreach v of varlist N - t_Mean {
		egen mn_`v' = mean(`v')
	}
	
	preserve
		use "`scen'_Hazard_Coverage_`i'.dta", clear
		
		keep in 1
		keep t b_0 b_1
	
		rename t No_Sim
		sort No_Sim
		tempfile beta
		save `beta', replace
	restore
	
	sort No_Sim
	merge No_Sim using `beta'
	drop _merge
	
	keep in 1
	keep b_0 b_1 mn_*
	qui sum b_1
	local b_1 = r(mean)	
	
	nois di _newline(2) "`scen': Scenario # " `i'
	nois list _all
	
	*** Performance of betas and standard errors
	use "`scen'_Beta_`i'.dta", clear
	
	foreach m in Exp TD CP S ASS {
		egen mn_`m' = mean(B_`m')
		egen ab_`m' = mean(abs(B_`m' - `b_1'))
		egen mse_`m' = mean((B_`m' - `b_1')^2)
		
		egen mnse_`m' = mean(SE_`m')
		egen sdb_`m' = sd(B_`m')
		
		nois list mn_`m' ab_`m' mse_`m' mnse_`m' sdb_`m' in 1
	}
}
 

*********************************************************************
*** Non-monotonic temporal dependence (pattern #1)
*** Parabolic (CS formula): 
***
*** Sims: 1,000
*** N: varies by scenario
*** Betas: (c, 1), where c varies by scenario
*** Knot location: c(1, 4, 7)
*** X: uniformly drawn from [-2, 2]
***
*** Lambda: 0.15
*** Formula: h = 1/3 * (lam/2*(t-16))^2
*** Modification to hazard: h*2
*********************************************************************
cd "G:\Temporal Dependence Monte Carlos--Replication\Non-Monotonic 1"

local scen "NM1"

qui foreach i of numlist 1(1)6 {
	*** Sample characteristics 
	use `scen'_Sample_`i'.dta, clear
	
	foreach v of varlist N - t_Mean {
		egen mn_`v' = mean(`v')
	}
	
	preserve
		use "`scen'_Hazard_Coverage_`i'.dta", clear
		
		keep in 1
		keep t b_0 b_1
	
		rename t No_Sim
		sort No_Sim
		tempfile beta
		save `beta', replace
	restore
	
	sort No_Sim
	merge No_Sim using `beta'
	drop _merge
	
	keep in 1
	keep b_0 b_1 mn_*
	qui sum b_1
	local b_1 = r(mean)	
	
	nois di _newline(2) "`scen': Scenario # " `i'
	nois list _all
	
	*** Performance of betas and standard errors
	use "`scen'_Beta_`i'.dta", clear
	
	foreach m in Exp TD CP S ASS {
		egen mn_`m' = mean(B_`m')
		egen ab_`m' = mean(abs(B_`m' - `b_1'))
		egen mse_`m' = mean((B_`m' - `b_1')^2)
		
		egen mnse_`m' = mean(SE_`m')
		egen sdb_`m' = sd(B_`m')
		
		nois list mn_`m' ab_`m' mse_`m' mnse_`m' sdb_`m' in 1
	}
}


*********************************************************************
*** Non-monotonic temporal dependence (pattern #2)
*** Log-logistic: 
***
*** Sims: 1,000
*** N: varies by scenario
*** Betas: (c, 1), where c varies by scenario
*** Knot location: c(1, 4, 7)
*** X: uniformly drawn from [-2, 2]
***
*** Lambda: 0.25
*** Rho: 1.5
*** Formula: h = (lambda*(rho)*(lambda*t)^(rho-1)) / (1+(lambda + t)^rho)
*** Modification to hazard: h*10
*********************************************************************
cd "G:\Temporal Dependence Monte Carlos--Replication\Non-Monotonic 2"

local scen "NM2"

qui foreach i of numlist 1(1)6 {
	*** Sample characteristics 
	use `scen'_Sample_`i'.dta, clear
	
	foreach v of varlist N - t_Mean {
		egen mn_`v' = mean(`v')
	}
	
	preserve
		use "`scen'_Hazard_Coverage_`i'.dta", clear
		
		keep in 1
		keep t b_0 b_1
	
		rename t No_Sim
		sort No_Sim
		tempfile beta
		save `beta', replace
	restore
	
	sort No_Sim
	merge No_Sim using `beta'
	drop _merge
	
	keep in 1
	keep b_0 b_1 mn_*
	qui sum b_1
	local b_1 = r(mean)	
	
	nois di _newline(2) "`scen': Scenario # " `i'
	nois list _all
	
	*** Performance of betas and standard errors
	use "`scen'_Beta_`i'.dta", clear
	
	foreach m in Exp TD CP S ASS {
		egen mn_`m' = mean(B_`m')
		egen ab_`m' = mean(abs(B_`m' - `b_1'))
		egen mse_`m' = mean((B_`m' - `b_1')^2)
		
		egen mnse_`m' = mean(SE_`m')
		egen sdb_`m' = sd(B_`m')
		
		nois list mn_`m' ab_`m' mse_`m' mnse_`m' sdb_`m' in 1
	}
}


*********************************************************************
*** Negative temporal dependence (X has increasing time trend)
*** Weibull (B-S Jones p. 25): 
***
*** Sims: 1,000
*** N: 1,000
*** Betas: (-3, 1)
*** Knot location: c(1, 4, 7)
*** X: uniformly drawn from [-2, 2] + t/S, where S = (5, 10, 25, 50)
***
*** Lambda: 1
*** Rho: 0.25
*** Formula: h = lambda*rho*(lambda*t)^(rho-1)
*** Modification to hazard: 12*h
*********************************************************************
cd "G:\Temporal Dependence Monte Carlos--Replication\Negative\NPH Positive"

local scen "NPH Positive"

qui foreach i of numlist 1(1)4 {
	*** Sample characteristics 
	use "`scen'_Sample_`i'.dta", clear
	
	foreach v of varlist N - t_Mean {
		egen mn_`v' = mean(`v')
	}
	
	preserve
		use "`scen'_Hazard_Coverage_`i'.dta", clear
		
		keep in 1
		keep t b_0 b_1
	
		rename t No_Sim
		sort No_Sim
		tempfile beta
		save `beta', replace
	restore
	
	sort No_Sim
	merge No_Sim using `beta'
	drop _merge
	
	keep in 1
	keep b_0 b_1 mn_*
	qui sum b_1
	local b_1 = r(mean)	
	
	nois di _newline(2) "`scen': Scenario # " `i'
	nois list _all
	
	*** Performance of betas and standard errors
	use "`scen'_Beta_`i'.dta", clear
	
	foreach m in Exp TD CP S ASS {
		egen mn_`m' = mean(B_`m')
		egen ab_`m' = mean(abs(B_`m' - `b_1'))
		egen mse_`m' = mean((B_`m' - `b_1')^2)
		
		egen mnse_`m' = mean(SE_`m')
		egen sdb_`m' = sd(B_`m')
		
		nois list mn_`m' ab_`m' mse_`m' mnse_`m' sdb_`m' in 1
	}
} 

*********************************************************************
*** Positive temporal dependence (X has decreasing time trend)
*** Weibull (B-S Jones p. 25): 
***
*** Sims: 1,000
*** N: 1,000
*** Betas: (-3, 1)
*** Knot location: c(1, 4, 7)
*** X: uniformly drawn from [-2, 2] + t/S, where S = (-5, -10, -25, -50)
***
*** Lambda: 0.15
*** Rho: 2.5
*** Formula: h = lambda*rho*(lambda*t)^(rho-1)
*** Modification to hazard: none
*********************************************************************
cd "G:\Temporal Dependence Monte Carlos--Replication\Positive\NPH Negative"

local scen "NPH Negative"

qui foreach i of numlist 1(1)4 {
	*** Sample characteristics 
	use "`scen'_Sample_`i'.dta", clear
	
	foreach v of varlist N - t_Mean {
		egen mn_`v' = mean(`v')
	}
	
	preserve
		use "`scen'_Hazard_Coverage_`i'.dta", clear
		
		keep in 1
		keep t b_0 b_1
	
		rename t No_Sim
		sort No_Sim
		tempfile beta
		save `beta', replace
	restore
	
	sort No_Sim
	merge No_Sim using `beta'
	drop _merge
	
	keep in 1
	keep b_0 b_1 mn_*
	qui sum b_1
	local b_1 = r(mean)	
	
	nois di _newline(2) "`scen': Scenario # " `i'
	nois list _all
	
	*** Performance of betas and standard errors
	use "`scen'_Beta_`i'.dta", clear
	
	foreach m in Exp TD CP S ASS {
		egen mn_`m' = mean(B_`m')
		egen ab_`m' = mean(abs(B_`m' - `b_1'))
		egen mse_`m' = mean((B_`m' - `b_1')^2)
		
		egen mnse_`m' = mean(SE_`m')
		egen sdb_`m' = sd(B_`m')
		
		nois list mn_`m' ab_`m' mse_`m' mnse_`m' sdb_`m' in 1
	}
}

log close

