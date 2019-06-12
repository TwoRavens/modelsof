*This file generates figures 6A and 6B for the revenue simulations as well as the appendix table A22.

set more off

log using log_revenue.log, replace

use "..\data\data_agg_rev" , clear


set seed 2047855923
global income 90180

generate pareto = . 
gen paretostd = .
foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {
replace pareto = alpha`s' if code_ccaa == `s'
replace paretost = alpha`s'_sd if code_ccaa == `s'
}
drop alpha*


*Merge in revenue data
merge 1:1 code_ccaa year using "..\data\controls\taxrevenue.dta"
drop _merge
replace PIT = PIT*1000
replace tot_rec_trib =  tot_rec_trib*1000
by code_ccaa, sort: egen revenue = mean(PIT) if year>2010
rename av_inc_ccaa_perc_year y
gen ybar = $income


*Plug In Elasticity of mobility/TI
gen emob = .878
gen estd = .500
gen eti = .15



replace tau100_total = tau100_total/100
replace tau100_central =tau100_central/100
replace tau100_regional =tau100_regional/100
replace tau_regional =tau_regional/100 
replace tau_central =tau_central/100 
replace tau_bar_regional =tau_bar_regional/100
replace tau_bar_central = tau_bar_central/100


gen n=. 


*Take the stock averaged across post-reform years, use post reform because multiple years
by code_ccaa, sort: egen statestock = mean(n_obs_ccaa_perc_year) if year>2010
by code_ccaa, sort: egen statey = mean(y) if year>2010


*Define the tax rate pre-reform
gen tau100_regional_prejunk = tau100_regional if year ==2010
gen tau100_regional_postjunk = tau100_regional if year ==2014

gen taubar_regional_prejunk = tau_bar_regional if year ==2010
gen taubar_regional_postjunk = tau_bar_regional if year ==2014

gen tau100_central_prejunk = tau100_central if year ==2010
gen tau100_central_postjunk = tau100_central if year ==2014

gen taubar_central_prejunk = tau_bar_central if year ==2010
gen taubar_central_postjunk = tau_bar_central if year ==2014

gen tau_regional_prejunk = tau_regional if year ==2010
gen tau_regional_postjunk = tau_regional if year ==2014
gen tau_central_prejunk = tau_central if year ==2010
gen tau_central_postjunk = tau_central if year ==2014



*expand these variables to fill in all years; use min command as only one value
by code_ccaa, sort: egen taubar_regional_pre = min(taubar_regional_prejunk)
by code_ccaa, sort: egen taubar_regional_post = min(taubar_regional_postjunk)
by code_ccaa, sort: egen tau100_regional_pre = min(tau100_regional_prejunk)
by code_ccaa, sort: egen tau100_regional_post = min(tau100_regional_postjunk)
by code_ccaa, sort: egen taubar_central_pre = min(taubar_central_prejunk)
by code_ccaa, sort: egen taubar_central_post = min(taubar_central_postjunk)
by code_ccaa, sort: egen tau100_central_pre = min(tau100_central_prejunk)
by code_ccaa, sort: egen tau100_central_post = min(tau100_central_postjunk)
by code_ccaa, sort: egen tau_regional_pre = min(tau_regional_prejunk)
by code_ccaa, sort: egen tau_regional_post = min(tau_regional_postjunk)
by code_ccaa, sort: egen tau_central_pre = min(tau_regional_prejunk)
by code_ccaa, sort: egen tau_central_post = min(tau_central_postjunk)
gen tau100_dif_pre = tau100_regional_pre - tau100_central_pre
gen taubar_dif_pre = taubar_regional_pre - taubar_central_pre
gen tau100_dif_post = tau100_regional_post - tau100_central_post
gen taubar_dif_post = taubar_regional_post - taubar_central_post
gen tau_dif_pre = tau_regional_pre - tau_central_pre
gen tau_dif_post = tau_regional_post - tau_central_post


*keep only one year of data.  all variables to be used are not year sensative
keep if year == 2014

*Do the double difference to account for small differences prior to the reform.
gen taubar_change = taubar_dif_post-taubar_dif_pre
*Valenica mimicks; this removes some rounding error
replace taubar_change = 0 if taubar_change < .000001 & taubar_change >-.000001
*replace taubar_change = round(taubar_change, .000001)
gen atr_change = tau_dif_post - tau_dif_pre



***Need to multiply by 25 to obtain population level estimates


foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {
preserve
keep if code_ccaa ==`s'
expand = 100000
gen e = emob+estd*rnormal() 
gen a = pareto +paretostd*rnormal()

gen mechanical_effect = (25)*statestock*(statey-ybar)*taubar_change
gen income_effect = (-1)*(25)*statestock*(statey-ybar)*eti*pareto*(taubar_regional_pre/(1-taubar_regional_pre))*taubar_change
gen migration_effect = (-1)*(25)*statestock*(statey-ybar)*emob*(tau_regional_pre/(1-tau_regional_pre))*taubar_change
gen revenue_effect = mechanical_effect+income_effect+migration_effect
gen percent_effect = revenue_effect*100/revenue
gen percent_mechanical = mechanical_effect*100/revenue
gen percent_income = income_effect*100/revenue
gen percent_migration = migration_effect*100/revenue
gen critical_elasticity = (mechanical_effect+migration_effect)/((25)*statestock*(statey-ybar)*pareto*(taubar_regional_pre/(1-taubar_regional_pre))*taubar_change)

gen income_effect_se = (-1)*(25)*statestock*(statey-ybar)*eti*a*(taubar_regional_pre/(1-taubar_regional_pre))*taubar_change
gen migration_effect_se = (-1)*(25)*statestock*(statey-ybar)*e*(tau_regional_pre/(1-tau_regional_pre))*taubar_change
gen revenue_effect_se = mechanical_effect+income_effect_se+migration_effect_se
gen percent_effect_se = revenue_effect_se*100/revenue
gen percent_income_se = income_effect_se*100/revenue
gen percent_migration_se = migration_effect_se*100/revenue
gen critical_elasticity_se = (mechanical_effect+migration_effect)/((25)*statestock*(statey-ybar)*a*(taubar_regional_pre/(1-taubar_regional_pre))*taubar_change)


*Convert to thousands of Euros
replace mechanical_effect=mechanical_effect/1000
replace income_effect = income_effect/1000
replace migration_effect = migration_effect/1000
replace revenue_effect = revenue_effect/1000
replace income_effect_se = income_effect_se/1000
replace migration_effect_se = migration_effect_se/1000
replace revenue_effect_se = revenue_effect_se/1000

gen mechanical_effect_se=0
gen percent_mechanical_se = 0


replace n=_n
gen str output=""
gen str output2=""
gen str coef=""
gen coef2=.
gen lower=.
gen  lower2=.
gen str lower3=""

gen upper=.
gen  upper2=.
gen str upper3=""

foreach var of varlist mechanical_effect income_effect migration_effect revenue_effect {

local loop = `loop'+1



sum `var'
replace coef2=round(`r(mean)')
replace coef=string(coef2)
centile `var'_se , centile(2.5,97.5)
replace lower=`r(c_1)'
replace lower2=round(lower,1)
replace lower3=string(lower2)

replace upper=`r(c_2)'
replace upper2=round(upper,1)
replace upper3=string(upper2)


replace output=coef if n==`loop'
replace output2="["+lower3+","+upper3+"]" if n==`loop'



}
foreach var of varlist percent_effect percent_mechanical  percent_income percent_migration critical_elasticity {

local loop = `loop'+1



sum `var'
replace coef2=round(`r(mean)',.001)
replace coef=string(coef2)
centile `var'_se , centile(2.5,97.5)
replace lower=`r(c_1)'
replace lower2=round(lower,.001)
replace lower3=string(lower2)

replace upper=`r(c_2)'
replace upper2=round(upper,.001)
replace upper3=string(upper2)


replace output=coef if n==`loop'
replace output2="["+lower3+","+upper3+"]" if n==`loop'



}

local k = (`s'*2)-1


keep output output2
drop if output==""

local alpha "abcdefghijklmnopqrstuvwxyz"
gen alpha = substr("`alpha'", `k', 1) 
local alpha2 = alpha[1]  

if `s'<=13{

export excel using "table_A22", cell(`alpha2'1) sheetmodify

}


if `s'==14 {

export excel using "table_A22", cell(AA1) sheetmodify

}



if `s'==17 {

export excel using "table_A22", cell(AC1) sheetmodify

}
local loop=0
restore
}



******* GRAPHS


import excel "table_A22.xls", sheet("Sheet1") cellrange(A1:AD9) clear
gen i = _n

rename A a_1
rename B b_1
rename C a_2
rename D b_2
rename E a_3
rename F b_3
rename G a_4
rename H b_4
rename I a_5
rename J b_5
rename K a_6
rename L b_6
rename M a_7
rename N b_7
rename O a_8
rename P b_8
rename Q a_9
rename R b_9
rename S a_10
rename T b_10
rename U a_11
rename V b_11
rename W a_12
rename X b_12
rename Y a_13
rename Z b_13
rename AA a_14
rename AB b_14
rename AC a_15
rename AD b_15


reshape long a_ b_, j(id) i(i)


destring a_, replace
rename a_ max_tax

generate splitat = strpos(b_,",")
generate splitend = strpos(b_,"]")
generate splitdif_up=splitend-splitat-1


generate lower  = substr(b_,2,splitat-2)
destring lower, replace force
generate upper  = substr(b_,splitat+1,splitdif_up)
destring upper, replace
drop b_ 

label define name_ccaa 1 "Andalucía" 2 "Aragón" 3 "Asturias" 4 "Illes Balears" 5 "Canarias" 6 "Cantabria" 7 "Castilla y León" 8 "Castilla-La Mancha" 9 "Cataluña" 10 "Valencia" 11 "Extremadura" 12 "Galicia" 13 "Madrid" 14 "Murcia" 15 "La Rioja"
label values id name_ccaa



reshape wide max_tax splitat splitend splitdif_up lower upper , i(id) j(i)


*Figure 6 A
graph hbar (mean) max_tax6 max_tax7 max_tax8, over(id, sort(max_tax)) graphregion(color(white)) ytitle("percent of revenue") legend(order(1 "mechanical" 2 "taxable income" 3 "mobility"))  bar(1, color(lightgrey) fi(5) lw(vthin)) bar(2, color(grey)  fi(50) lw(vthin)) bar(3, color(black) fi(100) lw(medium)) 
graph export fig_6A.pdf, as(pdf) replace
 
 
 *Figure 6 B
 twoway (bar  max_tax9 id, color(gray) fi(30) lw(medium))  (rcap lower9 upper9 id, color(black)) (scatter max_tax9 id , color(black)) , xlabel(1(1)15, angle(forty_five) valuelabel) xtitle("") graphregion(color(white)) yscale(range(0 (.1) 1)) ylabel(0 (.25) 1.5) legend(off) ytitle(elasticity of taxable income)
graph export fig_6B.pdf, as(pdf) replace

*Table A22
*Use the excel output to reshape the table as in the paper.  (Use, copy-paste-transpose.)

 
 log close
