/* estimate_decom_gmm_iv.do */
* This file creates the decomposition figure

set more off



use "$Externals/Calculations/Model/decomp_nuts.dta", clear
drop StoreTime30 StoreTime_percal


rename expend_percal price
replace price=price

foreach var of varlist *percal {
local newname = substr("`var'",1,length("`var'")-7)
gen `newname'_per1000Cal = 1000 * `var'
drop `var'
}
gen energy_per1=10
include Code/DataPrep/NutritionFacts/GetlinearHEI.do 




rename department department
reshape wide cals- StoreTime365 rlHEI_per1000Cal, i(group) j(inc_cat)

merge m:1 group using "$Externals/Calculations/Homescan/StoreChoicesHomeScan.dta"
keep if _merge==3
drop _merge


/*
foreach var of varlist     supply_Veg* supply_Fruit*  {
local nn=length("`var'")-8
di "`nn'"
local var2=substr("`var'",1,7)+"g_"+substr("`var'",8,`nn') +substr("`var'",-1,.)
disp "rename `var' `var2'"
rename `var' `var2'
}
*/




merge m:1 group using "$Externals/Calculations/Model/groupfe_gmm.dta"
keep if _merge==3
drop _merge

gen id=1
merge m:1 id using "$Externals/Calculations/Model/estimates_gmm.dta"
drop _merge

merge m:1 id using  "$Externals/Calculations/Model/county_med_gmm.dta"
drop _merge

gen year=2016
merge m:1 year using  "$Externals/Calculations/Model/year_fe.dta"
keep if _merge ==3 
drop _merge


forvalues i=1/4{
replace fe`i'=fe`i'+countyfe`i'+year_fe`i'
}

//Rescale beta on sodium
forvalues i=1/4 {
replace beta`i'sodium=beta`i'sodium/1000
rename beta`i'sodium beta`i'sodium_mg
}
*First calculate health index of observed purchases

*nut value
forvalues i=1/4 {
gen nut_value`i'=beta`i'base
foreach nut in fruits_total fruits_whole greens_beans refined_grains sea_plant_prot sodium_mg solid_fats_kcal total_protein veggies whole_grains {
replace nut_value`i'=nut_value`i'+(`nut'_per1000Cal`i'*beta`i'`nut'/1000)
}
}

forvalues i=1/4 {
gen cals_base`i'=exp(fe`i')/(price`i'-nut_value`i')
egen total_cals_base`i'=total(cals_base`i')
egen HealthIndex_base`i'=total(rlHEI_per1000Cal`i'*cals_base`i'/total_cals_base`i')
*replace HealthIndex_base`i'= (HealthIndex_base`i'+2.93)/.78
}


sum HealthIndex_base*


*Create average bundle

foreach nut in fruits_total fruits_whole greens_beans refined_grains sea_plant_prot sodium_mg solid_fats_kcal total_protein veggies whole_grains {
gen mean_`nut'=0
forvalues i=4/4 {
replace mean_`nut'=mean_`nut'+(supply_`nut'_per_cal`i')
}
egen mean_all_`nut'=mean(mean_`nut')
replace mean_`nut'=mean_all_`nut'
drop mean_all_`nut'
}



**Now use average supply conditions


*nut value
forvalues i=1/4 {
gen nut_value_sup`i'=beta`i'base
foreach nut in fruits_total fruits_whole greens_beans refined_grains sea_plant_prot sodium_mg solid_fats_kcal total_protein veggies whole_grains  {
replace nut_value_sup`i'=nut_value_sup`i'+(supply_`nut'_per_cal`i'*beta`i'`nut')
}
}

forvalues i=1/4 {
gen denom`i'=(supply_price_per_cal`i'-nut_value_sup`i')
gen cals_sup`i'=exp(fe`i')/(supply_price_per_cal`i'-nut_value_sup`i')
egen total_cals_sup`i'=total(cals_sup`i')
egen HealthIndex_sup`i'=total(supply_rlHEI_per1000Cal`i'*cals_sup`i'/total_cals_sup`i')
*replace HealthIndex_sup`i'= (HealthIndex_sup`i'+2.93)/.78
}
su denom*

