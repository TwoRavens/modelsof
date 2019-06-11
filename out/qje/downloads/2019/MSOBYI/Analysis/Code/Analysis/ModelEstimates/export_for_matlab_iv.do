/*
Creates dataset to estimate grocery and nutrient demand model
*/




use "$Externals/Calculations/Homescan/HHxGroup.dta" , clear




keep if InSample==1

rename StoreTime365 StoreTime365real
rename StoreTime30  StoreTime30real
rename Convenience Conveniencereal

/*
*get zip3
tostring zip_code, gen(zip)
replace zip="0"+zip if length(zip)<5
gen store_zip3=substr(zip,1,3)
destring store_zip3, replace
*/
rename panel_year year



drop if year<2006

//merge in intstruments
merge m:1 fips_state_code fips_county_code group year using "$Externals/Calculations\RMS/Instruments_CountyLevel.dta"
keep if _merge==3
drop _merge


rename IncomeResidQuartile inc_cat

merge m:1 group using "$Externals\Calculations\OtherNielsen\GroupNameList.dta"

/*
*gen income=exp(lnInc)
gen inc_cat=1 if NominalIncome<25000
replace inc_cat=2 if NominalIncome>=25000
replace inc_cat=3 if NominalIncome>=50000
replace inc_cat=4 if NominalIncome>=70000
*/

// Deflate prices to real dollaors


/*
saveold "$Externals/Calculations\Model/data_for_matlab_iv.dta", replace

/* Check to see is missing product groups correlated with nutrients */
egen id=group(household_code year)
fillin id group
gen missing =household_code==.
egen temp=max(inc_cat), by(id)
replace inc_cat=temp
drop temp

collapse (sum) g_* cals (mean) missing, by(group inc_cat) fast
foreach var of varlist g_* {
replace `var'=`var'/cals
}
drop g_carb // omitted category
reg missing c.g_*##i.inc_cat , cluster(group)

reg missing c.g_*##i.inc_cat if group~=501, cluster(group)


use "Calculations\Model/data_for_matlab_iv.dta", clear
*/


// for new HEI
*drop g_fat- rHealthIndex LO_dm_PricePerCal LO_dm_noCounty_PricePerCal NationalPrice g_Fruit g_Veg

// Collapse and differnce HEI nuts for estimation
*gen fruits_nonwhole=fruits_total-fruits_whole
*drop fruits_total
*replace fruits_nonwhole=0 if fruits_nonwhole<0

*gen veg_nogreen=veggies-greens_beans
*drop veggies
*replace veg_nogreen=0 if veg_nogreen<0

*gen nonsea_plant_protien=total_protein-sea_plant_prot
*drop total_protein
*replace nonsea_plant=0 if nonsea_plant<0

*gen unsat_fat=mon_unsat_fat_g+poly_unsat_fat_g
*drop mon_unsat poly_unsat
*drop satfat
*drop solid_fats_kcal


order household_code group year fips_state_code fips_county_code inc_cat lnLO_dm_noCounty_PricePerCal expend- added_sugars solid_fats fruits_total veggies total_protein StoreTime365real StoreTime30real Conveniencereal
drop department_code- NationalPrice

outsheet using "$Externals/Calculations\Model/data_for_matlab_iv.txt", replace
saveold "$Externals/Calculations\Model/data_for_matlab_iv.dta", replace

