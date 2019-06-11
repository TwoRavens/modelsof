* Part IV, step 3 of Racial_inequality_Notes_2
cd F:\RA\RA_Inequality\summer\data1

clear all
set more off 
set matsize 800
set memory 10000m 
capture log close 
log using "busfm",text replace

* open the dataset used: Census 1940 - 2010 + ACS 2005 - 2007
use acs_1964_2014.dta, clear

keep year state age race hispan educ incbusfm incwage ind1950

keep if year == 1950

keep if age >= 19 & age <= 64

* race groups
 gen white = (race==1)*(hispan==0)
 gen black = (race==2)
 gen other = (white == 0 & black == 0)
 
 gen racegr = white
 replace racegr = 2 if black == 1
 replace racegr = 3 if other == 1
* create age groups
gen agegr = 1 if age >= 19 & age <= 24

replace agegr = 2 if age>= 25 & age <= 29

replace agegr = 3 if age>= 30 & age <= 34

replace agegr = 4 if age>= 35 & age <= 39

replace agegr = 5 if age >= 40 & age <= 44

replace agegr = 6 if age>= 45 & age <= 49

replace agegr = 7 if age >= 50 & age <= 54

replace agegr = 8 if age >= 55 & age <= 59

replace agegr = 9 if age >= 60 & age <= 64



* education groups

gen educgr = 1 if educ < 6

replace educgr = 2 if educ >= 6 & educ <= 9

replace educgr = 3 if educ >= 10 

* conditional on receiving farm or business income 

gen incbusfmmis = incbusfm if incbusfm > 0 & incbusfm < 99999

gen incwagemis = incwage if incwage >= 0 & incwage < 99999

gen agr = (ind1950 == 105)

keep state racegr agegr educgr agr incbusfmmis incwagemis 

gen busfmind = (incbusfmmis != . & incbusfm > 0)

gen earnind = (incwage != . & incwage > 0)

save acs_1950, replace

*(1) s,r,a,e,i,+earn,
egen meanbusfmind = mean(busfmind), by(state racegr agr agegr educgr earnind)
* codes: -1 = net loss, 99999 = N/A

egen tot_gr1 = group(state racegr agr agegr educgr earnind)

* many groups have only 1 person

tabulate tot_gr1 if incbusfm > 0 & incbusfm < 99999

egen meanincafm1 = mean(incbusfmmis), by(state racegr agr agegr educgr earnind)

egen meanincw1 = mean(incwagemis) , by(state racegr agr agegr educgr)

gen rat1 = meanincafm1/meanincw1

count if rat1 == .
drop if rat1 == .

replace rat1 = 0.1 if rat1 < 0.1 & rat1 != . 

replace rat1 = 0.9 if rat1 > 0.9 & rat1 != .

bysort state racegr agr agegr educgr earnind: gen dup = cond(_N==1, 0, _n)

keep if dup <= 1
* 1/3 has missing data
save rat11950.dta, replace

*(2) s,r,e,i,+earn, 
use acs_1950, clear
egen meanbusfmind2 = mean(busfmind), by(state racegr agr educgr earnind)
* no age group
egen tot_gr2 = group(state racegr agr educgr earnind)

tabulate tot_gr2 if incbusfm > 0 & incbusfm < 99999

egen meanincafm2 = mean(incbusfmmis), by(state racegr agr educgr earnind)

egen meanincw2 = mean(incwagemis), by(state racegr agr educgr)

gen rat2 = meanincafm2/meanincw2

count if rat2 == .

drop if rat2 == .

replace rat2 = 0.1 if rat2 < 0.1 & rat2 != . 

replace rat2 = 0.9 if rat2 > 0.9 & rat2 != .

bysort state racegr agr educgr earnind: gen dup = cond(_N==1, 0, _n)

keep if dup <= 1

list state race educgr meanincafm meanincw if rat2 == .
* 1/3 has missing data
save rat21950.dta, replace

*(3) s,r,a,i,+earn
use acs_1950, clear
egen meanbusfmind3 = mean(busfmind), by(state racegr agr agegr earnind)
* no age group
egen tot_gr3 = group(state racegr agr earnind)

tabulate tot_gr3 if incbusfm > 0 & incbusfm < 99999

egen meanincafm3 = mean(incbusfmmis), by(state racegr agr agegr earnind)

egen meanincw3 = mean(incwagemis), by(state racegr agr agegr)

gen rat3 = meanincafm3/meanincw3

count if rat3 == .

drop if rat3 == .

replace rat3 = 0.1 if rat3 < 0.1 & rat3 != . 

replace rat3 = 0.9 if rat3 > 0.9 & rat3 != .

bysort state racegr agr agegr earnind : gen dup = cond(_N==1, 0, _n)

keep if dup <= 1

* 1/3 has missing data
save rat31950.dta, replace

* (4) s,r,i,+earn, 
use acs_1950, clear
egen meanbusfmind4 = mean(busfmind), by(state racegr agr earnind)
egen tot_gr4 = group(state racegr agr earnind)

tabulate tot_gr4 if incbusfm > 0 & incbusfm < 99999

egen meanincafm4 = mean(incbusfmmis), by(state racegr agr earnind)

egen meanincw4 = mean(incwagemis), by(state racegr agr)

gen rat4 = meanincafm4/meanincw4

count if rat4 == .

drop if rat4 == .

replace rat4 = 0.1 if rat4 < 0.1 & rat4 != . 

replace rat4 = 0.9 if rat4 > 0.9 & rat4 != .

bysort state racegr agr earnind: gen dup = cond(_N==1, 0, _n)

keep if dup <= 1

* 1/3 has missing data
save rat41950.dta, replace

* (5) s,r, +earn, 
use acs_1950, clear

egen meanbusfmind5 = mean(busfmind), by(state racegr earnind)
egen tot_gr5 = group(state racegr agr earnind)

tabulate tot_gr5 if incbusfm > 0 & incbusfm < 99999

egen meanincafm5 = mean(incbusfmmis), by(state racegr earnind)

egen meanincw5 = mean(incwagemis), by(state racegr)

gen rat5 = meanincafm5/meanincw5

count if rat5 == .

drop if rat5 == .

replace rat5 = 0.1 if rat5 < 0.1 & rat5 != . 

replace rat5 = 0.9 if rat5 > 0.9 & rat5 != .

bysort state racegr earnind: gen dup = cond(_N==1, 0, _n)

keep if dup <= 1

save rat51950.dta, replace

