/* Prep_HHxGroup.do */
* This prepares the HHxGroup dataset for demand estimation.

* Define global containing Attributes variables
global Attributes = "energy_per1 rlHEI_per1000Cal $HEINuts_per1 cals_per1"
global Produce = "Fruit Veg"

clear
save "$Externals/Calculations/Homescan/HHxGroup.dta", replace emptyok
forvalues year = 2004/$MaxYear {
	use "$Externals/Calculations/Homescan/Transactions/Transactions_`year'.dta", clear
	
	** Merge UPC info
	merge m:1 upc upc_ver_uc using "$Externals/Calculations/OtherNielsen/Prepped-UPCs.dta", keep(match master) nogen ///
		keepusing(department_code dept_est product_group_code group product_module_code  $Attributes $Produce Grams Storability* StoreTime Convenience) 	


		
		
		
	** Drop magnet transactions because this is the entire panel and the magnet transactions will have the wrong weights.
		* Drop if missing a product_group_code; most of these are non-food or difficult to classify.
	drop if department_code==99 | (product_module_code>=445&product_module_code<=468) ///
		| product_group_code==. | dept_est==.
	drop product_module_code product_group_code
	
	** Get attribute totals
	global AttributeTotals = ""
	foreach Attribute in $Attributes {
		local newname = substr("`Attribute'",1,length("`Attribute'")-5)
		gen `newname' = quantity * `Attribute'
		drop `Attribute'
		global AttributeTotals = "$AttributeTotals `newname'"
	}
	* Total grams of produce
		* This just creates one produce variable:
		*gen g_Produce = quantity*Grams*(Fruit+Veg)
		*global AttributeTotals = "$AttributeTotals g_`prod'"
	foreach prod in $Produce {
		gen g_`prod' = quantity*Grams*`prod'
		global AttributeTotals = "$AttributeTotals g_`prod'"
	}
	* Storability
	gen StoreTime365=StoreTime
	replace StoreTime365=365 if StoreTime>365 & StoreTime~=.
	gen StoreTime30=StoreTime
	replace StoreTime30=30 if StoreTime>30 & StoreTime~=.
	replace Storability = energy*Storability
	replace StorabilityLong = energy*StorabilityLong
	replace StoreTime = energy*StoreTime
	replace StoreTime365 = energy*StoreTime365
	replace StoreTime30 = energy*StoreTime30
	
	*Make Convenience Calorie Weighted
	replace Convenience=Convenience*energy
	
	* gen int YQ = qofd(purchase_date) // Could prepare at the quarterly level if desired. If doing this, make sure to place the end of December into Q1 so that the panel_year matches.
	collapse (first) department_code dept_est (sum) expend $AttributeTotals Grams Storability* StoreTime* Convenience, by(household_code group) fast // YQ

	gen int panel_year = `year'
	
	append using "$Externals/Calculations/Homescan/HHxGroup.dta"
	saveold "$Externals/Calculations/Homescan/HHxGroup.dta", replace
}

	** If want to remake from here after the collapse:
	*use Calculations/Homescan/HHxGroup.dta, replace
	*keep household_code group expend g_* HealthIndex panel_year

** Deflate to real 2010 expenditures
rename panel_year year
merge m:1 year using "$Externals/Calculations/CPI/CPI_Annual.dta", keepusing(CPI) keep(match master) nogen
replace expend = expend/CPI
rename year panel_year
drop CPI

** Merge household info
	* Change this line to merge in whatever individual characteristics are needed for the demand estimation
merge m:1 household_code panel_year using "$Externals/Calculations/Homescan/Prepped-Household-Panel.dta", ///
	keepusing(lnIncome IncomeResidQuartile fips_state_code fips_county_code projection_factor lnAge lnEduc Children R_* CalorieNeed ///
	dma_code zip_code zip3) keep(match master) nogen 

	
** InSample variable
	* If Homescan purchases are less than 5% of calorie need over the year
replace CalorieNeed = CalorieNeed * 365
bysort household_code panel_year: egen Calories = sum(cals)
gen byte InSample = cond(Calories/CalorieNeed>0.05,1,0)
drop Calories CalorieNeed


compress
saveold "$Externals/Calculations/Homescan/HHxGroup.dta", replace

