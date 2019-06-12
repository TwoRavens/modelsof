/* DataSection.do */
* This prepares all data and descriptive info in the Data section of the paper


/* Household characteristics */
use $Externals/Calculations/Homescan/Prepped-Household-Panel.dta,replace, if panel_year <= $MaxYear
sum $Ctls_SummStats CalorieNeed svy_health_importance svy_health_knowledge BMI Diabetic [aw=projection_factor] // svy_healthcare svy_knowledge_pantry

codebook household_code
tab panel_year // Homescan includes 39k for 2004-2006 and 61k for 2007-2015
tab panel_year if projection_factor_magnet!=.

sum CalorieNeed
clear
set obs 1
gen var = r(N)
format var %12.0fc 
tostring var, replace force u
outfile var using "Output/NumbersForText/NHomescanObservations.tex", replace noquote




/* Zip Code Business Patterns */
use $Externals/Calculations/StoreEntryExit/ZipCodeBusinessPatterns.dta, replace, if year>=2004&year<=$MaxYear
gen est_LSmallGroc = est_SmallGroc-est_VSmallGroc // Larger small grocery
sum est_Grocery est_VSmallGroc est_LSmallGroc est_LargeGroc est_SuperClub est_Drug est_Conv est_Spec
clear
set obs 1
gen var = r(N)
format var %12.0fc 
tostring var, replace force u
outfile var using "Output/NumbersForText/NZBPObservations.tex", replace noquote

/* UPCs and nutritional characteristics */
use $Externals/Calculations/OtherNielsen/Prepped-UPCs.dta, replace, if NonFood==0
sum Grams cals_per1 g_fat_per1000Cal g_fat_sat_per1000Cal g_cholest_per1000Cal g_sodium_per1000Cal g_carb_per1000Cal g_fiber_per1000Cal g_sugar_per1000Cal g_prot_per1000Cal // HealthIndex_per1000Cal



/* OTHER STATEMENTS IN TEXT */
/* Number of RMS stores */
use $Externals/Calculations/RMS/RMS-Prepped.dta, replace
codebook store_code_uc retailer_code
tab year

/* Number of store entries */
use $Externals/Calculations/StoreEntryExit/AllRetailerEntry.dta, replace
sum OpenDate 
clear
set obs 1
gen var = r(N)
format var %12.0fc 
tostring var, replace force u
outfile var using "Output/NumbersForText/NStoreEntries.tex", replace noquote


/* Validate dietary quality measures */
include Code/Analysis/DataSection/ValidateHealthMeasures.do


/* Share of fruit and vegetable calories captured in non-Magnet transactions */
global FruitVegVars = "FreshFruit FreshVeg Fruit Veg"

clear
save $Externals/Calculations/Homescan/MagnetCalorieShare.dta, replace emptyok 

forvalues year = 2004/2006 {
	use $Externals/Calculations/Homescan/Transactions/Transactions_`year'.dta, clear, if year(purchase_date)==`year'
	
	** Merge projection_factor_magnet to determine if the transaction is by a magnet household.
		* For the moment do not merge other household characteristics because this will use a lot of memory. Merge other household characteristics to the collapsed dataset below.
	gen int panel_year = `year'
	merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
		keepusing(projection_factor_magnet lnIncome NominalIncomeGroup) keep(match) nogen 
	drop if projection_factor_magnet == .
	drop projection_factor_magnet panel_year
	
	** Merge UPC info
	merge m:1 upc upc_ver_uc using $Externals/Calculations/OtherNielsen/Prepped-UPCs.dta, keep(match master) nogen ///
		keepusing(department_code product_group_code $FruitVegVars cals_per1 Grams) // 
	* Drop if missing a product_group_code; most of these are non-food or difficult to classify.
	drop if product_group_code==. 
	
	** The magnet transactions are separate. Append them.
	append using $Externals/Calculations/Homescan/Transactions/MagnetTransactions_`year'.dta, gen(Magnet)
		
	** Add nutrition facts only to the magnet data
	merge m:1 product_module_code type pct_lean using $Externals/Calculations/NutritionFacts/magnetdata_nut_facts.dta, ///
		update replace keep(match master match_update match_conflict) nogen /// there should be no conflicts: FreshFruit, FreshVeg, and HealthIndex_per100g are missing for the RW transactions because there are no UPCs for them anyway.
		keepusing($FruitVegVars cals_per100g) // RW will not include bread coded into Wheat, Whole, etc because this comes from UPC description field.
	
	replace cals_per1=cals_per100g * Grams/100 if cals_per100g!=. // Get calories for RW data
	gen cals_perRow=cals_per1*quantity // Get total for the row.
	drop cals_per1
	
	gen int panel_year = `year'
	
	if `year' != 2004 {
		append using $Externals/Calculations/Homescan/MagnetCalorieShare.dta
	}
	save $Externals/Calculations/Homescan/MagnetCalorieShare.dta, replace
}

collapse (sum) $FruitVegVars [pw=cals_perRow],by(Magnet household_code panel_year)
gen Produce = Fruit+Veg
gen FreshProduce = FreshFruit+FreshVeg
reshape wide $FruitVegVars Produce FreshProduce, i(household_code panel_year) j(Magnet)
drop if FreshFruit1==. // 566 households buy no fresh fruits in Magnet, and exactly the same households buy no fresh vegetables in Magnet, which suggests that these are missing entirely from the Magnet data.
	merge 1:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
		keepusing(projection_factor_magnet lnIncome HHAvIncome) keep(match) nogen 
xtile HHAvIncomeGroup = HHAvIncome [aw=projection_factor], nq(10)
		

foreach var in $FruitVegVars Produce FreshProduce {
	gen `var'NonMagnetShare = `var'0/(`var'1+`var'0)
}

** Regress non-magnet share on income
	* Produce non-magnet share is 60% and does not vary by income.
	* Fresh produce non-magnet share is 39%; households with income < $20k buy about 5 percentage points less of their produce from UPCs, so the UPCs slightly overstate the income gradient for fresh produce - although we are not presenting that.
reg ProduceNonMagnetShare [pw=projection_factor_magnet], robust cluster(household_code)
reg ProduceNonMagnetShare lnIncome [pw=projection_factor_magnet], robust cluster(household_code)

reg FreshProduceNonMagnetShare [pw=projection_factor_magnet], robust cluster(household_code)
reg FreshProduceNonMagnetShare lnIncome [pw=projection_factor_magnet], robust cluster(household_code)

** Collapse to income group level for the figure
collapse (mean) HHAvIncome *roduceNonMagnetShare [aw=projection_factor_magnet], by(HHAvIncomeGroup)
saveold $Externals/Calculations/Homescan/MagnetCalorieShare_IncomeGroup.dta, replace


** Create figure
use $Externals/Calculations/Homescan/MagnetCalorieShare_IncomeGroup.dta, replace
twoway (scatter ProduceNonMagnetShare HHAvIncome, connect(line) mcolor(navy) lcolor(navy)) ///  yscale(range(0)) 
		(scatter FreshProduceNonMagnetShare HHAvIncome, msymbol(S) connect(line) lp(-) mcolor(maroon) lcolor(maroon)), ///
		graphregion(color(white) lwidth(medium)) ///
		xlabel(0(25)125) xscale(range(0 125)) ///
		xtitle("Household income ($000s)") ytitle("Share of calories from items with UPCs") ///
		legend(label(1 "Produce") label(2 "Fresh Produce"))
	graph export Output/DataSection/MagnetCalorieShare_Income.pdf, as(pdf) replace


erase $Externals/Calculations/Homescan/MagnetCalorieShare.dta // This is >1 GB
