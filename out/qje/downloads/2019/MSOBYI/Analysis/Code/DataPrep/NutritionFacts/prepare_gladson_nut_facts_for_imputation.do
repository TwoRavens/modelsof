clear all
set more off

/*-------------------------------------------------
Prepare Gladson nut facts
ccwright began 2 April 2015
diamondr last modified 7 May 2015

Sections of Code:
0) Globals
1) Import & basic cleaning of Gladson nut data
2) Standardize units of measurement & fix errors in weight/quantity data as best as possible
3) Incorporate Nielsen HMS size codes prior to standaridizing any sizes
4) Deal with size/weight discrepancies between HMS & Gladson and deal with isolated data entry errors
5) Calculate nuts per100g
6) Merge this Gladson set to macronut dums to be used for imputation & tidy/save
---------------------------------------------------*/

/*-------------------------------------------------
0) Set globals
---------------------------------------------------*/

/*
* MAIN DROBBOX FOLDER
*global MAIN "C:/Users/ccwright/Dropbox/NutritionandIncome"
global MAIN "C:/Users/diamondr/Dropbox/NutritionandIncome"
global in "$MAIN\OriginalData\Gladson"
global dataout "$MAIN\Analysis\Data\NutritionFacts"

* LOCAL MACHINE
global LOCAL "C:\Users\ccwright\Desktop\RF work\NutritionandIncome_LOCAL"
global nutfactslocal "$LOCAL\NutritionFacts" 
global TEMP "$LOCAL\NutritionFacts\TMP"
global hms "$LOCAL\NielsenHMS"

//Rebecca's paths
global LOCAL "D:\nielsen"
global nutfactslocal "$LOCAL/NutritionFacts"
global TEMP "$LOCAL/TMP"
global hms "$LOCAL/stata_datasets"
*/



/*-------------------------------------------------
1) IMPORT & PRELIMINARY CLEANING
---------------------------------------------------*/
set more off

import delimited using "$Externals/Data/NutritionFacts/final_gladson_upc_list.csv", clear stringcols(1 3) // this is just a stata copy of "final_gladson_upc_listcsv"
save "$Externals/Data/NutritionFacts/gladson_upc_conversions.dta", replace

import delimited using "$Externals/Data/NutritionFacts/nutrient.csv", case(lower) stringcols(_all) varnames(1) clear

* Merge on UPC format that will match to Homescan
rename upc gtin
replace gtin="00089094033552D" if gtin=="00089094033552d"
replace gtin="00894773001117s" if gtin=="00894773001117S"

	* Create numeric version of upc
	gen upc=gtin
	replace upc=subinstr(upc,"S","",.)
	replace upc=subinstr(upc,"A","",.)
	replace upc=subinstr(upc,"U","",.)
	replace upc=subinstr(upc,"D","",.)
	replace upc=subinstr(upc,"G","",.)
	replace upc=subinstr(upc,"N","",.)
	replace upc=subinstr(upc,"M","",.)
	replace upc=subinstr(upc,"C","",.)
	replace upc=subinstr(upc,"V","",.)
	replace upc=subinstr(upc,"X","",.)
	replace upc=subinstr(upc,"Q","",.)	
	replace upc=subinstr(upc,"d","",.)	
	replace upc=subinstr(upc,"R","",.)	
	replace upc=subinstr(upc,"s","",.)		
	replace upc=subinstr(upc,"g","",.)	
	destring upc, replace
	format upc %16.0g

merge m:1 gtin using "$Externals/Data/NutritionFacts/gladson_upc_conversions.dta"  
drop if _merge==2 
drop _merge

* Merge on serving sizes
merge m:1 gtin valuepreparedtype using "$Externals/Data/NutritionFacts/ValuePrepared.dta" 
keep if _merge==3
drop _merge

* Merge on Nutrient IDs
destring nutrientmasterid, replace
*sort nutrientmasterid
merge m:1 nutrientmasterid using "$Externals/Data/NutritionFacts/NutrientMaster.dta"
drop if _merge==2 
drop _merge
rename name nutrient

	replace nutrient="cals" if nutrient=="Calories"
	replace nutrient="cals_fat" if nutrient=="Calories from Fat"
	replace nutrient="fat" if nutrient=="Total Fat"
	replace nutrient="fat_sat" if nutrient=="Saturated Fat"
	replace nutrient="fat_poly" if nutrient=="Polyunsaturated Fat"
	replace nutrient="fat_mono" if nutrient=="Monounsaturated Fat"
	replace nutrient="fat_trans" if nutrient=="Trans Fat"
	replace nutrient="cholest" if nutrient=="Cholesterol"
	replace nutrient="sodium" if nutrient=="Sodium"
	replace nutrient="carb" if nutrient=="Total Carbohydrate"
	replace nutrient="fiber" if nutrient=="Dietary Fiber"
	replace nutrient="sugar" if nutrient=="Sugars"
	replace nutrient="prot" if nutrient=="Protein"
	
