**************
***Figure 4***
**************

use "Datasets/PRIO battle deaths 2009 version with no missing data.dta", clear

drop if type == 1
drop if type == 2
keep if bdeadbesx > 999

**********************
***Muslim countries***
**********************

gen MuslimShare = .

gen MuslimDum = .

gen MuslimPart = .

*Afghanistan
replace MuslimShare = 99.7 if location == "Afghanistan"
replace MuslimDum = 1 if location == "Afghanistan"
replace MuslimPart = 1 if location == "Afghanistan, Russia (Soviet Union)"

*Algeria
replace MuslimShare = 97.9 if location == "Algeria"
replace MuslimDum = 1 if location == "Algeria"
replace MuslimPart = 2 if location == "Algeria, Morocco"

*Australia, Iraq, United Kingdom, United States
replace MuslimPart = 1 if location == "Australia, Iraq, United Kingdom, United States of America"

*Azerbaijan
replace MuslimShare = 96.9 if location == "Azerbaijan"
replace MuslimDum = 1 if location == "Azerbaijan"

*Bangladesh
replace MuslimShare = 89.8 if location == "Bangladesh"
replace MuslimDum = 1 if location == "Bangladesh"

*Bosnia-Herzegovina
*replace MuslimShare = 45.2 if location == "Bosnia-Herzegovina"
*replace MuslimDum = 1 if location == "Bosnia-Herzegovina"

*Brunei
replace MuslimShare = 75.1 if location == "Brunei"
replace MuslimDum = 1 if location == "Brunei"

*Burkina Faso
replace MuslimShare = 61.6 if location == "Burkina Faso"
replace MuslimDum = 1 if location == "Burkina Faso"
replace MuslimPart = 2 if location == "Burkina Faso, Mali"

*Chad
replace MuslimShare = 55.3 if location == "Chad"
replace MuslimDum = 1 if location == "Chad"
replace MuslimPart = 2 if inlist(location,"Chad, Libya","Chad, Nigeria")

*Comoros
replace MuslimShare = 98.3 if location == "Comoros"
replace MuslimDum = 1 if location == "Comoros"

*Cyprus, Turkey
replace MuslimPart = 1 if location == "Cyprus, Turkey"

*Djibouti
replace MuslimShare = 96.9 if location == "Djibouti"
replace MuslimDum = 1 if location == "Djibouti"
replace MuslimPart = 1 if location == "Djibouti, Eritrea"

*Egypt
replace MuslimShare = 94.9 if location == "Egypt"
replace MuslimDum = 1 if location == "Egypt"
replace MuslimPart = 1 if inlist(location, "Egypt, Israel","Egypt, United Kingdom","Egypt, France, Israel, United Kingdom")
replace MuslimPart = 3 if inlist(location,"Egypt, Iraq, Israel, Jordan, Lebanon, Syria")

*Ethiopia, Somalia
replace MuslimPart = 1 if location == "Ethiopia, Somalia"

*France, Tunisia
replace MuslimPart = 1 if location == "France, Tunisia"

*Gambia
replace MuslimShare = 95.1 if location == "Gambia"
replace MuslimDum = 1 if location == "Gambia"

*Guinea 
replace MuslimShare = 84.4 if location == "Guinea"
replace MuslimDum = 1 if location == "Guinea"

*Guinea-Bissau
replace MuslimShare = 45.1 if location == "Guinea-Bissau"
*!!OBSOBS!!!*
replace MuslimDum = 1 if location == "Guinea-Bissau"

*India, Pakistan
replace MuslimPart = 1 if location == "India, Pakistan"

*Indonesia
replace MuslimShare = 87.2 if location == "Indonesia"
replace MuslimDum = 1 if location == "Indonesia"
replace MuslimPart = 2 if location == "Indonesia, Malaysia"
replace MuslimPart = 1 if location == "Indonesia, Netherlands"

*Iran
replace MuslimShare = 99.5 if location == "Iran"
replace MuslimDum = 1 if location == "Iran"
replace MuslimPart = 2 if location == "Iran, Iraq"

*Iraq
replace MuslimShare = 99.0 if location == "Iraq"
replace MuslimDum = 1 if location == "Iraq"
replace MuslimPart = 2 if location == "Iraq, Kuwait"

*Israel
*replace MuslimShare = 18.6 if location == "Israel"
*replace MuslimDum = 0 if location == "Israel"
replace MuslimPart = 1 if inlist(location, "Israel, Jordan","Israel, Syria")

