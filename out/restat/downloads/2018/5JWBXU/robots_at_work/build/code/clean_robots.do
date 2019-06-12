* constructing measures of robot stocks (end of year)

u "..\temp\robots_raw", clear
	
* keep industries that add up to aggregate
	keep if ( level==1 & subcategories=="No" ) | level==2
	
* drop countries
	drop if country=="CZE" | country=="EST" 		///
		| country=="LTU" | country=="LVA" | country=="MLT" 		///
		| country=="SVK"  | country=="SVN"  | country=="POL" 	///
		| country=="PRT"  | country=="RUS" | country=="JPN"
	
* compute adjustment ratio for US (since includes CAN, MEX before 2011)
	do clean_robots_adjust_US
		drop if country=="CAN" | country=="MEX"
		
* impute deliveries based on totals, where necessary 
	do clean_robots_impute
	
* clean stock variables, create new ones
	do clean_robots_stocks // this also adjusts the US robots stock

* merge with price data
	merge m:1 year using "..\input\IFR\robots_prices_12"
		keep if _mer==3
			drop _mer
		
* collapse robots data to robots industries

		// collapse 29a, 30, equivalent to 34t35 in EUKLEMS
		replace code_robots = "29a" if code_robots=="30"
	
	collapse ( sum ) delvrd* stock stock_clean_12  ///
		stock_pim* ( mean ) imp_delvrd imp_stock_clean price_robots adjustUS, by(country year code_robots)

* industry names
	do rename_robots_industries
		
* labels

	do labels_robots		
	
	order country year code_robots ind_robots delvrd delvrd_raw imp_delvrd stock 	///
		stock_clean_12 imp_stock_clean stock_pim_10 price_robots adjustUS_delvrd
		
sa "..\temp\robots_clean", replace
