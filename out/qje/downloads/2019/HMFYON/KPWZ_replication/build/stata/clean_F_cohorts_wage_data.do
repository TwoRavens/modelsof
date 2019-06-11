
local firstyear = 1999
local lastyear  = 2014

*******************************************************************************
*1.0 LOAD EIN-YEAR PAIRS OF INTEREST
*******************************************************************************
use $dtadir/app_dta_post_wfall_nopre00G.dta, clear
keep unmasked_tin applicationyear

tempfile ein_list_appdata
sort unmasked_tin applicationyear
save `ein_list_appdata'

*******************************************************************************
* 1.1 Load cohort data for all workers and rename to match old file names
*******************************************************************************
use $dumpdir/outcomes_patent_eins_w2_cht_female.dta, clear
rename year applicationyear

drop wage_cht_F_1996
drop wage_cht_F_1997
drop wage_cht_F_1998

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
usd2014, var(wage_cht_F_`y') yr(y) 
drop y
}

*******************************************************************************
* 3. WINZORIZE output vars
*******************************************************************************

*REPLACE FOR MISSING EMP
forv y=`firstyear'/`lastyear'{
replace wage_cht_F_`y' = . if wage_cht_F_`y'==0
}

*******************************************************************************
* 4. clean up variable names and save
*******************************************************************************

rename applicationyear year
compress
sort unmasked_tin year
save $dtadir/patent_eins_W2_cht_F.dta, replace
