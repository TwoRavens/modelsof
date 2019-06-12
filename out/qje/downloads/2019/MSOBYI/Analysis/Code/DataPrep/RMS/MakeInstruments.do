/* MakeInstruments.do */
* This constructs the price instruments
/*
6-2018: This has all be incorporated RD other Deflate prices in MovementUPCStoreYear. Not sure what this means.

Note 7-2017 from Hunt
Next time we remake these data, we should change the following:
1. Deflate prices in MovementUPCStoreYear
2. Use parent code instead of retailer code as in the optimal soda tax construction.
3. NationalPriceAndSalesList is now at the UPC-by-year level.

*/

/* SET UP */
/* File locations */
*global RMSData = "../../NutritionandIncomePersonal/Nielsen/KiltsOriginalFiles/nielsen_extracts/RMS" // on Hunt's computer only
*global Temp = "../../NutritionandIncomePersonal/Analysis/Calculations/RMS/" // This will hold large temporary files
*global Temp = "../../NutritionRD/" // This will hold large temporary files

global yearlist = "2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016"

/* Set up files */
*clear
*save "$Externals/Calculations/RMS/Instruments_DMALevel.dta", emptyok replace 

clear
save "$Externals/Calculations/RMS/Instruments_CountyLevel.dta", emptyok replace 
*save $temp/Instruments_zip3Level.dta, emptyok replace 

*clear 
*save "$Externals/Calculations/RMS/CountyPrices.dta", emptyok replace

*clear
*save "$Externals/Calculations/RMS/GroupbyYearAveragePrices.dta", emptyok replace

*clear
*save "$Externals/Calculations/RMS/CountyGroupPriceIndex.dta", emptyok replace


/* Get stores file with DMAs in it */
/*
foreach year in $yearlist {
	
	insheet using $RMSData/`year'/Annual_Files/stores_`year'.tsv, clear
	save Calculations/RMS/stores_`year'.dta, replace
}
*/

	

/*
**Collect County Price Index
foreach year in $yearlist {
	foreach d in 1 2 3 4 5 6 { // 0 is health&beauty (includes diet aids and vitamins); 8 is alcohol (see ImportHomescan.do; these are excluded from all analysis. 7 is non-food grocery, and 9 is general merchandise. 9999 has prices but is "unclassified," and we have no UPC info for them (e.g. no calorie info), so leave out.
		display "This is department `d' for year `year'."
		use "$Externals/Calculations/RMS/MovementUPCStoreYear_`d'_`year'.dta", replace
			if _N==0 {
				continue
			}
		** Merge UPC version
		merge m:1 upc using "$Externals/Calculations/RMS/rms_versions_`year'.dta", keep(match master) nogen keepusing(upc_ver_uc)

		** Merge in cals and group code
		merge m:1 upc upc_ver_uc using "$Externals/Calculations/OtherNielsen/Prepped-UPCs.dta", keep(match) nogen ///
			keepusing(group cals_per1 NonFood)
		
		drop if NonFood==1
		drop NonFood
		
		*Get County
		gen year=`year'
		merge m:1 store_code_uc year using "$Externals/Calculations/RMS/Stores-Prepped.dta", keep(match master) keepusing(ChainCodeForIV fips_state_code fips_county_code) nogen

		*Get Nationwide units sold
		merge m:1 upc upc_ver_uc year using "$Externals/Calculations/RMS/NationalPriceandSalesList.dta",  keep(match master) keepusing(units) nogen
		rename units NationalUnits
		
		gen CaloriesSold = round(cals_per1*NationalUnits)
		gen price_per_cal=price/cals_per1
		
		
		collapse  (rawsum) CaloriesSold (mean) price_per_cal [fw=CaloriesSold], by(fips_state_code fips_county_code year)
		
		
		gen dep=`d'
		append using "$Externals/Calculations/RMS/CountyPrices.dta"
		saveold "$Externals/Calculations/RMS/CountyPrices.dta", replace 
		}
}
	collapse  (rawsum) CaloriesSold (mean) price_per_cal [fw=CaloriesSold], by(fips_state_code fips_county_code year)
	saveold "$Externals/Calculations/RMS/CountyPrices.dta", replace 
	

*/




