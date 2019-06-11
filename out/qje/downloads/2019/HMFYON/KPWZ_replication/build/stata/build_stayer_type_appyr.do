
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
	insheet using $rawdir/new_stayer_vars.csv, clear	

	
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


	*******************************************************************************
	*2.0 get the stayer wages organized into long format indexed by
	* ein/reference year / wage year
	*******************************************************************************
	rename payer_tin_w2_max tin
	keep tin tax_yr wage* stayers*
	reshape long wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv stayersM stayersF stayers_inv stayers_noninv, i(tin tax_yr) j(wageyear)
	ren tax_yr refyear
	sort tin refyear wageyear

	save $dumpdir/stayers_type_long.dta, replace



*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************

use `tin_year_spine', clear

*merge to spine
sort tin year
merge 1:1 tin refyear wageyear using $dumpdir/stayers_type_long.dta
tab _merge
keep if _merge==3
drop _merge

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
usd2014, var(wage_stayersM) yr(wageyear) 
usd2014, var(wage_stayersF) yr(wageyear) 
usd2014, var(wage_stayers_inv) yr(wageyear) 
usd2014, var(wage_stayers_noninv) yr(wageyear) 



replace stayersM	   = 0 if stayersM==.
replace wage_stayersM  = . if stayersM==0
replace stayersF	   = 0 if stayersF==.
replace wage_stayersF  = . if stayersF==0

replace stayers_inv 	      = 0 if stayers_inv==.
replace wage_stayers_inv      = . if stayers_inv==.
replace stayers_noninv 	      = 0 if stayers_noninv==.
replace wage_stayers_noninv   = . if stayers_noninv==.

drop refyear wageyear 

foreach var in wage_stayersM wage_stayersF wage_stayers_inv wage_stayers_noninv stayersM stayersF stayers_inv stayers_noninv{
rename `var' `var'_appyr
}

forv y=`firstyear'/`lastyear' {
capture drop stayers`y'
}

reshape wide wage_stayersM_appyr wage_stayersF_appyr wage_stayers_inv_appyr wage_stayers_noninv_appyr stayersM_appyr stayersF_appyr stayers_inv_appyr stayers_noninv_appyr, i(unmasked_tin) j(year)
*******************************************************************************
*4.0 SAVE
*******************************************************************************
rename applicationyear year
compress
sort unmasked_tin year
order unmasked_tin year 
save $dtadir/patent_eins_W2stayers_type_appyr.dta, replace

