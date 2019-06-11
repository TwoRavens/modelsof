/* PrepCTractData.do */
* This prepares all data at the Census tract level.
* Note: we are using Census 2000 tracts, not 2010.


/* CENTROIDS */
import delimited $Externals/Data/Census/TractData/tract_pop.txt, varnames(nonames) clear 
tostring v1, gen(fips_state_string)
replace fips_state_string = "0"+fips_state_string if length(fips_state_string)==1
tostring v2, gen(fips_county_string)
replace  fips_county_string = "0"+ fips_county_string if length(fips_county_string)<3
replace  fips_county_string = "0"+ fips_county_string if length(fips_county_string)<3
tostring v3, gen(fips_tract_string)
replace fips_tract_string = "0"+fips_tract_string if length(fips_tract_string)<6
replace fips_tract_string = "0"+fips_tract_string if length(fips_tract_string)<6
replace fips_tract_string = "0"+fips_tract_string if length(fips_tract_string)<6
replace fips_tract_string = "0"+fips_tract_string if length(fips_tract_string)<6
replace fips_tract_string = "0"+fips_tract_string if length(fips_tract_string)<6

gen gisjoin = "G"+fips_state_string+"0"+fips_county_string+"0"+fips_tract_string

destring v5, gen(TractCentroid_lat) ignore("+")
destring v6, gen(TractCentroid_lon) ignore("+") force

keep gisjoin fips_*_string TractCentroid_*


saveold $Externals/Calculations/Geographic/Tr_Data.dta, replace


**************************************************
/* ADD DEMOGRAPHIC DATA */
*** Tract education
insheet using $Externals/Data/Census/TractData/TractEducation/ACS_09_5YR_S1501_with_ann.csv, clear comma names
drop if _n==1
destring hc01_est_vc0? hc01_est_vc1?, replace force

gen TractEduc = (hc01_est_vc08*6 + hc01_est_vc09*10 + hc01_est_vc10*12 + hc01_est_vc11*14 + hc01_est_vc12*14 + hc01_est_vc13*16 + hc01_est_vc14*18)/100
gen TractlnEduc = ln(TractEduc)
gen TractCollege = hc01_est_vc17 // Percent bachelor's degree or higher

keep geoid2 TractEduc TractlnEduc TractCollege

saveold $Externals/Calculations/Geographic/TractEducTemp.dta, replace


*** Tract median income
insheet using $Externals/Data/Census/TractData/TractMedIncome/ACS_09_5YR_B19013_with_ann.csv, clear comma names
drop if _n==1

	** Merge education data
	merge 1:1 geoid2 using $Externals/Calculations/Geographic/TractEducTemp.dta, keep(match master using) nogen
	erase $Externals/Calculations/Geographic/TractEducTemp.dta


gen fips_state_string=substr(geoid,10,2)
gen fips_county_string=substr(geoid,12,3)
gen fips_tract_string=substr(geoid,15,6)
	
gen gisjoin = "G"+substr(geoid,10,2)+"0"+substr(geoid,12,3)+"0"+substr(geoid,15,6)
drop if _n==1
destring hd01_vd01, gen(TractMedIncome) force

** Transform real 2009 dollars to real 2010 dollars
gen year=2009
merge m:1 year using $Externals/Calculations/CPI/CPI_Annual.dta, keep(match) nogen keepusing(CPI)
replace TractMedIncome = TractMedIncome/CPI

gen TractlnMedIncome=ln(TractMedIncome)

keep gisjoin fips_*_string Tract*

merge 1:1 gisjoin using $Externals/Calculations/Geographic/Tr_Data.dta, keep(match master using) nogen

** fips_state and fips_county are the "real" of fips_state_code and fips_county_code
destring fips_state_string, gen(fips_state_code) force
destring fips_county_string, gen(fips_county_code) force

** Labels
label var TractMedIncome "Tract median income"
label var TractlnMedIncome "ln(Tract median income)"


compress
saveold $Externals/Calculations/Geographic/Tr_Data.dta, replace




