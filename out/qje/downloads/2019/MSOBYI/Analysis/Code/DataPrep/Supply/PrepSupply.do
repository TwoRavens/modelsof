/* PrepSupply.do */

/* Prep store entry data and ZBP */
include Code/DataPrep/Supply/PrepStoreEntry.do 
include Code/DataPrep/Supply/PrepZipCodeBusinessPatterns



/* Run regression to get predicted Health Index (of UPCs offered, weighted by calories but not by sales) and number of Produce UPCs */
	* Note that we will map LargeGroc (over $5million in grocery UPC revenue) to ZBP as 50+ employees. According to the Economic Census 2007, 20-50 employee grocery stores have mean revenues of $5.357 million, but note that this is total revenues, not just grocery. So this map seems rough but reasonable. See Hunt/Dropbox/NutritionIncomePersonal/Notes/Economic Census spreadsheet.
use $Externals/Calculations/RMS/RMS-Prepped.dta, replace
	* This was the original regression for the table: reg `YVar' Z_lnIncome  C_LargeGroc C_SmallGroc C_SuperClub C_Conv C_OtherMass, cluster(zip_code)
		* This is that same regression:
reg HealthIndex_per1000Cal Z_lnIncome C_LargeGroc C_SmallGroc C_SuperClub C_Drug C_Conv C_OtherMass, cluster(zip_code) nocons
	est store PredHealthIndex
reg lHEI_per1000Cal Z_lnIncome C_LargeGroc C_SmallGroc C_SuperClub C_Drug C_Conv C_OtherMass, cluster(zip_code) nocons
	est store PredlHEI
reg NProduce Z_lnIncome  C_LargeGroc C_SmallGroc C_SuperClub C_Drug C_Conv C_OtherMass, cluster(zip_code) nocons
	est store PredNProduce
reg ShareCoke Z_lnIncome  C_LargeGroc C_SmallGroc C_SuperClub C_Drug C_Conv C_OtherMass, cluster(zip_code) nocons
	est store PredShareCoke
	
/*reg NUPCs Z_lnIncome  Div_? C_LargeGroc C_SmallGroc C_SuperClub C_DrugConv C_OtherMass, cluster(zip_code) nocons
	est store PredNUPCs 
*/
** Get unconditional average UPCs and Coke/Pepsi calories by store type for weights below
	foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
		sum NUPCs if C_`cat' == 1
		local NUPCs_`cat' = r(mean)/1000 // Make UPCs in units of 1000s
		sum CaloriesSoldCokePepsi if C_`cat' == 1
		local CaloriesSoldCokePepsi_`cat' = r(mean) 
	}
	
/* Attribute-specific regressions
	* Note that this doesn't have Fruit or Veg yet, will have to decide how to treat that because the nutrient variables are in a different format
global Attributes = "g_fiber_per1000Cal g_prot_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal"
foreach att in $Attributes {
	reg `att' Z_lnIncome  Div_? C_LargeGroc C_SmallGroc C_SuperClub C_DrugConv C_OtherMass, cluster(zip_code)
	est store `att'
}
*/

/* COLLAPSE TO ZIPCODE-LEVEL DATASET OF SUPPLY CHARACTERISTICS */
clear
save $Externals/Calculations/Geographic/ZipCodeSupplyInfo.dta, replace emptyok
** Loop over years. This is needed because when we merge in the zip codes in ZipCodeData, we need a full set for each year.
forvalues year = 2003/$MaxYear {
	use zip_code year est_Grocery est_VSmallGroc est_SmallGroc est_MediumGroc est_LargeGroc est_SuperClub est_DrugConv est_Drug est_Conv est_Meat est_Seafood est_FruitVeg est_OtherSpec ///
		using $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta, replace, if year==`year'
	
	** Get census region
		* Some unmatched from using (if no businesses) and from master (these are sometimes zips within other zips, or PO box zip codes. Presumably there are few if any Homescan households in these.)
		* We are keeping both, but in descriptive statistics we should not include zips that are not in ZipCodeData
	merge m:1 zip_code using $Externals/Calculations/Geographic/Z_Data.dta, nogen keep(match master using) keepusing(Div_? Z_lnIncome  ZipPop) //  
		drop if zip_code == 99999
	** Fill in missing data for the zips not in Zip Business Patterns
	replace year = `year' if year==.
	* Missing in Zip Business Patterns means zero establishments
	foreach var of varlist est_* {
		replace `var' = 0 if `var'==.
	}
	gen est_LSmallGroc = est_SmallGroc-est_VSmallGroc // Larger small grocery
	gen est_Large = est_LargeGroc+est_SuperClub // Count of large grocery retailers
	gen int NStores = est_Grocery+est_SuperClub+est_DrugConv
	gen C_OtherMass = 0 // Ignore Other Mass merchants; we don't have precise store counts in ZBP data; closest we have is "discount department stores" or "general stores," but seems most precise to omit these.
		* For fitting nutritional characterististics, put very small grocery stores (fewer than 10 employees as nutritional equivalents to Convenience stores). We only use the NUPCs variable from these fits, and this is especially important for NUPCs even if questionable for average HealthIndex.
	replace est_SmallGroc = est_SmallGroc-est_VSmallGroc
	replace est_Conv = est_Conv+est_VSmallGroc
	

	/* Predict mean ShareCoke, mean Health Index, and count of produce UPCS */ 
	*** Get prediced count of Coke and Pepsi calories in the zip
		* These are the weights for the Share Coke
	gen CaloriesSoldCokePepsi = 0
	foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
		replace CaloriesSoldCokePepsi = CaloriesSoldCokePepsi + est_`cat'*`CaloriesSoldCokePepsi_`cat''
	}
	*** Share Coke
	foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
		gen C_`cat' = est_`cat' * `CaloriesSoldCokePepsi_`cat''/CaloriesSoldCokePepsi // This gives the weight on each category: category sum UPCs/zip sum UPCs.
	}
	est restore PredShareCoke
	predict meanShareCoke
	
	sum meanShareCoke
	replace meanShareCoke = r(mean) if NStores==0 // I am assigning the average health index if there are no grocery, supercenter, club, drug, or convenience stores
	foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
		drop C_`cat'
	}
	
	*** Produce
	* Get the C_ variables. These are store-weighted averages, then multiplied by the number of stores
	foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
		gen C_`cat' = est_`cat'/NStores
	}
	est restore PredNProduce
	predict meanNProduce
	gen NProduceUPCs = NStores*meanNProduce/1000 // In thousands. Note that a very small handful are negative.
	replace NProduceUPCs = 0 if NStores==0
	drop meanNProduce
	
	*** Get predicted count of UPCs in the zip
		* These are weights for the health index
	gen NUPCs = 0
	foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
		replace NUPCs = NUPCs + est_`cat'*`NUPCs_`cat''
	}
	foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
		drop C_`cat' 
	}
	
	*** Mean Health Index
	* Get the C_ variables
	foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
		gen C_`cat' = est_`cat' * `NUPCs_`cat''/NUPCs // This gives the weight on each category: category sum UPCs/zip sum UPCs.
	}
	foreach measure in HealthIndex lHEI {
		est restore Pred`measure'
		predict mean`measure'
		
		sum mean`measure'
		replace mean`measure' = r(mean) if NStores==0 // I am assigning the average health index if there are no grocery, supercenter, club, drug, or convenience stores
	}
	drop C_*
	
	/* Predict mean attribute 
	foreach att in $Attributes {
		est restore `att'
		predict `att'
		* Should discuss how to impute if no stores in the zip.
	}
	*/

	/* Per capita variables */
	foreach var in NProduceUPCs est_Large est_LargeGroc est_SuperClub {
		gen `var'_Pop = `var'/ZipPop * 1000 // Per thousand people in the zip code
	}

	
	* Replace est variables with original data (undoes code above)
	replace est_SmallGroc = est_SmallGroc + est_VSmallGroc
	replace est_Conv = est_Conv-est_VSmallGroc
	
	drop Z_lnIncome  Div_*
	
	compress
	append using $Externals/Calculations/Geographic/ZipCodeSupplyInfo.dta
	save $Externals/Calculations/Geographic/ZipCodeSupplyInfo.dta, replace	
}


