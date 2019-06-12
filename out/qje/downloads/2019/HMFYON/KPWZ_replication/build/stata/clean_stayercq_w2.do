
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

insheet using $rawdir/mean_quartile_stayer_currwages.csv, clear	

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

capture rename mean_styr`y'_q_currwages wagecq_stay`y'
capture rename mean_styr`y'_q_oldwages oldwagecq_stay`y'
}


keep year unmasked_tin q wagecq_stay* oldwagecq_stay*

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort unmasked_tin year
order unmasked_tin year
save $dumpdir/outcomes_patent_eins_w2_stayercq.dta, replace

forv i=1/4{
use $dumpdir/outcomes_patent_eins_w2_stayercq.dta, clear
keep if q==`i'
drop q
	forv y=`firstyear'/`lastyear' {
	rename wagecq_stay`y' wagecq`i'_stay`y' 
	rename oldwagecq_stay`y' oldwagecq`i'_stay`y' 
	}

sort unmasked_tin year
order unmasked_tin year
save $dumpdir/outcomes_patent_eins_w2_stayercq`i'.dta, replace
}


