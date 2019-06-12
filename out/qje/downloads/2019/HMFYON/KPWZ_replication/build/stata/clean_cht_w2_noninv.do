
*******************************************************************************
*******************************************************************************
* create cohort files for w2
*******************************************************************************
*******************************************************************************
set more off
clear 
set maxvar 8000

local firstyear = 1996
local lastyear  = 2014

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
*"inventor" "noninventor" "M" "F"
*foreach dataset in  "noninventor" {
local dataset="noninventor"
insheet using $rawdir/cohort_`dataset'_wages.csv, clear	

*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************
rename cht_`dataset' cht_noninv
rename payer_tin_w2_max tin
rename tax_yr year

*merge to spine
sort tin year
merge 1:1 tin year using `tin_year_spine'
tab _merge
keep if _merge==3
drop _merge

	forv y=`firstyear'/`lastyear' {
	rename noninventor_chtwages_`y' wage_cht_noninv_`y'
	}

keep year unmasked_tin wage_cht_noninv_* cht_noninv

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort unmasked_tin year
order unmasked_tin year
save $dumpdir/outcomes_patent_eins_w2_cht_`dataset'.dta, replace
*}
