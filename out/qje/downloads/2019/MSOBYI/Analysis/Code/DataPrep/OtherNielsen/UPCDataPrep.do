/* UPCDataPrep.do */
* After nutrition facts, convenience, and perishability are prepared, run this to get the file Calculations/Prepped-UPCs.dta 


** Open UPC-Info, as imported from the original Kilts files
use "$Externals/Calculations/OtherNielsen/UPC-Info.dta", replace

** Merge nutrition facts
merge 1:1 upc upc_ver_uc using "$Externals/Calculations/NutritionFacts/hms_upcs_with_nut_facts_imputed.dta", keep(match master using) keepusing(cals_per1 g_*_per*) nogen

** Translate everything to grams. 
include Code/DataPrep/OtherNielsen/GetGrams.do


** Get nutrition facts per 100 grams and per 1000 calories
foreach nut in cals g_fat g_carb g_fiber g_prot g_fat_sat g_sugar g_sodium g_cholest {
	gen `nut'_per100g = `nut'_per1/Grams * 100
	if "`nut'"!="cals" {
		gen `nut'_per1000Cal = `nut'_per1/cals_per1 * 1000 if cals_per1>1 // Leave this missing for very low calorie UPCs because this generates massive outliers.
	}
}

/* Define fruits and vegetables */
	* Note: Tomato is a vegetable, as coded by Nielsen. It is botanically a fruit but has lower sugar content than most fruit.
	* Note: Pumpkin is a vegetable, as coded by Nielsen.
gen byte FreshFruit = cond(inlist(product_module_code,453,3560,3563,4010,4085,4180,4225,4230,4355,4470,6049,6050),1,0)
gen byte Fruit = cond(FreshFruit==1|inlist(product_group_code,504,1010)==1| ///
	inlist(product_module_code,6,42,2664)==1,1,0) // Canned, dried, and frozen

gen byte FreshVeg = cond(inlist(product_module_code,460,3544,4015,4020,4023,4050,4055,4060,4140,4275,4280,4350,4400,4415,4460,4475,6064,6070)==1,1,0) // Fresh vegetables and pre-cut fresh salad mix
gen byte Veg = cond( ( FreshVeg==1 | inlist(product_group_code,514,2010)==1 | /// canned and frozen vegetables
	inlist(product_module_code,24,96,1316,3565)==1 ) & /// unclassified canned and frozen vegetables; dried peas, lentils, and corn ; sauerkraut.
	inlist(product_module_code,1071,2618,2635,2637,2638,2639)==0,1,0) // EXCLUDES: 1071 cream style corn. 2618: frozen vegetables in pastry. 3635: vegetables - breaded - frozen. 3637 - breaded mushrooms. 3638 - breaded onions. 2639 - vegetables in sauce.
	
** Note: not including these as vegetables:
	*product_module_code 4475: fresh flowers.
	*product_module_code 64: unclassified vegetables and grains - dried	
	*product_group_code 1021: vegetables and grains - dried. This includes rice and beans, which we definitely don't want to count as vegetables. I am including only peas and lentils module from that.
	*product_module_code 3564: remaining ready-made salads. Could be pasta salad, etc, and may include mayo.

label var FreshFruit "1(Fresh Fruit)"	
label var Fruit "1(Fruit)"
label var FreshVeg "1(Fresh Vegetable)"
label var Veg "1(Vegetable)"


/* Define sugar-sweetened beverages */
gen byte SSB = cond( (inlist(product_group_code,1503,1508) /// carbonated beverages and soft-drinks non-carbonated
	& product_module_code!=1553 & product_module_code!=1487 & product_module_code!=1049 ) | /// excluding diet drinks, bottled water, and 1049, which is largely meal replacements and soymilk
	inlist(product_module_code,1041,1042) /// Any fruit "drinks" in product_group_code 507 (but not fruit or vegetable "juices")
	,1,0) // exclude diet and water. 1049 is soymilk, yoo-hoo, and breakfast drinks. These are largely sugar-sweetened but milk substitutes and breakfast drinks are not typically taxed.


/* Assign graintypes using upc description */
include Code/DataPrep/NutritionFacts/AssignGraintypefromUPCDescription.do


/* Determine milkfat percent */
include Code/DataPrep/NutritionFacts/GetMilkFat.do

*keep upc upc_ver_uc department_code product_group_code product_module_code Wheat MilkFatPct LowFat NonFat Grams

* egen UPCGroup = group(upc upc_ver_uc) // Only needed if we are doing UPC fixed effects.

/* Get group */
include Code/DataPrep/NutritionFacts/GetGroup.do

