



use "$Externals/Calculations/Homescan/Trips/trips_2016.dta", clear
gen panel_year=2016
*append using "/Users/diamondr/Dropbox/NutritionIncomeFinal/Analysis/Calculations/Homescan/Trips/trips_2013.dta"
*replace panel_year=2013 if panel_year==.

merge m:1  household_code panel_year using "$Externals/Calculations/Homescan/Prepped-Household-Panel.dta" ///
, keepusing(IncomeResidQuartile)

keep if _merge==3

drop if store_code==0
rename IncomeResidQuartile inc_cat

gen trip_count=1


collapse (sum) trip_count, by(inc_cat store_code_uc)


save "$Externals/Calculations/Homescan/StoreChoicesHomeScan.dta", replace


/*
use /Users/diamondr/Dropbox/NutritionIncomeFinal/Analysis/Calculations/RMS/Product_Hierarchy.dta, clear

rename group_string product_group_descr
include /Users/diamondr/Dropbox/NutritionIncomeFinal\Analysis\Code\DataPrep\NutritionFacts\GetGroup.do

keep group product_module_code

merge 1:m product_module_code using "/Users/diamondr/Dropbox/NutritionIncomeFinal/Analysis/Calculations/RMS/MovementStore_2006.dta"
drop _merge
*/

use "$Externals/Calculations/RMS/MovementStore_2016.dta", clear
gen year=2016
/*
merge m:1 year store_code_uc using "$Externals/Calculations/RMS/Stores-Prepped.dta", keep(match ) keepusing(state_countyFIPS)
drop _merge

//merge in intstruments

merge m:1 store_zip3 group year using "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/Calculations/RMS/Instruments_zip3Level.dta", keepusing(LO_PricePerCal)
drop if _merge==2
drop _merge

//renaem zip3 instruments 
foreach var in  LO_PricePerCal {
rename `var' `var'zip
}

replace LO_PricePerCalzip=.02 if LO_PricePerCalzip>0.02 & LO_PricePerCalzip~=.


*/

joinby store_code_uc using "$Externals/Calculations/Homescan/StoreChoicesHomeScan.dta"

drop cals_per1 
rename energy_per1 cals_per1
gen wt=trip_count

egen denom=total(trip_count), by(inc_cat group)
*egen denom_iv=total(trip_count), by(inc_cat group)
*rename Fruit Fruit_per1
*rename Veg Veg_per1
*rename StoreTime StoreTime_per1
foreach nut of varlist  rlHEI_per1000Cal sodium_mg_per1 fruits_total_per1- solid_fats_kcal_per1 {
local newname = substr("`nut'",1,length("`nut'")-8)		
egen `newname'_per_cal=total(`nut'*trip_count), by(inc_cat group)
replace `newname'_per_cal=`newname'_per_cal/denom
}

egen price_per_cal=total(total_expend*trip_count) , by(inc_cat group)
replace price_per_cal=price_per_cal/denom

*egen price_idex_per_cal=total(LO_PricePerCalzip*trip_count/denom_iv), by(inc_cat group)


keep *_per_cal denom inc_cat group price_per_cal
duplicates drop


*rename denom cals
*drop if cals==0
drop rlHEI_pe_per_cal

foreach var of varlist sodium_mg_per_cal- solid_fats_kcal_per_cal{
local newname = substr("`var'",1,length("`var'")-8)
gen `newname'_per1000Cal=`var'*1000
}
gen energy_per1=10
include Code/DataPrep/NutritionFacts/GetlinearHEI.do 
drop energy_per1

drop sodium_mg_per1000Cal- solid_fats_kcal_per1000Cal denom
reshape wide sodium- rlHEI_per1000Cal, i(group) j(inc_cat)

//drop if group==0 | group==2509 | group==2004

foreach var of varlist sodium_mg_per_cal1- rlHEI_per1000Cal4 {
rename `var' supply_`var'
}

save "$Externals/Calculations/Homescan/StoreChoicesHomeScan.dta", replace

