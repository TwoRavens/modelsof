 /***************************************************************************** 
	Most of Africa’s Nutritionally-Deprived Women and Children are Not Found in Poor Households 

	Version for R.E. Stat
	
	DHS Data 
	
	Variables for women and children are constructed using separate do files. 
	These datasets are appended to the file all_individuals_clean.dta
	Each woman and child has a separate row. The following analysis is run and 
	saved in all_individuals.dta
	Please contact Cait Brown for do files to construct the all_individuals_clean.dta
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

// Set path here				

//****** Set path here ****/
		
cd ""




/********************** Data cleaning & creating new variables  ***************/ 

use "all_individuals_clean.dta", clear

tab age if woman == 1
drop if age > 49 & woman == 1
// dropped 822 obs. 

* dropped Chad & Saotome. Also dropped Comoros & Madagascar because they're islands. 
drop if countryname == "Chad" | countryname == "Comoros" | countryname == "SaoTome" | countryname == "Madagascar"

* ethiopia's year says 2003? 
replace year = 2011 if countryname == "Ethiopia" 

* check countries aren't missing weights
tab country if missing(w)
tab country if missing(clust) 
tab country if missing(hh_w)
tab country if missing(ch_w) & woman == 0 

** Variables for the augmented regressions
egen age_cat = cut(age), at(15,20,25,30,35,40,45,50)
label var age_cat "Age categories"
egen age_head_cat = cut(agehd), at(15,20,25,30,35,40,45,50,55,60,65,70)
replace age_head_cat = 70 if agehd >=70 & agehd != . 
replace age_head_cat = 15 if agehd <= 15 & agehd != .
label var age_head_cat "Age of head categories"
egen hhsize_cat = cut(hhsize_dejure), at(1,3,5,7,9)
replace hhsize_cat = 9 if hhsize_dejure >=9 
label var hhsize_cat "Household size categories"
egen edu_head_years_cat = cut(eduyrshd), at(0,2,4,6,8,10,12,16,18)
replace edu_head_years_cat = 18 if eduyrshd >=18
label var edu_head_years_cat "Head years of education categories"
egen edu_years_cat = cut(eduyrs), at(0,2,4,6,8,10,12,16,18)
replace edu_years_cat = 18 if eduyrs >=18
label var edu_years_cat "Head Years of education categories"
gen  ever_married_head = 0
replace  ever_married_head = 1 if nevermarhh == 0 
label var  ever_married_head "Head is ever married"
gen  female_head_widow = 0 
replace female_head_widow = 1 if femhd == 1 & widhdhh == 1 
label var female_head_widow "Female head is widowed" 
gen  female_head_div = 0 
replace female_head_div = 1 if femhd == 1 & divhdhh == 1 
label var female_head_div "Female head is divorced or separated" 
gen  female_head_nevermar = 0 
replace female_head_nevermar = 1 if femhd == 1 & nevermarhh == 1 
label var female_head_nevermar "Female head is never married" 


* Some countries have missing values for variables used in the augmented regression. 
replace telephone = 0 if countryname == "Liberia"
replace land = 0 if countryname == "Liberia"
replace num_goats =  0 if countryname == "Tanzania" 
replace num_sheep =  0 if countryname == "Tanzania" 
replace widhdhh = 0 if countryname == "Malawi" 
replace nevermarhh = 0 if countryname == "Malawi"
replace marhd = 0 if countryname == "Malawi" 
replace ever_married_head = 0 if countryname == "Malawi"
replace muslim = 0 if countryname == "Niger" | countryname == "Tanzania" 
replace christian = 0 if countryname == "Niger"  | countryname == "Tanzania" 
replace fuel_elecgas = 0 if missing(fuel_elecgas) & countryname == "Senegal"
replace fuel_coalchar = 0 if missing(fuel_coalchar) & countryname == "Senegal"

local vars share_05f share_05m share_614f share_614m share_1564f share_1564m share_65plusf share_65plusm
foreach var of local vars { 
replace `var' = 0 if missing(`var')
}

* drop observations with missing values for nutritional outcomes
drop if missing(bmi) & woman == 1
// 128,973 observations dropped
drop if missing(weightheight_ch) & woman == 0 
//dropped 113,414 obs
drop if missing(heightage_ch) & woman == 0 
//dropped 1,603 obs 
drop if missing(wealth_index) 
// 0 dropped

save "all_individuals.dta", replace

** Adding in country specific poverty rates.
use "CountryStats.dta", clear 
rename Countryname countryname
merge m:m countryname using  "all_individuals.dta"
drop if _merge == 1 
drop _merge 
order GDP_2011-Access_Impr_Sanitation, last 
sort countryname hid pid 

bys countryname: sum Pov_rate 

save "all_individuals.dta", replace



/****************************  Descriptive Statistics ************************/ 

use "all_individuals.dta", clear

* Table A1: Countries and Years 
tab countryname woman if pregnant != 1, missing 

* Table A2: Number and incidence of pregnant women
// number of pregnant women
tabstat pregnant if pregnant == 1 & woman == 1 [aweight=w] , by(countryname) format(%9.3g) stat(n) missing 
// porportion of pregnant women
tabstat pregnant if woman == 1 [aweight=w] , by(countryname) format(%9.3g) stat(mean) missing 

* drop pregnant women because they aren't included in further analysis 
drop if pregnant == 1
// dropped 23,199 obs
 
