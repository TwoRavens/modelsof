/* PrepMagnetNutritionFacts.do */
* This file preps the random weight nutrition facts. 
* Original code prepared by Katie, and modified thereafter.


******************************************************************************

/* SETUP */
ssc install carryforward


/* IMPORT & APPEND USDA NUTRITION FACTS */

* Import magnet data nutrition facts from USDA 
file open myfile using "$Externals/Data/NutritionFacts/USDA/usda_filelist.txt", read
file read myfile line
import delimited using "$Externals/Data/NutritionFacts/USDA/RandomWeight_NutritionFacts/`line'.csv", delimiter(comma) clear
gen usda_product=v1 if _n==4
rename (v1 v2 v3) (nutrient unit valueper100g)
carryforward usda_product, replace
drop if 1<=_n <5
gen id = "`line'"
drop if unit=="" | unit=="Unit"
saveold "$Externals/Calculations/NutritionFacts/USDA/`line'.dta", replace
drop _all

file read myfile line
while r(eof)==0 {
	import delimited using "$Externals/Data/NutritionFacts/USDA/RandomWeight_NutritionFacts/`line'.csv", delimiter(comma) clear
	gen usda_product=v1 if _n==4
	rename (v1 v2 v3) (nutrient unit valueper100g)
	carryforward usda_product, replace
	drop if 1<=_n <5
	gen id = "`line'"
	drop if unit=="" | unit=="Unit"
	save "$Externals/Calculations/NutritionFacts/USDA/`line'.dta", replace
	drop _all
	file read myfile line
	}
	
* Append data
clear all	
set more off
file open myfile2 using "$Externals/Data/NutritionFacts/USDA/usda_filelist.txt", read
file read myfile2 line
use "$Externals/Calculations/NutritionFacts/USDA/`line'.dta", clear
saveold "$Externals/Calculations/NutritionFacts/USDA/usda_master_data.dta", replace
*drop _all

file read myfile2 line
while r(eof)==0 {
	append using "$Externals/Calculations/NutritionFacts/USDA/`line'.dta", force
	*use "$Externals/Data/NutritionFacts/USDA/RandomWeight_NutritionFacts/`line'.dta", clear
	*append using "$Externals/Data/NutritionFacts/USDA/RandomWeight_NutritionFacts/usda_master_data.dta", force
	*drop _all
	erase "$Externals/Calculations/NutritionFacts/USDA/`line'.dta" // There are a lot of these files and we don't need to keep them
	file read myfile2 line
}
	
saveold "$Externals/Calculations/NutritionFacts/USDA/usda_master_data.dta", replace


/* CLEAN USDA NUT FACTS */

* Clean nutrition facts data
use "$Externals/Calculations/NutritionFacts/USDA/usda_master_data.dta", clear
drop v4-v9	v10-v16
gen code_kw = substr(id,1,strpos(id,"_")-1)
replace usda_product=substr(usda_product,strpos(usda_product,",")+1,.)
gen type = substr(id,strpos(id,"_")+1,.)
gen imputed_match = 1 if regexm(id,"_imp")
replace type=substr(id,strpos(id,"_")+1,strpos(id,"_imp")-strpos(id,"_")-1) if imputed_match==1
replace code_kw="cakes2" if code_kw=="cake2"
replace code_kw="ribs" if code_kw=="ribs2"

