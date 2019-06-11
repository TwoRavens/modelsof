/* PrepCZData.do */
* Note that these are 1990 CZs to match the 


/* County to 1990 CZ crosswalk */
insheet using $Externals/Data/Census/cty_cz_st_crosswalk.csv, comma names clear // This is from https://healthinequality.org/data/.
rename cty state_countyFIPS

** Add Broomfield county
sum state_countyFIPS
local N_1 = r(N) + 1
set obs `N_1'
replace state_countyFIPS = 8014 if _n==`N_1'
replace county_name = "Broomfield" if _n==`N_1'
replace cz = 28900 if _n==`N_1'
replace cz_name = "Denver" if _n==`N_1'
replace statename = "Colorado" if _n==`N_1'
replace state_fips = 8 if _n==`N_1'
replace stateabbrv = "CO" if _n==`N_1'

sort state_countyFIPS

** County name corrections
include Code/DataPrep/Geographic/FixCountyFIPS.do

rename cz cz1990

saveold $Externals/Calculations/Geographic/CountytoCZCrosswalk.dta, replace


/* County to 2000 CZ crosswalk */
import excel $Externals/Data/Census/cz00_eqv_v1.xls, sheet("CZ00_Equiv") firstrow clear // This is from https://www.ers.usda.gov/data-products/commuting-zones-and-labor-market-areas/
destring FIPS, gen(state_countyFIPS)
rename CountyName county_name
rename CommutingZoneID2000 cz
*destring CommutingZoneID1990, gen(cz1990_ers) // These are identical to the Chetty et al. dataset for the lower-48.

** Add Broomfield county
sum state_countyFIPS
local N_1 = r(N) + 1
set obs `N_1'
replace state_countyFIPS = 8014 if _n==`N_1'
replace county_name = "Broomfield" if _n==`N_1'
replace cz = 5 if _n==`N_1'
*replace cz1990_ers = 28900 if _n==`N_1'

sort state_countyFIPS

** County name corrections
include Code/DataPrep/Geographic/FixCountyFIPS.do

keep state_countyFIPS county_name cz*
compress

merge 1:1 state_countyFIPS using $Externals/Calculations/Geographic/CountytoCZCrosswalk.dta, keep(match master using) nogen // unmatched are only alaska

saveold $Externals/Calculations/Geographic/CountytoCZCrosswalk.dta, replace

/*
/* Collapse REIS county-level data to CZs */
use $Externals/Calculations/Geographic/Ct_Data.dta, replace
merge m:1 state_countyFIPS using $Externals/Calculations/Geographic/CountytoCZCrosswalk.dta, nogen keep(match) keepusing(cz)
collapse (rawsum) Population (mean) CZ_Income=Ct_Income [pw=Population],by(cz)

compress

save $Externals/Calculations/Geographic/CZ_Data.dta, replace

** 1990 definitions
use $Externals/Calculations/Geographic/Ct_Data.dta, replace
merge m:1 state_countyFIPS using $Externals/Calculations/Geographic/CountytoCZCrosswalk.dta, nogen keep(match) keepusing(cz1990)
collapse (rawsum) Population (mean) C9_Income=Ct_Income [pw=Population],by(cz1990)

compress

save $Externals/Calculations/Geographic/C9_Data.dta, replace
*/
