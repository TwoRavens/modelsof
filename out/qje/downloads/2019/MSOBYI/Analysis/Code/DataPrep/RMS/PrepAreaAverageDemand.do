/* PrepAreaAverageDemand.do */
* This gets average demand from RMS by area, e.g. by zip code, county, or state
* Absorb regressions absorb YVar for the average OtherMass category store in the zip/zip3/state.
* Then when we predict for the zip code, we predict based on the share of each category, ignoring OtherMass. This correctly gives the predicted YVar in non-mass merchant stores, weighted by store type share, in each area.


/* SETUP */
global HealthVarList = "HealthIndex_per1000Cal lHEI_per1000Cal ShareCoke D_HealthIndex_per1000Cal D_lHEI_per1000Cal D_ShareCoke" // D_g_prot_per1000Cal D_g_fiber_per1000Cal D_g_fat_sat_per1000Cal D_g_sugar_per1000Cal D_g_sodium_per1000Cal D_g_cholest_per1000Cal
global AreaTypeList = "Z Ct" // CZ C9 St" // Z3 


/* ESTIMATE HEALTHFULNESS IN RMS DATA */
use year $HealthVarList Fruit Veg fips_state_code cz cz1990 state_countyFIPS zip_code C_* CaloriesSold NUPCs /// D_Fruit D_Veg
	using $Externals/Calculations/RMS/RMS-Prepped.dta, replace
gen Produce = Fruit+Veg
* gen D_Produce=D_Fruit+D_Veg
global HealthVarList = "$HealthVarList Produce" // D_Produce

gen int zip3 = floor(zip_code/100)

foreach var in $HealthVarList {
	
	** Define weights
	if strpos("`var'","D_")!=0 { // If a demand variable, weight by calories sold
		local Weight = "CaloriesSold"
	}
	else { // If a supply variable, weight by UPCs offered
		local Weight = "NUPCs"
	}
	
	foreach areatype in $AreaTypeList {
		include Code/DataPrep/DefineGeonames.do
		
		areg `var' C_LargeGroc C_SmallGroc C_SuperClub C_Drug C_Conv [pw=`Weight'], absorb(`geoname')
			est store `areatype'_`var'
		
			** Store fixed effects
			preserve 
			predict FE, d 
			collapse (mean) FE `var' [aw=`Weight'], by(`geoname')
			saveold $Externals/Calculations/Geographic/Temp`areatype'_`var'.dta, replace
			restore
	}

}


** Get unconditional average UPCs and calories sold by store type for weights below
foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
	sum NUPCs if C_`cat' == 1
	local NUPCs_`cat' = r(mean)
	
	sum CaloriesSold if C_`cat' == 1
	local CaloriesSold_`cat' = r(mean)
}

/*

nb don't do this, just predict with the zip residual.

** Get list of zips with RMS stores but no ZBP stores. (Many are other mass merchants, which we are explicitly not measuring in ZBP, but a few are convenience stores etc. that ZBP seems to have missed.)
	* these get merged below.
	* Note that there are no RMS stores in zips that are fully excluded from ZBP.
merge m:1 zip_code year using $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta, keepusing(est_Grocery est_SuperClub est_Drug est_Conv) keep(match master)
gen int NStores = est_Grocery+est_SuperClub+est_Drug+est_Conv
keep if NStores==0

* Collapse to zip level
collapse (rawsum) CaloriesSold (mean) $HealthVarList [pw=CaloriesSold],by(zip_code)
saveold $Externals/Calculations/Geographic/Temp_RMSZipsWithNoZPBStores.dta, replace
*/



/* FIT PREDICTED HEALTHFULNESS */
* Get average of ZBP store counts over 2006-2013 RMS period
use zip_code year est_VSmallGroc est_SmallGroc est_LargeGroc est_Grocery est_SuperClub est_Drug est_Conv ///
	using $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta, replace, if year>=2006&year<=$MaxYear

collapse (mean) est_*, by(zip_code)


** Merge county and state
	* Some unmatched from using (if no businesses) and from master (these are sometimes zips within other zips, or PO box zip codes. Presumably there are few if any Homescan households in these.)
	* We are keeping both, but in descriptive statistics we should not include zips that are not in ZipCodeData
merge m:1 zip_code using $Externals/Calculations/Geographic/Z_Data.dta, nogen keep(match master using) keepusing(state_countyFIPS fips_state_code ZipPop) // lnZipMedIncome  
	drop if zip_code == 99999
** Merge CZ
merge m:1 state_countyFIPS using $Externals/Calculations/Geographic/CountytoCZCrosswalk.dta, nogen keep(match master) keepusing(cz cz1990)