destring quantity pct , replace


/*-------------------------------------------------
2) STANDARDIZE UNITS OF MEASUREMENT
--------------------------------------------------*/

* Standardize servings per container
set more off
gen totservings=servingspercontainer
foreach word in about approx approximately usually approx. aprox aprox. aprx. aprx sbout {
	replace totservings = subinstr(totservings,"`word' ","",.)
	}
gen test1=real(totservings)
tab totservings if test1==.
replace totservings="2" if substr(totservings,1,2)=="2 " | totservings=="2"
replace totservings="9" if servingspercontainer=="about 9 as packaged"
replace totservings="18" if servingspercontainer=="about 18 as packaged"
replace totservings="8" if servingspercontainer=="about 8 as packaged"
replace totservings="27" if servingspercontainer=="about 27 as packaged"
replace totservings="2.5" if servingspercontainer=="2-3"
replace totservings="4.5" if servingspercontainer=="4,5"
replace totservings="15" if servingspercontainer=="14-16"
replace totservings="5.5" if servingspercontainer=="5-6"
replace totservings="5.5" if servingspercontainer=="about 5-6 muffins"
replace totservings="5" if servingspercontainer=="about 5 (dry)"
replace totservings="3" if servingspercontainer=="about 3 dry"
replace totservings="3" if servingspercontainer=="about 3 (dry)"
replace totservings="1" if servingspercontainer=="1 pie"
replace totservings="10" if servingspercontainer=="10 approx"
replace totservings="15" if servingspercontainer=="14-16"
replace totservings="17" if servingspercontainer=="16-18"
replace totservings="18" if servingspercontainer=="18 as packaged"
replace totservings="19" if servingspercontainer=="19 (per 20 oz)"
replace totservings="1" if servingspercontainer=="1`"
replace totservings="2" if servingspercontainer=="2 about"
replace totservings="2.5" if regexm(servingspercontainer,("2-1/2|2-5|2.5 (dry)|2.5 dry|2.5 with liquid|abut 2.5"))
replace totservings="27" if servingspercontainer=="27 as packaged"
replace totservings="3" if servingspercontainer=="3 (dry)" | servingspercontainer=="3 dry"
replace totservings="3.5" if regexm(servingspercontainer,("3-4|3.5 (dry)|3.5 dry|abotu 3.5"))
replace totservings="4.5" if regexm(servingspercontainer,("4 - 5|4,5|4-5"))
replace totservings="5" if regexm(servingspercontainer,("5 (dry)|5 with liquid"))
replace totservings="5.5" if regexm(servingspercontainer,("5-6"))
replace totservings="8" if regexm(servingspercontainer,("8, 2-4 serving pouches|8 as packaged|appr. 8"))
replace totservings="9" if regexm(servingspercontainer,("9 as packaged|9`"))
replace totservings="6" if regexm(servingspercontainer,("`6|per pack 6"))
replace totservings="6" if servingspercontainer=="6 - 1oz bags"
replace totservings="42" if servingspercontainer=="abouat 42"
replace totservings="16" if servingspercontainer=="abut 16"
replace totservings="15" if servingspercontainer=="usally 15"
replace totservings="1100" if servingspercontainer=="1100 as pan spray"
replace totservings="1134" if servingspercontainer=="1,134"
replace totservings="14" if servingspercontainer=="14Servi"
replace totservings="2" if servingspercontainer=="2 packs"
replace totservings="17.5" if servingspercontainer=="17-18"
replace totservings="4" if servingspercontainer=="about 4 dry"
gen test2=real(totservings)
set more off
tab totservings if test2==.



destring totservings, replace force
gen servingsizetextreal=real(servingsizetext)
replace totservings = itemsize / servingsizetextreal if test2==. & servingsizeuom=="oz" & itemmeasure=="oz"
replace totservings = itemsize / servingsizetextreal if test2==. & servingsizeuom=="fl oz" & itemmeasure=="oz"
replace totservings = itemsize / servingsizetextreal if test2==. & servingsizeuom=="oz dry" & itemmeasure=="oz"
replace totservings = itemsize / servingsizetextreal if test2==. & servingsizeuom=="g" & itemmeasure=="g"
replace totservings=1 if servingsizetext=="1" & servingspercontainer=="" & ///	
	regexm(servingsizeuom,("bar|bottle|can|container|jar|meal|package|pouch"))==1 & totservings==.
	
