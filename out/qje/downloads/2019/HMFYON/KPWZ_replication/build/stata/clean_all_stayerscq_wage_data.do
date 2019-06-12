
local firstyear = 1996
local lastyear  = 2014

*******************************************************************************
*1.0 LOAD EIN-YEAR PAIRS OF INTEREST
*******************************************************************************
use $dtadir/app_dta_post_wfall_nopre00G.dta, clear
keep unmasked_tin applicationyear

tempfile ein_list_appdata
sort unmasked_tin applicationyear
save `ein_list_appdata'

forv i=1/4{
*******************************************************************************
* 1.1 Load stayers data for all workers and rename to match old file names
*******************************************************************************
use $dumpdir/outcomes_patent_eins_w2_stayercq`i'.dta, clear
rename year applicationyear

*drop old wages
drop oldwagecq*

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
usd2014, var(wagecq`i'_stay`y') yr(y) 
drop y
}
*******************************************************************************
* 3. reshape to match other stayer file format
*******************************************************************************

rename applicationyear year
*******************************************************************************
* 4. clean up variable names and save
*******************************************************************************

compress
sort unmasked_tin year
saveold $dtadir/patent_eins_W2stayerscq`i'.dta, replace
}