** Get log of the number of produce UPCs.
sum NProduceUPCs
gen lnNProduceUPCs = ln(NProduceUPCs+abs(r(min))+0.001) // Add min and one UPC (measured in 000s) to make all non-missing


** Label variables
label var meanShareCoke "Zip code store type share Coke"
label var meanHealthIndex "Zip code store type Health Index"
label var meanlHEI "Zip code store type Health Index"
label var NProduceUPCs "Zip code store type produce UPCs"

save $Externals/Calculations/Geographic/ZipCodeSupplyInfo.dta, replace	


/* Re-do with averages for all zips within 3-mile radius of centroid */
** Do for individual years to speed up the sums
clear 
save $Externals/Calculations/Geographic/ZipCodeSupplyInfo_3m.dta, replace emptyok
forvalues year = 2003/$MaxYear {
use $Externals/Calculations/Geographic/ZipCodeSupplyInfo.dta, replace, if year==`year'

** Merge in zip code centroid
	* Keep zip codes that don't have stores in case they are near RMS store zips
merge m:1 zip_code using $Externals/Calculations/Geographic/Z_Data.dta, keep(match master using) nogen keepusing(*Centroid*)

** Create 3 mile distance variables
foreach var in meanHealthIndex meanlHEI NProduceUPCs NUPCs NStores est_Large est_LargeGroc est_SuperClub est_LSmallGroc ///
	NProduceUPCs_Pop est_Large_Pop est_LargeGroc_Pop est_SuperClub_Pop {
	gen `var'_3m = .
}

