clear all
set more off

/*-------------------------------------------------
Prepare Nielsen HMS data for merger with nutrition fact data by UPC
diamondr last modified June 2018

0) Globals
1) Collapse Homescan purchase data by upc upc_ver_uc
2) Prepare extra product info files by UPC
3) Match purchases to products.tsv
4) Construct macronut dummies, using extra product info
---------------------------------------------------*/

/*-------------------------------------------------
0) Set globals
---------------------------------------------------*/
/*
* MAIN DROBBOX FOLDER
*global MAIN "C:/Users/ccwright/Dropbox/NutritionandIncome"
global MAIN "C:/Users/diamondr/Dropbox/NutritionandIncome"
global dataout "$MAIN\Analysis\Data\NutritionFacts"

* LOCAL MACHINE
global LOCAL "C:\Users\ccwright\Desktop\RF work\NutritionandIncome_LOCAL"
global TEMP "$LOCAL\NutritionFacts\TMP"
global hms "$LOCAL\NielsenHMS\stata_datasets"

//Rebecca's paths
global LOCAL "D:\nielsen""
global TEMP "$LOCAL\TMP"
*/
global hms "F:\Darchive\nielsen\stata_datasets"


/*-------------------------------------------------
1) Collapse Homescan purchases by UPC
---------------------------------------------------*/
use "$Externals/Calculations\Homescan\Transactions/Transactions_2004.dta", clear

	* Merge on trips data to get purchase date
	*sort trip_code_uc
	*merge m:1 trip_code_uc using "$hms\trips_2004.dta"
	*keep if _merge==1 | _merge==3
	rename expend total_price_paid
	keep upc upc_ver_uc quantity total_price_paid //purchase_date	

collapse (sum) quantity total_price_paid, by(upc upc_ver_uc)


gen panel_year=2004
save "$Externals/Calculations\Homescan\purchasesbyupc.dta", replace
	
foreach num of numlist 2005/2016 { 
	use  "$Externals/Calculations\Homescan\Transactions/Transactions_`num'.dta", clear
	set more off
	display `num'
	
		* Merge on trips data to get purchase date
		*sort trip_code_uc
	*	merge m:1 trip_code_uc using "$hms\trips_`num'.dta"
	*	keep if _merge==1 | _merge==3
	rename expend total_price_paid
		keep upc upc_ver_uc quantity total_price_paid // purchase_date	

	collapse (sum) quantity total_price_paid, by(upc upc_ver_uc)

	gen panel_year=`num'

	append using "$Externals/Calculations\Homescan\purchasesbyupc.dta"
	save "$Externals/Calculations\Homescan\purchasesbyupc.dta", replace
	}
		
use "$Externals/Calculations\Homescan\purchasesbyupc.dta", clear
collapse (sum) quantity total_price_paid (min) min_year=panel_year (max) max_year=panel_year, by (upc upc_ver_uc)

save "$Externals/Calculations\Homescan\purchasesbyupc.dta", replace // 1,740,020 UPCs purchased (this is more than are in UPC-info?)



/*-------------------------------------------------
2) Prepare extra product info files by UPC
---------------------------------------------------*/
use "$hms\products_extra_2004.dta", clear
foreach num of numlist 2005/2016 {
	append using "$hms\products_extra_`num'.dta"
	set more off
	}
*sort upc upc_ver_uc panel_year

* Drop vars presumably unrelated to nutrition
drop common* strength* scent* dosage* gender* target* use* container* organic* usda* size2* form_*

*foreach var of varlist *code {
*	replace `var'="" if `var'=="0"
*	}
drop *code
foreach var of varlist flavor_descr-variety_descr {
	gsort upc upc_ver_uc -`var'
	bysort upc upc_ver_uc: carryforward `var', gen(`var'2)
	}