** Fill in missing data for the zips not in Zip Business Patterns
* Missing in Zip Business Patterns means zero establishments
foreach var of varlist est_* {
	replace `var' = 0 if `var'==.
}
*gen C_OtherMass = 0 // Ignore Other Mass merchants; we don't have precise store counts in ZBP data; closest we have is "discount department stores" or "general stores," but seems most precise to omit these.

gen NStores = est_Grocery+est_SuperClub+est_Drug+est_Conv

* For fitting nutritional characterististics, put very small grocery stores (fewer than 10 employees as nutritional equivalents to Convenience stores)
	* This worsens predictions so comment out.
*replace est_SmallGroc = est_SmallGroc-est_VSmallGroc
*replace est_Conv = est_Conv+est_VSmallGroc




/* Predict area characteristics */
foreach areatype in $AreaTypeList {
	preserve
	
**** Preparation
	include Code/DataPrep/DefineGeonames.do
	if "`geoname'" != "zip_code" {
		if "`areatype'" == "Z3" {
			gen int zip3 = floor(zip/100)
		}
		collapse (sum) est_* NStores,by(`geoname')
	}
	
	** Get predicted count of UPCs in the area
	gen NUPCs = 0
	foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
		replace NUPCs = NUPCs + est_`cat'*`NUPCs_`cat''
	}
	
	** Get predicted count of calories sold in the zip
	gen CaloriesSold = 0
	foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
		replace CaloriesSold = CaloriesSold + est_`cat'*`CaloriesSold_`cat''
	}
	

	
	
	/* Loop through $HealthVarList and construct fits */
	foreach var in $HealthVarList {
	
		*** Get the C_ variables
		if strpos("`var'","D_")!=0 { // If a demand variable, weight by calories sold
			foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
				gen C_`cat' = est_`cat' * `CaloriesSold_`cat''/CaloriesSold // This gives the weight on each category: category sum calories sold/area sum calories sold.
			}
		}
		else { // If a supply variable, weight by UPCs offered
			foreach cat in SmallGroc LargeGroc SuperClub Drug Conv {
				gen C_`cat' = est_`cat' * `NUPCs_`cat''/NUPCs // This gives the weight on each category: category sum UPCs/area sum UPCs
			}
		}
	
		*** Merge above regression results and predict
		merge 1:1 `geoname' using $Externals/Calculations/Geographic/Temp`areatype'_`var'.dta, keep(match master using) keepusing(FE `var') nogen
		
			* If we wanted to do mean imputation:
			*sum FE, meanonly
			*replace FE = r(mean) if FE==.
		
		* Get xb (prediction based only on county store types)
		est restore `areatype'_`var'
		predict XB, xb

		* Main prediction Pr is the RMS residual adjusted for differences in store counts in RMS vs. the area.
		gen Pr`var' = cond(FE!=.,XB+FE,XB) // If FE (the RMS residual) is missing, just use the prediction based on store type.
		
		* Other demand variables
		rename `var' Rm`var' // RMS raw mean in the area
		rename FE Rs`var' // Residual from the RMS regression: `var' residual of store type
		rename XB St`var' // Prediction based on store type only
		
		* If we wanted mean imputation
		*sum P`var', meanonly
		*replace P`var' = r(mean) if NStores==0 & _m==1 // I am assigning the mean if there are no stores. Limit to _m==1 because if the zip is one of the 32 zips that have a residual (FE) from RMS but no ZBP-listed stores, just use the RMS residual.

		drop C_*
	}
	
	
	drop if `geoname'==.
	
	compress
	saveold $Externals/Calculations/Geographic/`areatype'_DemandInfo.dta, replace
	
	restore
}	



** Erase temporary files
foreach var in $HealthVarList {
	foreach areatype in $AreaTypeList {
		erase $Externals/Calculations/Geographic/Temp`areatype'_`var'.dta
	}
}

*erase Calculations/Geographic/Temp_RMSZipsWithNoZPBStores.dta




/* ESTIMATE HEALTHFULNESS IN HOMESCAN DATA FOR COMPARISON */
foreach areatype in $AreaTypeList {
	use $Externals/Calculations/Homescan/HHxYear.dta, replace
	
	merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
		nogen keep(match master) keepusing(projection_factor zip_code state_countyFIPS cz cz1990 fips_state_code)	
	
	include Code/DataPrep/DefineGeonames.do
	
	if "`areatype'" == "Z3" {
		gen int zip3 = floor(zip_code/100)
	}

	*gen pw = Calories*projection_factor // Calorie weighting worsens the fits to RMS and state educ/income data
	gen pw = projection_factor
	collapse (mean) ShareCoke HealthIndex_per1000Cal Produce [pw=pw], by(`geoname')
	save $Externals/Calculations/Homescan/`areatype'_DemandInfo.dta, replace
}
	



