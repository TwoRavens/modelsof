
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
use $dumpdir/outcomes_patent_eins_w2_stayers_noninventor.dta, clear

forv y=`firstyear'/`lastyear'{
rename wb_stay_noninventor`y' wb_stay_noninv`y'
rename stay_noninventor`y' emp_stay_noninv`y'
}
*base level of employment 
drop stayers_noninventor

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
usd2014, var(wb_stay_noninv`y') yr(y) 
drop y
}

*******************************************************************************
* 3. WINZORIZE output vars
*******************************************************************************
foreach var in wb_stay_noninv {

forv y=`firstyear'/`lastyear'{
g y=`y'
*qui winzorize_by_year, var(`var'`y') pct(2) yr(y)
drop y

*REPLACE MISSING WITH ZEROS
replace `var'`y' = 0 if `var'`y'==.
}

}

foreach var in emp_stay_noninv {

forv y=`firstyear'/`lastyear'{
g y=`y'
**qui winzorize_by_year, var(`var'`y') pct(5) yr(y)
drop y

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
saveold $dtadir/patent_eins_W2stayers_noninv.dta, replace
