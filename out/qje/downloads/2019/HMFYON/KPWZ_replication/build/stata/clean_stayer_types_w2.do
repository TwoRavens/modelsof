
*******************************************************************************
*******************************************************************************
* create cohort files for w2 stayers
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

insheet using $rawdir/new_stayer_vars.csv, clear	

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


forv y=`firstyear'/`lastyear' {
capture rename male_stayers`y'        stayersM`y'
capture rename female_stayers`y'      stayersF`y'
capture rename inventor_stayers`y'    stayers_inv`y'
capture rename noninventor_stayers`y' stayers_noninv`y'

capture rename male_stayer_wages`y'        wage_stayersM`y'
capture rename female_stayer_wages`y'      wage_stayersF`y'
capture rename inventor_stayer_wages`y'    wage_stayers_inv`y'
capture rename noninventor_stayer_wages`y' wage_stayers_noninv`y'

}


keep year unmasked_tin stayers* wage_stayer*

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort unmasked_tin year
order unmasked_tin year
save $dumpdir/outcomes_patent_eins_w2_stayers_type_allworker.dta, replace

