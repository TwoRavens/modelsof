********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE 1

* START LOG SESSION
	log using "LOGS/TAB_1", replace

* LOAD DATA
	u "DATA/BUILDING_LV.dta", clear

* COMPUTE STATS BY COHORT
	collapse (count) N=HEIGHT (min) Min = HEIGHT  (mean) Mean = HEIGHT (max) Max = HEIGHT (mean) Residential = RESIDENTIAL (mean) Commercial = COMMERICIAL (mean) DCBD = dist_cbd, by(CC)
	
* COMPUTE MEAN ACROSS COHORTS
	set obs 14
	foreach var of varlist N Min Mean Max Residential Commercial DCBD {
	sum `var'
	replace `var' = round(r(mean),0.01) if _n == 14
	replace `var' = round(`var', 0.01) if _n < 14
	}
	
* WRITE TABLE 
	export excel using "TABS\TAB_1.xls", firstrow(variables) replace

	
* END LOG SESSION
 log close
