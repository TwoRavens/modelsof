
*******************************************************************************
*******************************************************************************
* BUILD WAGE OUTCOMES
*******************************************************************************
*******************************************************************************
set more off
clear 
set maxvar 8000

*******************************************************************************
*0.1 KEEP EINS WITH WAGE OUTCOMES OF EINS IN SPINE (WITH TINS)
*******************************************************************************

use $dtadir/einXyear_spine.dta, clear
sort unmasked_tin
merge m:1 unmasked_tin using $dtadir/tin_ein_xwalk.dta
keep if _merge==3
drop _merge
tempfile tin_year_spine
sort tin
save `tin_year_spine'

*******************************************************************************
*1.0 LOAD WAGE DATA COMPONENTS
*******************************************************************************

use $dumpdir/outcomes_patent_eins_w2_all.dta, clear
merge 1:1 tin year using $dumpdir/outcomes_patent_eins_w2_noninventor.dta
tab _merge
drop _merge
merge 1:1 tin year using $dumpdir/outcomes_patent_eins_w2_inventor.dta
tab _merge
drop _merge
merge 1:1 tin year using $dumpdir/outcomes_patent_eins_w2_M.dta
tab _merge
drop _merge
merge 1:1 tin year using $dumpdir/outcomes_patent_eins_w2_F.dta
tab _merge
drop _merge

merge 1:1 tin year using $dumpdir/outcomes_patent_eins_w2_allworkers_jani.dta
tab _merge
drop _merge

recode emp_inventor wb_inventor emp_noninventor wb_noninventor (.=0)
rename emp_inventor employees_inv 
rename wb_inventor wagebill_inv
rename emp_noninventor employees_noninv 
rename wb_noninventor wagebill_noninv
rename emp_all employees
rename wb_all wagebill
rename emp_M employees_m
rename wb_M wagebill_m
rename emp_F employees_f
rename wb_F wagebill_f

recode emp_allworkers_jani wb_allworkers_jani (.=0)
rename emp_allworkers_jani employees_jani
rename wb_allworkers_jani wagebill_jani

*merge to spine
sort tin year
merge 1:1 tin year using `tin_year_spine'
tab _merge
keep if _merge==3
drop _merge

*******************************************************************************
*1.1 LOAD WAGE DATA
*******************************************************************************

	**OLD RAW FILE (USED TO BE JUST ONE FILE)
	**insheet using $oldrawdir/patenting_eins_spine_wagedif2.csv, clear	

duplicates drop
keep unmasked_tin year  ///
wagebill employees ///
employees_noninv wagebill_noninv ///
employees_inv wagebill_inv ///
wagebill_f wagebill_m employees_m employees_f ///
employees_jani wagebill_jani

destring unmasked_tin, replace 
drop if unmasked_tin==.


*drop inactive firms
*drop if wagebill==0 | wagebill==.

*******************************************************************************
* 2. WINZORIZE output vars
*******************************************************************************
	*employees wagebill employees_noninv wagebill_noninv  employees_inv wagebill_inv wagebill_f wagebill_m employees_m employees_f employees_jani wagebill_jani{

foreach var in wagebill wagebill_noninv wagebill_inv wagebill_f wagebill_m wagebill_jani{
*qui winzorize_by_year, var(`var') pct(2) yr(year)
}

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
local varlist "wagebill wagebill_noninv  wagebill_inv wagebill_f wagebill_m wagebill_jani"

foreach var in `varlist' {
usd2014, var(`var') yr(year) 
}

*******************************************************************************
* 4. SAVE Data
*******************************************************************************

g form="w2"
sort unmasked_tin year
saveold $dtadir/outcomes_patent_eins_w2.dta, replace
