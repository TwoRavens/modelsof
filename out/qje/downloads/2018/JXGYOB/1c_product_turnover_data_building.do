*******************************************************************
***** This do.file generates the full list of products available 
***** as of a given year or that never appear in the future
***** using both HMS and RMS data
********************************************************************
global db2 "D:\Dropbox\unequal_gains\QJE revision plan\analysis"
global db "D:\Dropbox\unequal_gains\main_data"

*** 1. Build year by year lists from HMS data
cd "D:/Dropbox/unequal_gains/main_data/HMS/"

foreach i of numlist 2004(1)2015 {
clear
import delimited `i'/Annual_Files/purchases_`i'.tsv, numericcols(_all) asdouble
save "$db/Important Datasets/purchases_`i'.dta", replace

keep upc upc_ver_uc 
duplicates drop 
save "$db/Important Lists/available_upcs_`i'.dta", replace
}

*** 2. Build year by year lists from RMS data 
cd "$db2\RMS\collapsed_files\state_level"

foreach i of numlist 2006(1)2015 {
use rms_`i', replace
keep upc
duplicates drop
save "$db/Important Lists/RMS_available_upcs_`i'.dta", replace
}

*** 3. Build consolidated lists

* (a) UPCs that showed up in data at any point up to a given year (including that year)

* 2004
use "$db/Important Lists/available_upcs_2004.dta", clear
save "$db/Important Lists/available_upcs_upto2004_final.dta", replace 

* 2005
use "$db/Important Lists/available_upcs_upto2004_final.dta", clear
append using "$db/Important Lists/available_upcs_2005.dta"
keep upc upc_ver_uc
duplicates drop
save "$db/Important Lists/available_upcs_upto2005_final.dta", replace 

* 2006-2015
foreach i of numlist 2006(1)2015 {
local var=`i'-1
use "$db/Important Lists/available_upcs_upto`var'_final.dta", clear
append using "$db/Important Lists/available_upcs_`i'.dta"
append using "$db/Important Lists/RMS_available_upcs_`i'.dta"
replace upc_ver_uc=1 if missing(upc_ver_uc)
keep upc upc_ver_uc
duplicates drop
save "$db/Important Lists/available_upcs_upto`i'_final.dta", replace 
}

* (b) UPCs that showed up in data (strictly) after a given year 

use "$db/Important Lists/available_upcs_2015.dta", clear
append using "$db/Important Lists/RMS_available_upcs_2015.dta"
replace upc_ver_uc=1 if missing(upc_ver_uc)
keep upc upc_ver_uc
duplicates drop
save "$db/Important Lists/available_upcs_post2014_final.dta", replace 

foreach i of numlist 2014(-1)2006 {
local var=`i'-1
use "$db/Important Lists/available_upcs_`i'.dta", clear
append using "$db/Important Lists/RMS_available_upcs_`i'.dta"
append using "$db/Important Lists/available_upcs_post`i'_final.dta"
replace upc_ver_uc=1 if missing(upc_ver_uc)
keep upc upc_ver_uc
duplicates drop
save "$db/Important Lists/available_upcs_post`var'_final.dta", replace 
}

use "$db/Important Lists/available_upcs_2005.dta", clear
append using "$db/Important Lists/available_upcs_post2005_final.dta"
keep upc upc_ver_uc
duplicates drop
save "$db/Important Lists/available_upcs_post2004_final.dta", replace 