//converting percent of daily value nut facts to grams
	replace quantity=pct*300/100 if nutrient=="carb" & quantity==.
	replace quantity=pct*65/100 if nutrient=="fat" & quantity==.
	replace quantity=pct*20/100 if nutrient=="fat_sat" & quantity==.
	replace quantity=pct*25/100 if nutrient=="fiber" & quantity==.
	replace quantity=pct*2.4/100 if nutrient=="sodium" & quantity==.
	
	replace uom="g" if nutrient=="carb" & quantity~=. & pct~=. & uom==""
	replace uom="g" if nutrient=="fat" & quantity~=. & pct~=. & uom==""
	replace uom="g" if nutrient=="fat_sat" & quantity~=. & pct~=. & uom==""
	replace uom="g" if nutrient=="fiber" & quantity~=. & pct~=. & uom==""
	replace uom="g" if nutrient=="sodium" & quantity~=. & pct~=. & uom==""
	
	
	
drop test* servingsizetextreal

* Standardize units of measurement 

	* Carb
	replace quantity=quantity*1000 if nutrient=="carb" & uom=="mg"
	replace uom="g" if regexm(uom,("2|6|mg")) & nutrient=="carb"
	replace uom="g" if nutrient=="carb"
	replace quantity=0 if quantity<0 & nutrient=="carb"

	* Fat
	replace quantity=quantity*1000 if nutrient=="fat" & uom=="mg"
	replace uom="g" if regexm(uom,("22|4|4g|G|g |g 3|g8|mg")) & nutrient=="fat"
	replace uom="g" if nutrient=="fat"

	* Fat_mono
	replace quantity=quantity*1000 if nutrient=="fat_mono" & uom=="mg"
	replace uom="g" if regexm(uom,("0|mg")) & nutrient=="fat_mono"
	replace uom="g" if nutrient=="fat_mono"

	* Fat_poly
	replace quantity=quantity*1000 if nutrient=="fat_poly" & uom=="mg"
	replace uom="g" if nutrient=="fat_poly"

	* Fat_sat
	replace quantity=quantity*1000 if nutrient=="fat_sat" & uom=="mg"
	replace uom="g" if regexm(uom,("0|30|G|mg")) & nutrient=="fat_sat"
	replace uom="g" if nutrient=="fat_sat"

	* Fat_trans 
	replace quantity=quantity*1000 if nutrient=="fat_trans" & uom=="mg"
	replace uom="g" if regexm(uom,(" g|g |mg")) & nutrient=="fat_trans"
	replace uom="g" if nutrient=="fat_trans"

	* Fiber
	replace quantity=quantity*1000 if nutrient=="fiber" & uom=="mg"
	replace uom="g" if regexm(uom,("0|3|4|5|8|G|g |g0|mg")) & nutrient=="fiber"
	replace uom="g" if nutrient=="fiber"
	replace quantity=0 if quantity<0 & nutrient=="fiber"
	
	
	* Protein
	replace quantity=quantity*1000 if nutrient=="prot" & uom=="mg"
	replace uom="g" if regexm(uom,("6|G|g |mg")) & nutrient=="prot"
	replace uom="g" if nutrient=="prot"

	* Sugar
	replace quantity=quantity*1000 if nutrient=="sugar" & uom=="mg"
	replace quantity=quantity*28.3495 if nutrient=="sugar" & uom=="oz"
	replace uom="g" if regexm(uom,("0|G|Null|mg|oz")) & nutrient=="sugar"
	replace uom="g" if nutrient=="sugar"

	* Cholest - convert to mg
	replace quantity=quantity/1000 if nutrient=="cholest" & uom=="g"
	replace uom="mg" if regexm(uom,("0|2|6|Mg|g")) & nutrient=="cholest"
	replace uom="mg" if nutrient=="cholest"
		
	* Sodium - convert to mg
	replace quantity=quantity/1000 if nutrient=="sodium" & uom=="g"
	replace uom="mg" if regexm(uom,("0|g|mEq|mg ")) & nutrient=="sodium"
	replace uom="mg" if nutrient=="sodium"

* Reshape dataset to 1 row per UPC
gen nut = uom+"_"+nutrient if regex(nutrient,"cals")!=1
replace nut=nutrient if regex(nutrient,"cals")==1
drop nutrientmasterid uom pct nutrient
rename quantity _
reshape wide _, i(gtin str_upc ean_13 serving* item* valuepreparedtype isorcontains) j(nut) string
	

