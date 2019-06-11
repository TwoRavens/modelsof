/* PrepHouseholdCensusTracts.do */

* Notes on Census tracts:
	* We have two sources of Census tracts. Zip codes are more reliable. We use Census tracts for lat/long iff EITHER (all three sources agree) OR (one of the two tract sources agrees with the zip code and the other doesn't)

/* Household census tracts and covariates */
*** Preliminary data prep for food desert definition census tracts
* These only cover 2006-2011
use $Externals/Data/Nielsen/Homescan/CensusTracts/census_tracts_from_nielsen.dta, replace

rename gisjoin gisjoin_FD
duplicates tag household_code panel_year, gen(dup)
drop if dup!=0

keep household_code panel_year gisjoin_FD

saveold $Externals/Calculations/Homescan/census_tracts_from_nielsen.dta, replace


*********
**** Prep Census tract file
clear
save $Externals/Calculations/Homescan/HouseholdCensusTracts.dta, replace emptyok

*** Start with tracts provided to USDA; 2004-2010
forvalues year=2004/2010 {
	use $Externals/Data/Nielsen/Homescan/CensusTracts/demogeog`year'.dta, clear    // tract`year'.dta, clear
	* Rename to be consistent with new Kilts release
	rename hhid household_code
	rename county fips_county_code
	gen panel_year = `year'
	append using $Externals/Calculations/Homescan/HouseholdCensusTracts.dta
	saveold $Externals/Calculations/Homescan/HouseholdCensusTracts.dta, replace
}
merge 1:1 household_code panel_year using $Externals/Calculations/Homescan/Household-Panel.dta, keep(match) keepusing(fips_state_code) nogen // Note that 8 are not matched from the master.
gen fips_tract_code = string(tract)
drop if fips_tract==""
forvalues i = 1/6 {
	replace fips_tract = "0" + fips_tract if length(fips_tract)<6
}

format household_code %12.0g 
drop tract


** Get gisjoin variable
tostring fips_state_code, gen(fips_state_string)
replace fips_state_string = "0"+fips_state_string if length(fips_state_string)==1
tostring fips_county_code, gen(fips_county_string)
replace fips_county_string = "0"+fips_county_string if length(fips_county_string)<3
replace fips_county_string = "0"+fips_county_string if length(fips_county_string)<3

gen gisjoin = "G"+fips_state_string+"0"+fips_county_string+"0"+fips_tract_code



*** Add tracts based on food desert definitions
merge 1:1 household_code panel_year using $Externals/Calculations/Homescan/census_tracts_from_nielsen.dta, keep(match master using) nogen

*** Add zips from the Kilts release
merge 1:1 household_code panel_year using $Externals/Calculations/Homescan/Household-Panel.dta, keepusing(panelist_zip_code) nogen
rename panelist_zip_code zip_code

** Get the list of tracts in a zip code
	* This is Census 2000 tracts.
merge m:1 zip_code using $Externals/Calculations/Geographic/TractsinZip.dta, nogen keep(match master)

gen TractMatch = 0 if gisjoin!=""&zip_code!=.
gen TractMatch_FD = 0 if gisjoin_FD!=""&zip_code!=.

forvalues i = 1/47 {
	replace TractMatch=1 if gisjoin==gisjoin`i' & gisjoin`i'!=""
	replace TractMatch_FD=1 if gisjoin_FD==gisjoin`i' & gisjoin`i'!=""
}
* sum TractMatch* // Each is right 97% of the time

** Generate UnreliableTractData variable if tract data disagree. If this variable = 1, then we do not use that household's earlier/later Census tract data.
gen byte UnreliableTractData = 0
replace UnreliableTractData = 1 if (TractMatch_FD==0&TractMatch==0) | (TractMatch_FD==1&TractMatch==1&gisjoin!=gisjoin_FD)

*** Determine final gisjoin variable
replace gisjoin = "" if TractMatch!=1
replace gisjoin = gisjoin_FD if TractMatch_FD==1&TractMatch!=1

** Don't use either if they are non-missing and disagree
replace gisjoin = "" if gisjoin!=gisjoin_FD & TractMatch==1&TractMatch_FD==1


keep household_code panel_year gisjoin UnreliableTractData

compress
saveold $Externals/Calculations/Homescan/HouseholdCensusTracts.dta, replace
