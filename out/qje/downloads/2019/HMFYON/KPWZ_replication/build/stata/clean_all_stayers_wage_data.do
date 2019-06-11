
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
* 1.1 Load stayers data for all workers and rename to match old file names
*******************************************************************************
use $dumpdir/outcomes_patent_eins_w2_stayers_allworker.dta, clear

forv y=`firstyear'/`lastyear'{
rename wb_stay_allworker`y' wb_stay`y'
rename stay_allworker`y' emp_stay`y'
}
*base level of employment 
drop stayers_allworker

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
usd2014, var(wb_stay`y') yr(y) 
drop y
}

*******************************************************************************
* 3. WINZORIZE output vars
*******************************************************************************
foreach var in wb_stay {

forv y=`firstyear'/`lastyear'{
*REPLACE MISSING WITH ZEROS
replace `var'`y' = 0 if `var'`y'==.
}

}

foreach var in emp_stay {

forv y=`firstyear'/`lastyear'{

*REPLACE MISSING WITH ZEROS
replace `var'`y' = 0 if `var'`y'==.
}

}

*******************************************************************************
* 4. clean up variable names and save
*******************************************************************************

rename applicationyear year

compress
sort unmasked_tin year
saveold $dtadir/patent_eins_W2stayers.dta, replace
