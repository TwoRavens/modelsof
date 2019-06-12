 /***************************************************************************** 
	Most of Africa’s Nutritionally-Deprived Women and Children are Not Found in Poor Households 

	Version for R.E. Stat
	
	DHS Data 
	
	This file includes nutritional outcomes for all household members: men, women, and children
	
	Variables are constructed using separate do files. 
	These datasets are appended to the file all_individuals_intra_clean.dta
	Each woman and child has a separate row. The following analysis is run and 
	saved in all_individuals_intra.dta
	Please contact Cait Brown for do files to construct the all_individuals_intra_clean.dta
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

use "all_individual_intra_clean", clear

gen adult = 0 
replace adult = 1 if age >= 15
drop if missing(bmi) & adult == 1
//140,479 observations dropped

drop if missing(weightheight_ch) & adult == 0
//dropped 144,041 obs
drop if missing(heightage_ch) & adult == 0
//dropped 37 obs 

* included now are household members 0-5; 15-64
tab age

gen wealth_index = hv271/100000
label var wealth_index "Wealth Index factor score" 
drop if missing(wealth_index) 
// dropped 0 obs

gen clust=hv001

* survey weights
gen hh_w=hv005/1000000
gen psu_hh = hv012
label var psu_hh "PSU - households"
drop if missing(hh_w)  
// 0 dropped

tab country female if age15to49 == 1 & pregnant != 1 

gen hhsize = hv012
label var hhsize "Household size, de jure"

gen head1 = 0 if head == 1 & female == 0
replace head1 = 1 if head == 1 & female == 0 & age15to49 == 1
egen head_15to49 = max(head1), by(hhid)
drop head1 

gen head1 = 0 if head == 1 & female == 0 & age15to49 == 1 & underw == 0
replace head1 = 1 if head == 1 & female == 0 & age15to49 == 1 & underw == 1
egen head_isunderw_15to49 = max(head1), by(hhid) 
drop head1 

gen head1 = 0 if head == 1 & female == 0 & age15to49 == 1 & underw == 1
replace head1 = 1 if head == 1 & female == 0 & age15to49 == 1 & underw == 0
egen head_notunderw_15to49 = max(head1), by(hhid) 
drop head1 
 
tabstat head_underw_15to49 head_isunderw_15to49 head_notunderw_15to49, by(countryname)

drop if pregnant == 1 
//3,764 dropped
drop if missing(w)
// 0 dropped


/*****************************  Descriptives & Analysis ************************/ 
drop nval
bys countryname hhid: gen nval = _n == 1 

* Table 2: Incidence of undernutrition  
* main numbers			
* proportion of underweight males and females 
foreach num of numlist 0/1 {
tabstat underw [aweight = w] if female == `num' & age15to49 == 1 , by(countryname)
}
* numbers in brackets
* proportion of underweight women and children who live in households by male head nutritional status
foreach num of numlist 1/0 {
tabstat underw [aweight = w] if female == 1 & age15to49 == 1 & head_underw == `num' , by(countryname) 
foreach x of numlist 0/1 {
tabstat stunted  [aweight = w] if head_underw == `num' & female == `x', by(countryname) 
tabstat wasted  [aweight = w] if head_underw == `num' & female == `x', by(countryname) 
}
}

** variance in undernutrition within househols 
gen undernour = 0 
replace undernour = 1 if underw == 1 | stunted == 1 | wasted == 1 
label var undernour "Undernourished all household members"
tabstat undernour [aweight = hh_w] if nval == 1, by(countryname) f(%9.3g)

*** Estimating the impact of intra-household inequality on conditional probabilities
* use continuous variables for intrahh inequality, assign all members of the household the same value of bmi, height-for-age, weight-for-heigt

** mean of cont vars within the household
egen mean_bmi_hh = wtmean(bmi) if age15to49 == 1 , by(countryname hhid) weight(w)
egen mean_stunt_hh = wtmean(heightage_ch) if heightage_ch != . , by(countryname hhid) weight(w)
egen mean_wast_hh = wtmean(weightheight_ch) if weightheight_ch != . , by(countryname hhid) weight(w)

*  checking that means equal 
tabstat  mean_bmi_hh bmi if age15to49 == 1  [aweight = w], by(countryname)
tabstat  mean_stunt_hh heightage_ch if heightage_ch != . [aweight = w], by(countryname)
tabstat  mean_wast_hh weightheight_ch if weightheight_ch != . [aweight = w], by(countryname)

