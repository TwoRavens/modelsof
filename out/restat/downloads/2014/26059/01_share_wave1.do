
********************************************************************************
****** The Effects of WWII on Economic and Health Outcomes across Europe *******
********************************************************************************
* Authors: Iris Kesternich, Bettina Siflinger, James P. Smith, Joachim Winter
* Review of Economics and Statistics, 2014
********************************************************************************
* DOFILE: SHARE WAVE 1 PREP
********************************************************************************


clear
clear matrix
clear mata
set more off


*** define the path to the directory containing the data files here 
*** or leave "." if the do files are in the current directory 

global datapath "."


* module: coverscreen
use "$datapath\basic\sharew1_rel2-5-0_cv_r.dta", clear
keep mergeid hhid country waveid mobirth yrbirth int_year int_month
ren int_year  int_year_w1
ren int_month int_month_w1
sum waveid
sort mergeid hhid country 
save "$datapath\temp\wave1_cv.dta", replace


* module: physical health
preserve
use "$datapath\basic\sharew1_rel2-5-0_ph.dta", clear
keep mergeid hhid country waveid ph003_ ph006d1 ph006d5 ph013_ ph052_* 
ren ph013_ height
sort mergeid hhid country 
save "$datapath\temp\wave1_ph.dta", replace
restore

merge mergeid hhid country using "$datapath\temp\wave1_ph.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid country 
 

* module: demographics
preserve
use "$datapath\basic\sharew1_rel2-5-0_dn.dta", clear
keep mergeid hhid country waveid dn004_ dn014_ dn026_1-dn028_2 
sort mergeid hhid country 
save "$datapath\temp\wave1_dn.dta", replace
restore

merge mergeid hhid country using "$datapath\temp\wave1_dn.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid country 



* module: children section
preserve
use "$datapath\basic\sharew1_rel2-5-0_ch.dta", clear
keep mergeid hhid country waveid /*ch001_*/ ch002_ ch006_* /*ch010_**/
sort mergeid hhid country 
save "$datapath\temp\wave1_ch.dta", replace
restore

merge mergeid hhid country using "$datapath\temp\wave1_ch.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid country



* module: generated variables, ISCED
preserve
use "$datapath\basic\sharew1_rel2-5-0_gv_isced.dta", clear
keep mergeid hhid country iscedy_r 
sort mergeid hhid country 
save "$datapath\temp\wave1_isced.dta", replace
restore

merge mergeid hhid country using "$datapath\temp\wave1_isced.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid country



* module: imputations
preserve
use "$datapath\basic\sharew1_rel2-5-0_imputations.dta", clear
keep mergeid hhid country implicat depress /*depressi*/ hnetwv /*hnetwvi*/ 
sort mergeid hhid country 
keep if implicat == 1
save "$datapath\temp\wave1_imputations.dta", replace
restore

merge mergeid hhid country using "$datapath\temp\wave1_imputations.dta"
tab _m
keep if _m == 3
drop _m implicat
sort mergeid hhid country

gen wave = 1



*** generating and cleaning specific variables

* self-rated health
tab1 ph052 ph003
recode ph052 (-1 -2 = .)
recode ph003 (-1 -2 = .)
replace ph003 = ph052 if ph052 ~= . & ph003 == .
drop ph052 


* age variable
gen birth = yrbirth + (mobirth -1)/12
gen inter = int_year_w1 + (int_month_w1-1)/12
gen age1	  = int(inter - birth)
tab age1
tab1 yrbirth if age1 == 2005 | age1 == 2006 | age1 == 2007
tab1 mobirth if age1 == 2005 | age1 == 2006 | age1 == 2007
gen age = age1
replace age = . if age1 == 2005 | age1 == 2006 | age1 == 2007
drop age1 inter birth int_year_w1 int_month_w1

ren hhid hhid2


drop mobirth yrbirth

save "$datapath\temp\wave1.dta", replace
