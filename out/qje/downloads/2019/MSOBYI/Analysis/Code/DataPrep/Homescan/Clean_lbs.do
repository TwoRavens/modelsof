/* Clean_lbs.do */
* From prepare_analyze_magnetdata_nut_facts.do
* Katie wrote this code; it addresses what appear to be implausible weights in the 2004-2006 magnet data.

** Merge in the size1 codes
	merge m:1 product_module_code size1 using $Externals/Calculations/Homescan/Transactions/product_size1_codes.dta, nogen keep(match master)
	gen lbs=real(substr(description,1,6))
	replace lbs = size1 if lbs==.
	replace lbs=lbs/100
	drop description size1

** Get module descriptions
merge m:1 product_module using $Externals/Data/NutritionFacts/product_module_codes.dta, keep(match master) nogen // This is from product_module_codes_kw and can be re-created from USDA Random Weight Purchase Data Specifications yyyy.xls.

** Get type descriptions
merge m:1 product_module_code type using $Externals/Data/NutritionFacts/product_type_codes.dta, keep(match master) nogen keepusing(Description) // This is from Katie's file and can be re-created from USDA Random Weight Purchase Data Specifications yyyy.xls.
rename Description type_descr

* Standardize module names 
gen module=module_descr
replace module=subinstr(module, "RANDOM WEIGHT", "RW",.)
replace module=subinstr(module, "RANDOM WGHT", "RW",.)
replace module=subinstr(module, "LUNCHEON MEAT ", "LNCHN ",.)
replace module=subinstr(module, "RW OTHER-LUNCHEON MEATS", "RW LNCHN-OTH",.)
replace module=subinstr(module, "RW OTH SWEET BAKED GOODS", "RW BAKED-OTH",.)
replace module=subinstr(module, "RW SWEET BAKED GOODS", "RW BAKED",.)
replace module=subinstr(module, "PREPARED", "PREP",.)
replace module=subinstr(module, "NUTS AND SEEDS", "NUTS/SEEDS",.)
replace module=subinstr(module, "OTHER", "OTH",.)
replace module=subinstr(module, " AND HOT DOGS", "",.)
replace module=subinstr(module, "-LUNCHEON MEATS", "",.)

* Group higher level food cats
gen cat="bread" if module=="RW BAGELS" | module=="RW BREADS" | module=="RW ROLLS"
replace cat="sweets" if module=="RW BAKED" | module=="RW CAKES" | module=="RW CANDY" | module=="RW COOKIES" |  ///
	module=="RW OTH SWEET BAKED GOODS" | module=="RW PIES"
replace cat="meatred" if module=="RW BEEF" | module=="RW RIBS"
replace cat="meatbird" if module=="RW CHICKEN" | module=="RW LNCHN CHICKEN" | module=="RW LNCHN TURKEY" | ///
	module=="RW OTH POULTRY" | module=="RW TURKEY"
replace cat="meatpork" if module=="RW HAM" | module=="RW LNCHN BOLOGNA" | module=="RW LNCHN HAM" | ///
	module=="RW LNCHN SALAMI" | module=="RW OTH PORK" | module=="RW PORK" | module=="RW SAUSAGES " | module=="RW SAUSAGES"	
replace cat="meatsea" if module=="RW FISH" | module=="RW SHELLFISH"
replace cat="meatoth" if module=="RW COLD CUTS" | module=="RW LAMB" | module=="RW LNCHN-OTH" | module=="RW VEAL"
replace cat="cheese" if module=="RW CHEESE"
replace cat="misc" if module=="RW COFFEE" | module=="RW HERBS"
replace cat="produce" if module=="RW FRUIT" | module=="RW VEGETABLES"
replace cat="prepared" if module=="RW PREP FOODS"
replace cat="nuts" if module=="RW NUTS/SEEDS"

