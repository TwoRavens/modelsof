
* Open log 
**********
capture log close
log using "Data analysis\Data management\msim-data10-simdata.log", replace


* **************************************************************************************************************************************************
* Generate directed and undirected dyadic datasets of component variables for the calculation of similarity measures covering the entire time period 
* **************************************************************************************************************************************************

* Programme:	msim-data10-simdata.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file stacks the yearly dyadic datasets of component variables for the calculation of similarity measures
* (i.e. all files of the form msim-data09-votesimvalued-YEAR.dta, msim-data08-allysimbinary-YEAR.dta, and msim-data07-allysimvalued-YEAR.dta)
* As a result, three dyadic datasets, one based on valued alliance ties, one based on binary alliance ties, and one based on UN voting data are generated.
* The time coverage of the alliance datasets ranges from 1816 to 2000 and the coverage of the UN voting dataset from 1946 to 2004.


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off


* Prepare state system membership data for merge
use "Datasets\Derived\msim-data01a-sysmemb.dta", clear
sort year cabb
save "Datasets\Derived\msim-data01a-sysmemb.dta", replace


* Valued alliance data
**********************
         
* Load dataset for first year
use "Datasets\Derived\Individual years\Alliances\Valued\Similarity\msim-data07-allysimvalued-1816.dta", clear

* Append the remaining yearly datasets
foreach year of numlist 1817/2000 {
	append using "Datasets\Derived\Individual years\Alliances\Valued\Similarity\msim-data07-allysimvalued-`year'.dta" 
}

* Merge data with state system membership data on first dyad country
rename cabb1 cabb
sort year cabb
merge year cabb using "Datasets\Derived\msim-data01a-sysmemb.dta", uniqusing
tab _merge, m
drop if year > 2000
drop _merge
rename cabb cabb1
rename ccode ccode1
label var ccode1 "Country code 1 (COW state system membership, v2004.1)"

* Merge data with state system membership data on second dyad country
rename cabb2 cabb
sort year cabb
merge year cabb using "Datasets\Derived\msim-data01a-sysmemb.dta", 
tab _merge, m
drop if year > 2000
drop _merge
rename cabb cabb2
rename ccode ccode2
label var ccode2 "Country code 2 (COW state system membership, v2004.1)"

* Save as directed dyad dataset (with two observations per dyad)
order year nobs tnobs cabb1 ccode1 cabb2 ccode2
sort year ccode1 ccode2
compress
save "Datasets\Derived\msim-data10b-allysimvalued2.dta", replace


* Drop one of the observations per dyad
***************************************

* Drop second dyad observation
sort year ccode1 ccode2
by year: drop if ccode1 > ccode2

* Generate number of dyads variable
by year: generate ndyads = _N
label var ndyads "No. of dyads"

* Check number of dyads per year
generate ndyads2 = (nobs*(nobs-1))/2 + nobs
assert ndyads == ndyads2
* The number of dyads per year has the expected value
drop ndyads2

* Save as undirected dyad dataset (with one obseration per dyad)
order year nobs tnobs ndyads cabb1 ccode1 cabb2 ccode2
compress
save "Datasets\Derived\msim-data10a-allysimvalued1.dta", replace


* Binary alliance data
**********************
         
* Load dataset for first year
use "Datasets\Derived\Individual years\Alliances\Binary\Similarity\msim-data08-allysimbinary-1816.dta", clear


* Append the remaining yearly datasets
foreach year of numlist 1817/2000 {
	append using "Datasets\Derived\Individual years\Alliances\Binary\Similarity\msim-data08-allysimbinary-`year'.dta" 
}

* Merge data with system membership data on first dyad country
rename cabb1 cabb
sort year cabb
merge year cabb using "Datasets\Derived\msim-data01a-sysmemb.dta", uniqusing
tab _merge, m
drop if year > 2000
drop _merge
rename cabb cabb1
rename ccode ccode1
label var ccode1 "Country code 1 (COW state system membership, v2004.1)"

* Merge master data with system membership data on second dyad country
rename cabb2 cabb
sort year cabb
merge year cabb using "Datasets\Derived\msim-data01a-sysmemb.dta", 
tab _merge, m
drop if year > 2000
drop _merge
rename cabb cabb2
rename ccode ccode2
label var ccode2 "Country code 2 (COW state system membership, v2004.1)"

* Save as directed dyad dataset (with two observations per dyad)
compress
save "Datasets\Derived\msim-data10d-allysimbinary2.dta", replace


* Drop one of the observations per dyad
***************************************

* Drop second dyad observation
sort year ccode1 ccode2
by year: drop if ccode1 > ccode2

* Generate number of dyads variable
by year: generate ndyads = _N
label var ndyads "No. of dyads"

* Check number of dyads per year
generate ndyads2 = (nobs*(nobs-1))/2 + nobs
assert ndyads == ndyads2
* The number of dyads per year has the expected value
drop ndyads2

* Save as undirected dyad dataset (with one obseration per dyad)
order year nobs tnobs ndyads cabb1 ccode1 cabb2 ccode2
compress
save "Datasets\Derived\msim-data10c-allysimbinary1.dta", replace


* Valued UN voting data
***********************
         
* Load dataset for first year
use "Datasets\Derived\Individual years\UN voting\Valued\Similarity\msim-data09-votesimvalued-1946.dta", clear


* Append the remaining yearly datasets
foreach year of numlist 1947/1963 1965/2004 {
	append using "Datasets\Derived\Individual years\UN voting\Valued\Similarity\msim-data09-votesimvalued-`year'.dta" 
}

* Merge data with system membership data on first dyad country
rename cabb1 cabb
sort year cabb
merge year cabb using "Datasets\Derived\msim-data01a-sysmemb.dta", uniqusing
tab _merge, m
drop if year > 2004 | year < 1946
drop if _merge == 2
drop _merge
rename cabb cabb1
rename ccode ccode1
label var ccode1 "Country 1 code (COW)"

* Merge master data with system membership data on second dyad country
rename cabb2 cabb
sort year cabb
merge year cabb using "Datasets\Derived\msim-data01a-sysmemb.dta", 
tab _merge, m
drop if year > 2004 | year < 1946
drop if _merge == 2
drop _merge
rename cabb cabb2
rename ccode ccode2
label var ccode2 "Country 2 code (COW)"

* Save as directed dyad dataset (with two observations per dyad)
compress
save "Datasets\Derived\msim-data10f-votesimvalued2.dta", replace


* Drop one of the observations per dyad
***************************************

* Drop second dyad observation
sort year ccode1 ccode2
by year: drop if ccode1 > ccode2

* Generate number of dyads variable
by year: generate ndyads = _N
label var ndyads "No. dyads"

* Check number of dyads per year
generate ndyads2 = (ncountry*(ncountry-1))/2 + ncountry
assert ndyads == ndyads2
* The number of dyads per year has the expected value
drop ndyads2

* Save as undirected dyad dataset (with one obseration per dyad)
order year nobs tnobs ndyads cabb1 ccode1 cabb2 ccode2
save "Datasets\Derived\msim-data10e-votesimvalued1.dta", replace


* Exit do-file
log close
exit
