//read in the purchases data from HMS due to RMS store purchases
*capture cd "D:\Dropbox (Diamond)/NutritionIncomeFinal/Analysis/"
use "$Externals/Calculations/Homescan/HHxGroup.dta", clear
drop cals


keep if InSample==1
rename energy cals
**Calc Mean and SD for health index
*egen HIall=total(HealthIndex), by(household_code panel_year)
*replace HIall=1000*HIall/totalcals
*sum HIall 
// mean is -2.93, sd .77



rename IncomeResidQuartile inc_cat


*gen HealthIndex_cal=HealthIndex*cals/1000
egen denom=total(cals*projection_factor), by(inc_cat group)
foreach var of varlist expend sodium_mg fruits_total- solid_fats_kcal StoreTime StoreTime365 StoreTime30{
gen `var'_percal=projection_factor*`var'/(denom)

}


collapse (sum) cals *_percal , by(inc_cat group department)



saveold "$Externals/Calculations/Model/decomp_nuts.dta", replace



//GMM ESTIMATES


//full data sample
import delimited  "$Externals/Calculations/Model/group_fe.txt", delimiter(space, collapse) clear
drop v1

rename v2 group
rename v3 fe1
rename v4 fe2
rename v5 fe3
rename v6 fe4

saveold "$Externals/Calculations/Model/groupfe_gmm.dta", replace

use "$Externals/Calculations/Homescan/Prepped-Household-Panel.dta", clear
keep projection_factor fips* 
gen county=fips_state*100+fips_county
collapse (sum) project, by(county)
save "$Externals/Calculations/Homescan/county_pops.dta", replace



import delimited  "$Externals/Calculations/Model/county_fe.txt", delimiter(space, collapse) clear
drop v1

rename v2 county
rename v3 countyfe1
rename v4 countyfe2
rename v5 countyfe3
rename v6 countyfe4



saveold "$Externals/Calculations/Model/countyfe_gmm.dta", replace

merge 1:1 county using "$Externals/Calculations/Homescan/county_pops.dta"
keep if _merge==3
drop _merge



collapse (mean) countyfe* [pw=proj]

gen id=1
saveold "$Externals/Calculations/Model/county_med_gmm.dta", replace


import delimited "$Externals/Calculations/Model/year_fe.txt", delimiter(space, collapse) clear
drop v1

rename v2 year
rename v3 year_fe1
rename v4 year_fe2
rename v5 year_fe3
rename v6 year_fe4
saveold "$Externals/Calculations/Model/year_fe.dta", replace



import delimited "$Externals/Calculations/Model/beta_all.txt", delimiter(space, collapse) clear
drop v1

gen id=[_n]
rename v2 beta1
rename v3 beta2
rename v4 beta3
rename v5 beta4

gen name=""
replace name="base" if id==1
replace name="sodium" if id==2
replace name="fruits_total" if id==3
replace name="fruits_whole" if id==4
replace name="veggies" if id==5

replace name="greens_beans" if id==6

replace name="whole_grains" if id==7
replace name="refined_grains" if id==8
replace name="dairy" if id==9
replace name="total_protein" if id==10
replace name="sea_plant_prot" if id==11
replace name="added_sugars" if id==12
replace name="solid_fats_kcal" if id==13


drop id
gen id=1
reshape wide beta*, i(id) j(name) string


saveold "$Externals/Calculations/Model/estimates_gmm.dta", replace 