*Lebanon
replace MuslimShare = 61.3 if location == "Lebanon"
replace MuslimDum = 1 if location == "Lebanon"

*Libya
replace MuslimShare = 96.6 if location == "Libya"
replace MuslimDum = 1 if location == "Libya"

*Malaysia
replace MuslimShare = 63.7 if location == "Malaysia"
replace MuslimDum = 1 if location == "Malaysia"

*Mali
replace MuslimShare = 92.4 if location == "Mali"
replace MuslimDum = 1 if location == "Mali"

*Mauritania
replace MuslimShare = 99.1 if location == "Mauritania"
replace MuslimDum = 1 if location == "Mauritania"

*Morocco
replace MuslimShare = 99.9 if location == "Morocco"
replace MuslimDum = 1 if location == "Morocco"

*Niger
replace MuslimShare = 98.4 if location == "Niger"
replace MuslimDum = 1 if location == "Niger"

*Nigeria
*replace MuslimShare = 48.8 if SideB == "Jama'atu Ahlis Sunna Lidda'awati wal-Jihad "
*replace MuslimShare = 48.8 if SideB == "Ahlul Sunnah Jamaa"
*replace MuslimDum = 0 if SideB == "Jama'atu Ahlis Sunna Lidda'awati wal-Jihad "
*replace MuslimDum = 0 if SideB == "Ahlul Sunnah Jamaa"

*Oman
replace MuslimShare = 85.9 if location == "Oman"
replace MuslimDum = 1 if location == "Oman"

*Pakistan
replace MuslimShare = 96.4 if location == "Pakistan"
replace MuslimDum = 1 if location == "Pakistan"

*Russia
*replace MuslimShare = 10.0 if SideB == "Wahhabi movement of the Buinaksk district"
*replace MuslimDum = 0 if SideB == "Wahhabi movement of the Buinaksk district"

*Saudi Arabia
replace MuslimShare = 93 if location == "Saudi Arabia"
replace MuslimDum = 1 if location == "Saudi Arabia"

*Senegal
replace MuslimShare = 96.4 if location == "Senegal"
replace MuslimDum = 1 if location == "Senegal"

*Sierra Leone
replace MuslimShare = 78.0 if location == "Sierra Leone"
replace MuslimDum = 1 if location == "Sierra Leone"

*Somalia
replace MuslimShare = 99.8 if location == "Somalia"
replace MuslimDum = 1 if location == "Somalia"

*Sudan
replace MuslimShare = 90.7 if location == "Sudan"
replace MuslimDum = 1 if location == "Sudan"
replace MuslimPart = 1 if location == "South Sudan, Sudan"

*Syria
replace MuslimShare = 92.8 if location == "Syria"
replace MuslimDum = 1 if location == "Syria"

*Tajikistan
replace MuslimShare = 96.7 if location == "Tajikistan"
replace MuslimDum = 1 if location == "Tajikistan"

*Tunisia
replace MuslimShare = 99.5 if location == "Tunisia"
replace MuslimDum = 1 if location == "Tunisia"

*Turkey
replace MuslimShare = 98.0 if location == "Turkey/Ottoman Empire"
replace MuslimDum = 1 if location == "Turkey/Ottoman Empire"

*US
*replace MuslimShare = 0.9 if SideB == "al-Qaida "
*replace MuslimDum = 0 if SideB == "al-Qaida "

*Uzbekistan
replace MuslimShare = 96.7 if location == "Uzbekistan"
replace MuslimDum = 1 if location == "Uzbekistan"

*Yemen
replace MuslimShare = 99.1 if inlist(location, "North Yemen","North Yemen, South Yemen","South Yemen","Yemen","Yemen (North Yemen)")
replace MuslimDum = 1 if inlist(location, "North Yemen","North Yemen, South Yemen","South Yemen","Yemen","Yemen (North Yemen)")

egen sumBDMuslim=sum(bdeadbesx) if MuslimDum==1,by(year)

keep if MuslimDum == 1
collapse (sum) bdeadbesx, by(year)

save "Datasets/muslim_conflicts_2015_figure4_1.dta", replace


***********************************
*All battle deaths civil war, PRIO*
***********************************

use "Datasets/PRIO battle deaths 2009 version with no missing data.dta", clear

drop if type == 1
drop if type == 2
keep if bdeadbesx > 999

collapse (sum) bdeadbesx, by (year)

save "Datasets/all_battledeaths_PRIO.dta", replace