* Table 1: Summary statistics for undernutrition
tabstat underw  if woman == 1 [aweight=w] , by(countryname) format(%9.3g) missing
local vars stunted wasted 
foreach var of local vars{ 
foreach num of numlist 0/1{ 
tabstat `var'  if woman == 0 & female_ch == `num' [aweight=w] , by(countryname) format(%9.3g) missing 
}
}
tabstat stunted wasted  if woman == 0 [aweight=w] , by(countryname) format(%9.3g) missing 

* In text p. 13: cross country correlations 
egen mean_underw1 = wtmean(underw) if woman == 1, by(countryname) weight(w)
egen mean_underw = max(mean_underw1), by(countryname) 
drop mean_underw1
local vars stunted wasted 
foreach var of local vars{
egen mean_`var'1 = wtmean(`var') if woman == 0, by(countryname) weight(w)
egen mean_`var' = max(mean_`var'1), by(countryname) 
drop mean_`var'1
}
bys countryname: gen nval = _n == 1 
pwcorr mean_underw mean_stunted if nval == 1, sig obs
pwcorr mean_underw mean_wasted if nval == 1 , sig obs


* In text p. 14 - poverty rate for SSA, not weighted just at country level
tabstat GDP_2011 Pov_rate FLR Access_Impr_Water Access_Impr_Sanitation, by(countryname) missing
tab countryname Pov_year if nval == 1
drop nval 
save "all_individuals.dta", replace
 
 

/*********************************** Analysis  ********************************/

**** Household level percentiles 
bys countryname hid: gen nval = _n == 1 

gen wealth_percentile_hh = . 
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"  "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
xtile percentile_`x' = wealth_index  [aweight=hh_w]  if countryname == "`x'" & nval == 1 , n(100) 
egen wealth1_`x' = max(percentile_`x') if countryname == "`x'", by(hid)
replace  wealth_percentile_hh = wealth1_`x' if countryname == "`x'"
drop percentile_`x' wealth1_`x'
}


**** Individual level percentiles - for the demographically weighted results
gen wealth_percentile_i = . 
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"  "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
xtile percentile_`x' = wealth_index  [aweight=w] if countryname == "`x'" &  woman == 1, n(100) 
replace  wealth_percentile_i = percentile_`x' if countryname == "`x'" & woman == 1
drop percentile_`x'
}

local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
xtile percentile_`x' = wealth_index [aweight=ch_w] if countryname == "`x'" &  woman == 0, n(100) 
replace  wealth_percentile_i = percentile_`x' if countryname == "`x'" & woman == 0
drop percentile_`x'
}


** creating indicator for wealth poor
local names `" "hh" "i" "'
local nums `" "20" "40" "'
foreach x of local names{
foreach num of local nums{
gen wealth_`x'_`num' = 0 
replace wealth_`x'_`num' = 1 if wealth_percentile_`x' <= `num' 
label var wealth_`x'_`num' "Wealth index in bottom `num' percent"
}
gen wealth_`x'_pov = 0 
replace wealth_`x'_pov = 1 if wealth_percentile_`x' <= Pov_rate 
label var wealth_`x'_pov "Wealth index below poverty rate" 
}

tabstat wealth_hh_20 wealth_hh_40 wealth_hh_pov Pov_rate if nval == 1 [aweight=hh_w], by(countryname)
tabstat wealth_i_20 wealth_i_40 wealth_i_pov Pov_rate  [aweight=w], by(countryname)

drop nval 

***** Lowess and Concentration Curves 
 
** create means with percentiles
local names `" "_hh" "'
foreach y of local names {
gen underw`y'_pc = . 
gen underw20`y'_pc = .
gen stunt`y'_pc = . 
gen wast`y'_pc = . 
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
egen underw_pc1 = mean(100 * underw) if woman == 1 & countryname == "`x'", by(wealth_percentile`y') 
replace underw`y'_pc = underw_pc1 if countryname == "`x'"
egen underw20_pc1 = mean(100 * underw) if woman == 1 & countryname == "`x'" & age >= 20, by(wealth_percentile`y')
replace underw20`y'_pc = underw20_pc1 if countryname == "`x'"
egen stunt_pc1 = mean(100 * stunted) if woman == 0 & countryname == "`x'", by(wealth_percentile`y')  
replace stunt`y'_pc = stunt_pc1 if countryname == "`x'"
egen wast_pc1 = mean(100 * wasted) if woman == 0 & countryname == "`x'", by(wealth_percentile`y') 
replace wast`y'_pc = wast_pc1 if countryname == "`x'"
drop underw_pc1 underw20_pc1 stunt_pc1 wast_pc1
}
}


* Lowess of percent underweight, stunting and wasting on W percentiles
// household percentiles only
local names `" "_hh" "'
foreach y of local names {
bys country wealth_percentile`y' woman: gen nval1 = _n == 1 

local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
lowess underw`y'_pc wealth_percentile`y' if countryname == "`x'" & woman == 1 , gen(underw`y'_pc_`x') nograph
lowess stunt`y'_pc wealth_percentile`y' if countryname == "`x'" & woman == 0 , gen(stunt`y'_pc_`x')  nograph
lowess wast`y'_pc wealth_percentile`y' if countryname == "`x'" & woman == 0 , gen(wast`y'_pc_`x')  nograph
lowess underw20`y'_pc wealth_percentile`y' if countryname == "`x'" & woman == 1 & age >=20 , gen(underw20`y'_pc_`x') nograph 
}
}
drop nval1

* Figure 1: lowess curves 
* creating plots with just the lowess lines. 

local names `" "_hh" "'
foreach y of local names {
bys country wealth_percentile`y' woman: gen nval1 = _n == 1 

* women and children 
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
graph twoway line underw`y'_pc_`x' wealth_percentile`y' if countryname == "`x'" & woman == 1 & nval1 == 1  , lpattern(solid) lcolor(black) lwidth(medium)  || line underw20`y'_pc_`x' wealth_percentile`y' if countryname == "`x'" & woman == 1 & nval1 == 1 , lpattern(shortdash) lcolor(black) lwidth(medium) || line stunt`y'_pc_`x' wealth_percentile`y' if countryname == "`x'" & woman == 0 & nval1 == 1 , lpattern(longdash_dot) lcolor(black) lwidth(medium)  || line wast`y'_pc_`x' wealth_percentile`y'  if countryname == "`x'" & woman == 0 & nval1 == 1 , lpattern("---...") lcolor(black) lwidth(medium) ytitle(Percent Undernourished) xtitle(Wealth Percentile) title("`x'") legend(ring(0) pos(2) cols(1) lab(1 "Underweight All") lab(2 "Underweight 20-49") lab(3 "Stunted") lab(4 "Wasted")  region(style(none))) yscale(range(0 60)) ylabel(0[10]60)  graphregion(color(white)) bgcolor(white) ylabel(,nogrid)
graph save lowess_all20`y'_`x', replace
graph export lowess_all20`y'_`x'.png, replace
drop underw`y'_pc_`x' stunt`y'_pc_`x' wast`y'_pc_`x' underw20`y'_pc_`x'
}
drop nval1
}

