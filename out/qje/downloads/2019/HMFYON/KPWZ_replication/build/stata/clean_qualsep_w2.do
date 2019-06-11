
*******************************************************************************
*******************************************************************************
* create cohort files for w2 stayers
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
*1.0 LOAD CSV OF EIN-YEAR-worker cohort file
*******************************************************************************

insheet using $rawdir/med_baseline_qual_sep_vars.csv, clear	

*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************
rename payer_tin_w2_max tin
rename tax_yr year

*merge to spine
sort tin year
merge m:1 tin year using `tin_year_spine'
tab _merge
keep if _merge==3
drop _merge

keep year unmasked_tin abv* w2* num*

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort unmasked_tin year
order unmasked_tin year
save $dumpdir/outcomes_patent_eins_w2_qualsep.dta, replace