sum HealthIndex*
gen temp=HealthIndex_sup4
egen max=max(temp)
drop temp
gen temp=HealthIndex_sup1
egen min=max(temp)
drop temp

forvalues i=1/4 {
replace HealthIndex_sup`i'=(HealthIndex_sup`i'-min)/(max-min)
}
sum HealthIndex_sup*



*nut value of average bundle

forvalues i=1/4 {
gen nut_value_avg`i'=beta`i'base
foreach nut in fruits_total fruits_whole greens_beans refined_grains sea_plant_prot sodium_mg solid_fats_kcal total_protein veggies whole_grains {
replace nut_value_avg`i'=nut_value_avg`i'+(mean_`nut'*beta`i'`nut')
}
}




*Now use the prices of the Q4 area
forvalues i=1/4 {
gen cals_sup_p`i'=exp(fe`i')/(supply_price_per_cal4-nut_value_sup`i')
egen total_cals_sup_p`i'=total(cals_sup_p`i')
egen HealthIndex_p_adjust`i'=total(supply_rlHEI_per1000Cal`i'*cals_sup_p`i'/total_cals_sup_p`i')
*replace HealthIndex_p_adjust`i'= (HealthIndex_p_adjust`i'+2.93)/.78
}


forvalues i=1/4 {
replace HealthIndex_p_adjust`i'=(HealthIndex_p_adjust`i'-min)/(max-min)
}

sum HealthIndex_base*
sum HealthIndex_sup*
sum  HealthIndex_p_adjust*

	

	
	
	
	
	
	
*Now use the prices and nutrients of the Q4 area
*nut value


forvalues i=1/4 {
gen nut_value_4_`i'=beta`i'base
foreach nut in fruits_total fruits_whole greens_beans refined_grains sea_plant_prot sodium_mg solid_fats_kcal total_protein veggies whole_grains {
replace nut_value_4_`i'=nut_value_4_`i'+((supply_`nut'_per_cal4)*beta`i'`nut')
}
}


forvalues i=1/4 {
gen cals_p_nut_adjust`i'=exp(fe`i')/(supply_price_per_cal4-nut_value_4_`i')
egen total_cals_p_nut_adjust`i'=total(cals_p_nut_adjust`i')
egen HealthIndex_p_nut_adjust`i'=total(supply_rlHEI_per1000Cal4*cals_p_nut_adjust`i'/total_cals_p_nut_adjust`i')
*replace HealthIndex_p_nut_adjust`i'= (HealthIndex_p_nut_adjust`i'+2.93)/.78
}

forvalues i=1/4 {
replace HealthIndex_p_nut_adjust`i'=(HealthIndex_p_nut_adjust`i'-min)/(max-min)
}

sum HealthIndex_base*
sum HealthIndex_sup*
sum  HealthIndex_p_adjust*
sum HealthIndex_p_nut_adjust*


*Now use the price preferencesof Q4 people and Q4 supply




gen ratio1=1
gen ratio2=1
gen ratio3=1
gen ratio4=1
forvalues i=1/4 {
gen nut_valuepp_4_`i'=beta4base
foreach nut in fruits_total fruits_whole greens_beans refined_grains sea_plant_prot sodium_mg solid_fats_kcal total_protein veggies whole_grains {
replace nut_valuepp_4_`i'=nut_valuepp_4_`i'+((supply_`nut'_per_cal4)*beta`i'`nut')
}
}


forvalues i=1/4 {
gen cals_pp_nut_adjust`i'=exp(fe`i')/(supply_price_per_cal4-nut_valuepp_4_`i')
*replace cals_pp_nut_adjust`i'=exp(fe`i')/.1 if cals_pp_nut_adjust`i'<0
egen total_cals_pp_nut_adjust`i'=total(cals_pp_nut_adjust`i')
egen HealthIndex_pp_nut_adjust`i'=total(supply_rlHEI_per1000Cal4*cals_pp_nut_adjust`i'/total_cals_pp_nut_adjust`i')
*replace HealthIndex_pp_nut_adjust`i'= (HealthIndex_pp_nut_adjust`i'+2.93)/.78
}