* Figure A1: Concentration curves with underweight, stunted and wasted 

local names `" "_hh" "'
foreach y of local names {
gen wealth_percentile`y'1 = wealth_percentile`y' / 100 
bys country wealth_percentile`y' woman: gen nval1 = _n == 1 

local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country {
glcurve underw`y'_pc  if countryname == "`x'" & woman == 1   [aweight = w], sortvar(wealth_percentile`y') glvar(uwy`y'_`x') lorenz replace nograph
glcurve stunt`y'_pc  if countryname == "`x'" & woman == 0   [aweight = w], sortvar(wealth_percentile`y')  glvar(sty`y'_`x') lorenz replace nograph
glcurve wast`y'_pc  if countryname  == "`x'" & woman == 0   [aweight = w], sortvar(wealth_percentile`y')  glvar(way`y'_`x') lorenz replace nograph
}

local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country {
graph twoway line uwy`y'_`x' wealth_percentile`y'1 if countryname == "`x'" & woman == 1 & nval1 == 1, sort lpattern(solid) lcolor(black) lwidth(medium)  || line sty`y'_`x' wealth_percentile`y'1  if countryname == "`x'" & woman == 0 & nval1 == 1, sort lpattern(longdash_dot) lcolor(black) lwidth(medium) || line way`y'_`x' wealth_percentile`y'1  if countryname == "`x'" & woman == 0 & nval1 == 1, sort lpattern("---...") lcolor(black) lwidth(medium) ytitle(Cumulative Share of Undernutrition) xtitle(Wealth Percentile) title("`x'") legend(ring(0) pos(5) cols(1) lab(1 "Underweight") lab(2 "Stunted") lab(3 "Wasted") region(style(none)))  graphregion(color(white)) bgcolor(white) ylabel(,nogrid)
graph save cc`y'_`x' , replace
graph export cc`y'_`x'.png , replace
drop uwy`y'_`x' sty`y'_`x' way`y'_`x'
}
drop nval1 underw`y'_pc stunt`y'_pc wast`y'_pc underw20`y'_pc
}



* Table 4 - elasticies wealth w.r.t nutritional outcomes
 
* rescale BMI so in z-score form 
gen bmi_z = . 
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"     "Malawi" "Mali" "Mozambique"  "Namibia"   "Niger" "Nigeria" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
egen z = std(bmi) if woman == 1 & countryname == "`x'"
replace bmi_z = z if countryname == "`x'"
drop z 
}
label var bmi_z "BMI zscore"

* "elasticities" 
eststo clear
gen elasticity_bmi = . 
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"     "Malawi" "Mali" "Mozambique"  "Namibia"   "Niger" "Nigeria" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
eststo: quietly  reg bmi_z wealth_index if countryname == "`x'" & woman == 1,  vce(cluster clust)
matrix define beta = e(b)
replace elasticity_bmi = beta[1,1] if countryname == "`x'" & woman == 1
matrix drop beta
}
esttab using "results", replace title("`x'")  b(%10.3f) star(* .10 ** .05 *** .01) label se(%9.3f) obslast longtable r2 csv 

eststo clear
local vars heightage_ch weightheight_ch
foreach var of local vars{
gen elasticity_`var' = . 
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"     "Malawi" "Mali" "Mozambique"  "Namibia"  "Niger" "Nigeria"  "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
eststo: quietly  reg `var' wealth_index if countryname == "`x'" & woman == 0,  vce(cluster clust)
matrix define beta = e(b)
replace elasticity_`var' = beta[1,1] if countryname == "`x'" & woman == 0 
matrix drop beta
}
}
esttab using "results", append title("`x'")  b(%10.3f) star(* .10 ** .05 *** .01) label se(%9.3f) obslast longtable r2 csv 


