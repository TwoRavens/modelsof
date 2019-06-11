
*******************************************************************************
*******************************************************************************
* create cohort files for w2 stayers
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

*merge on application year
sort unmasked_tin
merge m:1 unmasked_tin using $dtadir/app_dta_post_wfall_nopre00G.dta
keep if _merge==3
keep tin unmasked_tin year applicationyear

*prep  for merge
g refyear  = year
g wageyear = applicationyear 

tempfile tin_year_spine
sort tin
save `tin_year_spine'


*******************************************************************************
* 1.0 SAVE ein - reference year -wage year long file
*******************************************************************************

	*******************************************************************************
	*1.0 LOAD CSV OF EIN-YEAR-worker cohort file
	*******************************************************************************
	local dataset="allworker"
	insheet using $rawdir/`dataset'_stayers.csv, clear	


	*******************************************************************************
	*2.0 get the stayer wages organized into long format indexed by
	* ein/reference year / wage year
	*******************************************************************************
	rename payer_tin_w2_max tin
	keep tin tax_yr wagebill* stayers*
	reshape long wagebill_stayers stayers, i(tin tax_yr) j(wageyear)
	ren tax_yr refyear
	sort tin refyear wageyear

	save $dumpdir/stayers_long.dta, replace



*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************

use `tin_year_spine', clear

*merge to spine
sort tin year
merge 1:1 tin refyear wageyear using $dumpdir/stayers_long.dta
tab _merge
keep if _merge==3
drop _merge

ren wagebill_stayers wb_stay_appyr
ren stayers emp_stay_appyr

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
usd2014, var(wb_stay_appyr) yr(wageyear) 

replace wb_stay_appyr  = 0 if wb_stay_appyr==.
replace emp_stay_appyr = 0 if emp_stay_appyr==.

drop refyear wageyear 
reshape wide wb_stay_appyr emp_stay_appyr, i(unmasked_tin) j(year)
*******************************************************************************
*4.0 SAVE
*******************************************************************************
rename applicationyear year
compress
sort unmasked_tin year
order unmasked_tin year 
save $dtadir/patent_eins_W2stayers_appyr.dta, replace

