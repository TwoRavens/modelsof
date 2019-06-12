
local firstyear = 1996
local lastyear  = 2014

set more off
*******************************************************************************
*1.0 LOAD EIN-YEAR PAIRS OF INTEREST
*******************************************************************************
use $dtadir/app_dta_post_wfall_nopre00G.dta, clear
keep unmasked_tin applicationyear

tempfile ein_list_appdata
sort unmasked_tin applicationyear
save `ein_list_appdata'

*******************************************************************************
* 1.1 Load stayers data for all workers and rename to match old file names
*******************************************************************************
use $dumpdir/outcomes_patent_eins_w2_stayers_type_allworker.dta, clear
rename year applicationyear

*******************************************************************************
* 1.2 Keep ein-application years of interest
*******************************************************************************
sort unmasked_tin applicationyear
merge m:1 unmasked_tin applicationyear using `ein_list_appdata'
tab _merge
keep if _merge==3
drop _merge

*******************************************************************************
* 2. Adjust for Inflation
*******************************************************************************
forv y=`firstyear'/`lastyear'{
g y=`y'
usd2014, var(wage_stayersM`y') yr(y)
usd2014, var(wage_stayersF`y') yr(y)
usd2014, var(wage_stayers_inv`y') yr(y)
usd2014, var(wage_stayers_noninv`y') yr(y)
drop y
}


rename applicationyear year
*******************************************************************************
* 3. clean up variable names and save
*******************************************************************************

compress
sort unmasked_tin year
saveold $dtadir/patent_eins_W2stayers_type.dta, replace
