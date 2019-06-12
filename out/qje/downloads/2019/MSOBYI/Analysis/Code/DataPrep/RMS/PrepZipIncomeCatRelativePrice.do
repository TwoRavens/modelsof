/* PrepZipIncomeCatRelativePrice.do */
* This preps the sales-weighted average price of baskets of healthy and unhealthy UPCs, by zip code median income category

/* SETUP */
capture cd C:/Users/Hunt/Dropbox/NutritionIncomeFinal/Analysis	
capture cd /home/data/desert/Analysis
local year = 2012

/* Set up file */
clear
save Calculations/RMS/AveragePricebyUPCandZipMedIncome.dta, replace emptyok

/* GET SALES-WEIGHTED AVERAGE PRICE OF EACH UPC, BY ZIP MEDIAN INCOME */
	foreach d in 1 2 3 4 5 6 9999 {
		use Calculations/RMS/MovementUPCStoreYear_`d'_`year'.dta, replace
		if _N==0 {
			continue
		}
		** Deflate
		gen int year = `year'
		merge m:1 year using Calculations/CPI/CPI_Annual.dta, keep(match master) nogen keepusing(CPI)
		replace price = price/CPI
		drop CPI
		
		if _N==0 {
			continue
		}
		
		merge m:1 store_code_uc year using Calculations/RMS/RMS-Prepped.dta, keep(match) keepusing(ZipMedIncomeGroup) nogen
		
		collapse (rawsum) ZipMedIncomeGroup_units = units (mean) ZipMedIncomeGroupAveragePrice = price [pw=units], by(ZipMedIncomeGroup upc)
		append using Calculations/RMS/AveragePricebyUPCandZipMedIncome.dta
		saveold Calculations/RMS/AveragePricebyUPCandZipMedIncome.dta, replace
	}



/* MERGE NATIONAL PRICE AND SALES LIST AND GET ZIP PRICE INDEX */
use Calculations/RMS/AveragePricebyUPCandZipMedIncome.dta, replace
gen year = `year'
merge m:1 upc using Calculations/RMS/rms_versions_`year'.dta, keep(match master) nogen keepusing(upc_ver_uc)
merge m:1 upc upc_ver_uc year using Calculations/RMS/NationalPriceandSalesList.dta, nogen keep(match) keepusing(price units)
merge m:1 upc upc_ver_uc using Calculations/OtherNielsen/Prepped-UPCs.dta, keep(match master) nogen ///
	keepusing(HealthIndex_per1 cals_per1 Fruit Veg NonFood)
	
	drop if NonFood==1

	gen UPCCat = "Healthy" if Fruit==0&Veg==0 & HealthIndex_per1>0 & HealthIndex_per1!=. 
	replace UPCCat = "Unhealthy" if HealthIndex_per1<0 & HealthIndex_per1!=.
	replace UPCCat = "Produce" if Fruit==1|Veg==1 
	
	gen cals = cals_per1 * units
	
	gen RelativePrice = ZipMedIncomeGroupAveragePrice/price
	
	collapse (mean) RelativePrice [pw=cals], by(UPCCat ZipMedIncomeGroup)
	
saveold Calculations/RMS/ZipIncomeCatRelativePrice.dta, replace



