 /***************************************************************************** 
	Most of Africa’s Nutritionally-Deprived Women and Children are Not Found in Poor Households 

	Version for R.E. Stat
	
	LSMS Data
	
	Variables for women and children are constructed using separate do files. 
	These datasets are appended to the file all_individuals_LSMS_clean.dta
	Each woman and child has a separate row. The following analysis is run and 
	saved in all_individuals_LSMS.dta
	Please contact Cait Brown for do files to construct the all_individuals_LSMS_clean.dta
	file. 

	
	Last edited: July 2, 2018

	Cait Brown 
	cb575@georgetown.edu
*******************************************************************************/

clear all 
set maxvar 32000
set matsize 11000
* set graph font
graph set window fontface "Times New Roman"

//****** Set path here ****/
		
cd ""



/********************** Data cleaning & creating new variables  ***************/ 


use "all_individuals_LSMS_clean.dta", clear

replace month = 1 if  country == "BurkinaFaso"  |  country == "Ethiopia" | country == "Malawi" 
gen popweight1 = hhweight*hhsize 
replace popweight1 = popweight if popweight1 == . 
label var popweight1 "Population weight v2"

* need to calculate hhweight for Nigeria 
replace hhweight = popweight / hhsize if country == "Nigeria" 

* drop those with missing weights
drop if missing(popweight1) 
//84 obs

tab country if missing(EA)

drop if real_consumption_pc == . 
//957 obs 

drop if missing(underw) & woman == 1

drop if missing(whz06) & woman == 0 
// 27,370 obs dropped 
drop if missing(haz06) & woman == 0 

* 6.22 percent of woman are pregnant. 
tabstat pregnant if country == "Ghana" & woman == 1 
drop if pregnant == 1 & country == "Ghana" & woman == 1

gen consump = log(real_consumption_pc) 
label var consump "Log real consumption per capita" 

gen heightage_ch = haz06
gen weightheight_ch = whz06


save "all_individuals_LSMS.dta", replace 

* Adding in country specific poverty rates. Need to merge the file on 

use "CountryStats.dta", clear
rename Countryname country

merge m:m country using  "all_individuals_LSMS.dta"
drop if _merge == 1 
drop _merge 
order GDP_2011-Access_Impr_Sanitation, last 
sort country hhid memberid 

save "all_individuals_LSMS.dta", replace


/*****************************  Descriptives & Analysis ************************/ 

* Table A1
tab country woman

* Table 1
* all the weight-related variables 
tabstat underw  if woman == 1 [aweight=popweight1] , by(country) format(%9.3g)
* by gender
foreach x of numlist 0/1 {
tabstat stunted wasted if woman == 0 & female_ch == `x' [aweight=popweight1], by(country) format(%9.3g)
}
tabstat stunted wasted  if woman == 0 [aweight=popweight1] , by(country) format(%9.3g)


* elasticity of wealth w.r.t nutritional outcomes
gen bmi_z = . 
local country `"  "Ghana"  "Tanzania"  "'
foreach x of local country{ 
egen z = std(bmi) if woman == 1 & country == "`x'"
replace bmi_z = z if country == "`x'"
drop z 
}
label var bmi_z "BMI zscore"

gen consump_z = . 
local country `" "BurkinaFaso" "Ethiopia" "Ghana"  "Malawi"  "Nigeria" "Tanzania" "Uganda" "'
foreach x of local country{ 
egen z = std(real_consumption_pc) if country == "`x'"
replace consump_z = z if country == "`x'"
drop z 
}
label var consump_z "Comsumption zscore"

* Table 3
eststo clear
local country `"  "Ghana"  "Tanzania"  "'
foreach x of local country{ 
eststo: quietly  reg bmi_z consump_z if country == "`x'" & woman == 1,  vce(cluster EA)
}
esttab using "results", append title("`x'")  b(%10.3f) star(* .10 ** .05 *** .01) label se(%9.3f) obslast longtable r2 csv 

