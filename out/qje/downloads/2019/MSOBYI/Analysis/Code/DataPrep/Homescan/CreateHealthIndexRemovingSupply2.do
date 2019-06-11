set more off




*Create average supply of each group 
use "$Externals/Calculations/RMS/MovementStore_2016.dta", clear

collapse (mean) sodium_mg_per1Cal- solid_fats_kcal_per1Cal total_expendCal (rawsum) energy_per1 [pw=energy_per1], by(group)






save  "$Externals/Calculations/RMS/GroupSupply_2016.dta", replace

*Reshape nutrient preferences
use  "$Externals/Calculations/Model/estimates_gmm.dta", clear
reshape long beta1 beta2 beta3 beta4, i(id) j(nut) string
reshape long beta, i(nut) j(inc_cat)
reshape wide beta, i(inc_cat) j(nut) string
save "$Externals/Calculations/Model/estimates_long_gmm.dta", replace



use "$Externals\Calculations\Homescan\HHxGroup.dta" , clear


* Create Averge Purchases for each group
collapse (sum) expend- solid_fats_kcal [aw=projection_factor], by(group)

foreach var of varlist sodium_mg- solid_fats_kcal {
replace `var'=`var'/energy

}
drop if energy==0
save "$Externals\Calculations\Homescan/GroupSupply.dta", replace


use "$Externals\Calculations\Homescan\HHxGroup.dta" , clear

gen lncals=ln(cals)

foreach var of varlist expend sodium_mg- solid_fats_kcal {
replace `var'=`var'/energy
egen temp=pctile(`var'), p(99) 
replace `var'=temp if `var'>temp & `var'~=.
drop temp
rename `var' true_`var'
}
rename energy true_cals

merge m:1 group using "$Externals/Calculations/Homescan/GroupSupply.dta"
drop _merge

rename IncomeResidQuartile inc_cat
merge m:1 inc_cat using  "$Externals/Calculations/Model/estimates_long_gmm.dta"

/*
foreach nut in cals g_fat g_fat_sat g_carb g_fiber g_prot g_sugar g_sodium g_cholest HealthIndex {
rename `nut'_per1 `nut'
}
rename Fruit g_Fruit
rename Veg g_Veg
*/

replace betasodium=betasodium/1000
rename betasodium betasodium_mg

gen nut_ind_true=betabase
gen nut_ind_supply=betabase
foreach nut of varlist sodium_mg fruits_total- solid_fats_kcal {
replace nut_ind_true=nut_ind_true+true_`nut'*beta`nut'
replace nut_ind_supply=nut_ind_supply+`nut'*beta`nut'
}

replace expend=expend/energy
replace nut_ind_true=true_expend-nut_ind_true
replace nut_ind_supply=expend-nut_ind_supply
replace nut_ind_true=0.00001 if nut_ind_true<0.00001

gen lncals_supply=lncals+ln(nut_ind_true)-ln(nut_ind_supply)

gen cals_supply=exp(lncals_supply)
egen denom=total(cals_supply), by(household_code panel_year)
egen denom_true=total(true_cals), by(household_code panel_year)



gen true_rlHEI_per1000Cal = 5*1000*true_fruits_total/0.8 + ///
		5*1000*true_fruits_whole/0.4 + 5*1000*true_veggies/1.1 + 5*1000*true_greens_beans/0.2 + ///
		10*1000*true_whole_grains/1.5 + 10*1000*true_dairy/1.3 + 5*1000*true_total_protein/2.5 + ///
		5*1000*true_sea_plant_prot/0.8 ///
		+ 10*(4.3-1000*true_refined_grains)/(4.3-1.8) ///
		+ 10*(2-true_sodium_mg)/(2-1.1) ///
		+ 10*(0.26-true_added_sugars*4)/(0.26-0.065) /// added sugars is share of calories, so take added sugars in grams and multiply by 4 to get to calories
		+ 10*(0.16-true_solid_fats_kcal)/(0.16-0.08) 

gen supply_rlHEI_per1000Cal = 5*1000*fruits_total/0.8 + ///
		5*1000*fruits_whole/0.4 + 5*1000*veggies/1.1 + 5*1000*greens_beans/0.2 + ///
		10*1000*whole_grains/1.5 + 10*1000*dairy/1.3 + 5*1000*total_protein/2.5 + ///
		5*1000*sea_plant_prot/0.8 ///
		+ 10*(4.3-1000*refined_grains)/(4.3-1.8) ///
		+ 10*(2-sodium_mg)/(2-1.1) ///
		+ 10*(0.26-added_sugars*4)/(0.26-0.065) /// added sugars is share of calories, so take added sugars in grams and multiply by 4 to get to calories
		+ 10*(0.16-solid_fats_kcal)/(0.16-0.08) 		
		
		
gen HealthIndex_supply=supply_rlHEI_per1000Cal*cals_supply/denom
gen HealthIndex_true=true_rlHEI_per1000Cal*true_cals/denom_true
collapse (sum) HealthIndex_supply HealthIndex_true, by(household_code panel_year)

saveold "$Externals/Calculations\Homescan\HealthIndexNoSupply.dta", replace