* Drop items we don't care about - prepared stuff
drop if valueprepared!="0"
drop if isorcontains!="0" // 103,553 unique UPCs now in Gladson set
drop valueprepared isorcontains


	foreach var of varlist _* {
		replace `var'=0 if `var'<0
		replace `var'=0 if `var'==.
	}		
	foreach var of varlist _g_carb-_mg_cholest {
	replace `var'=`var'/1000 if `var'>=1000   // some things appear to be accidentally listed as mg, but were actually grams
	}
	
	replace _mg_cholest=_mg_cholest/1000 if _mg_cholest>500
	
	
	replace totservings=-1*totservings if totservings<0
			
// sat fat can never have more grams than total fat
replace _g_fat_sat=_g_fat if _g_fat_sat>_g_fat & _g_fat~=.

// g of sugar can never be more than total g of carbs
replace _g_sugar=_g_carb if _g_sugar>_g_carb & _g_carb~=.

replace _g_fiber=_g_carb-_g_sugar if _g_fiber>(_g_carb-_g_sugar) & _g_carb~=.

replace _cals=_cals_fat if _cals_fat>_cals & _cals_fat~=.

	//manually fix a few errors
	replace totservings=9 if gtin=="0077890732076"
			
			
save "$Externals/Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim1.dta", replace // temp dataset with raw nuts to use for updating stuff later	


		* Save clean copy of Gladson data on Dropbox
		use "$Externals/Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim1.dta", clear
		drop addeditem type legacyupc upc_a gtin
		drop totservings
		foreach var of varlist itemsize-servingspercontainer brand-segment {
			rename `var' glad_`var'
			}
		foreach var of varlist _* {
		
			rename `var' raw`var'
			}
		order upc str_upc ean_13 glad* raw*
		save "$Externals/Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim.dta", replace
	

/*-------------------------------------------------
3) INCORPORATE HMS WEIGHT DATA
---------------------------------------------------*/	
use "$Externals/Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim1.dta", clear

* 3a) Merge to UPC-Info on ean_13 UPC code
*sort str_upc 
rename upc upc_num
rename str_upc upc
destring upc, replace
merge 1:m upc using "$Externals/Calculations/OtherNielsen/UPC-Info.dta"
*merge 1:m upc using "$hms\products.dta" // this is dta of "products.tsv"
drop if _merge==2
drop _merge 

rename size1_units size1_units_hms
rename size1_amount size1_amount_hms

* 3b) Construct final weight vars incorporating HMS info
tab itemmeasure
replace itemmeasure="each" if regexm(itemmeasure,("ea|ae|e|eaw|es|each"))
replace itemmeasure="lb" if regexm(itemmeasure,("LB|lbs")) // =453.592 g
replace itemmeasure="fl oz" if regexm(itemmeasure,("fl.oz|fl")) // = 29.5735296875 g
replace itemmeasure="gal" if regexm(itemmeasure,("gl|ql")) // = 3785.41 g
replace itemmeasure="liter" if regexm(itemmeasure,("lt")) // = 1000 g
replace itemmeasure="oz" if regexm(itemmeasure,("OZ|oa")) // = 28.3495 g
replace itemmeasure="pint" if regexm(itemmeasure,("pt|pz")) // = 473.1764750005525 g
replace itemmeasure="quart" if regexm(itemmeasure,("qt|qts")) // = 946.35295 
tab size1_units_hms
set more off
tab itemmeasure if size1_units_hms!="OZ"
tab size1_units_hms if size1_units_hms!="OZ" & itemmeasure=="oz" 

	* Create unified weight variable (in original units, not grams yet)
	destring size1_amount_hms, replace
	gen totweightuom=size1_units_hms if size1_units_hms=="OZ"
	gen totweight=size1_amount_hms if size1_units_hms=="OZ"
	replace totweightuom="OZ" if totweightuom=="" & itemmeasure=="oz"
	replace totweight=itemsize if totweight==. & itemmeasure=="oz"
	replace totweightuom="CT" if totweightuom=="" & itemmeasure=="each" & size1_units_hms=="CT"
	replace totweight=size1_amount_hms if totweight==. & itemmeasure=="each" & size1_units_hms=="CT"
	replace totweightuom=size1_units_hms if totweightuom=="" & itemmeasure=="each"
	replace totweight=size1_amount_hms if totweight==. & itemmeasure=="each"
	replace totweightuom=size1_units_hms if totweightuom=="" & itemmeasure=="lb"
	replace totweight=size1_amount_hms if totweight==. & itemmeasure=="lb"
	replace totweightuom=size1_units_hms if totweightuom=="" & itemmeasure=="ml"
	replace totweight=size1_amount_hms if totweight==. & itemmeasure=="ml"
	replace totweightuom="CT" if totweightuom=="" & itemmeasure=="each"	
	replace totweight=itemsize if totweight==. & itemmeasure=="each"	
	replace totweightuom="GAL" if totweightuom=="" & itemmeasure=="gal"	
	replace totweight=itemsize if totweight==. & itemmeasure=="gal"	
	replace totweightuom="PO" if totweightuom=="" & itemmeasure=="lb"	
	replace totweight=itemsize if totweight==. & itemmeasure=="lb"	
	replace totweightuom="QT" if totweightuom=="" & itemmeasure=="quart"	
	replace totweight=itemsize if totweight==. & itemmeasure=="quart"	
	replace totweightuom=itemmeasure if totweightuom=="" & size1_units==""
	replace totweight=itemsize if totweight==. & size1_units==""
	replace totweightuom="PT" if itemmeasure=="pint" & totweightuom==""
	replace totweight=itemsize if itemmeasure=="pint" & totweight==.
	replace totweightuom="CT" if totweightuom=="ct"
	replace totweightuom="OZ" if totweightuom=="fl oz"
	replace totweightuom="GAL" if totweightuom=="gal"
	replace totweightuom="PINT" if totweightuom=="pint"
	replace totweightuom="ML" if totweightuom=="ml"
	replace totweightuom="G" if totweightuom=="g"
	replace totweightuom="OZ" if totweightuom=="5.29"
	replace totweightuom="PO" if totweightuom=="pk"
	replace totweightuom="QT" if totweightuom=="ql"
	tab size1_units itemmeasure if totweightuom==""
	replace totweight=. if itemmeasure=="each" & size1_units=="CT" // these will just have perUPC facts
	