eststo clear
local country `" "BurkinaFaso" "Ethiopia" "Ghana"  "Malawi"  "Nigeria" "Tanzania" "Uganda" "'
foreach x of local country{ 
eststo: quietly  reg `var'  consump_z if country == "`x'" & woman == 0,  vce(cluster EA)
}
esttab using "results", append title("`x'")  b(%10.3f) star(* .10 ** .05 *** .01) label se(%9.3f) obslast longtable r2 csv 
eststo clear


*******  Calculating wealth percentiles  ********/

bys country hhid: gen nval = _n == 1 

gen wealth_percentile_hh = . 
local country `" "BurkinaFaso" "Ethiopia" "Ghana" "Malawi"  "Nigeria" "Tanzania" "Uganda" "'
foreach x of local country{ 
xtile percentile_`x' = real_consumption_pc [aweight=hhweight] if country == "`x'" &  nval == 1 & real_consumption_pc != ., n(100) 
egen wealth1_`x' = max(percentile_`x') if country == "`x'", by(hhid)
replace wealth_percentile_hh = wealth1_`x' if country == "`x'"
drop percentile_`x' wealth1_`x'
}

local nums `" "20" "40" "'
foreach num of local nums{
gen wealth_hh_`num' = 0 
replace wealth_hh_`num' = 1 if wealth_percentile_hh <= `num' 
label var wealth_hh_`num' "Consumption in bottom `num' percent"
}

gen wealth_hh_pov = 0 
replace wealth_hh_pov = 1 if wealth_percentile <= Pov_rate 
label var wealth_hh_pov "Consumption below poverty rate" 


/*********  Calculating conditional & joint probabilities  ********/

* conditional probabilties - of the underweight, who falls in the bottom 20 percent of wealth? 

local names `" "_hh_" "'
foreach y of local names {
local nums `" "20" "40" "pov" "'
foreach num of local nums{
gen underw`num' = 0 
replace underw`num' = 1 if wealth`y'`num' == 1 & underw == 1 & woman == 1
bys country: egen e1_underw`y'`num' = wtmean(underw`num') if underw == 1 & woman == 1 , weight(popweight1) 
drop underw`num' 
}
local vars stunted wasted 
foreach var of local vars {
local nums `" "20" "40" "pov" "'
foreach num of local nums{
gen `var'`num' = 0 
replace `var'`num' = 1 if wealth`y'`num' == 1 & `var' == 1 & woman == 0
bys country: egen e1_`var'`y'`num' = wtmean(`var'`num') if `var' == 1 & woman == 0 , weight(popweight1) 
drop `var'`num' 
}
}
}

local names `" "_hh_" "'
foreach y of local names {
tabstat e1_underw`y'20 e1_underw`y'40 e1_underw`y'pov if woman == 1 [aweight=popweight1], by(country)
tabstat e1_stunted`y'20 e1_wasted`y'20  e1_stunted`y'40 e1_wasted`y'40 e1_stunted`y'pov e1_wasted`y'pov if woman == 0 [aweight=popweight1], by(country)
}

drop nval

save "all_individuals_LSMS.dta", replace


/************************ FIGURES   **********************/

** create means with percentiles
local names `" "_hh" "'
foreach y of local names {

gen underw`y'_pc = . 
gen stunt`y'_pc = . 
gen wast`y'_pc = . 
gen underw20`y'_pc = .

local country `"  "Ghana"  "Tanzania"  "'
foreach x of local country{ 
egen underw_pc1 = mean(100 * underw) if woman == 1 & country == "`x'", by(wealth_percentile`y') 
replace underw`y'_pc = underw_pc1 if country == "`x'"
drop underw_pc1
egen underw_pc1 = mean(100 * underw) if woman == 1 & country == "`x'" & age >= 20, by(wealth_percentile`y') 
replace underw20`y'_pc = underw_pc1 if country == "`x'"
drop underw_pc1
}
local country `" "BurkinaFaso" "Ethiopia" "Ghana"  "Malawi"  "Nigeria" "Tanzania" "Uganda" "'
foreach x of local country{ 
egen stunt_pc1 = mean(100 * stunted) if woman == 0 & country == "`x'", by(wealth_percentile`y') 
replace stunt`y'_pc = stunt_pc1 if country == "`x'"
egen wast_pc1 = mean(100 * wasted) if woman == 0 & country == "`x'", by(wealth_percentile`y') 
replace wast`y'_pc = wast_pc1 if country == "`x'"
drop stunt_pc1 wast_pc1
}
}


