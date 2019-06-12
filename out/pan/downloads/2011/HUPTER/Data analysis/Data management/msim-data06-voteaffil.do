
* Open log 
**********
capture log close
log using "Data analysis\Data management\msim-data06-voteaffil.log", replace


******************************************************************************
* Generate roll call vote affiliation matrices for valued voting relationships
******************************************************************************

* Programme:	msim-data06-voteaffil.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file reshapes the UN voting record dataset (msim-data05-voterecord.dta) into wide format.
* It generates datasets in the form of valued roll call vote affiliation-matrices for individual years and the entire time period.


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off

* Load dataset and prepare it for reshaping
use "Datasets\Derived\msim-data05-voterecord.dta", clear
drop ccode version

* Generate valued voting variable
tab votetype, m
generate votevalued = .
* Absenteism is equivalent to abstaining
replace votevalued = 1 if votetype == 3
replace votevalued = 2 if votetype == 2 | votetype == 8
replace votevalued = 3 if votetype == 1
note votevalued: 'Absent' has been recoded to 'Abstain'
label var votevalued "Type of vote"
label def votevaluedl 1 "1 No" 2 "2 Abstain" 3 "3 Yes"
label val votevalued votevaluedl
tab votetype votevalued
drop votetype


* Generate valued roll call by country affiliation matrix for individual years
******************************************************************************

* Loop through each roll call vote
* No roll call votes in 1964!
foreach x of numlist 1946/1963 {
	
	* Keep the full dataset in memory while transforming the data for individual years
	preserve

	* Reshape the data for the respective year into wide format
	drop if year ~= `x'
	reshape wide votevalued, i(rccode) j(cabb) string

	* Delete 'votevalued' from variable names and labels
	unab vars : votevalued*
	local a : subinstr local vars "votevalued" "", all
	foreach y of local a {
		label var votevalued`y' `y'
	}
	foreach y of local a {
		rename votevalued`y' `y'
	}

	* Save the roll call vote by country affiliation matrix for the respective year
	order session rccode rccode_orig unres date day month year
	sort rccode
	compress
	save "Datasets\Derived\Individual years\UN voting\Valued\msim-data06a-votevalued-`x'.dta", replace

	restore

}

foreach x of numlist 1965/2004 {
	
	* Keep the full dataset in memory while transforming the data for individual years
	preserve

	* Reshape the data for the respective year into wide format
	drop if year ~= `x'
	reshape wide votevalued, i(rccode) j(cabb) string

	* Delete 'votevalued' from variable names and labels
	unab vars : votevalued*
	local a : subinstr local vars "votevalued" "", all
	foreach y of local a {
		label var votevalued`y' `y'
	}
	foreach y of local a {
		rename votevalued`y' `y'
	}

	* Save the roll call vote by country affiliation matrix for the respective year
	order session rccode rccode_orig unres date day month year
	sort rccode
	compress
	save "Datasets\Derived\Individual years\UN voting\Valued\msim-data06a-votevalued-`x'.dta", replace

	restore

}


* Generate valued roll call by country affiliation matrix for entire period
***************************************************************************

* Reshape the data into wide format
reshape wide votevalued, i(rccode) j(cabb) string

* Delete 'votevalued' from variable names and labels
unab vars : votevalued*
local a : subinstr local vars "votevalued" "", all
foreach y of local a {
	label var votevalued`y' `y'
}
foreach y of local a {
	rename votevalued`y' `y'
}

* Save the roll call vote by country affiliation matrix for the entire period
order session rccode rccode_orig unres date day month year
sort rccode
compress
save "Datasets\Derived\msim-data06a-votevalued.dta", replace


* Exit do-file
log close
exit
