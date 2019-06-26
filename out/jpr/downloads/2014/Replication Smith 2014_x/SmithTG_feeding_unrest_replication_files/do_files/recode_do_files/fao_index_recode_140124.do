*** prep FAO food index data

local user  "`c(username)'"
cd "/Users/`user'/Documents/Active Projects/Feeding Unrest Africa/analysis"

import delimited "data/raw_data/Food_price_indices_data_140124.csv", clear

egen time = fill(360 361)
format time %tmMon_CCYY

order time
drop date
tsset time

rename foodpriceindex FAO_food
rename meatpriceindex meat
rename dairypriceindex dairy
rename cerealspriceindex cereals
rename oilspriceindex oils
rename sugarpriceindex sugar

foreach var of varlist FAO_food meat dairy cereal oils sugar {
	gen `var'_chg = d.`var'/l.`var'
	}

lab var FAO_food "FAO Food Price Index"
lab var FAO_food_chg "Monthly % Change in FAO Food Price Index"
lab var meat_chg "Monthly % Change Meat Price Index"
lab var dairy_chg "Monthly % Change Dairy Price Index"
lab var cereals_chg "Monthly % Change Cereals Price Index"
lab var oils_chg "Monthly % Change Oils Price Index"
lab var sugar_chg "Monthly % Change Sugar Price Index"

save "data/fao_commodity_index.dta", replace
exit