* new values - assigning all members the same as household average
gen underw_new = 0 if mean_bmi_hh > 18.5 & bmi != . & age15to49 == 1 
replace underw_new = 1 if mean_bmi_hh <= 18.5 & bmi != . & age15to49 == 1 
gen stunted_new = 0 if mean_stunt_hh > -2 & heightage_ch != . 
replace stunted_new = 1 if mean_stunt_hh <= -2 & heightage_ch != . 
gen wasted_new = 0 if mean_wast_hh > -2 & weightheight_ch != . 
replace wasted_new = 1 if mean_wast_hh <= -2 & weightheight_ch != . 

* these are super unequal
tabstat underw underw_new  if age15to49 == 1 [aweight = w], by(countryname)
tabstat stunted stunted_new if heightage_ch != . [aweight = w], by(countryname)
tabstat wasted wasted_new  if weightheight_ch != . [aweight = w], by(countryname)


*** use different cut off point to make the mean undernourished equal. 
* used trial and error to find this point

gen cutoff_bmi = 18.5 
gen cutoff_stunt = -2 

* country means
egen mean_underw = wtmean(underw) if age15to49 == 1 , by(countryname) weight(w)
egen mean_stunt = wtmean(stunted) if heightage_ch != . , by(countryname) weight(w)
egen mean_wast = wtmean(wasted) if weightheight_ch != . , by(countryname) weight(w)

foreach num of numlist 50/60 {

gen underw_`num' = 0 if mean_bmi_hh > cutoff_bmi + `num'/50 & bmi != . & age15to49 == 1 
replace underw_`num' = 1 if mean_bmi_hh <= cutoff_bmi + `num'/50 & bmi != . & age15to49 == 1 
gen stunted_`num' = 0 if mean_stunt_hh > cutoff_stunt + `num'/50 & heightage_ch != . 
replace stunted_`num' = 1 if mean_stunt_hh <= cutoff_stunt + `num'/50 & heightage_ch != . 
gen wasted_`num' = 0 if mean_wast_hh > cutoff_stunt + `num'/50 & weightheight_ch != . 
replace wasted_`num' = 1 if mean_wast_hh <= cutoff_stunt + `num'/50 & weightheight_ch != . 

egen underw_bar_`num' = mean(underw_`num') if underw_`num' != ., by(countryname)
egen stunted_bar_`num' = mean(stunted_`num') if stunted_`num' != ., by(countryname)
egen wasted_bar_`num' = mean(wasted_`num') if wasted_`num' != ., by(countryname)

gen underw_diff_`num' = underw_bar_`num' - mean_underw
gen stunted_diff_`num' = stunted_bar_`num' - mean_stunt
gen wasted_diff_`num' = wasted_bar_`num' - mean_wast

drop underw_`num' stunted_`num' wasted_`num' underw_bar_`num' stunted_bar_`num' wasted_bar_`num' 
}


order underw_diff_*, last
order stunted_diff_*, last 
order wasted_diff_*, last 

tabstat underw_diff_* [aweight = w], by(countryname)
tabstat stunted_diff_* [aweight = w], by(countryname)
tabstat wasted_diff_* [aweight = w], by(countryname)

drop underw_diff_*  stunted_diff_* wasted_diff_*


gen cutoff_underw_new = . 
replace cutoff_underw_new = cutoff_bmi + 1/50 if countryname == "Ethiopia" 
replace cutoff_underw_new = cutoff_bmi + 21/50 if countryname == "Ghana" 
replace cutoff_underw_new = cutoff_bmi + 28/50 if countryname == "Lesotho" 
replace cutoff_underw_new = cutoff_bmi + 41/50 if countryname == "Namibia" 
replace cutoff_underw_new = cutoff_bmi + 22/50 if countryname == "Rwanda" 
replace cutoff_underw_new = cutoff_bmi + 56/50 if countryname == "Senegal" 
replace cutoff_underw_new = cutoff_bmi + 34/50 if countryname == "SierraLeone" 

gen cutoff_stunt_new = . 
replace cutoff_stunt_new = cutoff_stunt + 12/50 if countryname == "Ethiopia" 
replace cutoff_stunt_new = cutoff_stunt + 4/50 if countryname == "Ghana" 
replace cutoff_stunt_new = cutoff_stunt + 6/50 if countryname == "Lesotho" 
replace cutoff_stunt_new = cutoff_stunt + 8/50 if countryname == "Namibia" 
replace cutoff_stunt_new = cutoff_stunt + 4/50 if countryname == "Rwanda" 
replace cutoff_stunt_new = cutoff_stunt + 20/50 if countryname == "Senegal" 
replace cutoff_stunt_new = cutoff_stunt + 15/50 if countryname == "SierraLeone" 

