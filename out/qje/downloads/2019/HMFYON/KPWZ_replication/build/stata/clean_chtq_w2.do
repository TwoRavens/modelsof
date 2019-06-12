
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

insheet using $rawdir/cohort_appyr_q_wages.csv, clear	

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

rename quartile q
label var q "quartile"

forv y=`firstyear'/`lastyear' {

rename cht_q_wages_`y' wage_cht_q_`y'
}

rename cht_quartile_size n_chtq
keep year unmasked_tin q wage_cht_q* n_chtq

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort unmasked_tin year
order unmasked_tin year
save $dumpdir/outcomes_patent_eins_w2_chtq.dta, replace

forv i=1/4{
use $dumpdir/outcomes_patent_eins_w2_chtq.dta, clear
keep if q==`i'
drop q
	forv y=`firstyear'/`lastyear' {
	rename wage_cht_q_`y' wage_cht_q`i'_`y'  
	}

sort unmasked_tin year
order unmasked_tin year
save $dumpdir/outcomes_patent_eins_w2_chq`i'.dta, replace
}


