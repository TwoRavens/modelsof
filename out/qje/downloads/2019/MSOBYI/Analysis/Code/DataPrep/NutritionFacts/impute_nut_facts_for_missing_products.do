clear all
set more off

/*-------------------------------------------------
Prepare imputation of nut facts for unmatched products
diamondr last modified june 2018

1) Prepare nut facts for imputation
2) Do nutrient imputation
3) Reconvert back to perUPC level
4) Impute Nuts for products with no grams measure
5) Tidy & save
---------------------------------------------------*/

/*
global MAIN "C:/Users/ccwright/Dropbox/NutritionandIncome"
global LOCAL "C:\Users\ccwright\Desktop\RF work\NutritionandIncome_LOCAL"
global dataout "$MAIN\Analysis\Data\NutritionFacts"
global TEMP "$LOCAL\NutritionFacts\TMP"
global homescan "$LOCAL\NielsenHMS"


//Rebecca's paths
global MAIN "C:/Users/diamondr/Dropbox/NutritionandIncome"
global dataout "$MAIN\Analysis\Data\NutritionFacts"
global LOCAL "D:\nielsen"
global nutfactslocal "$LOCAL/NutritionFacts"
global TEMP "$LOCAL/TMP"
global hms "$LOCAL/stata_datasets"
*/
set matsize 2000

/*---------------------------------------------------
1) Prepare nutrition facts data
---------------------------------------------------*/	
use "$Externals\Calculations\NutritionFacts/gladson_nut_facts_for_imp_outliers_dropped.dta", clear

drop if upc==""

replace product_module_descr="SALAD DRESSING MIRACLE WHIP" if regex(product_module_descr, "MIRACLE WHIP")

drop if product_group_descr=="PET FOOD"
drop if department_descr=="NON-FOOD GROCERY"
drop if department_descr==" GENERAL MERCHANDISE"
drop if product_group_descr=="KITCHEN GADGETS"
// These ar due to false matches due to not being able to match on upc_ver_uc to Gladson data
drop if product_module_descr=="BAGS - LAWN & LEAF" | product_module_descr=="BATHROOM ACCESSORY" | product_module_descr=="BURNER AND RANGE APPLIANCE" ///
 | product_module_descr=="COFFEE AND TEA MAKER APPLIANCE" | product_module_descr=="LAMPS - INCANDESCENT" | product_module_descr=="STORAGE AND SPACE MANAGEMENT" ///
 | product_module_descr=="UNCLASSIFIED PHOTOGRAPHIC SUPPLIES"


// Dropping post 2006 magnet data
drop if product_module_descr=="MAGNET DATA"
 
 
* Encode categorical variables
egen productfixedeff1=group(product_descr ), missing
egen productfixedeff2=group(type_descr), missing
egen productfixedeff3=group(flavor_descr), missing


*Fill in zeros for blank fat/salt dummies
foreach var of varlist dumnofat- dumlesssugarother {
replace `var'=0 if `var'==.
}


// Products to have nut facts imputed
gen impute_flag=_merge==1

gen has_good_data=g_fat_per100g~=.

*Check to make sure every module has data to impute from
egen obs_for_imput=total(has_good_data), by(product_module_descr)	
drop _merge

save "$Externals\Calculations\NutritionFacts/nut_facts_imputation.dta", replace


/*---------------------------------------------------
2) NUTRIENT IMPUTATION
---------------------------------------------------*/
*use "$TEMP\nut_facts_imputation.dta", clear


set matsize 2000

****Dropping Modules where there is no data to impute from. Will return to these.***
drop if obs_for_imput<2

egen milk_group=group(MilkFat), missing
	
*********************************** IMPUTE NUT FACTS HERE********************************
*cap log close
*log using "$MAIN\Analysis\Output\NutritionFacts\nut_fact_imputation_gladson_fe.log", replace
set more off
levelsof product_module_descr, local(levels)
foreach module of local levels  {
	set more off
	foreach var of varlist g_fat_per100g- cals_fat_per100g {
		display "`module'"
		capture {
		reg `var' dum* i.productfixedeff1  i.productfixedeff2 i.productfixedeff3 i.milk_group [aweight = quantity] if product_module_descr == "`module'"
		predict temp if product_module_descr == "`module'", xb
		
		replace `var'=temp if product_module_descr == "`module'" & `var'==.
		drop temp

		}
		*replace `var'_r2 = e(r2) if product_module_descr_hms == "`module'"	
		*replace `var'_n = e(N) if product_module_descr_hms == "`module'"	
		}
	}	