* Table A4: elasticies separately for boys and girls 
* separately for boys and girls 
eststo clear
local vars heightage_ch weightheight_ch
foreach var of local vars{
gen elasticity_g_`var' = . 
foreach num of numlist 0/1{
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"     "Malawi" "Mali" "Mozambique"  "Namibia"  "Niger" "Nigeria"  "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
eststo: quietly  reg `var' wealth_index if countryname == "`x'" & woman == 0 & female_ch == `num',  vce(cluster clust)
matrix define beta = e(b)
replace elasticity_g_`var' = beta[1,1] if countryname == "`x'" & woman == 0 & female_ch == `num'
matrix drop beta
}
}
}
esttab using "results", append title("`x'")  b(%10.3f) star(* .10 ** .05 *** .01) label se(%9.3f) obslast longtable r2 csv 
eststo clear


******  Calculating conditional & joint probabilities 

* conditional probabilities: of the underweight, who falls in the bottom 20 percent of wealth? 

* household & individual level probabilities
local names `" "_hh_" "_i_" "'
foreach y of local names {
local nums `" "20" "40" "'
foreach num of local nums{
gen underw`num' = 0 
replace underw`num' = 1 if wealth`y'`num' == 1 & underw == 1 & woman == 1
bys country: egen e1_underw`y'`num' = wtmean(underw`num') if underw == 1 & woman == 1 , weight(w) 
drop underw`num' 
}

local vars stunted wasted 
foreach var of local vars {
local nums `" "20" "40" "'
foreach num of local nums{
gen `var'`num' = 0 
replace `var'`num' = 1 if wealth`y'`num' == 1 & `var' == 1 & woman == 0
bys country: egen e1_`var'`y'`num' = wtmean(`var'`num') if `var' == 1 & woman == 0 , weight(ch_w) 
drop `var'`num' 
}
}
}

* Table 4
local names `" "_hh_" "'
foreach y of local names {
tabstat e1_underw`y'20 e1_underw`y'40 if woman == 1 [aweight=w], by(countryname) format(%9.3g)
tabstat e1_stunted`y'20 e1_wasted`y'20  e1_stunted`y'40 e1_wasted`y'40 if woman == 0 [aweight=ch_w], by(countryname) format(%9.3g)
}

* Table A5 
* reverse conditional probabilities 

* household & individual level probabilities
local names `" "_hh_" "'
foreach y of local names {
local nums `" "20" "40" "'
foreach num of local nums{
gen underw`num' = 0 
replace underw`num' = 1 if wealth`y'`num' == 1 & underw == 1 & woman == 1
bys country: egen r1_underw`y'`num' = wtmean(underw`num') if wealth`y'`num' == 1 & woman == 1 , weight(w) 
drop underw`num' 
}

local vars stunted wasted 
foreach var of local vars {
local nums `" "20" "40" "'
foreach num of local nums{
gen `var'`num' = 0 
replace `var'`num' = 1 if wealth`y'`num' == 1 & `var' == 1 & woman == 0
bys country: egen r1_`var'`y'`num' = wtmean(`var'`num') if wealth`y'`num' == 1 & woman == 0 , weight(ch_w) 
drop `var'`num' 
}
}
}

* Table 4
local names `" "_hh_" "'
foreach y of local names {
tabstat r1_underw`y'20 r1_underw`y'40 if woman == 1 [aweight=w], by(countryname) format(%9.3g)
tabstat r1_stunted`y'20 r1_wasted`y'20  r1_stunted`y'40 r1_wasted`y'40 if woman == 0 [aweight=ch_w], by(countryname) format(%9.3g)
}




** Conditional probabilities  by gender 
local vars stunted wasted 
foreach var of local vars {
local nums `" "20" "40" "'
foreach num of local nums{
gen e1_`var'_hh_g_`num' = .
foreach x of numlist 0/1 {
gen `var'`num' = 0 
replace `var'`num' = 1 if wealth_hh_`num' == 1 & `var' == 1 & woman == 0 & female_ch == `x'
bys country: egen e1_`var'`num' = wtmean(`var'`num') if `var' == 1 & woman == 0 & female_ch == `x', weight(ch_w) 
replace e1_`var'_hh_g_`num' = e1_`var'`num' if `var' == 1 & woman == 0 & female_ch == `x'
drop `var'`num' e1_`var'`num'
}
}
}

* Table A6
foreach x of numlist 0/1 {
tabstat e1_stunted_hh_g_20 e1_wasted_hh_g_20  e1_stunted_hh_g_40 e1_wasted_hh_g_40 if woman == 0 & female_ch == `x' [aweight=ch_w], by(countryname) format(%9.3g)
}



** Conditional probabilities for severely underweight stunted and wasted
* severe stunted and wasted as -3

* cond 
local names `" "_hh_"  "'
foreach y of local names {
*children
local vars sevstunted sevwasted 
foreach var of local vars {
local nums `" "20" "40" "'
foreach num of local nums{
gen `var'`num' = 0 
replace `var'`num' = 1 if wealth`y'`num' == 1 & `var' == 1 & woman == 0
bys country: egen e1_`var'`y'`num' = wtmean(`var'`num') if `var' == 1 & woman == 0 , weight(ch_w) 
drop `var'`num' 
}
}
}

