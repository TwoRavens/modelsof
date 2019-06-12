
* Open log 
**********
capture log close
log using "Data analysis\Data management\msim-data01-sysdyad.log", replace


*****************************************************************
* Generation of a directed dyadic system member dataset 1816-2001
*****************************************************************

* Programme:	msim-data01-sysdyad.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file generates a dataset of directed dyads of all COW state system members between 1816 and 2001.
* The input dataset is the system version of the COW State System Membership List (v2004.1).
* The State System Membership dataset was retrieved from http://correlatesofwar.org/COW2%20Data/SystemMembership/system2004.csv (8 January 2008).


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off


* Import COW State System dataset and save as Stata file
********************************************************

* Import State System dataset
insheet using "Datasets\Source\COW system membership\system2004.csv", clear

* Rename and label variables
rename stateabb cabb
label var cabb "Country abbreviation (COW state system membership, v2004.1)"
rename statenum ccode
label var ccode "Country code (COW state system membership, v2004.1)"

* Save as Stata dataset
order year cabb ccode
sort cabb year
compress
save "Datasets\Derived\msim-data01a-sysmemb.dta", replace


* Open COW system membership dataset
************************************
use "Datasets\Derived\msim-data01a-sysmemb.dta", clear
sort year ccode
drop version


* Generate a dyadic dataset of system members for each year
***********************************************************
* Because Intercooled Stata allows only 2047 variables, the dyadic dataset is first created for each individual year.
* The resulting dyadic datasets for each year are subsequently merged into a single dataset covering the whole period.

* Run the following commands for each year
foreach x of numlist 1816/2004 {
	
	* Keep the full dataset in memory while transforming the data for individual years
	preserve

	* Save the data for the respective year in long format
	drop if year ~= `x'
	sort year
	save "Datasets\Derived\Individual years\System membership\Monads\msim-data01-sysmemb`x'-long.dta", replace

	* Transpose the data for the respective year from long to wide format and save the resulting dataset
	rename cabb _varname
	xpose, clear varname
	drop _varname
	drop if _n == 1
	foreach y of varlist _all {
		replace `y' = 0 if `y' ~= .
		rename `y' tie`y'
	}
	generate year = `x'
	order year
	sort year
	save "Datasets\Derived\Individual years\System membership\Monads\msim-data01-sysmemb`x'-wide.dta", replace

	* Merge the long format data of the respective year with the wide format to yield a square (socio-)matrix
	use "Datasets\Derived\Individual years\System membership\Monads\msim-data01-sysmemb`x'-long.dta", clear
	merge year using "Datasets\Derived\Individual years\System membership\Monads\msim-data01-sysmemb`x'-wide.dta", uniqusing
	drop _merge

	* Reshape the square matrix into long format to yield a dyadic dataset
	rename cabb cabb1
	rename ccode ccode1
	reshape long tie, i(cabb1) j(cabb2) string
	rename cabb2 cabb
	sort cabb year

	* Merge the dyadic dataset for the respective year again with the COW State System Membership dataset
	* This merge yields a country code variable for the second dyad member
	merge cabb year using "Datasets\Derived\msim-data01a-sysmemb.dta", uniqusing
	drop if year ~= `x'
	rename cabb cabb2
	rename ccode ccode2
	order year cabb* ccode*
	drop tie-_merge
	compress
	sort year ccode1 ccode2
	label var cabb1 "Country abbreviation 1 (COW state system membership, v2004.1)"
	label var cabb2 "Country abbreviation 2 (COW state system membership, v2004.1)"
	label var ccode1 "Country code 1 (COW state system membership, v2004.1)"
	label var ccode2 "Country code 2 (COW state system membership, v2004.1)"	
	save "Datasets\Derived\Individual years\System membership\Dyads\msim-data01-sysdyad`x'.dta", replace

	* Restore the full dataset to rerun the whole procedure for the following year until all yearly datasets are created
	restore
	
}


* Stack the yearly directed dyadic datasets
*******************************************
* This procedure generates a directed dyadic dataset covering the whole period

* Open the dyadic dataset for the first year
use "Datasets\Derived\Individual years\System membership\Dyads\msim-data01-sysdyad1816.dta", clear

* Append the other yearly dyadic datasets to the dataset of the first year
foreach x of numlist 1817/2004 {
	append using "Datasets\Derived\Individual years\System membership\Dyads\msim-data01-sysdyad`x'.dta"
}


* Save the directed dyadic dataset of system members
****************************************************
* Note: This dataset covers the period from 1816 to 2004 and includes two observation for each dyad (one for each direction)
sort year ccode1 ccode2
compress
save "Datasets\Derived\msim-data01-sysdyad.dta", replace
log close