*gen multi=multi_hms
*destring multi, replace
replace multi=1 if multi==.	

save "$Externals/Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim2.dta", replace


/*-------------------------------------------------
4) Deal with discrepancies 
---------------------------------------------------*/
use "$Externals/Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim2.dta", clear
set more off

rename product_module_desc product_module_descr_hms
rename upc_descr upc_descr_hms
* Issues with multi

	* Pull quantity info out of upc descr -- only some have corresponding multi
	replace upc_descr_hms=strtrim(upc_descr_hms)
	gen upclast = word(upc_descr_hms,-1)	
	foreach num in 2 3 4 5 6 8 10 12 15 16 24 {
		foreach multitype in CT P PK PACK {
			replace multi=`num' if upclast=="`num'"+"`multitype'" & multi!=`num'
			}
		}	
	replace totweight=totweight*totservings if totservings>6 & totweight<1 & totweightuom=="OZ" // NEW
	replace totservings=real(servingspercontainer) if itemmeasure=="each" & size1_units=="CT" // NEW

	
* Calculate weight per serving -- UPDATE ERRORS WITH TOTSERVINGS HERE before calculating standardized weights
gen servingweight=totweight/(totservings)		
	
	replace totservings=1 if totservings==_cals & totservings>50 & ///
	category!="BAKINGPL" & category!="JELLY" & category!="DRNKMXPL" & category!="SYRUP" & ///
	category!="TEAPL"
		
	* Calculate totweight, incorporating the corrected multi now
	gen totweight2=totweight*multi
	drop totweight
	rename (totweight2) (totweight)
	
	* Assume things are 1 serving if they don't say otherwise and size1_amount is low
	replace totservings=1 if servingspercontainer=="" & size1_amount<3 & size1_units=="OZ"
	
	* Isolated data entry errors
	replace totservings=9 if ean_13=="0030000063107"
	replace totservings=3.5 if ean_13=="0042238301568"

drop if category=="DOGFOOD"
drop if product_module_descr_hms=="KITCHEN ACCESSORY PRODUCT"
drop if product_module_descr_hms=="DOG FOOD - DRY TYPE"

save "$Externals/Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim3.dta", replace	
	

/*-------------------------------------------------
5) Calculate nuts per100g
---------------------------------------------------*/
use "$Externals/Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim3.dta", clear
drop *fat_mono *fat_poly *fat_trans


rename product_group_code product_group_code_hms
rename product_module_code product_module_code_hms


destring product_group_code_hms, replace
destring product_module_code_hms, replace



** Translate everything to grams. 

gen g_fat_per1=.
gen g_carb_per1=.
gen g_prot_per1=.
gen g_sodium_per1=.
include Code/DataPrep/OtherNielsen/GetGrams.do


* Calculate total nutrients in the whole product
foreach var of varlist _*  {
	replace `var'=0 if `var'==.
	replace `var' = `var'*-1 if `var'<0
	gen tot`var' = `var'*totservings
	}
	
