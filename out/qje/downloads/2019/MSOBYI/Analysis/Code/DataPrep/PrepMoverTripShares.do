/* PrepMoverTripShares.do */
* Use trips file to get share of trips in current, past, and future geographic areas.
* Note that we should do this at the county level or wider, as people often shop outside of their own zip.

global AreaTypeList = "Ct"

foreach t in Year Quarter { // Quarter Year
	if "`t'" == "Year" { 
		global WindowList = "31 12 13 23"
	}
	if "`t'" == "Quarter" {
		global WindowList = "308 408 412 812"
	}

	foreach areatype in $AreaTypeList { 
		include Code/DataPrep/DefineGeonames.do
		clear
		save $Externals/Calculations/Homescan/TripShares_`areatype'_`t'.dta, emptyok replace
		
		forvalues year = 2004/$MaxYear {
			use $Externals/Calculations/Homescan/Trips/trips_`year'.dta, replace, if store_code_uc!=0
			gen int year = `year'
			replace year = 2006 if `year'<2006
			merge m:1 store_code_uc year using $Externals/Calculations/RMS/Stores-Prepped.dta, keepusing(`geoname') keep(match master) nogen
			rename `geoname' Trip_`geoname'
			drop year
			forvalues l=-4/4 {
				if `year'+`l' < 2004 | `year'+`l' > $MaxYear {
					continue
				}
				local l10 = `l'+10
				gen int panel_year = `year'+`l'
				merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, keepusing(`geoname') keep(master match) nogen
				gen TripShareIn`areatype'_`l10' = cond(Trip_`geoname'==`geoname',1,0) if Trip_`geoname'!=. & `geoname'!=.
				drop panel_year `geoname'
			}
			
			** Collapse 
			gen byte TripCount = 1
			gen byte TripCountWith`areatype' = 1 if Trip_`geoname'!=.
			if "`t'" == "Quarter" {
				gen int YQ = qofd(purchase_date)
				format %tq YQ
				replace YQ = YQ+1 if year(purchase_date)==`year'-1 // Extend Q1 to include the last few days of December, which are included in this panel_year.
				collapse (sum) TripCount TripCountWith`areatype' (mean) TripShareIn`areatype'_*,by(household_code YQ) fast
			}
			if "`t'" == "Year" {
				gen panel_year = `year'
				collapse (sum) TripCount TripCountWith`areatype' (mean) TripShareIn`areatype'_*,by(household_code panel_year) fast
			}
			compress
			append using $Externals/Calculations/Homescan/TripShares_`areatype'_`t'.dta
			saveold $Externals/Calculations/Homescan/TripShares_`areatype'_`t'.dta, replace
		}
	}
}