gen cutoff_wast_new = . 
replace cutoff_wast_new = cutoff_stunt + 6/50 if countryname == "Ethiopia" 
replace cutoff_wast_new = cutoff_stunt + 12/50 if countryname == "Ghana" 
replace cutoff_wast_new = cutoff_stunt + 7/50 if countryname == "Lesotho" 
replace cutoff_wast_new = cutoff_stunt + 12/50 if countryname == "Namibia" 
replace cutoff_wast_new = cutoff_stunt + 11/50 if countryname == "Rwanda" 
replace cutoff_wast_new = cutoff_stunt + 22/50 if countryname == "Senegal" 
replace cutoff_wast_new = cutoff_stunt + 19/50 if countryname == "SierraLeone" 


* new cutoff values & measures of undernourished
* new values - assigning all members the same as household average
gen underw_newcutoff = 0 if mean_bmi_hh > cutoff_underw_new & bmi != . & age15to49 == 1 
replace underw_newcutoff = 1 if mean_bmi_hh <= cutoff_underw_new & bmi != . & age15to49 == 1 
gen stunted_newcutoff = 0 if mean_stunt_hh > cutoff_stunt_new & heightage_ch != . 
replace stunted_newcutoff = 1 if mean_stunt_hh <= cutoff_stunt_new & heightage_ch != . 
gen wasted_newcutoff = 0 if mean_wast_hh > cutoff_wast_new & weightheight_ch != . 
replace wasted_newcutoff = 1 if mean_wast_hh <= cutoff_wast_new & weightheight_ch != . 

* these are closer, but not exact
tabstat underw underw_new underw_newcutoff if age15to49 == 1  [aweight = w], by(countryname)
tabstat stunted stunted_new stunted_newcutoff if heightage_ch != . [aweight = w], by(countryname)
tabstat wasted wasted_new wasted_newcutoff if weightheight_ch != . [aweight = w], by(countryname)


*** conditional probability tables with no intrahousehold inequality 

**** Household level percentiles 
gen wealth_percentile_hh = . 
local country `" "Ethiopia"  "Ghana" "Lesotho"  "Namibia" "Rwanda" "Senegal"  "SierraLeone" "' 
foreach x of local country{ 
xtile percentile_`x' = wealth_index  [aweight=hh_w]  if countryname == "`x'" & nval == 1 , n(100) 
egen wealth1_`x' = max(percentile_`x') if countryname == "`x'", by(hid)
replace  wealth_percentile_hh = wealth1_`x' if countryname == "`x'"
drop percentile_`x' wealth1_`x'
}
local nums `" "20" "40" "'
foreach num of local nums{
gen wealth_hh_`num' = 0 
replace wealth_hh_`num' = 1 if wealth_percentile_hh <= `num' 
label var wealth_hh_`num' "Wealth index in bottom `num' percent"
}


* conditional probs 
gen woman = 1 if female == 1 & age15to49 == 1 & bmi != . 
replace woman = 0 if age <= 5  & heightage_ch != . 

local names `" "_hh_"  "'
foreach y of local names {
local vars underw underw_new underw_newcutoff
foreach var of local vars {
local nums `" "20" "40"  "'
foreach num of local nums{
gen underw`num' = 0 
replace underw`num' = 1 if wealth`y'`num' == 1 & `var' == 1 & woman == 1
bys country: egen e1_`var'`y'`num' = wtmean(underw`num') if `var' == 1 & woman == 1 , weight(w) 
drop underw`num' 
}
}
local vars stunted stunted_new stunted_newcutoff wasted wasted_new wasted_newcutoff
foreach var of local vars {
local nums `" "20" "40"  "'
foreach num of local nums{
gen `var'`num' = 0 
replace `var'`num' = 1 if wealth`y'`num' == 1 & `var' == 1 & woman == 0
bys country: egen e1_`var'`y'`num' = wtmean(`var'`num') if `var' == 1 & woman == 0 , weight(w) 
drop `var'`num' 
}
}
}

* Table 7
local names `" "_hh_"  "'
foreach y of local names {
tabstat e1_underw`y'20 e1_underw_new`y'20 e1_underw_newcutoff`y'20 e1_underw`y'40 e1_underw_new`y'40 e1_underw_newcutoff`y'40 if woman == 1 [aweight=w], by(countryname)
tabstat e1_stunted`y'20 e1_stunted_new`y'20 e1_stunted_newcutoff`y'20  e1_stunted`y'40 e1_stunted_new`y'40 e1_stunted_newcutoff`y'40 if woman == 0 [aweight=w], by(countryname)
tabstat e1_wasted`y'20 e1_wasted_new`y'20 e1_wasted_newcutoff`y'20  e1_wasted`y'40 e1_wasted_new`y'40 e1_wasted_newcutoff`y'40 if woman == 0 [aweight=w], by(countryname)
}