destring type, replace

	* Deal with meats of different fat contents
	gen fatproduct=1 if strpos(id,"_pct_")
	gen pct_lean = substr(id,strpos(id,"_pct_")+5,.) if fatproduct==1
	replace type=substr(type,1,strpos(type,"_pct_")-1) if fatproduct==1
	drop fatproduct
	
	* Merge on product module and food item description
	sort code_kw type
	merge m:1 code_kw using "$Externals/Data/NutritionFacts/USDA\product_module_codes_kw.dta"
	drop Characteristic code_kw _merge id
	
	* Prepare for reshape
	gen unit2 = "iu" if unit=="IU"
	replace unit2 = "g" if unit=="g"
	replace unit2 = "kcal" if unit=="kcal"
	replace unit2 = "mg" if unit=="mg"
	replace unit2 = "mcg" if unit=="µg"
	replace unit2 = "mcg" if unit=="Âµg"
	
	gen nutrient2="caffeine" if nutrient=="Caffeine"
	replace nutrient2="calcium" if nutrient=="Calcium, Ca"
	replace nutrient2="carb" if nutrient=="Carbohydrate, by difference"
	replace nutrient2="cholesterol" if nutrient=="Cholesterol"
	replace nutrient2="energy" if nutrient=="Energy"
	replace nutrient2="fat_mono" if nutrient=="Fatty acids, total monounsaturated"
	replace nutrient2="fat_poly" if nutrient=="Fatty acids, total polyunsaturated"
	replace nutrient2="fat_sat" if nutrient=="Fatty acids, total saturated"
	replace nutrient2="fiber" if nutrient=="Fiber, total dietary"
	replace nutrient2="folate" if nutrient=="Folate, DFE"
	replace nutrient2="iron" if nutrient=="Iron, Fe"
	replace nutrient2="magnesium" if nutrient=="Magnesium, Mg"
	replace nutrient2="niacin" if nutrient=="Niacin"
	replace nutrient2="phosphorus" if nutrient=="Phosphorus, P"
	replace nutrient2="potassium" if nutrient=="Potassium, K"
	replace nutrient2="protein" if nutrient=="Protein"
	replace nutrient2="riboflavin" if nutrient=="Riboflavin"
	replace nutrient2="sodium" if nutrient=="Sodium, Na"
	replace nutrient2="sugar_tot" if nutrient=="Sugars, total"
	replace nutrient2="thiamin" if nutrient=="Thiamin"
	replace nutrient2="lipid_tot" if nutrient=="Total lipid (fat)"
	replace nutrient2="vit_a_iu" if nutrient=="Vitamin A, IU"
	replace nutrient2="vit_a_rae" if nutrient=="Vitamin A, RAE"
	replace nutrient2="vit_b12" if nutrient=="Vitamin B-12"
	replace nutrient2="vit_b6" if nutrient=="Vitamin B-6"
	replace nutrient2="vit_c" if nutrient=="Vitamin C, total ascorbic acid"
	replace nutrient2="vit_d" if nutrient=="Vitamin D"
	replace nutrient2="vit_d2_d3" if nutrient=="Vitamin D (D2 + D3)"
	replace nutrient2="vit_e" if nutrient=="Vitamin E (alpha-tocopherol)"
	replace nutrient2="vit_k" if nutrient=="Vitamin K (phylloquinone)"
	replace nutrient2="water" if nutrient=="Water"
	replace nutrient2="zinc" if nutrient=="Zinc, Zn"
	
	* Reshape
	gen var=unit2+"_"+nutrient2
	drop *2 unit nutrient
	rename valueper100g _per100g
	reshape wide @_per100g, i(product_module type pct_lean Description) j(var) string
	rename Description module_descr
	
	* Merge on type codes
	sort product_module type
	destring type, replace
	merge m:1 product_module type using "$Externals/Data/NutritionFacts/USDA\product_type_codes.dta"
	drop Characteristic _merge 
	rename Description type_descr
	
		*Merge on module codes
		sort product_module
		merge m:1 product_module using "$Externals/Data/NutritionFacts/USDA\product_module_codes_kw.dta"
		drop module_descr Characteristic code_kw _merge
		rename Description module_descr
		order product_module type pct_lean module_descr type_descr usda_product
		sort product_module type pct_lean
	
	* Tag questionable matches - ones we don't feel great about
	gen questionable_match=0
	replace questionable_match=1 if product_module==701 & type==30603
	replace questionable_match=1 if product_module==701 & type==30604
	replace questionable_match=1 if product_module==702 & type==37020
	replace questionable_match=1 if product_module==703 & type==30595
	replace questionable_match=1 if product_module==704 & type==30588
	replace questionable_match=1 if product_module==706 & type==30766
	replace questionable_match=1 if product_module==706 & type==30776
	replace questionable_match=1 if product_module==706 & type==30779
	replace questionable_match=1 if product_module==707 & type==30623
	replace questionable_match=1 if product_module==707 & type==30624
	replace questionable_match=1 if product_module==707 & type==30628
	replace questionable_match=1 if product_module==708 & type==3877
	replace questionable_match=1 if product_module==709 & type==1535
	replace questionable_match=1 if product_module==709 & type==2505
	replace questionable_match=1 if product_module==709 & type==2549
	replace questionable_match=1 if product_module==709 & type==5605
	replace questionable_match=1 if product_module==709 & type==31162
	replace questionable_match=1 if product_module==709 & type==31163
	replace questionable_match=1 if product_module==709 & type==31166
	replace questionable_match=1 if product_module==709 & type==31167
	replace questionable_match=1 if product_module==710 & type==4720
	replace questionable_match=1 if product_module==712 & type==30707
	replace questionable_match=1 if product_module==712 & type==30731
	replace questionable_match=1 if product_module==712 & type==30735
	replace questionable_match=1 if product_module==713 & type==30665
	replace questionable_match=1 if product_module==714 & type==2096
	replace questionable_match=1 if product_module==715 & type==5348
	replace questionable_match=1 if product_module==715 & type==5351
	replace questionable_match=1 if product_module==715 & type==5440
	replace questionable_match=1 if product_module==715 & type==5613
	replace questionable_match=1 if product_module==717 & type==14208
	replace questionable_match=1 if product_module==717 & type==17242
	replace questionable_match=1 if product_module==717 & type==30674
	replace questionable_match=1 if product_module==717 & type==30675
	replace questionable_match=1 if product_module==717 & type==30676
	replace questionable_match=1 if product_module==717 & type==30678
	replace questionable_match=1 if product_module==717 & type==30679
	replace questionable_match=1 if product_module==717 & type==30685
	replace questionable_match=1 if product_module==717 & type==30689
	replace questionable_match=1 if product_module==719 & type==30632
	replace questionable_match=1 if product_module==719 & type==30633
	replace questionable_match=1 if product_module==719 & type==30634
	replace questionable_match=1 if product_module==719 & type==30640
	replace questionable_match=1 if product_module==719 & type==30641
	replace questionable_match=1 if product_module==719 & type==30644
	replace questionable_match=1 if product_module==720 & type==15269
	replace questionable_match=1 if product_module==721 & type==30771
	replace questionable_match=1 if product_module==721 & type==30808
	replace questionable_match=1 if product_module==721 & type==30809
	replace questionable_match=1 if product_module==721 & type==30810
	replace questionable_match=1 if product_module==721 & type==30811
	replace questionable_match=1 if product_module==721 & type==30812
	replace questionable_match=1 if product_module==721 & type==30813
	replace questionable_match=1 if product_module==722 & type==30701
	replace questionable_match=1 if product_module==722 & type==30702
	replace questionable_match=1 if product_module==723 & type==1411
	replace questionable_match=1 if product_module==725 & type==2619
	replace questionable_match=1 if product_module==725 & type==4105
	replace questionable_match=1 if product_module==725 & type==4720
	replace questionable_match=1 if product_module==730 & type==30603
	replace questionable_match=1 if product_module==730 & type==30604
	replace questionable_match=1 if product_module==730 & type==37089
	replace questionable_match=1 if product_module==730 & type==37090
	replace questionable_match=1 if product_module==731 & type==36999
	replace questionable_match=1 if product_module==733 & type==3494
	replace questionable_match=1 if product_module==735 & type==24058
	replace questionable_match=1 if product_module==736 & type==3877
	replace questionable_match=1 if product_module==740 & type==30643
	replace questionable_match=1 if product_module==740 & type==30644
	replace questionable_match=1 if product_module==740 & type==37111
	replace questionable_match=1 if product_module==740 & type==37112
	replace questionable_match=1 if product_module==741 & type==30803
	replace questionable_match=1 if product_module==742 & type==30768
	replace questionable_match=1 if product_module==742 & type==30771
	replace questionable_match=1 if product_module==742 & type==30775
	replace questionable_match=1 if product_module==742 & type==30808
	replace questionable_match=1 if product_module==742 & type==37156
	replace questionable_match=1 if product_module==749 & type==2505
	replace questionable_match=1 if product_module==749 & type==31163
	replace questionable_match=1 if product_module==749 & type==37833
	replace questionable_match=1 if product_module==749 & type==37835
	replace questionable_match=1 if product_module==749 & type==37837
	replace questionable_match=1 if product_module==749 & type==37846
	replace questionable_match=1 if product_module==749 & type==37852
	replace questionable_match=1 if product_module==749 & type==37853
	replace questionable_match=1 if product_module==718 & type==30803
	replace questionable_match=1 if product_module==718 & type==30806
	replace questionable_match=1 if product_module==738 & type==37081
	replace questionable_match=1 if product_module==739 & type==37083
	replace questionable_match=1 if product_module==740 & type==30634
	replace questionable_match=1 if product_module==749 & type==3863
	replace questionable_match=1 if product_module==709 & type==3863
	
	destring g* mg* kcal_energy_per100g, replace force
	
	
	/* Rename variables to be consistent with other datasets */
	rename module_descr product_module_descr
	rename product_module product_module_code
	rename g_protein_per100g g_prot_per100g
	rename g_sugar_tot_per100g g_sugar_per100g
	rename g_lipid_tot_per100g g_fat_per100g
	
	rename kcal_energy_per100g cals_per100g
	
	gen g_cholest_per100g = mg_cholesterol_per100g/1000
	drop mg_cholesterol_per100g
	gen g_sodium_per100g = mg_sodium_per100g/1000
	drop mg_sodium_per100g
	

