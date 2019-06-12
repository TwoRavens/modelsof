import delimited "$Externals/Data/Census/TractData/TractHouseholds/US_tract_2016.csv", clear


// For whole foods in engelwood
keep if statefp==17
keep if countyfp==31
gen store_lat=41.780690
gen store_lon=-87.646474



georoute, hereid(6zKWN1yMDWNUL7rOKvlU) herecode(qV3oAzZj3Svfkyfsqm5iVQ) startxy(intptlat intptlon) endxy(store_lat store_lon) time(drivetime) diagnostic(flag)

save "$Externals\Calculations\Geographic/CookCountyDriveTimes.dta", replace


import delimited "$Externals\Data\Census\TractData\TractHouseholds\nhgis0074_ds225_20165_2016_tract.csv", clear
gen low_income_households=af48e002+af48e003+af48e004+af48e005+(af48e006*(27300-25000)/5000)

merge 1:1 gisjoin  using "$Externals\Calculations\Geographic/CookCountyDriveTimes.dta"
keep if _merge==3
drop _merge

keep low_income_households drivetime

keep if drivetime<=10

sum


// For real HHFI store in jacksonville FL

import delimited "$Externals/Data/Census/TractData/TractHouseholds/US_tract_2016.csv", clear


keep if statefp==12
keep if countyfp==31
gen store_lat=30.358870
gen store_lon=-81.674180


georoute, hereid(6zKWN1yMDWNUL7rOKvlU) herecode(qV3oAzZj3Svfkyfsqm5iVQ) startxy(intptlat intptlon) endxy(store_lat store_lon) time(drivetime) diagnostic(flag)

save "$Externals\Calculations\Geographic/FLDriveTimes.dta", replace


import delimited "$Externals\Data\Census\TractData\TractHouseholds\nhgis0074_ds225_20165_2016_tract.csv", clear
gen low_income_households=af48e002+af48e003+af48e004+af48e005+(af48e006*(27300-25000)/5000)

merge 1:1 gisjoin  using "$Externals\Calculations\Geographic/FLDriveTimes.dta"
keep if _merge==3
drop _merge

// Income cutoff for 25th percentile of 2016 income is 27300


keep low_income_households drivetime

keep if drivetime<=10

sum // 15720 total
