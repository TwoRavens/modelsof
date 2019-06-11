
* Open log 
**********
capture log close
log using "Data analysis\Data management\msim-data02-weightsysdyad.log", replace


* ***************************************************************************************
* Merge of directed State System Membership data with National Material Capabilities data
* ***************************************************************************************

* Programme:	msim-data02-weightsysdyad.do
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* The directed dyadic State System Membership dataset (msim-data01-sysdyad.dta) is merged with the COW National Material Capabilities dataset (v3.02).
* The National Material Capabilities dataset was retrieved from http://correlatesofwar.org/COW2%20Data/Capabilities/NMC_3.02.csv (15 January 2008).


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off


* Prepare material capabilities dataset for merge
*************************************************

* Import material capabilities data and save as Stata file
insheet using "Datasets\Source\COW material capabilities\NMC_3.02.csv", clear

* Rename and label variables
label var year "Year"
label var ccode "Country code (COW national material capabilities, v3.02)"
rename stateabb cabb1
label var cabb1 "Country abbreviation (COW national material capabilities, v3.02)"
rename cinc matcap
label var matcap "National material capabilities (COW, v3.02)"
order year cabb ccode matcap
drop irst-version

* Save dataset
sort year ccode
compress
save "Datasets\Derived\msim-data02a-matcap.dta", replace


* Merge the directed dyadic data set of system membership with the material capabilities data
*********************************************************************************************

* Load dyadic system membership data set and prepare for merge
use "Datasets\Derived\msim-data01-sysdyad.dta", clear
rename ccode1 ccode
sort year ccode 

* Merge the system membership with material capabilities data on country code variable for first dyad member
merge year ccode using "Datasets\Derived\msim-data02a-matcap.dta", uniqusing
rename ccode ccode1
rename matcap matcap1
label var matcap1 "National material capabilities 1 (COW, v3.02)"
tab _merge, m

* Drop years for which no material capability data is available
tab year if _merge == 1
drop if _merge == 1
drop _merge

* Save the directed dyadic dataset of system members with material capability variable
order year cabb1 ccode1 matcap1
sort year ccode1 ccode2
compress
save "Datasets\Derived\msim-data02-weightsysdyad.dta", replace


* Exit do-file
log close
exit