/* Impute missing data */
* In some cases, a module will be missing one nutrition fact. Impute using module means.
foreach var of varlist g_*_per100g {
	bysort product_module_code: egen mean`var'=mean(`var')
	replace `var' = mean`var' if `var'==.
	drop mean`var'
}

/* Get grams per 1000 Calories */
	foreach nut in carb fat fiber prot fat_sat sugar sodium cholest {
		gen g_`nut'_per1000Cal = g_`nut'_per100g / cals_per100g * 1000
	}
	
	** Placeholder missings to make later merges work
	foreach nut in  MilkFatPct LowFatMilk NonFatMilk Whole  {
		gen `nut' = .
	}
	
/* Get Fruit, Veg, and HealthIndex */
gen byte FreshFruit = cond(product_module_code==711,1,0)
gen byte FreshVeg = cond(product_module_code==712,1,0)
gen byte Fruit = FreshFruit
gen byte Veg = FreshVeg
	
label var FreshFruit "1(Fresh Fruit)"	
label var FreshVeg "1(Fresh Vegetable)"
label var Fruit "1(Fruit)"
label var Veg "1(Vegetable)"

include Code/DataPrep/NutritionFacts/GetHealthIndex.do

/* Merge data for Healthy Eating Index */
*** Get crosswalk from module code to foodcode
	preserve
	insheet using $Externals/Data/NutritionFacts/USDA/Crosswalk_RandomWeight_to_foodcode.csv, comma names clear case
	keep product_module_code type pct_lean foodcode
	compress
	tostring pct_lean, replace
	replace pct_lean = "" if pct_lean=="."
	save $Externals/Calculations/NutritionFacts/USDA/Crosswalk_RandomWeight_to_foodcode.dta, replace
	restore

** Merge foodcode into RW data
merge 1:1 product_module_code type pct_lean using $Externals/Calculations/NutritionFacts/USDA/Crosswalk_RandomWeight_to_foodcode.dta, ///
	keep(match master) nogen keepusing(foodcode)
** Merge $HEINuts by foodcode
merge m:1 foodcode using $Externals/Calculations/NutritionFacts/HEI/HEINutritionFactsByFoodcode.dta, ///
	keep(match master) keepusing($HEINuts energy)
assert _m==3 // Check that all match. 
drop _m
drop foodcode


** Get HEI
	* Temp: need energy_per1
	gen energy_per1 = energy
include Code/DataPrep/NutritionFacts/GetlinearHEI.do
	drop energy_per1

rename energy energy_per100g // This makes energy consistent with the variable name cals_per100g
	
/* Merge perishability */
merge m:1 product_module_code type using "$Externals/Calculations/NutritionFacts/Perishability_Magnet.dta", nogen keep(match master) keepusing(Storability)
* there are no missings


/* Get Coke vs. Pepsi indicator */
	* We don't know this for the magnet data
gen byte ShareCoke = .


/* Define sugar-sweetened beverages */
gen byte SSB = cond(inlist(product_module_code,1484,7743,1046,1048,1050,1052,1481,1482,1483,1041,1042),1,0) // These product modules are the same as in UPCDataPrep.do: everything in groups 1503 and 1508, except 1553, 1487, and 1049; plus 1041 and 1042.


/* Merge convenience scores */
merge m:1 product_module_code using "$Externals/Calculations/NutritionFacts/ConvenienceScores.dta", keep(match master) nogen

	
compress
saveold "$Externals/Calculations/NutritionFacts/magnetdata_nut_facts.dta", replace
	

