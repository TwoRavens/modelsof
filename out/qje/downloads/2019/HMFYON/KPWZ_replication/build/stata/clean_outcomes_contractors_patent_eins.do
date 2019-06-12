
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

use $dumpdir/outcomes_patent_eins_1099_contract.dta, clear
recode emp_contract wb_contract (.=0)

*merge to spine
sort tin year
merge 1:1 tin year using `tin_year_spine'
tab _merge
keep if _merge==3
drop _merge

*******************************************************************************
*1.1 LOAD WAGE DATA
*******************************************************************************

duplicates drop
keep unmasked_tin year  ///
emp_contract wb_contract 

destring unmasked_tin, replace 
drop if unmasked_tin==.

*drop inactive firms
*drop if wagebill==0 | wagebill==.

*******************************************************************************
* 2. WINZORIZE output vars
*******************************************************************************

foreach var in wb_contract  {
*qui winzorize_by_year, var(`var') pct(2) yr(year)
}

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
local varlist "wb_contract"

foreach var in `varlist' {
usd2014, var(`var') yr(year) 
}

*******************************************************************************
* 4. SAVE Data
*******************************************************************************

g form="1099"
sort unmasked_tin year
saveold $dtadir/outcomes_patent_eins_1099.dta, replace