forvalues i=1/4 {
replace HealthIndex_pp_nut_adjust`i'=(HealthIndex_pp_nut_adjust`i'-min)/(max-min)
}


sum HealthIndex_base*
sum HealthIndex_sup*
sum  HealthIndex_p_adjust*
sum HealthIndex_p_nut_adjust*
sum HealthIndex_pp_nut_adjust*



*Nutrient Pref of group4
forvalues i=1/4 {
gen nut_value_nut_only4_`i'=beta4base
foreach nut in fruits_total fruits_whole greens_beans refined_grains sea_plant_prot sodium_mg solid_fats_kcal total_protein veggies whole_grains {
replace nut_value_nut_only4_`i'=nut_value_nut_only4_`i'+(supply_`nut'_per_cal4*beta4`nut')
}
*replace nut_value_nut_only4_`i'=nut_value_nut_only4_`i'+(2.5*supply_g_StoreTime365_per_cal`i'*beta`i'StoreTime365)

}


forvalues i=1/4 {
gen cals_nut_only4_adjust`i'=exp(fe`i')/(supply_price_per_cal4-nut_value_nut_only4_`i')
*replace cals_nut_only4_adjust`i'=2500*exp(fe`i')/.1 if cals_nut_only4_adjust`i'<0
egen total_cals_nut_only4_adjust`i'=total(cals_nut_only4_adjust`i')
egen HealthIndex_nut_only4_adjust`i'=total(supply_rlHEI_per1000Cal4*cals_nut_only4_adjust`i'/total_cals_nut_only4_adjust`i')
*replace HealthIndex_nut_only4_adjust`i'= (HealthIndex_nut_only4_adjust`i'+2.93)/.78
}



forvalues i=1/4 {
replace HealthIndex_nut_only4_adjust`i'=(HealthIndex_nut_only4_adjust`i'-min)/(max-min)
}


sum HealthIndex_base*
sum HealthIndex_sup*
sum  HealthIndex_p_adjust*
sum HealthIndex_p_nut_adjust*
*sum HealthIndex_nut_adjust*
sum HealthIndex_pp_nut_adjust*
*sum HealthIndex_p_nonut_adjust*
*sum HealthIndex_store4_adjust*
sum HealthIndex_nut_only4_adjust*





*Now use all q4 

forvalues i=1/4 {
gen nut_value_all4_`i'=beta4base
foreach nut in fruits_total fruits_whole greens_beans refined_grains sea_plant_prot sodium_mg solid_fats_kcal total_protein veggies whole_grains {
replace nut_value_all4_`i'=nut_value_all4_`i'+(supply_`nut'_per_cal4*beta4`nut')
}
}


forvalues i=1/4 {
gen cals_all4_adjust`i'=exp(fe4)/(supply_price_per_cal4-nut_value_all4_`i')
egen total_cals_all4_adjust`i'=total(cals_all4_adjust`i')
egen HealthIndex_all4_adjust`i'=total(supply_rlHEI_per1000Cal4*cals_all4_adjust`i'/total_cals_all4_adjust`i')
*replace HealthIndex_all4_adjust`i'= (HealthIndex_all4_adjust`i'+2.93)/.78
}

forvalues i=1/4 {
replace HealthIndex_all4_adjust`i'=(HealthIndex_all4_adjust`i'-min)/(max-min)
}



sum HealthIndex_base*
sum HealthIndex_sup*
sum  HealthIndex_p_adjust*
sum HealthIndex_p_nut_adjust*
sum HealthIndex_pp_nut_adjust*
sum HealthIndex_nut_only4_adjust*
sum HealthIndex_all4_adjust*





// Try Subsidy to close gap by 9%