capture log close		


		//Predictions for observations which have product characteristics not seen in sample
		foreach var of varlist g_fat_per100g- cals_fat_per100g {
		egen temp=mean(`var'), by(product_module_descr)
		replace `var'=temp if `var'==. 
		drop temp
		}
		
		
// Cleaning up the negative nutrients. Most of these are products which should have nutrients very close to zero.
foreach var of varlist g_fat_per100g- cals_fat_per100g {
	replace `var'=0 if `var'<0
	}


// Merge back in data which could not be imputed by regression
//drop _merge
drop if upc==""
merge 1:1 upc upc_ver_uc using "$Externals\Calculations\NutritionFacts/nut_facts_imputation.dta"

//Impute Nut facts for modules that only had 1 obv from Gladson
foreach var of varlist g_fat_per100g- cals_fat_per100g {
egen temp=mean(`var') if obs_for_imput==1, by(product_module_descr)
replace `var'=temp if `var'==. & obs_for_imput==1
drop temp
}

drop _merge

drop product_module_descr_hms
rename product_module_descr product_module_descr_hms
//Merge in manually updated Nutrition Info
merge m:1 product_module_descr_hms using "$Externals/Data\NutritionFacts/nut_facts_for_missing_modules.dta", update 
drop _merge

//Dropping UPCs which are missing product_module code and nut facts
drop if product_module_descr_hms=="" & g_carb_per100g==. & tot_cals==.




	
// Fixing issues with more grams per 100 than 100
gen grams_nut= g_fat_per100+ g_carb_per100+ g_prot_per100+ g_sodium_per100+ g_cholest_per100
	gen water_share=1-(grams_nut/100)
	egen avg_water_share=mean(water_share), by(product_module_code)
	replace avg_water_share=0 if avg_water_share<0	
gen sat_fat_share=g_fat_sat_per100g/(g_fat_per100g)
	replace sat_fat_share=1 if sat_fat_share>1 & sat_fat_share~=.
	replace sat_fat_share=0 if sat_fat_share==.
gen fiber_share=g_fiber_per100g/g_carb_per100g
	replace fiber_share=0 if g_carb_per100g==0
	replace fiber_share=1 if fiber_share>1 & fiber_share~=.
gen sugar_share=g_sugar_per100g/ g_carb_per100g
	replace sugar_share=0 if g_carb_per100g==0
	replace sugar_share=1 if sugar_share>1 & sugar_share~=.
gen fiber_sugar_share=fiber_share+sugar_share	
replace sugar_share=1-fiber_share if fiber_sugar_share>1 & sugar_share~=.


	foreach nut in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
	replace `nut'_per100g = 100*`nut'_per100g/(grams_nut+100*avg_water_share) if 100<grams_nut & grams_nut~=.
	}		
	replace g_fat_sat_per100g=g_fat_per100g*sat_fat_share
	replace g_fiber_per100g=g_carb_per100g*fiber_share
	replace g_sugar_per100g=g_carb_per100g*sugar_share

*save "$TEMP\imputed_nut_facts.dta", replace






/*---------------------------------------------------
3) Reconvert back to perUPC level
---------------------------------------------------*/
*use "$TEMP\imputed_nut_facts.dta", clear

replace size1_units_hms="OZ" if regex(size1_units_hms,"OZ")==1

drop Grams
destring multi, replace
destring size1_amount, replace
destring product_group_code, replace
include Code\DataPrep\OtherNielsen\GetGrams.do



foreach nut in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
	gen `nut'_perUPC = .
	}
	
foreach nut in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
	replace `nut'_perUPC = (`nut'_per100g/100)*Grams
	}

*foreach nut in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
*	replace `nut'_perUPC = tot_`nut' if impute_flag==0 & tot_`nut'~=.
*	}	
	
	
	
	
	
	

	
	
*save "$TEMP\imputednutfacts_v2.dta", replace
	
	
	
/*---------------------------------------------------
4) FINAL IMPUTATION FOR ITEMS THAT DONT HAVE WELL DEFINED WEIGHTS/SERVING SIZE
USE AVERAGE UPC level nut facts for these within module
------------------------------------------------------*/
keep ean_13 upc_ver_uc upc quantity min_year max_year upc_descr product_module_descr ///
product_group_descr department_descr multi size1_code_uc size1_amount size1_units ///
 gtin postdate product_module_code product_group_code department_code Grams impute_flag cals_perUPC-g_cholest_perUPC

egen denom=total(quantity), by(product_module_descr_hms)

foreach nut of varlist cals_perUPC- g_cholest_perUPC {
egen temp=total(quantity*`nut'/denom), by(product_module_descr_hms)
replace `nut'=temp if `nut'==.
drop temp
} 

drop denom
gen str_upc=upc


drop if upc==""
gen cals_check = 4*(g_carb_per-g_fiber_perUPC+g_prot_per)+9*g_fat_per
*replace cals_perUPC=cals_check if ((cals_perUPC>2*cals_check) | (cals_perUPC<.9*cals_check)) & department_code~=8
replace cals_perUPC=cals_check  //if ((cals_perUPC>2*cals_check) | (cals_perUPC<.9*cals_check)) & department_code~=8

drop cals_check 


save "$Externals\Data\NutritionFacts/nut_facts_upc_level_MASTER.dta", replace