/* Merge perishability */
merge m:1 product_module_code using "$Externals/Calculations/NutritionFacts/Perishability.dta", nogen keep(match master) keepusing(Storability* StoreTime)
* replace missings. (There are a few, including e-cigs, mostly non-food)
sum Storability
replace Storability = r(max) if Storability==.

sum StoreTime
replace StoreTime = r(max) if StoreTime==.

/* Get departments for estimation*/
include Code/DataPrep/NutritionFacts/GetDeptEst.do


/* Get Coke vs. Pepsi indicator */
* Takes value 1 for coke, 0 for Pepsi, and missing otherwise, within product_module_code = 1484 (carbonated soft drinks, excluding low-calorie)
gen byte ShareCoke = .
replace ShareCoke = 1 if product_module_code==1484 & strpos(brand_descr,"COCA-COLA")!=0
replace ShareCoke = 0 if product_module_code==1484 & strpos(brand_descr,"PEPSI")!=0


/* Merge convenience scores */
merge m:1 product_module_code using "$Externals/Calculations/NutritionFacts/ConvenienceScores.dta", keep(match master) nogen

/* Merge nutrition facts for HEI */
merge m:1 upc using "$Externals/Calculations/NutritionFacts/HEI/HEINutritionFactsByUPC.dta", keep(match master) nogen keepusing($HEINuts energy yield)
gen byte ImputedHEINuts=cond(sodium_==.,1,0) if NonFood==0

* Use graintype when observed
gen Wholeg = cond(Whole==1,1,0)

** Impute missing HEI nutrition facts per 1000 calories
	* This is way higher R2 than predicting per 1000Cal
foreach var in $HEINuts {
	sum `var'
	local min = r(min)
	local max = r(max)
	
	** Predict based on nutrients only
	reg `var' g_fat_per1000Cal g_carb_per1000Cal g_fiber_per1000Cal g_prot_per1000Cal ///
			g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal ///
			Wholeg 
	predict Pnuts
	** Predict based on nutrients and group/module means
	foreach level in module group {
		bysort product_`level'_code: egen m`level'=mean(`var') // m for mean
		
		reg `var' g_fat_per1000Cal g_carb_per1000Cal g_fiber_per1000Cal g_prot_per1000Cal ///
			g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal ///
			Wholeg m`level'
		predict P`level' // P for Prediction
	}
	
	** Replace with predictions
	* Full module, then group predictions. Then module, then group averages (helps for low- or zero-cal UPCs where nuts/1000Cal is missing. Then nutrient-only averages (helps for a few UPCs that have missing product groups and modules.)
	replace `var' = Pmodule if `var'==. & NonFood==0
	replace `var' = Pgroup if `var'==. & NonFood==0
	replace `var' = mmodule if `var'==. & NonFood==0
	replace `var' = mgroup if `var'==. & NonFood==0
	replace `var' = Pnuts if `var'==. & NonFood==0
	
	* winsorize
	replace `var' = `min' if `var'<`min' & NonFood==0
	replace `var' = `max' if `var'>`max' & `var'!=. & NonFood==0
	drop Pnuts Pmodule Pgroup mmodule mgroup
}
drop Wholeg

** Impute yield
egen myield=mean(yield), by(product_module_code)
replace yield=myield if yield==. & NonFood==0

egen pyield=mean(yield), by(product_group_code)
replace yield=myield if yield==. & NonFood==0
replace yield=pyield if yield==. & NonFood==0
drop myield pyield
replace yield=1 if yield==. & NonFood==0

** Impute energy
sum energy
local min = r(min)
local max = r(max)
	
egen menergy=mean(energy), by(product_module_code)
egen penergy=mean(energy), by(product_group_code)

reg energy cals_per100g menergy
predict menergy1
reg energy cals_per100g penergy
predict penergy1
reg energy cals_per100g
predict ehat
replace energy=menergy1 if energy==. & NonFood==0
replace energy=penergy1 if energy==. & NonFood==0
replace energy=ehat if energy==. & NonFood==0
drop ehat menergy* penergy*
replace energy=`min' if energy<`min' & NonFood==0
replace energy=`max' if energy>`max' & energy~=. & NonFood==0


** Get HEI measure of calories in the UPC
gen energy_per1=energy*yield*Grams/100


** Get HEI nutrition facts per 1 (needed for PrepHHxGroup.do)
foreach var in $HEINuts_per1 {
	gen `var' = `var'000Cal * (energy_per1/1000)
}


** Get HealthIndex and linear HEI
include Code/DataPrep/NutritionFacts/GetHealthIndex.do 
include Code/DataPrep/NutritionFacts/GetlinearHEI.do 

compress
saveold "$Externals/Calculations/OtherNielsen/Prepped-UPCs.dta", replace

* 
