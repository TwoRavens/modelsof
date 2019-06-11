
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
* 1.1 Load cht data for all workers 
*******************************************************************************
use $dumpdir/outcomes_patent_eins_w2_chq`i'.dta, clear

rename n_chtq qsize`i'
rename year applicationyear

*******************************************************************************
* 1.2 Keep ein-application years of interest
*******************************************************************************
sort unmasked_tin applicationyear
merge 1:1 unmasked_tin applicationyear using `ein_list_appdata'
tab _merge
keep if _merge==3
drop _merge

*******************************************************************************
* 2. Adjust for Inflation
*******************************************************************************
forv y=`firstyear'/`lastyear'{
g y=`y'
usd2014, var(wage_cht_q`i'_`y') yr(y) 
drop y
}

*******************************************************************************
* 3. clean up variable names and save
*******************************************************************************

rename applicationyear year

drop wage_cht_q`i'_1996
drop wage_cht_q`i'_1997
drop wage_cht_q`i'_1998

compress
sort unmasked_tin year
save $dtadir/patent_eins_W2chtq`i'.dta, replace
}