* Table A7
local names `" "_hh_" "'
foreach y of local names {
tabstat e1_sevstunted`y'20 e1_sevwasted`y'20  e1_sevstunted`y'40 e1_sevwasted`y'40  if woman == 0 [aweight=ch_w], by(countryname) format(%9.3g)
}

* In text p. 17: correlation coefficients  for conditional probabilities
local names `" "_hh_"  "'
foreach y of local names {

local vars `" "underw" "stunted" "wasted" "'
foreach var of local vars {

local nums `" "20" "40" "'
foreach num of local nums {
egen e1_`var'`y'`num'_max = max(e1_`var'`y'`num'), by(countryname)

}
}
}



** joint probabilies - probability of undernourished and poor 
local names `" "_hh_" "_i_" "'
foreach y of local names {

local nums `" "20" "40"  "'
foreach num of local nums{
gen underw`num' = 0 
replace underw`num' = 1 if wealth`y'`num' == 1 & underw == 1 & woman == 1
bys country: egen joint`y'underw`num' = wtmean(underw`num') if  woman == 1 , weight(w) 
drop underw`num'
}

local vars stunted wasted 
foreach var of local vars {
local nums `" "20" "40"  "'
foreach num of local nums{
gen `var'`num' = 0 
replace `var'`num' = 1 if wealth`y'`num' == 1 & `var' == 1 & woman == 0
bys country: egen joint`y'`var'`num' = wtmean(`var'`num') if  woman == 0 , weight(ch_w) 
drop `var'`num' 
}
}
}


* Table A8 for full values, summary in Table 6 
local names `" "_hh_"  "' 
foreach y of local names {
tabstat joint`y'underw20 joint`y'underw40  if woman == 1 [aweight=w], by(countryname) format(%9.3g)
tabstat  joint`y'stunted20 joint`y'wasted20 joint`y'stunted40 joint`y'wasted40  if woman == 0 [aweight=ch_w], by(countryname) format(%9.3g)
}


* correlation coefficients - joint and incidence of being underweight at the country level. 
bys countryname: gen nval = _n == 1 
//rate of undernutrition 
egen underw_r = wtmean(underw) if woman == 1, by(countryname) weight(w)
egen underw_rate = max(underw_r), by(countryname)
drop underw_r
egen stunted_r = wtmean(stunted) if woman == 0, by(countryname) weight(ch_w)
egen stunted_rate = max(stunted_r), by(countryname)
drop stunted_r
egen wasted_r = wtmean(wasted) if woman == 0, by(countryname) weight(ch_w)
egen wasted_rate = max(wasted_r), by(countryname)
drop wasted_r

tabstat underw_rate stunted_rate wasted_rate if nval == 1, by(countryname)

* Table 6, row 2
local names `" "_hh_"  "'
foreach y of local names {
local nums `" "20" "40" "'
foreach num of local nums {
local vars `" "underw" "stunted" "wasted" "'
foreach var of local vars {
egen joint`y'`var'`num'_max = max(joint`y'`var'`num'), by(countryname)
pwcorr joint`y'`var'`num'_max `var'_rate if nval == 1
drop joint`y'`var'`num'_max
}
}
}

* elasticities of joint to marginals 
local vars `" "underw" "stunted" "wasted" "'
foreach var of local vars {
gen l`var'_rate = log(`var'_rate)
}

local names `" "_hh_"  "'
foreach y of local names {

local vars `" "underw" "stunted" "wasted" "'
foreach var of local vars {

local nums `" "20" "40" "'
foreach num of local nums {
egen joint`y'`var'`num'_max = max(joint`y'`var'`num'), by(countryname)
gen ljoint`y'`var'`num'_max = log(joint`y'`var'`num'_max)
eststo: quietly reg  ljoint`y'`var'`num'_max  l`var'_rate  if nval == 1
drop joint`y'`var'`num'_max  ljoint`y'`var'`num'_max
}
}
}
esttab using "results", replace title("`x'")  b(%10.3f) star(* .10 ** .05 *** .01) label se(%9.3f) obslast longtable r2 csv 
eststo clear
drop lunderw_rate lstunted_rate lwasted_rate


** Results for demographically balanced wealth distribution 
* Table A8
local names `" "_i_" "'
foreach y of local names {
tabstat e1_underw`y'20 e1_underw`y'40 if woman == 1 [aweight=w], by(countryname) format(%9.3g)
tabstat e1_stunted`y'20 e1_wasted`y'20  e1_stunted`y'40 e1_wasted`y'40 if woman == 0 [aweight=ch_w], by(countryname) format(%9.3g)
}

** Results for demographically balanced joint probs 
* Table A9 
local names `" "_i_"  "' 
foreach y of local names {
tabstat joint`y'underw20 joint`y'underw40  if woman == 1 [aweight=w], by(countryname) format(%9.3g)
tabstat  joint`y'stunted20 joint`y'wasted20 joint`y'stunted40 joint`y'wasted40  if woman == 0 [aweight=ch_w], by(countryname) format(%9.3g)
}


*** Measurement error in nutritional outcomes 

* Conditional probabilities for children over 18 months 
gen under18mth = 0 if woman == 0 
replace under18mth = 1 if age_month_ch < 18 & woman == 0 

local names `" "_hh_" "'
foreach y of local names {
local vars stunted wasted 
local nums `" "20" "40"  "'
foreach var of local vars {
foreach num of local nums {
gen `var'`num' = 0 
replace `var'`num' = 1 if wealth`y'`num' == 1 & `var' == 1 & woman == 0 & under18mth != 1 
bys country: egen e1_`var'`y'`num'_o18 = wtmean(`var'`num') if `var' == 1 & woman == 0  & under18mth != 1 , weight(ch_w) 
drop `var'`num'  
}
}
}

