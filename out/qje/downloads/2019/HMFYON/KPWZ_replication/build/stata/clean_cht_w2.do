
*******************************************************************************
*******************************************************************************
* create cohort files for w2
*******************************************************************************
*******************************************************************************
set more off
clear 
set maxvar 8000

local firstyear = 1999
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
*"inventor" "noninventor" "all" "M" "F"
foreach dataset in  "inventor" "noninventor" "all" "M" "F" {
*local dataset="inventor"
insheet using $rawdir/`dataset'_workers.csv, clear	

*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************
rename employees cht_`dataset'
rename payer_tin_w2_max tin
rename tax_yr year

if "`dataset'"=="M"{
 keep if gnd_ind=="M"
}
if "`dataset'"=="F"{
 keep if gnd_ind=="F"
}

*merge to spine
sort tin year
merge 1:1 tin year using `tin_year_spine'
tab _merge
keep if _merge==3
drop _merge

forv y=`firstyear'/`lastyear' {
recode zerowages`y' (.=0)
g emp_`dataset'`y'=cht_`dataset'-zerowages`y'
rename wagebill`y' wb_`dataset'`y'
}


keep year unmasked_tin wb_`dataset'* emp_`dataset'* cht_`dataset'

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort unmasked_tin year
order unmasked_tin year
save $dumpdir/outcomes_patent_eins_w2_cht_`dataset'.dta, replace
}
