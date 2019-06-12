
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

insheet using $rawdir/separators_pooled.csv, clear
rename payer_tin_w2_max tin
rename tax_yr year
rename separators sep
rename mean_separatorwages wage_sep
rename mean_separatorleadwages leadwage_sep

recode sep (.=0)

replace wage_sep      =. if sep==0
replace leadwage_sep  =. if sep==0

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
sep wage_sep leadwage_sep

destring unmasked_tin, replace 
drop if unmasked_tin==.

*******************************************************************************
* 2. WINZORIZE output vars
*******************************************************************************

foreach var in wage_sep leadwage_sep {
*qui winzorize_by_year, var(`var') pct(2) yr(year)
}

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
local varlist "wage_sep leadwage_sep"

foreach var in `varlist' {
usd2014, var(`var') yr(year) 
}

*******************************************************************************
* 4. SAVE Data
*******************************************************************************

g form="w2"
sort unmasked_tin year
saveold $dtadir/outcomes_patent_eins_sep.dta, replace