* Table A10
tabstat e1_stunted_hh_20_o18 e1_wasted_hh_20_o18 e1_stunted_hh_40_o18 e1_wasted_hh_40_o18    if woman == 0  & under18mth != 1 [aweight=ch_w], by(countryname)


* Correlation tables with undernourished women and children
// are kids more likely to be undernourished if their mothers are - break this down by gender
** fix BMI 
gen mother_bmi1 = mother_bmi / 100 
sum mother_bmi1
//drop outliers - missing recoded as 9999 
replace mother_bmi1 = . if mother_bmi1 < 12 | mother_bmi1 > 60
// 836 missing
gen mother_underw = 0 if mother_bmi1 != . 
replace mother_underw = 1 if mother_bmi1 < 18.5 & mother_bmi1 != . 
label var mother_underw "Mother is underweight" 
// No senegal - 29 countries 

* Table A11 
eststo clear
local vars heightage_ch weightheight_ch
foreach var of local vars {
* by gender
foreach num of numlist 0/1 {
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Malawi"  "Mali" "Mozambique"  "Namibia"  "Niger" "Nigeria"  "Rwanda"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
eststo: quietly reg  mother_underw  `var' [aweight = ch_w] if female_ch == `num' & countryname == "`x'", nocons  vce(cluster clust)
}
esttab using "results", append title("`x'")  b(%10.3f) star(* .10 ** .05 *** .01) label se(%9.3f) obslast longtable r2 csv 
eststo clear
}
* total
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Malawi"  "Mali" "Mozambique"  "Namibia"  "Niger" "Nigeria"  "Rwanda"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
eststo: quietly reg  mother_underw  `var' [aweight = ch_w]  if countryname == "`x'", nocons  vce(cluster clust)
}
esttab using "results", append title("`x'")  b(%10.3f) star(* .10 ** .05 *** .01) label se(%9.3f) obslast longtable r2 csv 
eststo clear
}


* Table A12
* correlations between child nutrition and mother underweight 

matrix drop _all
* by gender
foreach num of numlist 0/1 {
local vars heightage_ch weightheight_ch
foreach var of local vars {
matrix r_`num'_`var' = 1
matrix s_`num'_`var' = 1
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Malawi"  "Mali" "Mozambique"  "Namibia"  "Niger" "Nigeria"  "Rwanda"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
quietly pwcorr `var' mother_bmi1 [aweight = ch_w] if countryname == "`x'" & female_ch == `num', sig
matrix r = r(rho)
matrix r_`num'_`var' = r_`num'_`var' \ r 
matrix drop r 
matrix s1 = r(sig)
matrix s = s1[2,1]
matrix s_`num'_`var' = s_`num'_`var' \ s
matrix drop s s1
}
}
}
* total 
foreach var of local vars {
matrix r_`var' = 1
matrix s_`var' = 1
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Malawi"  "Mali" "Mozambique"  "Namibia"  "Niger" "Nigeria"  "Rwanda"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
quietly pwcorr `var' mother_bmi1 [aweight = ch_w] if countryname == "`x'" , sig
matrix r = r(rho)
matrix r_`var' = r_`var' \ r 
matrix drop r 
matrix s1 = r(sig)
matrix s = s1[2,1]
matrix s_`var' = s_`var' \ s
matrix drop s s1
}
}
matrix r_all = r_0_heightage_ch, r_0_weightheight_ch , r_1_heightage_ch, r_1_weightheight_ch, r_heightage_ch, r_weightheight_ch
matrix list r_all
matrix s_all = s_0_heightage_ch, s_0_weightheight_ch , s_1_heightage_ch, s_1_weightheight_ch, s_heightage_ch, s_weightheight_ch
matrix list s_all



** Common health risks - incidence curves regarding diarrhea and blood in stool 
** create means with percentiles
local names `" "_hh" "'
foreach y of local names {
local vars `" diarrhea blood_st fever "'
foreach var of local vars {
gen `var'`y'_pc = . 
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
egen `var'_pc1 = mean(100 * `var') if woman == 0 & countryname == "`x'", by(wealth_percentile`y') 
replace `var'`y'_pc = `var'_pc1 if countryname == "`x'"
drop `var'_pc1
}
}
}
* lowess lines 
local names `" "_hh"  "'
foreach y of local names {
bys country wealth_percentile`y' woman: gen nval1 = _n == 1 
local vars diarrhea blood_st fever
foreach var of local vars {
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"   "Madagascar"  "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania"  "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
lowess `var'`y'_pc wealth_percentile`y' if countryname == "`x'" & woman == 0 , gen(`var'`y'_pc_`x') nograph 
}
lowess `var'`y'_pc wealth_percentile`y' if woman == 0 , gen(`var'`y'_pc_all)  
drop `var'`y'_pc
}
drop nval1
}

