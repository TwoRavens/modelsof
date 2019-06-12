
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
use $dumpdir/outcomes_patent_eins_w2_cht_all.dta, clear
forv y=`firstyear'/`lastyear'{
rename wb_all`y' wagebill`y'
g zerowages`y'=cht_all - emp_all`y'
}
rename cht_all employees
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
usd2014, var(wagebill`y') yr(y) 
drop y
}

*******************************************************************************
* 3. WINZORIZE output vars
*******************************************************************************
foreach var in wagebill{

	forv y=`firstyear'/`lastyear'{

	*REPLACE MISSING WITH ZEROS
	replace `var'`y' = 0 if `var'`y'==.
	}

}

foreach var in zerowages{

	forv y=`firstyear'/`lastyear'{

	*REPLACE MISSING WITH ZEROS
	replace `var'`y' = 0 if `var'`y'==.
	}

}


*REPLACE MISSING WITH ZEROS
replace employees = 0 if employees==.


*******************************************************************************
* 4. clean up variable names and save
*******************************************************************************

rename employees cht
forv y=`firstyear'/`lastyear'{
capture rename wagebill`y' wb_cht`y'
capture rename zerowages`y' zero_cht`y'
}
rename applicationyear year
drop emp_all*
compress
sort unmasked_tin year
saveold $dtadir/patent_eins_W2allcohorts.dta, replace
