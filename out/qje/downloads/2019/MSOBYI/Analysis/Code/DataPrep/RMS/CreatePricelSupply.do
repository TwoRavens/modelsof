

use "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/Calculations/RMS/MovementStore_2012.dta", clear
gen year=2012
merge m:1 year store_code_uc using "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis\Calculations\RMS\RMS-Prepped.dta", keep(match master) keepusing(ZipMed)
keep if _merge==3 
drop _merge
*drop C_Conv C_Drug C_Chain C_Grocery C_NonChain C_Super
*reshape long C_, i(store_code group) j(storetype) string
*keep if C_==1

collapse (sum) cals_per1 HealthIndex total_expend,   by(ZipMed group )

gen price_per_cal=total_expend/cals
replace HealthIndex=HealthIndex/cals

keep if price~=.

su Health if group~=4001, d

gen cat=Health>-0.00287
replace cat=2 if group==4001

binscatter price ZipMed , by(cat)
/*
egen price_per_cal=total(price), by(ZipMed group)
egen denom=total(cals_per1), by(ZipMed group)

replace price_per_cal=price_per_cal/denom

bys group: reg price_per_cal ZipMed

scatter price_per_cal ZipMed, by(group)

egen denom=total(cals_per1*trip_count), by(inc_cat group)
egen denom_iv=total(trip_count), by(inc_cat group)
rename Fruit Fruit_per1
rename Veg Veg_per1
rename StoreTime StoreTime_per1
foreach nut in  g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest HealthIndex Fruit Veg StoreTime {
egen `nut'_per_cal=total(`nut'_per1*trip_count), by(inc_cat group)
replace `nut'_per_cal=`nut'_per_cal/denom
}

egen price_per_cal=total(total_expend*trip_count) , by(inc_cat group)
replace price_per_cal=price_per_cal/denom

egen price_idex_per_cal=total(LO_PricePerCalzip*trip_count/denom_iv), by(inc_cat group)


keep *_per_cal denom inc_cat group price_per_cal
duplicates drop


rename denom cals
drop if cals==0
reshape wide price_per_cal-price_idex_per_cal, i(group) j(inc_cat)

//drop if group==0 | group==2509 | group==2004

foreach var of varlist price_per_cal1- price_idex_per_cal4 {
rename `var' supply_`var'
}

save "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/Calculations/Homescan/StoreChoicesHomeScan.dta", replace

