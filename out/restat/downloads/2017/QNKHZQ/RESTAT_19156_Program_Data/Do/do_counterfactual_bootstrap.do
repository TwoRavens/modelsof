* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

loc num_bootstrap = 100

*********************
*** Analysis 
*********************

forval b = 1/100 {

loc dataset "DataStata/bootstrap/counterfactual_b`b'"
loc dataset2 "DataStata/bootstrap/data_subsidyline_fuelcons_domestic_kei_`b'"

loc nrep = 50
loc compliance = 0

foreach rc in 1 0 {

* Very important: Drop scalar values
scalar drop _all

loc filename counterfactual_rc`rc'

*** [1] Mandatory ABR

scalar s_subsidy_dollar = 1000
scalar s_subsidy_dollar_kei = 700
scalar s_ave_subsidy = 0.5*s_subsidy_dollar + 0.5*s_subsidy_dollar_kei
scalar simulation_subsidy_dollar = 9999999

loc difference = 999

loc sign = 1
loc iteration = 1
loc start = 1
if `compliance'==1 loc start 1
forval shift = `start'/500 {
if abs(`difference')>=0.005 {

* This dataset includes the subsidy cutoff line and distance to each point in the line to each vehicle's original location
use `dataset2 ',clear
g obs2008 = 0

* Shift the subsidy line
if `difference'<0 loc shift = -`shift'
loc k = (10000+`shift')/10000
replace kmlit = kmlit*`k' 
replace liter_km = 1/kmlit 
replace d_liter_km = liter_km - liter_km2008
replace d_liter_km_2 = d_liter_km^2  
g newsubsidy =1
save Temp/subsidylineforallid,replace

* Keep one obs for each weight
sort kg kmlit 
bysort kg: keep if _n==1
keep kg kmlit 
rename kmlit newtarget
sort kg 
save Temp/subsidyline,replace 
* Temp/subsidyline is the ABR schedule of fuel economy (kmlit) against weight (kg)

* Merge new target to obs in 2008
use `dataset',clear
if "`sample'"=="domestic" keep if n_type==1
if "`sample'"=="kei" keep if n_type==2
g obs2008=1 
sort kg
merge kg using $temp/subsidyline,nokeep
drop _merge

* New subsidy = 1 if the car would be qualified for subsidy under the new subsidy cutoff 
g newsubsidy = kmlit >= newtarget

* Append subsidy line for all
append using $temp/subsidylineforallid
replace obs2008=0 if obs2008==.

* Rescale
* Original data of liter_km not rescaled. We need to rescale as we did in DCM estimation for consisistency. 
foreach x in d_liter_km liter_km liter_km2008 compliance_old comp_at_old compliance compliance2008 {
g original_scale_`x' =`x' 
replace `x' = `x'*100
}
drop d_liter_km_2 d_liter_km_weight_min
g d_liter_km_2 = d_liter_km^2
g d_liter_km_weight_min = d_liter_km*d_weight_min

*** Merge with estimated parameters 
* Est filename
loc estfile "b`b'_result_mixlogit_rc`rc'_nrep`nrep'_compliance`compliance'"
sort id 
merge id using "TableText/b_para_`estfile'"
*tab _merge
keep if _merge==3
drop _merge

* Make comp_parameter 
foreach v in b_comp_at_old b_compliance {
cap g `v' = 0
}

* Important: we need to switch sign of b_comp_at_old to get "lambda_dot"
g lambda_dot =  -b_comp_at_old

*** 3) Find counterfactual no-regulation "a" and "e" 

* Write a g-function
loc g_func "0"
foreach x in d`ln'_weight_min_2 d`ln'_liter_km_2 d`ln'_liter_km_weight_min {
loc g_func "`g_func' + b_`x'*`x'"
}

* Make g-function
g g_func = `g_func'

* Make f-function
g f_func = g_func 
if `compliance'~=0 replace f_func =  g_func +  lambda_dot*(compliance2008 - comp_at_old) 

* Scale f_func as dollor
g subsidy_dollar = s_subsidy_dollar
replace subsidy_dollar = s_subsidy_dollar_kei if n_type==2
g f_func_dollar = f_func*(s_ave_subsidy/(b_subsidy))
g g_func_dollar = g_func*(s_ave_subsidy/(b_subsidy))

* Keep one obs for each id that maximizes f_func+subsidy 
g payoff_abr_new = f_func_dollar 
replace payoff_abr_new = f_func_dollar + simulation_subsidy_dollar if newsubsidy==1 
sort id payoff_abr_new
bysort id: keep if _n==_N

* Check inframarginal 
g inframarginal_ABR = obs2008==1 & newsubsidy==1 
g nosubsidy_bc_costly_ABR = obs2008==1 & newsubsidy==0
g getsubsidy_ABR = newsubsidy==1  & inframarginal_ABR==0

* Some estimates to scalar
qui:sum g_func_dollar
scalar s_payoff_ABR = r(mean)
qui:sum payoff_abr_new 
scalar s_payoff_with_subsidy_ABR = r(mean)
qui:sum d_weight_min 
scalar s_da_ABR = r(mean)
qui:sum d_liter_km 
scalar s_de_ABR = r(mean)

* NEW
* Bootstrap given that de = -0.84
loc de_ABR_RCL = -0.84
loc difference = - (`de_ABR_RCL' - s_de_ABR)
loc difference_i`iteration' = `difference'
dis "*** iteration = `iteration', shift = `shift' ***"
macro list _difference _de_ABR_RCL
scalar list s_de_ABR

loc iteration = `iteration'+1

*if
}
*shift
}

scalar list s_de_ABR

g de_ABR = d_liter_km
g da_ABR = d_weight_min

***
loc v da_ABR
sum `v',d
sum `v' if `v'>r(min) & `v'<r(max) | `v'==r(min) & `v'==r(max)
scalar s_`v' =  r(mean)

*sum g_func f_func
*sum g_func_dollar f_func_dollar

* Greek
g alpha = b_d_liter_km_2
g beta = b_d_weight_min_2
g gamma = b_d_liter_km_weight_min

scalar lambdamultiplier = 1

* 1. Cost from e2
g cost_e2 = ( b_d`ln'_liter_km_2*d`ln'_liter_km_2 + lambdamultiplier*lambda_dot*(-d`ln'_liter_km) )* (s_ave_subsidy/(b_subsidy) )

* 3. MC of ABR
g mc = (2*alpha*de_ABR + gamma*da_ABR - lambdamultiplier*lambda_dot)*    (s_ave_subsidy/(b_subsidy) )

*** Efficient policy 
* theta = 2*alpha - (gamma^2)/(2*beta) 
g theta = (2*alpha - (gamma^2)/(2*beta))^(-1) 
egen ave_theta = mean(theta)
g subsidy_Efficient = s_de_ABR/ave_theta
g de_Efficient = subsidy_Efficient*theta
g da_Efficient = -(gamma/(2*beta))*de_Efficient
sum *_Efficient
g mc_Efficient = (2*alpha*de_Efficient + gamma*da_Efficient - lambdamultiplier*lambda_dot)* (s_ave_subsidy/(b_subsidy) )
sum mc_Efficient
scalar s_mc_sd_Efficient = r(sd)
g payoff_Efficient = ( alpha*((de_Efficient)^2) + beta*((da_Efficient)^2) + gamma*de_Efficient*da_Efficient )* ( (s_ave_subsidy)/(b_subsidy) )
sum payoff_Efficient*

* Save mean as a scaler
foreach v in mc payoff de da {
sum `v'_Efficient
scalar s_`v'_Efficient =  r(mean)
}
*** Find a flat standard for this efficient policy 

loc difference = 999
forval i = 1/10000 {

if `difference'>0.001 {

loc flat_std_Efficient = 3 + `i'/1000
foreach v in extra_compliance {
cap drop `v'
}

g extra_compliance = `flat_std_Efficient' - (liter_km2008 + de_Efficient)
sum extra_compliance
loc difference = abs(r(mean))

scalar efficient_difference = `difference' 
scalar list efficient_difference
*if
}
*i
}
g flat_std_Efficient = `flat_std_Efficient'
g subsidy_revenue = (extra_compliance*subsidy_Efficient)* (s_ave_subsidy/(b_subsidy))
g payoff_with_trading_Efficient = payoff_Efficient + subsidy_revenue
sum flat_std_Efficient subsidy_revenue payoff_Efficient payoff_with_trading_Efficient

***
loc v da_Efficient
sum `v',d
sum `v' if `v'>r(min) & `v'<r(max) | `v'==r(min) & `v'==r(max)
scalar s_`v' =  r(mean)

* Some estimates to be stored 
qui:sum cost_e2 
scalar s_cost_de_ABR = r(mean)
qui:sum mc 
*scalar s_sd_mc = r(sd)
scalar s_mc_sd_ABR = r(sd)
*scalar list _all

* Save data for making histogram
g ave_mc_Efficient = s_mc_Efficient
*save Temp/data_histogram_ABR_rc`rc',replace 

foreach x in inframarginal_ABR nosubsidy_bc_costly_ABR getsubsidy_ABR {
qui:sum `x'
scalar s_`x' = r(mean)
}
compress
*save Temp/results_abr_`filename',replace


*** [2] Mandatory Flat

* Datafile
use `dataset',clear
if "`sample'"=="domestic" keep if n_type==1
if "`sample'"=="kei" keep if n_type==2

* Subsidy dollar
g subsidy_dollar = s_subsidy_dollar
replace subsidy_dollar = s_subsidy_dollar_kei if n_type==2

* Rescale
foreach x in d_liter_km liter_km liter_km2008 compliance2008 compliance_old {
g original_scale_`x' =`x'
replace `x' = `x'*100
}
drop d_liter_km_2 d_liter_km_weight_min
g d_liter_km_2 = d_liter_km^2
g d_liter_km_weight_min = d_liter_km*d_weight_min

*** ) Merge with estimated parameters 
* Est filename
sort id 
merge id using "TableText/b_para_`estfile'"
tab _merge
keep if _merge==3
drop _merge

* Make comp_parameter 
foreach v in b_comp_at_old b_compliance {
cap g `v' = 0
}

* Important: we need to switch sign of b_comp_at_old to get "lambda_dot"
g lambda_dot = - b_comp_at_old

* Greek
g alpha = b_d_liter_km_2
g beta = b_d_weight_min_2
g gamma = b_d_liter_km_weight_min

scalar cutoff_de  = sqrt( - (simulation_subsidy_dollar/s_ave_subsidy)*b_subsidy/b_d`ln'_liter_km_2) 

loc difference = 999
forval i = 1/10000 {

if `difference'>0.001 {

loc flat_std = 3 + `i'/1000
foreach v in inframarginal_Flat nosubsidy_bc_costly_Flat getsubsidy_Flat payoff_Flat de_Flat mc_Flat {
cap drop `v'
}
g inframarginal_Flat = liter_km2008 <= `flat_std' 
g nosubsidy_bc_costly_Flat = abs(`flat_std' - liter_km2008) > abs(cutoff_de) & inframarginal_Flat==0
g getsubsidy_Flat = nosubsidy_bc_costly_Flat ==0 & inframarginal_Flat==0
g de_Flat = 0
replace de_Flat = `flat_std' - liter_km2008 if getsubsidy_Flat==1

* Difference between e_Flat and e_ABR
sum de_Flat
loc mean_de_Flat = r(mean)
loc difference = abs(`mean_de_Flat' - s_de_ABR)
scalar s_difference = `difference' 
scalar list s_difference

*if
}
*i
}

*** Flat policy ouctomes  
g da_Flat = -(gamma/2*beta)*de_Flat
g mc_Flat = (2*alpha*de_Flat + gamma*da_Flat - lambdamultiplier*lambda_dot)* (s_ave_subsidy/(b_subsidy) )
g payoff_Flat = ( alpha*((de_Flat)^2) + beta*((da_Flat)^2) + gamma*de_Flat*da_Flat  + lambdamultiplier*lambda_dot*(-de_Flat))* ( (s_ave_subsidy)/(b_subsidy) )
* Save mean as a scaler
foreach v in mc payoff de da inframarginal nosubsidy_bc_costly getsubsidy {
sum `v'_Flat
scalar s_`v'_Flat =  r(mean)
}
sum mc_Flat
scalar s_mc_sd_Flat = r(sd)
scalar s_mc_mean_Flat = r(mean)
scalar s_flat_std = `flat_std'

***
loc v da_Flat
sum `v',d
sum `v' if `v'>r(min) & `v'<r(max) | `v'==r(min) & `v'==r(max)
scalar s_`v' =  r(mean)

compress
*save Temp/results_flat_`filename',replace

* Histogram of MC for Flat schedule, and combine it with ABR
*save Temp/data_histogram_Flat_rc`rc',replace 

loc de_ABR_RCL = s_de_ABR

*** Save results to text file 
loc s1 "payoff_ABR cost_de_ABR payoff_Efficient payoff_Flat"
loc s2 "de_ABR da_ABR de_Flat da_Flat flat_std mc_sd_ABR mc_sd_Flat mc_Efficient"
loc s3 "inframarginal_Flat nosubsidy_bc_costly_Flat getsubsidy_Flat"
loc s4 "inframarginal_ABR nosubsidy_bc_costly_ABR getsubsidy_ABR"
loc s5 "mc_sd_Efficient de_Efficient da_Efficient"
loc slist "`s1' `s2' `s3' `s4' `s5'"

capture file close myfile
file open myfile using "Temp/bootstrap`b'_Results_`filename'.txt", write replace
foreach s in `slist' {
file write myfile "`s'" _tab 
}
file write myfile _n
foreach s in `slist' {
file write myfile (s_`s') _tab 
}
capture file close myfile

************* rc
}
*b
}

*********************
*** Append results 
*********************

loc num_bootstrap=100
forval rc = 0/1 {
loc filename counterfactual_rc`rc'
clear 
forval b = 1/`num_bootstrap' {
insheet using "Temp/bootstrap`b'_Results_`filename'.txt",clear case
g b = `b'
save "Temp/bootstrap`b'_Results_`filename'.dta",replace
}
clear 
forval b = 1/`num_bootstrap' {
append using "Temp/bootstrap`b'_Results_`filename'.dta"
}
sum 
save "TableText/bootstrap_`filename'",replace 
}

*** END