* Figure A3
* creating plots with just the lowess lines. 
local names `" "_hh" "'
foreach y of local names {
bys country wealth_percentile`y' woman: gen nval1 = _n == 1 
bys wealth_percentile`y' woman: gen nval2 = _n == 1 
graph twoway line diarrhea`y'_pc_all wealth_percentile`y' if woman == 0 & nval2 == 1  , lpattern(solid) lcolor(black) lwidth(medium)  || line blood_st`y'_pc_all wealth_percentile`y' if woman == 0 & nval2 == 1 , lpattern(shortdash) lcolor(black) lwidth(medium) || line fever`y'_pc_all wealth_percentile`y' if woman == 0 & nval2 == 1  , lpattern(longdash_dot) lcolor(black) lwidth(medium)  ytitle(Percent) xtitle(Wealth Percentile) legend(ring(0) pos(2) cols(1) lab(1 "Diarrhea recently") lab(2 "Blood in stool") lab(3 "Fever recently") region(style(none)))  graphregion(color(white)) bgcolor(white) yscale(range(0 60)) ylabel(0[10]60, nogrid)
graph export lowess_health`y'_all.png, replace
drop nval1 nval2
}



*** Augmented regressions with undernourished and components of wealth index

local vars logbmi heightage_ch weightheight_ch
foreach var of local vars {
gen yhat_pmt_`var' = .
label var yhat_pmt_`var' "Predicted with PMT vars"
gen yhat_ind_`var' = . 
label var yhat_ind_`var' "Predicted with indiv vars" 
}

local wealth water_piped water_tubewell toilet_flush toilet_pit  floor_finish  wall_finished roof_finish members_per_room fuel_elecgas fuel_coalchar
local assets  electric radio telev fridge bicycle motorbike car telephone mobile_phone land num_goats num_sheep 
local hh urban  femhd divhdhh widhdhh nevermarhh female_head_widow female_head_div female_head_nevermar  muslim christian   share_05f share_05m share_614f share_614m share_65plusf share_65plusm 
local individ  head widow div_sep husb_occ_agr_int
local child female_ch 

local vars logbmi
foreach var of local vars {
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon" "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"   "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania" "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
quietly  reg `var' wealth_index `wealth' `assets' `hh' i.hhsize_cat i.age_head_cat i.edu_head_years_cat i.region i.month if countryname == "`x'"  & woman == 1, vce(cluster clust)
predict yhat_`x'
replace yhat_pmt_`var' = yhat_`x' if countryname == "`x'"   & woman == 1
drop yhat_`x'
}
}

local vars heightage_ch  weightheight_ch 
foreach var of local vars {
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon" "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"   "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania" "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
quietly  reg `var' wealth_index `wealth' `assets' `hh' i.hhsize_cat i.age_head_cat i.edu_head_years_cat i.region i.month if countryname == "`x'"  & woman == 0, vce(cluster clust)
predict yhat_`x'
replace yhat_pmt_`var' = yhat_`x' if countryname == "`x'"   & woman == 0
drop yhat_`x'
}
}

* with individual level variables 
local vars logbmi 
foreach var of local vars {
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania" "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
quietly  reg `var' wealth_index `wealth' `assets' `hh' `individ' i.hhsize_cat i.age_head_cat i.edu_head_years_cat i.age_cat i.edu_years_cat i.region i.month  if countryname == "`x'"  & woman == 1, vce(cluster clust)
predict yhat_`x'
replace yhat_ind_`var' = yhat_`x' if countryname == "`x'"  & woman == 1
drop yhat_`x'
}
}

local vars heightage_ch weightheight_ch
foreach var of local vars {
local country `"  "Benin" "BurkinaFaso"  "Burundi"  "Cameroon"  "Congo"  "CotedIvoire"   "DRC"   "Ethiopia"  "Gabon" "Gambia" "Ghana"  "Guinea"  "Kenya"  "Lesotho"   "Liberia"    "Mali"  "Malawi" "Mozambique"  "Namibia" "Nigeria"  "Niger" "Rwanda"  "Senegal"  "SierraLeone"  "Swaziland" "Tanzania" "Togo" "Uganda" "Zambia" "Zimbabwe" "'
foreach x of local country{ 
quietly  reg `var' wealth_index `wealth' `assets' `hh' `individ' `child' i.hhsize_cat i.age_head_cat i.edu_head_years_cat i.age_cat i.age_ch i.edu_years_cat i.region i.month  if countryname == "`x'"  & woman == 0, vce(cluster clust)
predict yhat_`x'
replace yhat_ind_`var' = yhat_`x' if countryname == "`x'"  & woman == 0
drop yhat_`x'
}
}

* checking means
local vars logbmi heightage_ch  weightheight_ch
foreach var of local vars {
tabstat `var'  yhat_pmt_`var' yhat_ind_`var' , by(countryname) format(%9.3g)
}

* back to regular bmi 
local vars  yhat_pmt_logbmi yhat_ind_logbmi 
foreach var of local vars { 
gen `var'1 = exp(`var') 
} 

local names `"  "pmt" "ind" "'
foreach y of local names {
gen pr_`y'_logbmi = 0 if woman == 1 & yhat_`y'_logbmi1 != .
replace pr_`y'_logbmi = 1 if yhat_`y'_logbmi1 <= 18.5 & woman == 1 
}