foreach nut in sodium cholest {
	gen _g_`nut' = _mg_`nut' / 1000
	gen tot_g_`nut' = tot_mg_`nut' / 1000
	drop _mg_`nut' tot_mg_`nut'
	}
	
foreach var of varlist _* {
	rename `var' raw`var'
	}

* CALC NUTS PER 100g
foreach nut in fat fat_sat carb fiber prot sugar sodium cholest {
	set more off
	gen g_`nut'_per100g=.
	replace g_`nut'_per100g = (tot_g_`nut' / totweight) * (1 / 28.3495) * 100 if totweightuom=="OZ"
	replace g_`nut'_per100g = (tot_g_`nut' / totweight) * (1 / 946.35295) * 100 if totweightuom=="QT"
	replace g_`nut'_per100g = (tot_g_`nut' / totweight) * (1 / 3785.41) * 100 if totweightuom=="GAL"
	replace g_`nut'_per100g = (tot_g_`nut' / totweight) * (1 / 453.592) * 100 if totweightuom=="PO"
	replace g_`nut'_per100g = (tot_g_`nut' / totweight) * (1 / 473.1765) * 100 if totweightuom=="PT"
	replace g_`nut'_per100g = (tot_g_`nut' / totweight) * (1 / 1000) * 100 if totweightuom=="liter"
	replace g_`nut'_per100g = (tot_g_`nut' / totweight) * (1) * 100 if totweightuom=="ML"
	replace g_`nut'_per100g = (tot_g_`nut' / totweight) * (1) * 100 if totweightuom=="G"
	}	
	
foreach nut in cals cals_fat {
	set more off
	gen `nut'_per100g=.
	replace `nut'_per100g = (tot_`nut' / totweight) * (1 / 28.3495) * 100 if totweightuom=="OZ"
	replace `nut'_per100g = (tot_`nut' / totweight) * (1 / 946.35295) * 100 if totweightuom=="QT"
	replace `nut'_per100g = (tot_`nut' / totweight) * (1 / 3785.41) * 100 if totweightuom=="GAL"
	replace `nut'_per100g = (tot_`nut' / totweight) * (1 / 453.592) * 100 if totweightuom=="PO"
	replace `nut'_per100g = (tot_`nut' / totweight) * (1 / 473.1765) * 100 if totweightuom=="PT"
	replace `nut'_per100g = (tot_`nut' / totweight) * (1 / 1000) * 100 if totweightuom=="liter"
	replace `nut'_per100g = (tot_`nut' / totweight) * (1) * 100 if totweightuom=="ML"
	replace `nut'_per100g = (tot_`nut' / totweight) * (1) * 100 if totweightuom=="G"
	}		
	

* ATTEMPT TO FIX OUTLIERS AT THE HIGH END


gen dum=1 if cals_per100g>2000





set more off
*tab product_module_descr if dum==1
gsort - cals_per100g

* MODULES THAT HAVE WEIRD "MULTI" GOING ON
foreach item in cals cals_fat {
	gen `item'_per100g2=.
	}
foreach nut in fat fat_sat carb fiber prot sugar sodium cholest {
	gen g_`nut'_per100g2 =.
	}

		
foreach module in "CRACKERS - CHEESE" "CANDY-CHOCOLATE"  "CANDY-DIETETIC - CHOCOLATE" "CANDY-HARD ROLLED"  {
	foreach item in cals cals_fat {
			replace `item'_per100g2=(raw_`item'/size1_amount)* (1 / 28.3495) * 100  if itemmeasure=="each" & size1_units=="OZ" & product_module_descr=="`module'" & dum==1 & cals_per100g!=.
			replace `item'_per100g2 = raw_`item' / (itemsize/totservings) * (1 / 28.3495) * 100 if itemmeasure=="oz" & product_module_descr=="`module'" & dum==1 & cals_per100g!=.
			}
		foreach nut in fat fat_sat carb fiber prot sugar sodium cholest {
			replace g_`nut'_per100g2 = (raw_g_`nut' / size1_amount)* (1 / 28.3495) * 100 if itemmeasure=="each" & size1_units=="OZ" & product_module_descr=="`module'" & dum==1 & cals_per100g!=.
			replace g_`nut'_per100g2 = raw_g_`nut' / (itemsize/totservings) * (1 / 28.3495) * 100 if itemmeasure=="oz" & product_module_descr=="`module'" & dum==1 & cals_per100g!=.
			}
		foreach item in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
			replace `item'_per100g = `item'_per100g2 if `item'_per100g2 !=.
			}
	}
			
	drop *per100g2