** Populate with weighted averages of nearby zips
local N = _N


forvalues n = 1/`N' {
	display "This is year `year', row `n'."
	quietly { 
		local zip = zip_code[`n']
		local ziplat = ZipCentroid_lat[`n']
		if `ziplat' == . {
			continue
		}
		local ziplon = ZipCentroid_lon[`n']
			
		geodist ZipCentroid_lat ZipCentroid_lon `ziplat' `ziplon', gen(Distance) miles sphere
		
		* Weighted average variables
		foreach var in meanHealthIndex meanlHEI {
			sum `var' [aw=NStores] if Distance<=3&year==`year', meanonly
			replace `var'_3m = r(mean) if _n==`n'
		}
		* Sum variables
		foreach var in NStores NProduceUPCs NUPCs est_Large est_LargeGroc est_SuperClub {
			sum `var' if Distance<=3&year==`year'
			replace `var'_3m = r(sum) if _n==`n'
		}
		* Population-normalized variables; weight by population
		foreach var in NProduceUPCs est_Large est_LargeGroc est_SuperClub {
			sum `var'_Pop [aw=ZipPop] if Distance<=3&year==`year'
			replace `var'_Pop_3m = r(mean) if _n==`n'
		}
		drop Distance

	}
}
append using $Externals/Calculations/Geographic/ZipCodeSupplyInfo_3m.dta
save $Externals/Calculations/Geographic/ZipCodeSupplyInfo_3m.dta, replace
}
drop *Centroid*

foreach var in HealthIndex lHEI {
	sum mean`var'_3m
	replace mean`var'_3m = r(min) if NStores_3m==0 // I am assigning the worse health index observed if there are no stores
}

foreach var in NProduceUPCs est_Large est_LargeGroc est_SuperClub {
	replace `var'_3m = 0 if NStores_3m==.|NStores_3m==0
}


sum NProduceUPCs_3m
gen lnNProduceUPCs_3m = ln(NProduceUPCs_3m+abs(r(min))+0.001)

compress
save $Externals/Calculations/Geographic/ZipCodeSupplyInfo_3m.dta, replace
