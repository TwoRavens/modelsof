***************
***Figure 5****
***************

*****************
*Interstate PRIO*
*****************

use "Datasets/PRIO battle deaths 2009 version with no missing data.dta", clear

keep if type == 2
keep if bdeadbesx > 999

*One of the sides is Muslim
gen MuslimPart = .
replace MuslimPart = 1 if location == "Albania, United Kingdom"
replace MuslimPart = 1 if location == "Afghanistan, Russia (Soviet Union)"
replace MuslimPart = 1 if location == "Algeria, Morocco"
replace MuslimPart = 1 if location == "Australia, Iraq, United Kingdom, United States of America"
replace MuslimPart = 1 if location == "Burkina Faso, Mali"
replace MuslimPart = 1 if inlist(location,"Chad, Libya","Chad, Nigeria")
replace MuslimPart = 1 if location == "Cyprus, Turkey/Ottoman Empire"
replace MuslimPart = 1 if location == "Djibouti, Eritrea"
replace MuslimPart = 1 if inlist(location, "Egypt, Israel","Egypt, United Kingdom","Egypt, France, Israel, United Kingdom")
replace MuslimPart = 1 if inlist(location,"Egypt, Iraq, Israel, Jordan, Lebanon, Syria")
replace MuslimPart = 1 if location == "Ethiopia, Somalia"
replace MuslimPart = 1 if location == "France, Tunisia"
replace MuslimPart = 1 if location == "India, Pakistan"
replace MuslimPart = 1 if location == "Indonesia, Malaysia"
replace MuslimPart = 1 if location == "Indonesia, Netherlands"
replace MuslimPart = 1 if location == "Iran, Iraq"
replace MuslimPart = 1 if location == "Iraq, Kuwait"
replace MuslimPart = 1 if inlist(location, "Israel, Jordan","Israel, Syria")
*replace MuslimPart = 1 if location == "North Korea, South Korea" & year > 1949
replace MuslimPart = 1 if location == "North Yemen, South Yemen"
replace MuslimPart = 1 if location == "South Sudan, Sudan"

keep if MuslimPart == 1
collapse (sum) bdeadbesx, by(year)

save "Datasets/muslim_conflicts_2015_figure5_1.dta", replace

*All interstate battle deaths
use "Datasets/PRIO battle deaths 2009 version with no missing data.dta", clear
keep if type == 2
keep if bdeadbesx > 999
collapse (sum) bdeadbesx, by(year)

save "Datasets/muslim_conflicts_2015_figure5_2.dta", replace

******
*UCDP*
******

***No observations of interstate battle deaths over 1000 after 2004. 

