



use "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/Calculations/Homescan/Trips/trips_2012.dta", clear
gen panel_year=2012
*append using "/Users/diamondr/Dropbox/NutritionIncomeFinal/Analysis/Calculations/Homescan/Trips/trips_2013.dta"
*replace panel_year=2013 if panel_year==.

merge m:1  household_code panel_year using "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/Calculations/Homescan/Prepped-Household-Panel.dta" ///
, keepusing(NominalIncome)

keep if _merge==3

drop if store_code==0
drop if NominalIncome==.
/*
gen inc_cat=1 if NominalIncome<=25000
replace inc_cat=2 if NominalIncome>25000
replace inc_cat=3 if NominalIncome>=50000
replace inc_cat=4 if NominalIncome>=75000
*/
gen trip_count=1


collapse (sum) trip_count, by(NominalIncome store_code_uc)


save "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/Calculations/Homescan/PriceByTrip.dta", replace


/*
use /Users/diamondr/Dropbox/NutritionIncomeFinal/Analysis/Calculations/RMS/Product_Hierarchy.dta, clear

rename group_string product_group_descr
include /Users/diamondr/Dropbox/NutritionIncomeFinal\Analysis\Code\DataPrep\NutritionFacts\GetGroup.do

keep group product_module_code

merge 1:m product_module_code using "/Users/diamondr/Dropbox/NutritionIncomeFinal/Analysis/Calculations/RMS/MovementStore_2006.dta"
drop _merge
*/

use "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/Calculations/RMS/MovementStore_2012.dta", clear
gen year=2012
merge m:1 year store_code_uc using "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/Calculations/RMS/Stores-Prepped.dta", keep(match master) keepusing(zip3)
rename zip3 store_zip3
keep if _merge==3 
drop _merge

//merge in intstruments
/*
merge m:1 store_zip3 group year using "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/Calculations/RMS/Instruments_zip3Level.dta", keepusing(LO_PricePerCal)
drop if _merge==2
drop _merge

//renaem zip3 instruments 
foreach var in  LO_PricePerCal {
rename `var' `var'zip
}

replace LO_PricePerCalzip=.02 if LO_PricePerCalzip>0.02 & LO_PricePerCalzip~=.
*/



joinby store_code_uc using "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/Calculations/Homescan/PriceByTrip.dta"


gen wt=trip_count

egen denom=total(cals_per1*trip_count), by(NominalInc group)
egen denom_iv=total(trip_count), by(NominalInc group)
rename Fruit Fruit_per1
rename Veg Veg_per1
rename StoreTime StoreTime_per1
foreach nut in  g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest HealthIndex Fruit Veg StoreTime {
egen `nut'_per_cal=total(`nut'_per1*trip_count), by(NominalInc group)
replace `nut'_per_cal=`nut'_per_cal/denom
}

egen price_per_cal=total(total_expend*trip_count) , by(NominalInc group)
replace price_per_cal=price_per_cal/denom

*egen price_idex_per_cal=total(LO_PricePerCalzip*trip_count/denom_iv), by(inc_cat group)


keep *_per_cal denom NominalInc group price_per_cal
duplicates drop


rename denom cals
drop if cals==0
*reshape wide price_per_cal-price_idex_per_cal, i(group) j(NominalInc)

//drop if group==0 | group==2509 | group==2004



save "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/Calculations/Homescan/PriceByTrip.dta", replace

