********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE 2

* START LOG SESSION
	log using "LOGS/TAB_2", replace

* LOAD DATA
	u "DATA/BUILDING_LV.dta", clear

* COMPUTE STATS BY COHORT
	collapse  (first) Year = LVYEAR (count) B_N=LV (min) B_Min = LV  (mean) B_Mean = LV (max) B_Max = LV , by(CC)
	
* SAVE TEMP FILE
	save "DATA/TEMP/temp.dta", replace
	
	u "DATA/GRID_WIDE.dta", clear
		keep grid_id lv* 
		reshape long lv , i(grid_id) j(LVYEAR)
	collapse   (count) G_N=lv (min) G_Min = lv  (mean) G_Mean = lv (max) G_Max = lv , by(LVYEAR)
	ren LVYEAR Year
	merge Year using "DATA/TEMP/temp.dta", unique sort
	tab _m

* COMPUTE MEAN ACROSS COHORTS
	set obs 14
	foreach var of varlist  B_Min B_Mean B_Max  G_Min G_Mean G_Max {
	sum `var'
	replace `var' = round(r(mean),0.01) if _n == 14
	replace `var' = round(`var', 0.01) if _n < 14
	}	
	
* CLEAN 
	drop _m
	erase "DATA/TEMP/temp.dta"
	order CC
* WRITE TABLE 
	export excel using "TABS\TAB_2.xls", firstrow(variables) replace

	
* END LOG SESSION
 log close
	
	
