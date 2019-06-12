/* CollapseTransactions.do */
	* This file collapses the transactions dataset to different levels
	* cals_per1 is calories per UPC
	
clear
save $Externals/Calculations/Homescan/$FileName.dta, replace emptyok
forvalues year = 2004/$MaxYear {
	use $Externals/Calculations/Homescan/Transactions/Transactions_`year'.dta, clear
	
	** Merge UPC info
	merge m:1 upc upc_ver_uc using $Externals/Calculations/OtherNielsen/Prepped-UPCs.dta, keep(match master) nogen ///
		keepusing($Attributes department_code product_group_code product_module_code cals_per1 energy_per1 ImputedHEINuts) // Grams	
	gen cals_perRow=cals_per1*quantity // Get total for the row.
	gen energy_perRow=energy_per1*quantity
	if strpos("$Attributes","ShareCoke")!=0 {
		gen CokePepsi_cals_perRow=cals_per1*quantity if ShareCoke!=.
		local CokePepsiCals = "CokePepsi_Calories = CokePepsi_cals_perRow"
	}
	else {
		local CokePepsiCals = ""
	}
	drop cals_per1	
	
	** Drop magnet transactions because this is the entire panel and the magnet transactions will have the wrong weights.
		* Drop if missing a product_group_code; most of these are non-food or difficult to classify.
	drop if department_code==99 | (product_module_code>=445&product_module_code<=468) ///
		| product_group_code==. 
	drop department_code product_module_code
	
	*** Get expenditures by channel type
	if "$ChannelExpendShare" == "Yes" {
		** Merge channel_type
		merge m:1 retailer_code using $Externals/Calculations/OtherNielsen/Retailers.dta, keepusing(C_Grocery C_ChainGroc C_Mass C_Club C_Super C_DrugConv C_Other C_WalTar) nogen keep(match master)

		foreach channel in Grocery ChainGroc Mass Club Super DrugConv Other { //  WalTar Entrant
			gen expend_`channel' = cond(C_`channel'==1,expend,0)
			drop C_`channel'
		}
		*gen expend_WalGroc = cond(inlist(retailer_code,848,6920),expend,0) // Walmart Neighborhood or Supercenter
		*gen expend_Entrant = cond(inlist(retailer_code,32,848,6920,6921),expend,0) // Any grocer in our entrant data: Safeway, Walmart grocery, or SuperTarget
		local expend = "expend_*"
	}
	else {
		local expend = ""
	}
	
	** HEI calories per row
	if "$HEI" == "Yes" {
		local HEICals = "Calories_HEI = HEI_cals_perRow"
		
		gen HEI_cals_perRow = cals_perRow if ImputedHEINuts==0
	}
	else {
		local HEICals = ""
	}
	
	** Collapse
	if strpos("$CollapseBy","panel_year")!=0 {
		gen int panel_year = `year'
	}
	if strpos("$CollapseBy","YQ")!=0 {
		gen int YQ = qofd(purchase_date)
			* Extend Q1 to include the last few days of December, which are included in this panel_year.
		replace YQ = YQ+1 if year(dofq(YQ))==`year'-1
		format %tq YQ
	}
	preserve
		collapse (rawsum) expend `expend' Calories=cals_perRow `CokePepsiCals' `HEICals' ///
			(mean) $Attributes_cals [pw=cals_perRow],by($CollapseBy) fast // Note that this drops zero-cal UPCs, including salt and baking soda. GFRP staff say that this helps reduce outliers, and many of these UPCs are not fully consumed anyway.
		save $Externals/Calculations/Homescan/Temp.dta, replace
	restore
		collapse (mean) $Attributes_energy [pw=energy_perRow],by($CollapseBy) fast // Note that this drops zero-cal UPCs, including salt and baking soda. GFRP staff say that this helps reduce outliers, and many of these UPCs are not fully consumed anyway.		
	
		merge 1:1 $CollapseBy using $Externals/Calculations/Homescan/Temp.dta, nogen
		erase $Externals/Calculations/Homescan/Temp.dta
		
	append using $Externals/Calculations/Homescan/$FileName.dta
	saveold $Externals/Calculations/Homescan/$FileName.dta, replace
}


	** If want to remake from here after the collapse:
	*use $Externals/Calculations/Homescan/$FileName.dta, replace
	*capture noisily keep household_code panel_year YQ expend* MilkFatPct LowFatMilk NonFatMilk HealthIndex_per100g Wheat Rye Whole FreshFruit FreshVeg 
	*capture noisily keep household_code panel_year expend* MilkFatPct LowFatMilk NonFatMilk HealthIndex_per100g Wheat Rye Whole FreshFruit FreshVeg 


** Deflate expenditures to real 2010 dollars
	if strpos("$CollapseBy","YQ")!=0 {
	*if "$CollapseBy" == "household_code YQ" {
		merge m:1 YQ using $Externals/Calculations/CPI/CPI_Quarterly.dta, keepusing(CPI) keep(match master) nogen
	}
	if strpos("$CollapseBy","panel_year")!=0 {
	*if "$CollapseBy" == "household_code panel_year" {
		rename panel_year year
		merge m:1 year using $Externals/Calculations/CPI/CPI_Annual.dta, keepusing(CPI) keep(match master) nogen
		rename year panel_year
	}	

	foreach var of varlist expend* {
		replace `var' = `var'/CPI
	}
	drop CPI


** Expenditure shares
if "$ChannelExpendShare" == "Yes" {
	foreach var in Grocery ChainGroc Mass Club Super DrugConv Other { // WalTar Entrant
		gen expshare_`var' = expend_`var' / expend
	}
}
** FreshProduce and Produce variables
* gen FreshProduce = FreshFruit+FreshVeg
capture gen Produce = Fruit+Veg

** InSample variable
	* Do not include if Homescan purchases are less than 5% of calorie need over the period
if "$CollapseBy" == "household_code YQ" { 
	gen int panel_year = year(dofq(YQ))
	merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, keepusing(CalorieNeed) keep(match master) nogen 
	replace CalorieNeed = CalorieNeed * 365/4
}
if "$CollapseBy" == "household_code panel_year" {
	merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, keepusing(CalorieNeed) keep(match master) nogen 
	replace CalorieNeed = CalorieNeed * 365
}
capture gen byte InSample = cond(Calories/CalorieNeed>$MinInSampleCalorieShareObserved,1,0)


compress
saveold $Externals/Calculations/Homescan/$FileName.dta, replace