local vars heightage_ch  weightheight_ch 
local names `"  "pmt" "ind" "'
foreach var of local vars {
foreach y of local names {
gen pr_`y'_`var' = 0 if woman == 0 & yhat_`y'_`var' != .
replace pr_`y'_`var' = 1 if yhat_`y'_`var' <= -2 & woman == 0 
}
}

tabstat underw pr_pmt_logbmi pr_ind_logbmi stunted pr_pmt_heightage_ch pr_ind_heightage_ch wasted pr_pmt_weightheight_ch pr_ind_weightheight_ch
// problem is that the predicted values are super low - use the rate method instead
drop pr_pmt_logbmi pr_ind_logbmi pr_pmt_heightage_ch pr_ind_heightage_ch pr_pmt_weightheight_ch pr_ind_weightheight_ch

* Generate percentiles by predicted value, then call underweight as anyone with a percentile below average. 
local vars logbmi 
local names `" "pmt" "ind" "'
foreach var of local vars {
foreach y of local names {
gen pc_`y'_`var' = . 
local countries `" "BJ" "BF" "BU" "CM" "CD" "CG" "CI" "ET" "GA" "GH" "GM" "GN" "KE" "LS" "LB"  "MW" "ML" "MZ" "NM" "NI" "NG" "RW" "SN" "SL" "SZ" "TZ" "TG" "UG" "ZM" "ZW" "'
foreach x of local countries{ 
xtile percentile_`x' = yhat_`y'_`var' [aweight=w] if country == "`x'"  & woman == 1, n(100) 
replace  pc_`y'_`var' = percentile_`x' if country == "`x'" &  woman == 1
drop percentile_`x'
}
replace pc_`y'_`var' = pc_`y'_`var' / 100
} 
}

local vars heightage_ch  weightheight_ch 
local names `"  "pmt" "ind" "'
foreach var of local vars {
foreach y of local names {
gen pc_`y'_`var' = . 
local countries `" "BJ" "BF" "BU" "CM" "CD" "CG" "CI" "ET" "GA" "GH" "GM" "GN" "KE" "LS" "LB"  "MW" "ML" "MZ" "NM" "NI" "NG" "RW" "SN" "SL" "SZ" "TZ" "TG" "UG" "ZM" "ZW" "'
foreach x of local countries{ 
xtile percentile_`x' = yhat_`y'_`var' [aweight=ch_w] if country == "`x'" &  woman == 0, n(100) 
replace  pc_`y'_`var' = percentile_`x' if country == "`x'" &  woman == 0
drop percentile_`x'
}
replace pc_`y'_`var' = pc_`y'_`var' / 100
} 
}
* checking - equal to 0.505
tabstat pc_pmt_logbmi pc_ind_logbmi  pc_pmt_heightage_ch pc_ind_heightage_ch pc_pmt_weightheight_ch pc_ind_weightheight_ch [aweight = w], by(country)

local vars pc_pmt_logbmi pc_ind_logbmi pc_pmt_heightage_ch pc_ind_heightage_ch pc_pmt_weightheight_ch pc_ind_weightheight_ch
foreach var of local vars { 
replace `var' = `var'*100
}


* generating indicator
local names `"  "pmt" "ind" "'
foreach y of local names {
local nums  `"  "20" "40" "'
foreach num of local nums {
local vars logbmi
foreach var of local vars {
gen po`num'_`y'_`var' = 0 if woman == 1 & yhat_`y'_`var' != .
replace po`num'_`y'_`var' = 1 if pc_`y'_`var' <= `num'  & woman == 1 & yhat_`y'_`var' != .
}
local vars heightage_ch weightheight_ch
foreach var of local vars {
gen po`num'_`y'_`var' = 0 if woman == 0 & yhat_`y'_`var' != .
replace po`num'_`y'_`var' = 1 if pc_`y'_`var' <= `num' & woman == 0 & yhat_`y'_`var' != .
}
}
}

* Conditional probabilities - of those in bottom % of pred values, who is underweight 

local names `" "pmt" "ind" "'
foreach y of local names {
local nums  `"  "20" "40" "'
foreach num of local nums {
gen underw`num' = 0 
replace underw`num' = 1 if po`num'_`y'_logbmi == 1 & underw == 1 & woman == 1
bys country: egen cond_`y'_underw`num' = wtmean(underw`num') if underw == 1 & woman == 1 , weight(w) 
drop underw`num'
gen stunt`num' = 0 
replace stunt`num' = 1 if po`num'_`y'_heightage_ch == 1 & stunted == 1 & woman == 0
bys country: egen cond_`y'_stunt`num' = wtmean(stunt`num') if stunted == 1 & woman == 0 , weight(w) 
drop stunt`num'
gen wast`num' = 0 
replace wast`num' = 1 if po`num'_`y'_weightheight_ch == 1 & wasted == 1 & woman == 0
bys country: egen cond_`y'_wast`num' = wtmean(wast`num') if wasted == 1 & woman == 0 , weight(w) 
drop wast`num'
}
}


* Tables A13 and A14
tabstat cond_pmt_underw20 cond_pmt_underw40 cond_ind_underw20 cond_ind_underw40 if woman == 1 [aweight=w], by(countryname)
tabstat cond_pmt_stunt20 cond_pmt_stunt40 cond_ind_stunt20 cond_ind_stunt40 cond_pmt_wast20  cond_pmt_wast40   cond_ind_wast20  cond_ind_wast40 if woman == 0 [aweight=ch_w], by(countryname)

save "all_individuals.dta", replace 