* Lowess of percent underweight, stunting and wasting on W percentiles
local names `" "_hh" "'
foreach y of local names {
bys country wealth_percentile`y' woman: gen nval1 = _n == 1 
local country `"  "Ghana"  "Tanzania"  "'
foreach x of local country{ 
lowess underw`y'_pc wealth_percentile`y' if country == "`x'" & woman == 1 , gen(underw`y'_pc_`x') nograph
}
local country `"  "Ghana"  "Tanzania"  "'
foreach x of local country{ 
lowess underw20`y'_pc wealth_percentile`y' if country == "`x'" & woman == 1 & age >=20 , gen(underw20`y'_pc_`x') nograph
}
local country `" "BurkinaFaso" "Ethiopia" "Ghana"  "Malawi"  "Nigeria" "Tanzania" "Uganda" "'
foreach x of local country{ 
lowess stunt`y'_pc wealth_percentile`y' if country == "`x'" & woman == 0 , gen(stunt`y'_pc_`x') nograph
}
local country `" "BurkinaFaso" "Ethiopia" "Ghana"  "Malawi"  "Nigeria" "Tanzania" "Uganda" "'
foreach x of local country{ 
lowess wast`y'_pc wealth_percentile`y' if country == "`x'" & woman == 0 , gen(wast`y'_pc_`x') nograph
}
drop nval1
}


* creating scatter plots with just the lowess lines. 

local names `" "_hh""'
foreach y of local names {
bys country wealth_percentile`y' woman: gen nval1 = _n == 1 

local country `"  "Ghana"  "Tanzania"  "'
foreach x of local country{ 
graph twoway line underw`y'_pc_`x' wealth_percentile`y' if country == "`x'" & woman == 1 & nval1 == 1  , lpattern(solid) lcolor(black) lwidth(medium)  || line underw20`y'_pc_`x' wealth_percentile`y' if country == "`x'" & woman == 1 & nval1 == 1 , lpattern(shortdash) lcolor(black) lwidth(medium) || line stunt`y'_pc_`x' wealth_percentile`y' if country == "`x'" & woman == 0 & nval1 == 1 , lpattern(longdash_dot) lcolor(black) lwidth(medium)  || line wast`y'_pc_`x' wealth_percentile`y'  if country == "`x'" & woman == 0 & nval1 == 1 , lpattern("---...") lcolor(black) lwidth(medium) ytitle(Percent Undernourished) xtitle(Consumption Percentile) title("`x'") legend(ring(0) pos(2) cols(1) lab(1 "Underweight All") lab(2 "Underweight 20-49") lab(3 "Stunted") lab(4 "Wasted") region(style(none))) yscale(range(0 60)) ylabel(0[10]60, nogrid)  graphregion(color(white)) bgcolor(white) 
graph export lowess_all`y'_`x'.png, replace
}
local country `" "BurkinaFaso" "Ethiopia"   "Malawi"  "Nigeria"  "Uganda" "'
foreach x of local country{ 
graph twoway line stunt`y'_pc_`x' wealth_percentile`y' if country == "`x'" & woman == 0 & nval1 == 1 , lpattern(longdash_dot) lcolor(black) lwidth(medium)  || line wast`y'_pc_`x' wealth_percentile`y'  if country == "`x'" & woman == 0 & nval1 == 1 , lpattern("---...") lcolor(black) lwidth(medium) ytitle(Percent Undernourished) xtitle(Consumption Percentile) title("`x'") legend(ring(0) pos(2) cols(1)  lab(1 "Stunted") lab(2 "Wasted") region(style(none))) yscale(range(0 60)) ylabel(0[10]60, nogrid)  graphregion(color(white)) bgcolor(white) 
graph export lowess_all`y'_`x'.png, replace
}

drop nval1 
}

save "all_individuals_LSMS.dta", replace
