/* InsertHealthMeasures.do */
* This script inserts HealthIndex and other health measures that do not aggregate up from the UPC level and thus must be inserted 
	* into household-by-time data.

** Define list of health measures	
local MeasureList = "HealthIndex_per1000Cal lHEI_per1000Cal" 

/* Define program to insert HRS nutrient score in a dataset */
capture program drop InsertRawNutrientScore
program define InsertRawNutrientScore
	** Define dietary guidelines in grams per 1000 calories
		* Based on the 2000 calorie diet recommendations here: https://www.fda.gov/Food/LabelingNutrition/ucm274593.htm
	local DG_fiber = 12.5
	local DG_fat = 32.5
	local DG_fat_sat = 10
	local DG_sodium = 1.2
	local DG_cholest = 0.15
	
	capture drop rNutrientScore
	gen rNutrientScore = 0 // r for "raw"
	foreach nutrient in fiber { // "lower bound"
		replace rNutrientScore = rNutrientScore + ((g_`nutrient'_per1000Cal - `DG_`nutrient'')/`DG_`nutrient'')^2 ///
			if g_`nutrient'_per1000Cal < `DG_`nutrient''
	}
	foreach nutrient in fat fat_sat sodium cholest { // "upper bound"
		replace rNutrientScore = rNutrientScore + ((g_`nutrient'_per1000Cal - `DG_`nutrient'')/`DG_`nutrient'')^2 ///
			if g_`nutrient'_per1000Cal > `DG_`nutrient''
	}
	replace rNutrientScore = rNutrientScore^(-1)
	
	** Winsorize outlying nutrient scores
	sum rNutrientScore, d
	*replace rNutrientScore=. if (r`measure'>`r(p99)' | r`measure'<`r(p1)') & rNutrientScore!=.
	replace rNutrientScore=r(p99) if rNutrientScore>r(p99) & rNutrientScore!=.
	replace rNutrientScore=r(p1) if rNutrientScore<r(p1)
end

/* Define program to insert HEI */
capture program drop InsertRawHEI
program define InsertRawHEI
	capture drop rHEI
	gen rHEI = 0
	/* Total Fruits */
	replace rHEI = rHEI + min(5,5*fruits_total/0.8) if fruits_total!=.
	
	/* Whole Fruits */
	replace rHEI = rHEI + min(5,5*fruits_whole/0.4) if fruits_whole!=.
	
	/* Total Veggies */
	replace rHEI = rHEI + min(5,5*veggies/1.1) if veggies!=.
	
	/* Greens + Beans */
	replace rHEI = rHEI + min(5,5*greens_beans/0.2) if greens_beans!=.
	
	/* Whole Grains */
	replace rHEI = rHEI + min(10,10*whole_grains/1.5) if whole_grains!=.
	
	/* Dairy */
	replace rHEI = rHEI + min(10,10*dairy/1.3) if dairy!=.
	
	/* Total Protein */
	replace rHEI = rHEI + min(5,5*total_protein/2.5) if total_protein!=.
	
	/* Seafood/Plant Protein */
	replace rHEI = rHEI + min(5,5*sea_plant_prot/0.8) if sea_plant_prot!=.
	
	/* Fat ratio. Recommended 2.5, minimum 1.2, if less then 1.2 no increase in HEI */
	gen fat_ratio = (mon_unsat_fat_g + poly_unsat_fat_g) / satfat_g
	replace fat_ratio = 0 if fat_ratio == . // If any component missing, zero points
	replace fat_ratio = 2.5 if satfat_g == 0 // if fat_ratio missing, then give full points	
	replace rHEI = rHEI + min(10,10*(fat_ratio - 1.2)/(2.5 - 1.2)) if fat_ratio>=1.2 
	drop fat_ratio
	
	/* Consume in Moderation */
	/* Refined grains */
	replace rHEI = rHEI + min(10,10*(4.3-refined_grains)/(4.3-1.8)) if refined_grains < 4.3 & refined_grains!=.
	
	/* Sodium */
	replace rHEI = rHEI + min(10,10*(2-sodium_mg/1000)/(2-1.1)) if sodium_mg/1000<2&sodium_mg!=.
	
	/* Added sugars */
	/* share of energy from added sugars */
	gen added_sugars_share = added_sugars*4 / 1000
	replace rHEI = rHEI + min(10,10*(0.26-added_sugars_share)/(0.26-0.065)) if added_sugars_share < 0.26 & added_sugars_share!=.
	drop added_sugars_share
	
	/* solid fats */
	gen solid_fats_share = solid_fats_kcal/1000
	replace rHEI = rHEI + min(10,10*(0.16-solid_fats_share)/(0.16-0.08)) if solid_fats_share<0.16 & solid_fats_share!=.
	drop solid_fats_share
	
	/* Drop if don't observe minimum calories */
	*replace rHEI = . if Calories_HEI/CalorieNeed<=$MinInSampleCalorieShareObserved // tk
	
	rename rHEI rHEI_per1000Cal
end
	

/* Get mean and standard deviation of each measure in the HHxYear data in order to normalize */
use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
InsertRawNutrientScore
InsertRawHEI

/*
* Get the fc_ version // tk
gen rHEI_hold = rHEI

foreach var in $HEINuts {
	rename `var' `var'_hold
	rename fc_`var' `var'
}
InsertRawHEI

foreach var in $HEINuts {
	rename `var' fc_`var' 
	rename `var'_hold `var'
	
}

rename rHEI rfc_HEI
rename rHEI_hold rHEI
*/


foreach measure in `MeasureList' HEI_per1000Cal lHEI_per1000Cal NutrientScore {
	sum r`measure' [aw=projection_factor] if InSample==1 // This is for the mean
	local m`measure' = r(mean)

	reg r`measure' i.panel_year [aw=projection_factor]
	predict YearDummies
	gen MinusYear = r`measure'-YearDummies
	sum MinusYear [aw=projection_factor] if InSample==1 // This is for the sd
	local sd`measure' = r(sd)
	
	drop YearDummies MinusYear
}




/* OPEN INDIVIDUAL DATASETS AND INSERT HEALTH MEASURES */
/* Homescan */
foreach FileName in HHxYear HHxQuarter HHxYearxStore RMS-Prepped RMS_by_store_code {
	if strpos("`FileName'","RMS")!=0 { 
		use $Externals/Calculations/RMS/`FileName'.dta, replace
	}
	else {
		use $Externals/Calculations/Homescan/`FileName'.dta, replace
	}
	
	
	** For HHxYear, HHxQuarter, and HHxYearxStore, also insert the "true" (non-linear) HEI and nutrient score
	if "`FileName'"=="HHxYear"|"`FileName'"=="HHxQuarter"|"`FileName'"=="HHxYearxStore" { //
		InsertRawNutrientScore
		InsertRawHEI
		/*
		* Get the fc_ version tk temp
							gen rHEI_hold = rHEI

							foreach var in $HEINuts {
								rename `var' `var'_hold
								rename fc_`var' `var'
							}
							InsertRawHEI
							foreach var in $HEINuts {
								rename `var' fc_`var' 
								rename `var'_hold `var'
								
							}

							rename rHEI rfc_HEI
							rename rHEI_hold rHEI
		*/
		
		local MeasureList_FileName = "`MeasureList' HEI_per1000Cal NutrientScore" 
	}
	/* else if "`FileName'"=="HHxYearxStore" {
		InsertRawNutrientScore
		local MeasureList_FileName = "`MeasureList' NutrientScore" 
	} */
	else {
		local MeasureList_FileName = "`MeasureList'"
	}


	
	*** Normalize all measures
	foreach measure in `MeasureList_FileName' {
		capture drop `measure' // in case the file has been run before
		gen `measure' = (r`measure'-`m`measure'')/`sd`measure'' // Mean and SD from above
	}
	label var HealthIndex_per1000Cal "Normalized Health Index"
	capture label var lHEI_per1000Cal "Normalized Healthy Eating Index"
	capture label var HEI_per1000Cal "Normalized Healthy Eating Index"
	capture label var NutrientScore "Normalized Nutrient Score"
	
	if strpos("`FileName'","RMS")!=0 { // "`FileName'"=="RMS_by_store_code" {
		* For RMS files, also need to normalize additional demand measures
		foreach measure in HealthIndex_per1000Cal lHEI_per1000Cal {
			capture drop D_`measure'
			gen D_`measure' = (D_r`measure' - `m`measure'')/`sd`measure'' // Mean and SD from above
		}
		* save
		saveold $Externals/Calculations/RMS/`FileName'.dta, replace
	}
	else {
		* save
		saveold $Externals/Calculations/Homescan/`FileName'.dta, replace	
	}
}


/* OUTPUT MEAN AND SD FOR TEXT */
foreach stat in m sd {
	clear
	set obs 1
	gen var = round(``stat'HealthIndex_per1000Cal',0.01)
	format var %12.2fc 
	tostring var, replace force u
	outfile var using "Output/NumbersForText/`stat'HealthIndex.tex", replace noquote
}


/* NORMALIZE MAGNET DATA SEPARATELY */
use $Externals/Calculations/Homescan/HHxYear_Magnet.dta, replace
*InsertRawNutrientScore
*InsertRawHEI
local MeasureList = "HealthIndex_per1000Cal lHEI_per1000Cal" 
local MeasureList_FileName = "`MeasureList'" // HEI_per1000Cal NutrientScore


foreach measure in `MeasureList_FileName'{
	sum r`measure' [aw=projection_factor] if InSample==1 // This is for the mean
	local m`measure' = r(mean)

	reg r`measure' i.panel_year [aw=projection_factor]
	predict YearDummies
	gen MinusYear = r`measure'-YearDummies
	sum MinusYear [aw=projection_factor] if InSample==1 // This is for the sd
	local sd`measure' = r(sd)
	
	drop YearDummies MinusYear
}
		
		
*** Normalize all measures
foreach measure in `MeasureList_FileName' {
	capture drop `measure' // in case the file has been run before
	gen `measure' = (r`measure'-`m`measure'')/`sd`measure'' // Mean and SD from above
}
label var HealthIndex_per1000Cal "Normalized Health Index"
capture label var lHEI_per1000Cal "Normalized Healthy Eating Index"
*capture label var HEI_per1000Cal "Normalized Healthy Eating Index"
*capture label var NutrientScore "Normalized Nutrient Score"
	
	
saveold $Externals/Calculations/Homescan/HHxYear_Magnet.dta, replace	
