/* GetStoreCodeListandStoreCounts.do */

** Set up storecode list file
clear
save $Externals/Calculations/OtherNielsen/StoreCodeList.dta, replace emptyok

forvalues year = 2004/$MaxYear {
	use $Externals/Calculations/Homescan/Trips/trips_`year'.dta, replace 
	gen NTrips = 1
	collapse (sum) NTrips , by(household_code retailer_code)
	gen int panel_year=`year'
	merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Household-Panel.dta, keepusing(fips_state_code fips_county_code) nogen keep(match master)
	
	gen NHouseholds = 1
	collapse (first) panel_year (sum) NTrips NHouseholds,by(retailer_code fips_state_code fips_county_code)
	append using $Externals/Calculations/OtherNielsen/StoreCodeList.dta
	saveold $Externals/Calculations/OtherNielsen/StoreCodeList.dta, replace
}


/* Determine count of stores for each retailer_code */
use $Externals/Calculations/OtherNielsen/StoreCodeList.dta, replace
** Collapse across years
collapse (mean) NTrips NHouseholds,by(retailer_code fips_state_code fips_county_code)
bysort retailer_code: egen TotalTrips = sum(NTrips)
bysort retailer_code: egen TotalHouseholds = sum(NHouseholds)
gen CountyTripShare = NTrips/TotalTrips
gen CountyHouseholdShare = NHouseholds/TotalHouseholds
collapse (max) CountyTripShare CountyHouseholdShare (sum) NTrips NHouseholds, by(retailer_code)
saveold $Externals/Calculations/OtherNielsen/StoreCounts.dta, replace