********************
***UCDP 1989-2014***
********************

use "Datasets/124934_1ucdp-brd-conflict-_2015", clear

drop if typeofconflict == "1"
drop if typeofconflict == "2"
keep if bdbest > 999


**********************
***Muslim countries***
**********************

gen MuslimShare = .

gen MuslimDum = .

gen MuslimPart = .

*Afghanistan
replace MuslimShare = 99.7 if location == "Afghanistan"
replace MuslimDum = 1 if location == "Afghanistan"
replace MuslimPart = 1 if location == "Afghanistan, Russia (Soviet Union)"

*Algeria
replace MuslimShare = 97.9 if location == "Algeria"
replace MuslimDum = 1 if location == "Algeria"
replace MuslimPart = 2 if location == "Algeria, Morocco"

*Australia, Iraq, United Kingdom, United States
replace MuslimPart = 1 if location == "Australia, Iraq, United Kingdom, United States of America"

*Azerbaijan
replace MuslimShare = 96.9 if location == "Azerbaijan"
replace MuslimDum = 1 if location == "Azerbaijan"

*Bangladesh
replace MuslimShare = 89.8 if location == "Bangladesh"
replace MuslimDum = 1 if location == "Bangladesh"

*Bosnia-Herzegovina
*replace MuslimShare = 45.2 if location == "Bosnia-Herzegovina"
*replace MuslimDum = 1 if location == "Bosnia-Herzegovina"

*Brunei
replace MuslimShare = 75.1 if location == "Brunei"
replace MuslimDum = 1 if location == "Brunei"

*Burkina Faso
replace MuslimShare = 61.6 if location == "Burkina Faso"
replace MuslimDum = 1 if location == "Burkina Faso"
replace MuslimPart = 2 if location == "Burkina Faso, Mali"

*Chad
replace MuslimShare = 55.3 if location == "Chad"
replace MuslimDum = 1 if location == "Chad"
replace MuslimPart = 2 if inlist(location,"Chad, Libya","Chad, Nigeria")

*Comoros
replace MuslimShare = 98.3 if location == "Comoros"
replace MuslimDum = 1 if location == "Comoros"

*Cyprus, Turkey
replace MuslimPart = 1 if location == "Cyprus, Turkey"

*Djibouti
replace MuslimShare = 96.9 if location == "Djibouti"
replace MuslimDum = 1 if location == "Djibouti"
replace MuslimPart = 1 if location == "Djibouti, Eritrea"

*Egypt
replace MuslimShare = 94.9 if location == "Egypt"
replace MuslimDum = 1 if location == "Egypt"
replace MuslimPart = 1 if inlist(location, "Egypt, Israel","Egypt, United Kingdom","Egypt, France, Israel, United Kingdom")
replace MuslimPart = 3 if inlist(location,"Egypt, Iraq, Israel, Jordan, Lebanon, Syria")

*Ethiopia, Somalia
replace MuslimPart = 1 if location == "Ethiopia, Somalia"

*France, Tunisia
replace MuslimPart = 1 if location == "France, Tunisia"

*Gambia
replace MuslimShare = 95.1 if location == "Gambia"
replace MuslimDum = 1 if location == "Gambia"

*Guinea 
replace MuslimShare = 84.4 if location == "Guinea"
replace MuslimDum = 1 if location == "Guinea"

*Guinea-Bissau
replace MuslimShare = 45.1 if location == "Guinea-Bissau"
*!!OBSOBS!!!*
replace MuslimDum = 1 if location == "Guinea-Bissau"

*India, Pakistan
replace MuslimPart = 1 if location == "India, Pakistan"

*Indonesia
replace MuslimShare = 87.2 if location == "Indonesia"
replace MuslimDum = 1 if location == "Indonesia"
replace MuslimPart = 2 if location == "Indonesia, Malaysia"
replace MuslimPart = 1 if location == "Indonesia, Netherlands"

*Iran
replace MuslimShare = 99.5 if location == "Iran"
replace MuslimDum = 1 if location == "Iran"
replace MuslimPart = 2 if location == "Iran, Iraq"

*Iraq
replace MuslimShare = 99.0 if location == "Iraq"
replace MuslimDum = 1 if location == "Iraq"
replace MuslimPart = 2 if location == "Iraq, Kuwait"

*Israel
*replace MuslimShare = 18.6 if location == "Israel"
*replace MuslimDum = 0 if location == "Israel"
replace MuslimPart = 1 if inlist(location, "Israel, Jordan","Israel, Syria")

