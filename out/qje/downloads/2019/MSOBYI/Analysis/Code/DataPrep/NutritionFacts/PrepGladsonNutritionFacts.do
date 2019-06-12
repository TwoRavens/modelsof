/* PrepGladsonNutritionFacts.do */
* Can insert Katie's original code in this do file.
* This do file shortcuts this and simply places the already-prepared Gladson nutrition facts into the Calculations folder.



/* Prep HMS for Nutionion Imputation*/
include DataPrep/NutritionFacts/prepare_hms_purchase_data_upcs.do


/* Prop Nutrition Fact Dtaa*/
include DataPrep/NutritionFacts/prepare_gladson_nut_facts_for_imputation.do


/* Impute Missing Nutrition Facts*/

include DataPrep/NutritionFacts/impute_nut_facts_for_missing_products.do





use "$Externals/Data/NutritionFacts/nut_facts_upc_level_MASTER.dta", clear
foreach var of varlist *perUPC {
	local varname = substr("`var'",1,length("`var'")-3) + "1"
	rename `var' `varname'
}

destring upc upc_ver_uc, replace force
drop if upc==. & upc_ver_uc==.
format %12.0f upc
keep upc_ver_uc upc *per1

compress
saveold "$Externals/Calculations/NutritionFacts/hms_upcs_with_nut_facts_imputed.dta", replace


* gen cals_check = 4*(g_carb_per1+g_prot_per1)+9*g_fat_per1