* CANDY-CHOCOLATE

	foreach item in cals cals_fat {
		gen `item'_per100g2=(raw_`item'/size1_amount)* (1 / 28.3495) * 100  if itemmeasure=="each" & size1_units=="OZ" & product_module_descr=="CANDY-CHOCOLATE" & dum==1 & cals_per100g!=.
		replace `item'_per100g2 = raw_`item' / (itemsize/totservings) * (1 / 28.3495) * 100 if itemmeasure=="oz" & product_module_descr=="CANDY-CHOCOLATE" & dum==1 & cals_per100g!=.
		}
	foreach nut in fat fat_sat carb fiber prot sugar sodium cholest {
		gen g_`nut'_per100g2 = (raw_g_`nut' / size1_amount)* (1 / 28.3495) * 100 if itemmeasure=="each" & size1_units=="OZ" & product_module_descr=="CANDY-CHOCOLATE" & dum==1 & cals_per100g!=.
		replace g_`nut'_per100g2 = raw_g_`nut' / (itemsize/totservings) * (1 / 28.3495) * 100 if itemmeasure=="oz" & product_module_descr=="CANDY-CHOCOLATE" & dum==1 & cals_per100g!=.
		}
	foreach item in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
		replace `item'_per100g = `item'_per100g2 if `item'_per100g2 !=.
		}
	drop *per100g2
	
	
*CANDY-NON-CHOCOLATE

	br if dum==1 & product_module_descr=="CANDY-NON-CHOCOLATE"
	foreach item in cals cals_fat {
		gen `item'_per100g2=(raw_`item'/size1_amount)* (1 / 28.3495) * 100  if itemmeasure=="each" & size1_units=="OZ" & product_module_descr=="CANDY-NON-CHOCOLATE" & dum==1 & cals_per100g!=.
		}
	foreach nut in fat fat_sat carb fiber prot sugar sodium cholest {
		gen g_`nut'_per100g2 = (raw_g_`nut' / size1_amount)* (1 / 28.3495) * 100 if itemmeasure=="each" & size1_units=="OZ" & product_module_descr=="CANDY-NON-CHOCOLATE" & dum==1 & cals_per100g!=.
		}
	foreach item in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
		replace `item'_per100g = `item'_per100g2 if `item'_per100g2 !=.
		}
	drop *per100g2
	
	
*COOKIES

	br if dum==1 & product_module_descr=="COOKIES"
	gen totweight2=totweight*totservings if dum==1 & product_module_descr=="COOKIES"
	foreach item in cals cals_fat {
		gen `item'_per100g2=(tot_`item'/totweight2)* (1 / 28.3495) * 100  if itemmeasure=="each" & size1_units=="OZ" & product_module_descr=="COOKIES" & dum==1 & cals_per100g!=.
		}
		
	foreach nut in fat fat_sat carb fiber prot sugar sodium cholest {
		gen g_`nut'_per100g2 = (tot_g_`nut'/totweight2)* (1 / 28.3495) * 100 if itemmeasure=="each" & size1_units=="OZ" & product_module_descr=="COOKIES" & dum==1 & cals_per100g!=.
		}
	foreach item in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
		replace `item'_per100g = `item'_per100g2 if `item'_per100g2 !=.
		}
	drop *per100g2
	drop totweight2		
		
		
*CANDY-CHOCOLATE-SPECIAL

	br if dum==1 & product_module_descr=="CANDY-CHOCOLATE-SPECIAL"
	foreach item in cals cals_fat {
		gen `item'_per100g2=(raw_`item'/size1_amount)* (1 / 28.3495) * 100  if itemmeasure=="each" & size1_units=="OZ" & product_module_descr=="CANDY-CHOCOLATE-SPECIAL" & dum==1 & cals_per100g!=.
		}
	foreach nut in fat fat_sat carb fiber prot sugar sodium cholest {
		gen g_`nut'_per100g2 = (raw_g_`nut' / size1_amount)* (1 / 28.3495) * 100 if itemmeasure=="each" & size1_units=="OZ" & product_module_descr=="CANDY-CHOCOLATE-SPECIAL" & dum==1 & cals_per100g!=.
		}	
	foreach item in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
		replace `item'_per100g = `item'_per100g2 if `item'_per100g2 !=.
		}
	drop *per100g2
		
	
* BREATH SWEETENERS

	br if product_module_descr_hms=="BREATH SWEETENERS"
	foreach item in cals cals_fat {
		gen `item'_per100g2=.
		replace `item'_per100g2 = `item'_per100g / multi if product_module_descr_hms=="BREATH SWEETENERS"
		}
	foreach nut in fat fat_sat carb fiber prot sugar sodium cholest {
		gen g_`nut'_per100g2 =.
		replace g_`nut'_per100g2 = g_`nut'_per100g / multi if product_module_descr_hms=="BREATH SWEETENERS"
		}
	foreach item in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
		replace `item'_per100g = `item'_per100g2 if `item'_per100g2 !=.
		}
	drop *per100g2	
	
	
