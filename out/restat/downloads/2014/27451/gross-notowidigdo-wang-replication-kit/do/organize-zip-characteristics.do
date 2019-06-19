#delim cr
set more off
*version 11
pause on
graph set ps logo off

capture log close
set linesize 80
set logtype text
log using ../log/organize-zip-characteristics.log , replace

/* --------------------------------------

Organizes the zip code characteristics, 
which are merged in later. 

--------------------------------------- */

clear all
estimates clear
set mem 500m
describe, short


************************************************************
**   Prepare Population
************************************************************

clear
use ../src/zip-data/population_by_zcta/zipcode-population-2000-sf1.dta

d, f

gen zip = real(zcta)
drop if zip == .

keep zip pop

sort zip
tempfile c
save `c'

************************************************************
**   Prepare household income
************************************************************

clear
use ../src/zip-data/income_by_zcta/zipcode-income-2000-sf3.dta

d, f

gen zip = real(zcta)
drop if zip == .

keep median_fam_income_all zip

sort zip 
tempfile b
save `b'

************************************************************
**   Prepare Share owner-occupied
************************************************************

clear
use ../src/zip-data/census-2000-share-owner-occupied-by-zip/share-owner-occupied.dta

d, f

rename zip zip_orig
gen zip = real(zip_orig)
drop if zip == .
drop zip_orig

sort zip
tempfile a
save `a'

************************************************************
**   Bring it all together, Clean up
************************************************************

clear
use ../src/zip-data/census-2000-share-college-by-zip/census-2000-share-college.dta
d, f
sort zip
drop if zip == .

merge 1:1 zip using `a'
tab _merge
drop _merge

merge 1:1 zip using `b'
tab _merge
drop _merge

merge 1:1 zip using `c'
tab _merge
drop _merge

************************************************************
**   Save & Close
************************************************************

sort zip
save ../dta/zip-characteristics.dta , replace



log close
exit