/* LOOP OVER YEARS AND CONSTRUCT INSTRUMENTS */
foreach year in $yearlist {
	foreach d in   2 3 4 5 6 1 { // 0 is health&beauty (includes diet aids and vitamins); 8 is alcohol (see ImportHomescan.do; these are excluded from all analysis. 7 is non-food grocery, and 9 is general merchandise. 9999 has prices but is "unclassified," and we have no UPC info for them (e.g. no calorie info), so leave out.
		display "This is department `d' for year `year'."
		
		
		/* Get UPC-by-store prices list */
			* Do these merges all at once because they are each used multiple times and the merges are time-consuming.
		use "$Externals/Calculations/RMS/MovementUPCStoreYear_`d'_`year'.dta", replace // , if _n<100000 // temporary limit on observations for de-bugging
		compress // Units is sometimes long, but can be int.
		/*if _N==0 {
			continue
		}
		*/
		gen year = `year'
		** Merge store code
		merge m:1 store_code_uc year using "$Externals/Calculations/RMS/Stores-Prepped.dta", keep(match master) keepusing(ChainCodeForIV fips_state_code fips_county_code)
		
		** Merge UPC version and our group code 
		merge m:1 upc using "$Externals/Calculations/RMS/rms_versions_`year'.dta", keep(match master) nogen keepusing(upc_ver_uc)
		merge m:1 upc upc_ver_uc using "$Externals/Calculations/OtherNielsen/Prepped-UPCs.dta", keep(match) nogen ///
			keepusing(group energy_per1 NonFood)
		
		
			** In some cases we may not have calories or groups at all. In this case, advance to the next.
			sum energy_per1
			if r(N)==0|r(mean)==0 {
				continue
			}
			
			
		drop if NonFood==1
		drop NonFood
		gen CaloriesSold = energy_per1*units
		gen PricePerCal = price/energy_per1
		gen Revenues = units*price
		
			** De-mean (dm stands for de-meaned)
			*rename price local_price
			*merge m:1 upc upc_ver_uc year using "$Externals/Calculations/RMS/NationalPriceandSalesList.dta", nogen keep(match master) keepusing(price)
			*rename price NationalPrice
			*rename local_price price
			*gen dm_price = price-NationalPrice
			*gen dm_PricePerCal = dm_price/energy_per1
		
		keep store_code_uc ChainCodeForIV fips_state_code fips_county_code year upc upc_ver_uc group Revenues PricePerCal CaloriesSold energy_per1 price units
		 
		*saveold $Temp/RMS_UPCbyStorePrices_`d'_`year'.dta, replace
	
		
		
		/* Get Quality Index */
		/*
			* For each zip and product group, the average price of all UPCs sold (weighted by national units of each UPC)
		use $Temp/RMS_UPCbyStorePrices_`d'_`year'.dta, replace
		** collapse to a list of UPCs sold in each zip3
		collapse (first) group cals_per1, by(store_zip3 upc upc_ver_uc)
		merge m:1 upc upc_ver_uc using Calculations/RMS/NationalPriceandSalesList.dta, keepusing(NationalPrice NationalUnits) keep(match) nogen
		
			
		gen Rev=NationalUnits*NationalPrice	
		gen cals=cals_per1*NationalUnits
		
		** collapse to the quality index by product group, weighting by national sales
		collapse (rawsum) Rev cals   (mean) NationalPrice [fw=NationalUnits], by(store_zip3 group)
		gen ZipGroupPricePerCalIndex=Rev/cals
		drop Rev cals
		rename NationalPrice ZipGroupPriceIndex
		
		gen year = `year'
		append using Calculations/RMS/ZipGroupPriceIndex.dta
		saveold Calculations/RMS/ZipGroupPriceIndex.dta, replace
		*/
		
		
		/* Get Diamond instruments */ 
			* These instrument for prices by zip3. (Finer variation than DMA.)
		*use $Temp/RMS_UPCbyStorePrices_`d'_`year'.dta, clear, if retailer_code!=. // Requires knowing retailer_code
		
		bysort store_code_uc: egen StoreUnits=total(units)
		bysort store_code_uc: egen StoreGroupRevenues = total(Revenues)
		bysort ChainCodeForIV: egen MeanStoreGroupRevenues = mean(StoreGroupRevenues)
				
		** Get retailer_code-level average price per calorie by UPC, leaving out establishments of that chain in the same area
		*bysort retailer_code upc upc_ver_uc store_zip3: egen retailerzipUPC_TotalPrice = total(PricePerCalorie)
		*bysort retailer_code upc upc_ver_uc store_zip3: gen retailerzipUPC_TotalStores = _N
		
		** collapse to the county by retailer by UPC level
		gen Stores = 1
		collapse (first) MeanStoreGroupRevenues group energy_per1 (sum) StoreUnits Stores (mean) price PricePerCal, by( year ChainCodeForIV upc upc_ver_uc fips_state_code fips_county_code )
		gen SxPrice = Stores * price
		gen SxPricePerCal = Stores * PricePerCal
		*gen Sxdm_PricePerCal = Stores * dm_PricePerCal
		
		gen UxPrice=StoreUnits*price
		
		** Get numerator and denominator of fraction for mean (LO mean price per cal across stores)
		bysort ChainCodeForIV upc upc_ver_uc: egen retailerUPC_TotalPrice = total(SxPrice)
		bysort ChainCodeForIV upc upc_ver_uc: egen retailerUPC_TotalPricePerCal = total(SxPricePerCal)
		*bysort ChainCodeForIV upc upc_ver_uc: egen retailerUPC_Totaldm_PricePerCal = total(Sxdm_PricePerCal)
		bysort ChainCodeForIV upc upc_ver_uc: egen retailerUPC_Stores = total(Stores)
		
		
		** Get number and denominator for national prices excluding zipcode
		bysort upc upc_ver_uc: egen UPC_TotalPrice = total(UxPrice)
		bysort upc upc_ver_uc: egen UPC_TotalUnits = total(StoreUnits)
		
		bysort upc upc_ver_uc fips_state_code fips_county_code : egen CountyUPC_TotalPrice = total(UxPrice)
		bysort upc upc_ver_uc fips_state_code fips_county_code : egen CountyUPC_TotalUnits = total(StoreUnits)
		
		
		** Get the average price per cal for each UPC at each retailer from stores outside the zip3
			* Some may be missing if the retailer's only store(s) are in one zip3
		gen retailerUPC_LO_Price = (retailerUPC_TotalPrice-SxPrice)/(retailerUPC_Stores-Stores)
		gen retailerUPC_LO_PricePerCal = (retailerUPC_TotalPricePerCal-SxPricePerCal)/(retailerUPC_Stores-Stores)
		*gen retailerUPC_LO_dm_PricePerCal = (retailerUPC_Totaldm_PricePerCal-Sxdm_PricePerCal)/(retailerUPC_Stores-Stores)
	
		gen NationalPrice=((UPC_TotalPrice-CountyUPC_TotalPrice)/(UPC_TotalUnits-CountyUPC_TotalUnits))/energy_per1
		gen UnitWeight=UPC_TotalUnits-CountyUPC_TotalUnits
		gen retUPC_LO_dm_noCounty_PriceCal=(retailerUPC_LO_Price/energy_per1)-NationalPrice
		
		gen lnretUPC_LO_dm_noCounty_PriceCal=ln(retailerUPC_LO_Price/energy_per1)-ln(NationalPrice)
		* Now we have a dataset by retailer by area and UPC of average price charged at other establishments within the same retailer outside the area.
	    
		** Collapse across UPCs to the retailer-by-group-by-area level, weighting by the national sales of each UPC
		merge m:1 upc upc_ver_uc year using "$Externals/Calculations/RMS/NationalPriceandSalesList.dta", keepusing(units) keep(match) nogen
		rename units NationalUnits
		
		
		gen NationalCals=round(NationalUnits*energy_per1)
		gen NRevs=retailerUPC_LO_Price*NationalUnits
		
		
		keep if retUPC_LO_dm_noCounty_PriceCal~=.
		
		
		collapse (first) MeanStoreGroupRevenues  (rawsum) UnitWeight NationalCals retailer_LO_Price=NRevs (mean) NationalPrice reLO_dm_noCounty_PriceCal=retUPC_LO_dm_noCounty_PriceCal ///
		lnretLO_dm_noCounty_PriceCal=lnretUPC_LO_dm_noCounty_PriceCal retailer_LO_PricePerCal = retailerUPC_LO_PricePerCal  ///
			[fw=NationalCals], by(fips_state_code fips_county_code year  ChainCodeForIV group) // So we now have average price per calorie of UPCs within a group, as determined by the prices charged by other establishments within the retailer outside the county.
		gen retailer_LO_PricePerCal2=retailer_LO_Price/NationalCals
		
		** Collapse to the group-by-area level, weighting by the retailer's average revenues in that product group
		collapse (first) UnitWeight (mean) LO_PricePerCal2 = retailer_LO_PricePerCal2  LO_PricePerCal = retailer_LO_PricePerCal  ///
		lnLO_dm_noCounty_PricePerCal=lnretLO_dm_noCounty_PriceCal LO_dm_noCounty_PricePerCal=reLO_dm_noCounty_PriceCal NationalPrice ///
			[pw=MeanStoreGroupRevenues], by(fips_state_code fips_county_code year group)
		
		
		
		append using "$Externals/Calculations/RMS/Instruments_CountyLevel.dta"
		saveold "$Externals/Calculations/RMS/Instruments_CountyLevel.dta", replace
		
		
		
		
		/*
		/* Get Hausman instruments */
			* Both prices and de-meaned prices
			* Use prices outside the DMA
		use $Temp/RMS_UPCbyStorePrices_`d'_`year'.dta, replace
		
		** Collapse to the DMA-by-group level
		collapse (rawsum) CaloriesSold (mean) PricePerCal dm_PricePerCal [pw=CaloriesSold], by(group dma_code)
		
		** Construct leave-out mean (LO for leave-out)
		gen Expend = PricePerCal*CaloriesSold
		gen dm_Expend = dm_PricePerCal*CaloriesSold

		egen TotalExpend = total(Expend)
		egen Totaldm_Expend = total(dm_Expend)
		egen TotalCaloriesSold = total(CaloriesSold)
		
		gen LO_PricePerCal = (TotalExpend-Expend)/(TotalCalories-Calories)
		gen LO_dm_PricePerCal = (Totaldm_Expend-dm_Expend)/(TotalCalories-Calories)
		
		keep dma_code group LO_PricePerCal LO_dm_PricePerCal
		gen year = `year'
		
		append using Calculations/RMS/Instruments_DMALevel.dta
		saveold Calculations/RMS/Instruments_DMALevel.dta, replace
		
		*/
		
			
		/* Get average price by group and year */
			* For comparison and tests of first stages
	*	use $Temp/RMS_UPCbyStorePrices_`d'_`year'.dta, replace 
*		collapse (mean) PricePerCal dm_PricePerCal [pw=CaloriesSold], by(group)*
*		gen year = `year'
*		append using Calculations/RMS/GroupbyYearAveragePrices.dta
*		saveold Calculations/RMS/GroupbyYearAveragePrices.dta, replace
		
*		erase $Temp/RMS_UPCbyStorePrices_`d'_`year'.dta
		
	
	}
}

