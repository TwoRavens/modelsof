/* PrepNutritionFactsForHEI.do */
/* Prep the nutrition facts by foodcode */
use "$Externals/Data/NutritionFacts/HEI/foodcode.dta", clear
rename seafood_plant_protein sea_plant_prot

** Transform teaspoons sugar to grams
replace added_sugar=added_sugar*4.2

** Transform to nutrient content per 1000 cals instead of per gram
foreach var in $HEINuts {
	local orig = substr("`var'",1,length("`var'")-11) // This is the original variable name, not _per1000Cal
	di "`orig'"
	gen `var' = `orig'/energy * 1000 if energy>1
}
compress
saveold $Externals/Calculations/NutritionFacts/HEI/HEINutritionFactsByFoodcode.dta, replace

/* Prep the UPC-level dataset */
** Get full list of IRI UPCs and their corresponding foodcodes
* Prep list 1
use "$Externals/Data/NutritionFacts/HEI/iri_foodcode_link.dta", clear
destring upc, replace force
compress
saveold $Externals/Calculations/NutritionFacts/HEI/HEINutritionFactsByUPC.dta, replace

* Open list 2, merge list 1
use "$Externals/Data/NutritionFacts/HEI/iri_foodcode_link_v2.dta", clear
recast str40 ec_description, force
rename ec foodcode
merge 1:1 upc using $Externals/Calculations/NutritionFacts/HEI/HEINutritionFactsByUPC.dta, nogen
replace foodcode = ec if foodcode==. // update foodcode with the v1 version only if missing from v2
drop ec
rename ec_description description


** Merge yield (the ratio between grams consumed and grams in package
merge 1:1 upc using $Externals/Data/NutritionFacts/HEI/conversion_rw.dta, keep(match master) keepusing(yield) nogen
merge 1:1 upc using "$Externals/Data/NutritionFacts/HEI/conversion_pos.dta", keep(match master match_up match_con) keepusing(yield) nogen update
replace yield = yield/100

* Impute missing yields. Assume foodcode mean, then 100% if none available
bysort foodcode: egen meanyield=mean(yield)
replace yield = meanyield if yield==.
drop meanyield
replace yield = 1 if yield==.

** Merge nutrition facts by foodcode
merge m:1 foodcode using $Externals/Calculations/NutritionFacts/HEI/HEINutritionFactsByFoodcode.dta, ///
	keep(match master) nogen // keepusing($HEINuts)

** Insert HEI
* include Code/DataPrep/NutritionFacts/GetlinearHEI.do // xx don't insert this now because need cals_per1 variable

** Re-make UPC to match with Nielsen data
replace upc = floor(upc/100)
* There are now some duplicates
duplicates drop upc foodcode, force
sort upc foodcode
duplicates drop upc, force // NB this arbitrarily drops some duplicates, but <1% of observations


compress
save $Externals/Calculations/NutritionFacts/HEI/HEINutritionFactsByUPC.dta, replace
