
********************************************************************************
****** The Effects of WWII on Economic and Health Outcomes across Europe *******
********************************************************************************
* Authors: Iris Kesternich, Bettina Siflinger, James P. Smith, Joachim Winter
* Review of Economics and Statistics, 2014
********************************************************************************
* DOFILE: SHARELIFE PREP
********************************************************************************


clear
clear matrix
clear mata
set more off


*** define the path to the directory containing the data files here 
*** or leave "." if the do files are in the current directory 

global datapath "."



* module: coverscreen
use "$datapath\basic\sharew3_rel1_cv_r.dta", clear
keep mergeid hhid3 country waveid gender mobirth yrbirth int_month_w3 int_year_w3 /*hhsize*/
sort mergeid hhid3 country 
save "$datapath\temp\wave3_cv.dta", replace


* module: partner respondent
preserve
use "$datapath\basic\sharew3_rel1_rp.dta", clear
keep mergeid hhid3 country waveid sl_rp002_
sort mergeid hhid3 country
save "$datapath\temp\wave3_rp.dta", replace
restore

merge mergeid hhid3 country using "$datapath\temp\wave3_rp.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid3 country


* module: accommodation
preserve
use "$datapath\basic\sharew3_rel1_ac.dta", clear
keep mergeid hhid3 country waveid sl_ac017_* sl_ac015c_* sl_ac015_* sl_ac014c_* sl_ac014_* sl_ac006_* sl_ac013_* sl_ac021_*

sort mergeid hhid3 country
save "$datapath\temp\wave3_ac.dta", replace
restore

merge mergeid hhid3 country using "$datapath\temp\wave3_ac.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid3 country



* module: general life questions
preserve
use "$datapath\basic\sharew3_rel1_gl.dta", clear
keep  mergeid hhid3 country waveid  sl_gl014_ sl_gl015_ sl_gl016_ sl_gl022_ sl_gl031_ sl_gl033_* sl_gl035_* /*sl_gl005_ sl_gl006_ sl_gl007_ sl_gl011_ sl_gl012_ sl_gl013_*/
sort mergeid hhid3 country
save "$datapath\temp\wave3_genlife.dta", replace
restore

merge mergeid hhid3 country using "$datapath\temp\wave3_genlife.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid3 country



* module: physical health
preserve
use "$datapath\basic\sharew3_rel1_hs.dta", clear
keep  mergeid hhid3 country waveid sl_ph003_ 
sort mergeid hhid3 country
save "$datapath\temp\wave3_hs.dta", replace
restore

merge mergeid hhid3 country using "$datapath\temp\wave3_hs.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid3 country



* module: childhood SES
preserve
use "$datapath\basic\sharew3_rel1_cs.dta", clear
keep  mergeid hhid3 country waveid sl_cs002_ sl_cs003_ sl_cs004d2 sl_cs007d1-sl_cs009
sort mergeid hhid3 country
save "$datapath\temp\wave3_childhood.dta", replace
restore

merge mergeid hhid3 country using "$datapath\temp\wave3_childhood.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid3 country


* module: health care
preserve
use "$datapath\basic\sharew3_rel1_hc.dta", clear
keep mergeid hhid3 country waveid sl_hc002_
sort mergeid hhid3 country
save "$datapath\temp\wave3_hc.dta", replace
restore

merge mergeid hhid3 country using "$datapath\temp\wave3_hc.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid3 country

gen wave3 = 1




*** generating and cleaning specific variables

* age variable
gen birth = yrbirth + (mobirth -1)/12
gen inter = int_year_w3 + (int_month_w3-1)/12
gen age1	  = int(inter - birth)
tab age1
ren age1 age
drop inter birth






save  "$datapath\temp\wave3_sharelife.dta", replace
