*****************************************************************************
** xp dosage **
*****************************************************************************

set more off

*****************************************************************************
* Step 0) Prep analysis_coeff with dosage X's
*****************************************************************************
use $rawdir/analysis_coeffs.dta
destring appnum, replace
	
	*ONLY PUBLIC FIRMS
	merge m:1 appnum using $rawdir/dosage_vars.dta
	tab _merge
	*keep if _merge==3
	drop _merge
	
	*ONLY JOEY FIRMS
	merge m:1 appnum using $rawdir/287_cstat_wfall_apps.dta
	tab _merge
	*keep if _merge==3
	
tempfile data_dosage_Xs
sort appnum
save `data_dosage_Xs'

*****************************************************************************
* Step 1) Load the firm-application panel data
*****************************************************************************
use $dtadir/kpwz_analysis_bld5_largest.dta, clear

rename naics_4D naics4digit
rename naics_3D naics3D
rename naics_2D naics2D
*****************************************************************************
*** generate the revenue bins
* first get the revenue in the year before the application year
*****************************************************************************
g		rev_temp=rev99*1000
gen     revbins = 1 if rev_temp >=           0 & rev_temp <=         10000
replace revbins = 2 if rev_temp >        10000 & rev_temp <=        100000
replace revbins = 3 if rev_temp >       100000 & rev_temp <=       1000000
replace revbins = 4 if rev_temp >      1000000 & rev_temp <=      10000000
replace revbins = 5 if rev_temp >     10000000 & rev_temp <=     100000000
replace revbins = 6 if rev_temp >    100000000 & rev_temp <=    1000000000
replace revbins = 7 if rev_temp >   1000000000 & rev_temp <=   10000000000
replace revbins = 8 if rev_temp >  10000000000 & rev_temp <=  100000000000
replace revbins = 9 if rev_temp > 100000000000 & rev_temp <= 1000000000000

label define bins 1 "0 <= rev <= 10K" 2 "10K < rev <= 100K" 3 "100K < rev <= 1M" 4 "1M < rev <= 10M" 5 "10M < rev <= 100M" 6 "100M < rev <= 1B" 7 "1B < rev <= 10B" 8 "10B < rev <= 100B" 9 "100B < rev <= 1T"
label values revbins bins

*****************************************************************************
* Step 2) merge on all of the required application level variables
* They are xi, logxi, dwpi, num_claims, HJT_cat, and applicationyear
*****************************************************************************
loc appvars "xi logxi dwpi_uniquecountries num_claims HJT_cat applicationyear"
foreach var of loc appvars {
	cap drop `var'
}

merge m:1 appnum using `data_dosage_Xs', keep(match) nogen

*****************************************************************************
* Step 3) Merge on coefficients by different variables
*****************************************************************************
loc mergevars "num_claims dwpi_uniquecountries applicationyear naics4digit revbins"
foreach var of loc mergevars {
	merge m:1 `var' using $rawdir/`var'.dta, keep(master match) nogen
	gen `var'_match = !mi(`var')
	qui count if `var'_match == 0
	loc val = r(N)
	di "Number of missing `var' observations: `val'"
	di " "
}

*****************************************************************************
* Step 4) generate the fitted values
*****************************************************************************
local first_stage_cons=-58801.589 
gen logxihat = `first_stage_cons' + numcl_coeff + dwpi_coeff  + appyear_coeff + naics_coeff + rev_coeff
count if mi(logxihat)

 summ logxi, d
 summ logxihat, d
 
*****************************************************************************
* Step 5) run the regression
*****************************************************************************
reg logxi logxihat, robust

*******************************************************************************
*7. SAVE 
*******************************************************************************
compress
sort unmasked_tin 
save $dtadir/kpwz_analysis_bld5_largest_dosage.dta, replace




