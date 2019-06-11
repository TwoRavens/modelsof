/* PrepZipCodeData.do */
* This uses ACS 2011 data. Could use Census 2000, but 2011 is the first year of the ACS 5-year estimates at the ZCTA level.


/* Tract-zip relationship files */
insheet using $Externals/Data/Census/geocorr_2000_ZipTract.csv, comma names clear
drop if _n==1
destring zcta, gen(zip_code) force

gen fips_state_string=substr(county,1,2)
gen fips_county_string=substr(county,3,3)
gen fips_tract_string=subinstr(tract,".","",.)

gen gisjoin = "G"+fips_state_string+"0"+fips_county_string+"0"+fips_tract_string
saveold $Externals/Calculations/Geographic/temp.dta, replace

*** List of tracts in each zip
keep zip_code gisjoin
drop if zip_code==.
bysort zip_code: gen n=_n
reshape wide gisjoin,i(zip_code) j(n)

saveold $Externals/Calculations/Geographic/TractsinZip.dta, replace


*** Map from tract to primary zip
use $Externals/Calculations/Geographic/temp.dta, replace
gsort gisjoin -afact2 // sort from highest to lowest allocation factor
drop if gisjoin == gisjoin[_n-1] // drop all but highest allocation factor
keep gisjoin zip_code

saveold $Externals/Calculations/Geographic/TracttoZip.dta, replace

erase $Externals/Calculations/Geographic/temp.dta


/* Zip code to state and to Census division */
insheet using $Externals/Data/Census/ZipData/zcta_county_rel_10.txt, comma names clear
rename zcta5 zip_code

** Get the state with the largest share of population
sort zip_code zpoppct // sorts in order from smallest to largest, so collapse (last) below
collapse (last) state,by(zip_code)
rename state fips_state_code
merge m:1 fips_state_code using $Externals/Calculations/Geographic/StateCodes.dta, nogen keep(match master) keepusing(state_abv division Div_?)
saveold $Externals/Calculations/Geographic/Z_Data.dta, replace

/* Zip code to county */
insheet using $Externals/Data/Census/ZipData/zcta_county_rel_10.txt, comma names clear
gen long state_countyFIPS = state*1000+county

rename zcta5 zip_code

** Get the state with the largest share of population
sort zip_code zpoppct // sorts in order from smallest to largest, so collapse (last) below

collapse (last) state_countyFIPS,by(zip_code) // Note: Median zip is 100% in one county. 5th percentile zip has 70% of population in main county. 1st percentile zip has 51.5% of population in main county. So this county mapping is pretty good.

** County name corrections
include Code/DataPrep/Geographic/FixCountyFIPS.do

merge 1:1 zip_code using $Externals/Calculations/Geographic/Z_Data.dta, keep(match using) nogen
saveold $Externals/Calculations/Geographic/Z_Data.dta, replace

/* Zip Code centroids and density */
import delimited $Externals/Data/Census/ZipData/Gaz_zcta_national.txt, varnames(1) clear
rename geoid zip_code
format zip_code %05.0f
rename intptlat ZipCentroid_lat
rename intptlong ZipCentroid_lon

gen ZipPopDen = pop10/aland_sqmi

rename pop10 ZipPop

keep zip_code ZipCentroid* ZipPopDen ZipPop

merge 1:1 zip_code using $Externals/Calculations/Geographic/Z_Data.dta, keep(match master using) nogen

saveold $Externals/Calculations/Geographic/Z_Data.dta, replace


*********************************************************************************
*********************************************************************************



/* Demographic Data */
*** Zip education
insheet using $Externals/Data/Census/ZipData/ZipEducation/ACS_11_5YR_S1501_with_ann.csv, comma names clear
drop if _n==1
destring hc01_est_vc0? hc01_est_vc1?, replace force

gen ZipEduc = (hc01_est_vc08*6 + hc01_est_vc09*10 + hc01_est_vc10*12 + hc01_est_vc11*14 + hc01_est_vc12*14 + hc01_est_vc13*16 + hc01_est_vc14*18)/100
gen ZiplnEduc = ln(ZipEduc)
gen ZipCollege = hc01_est_vc17 // Percent bachelor's degree or higher


destring geoid2, gen(zip_code)
format zip_code %05.0f
keep zip_code ZipEduc ZiplnEduc ZipCollege

merge 1:1 zip_code using $Externals/Calculations/Geographic/Z_Data.dta, keep(match master using) nogen
saveold $Externals/Calculations/Geographic/Z_Data.dta, replace


*** Zip median income
* From ACS 2011
insheet using $Externals/Data/Census/ZipData/ZipMedIncome/ACS_11_5YR_B19013_with_ann.csv, comma names clear
drop if _n==1
rename hd01_vd01 Z_Income

destring Z_Income, replace force

** Transform real 2011 dollars to real 2010 dollars
gen year=2011
merge m:1 year using $Externals/Calculations/CPI/CPI_Annual.dta, keep(match) nogen keepusing(CPI)
replace Z_Income = Z_Income/CPI


gen Z_lnIncome = ln(Z_Income)

destring geoid2, gen(zip_code)
format zip_code %05.0f
keep zip_code Z_Income Z_lnIncome

merge 1:1 zip_code using $Externals/Calculations/Geographic/Z_Data.dta, keep(match master using) nogen


** Get ZipMedIncomeGroup
gen ZipMedIncomeGroup = floor(Z_Income/10000)*10+5 
replace ZipMedIncomeGroup = 25 if ZipMedIncomeGroup<25
replace ZipMedIncomeGroup = 100 if ZipMedIncomeGroup>75 & ZipMedIncomeGroup!=. // This is very close to the conditional mean: sum Z_Income if ZipMedIncomeGroup==100 gives mean = $101,321.


** Labels
label var Z_Income "Zip median income"
label var ZipMedIncomeGroup "Zip median income"
label var Z_lnIncome "ln(Zip median income)"

** Drop Puerto Rico and US Virgin Islands
drop if zip_code < 1000

compress
saveold $Externals/Calculations/Geographic/Z_Data.dta, replace



/* COLLAPSE TO ZIP3 LEVEL, WEIGHTING BY POPULATION 
gen int zip3 = floor(zip_code/100)
collapse (median) fips_state_code (mean) ZipEduc ZipCollege Z3_Income=Z_Income [pw=ZipPop], by(zip3) // a few zip3s are in multiple states. collapsing median state gives the state where most zips are.
gen Z3_lnIncome = ln(Z3_Income)
saveold $Externals/Calculations/Geographic/Z3_Data.dta, replace
*/