preserve
gen s1=0.000657
gen s2=0
gen s3=0
gen s4=0
forvalues i=1/4 {
gen cals_sub`i'=exp(fe`i')/((1-s`i'*rlHEI_per1000Cal`i'*(rlHEI_per1000Cal`i'>37))*price`i'-nut_value`i')
egen total_cals_sub`i'=total(cals_sub`i')
egen HealthIndex_sub`i'=total(rlHEI_per1000Cal`i'*cals_sub`i'/total_cals_sub`i')
*replace HealthIndex_base`i'= (HealthIndex_base`i'+2.93)/.78
}
egen total_cost=total(cals_sub1*s1*rlHEI_per1000Cal1*(rlHEI_per1000Cal1>37)*price1)
egen total_spend=total(cals_sub1*price1)
sum  HealthIndex_base4
local high=`r(mean)'
sum  HealthIndex_base1
local low=`r(mean)'
local goal=(`high'-`low')*0.09
gen diff=(`high'-`low')-(HealthIndex_sub4-HealthIndex_sub1)
gen pct_cost=total_cost/total_spend
disp"`goal'"

sum diff total_cost total_spend pct_cost
restore

// Close gap by 0.9 percent
preserve
gen s1=0.0000676
gen s2=0
gen s3=0
gen s4=0


forvalues i=1/4 {
gen cals_sub`i'=exp(fe`i')/((1-s`i'*rlHEI_per1000Cal`i'*(rlHEI_per1000Cal`i'>37))*price`i'-nut_value`i')
egen total_cals_sub`i'=total(cals_sub`i')
egen HealthIndex_sub`i'=total(rlHEI_per1000Cal`i'*cals_sub`i'/total_cals_sub`i')
*replace HealthIndex_base`i'= (HealthIndex_base`i'+2.93)/.78
}
egen total_cost=total(cals_sub1*s1*rlHEI_per1000Cal1*(rlHEI_per1000Cal1>37)*price1)
egen total_spend=total(cals_sub1*price1)
sum  HealthIndex_base4
local high=`r(mean)'
sum  HealthIndex_base1
local low=`r(mean)'
local goal=(`high'-`low')*0.009
gen diff=(`high'-`low')-(HealthIndex_sub4-HealthIndex_sub1)
gen pct_cost=total_cost/total_spend
disp"`goal'"
gen sub=s1*rlHEI_per1000Cal1 if (rlHEI_per1000Cal1>37)
sum diff total_cost total_spend pct_cost sub
restore

//Close gap by 100 percent
preserve
gen s1=0.00601
gen s2=0
gen s3=0
gen s4=0


forvalues i=1/4 {
gen subsidy`i'=s`i'*rlHEI_per1000Cal`i'*(rlHEI_per1000Cal`i'>37)
replace subsidy`i'=.95 if subsidy`i'>0.95
gen cals_sub`i'=exp(fe`i')/((1-subsidy`i')*price`i'-nut_value`i')
egen total_cals_sub`i'=total(cals_sub`i')
egen HealthIndex_sub`i'=total(rlHEI_per1000Cal`i'*cals_sub`i'/total_cals_sub`i')
*replace HealthIndex_base`i'= (HealthIndex_base`i'+2.93)/.78
}
egen total_cost=total(cals_sub1*subsidy1*price1)
egen total_spend=total(cals_sub1*price1)
sum  HealthIndex_base4
local high=`r(mean)'
sum  HealthIndex_base1
local low=`r(mean)'
local goal=(`high'-`low')
gen diff=(`high'-`low')-(HealthIndex_sub4-HealthIndex_sub1)
gen pct_cost=total_cost/total_spend
disp"`goal'"

sum diff total_cost total_spend pct_cost 
sum subsidy1 if subsidy1>0, d
restore



*Now as percentages

forvalues i=1/4 {
gen HI_sup`i'=(HealthIndex_sup`i')
gen HI_p`i'=(HealthIndex_p_adjust`i')
gen HI_pnut_supp`i'=HealthIndex_p_nut_adjust`i'
gen HI_pp`i'=(HealthIndex_pp_nut_adjust`i')
gen HI_p_nut`i'=(HealthIndex_nut_only4_adjust`i')

gen HI_all`i'=(HealthIndex_all4_adjust`i')


}


forvalues i=1/4 {
gen share_p`i'=-1*(HI_p`i'-HI_p4 -(HI_sup`i'-HI_sup4))/(HI_sup`i'-HI_sup4)
gen share_nut`i'=-1*(HI_pnut_supp`i'-HI_pnut_supp4 -(HI_p`i'-HI_p4))/(HI_sup`i'-HI_sup4)
gen share_pref`i'=-1*(HI_p_nut`i'-HI_p_nut4-(HI_pnut_supp`i'-HI_pnut_supp4))/(HI_sup`i'-HI_sup4)
gen share_fe`i'=-1*(HI_all`i'-HI_all4-(HI_p_nut`i'-HI_p_nut4))/(HI_sup`i'-HI_sup4)
}

sum HI_*
sum share_*

keep HealthIndex_* HI_* share_* 
*drop HealthIndex_percal*

preserve
keep HI_* HealthIndex_sup* HealthIndex_base* HealthIndex_p_adjust* HealthIndex_pp_nut_adjust*  HealthIndex_all4_adjust* HealthIndex_p_nut_adjust* 
duplicates drop
gen id=1
forvalues i=1/4 {
rename HI_sup`i' HIq`i'1
rename HI_p`i' HIq`i'2
rename HI_pnut_supp`i' HIq`i'3
rename HI_p_nut`i' HIq`i'4
rename HI_all`i' HIq`i'5
} 



reshape long HIq1 HIq2 HIq3 HIq4  HIq5 HIq6 HIq7 , i(id) j(step)

label define cats 1 "Base" 2 "+ High-income store prices" 3 "+ High-income store characteristics" ///
	4  "+ High-income characteristic prefs" 5 "+ High-income product group prefs"  

label values step cats


scatter HIq1  step, connect(l) lp(dash) || ///
scatter HIq2  step, connect(l) lp(longdash) || ///
scatter HIq3  step, connect(l) lp(longdash_dot) || ///
scatter HIq4  step, connect(l) lp(l) || ///
scatter HIq5  step, connect(l) xlabel(1(1)5,valuelab angle(25)) xtitle("") ///
ytitle("Re-normalized Health Index") graphregion(color(white)) ///
legend(label(1 "Income Q1") label(2 "Income Q2") label(3 "Income Q3") label(4 "Income Q4") order(1 2 3 4))  // ///
*title("Predicted % Less Healthy than Income Group 4")

graph export "Output/ModelEstimates/decomp_levels_gmmiv.pdf", replace


restore

duplicates drop
gen id=1


reshape long share_p share_nut  share_fe  share_pref, i(id) j(inc_cat)

gen bar_share_p=share_p
gen bar_share_nut=share_nut+share_p
gen bar_share_pref=share_nut+share_p+share_pref
gen bar_share_fe=share_nut+share_p+share_pref +share_fe

gen inc_lab="Income <25K" if inc_cat==1
replace inc_lab="Income 25-50K" if inc_cat==2
replace inc_lab="Income >75K" if inc_cat==3

drop if inc_cat==4
graph bar share_*, over(inc_cat, relabel(1 "Income Q1" 2 "Income Q2" 3 "Income Q3") ) /// //title("% of Health Ind Differences From Supply & Demand Factors") ///
legend(label(1 "Pricing-Supply") label(2 "Product Nutrients-Supply") label(3 "Nutrient Preference") label(4 "Product Group Pref.") ) ///
ytitle("Attribution Share")  graphregion(color(white))

graph export "Output/ModelEstimates/decomp_gmmiv.png", replace

**** Make final figure of share explained between highest- and lowest- income groups
keep if inc_cat==1
gen n=_n
reshape long share, i(n) j(cat) string
gen order = .
replace order = 4 if cat=="_p"
replace order = 3 if cat=="_nut"
replace order = 2 if cat=="_pref"
replace order = 1 if cat=="_fe"

twoway bar share order, horizontal color(navy) ///
	ylabel(4 `" "Prices" "(supply)" "' 3 `" "Product" "nutrients" "(supply)" "' ///
	2 `" "Nutrient" "preferences" "(demand)" "' 1 `" "Product" "group" "preferences" "(demand)" "', noticks nogrid angle(0)) ///
	graphregion(color(white)) ytitle("") legend(off) xline(0,lcolor(black)) ///
	xtitle("Share of high-low income Health Index difference")

graph export "Output/ModelEstimates/decomp_gap_gmmiv.pdf", replace





















