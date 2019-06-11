
* Open log 
**********
capture log close
log using "Data analysis\Data management\msim-data03-allydyad.log", replace


*******************************************************************************************
* Generation of directed dyadic alliance dataset with variables for binary and valued links
*******************************************************************************************

* Programme:	msim-data03-allydyad.dta
* Project:		Measuring similarity
* Author:		Frank Haege, Department of Politics and Administration, University of Limerick
* Contact:		frank.haege@ul.ie

* Description
*************
* This do-file generates a directed dyadic alliance dataset of all COW state ystem members between 1816 and 2001.
* The input datasets are a directed dyadic State System Membership dataset with information on national material capabilities (msim-data02-weightsysdyad.dta) 
* and the undirected dyadic version (with one record per dyad-year) of the COW Formal Interstate Alliance dataset (v3.03).
* The COW Formal Interstate Alliance dataset was retrieved from http://www.correlatesofwar.org/COW2%20Data/Alliances/Alliance_v3.03_dyadic.zip (12 June 2009).


* Set up Stata
**************
version 11
clear all
macro drop _all
set linesize 80
set more off
set memory 500m


* Load alliance dataset and save it as a Stata file
***************************************************

* Load alliance dataset
insheet using "Datasets\Source\COW alliances\Alliance_v3.03_annual_dyadic_single.csv", clear

* Rename and label variables
label var ccode1 "Country code 1 (COW alliances, v3.03)
label var ccode2 "Country code 2 (COW alliances, v3.03)
label var year "Year"
rename allynum allycode
label var allycode "Alliance code (COW alliances, v3.03)"
rename sstype allytype
label var allytype "Alliance type (Singer & Small scale)"
label def allytypel 1 "Defence" 2 "Neutrality/non-aggression" 3 "Entente"
label val allytype allytypel
drop num_alli version

* Save alliance dataset as Stata file
order year ccode1 ccode2 allytype allycode
sort year ccode1 ccode2
compress
save "Datasets\Derived\msim-data03a-alliances.dta", replace


* Merge the directed dyadic State System Membership dataset including capability weights with the dyadic COW alliance dataset
*****************************************************************************************************************************

* Load directed dyadic dataset of state system members including material capabilities information
use "Datasets\Derived\msim-data02-weightsysdyad.dta", clear
sort year ccode1 ccode2

* Merge the dyadic state system member dataset with the dyadic alliance dataset
merge year ccode1 ccode2 using "Datasets\Derived\msim-data03a-alliances.dta", unique
tab _merge, m
* 1 = Dyad-years for which no alliance existed
* 3 = Dyad-years for which an alliance existed
* All alliance dyad-years were merged with system-membership dyad-years
drop _merge

* Delete years for which no alliance data is available
drop if year == 2001

* Replace missing values in alliance code variable
tab allycode, m
replace allycode = 9999 if allycode == .
notes allycode: The code 9999 denotes the absence of an alliance


* Generate alliance relationship variables
******************************************

* Generate rescaled alliance type variable
tab allytype, m
generate allyvalued = allytype
recode allyvalued (. = 0) (1 = 3) (3 = 1)
label var allyvalued "Alliance (0=No alliance ; 3=Defence pact)"
label def allyvaluedl 0 "No alliance" 1 "Entente" 2 "Neutrality/non-aggression" 3 "Defence"
label val allyvalued allyvaluedl
tab allytype, m
tab allyvalued, m
drop allytype

* Recode ties of countries to themselves as defence pacts
recode allyvalued (0 = 3) if cabb1 == cabb2
note allyvalued: Relationship of country to itself is coded as defence pact
tab allyvalued, m

* Generate a binary alliance variable
generate allybinary = 0
replace allybinary = 1 if allyvalued > 0
label var allybinary "Alliance (no/yes)"
label def yesno 0 "No" 1 "Yes"
label val allybinary yesno
tab allybinary, m

* Save the dyadic alliance dataset
order year cabb1 ccode1 matcap1 cabb2 ccode2 allyvalued allybinary allycode
sort year cabb1 cabb2
compress
save "Datasets\Derived\msim-data03-allydyad.dta", replace


* Exit do-file
log close
exit





