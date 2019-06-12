/* GetPerishability.do */
* This imports the foodkeeper database and organizes it by Nielsen product_module_code
.

/* Get storage time in days (StoreTime) by FoodKeeper ID */

** Import FoodKeeper database 
import excel "$Externals/Data/NutritionFacts/FMA-Data-v118.xlsx", sheet("Product") cellrange(A1:AV397) first clear

foreach mode in DOP_Refrigerate Refrigerate DOP_Pantry Pantry DOP_Freeze Freeze {
	gen `mode' = (`mode'_Min+`mode'_Max)/2
	replace `mode' = `mode'*7 if `mode'_Metric=="Weeks"
	replace `mode' = `mode'*30 if `mode'_Metric=="Months"
	replace `mode' = `mode'*365 if `mode'_Metric=="Years"
}

* Use refrigerate if we have, else pantry, else freeze. Ignore "after opening," because many of these can be stored in the pantry for awhile before opening.
gen StoreTime = DOP_Refrigerate
replace StoreTime = Refrigerate if StoreTime==.
replace StoreTime = DOP_Pantry if StoreTime==.
replace StoreTime = Pantry if StoreTime==.
replace StoreTime = DOP_Freeze if StoreTime==.
replace StoreTime = Freeze if StoreTime==.

** Individual replacements
replace StoreTime = 7 if ID==306 // tomatoes: When ripe, then 7 days
replace StoreTime = 4 if ID==179 // pre-cut fruit: 4 days after opening
replace StoreTime = 730 if ID==343 // Dry gravy mixes: there is a refrigeration time but it applies only to the prepared product
replace StoreTime = 6 if ID==198 // Fresh cheesecake
replace StoreTime = 10 if ID==28 // Pudding. This is just Hunt's guess. 
replace StoreTime = 10.5 if ID==29 // Sour cream. 1-2 weeks according to web search
replace StoreTime = 3.5 if ID==205 // Cream pies. For some reason only listed as "after opening" even though there is no "opening" for cream pies.
keep ID StoreTime

saveold $Externals/Calculations/NutritionFacts/FoodKeeper.dta, replace




/* Map the FoodKeeper info to product module codes */
import excel $Externals/Data/NutritionFacts/ModuleMatchestoFoodKeeper.xlsx, sheet("nls_hierarchy 09-17-2013") clear firstrow
destring ID1, replace force

foreach m in 1 2 3 {
	rename ID`m' ID
	merge m:1 ID using $Externals/Calculations/NutritionFacts/FoodKeeper.dta, nogen keep(match master) keepusing(StoreTime)
	rename StoreTime StoreTime`m'
	rename ID ID`m'
}




egen StoreTime = rowmean(StoreTime?)

** Individual line replacements
replace StoreTime = 2.5 if product_module_code==452 // This is fountain beverages so should be "after opening," which is 2-3 days for soda.
sum StoreTime if department_code==6, detail
replace StoreTime = r(p50) if StoreTime==. & (department_code==6 | product_module_code==124) // Unclassified fresh produce

** Missings
	* Typically non-food products
	* Missing also includes carbonated beverages, alcohol, baby food, and some other foods that are generally not perishable at all.
	* Assign the max
sum StoreTime
replace StoreTime = r(max) if StoreTime==.

keep product_module_code StoreTime
gen Storability = ln(min(StoreTime,30)) if StoreTime!=.
gen StorabilityLong = ln(min(StoreTime,365)) if StoreTime!=.

label var Storability "ln(min(Max storage days, 30))"

saveold $Externals/Calculations/NutritionFacts/Perishability.dta, replace



/* Map FoodKeeper data to Magnet products */
import excel $Externals/Data/NutritionFacts/MagnetModuleMatchestoFoodKeeper.xlsx, sheet("Unique") firstrow clear

merge m:1 ID using $Externals/Calculations/NutritionFacts/FoodKeeper.dta, nogen keep(match master) keepusing(StoreTime)

* There are no missings
keep product_module_code type StoreTime
gen Storability = ln(min(StoreTime,30)) if StoreTime!=.

gen StorabilityLong = ln(min(StoreTime,365)) if StoreTime!=.


label var Storability "ln(min(Max storage days, 30))"

saveold $Externals/Calculations/NutritionFacts/Perishability_Magnet.dta, replace


