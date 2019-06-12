/* CollapseTransactions_Magnet.do */
	* This file collapses the transactions dataset to different levels

clear
save $Externals/Calculations/Homescan/$FileName.dta, replace emptyok
forvalues year = 2004/2006 {
	use $Externals/Calculations/Homescan/Transactions/Transactions_`year'.dta, clear
	
	** Merge projection_factor_magnet to determine if the transaction is by a magnet household.
		* For the moment do not merge other household characteristics because this will use a lot of memory. Merge other household characteristics to the collapsed dataset below.
	gen int panel_year = `year'
	merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
		keepusing(projection_factor_magnet) keep(match) nogen 
	drop if projection_factor_magnet == .
	drop projection_factor_magnet
	drop panel_year 
	
	** Merge UPC info
	merge m:1 upc upc_ver_uc using $Externals/Calculations/OtherNielsen/Prepped-UPCs.dta, keep(match master) nogen ///
		keepusing(department_code product_group_code $Attributes cals_per1 energy_per1) // Grams
	* Drop if missing a product_group_code; most of these are non-food or difficult to classify.
	drop if product_group_code==. 
	
	** The magnet transactions are separate. Append them.
	append using $Externals/Calculations/Homescan/Transactions/MagnetTransactions_`year'.dta

	** Add nutrition facts for the magnet data
	merge m:1 product_module_code type pct_lean using $Externals/Calculations/NutritionFacts/magnetdata_nut_facts.dta, ///
		update replace keep(match master match_update match_conflict) nogen /// there should be no conflicts: FreshFruit, FreshVeg, and HealthIndex_per100g are missing for the RW transactions because there are no UPCs for them anyway.
		keepusing($Attributes cals_per100g energy_per100g) 

	** Get calories for RW data, measured by both our matches (cals) and HEI facts (energy)
	foreach cal in cals energy {
		replace `cal'_per1=`cal'_per100g * Grams/100 if `cal'_per100g!=.
		gen `cal'_perRow=`cal'_per1*quantity // Get total for the row.
		drop `cal'_per1
	}
	
	*** Get expenditures by channel type
	** Merge channel_type
	merge m:1 retailer_code using $Externals/Calculations/OtherNielsen/Retailers.dta, keepusing(C_Grocery C_ChainGroc C_Mass C_Club C_Super C_DrugConv C_Other C_WalTar) nogen keep(match master)

	foreach channel in Grocery ChainGroc Mass Club Super DrugConv Other { // WalTar
		gen expend_`channel' = cond(C_`channel'==1,expend,0)
		drop C_`channel'
	}
	*gen expend_WalGroc = cond(inlist(retailer_code,848,6920),expend,0) // Walmart Neighborhood or Supercenter
	*gen expend_Entrant = cond(inlist(retailer_code,32,848,6920,6921),expend,0) // Any grocer in our entrant data: Safeway, Walmart grocery, or SuperTarget
	
	** Collapse
	if "$CollapseBy" == "household_code YQ" {
		gen int YQ = qofd(purchase_date)
			* Extend Q1 to include the last few days of December, which are included in this panel_year.
		replace YQ = YQ+1 if year(dofq(YQ))==`year'-1
		format %tq YQ
	}
	if "$CollapseBy" == "household_code panel_year" {
		gen int panel_year = `year'
	}
	preserve
		collapse (rawsum) expend_* expend Calories=cals_perRow (mean) $Attributes_cals [pw=cals_perRow],by($CollapseBy) fast
		save $Externals/Calculations/Homescan/Temp_Magnet.dta, replace
	restore
		collapse (mean) $Attributes_energy [pw=energy_perRow],by($CollapseBy) fast // Note that this drops zero-cal UPCs, including salt and baking soda. GFRP staff say that this helps reduce outliers, and many of these UPCs are not fully consumed anyway.		
		merge 1:1 $CollapseBy using $Externals/Calculations/Homescan/Temp_Magnet.dta, nogen
		erase $Externals/Calculations/Homescan/Temp_Magnet.dta
	
	append using $Externals/Calculations/Homescan/$FileName.dta
	save $Externals/Calculations/Homescan/$FileName.dta, replace
}

	** If want to remake from here after the collapse:
	*use Calculations/Homescan/$FileName.dta, replace
	*capture noisily keep household_code panel_year YQ expend* MilkFatPct LowFatMilk NonFatMilk HealthIndex_per100g Wheat Rye Whole FreshFruit FreshVeg 
	*capture noisily keep household_code panel_year expend* MilkFatPct LowFatMilk NonFatMilk HealthIndex_per100g Wheat Rye Whole FreshFruit FreshVeg 


** Deflate expenditures to real 2010 dollars
		* Obviously not needed if we are only looking at expenditure shares
	if "$CollapseBy" == "household_code YQ" {
		merge m:1 YQ using $Externals/Calculations/CPI/CPI_Quarterly.dta, keepusing(CPI) keep(match master) nogen
	}
	if "$CollapseBy" == "household_code panel_year" {
		rename panel_year year
		merge m:1 year using $Externals/Calculations/CPI/CPI_Annual.dta, keepusing(CPI) keep(match master) nogen
		rename year panel_year
	}	

	foreach var of varlist expend* {
		replace `var' = `var'/CPI
	}
	drop CPI


** Expenditure shares
foreach var in Grocery ChainGroc Mass Club Super DrugConv Other { // WalTar Entrant
	gen expshare_`var' = expend_`var' / expend
}

** FreshProduce and Produce variables
gen FreshProduce = FreshFruit+FreshVeg
gen Produce = Fruit+Veg


** InSample variable
	* If Homescan purchases are less than 5% of calorie need over the period
if "$CollapseBy" == "household_code YQ" {
	gen int panel_year = year(dofq(YQ))
	merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, keepusing(CalorieNeed) keep(match master) nogen 
	replace CalorieNeed = CalorieNeed * 365/4
}
if "$CollapseBy" == "household_code panel_year" {
	merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, keepusing(CalorieNeed) keep(match master) nogen 
	replace CalorieNeed = CalorieNeed * 365
}
gen byte InSample = cond(Calories/CalorieNeed>0.05,1,0)

save $Externals/Calculations/Homescan/$FileName.dta, replace
