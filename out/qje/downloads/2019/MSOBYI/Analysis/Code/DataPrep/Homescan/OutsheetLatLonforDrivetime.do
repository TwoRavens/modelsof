/* OutsheetLatLonforDrivetime.do */
** Get list of Homescan locations
use $Externals/Calculations/Homescan/Prepped-Household-Panel.dta,replace
collapse (first) TractCentroid_lat TractCentroid_lon,by(HMS_Location_ID)
save $Externals/Calculations/Homescan/HomescanLatLon.dta, replace



foreach dataset in LatLong { // LatLong_add
	if "`dataset'" == "LatLong" {
		use storelat storelon Store_Location_ID using $Externals/Calculations/StoreEntryExit/AllRetailerEntry.dta, clear
		duplicates drop
	}
	else {
		use storelat_corrected storelon_corrected Store_Location_ID_corrected using $Externals/Calculations/StoreEntryExit/CorrectedStoreLocations.dta	
		foreach var in storelat storelon Store_Location_ID {
			rename `var'_corrected `var'
		}
	}


	local N=_N

		foreach dim in lat lon {
			gen double Store`dim' = .
		}
		gen Store_Distance=.

	forvalues i=1/`N' {
		display "This is `i' out of `N'."
		append using $Externals/Calculations/Homescan/HomescanLatLon.dta, gen(Homescan)
		
		foreach dim in lat lon {
			replace Store`dim' = store`dim'[`i'] if Homescan==1
		}
		replace Store_Location_ID = Store_Location_ID[`i'] if Homescan==1
		
		** Travel distance
		geodist TractCentroid_lat TractCentroid_lon Storelat Storelon, gen(StoreDistance) miles sphere
		drop if Homescan == 1&StoreDistance>15
		replace Store_Distance=StoreDistance if Homescan==1
		drop Homescan StoreDistance
	}

	keep if storelat==.
	keep TractCentroid_lat TractCentroid_lon HMS_Location_ID Storelat Storelon Store_Distance Store_Location_ID

	save $Externals/Calculations/Homescan/StoreHouse`dataset'.dta, replace



	/* Outsheet for perl script */
	use $Externals/Calculations/Homescan/StoreHouse`dataset'.dta, replace
	rename TractCentroid_lat latitude1
	rename TractCentroid_lon longitude1
	rename Storelat latitude2
	rename Storelon longitude2

	keep latitude? longitude? HMS_Location_ID Store_Location_ID

	outsheet using $Externals/Calculations/Homescan/StoreHouse`dataset'.csv, comma names replace
}


erase $Externals/Calculations/Homescan/HomescanLatLon.dta // just a temporary file.
