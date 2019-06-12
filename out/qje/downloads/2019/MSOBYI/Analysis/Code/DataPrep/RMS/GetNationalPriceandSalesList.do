/* GetNationalPriceandSalesList.do */
* Gets UPC-by-year total sales and average prices


/* GET NATIONAL PRICE AND SALES LIST */
clear
save $Externals/Calculations/RMS/NationalPriceandSalesList.dta, replace emptyok

forvalues year = 2006/$MaxYear {

	/* Get UPC version */
	insheet using $Nielsen/RMS/`year'/Annual_Files/rms_versions_`year'.tsv, clear
	format upc %12.0f
	drop panel_year
	saveold $Externals/Calculations/RMS/rms_versions_`year'.dta, replace
	
	/* Open collapsed movement files and get UPC prices */
	foreach d in 1 2 3 4 5 6 { // 0 is health&beauty (includes diet aids and vitamins); 8 is alcohol (see ImportHomescan.do; these are excluded from all analysis. 7 is non-food grocery, and 9 is general merchandise. 9999 has prices but is "unclassified," and we have no UPC info for them (e.g. no calorie info), so leave out.
		display "This is department `d' for year `year'."
		use $Externals/Calculations/RMS/MovementUPCStoreYear_`d'_`year'.dta, replace
			if _N==0 {
				continue
			}
		** Merge UPC version
		merge m:1 upc using $Externals/Calculations/RMS/rms_versions_`year'.dta, keep(match master) nogen keepusing(upc_ver_uc)

		** Collapse to UPC-by-year level
		collapse (rawsum) units (mean) price [pw=units], by(upc upc_ver_uc)
		gen int year = `year'
		merge m:1 year using $Externals/Calculations/CPI/CPI_Annual.dta, keep(match master) nogen keepusing(CPI)
		replace price = price/CPI
		drop CPI
		append using $Externals/Calculations/RMS/NationalPriceandSalesList.dta
		compress
		saveold $Externals/Calculations/RMS/NationalPriceandSalesList.dta, replace 
	}
}

/*
** Collapse across years to the UPC level
use Calculations/RMS/NationalPriceandSalesList.dta, replace 
collapse (rawsum) NationalUnits = units (mean) NationalPrice = price [pw=units], by(upc upc_ver_uc)
saveold Calculations/RMS/NationalPriceandSalesList.dta, replace 
*/