keep upc upc_ver_uc *2	
*duplicates drop // all dups are mainly just misspellings and other things that don't appear to affect nutrition
duplicates drop upc upc_ver_uc, force
save "$Externals/Calculations\NutritionFacts/upcinfo_extraattributes_only.dta", replace



/*-------------------------------------------------
3) Match purchases to products.tsv
---------------------------------------------------*/
use "$Externals/Calculations\Homescan\purchasesbyupc.dta", clear
set more off
*rename upc str_upc
*sort str_upc upc_ver_uc
*tostring upc_ver_uc, replace

destring upc, replace
merge 1:1 upc upc_ver_uc using "$Externals\Calculations\OtherNielsen/UPC-Info.dta"

tostring upc, replace format(%17.0g)
forvalues i=1/10 {
replace upc="0"+upc if length(upc)<12
}
tostring upc_ver_uc, replace
*merge 1:1 upc upc_ver_uc using "$hms\products.dta" // all 1,740,020 purchased UPCs match
*tab product_module_descr_hms if _merge==2 // UPCs never purchased

* Drop irrelevant (non-food or never purcahsed) UPCs
*drop if _merge==2
*drop if _merge==3 & department_descr_hms=="HEALTH & BEAUTY CARE"
drop if department_descr=="GENERAL MERCHANDISE"
drop if department_descr=="NON-FOOD GROCERY"
drop if product_group_descr=="PET FOOD"
drop if regex(product_module_descr,"UNCLASSIFIED") // these are all nonfood items - checked manually
*destring product_module_code, replace
drop if department_code==99 | (product_module_code>=445&product_module_code<=468) ///
		| product_group_code==.
drop if department_code==0 & product_module_descr~="COMPLETE NUTRITIONAL PRODUCTS" & product_module_descr~="DIETING AIDS-COMPLETE NUTRITIONAL" ///
& product_module_descr~="NUTRITIONAL SUPPLEMENTS" & product_module_descr~="PROTEIN SUPPLEMENTS"
		
drop _merge // 1,134,550 UPCs purchased, incl some in health/beauty that aren't food


/*-------------------------------------------------
3) Construct macronut dummies
---------------------------------------------------*/
*rename str_upc upc
*sort upc upc_ver_uc
*tostring upc_ver_uc, replace
merge 1:1 upc upc_ver_uc using "$Externals/Calculations\NutritionFacts/upcinfo_extraattributes_only.dta" // 479,566 purchased UPCs don't have extra product info	
drop if _merge==2
drop _merge
*drop *code
	
******** CONSTRUCT MACRONUT DUMMIES
foreach var of varlist formula_descr2 style_descr2 salt_content_descr2 {
	replace	`var'=subinstr(`var'," ","",.)
	replace	`var'=subinstr(`var',"-","",.)
	}		