* POTTED MEAT - CANNED
	
	br if product_module_descr_hms=="POTTED MEAT - CANNED"
	foreach item in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
		replace `item'_per100g = `item'_per100g/6  if gtin =="00017000003788"
		}

* "NUTS - BAGS"

	br if product_module_descr_hms=="NUTS - BAGS"
	foreach item in cals cals_fat g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest {
			replace `item'_per100g = `item'_per100g/totservings if gtin=="00050428144282" | gtin=="00075450083316"
			}
	
* ATTEMPT TO FIX OUTLIERS AT THE LOW END, esp for the weird modules
gen dum2=1 if cals_per100g<100  // look at the surprising modules here
tab product_module_descr if dum2==1	

	*BARBECUE SAUCES
	br if dum2==1 & product_module_descr=="BARBECUE SAUCES"
	// these actually look all correct

	*CHEESE - COTTAGE
	br if dum2==1 & product_module_descr=="CHEESE - COTTAGE"
	// these actually look all correct


	*DAIRY-MILK-REFRIGERATED	
	br if dum2==1 & product_module_descr=="DAIRY-MILK-REFRIGERATED"
	// these actually look all correct


	*DAIRY - SOUR CREAM - REFRIGERATED & C..	
	br if dum2==1 & regex(product_module_descr, "DAIRY - SOUR CREAM")
	replace raw_cals=45 if gtin=="00071700260612"
	replace cals_per100g=cals_fat_per100g if gtin=="00071700260612"
	// the remaining look correct

	*ENTREES - ITALIAN - 1 FOOD - FROZEN	
	br if dum2==1 & regex(product_module_descr, "ENTREES - ITALIAN - 1 FOOD - FROZEN")
	// these actually look all correct (100g isn't very much)
	
	*NUTRITIONAL SUPPLEMENTS
	br if dum2==1 & regex(product_module_descr, "NUTRITIONAL SUPPLEMENTS")
	// these actually look all correct

	*MEXICAN SAUCE	
	br if dum2==1 & regex(product_module_descr, "MEXICAN SAUCE")
	// these actually look all correct

	* ICE CREAM - BULK	
	br if dum2==1 & product_module_descr=="ICE CREAM - BULK"
	replace raw_cals=raw_cals*10 if gtin=="00719283596574"
	replace cals_per100g=cals_per100g*10 if gtin=="00719283596574"
	// the remaining look correct

	* REMAINING DRINKS AND SHAKES
	br if dum2==1 & regex(product_module_descr, "REMAINING DRINKS & SHAKES")
	// these actually look all correct

drop dum dum2
drop upclast   

//check on total number of grams per 100 grams (shouldn't be more than 100!)
gen g_per100g=g_fat_per100g+ g_carb_per100g+ g_prot_per100g+ g_sodium_per100g+ g_cholest_per100g


// Rescalling nuts per 100g so that total grams equal 100 for the ones where there appear to be >100g per 100g
foreach nut of varlist g_fat_per100g- cals_fat_per100g {
replace `nut'=100*`nut'/g_per100g if g_per100g>100 & g_per100g~=.
}

drop g_per100g

//These are items where the nut facts are for item prepared with additional ingredients, but the weight if just for the upc. 
drop if cals_per100g>1600 & cals_per100g~=.

save "$Externals/Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim4.dta", replace // USE THIS FOR IMPUTATION


	
/*-------------------------------------------------
6) Merge this Gladson set to macronut dums to be used for imputation
---------------------------------------------------*/	
* MERGE PURCHASES TO NUT FACTS
use "$Externals\Calculations\NutritionFacts/purchasesbyupc_macronut_dums.dta", clear

destring upc_ver_uc, replace
set more off
rename (product_descr2 type_descr2 flavor_descr2) (product_descr type_descr flavor_descr)
merge m:1 ean_13 upc_ver_uc using "$Externals/Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim4.dta", force // 116257 match

	
* Tidy and save
sort ean_13 upc_ver_uc
save "$Externals\Calculations\NutritionFacts/gladson_nut_facts_for_imp_outliers_dropped.dta", replace

erase "$Externals\Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim.dta"
erase "$Externals\Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim1.dta"
erase "$Externals\Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim2.dta"
erase "$Externals\Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim3.dta"
erase "$Externals\Calculations\NutritionFacts/gladson_nut_facts_cleaned_prelim4.dta"

	
	
	
