
* Open log 
**********
capture log close
log using "Data analysis\Data management\msim-data04-allysocio.log", replace


* ***************************************************************************
* Generate square socio-matrices for binary and valued alliance relationships
* ***************************************************************************

* Programme:	msim-data04-allysocio.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file reshapes the directed dyadic alliance dataset (msim-data03-allydyad.dta) into wide format.
* It generates datasets in the form of binary and valued alliance socio-matrices for individual years and the entire time period.


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off


* Generate a valued alliance socio-matrix for the entire time period
********************************************************************

* Load directed dyadic alliance dataset
use "Datasets\Derived\msim-data03-allydyad.dta", clear

* Reshape the data into a square socio-matrix
drop ccode2 allybinary allycode
reshape wide allyvalued, i(year cabb1) j(cabb2) string
order year cabb1 ccode1 matcap1

* Rename and label variables
rename cabb1 cabb
label var cabb "Country abbreviation (COW state system membership, v2004.1)"
rename ccode1 ccode
label var ccode "Country code (COW state system membership, v2004.1)"
rename matcap1 matcap
label var matcap "National material capabilities (COW, v3.02)"

* Delete 'allyvalued' from variable names and labels
unab vars : allyvalued*
local a : subinstr local vars "allyvalued" "", all
foreach y of local a {
	label var allyvalued`y' `y'
}
foreach y of local a {
	rename allyvalued`y' `y'
}

* Save the valued alliance socio-matrix as a dataset
sort year cabb
compress
save "Datasets\Derived\msim-data04a-allyvalued.dta", replace


* Generate a valued alliance socio-matrix for each year
*******************************************************

* Load directed dyadic alliance dataset
use "Datasets\Derived\msim-data03-allydyad.dta", clear

* Run the following commands for each year
foreach x of numlist 1816/2000 {
	
	* Keep the full dataset in memory while transforming the data for individual years
	preserve

	* Reshape the data for the respective year into a square socio-matrix
	drop if year ~= `x'
	drop ccode2 allybinary allycode
	reshape wide allyvalued, i(year cabb1) j(cabb2) string
	order year cabb1 ccode1 matcap1

	* Rename and label variables
	rename cabb1 cabb
	label var cabb "Country abbreviation (COW system membership, v2004.1)"
	rename ccode1 ccode
	label var ccode "Country code (COW system membership, v2004.1)"
	rename matcap1 matcap
	label var matcap "Material capabilities (COW, v3.02)"

	* Delete 'allyvalued' from variable names and labels
	unab vars : allyvalued*
	local a : subinstr local vars "allyvalued" "", all
	foreach y of local a {
		label var allyvalued`y' `y'
	}
	foreach y of local a {
		rename allyvalued`y' `y'
	}

	* Save the valued socio-matrix for the respective year as a dataset
	sort year cabb
	compress
	save "Datasets\Derived\Individual years\Alliances\Valued\msim-data04a-allyvalued-`x'.dta", replace

	restore

}


* Generate a binary alliance socio-matrix for the entire period
***************************************************************

* Load directed dyadic alliance dataset
use "Datasets\Derived\msim-data03-allydyad.dta", clear

* Reshape the data into a square socio-matrix
drop ccode2 allyvalued allycode
reshape wide allybinary, i(year cabb1) j(cabb2) string
order year cabb1 ccode1 matcap1

* Rename and label variables
rename cabb1 cabb
label var cabb "Country abbreviation (COW system membership, v2004.1)"
rename ccode1 ccode
label var ccode "Country code (COW system membership, v2004.1)"
rename matcap1 matcap
label var matcap "National Material Capabilities (COW, v3.02)"

* Delete 'allybinary' from variable names and labels
unab vars : allybinary*
local a : subinstr local vars "allybinary" "", all
foreach y of local a {
	label var allybinary`y' `y'
}
foreach y of local a {
	rename allybinary`y' `y'
}

* Save the binary socio-matrix as a dataset
sort year cabb
compress
save "Datasets\Derived\msim-data04b-allybinary.dta", replace


* Generate a binary alliance socio-matrix for each year
*******************************************************

* Load directed dyadic alliance dataset
use "Datasets\Derived\msim-data03-allydyad.dta", clear

* Run the following commands for each year
foreach x of numlist 1816/2000 {
	
	* Keep the full dataset in memory while transforming the data for individual years
	preserve

	* Reshape the data into a square socio-matrix
	drop if year ~= `x'
	drop ccode2 allyvalued allycode
	reshape wide allybinary, i(year cabb1) j(cabb2) string
	order year cabb1 ccode1 matcap1
	
	* Rename and label variables
	rename cabb1 cabb
	label var cabb "Country abbreviation (COW system membership, v2004.1)"
	rename ccode1 ccode
	label var ccode "Country code (COW system membership, v2004.1)"
	rename matcap1 matcap
	label var matcap "Material capabilities (COW, v3.02)"
	
	* Delete 'allybinary' from variable names and labels
	unab vars : allybinary*
	local a : subinstr local vars "allybinary" "", all
	foreach y of local a {
		label var allybinary`y' `y'
	}
	foreach y of local a {
		rename allybinary`y' `y'
	}

	* Save the binary socio-matrix for the respective year as a dataset
	sort year cabb
	compress
	save "Datasets\Derived\Individual years\Alliances\Binary\msim-data04b-allybinary-`x'.dta", replace
	
	restore

}

log close
exit