*Lebanon
replace MuslimShare = 61.3 if location == "Lebanon"
replace MuslimDum = 1 if location == "Lebanon"

*Libya
replace MuslimShare = 96.6 if location == "Libya"
replace MuslimDum = 1 if location == "Libya"

*Malaysia
replace MuslimShare = 63.7 if location == "Malaysia"
replace MuslimDum = 1 if location == "Malaysia"

*Mali
replace MuslimShare = 92.4 if location == "Mali"
replace MuslimDum = 1 if location == "Mali"

*Mauritania
replace MuslimShare = 99.1 if location == "Mauritania"
replace MuslimDum = 1 if location == "Mauritania"

*Morocco
replace MuslimShare = 99.9 if location == "Morocco"
replace MuslimDum = 1 if location == "Morocco"

*Niger
replace MuslimShare = 98.4 if location == "Niger"
replace MuslimDum = 1 if location == "Niger"

*Nigeria
*replace MuslimShare = 48.8 if SideB == "Jama'atu Ahlis Sunna Lidda'awati wal-Jihad "
*replace MuslimShare = 48.8 if SideB == "Ahlul Sunnah Jamaa"
*replace MuslimDum = 0 if SideB == "Jama'atu Ahlis Sunna Lidda'awati wal-Jihad "
*replace MuslimDum = 0 if SideB == "Ahlul Sunnah Jamaa"

*Oman
replace MuslimShare = 85.9 if location == "Oman"
replace MuslimDum = 1 if location == "Oman"

*Pakistan
replace MuslimShare = 96.4 if location == "Pakistan"
replace MuslimDum = 1 if location == "Pakistan"

*Russia
*replace MuslimShare = 10.0 if SideB == "Wahhabi movement of the Buinaksk district"
*replace MuslimDum = 0 if SideB == "Wahhabi movement of the Buinaksk district"

*Saudi Arabia
replace MuslimShare = 93 if location == "Saudi Arabia"
replace MuslimDum = 1 if location == "Saudi Arabia"

*Senegal
replace MuslimShare = 96.4 if location == "Senegal"
replace MuslimDum = 1 if location == "Senegal"

*Sierra Leone
replace MuslimShare = 78.0 if location == "Sierra Leone"
replace MuslimDum = 1 if location == "Sierra Leone"

*Somalia
replace MuslimShare = 99.8 if location == "Somalia"
replace MuslimDum = 1 if location == "Somalia"

*Sudan
replace MuslimShare = 90.7 if location == "Sudan"
replace MuslimDum = 1 if location == "Sudan"
replace MuslimPart = 1 if location == "South Sudan, Sudan"

*Syria
replace MuslimShare = 92.8 if location == "Syria"
replace MuslimDum = 1 if location == "Syria"

*Tajikistan
replace MuslimShare = 96.7 if location == "Tajikistan"
replace MuslimDum = 1 if location == "Tajikistan"

*Tunisia
replace MuslimShare = 99.5 if location == "Tunisia"
replace MuslimDum = 1 if location == "Tunisia"

*Turkey
replace MuslimShare = 98.0 if location == "Turkey"
replace MuslimDum = 1 if location == "Turkey"

*US
*replace MuslimShare = 0.9 if SideB == "al-Qaida "
*replace MuslimDum = 0 if SideB == "al-Qaida "

*Uzbekistan
replace MuslimShare = 96.7 if location == "Uzbekistan"
replace MuslimDum = 1 if location == "Uzbekistan"

*Yemen
replace MuslimShare = 99.1 if inlist(location, "North Yemen ","North Yemen, South Yemen","South Yemen","Yemen","Yemen (North Yemen)")
replace MuslimDum = 1 if inlist(location, "North Yemen ","North Yemen, South Yemen","South Yemen","Yemen","Yemen (North Yemen)")

egen sumBDMuslim=sum(bdbest) if MuslimDum==1,by(year)

keep if MuslimDum == 1
collapse (sum) bdbest, by(year)

save "Datasets/muslim_conflicts_2015_figure4_2.dta", replace

**************************************
**All battle deaths civil war, UCDP***
**************************************

use "Datasets/124934_1ucdp-brd-conflict-_2015", clear

keep if bdbest > 999
drop if type == "1"
drop if type == "2"

collapse (sum) bdbest, by (year)

save "Datasets/all_battledeaths_UCDP", replace

