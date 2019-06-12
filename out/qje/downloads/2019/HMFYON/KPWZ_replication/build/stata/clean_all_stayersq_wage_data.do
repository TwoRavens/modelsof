
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
use $dumpdir/outcomes_patent_eins_w2_stayers_allworkerq`i'.dta, clear

*base level of employment 
*drop qsize`i'
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
usd2014, var(wage_stayq`i'`y') yr(y) 
drop y
}

*******************************************************************************
* 3. WINZORIZE output vars
*******************************************************************************

foreach var in stayersq`i' {

forv y=`firstyear'/`lastyear'{
g y=`y'
**qui winzorize_by_year, var(`var'`y') pct(5) yr(y)
drop y

*REPLACE MISSING WITH ZEROS
replace `var'`y' = 0 if `var'`y'==.
}

}


foreach var in wage_stayq`i' {

forv y=`firstyear'/`lastyear'{
g y=`y'
*qui winzorize_by_year, var(`var'`y') pct(2) yr(y)
drop y

*REPLACE MISSING 
replace `var'`y' = . if stayersq`i'`y'==0
}

}

*******************************************************************************
* 4. clean up variable names and save
*******************************************************************************

rename applicationyear year

compress
sort unmasked_tin year
saveold $dtadir/patent_eins_W2stayersq`i'.dta, replace
}