gen type_descr3=subinstr(type_descr," ","",.)
replace type_descr3=subinstr(type_descr3,"-","",.)

	*FAT
	gen dumnofat=.		
	gen dumlowfat=.
	gen dumredufat=.
	gen dumlessfatother=.

	foreach var of varlist type_descr3 formula_descr2 style_descr2 salt_content_descr2 {
		replace dumnofat=1 if regexm(`var', "(NOFAT|FATFREE|NONFAT|ZEROFAT)") 
		replace dumlowfat=1 if regexm(`var', "(LOWFAT|LWFAT)") & dumnofat!=1
		replace dumredufat=1 if regexm(`var', "(REDUCEDFAT|RDFAT|REDFAT)") & dumnofat!=1 & dumlowfat!=1
		replace dumlessfatother=1 if regexm(`var', "(LESSFAT|LITEFAT|LIGHTFAT)") & dumnofat!=1 & dumlowfat!=1 & dumredufat!=1
		}

	* SALT
	gen dumnosalt=.		
	gen dumlowsalt=.
	gen dumredusalt=.
	gen dumlesssaltother=.	
	
	foreach var of varlist type_descr3 formula_descr2 style_descr2 salt_content_descr2 {
		replace dumnosalt=1 if regexm(`var', "(NOSALT|NOSODIUM|SODIUMFREE|SALTFREE)") 
		replace dumlowsalt=1 if regexm(`var', "(LOWSALT|LOWSODIUM)") & dumnosalt!=1
		replace dumredusalt=1 if regexm(`var', "(REDUCEDSALT|REDUCEDSODIUM)") & dumnosalt!=1 & dumlowsalt!=1
		replace dumlesssaltother=1 if regexm(`var', "(HALFSALT|HALFTHESALT|LESSSALT|LESSSODIUM|LIGHTSALT|LITESALT|LOWERSODIUM|LOWERINSODIUM)") & dumnosalt!=1 & dumlowsalt!=1 & dumredusalt!=1
		}
		
	* SUGAR
	gen dumnosugar=.		
	gen dumlowsugar=.
	gen dumredusugar=.
	gen dumlesssugarother=.		
		
	foreach var of varlist type_descr3 formula_descr2 style_descr2 salt_content_descr2 {
		replace dumnosugar=1 if regexm(`var', "(SUGARFREE|NOSUGAR|ZEROSUGAR)") 
		replace dumlowsugar=1 if regexm(`var', "(LOWSUGAR|LOWERSUGAR)") & dumnosugar!=1
		replace dumredusugar=1 if regexm(`var', "(REDUCEDSUGAR)") & dumnosugar!=1 & dumlowsugar!=1
		replace dumlesssugarother=1 if regexm(`var', "(NOSUGARADDED|LESSSUGAR)") & dumnosugar!=1 & dumlowsugar!=1 & dumredusugar!=1
		}	
		
foreach var of varlist dum* {
	replace `var'=0 if `var'==. & upc_ver_uc!="." & upc_ver_uc!=""
	}
	
	* Calculate check digit
	foreach num of numlist 1/12 {
		gen digit_`num' = substr(upc,`num',1)
		destring digit_`num', replace
		}
	foreach num of numlist 1 3 5 7 9 11 {
		replace digit_`num' = digit_`num'*3
		}
	egen digit_total = rowtotal (digit*)
	gen digit_mod_10 = mod(digit_total, 10)
	gen check_digit=.
	replace check_digit = 0 if digit_mod_10==0
	replace check_digit = (10 - digit_mod_10) if digit_mod_10!=0
	tostring check_digit, replace
	gen ean_13=upc+check_digit
	drop digit_* check_digit
	
sort ean_13 upc_ver_uc
order ean_13 upc_ver_uc

foreach item in "BABY NEEDS" "COSMETICS" "COUGH AND COLD REMEDIES" "DEODORANT" ///
	"ETHNIC HABA" "FEMININE HYGIENE" "FIRST AID" "FRAGRANCES - WOMEN" "GROOMING AIDS" ///
	"HAIR CARE" "MEDICATIONS/REMEDIES/HEALTH AIDS" "MEN'S TOILETRIES" "ORAL HYGIENE" ///
	"SANITARY PROTECTION" "SHAVING NEEDS" "SKIN CARE PREPARATIONS" {
	drop if department_des=="HEALTH & BEAUTY CARE" & product_group_descr=="`item'"
	} // only keeping vitamins & diet aids in this cat

	
	//This is for products only in RMS
replace quantity=0 if quantity==.
replace total_price=0 if total_price==.


//Add MilkFat Dummies
include Code/DataPrep/NutritionFacts/GetMilkFat.do
drop LowFatMilk NonFatMilk
replace MilkFatPct=0 if MilkFatPct==.


save "$Externals\Calculations\NutritionFacts/purchasesbyupc_macronut_dums.dta", replace	// 1395848

erase "$Externals/Calculations\Homescan\purchasesbyupc.dta"
erase "$Externals/Calculations\NutritionFacts/upcinfo_extraattributes_only.dta"