* Figure out how to deal with weight for different categories -- look at 1 cat at a time
	
	*bread
	replace lbs=.2 if module_descr=="RANDOM WGHT BAGELS" & lbs==1 &  quantity>=4
	replace lbs=.1 if module_descr=="RANDOM WEIGHT ROLLS" & lbs==1 & quantity>=4
	replace lbs=.1 if module_descr=="RANDOM WGHT ROLLS" & lbs==1 & quantity>=4
	replace quantity=1 if module_descr=="RANDOM WEIGHT BREADS" & lbs==1 & quantity>=4
	replace quantity=1 if module_descr=="RANDOM WGHT BREADS" & lbs==1 & quantity>=4

    *cheese -- everything looks reasonable
	*meatbird -- everything looks reasonable
	*meatoth -- everything looks reasonable
	*meatpork -- everything looks reasonable
	*meatred -- everything looks reasonable
    *meatsea -- everything looks reasonable
    *misc -- everything looks reasonable
    *nuts -- reasonable for the most part
	
	*prepared
	replace lbs=.08 if cat=="prepared" & lbs==1 & type_descr=="CHICKEN FINGERS-NUGGETS" & quantity>=4
	replace lbs=.22 if cat=="prepared" & lbs==1 & type_descr=="CHICKEN SANDWICH" & quantity>=4
	replace lbs=.1 if cat=="prepared" & lbs==1 & type_descr=="CHICKEN-FRIED" & quantity>=4
	replace lbs=.22 if cat=="prepared" & lbs==1 & type_descr=="HAMBURGER-CHEESEBURGER" & quantity>=4
	replace lbs=.22 if cat=="prepared" & lbs==1 & type_descr=="PIZZA" & quantity>=4
	replace lbs=.15 if cat=="prepared" & lbs==1 & type_descr=="TACO-OTHER MEXICAN ITEM" & quantity>=4
	replace lbs=.3 if cat=="prepared" & lbs==1 & type_descr=="PASTA-HOT" & quantity>=4
	replace lbs=.22 if cat=="prepared" & lbs==1 & type_descr=="FISH-SEAFOOD-FISH SANDWICH" & quantity>=4
	replace lbs=.22 if cat=="prepared" & lbs==1 & type_descr=="BREAKFAST ITEM" & quantity>=4
	replace lbs=.3 if cat=="prepared" & lbs==1 & type_descr=="COMBO-VALUE MEAL" & quantity>=4
	replace lbs=.3 if cat=="prepared" & lbs==1 & type_descr=="OTHER CHICKEN DISH" & quantity>=4
	replace lbs=.22 if cat=="prepared" & lbs==1 & type_descr=="OTHER SANDWICHES-HOT" & quantity>=4
	replace lbs=.22 if cat=="prepared" & lbs==1 & type_descr=="OTHER SANDWICHES-COLD" & quantity>=4
	replace lbs=.17 if cat=="prepared" & lbs==1 & type_descr=="HOT DOG-FRANKFURTER-SAUSAGE" & quantity>=4
	replace lbs=.3 if cat=="prepared" & lbs==1 & type_descr=="HORS DOEUVRES"  & quantity>=4
	
	*produce -- reasonable for the most part

	
	*sweets 
	replace lbs=.06 if cat=="sweets" & lbs==1 & regexm(type_descr, "COOKIES") & quantity>=4
	replace lbs=.15 if cat=="sweets" & lbs==1 & regexm(type_descr, "CRULLER") & quantity>=4	
	replace lbs=.25 if cat=="sweets" & lbs==1 & regexm(type_descr, "MUFFIN") & quantity>=4	
	replace lbs=.15 if cat=="sweets" & lbs==1 & regexm(type_descr, "DANISH") & quantity>=4	
	replace lbs=.15 if cat=="sweets" & lbs==1 & regexm(type_descr, "OTHER SWEET BAKED") & quantity>=4	
	replace lbs=.15 if cat=="sweets" & lbs==1 & regexm(type_descr, "CINNAMON BUN") & quantity>=4	
    replace lbs=.15 if cat=="sweets" & lbs==1 & regexm(type_descr, "CUPCAKE") & quantity>=4
	replace lbs=.06 if cat=="sweets" & lbs==1 & regexm(type_descr, "CHOCOLATE CHIP") & quantity>=4
	replace lbs=.06 if cat=="sweets" & lbs==1 & regexm(type_descr, "OATMEAL RAISIN") & quantity>=4
	replace lbs=.06 if cat=="sweets" & lbs==1 & type_descr=="SUGAR" & quantity>=4
	replace lbs=.06 if cat=="sweets" & lbs==1 & type_descr=="ASSORTED" & quantity>=4
	replace lbs=.15 if cat=="sweets" & lbs==1 & type_descr=="PASTRIES" & quantity>=4
	replace lbs=.12 if cat=="sweets" & lbs==1 & type_descr=="BROWNIE" & quantity>=4
	replace lbs=.06 if cat=="sweets" & lbs==1 & type_descr=="PEANUT BUTTER" & quantity>=4