/*
*Create Percentile Instrument Measure
use Calculations/RMS/Instruments_zip3Level.dta, clear
sort group lnLO_dm
by group: gen order=[_n]/[_N]
saveold   Calculations/RMS/Instruments_zip3Level.dta, replace

*Make group nutrient instruments
use Calculations/RMS/NationalPriceandSalesList.dta, clear
merge 1:1 upc upc_ver_uc using Calculations/OtherNielsen/Prepped-UPCs.dta, keep(match) nogen

gen NationalCals=round(NationalUnits*cals_per1)
gen StoreTime30=StoreTime
replace StoreTime30=30 if StoreTime>30
gen StoreTime365=StoreTime
replace StoreTime365=365 if StoreTime>365

replace Fruit=1000*Fruit*Grams/cals_per1
replace Veg=1000*Veg*Grams/cals_per1
drop if cals_per1==0
collapse (mean) StoreTime30 StoreTime365 Convenience *_per1000Cal Fruit Veg [fw=NationalCals], by(group)

saveold Calculations/RMS/Instruments_group.dta, replace





/* Tests */
use Calculations/RMS/Instruments_DMALevel.dta, replace
merge m:1 group year using Calculations/RMS/GroupbyYearAveragePrices.dta
reg PricePerCal LO_PricePerCal

use Calculations/RMS/Instruments_zip3Level.dta,clear
merge m:1 group year using Calculations/RMS/GroupbyYearAveragePrices.dta
reg PricePerCal LO_PricePerCal

*/
