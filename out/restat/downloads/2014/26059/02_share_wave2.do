
********************************************************************************
****** The Effects of WWII on Economic and Health Outcomes across Europe *******
********************************************************************************
* Authors: Iris Kesternich, Bettina Siflinger, James P. Smith, Joachim Winter
* Review of Economics and Statistics, 2014
********************************************************************************
* DOFILE: SHARE WAVE 2 PREP
********************************************************************************


clear
clear matrix
clear mata
set more off


*** define the path to the directory containing the data files here 
*** or leave "." if the do files are in the current directory 

global datapath "."


* module: coverscreen
use "$datapath\basic\sharew2_rel2-5-0_cv_r.dta", clear
keep mergeid hhid country waveid mobirth yrbirth int_year_w2 int_month_w2
sum waveid
sort mergeid hhid country 
save "$datapath\temp\wave2_cv.dta", replace


* module: physical health
preserve
use "$datapath\basic\sharew2_rel2-5-0_ph.dta", clear
keep mergeid hhid country waveid ph003_ ph006d1 ph006d5 ph013_ 
ren ph013_ height
sort mergeid hhid country 
save "$datapath\temp\wave2_ph.dta", replace
restore

merge mergeid hhid country using "$datapath\temp\wave2_ph.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid country 
 

* module: demographics
preserve
use "$datapath\basic\sharew2_rel2-5-0_dn.dta", clear
keep mergeid hhid country waveid dn004_ dn014_ dn026_1-dn028_2 dn041_
sort mergeid hhid country 
save "$datapath\temp\wave2_dn.dta", replace
restore

merge mergeid hhid country using "$datapath\temp\wave2_dn.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid country 



* module: well-being
preserve
use "$datapath\basic\sharew2_rel2-5-0_ac.dta", clear
keep mergeid hhid country waveid ac012_  
sort mergeid hhid country 
save "$datapath\temp\wave2_ac.dta", replace
restore

merge mergeid hhid country using "$datapath\temp\wave2_ac.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid country


* module: children section
preserve
use "$datapath\basic\sharew2_rel2-5-0_ch.dta", clear
keep mergeid hhid country waveid /*ch001_*/ ch002_ ch006_* /*ch010_**/
sort mergeid hhid country 
save "$datapath\temp\wave2_ch.dta", replace
restore

merge mergeid hhid country using "$datapath\temp\wave2_ch.dta"
tab _m
keep if _m == 3
drop _m
sort mergeid hhid country



* module: imputations
preserve
use "$datapath\basic\sharew2_rel2-5-0_imputations.dta", clear
keep mergeid hhid country implicat depress /*depressi*/ hnetwv /*hnetwvi*/ 
sort mergeid hhid country 
keep if implicat == 1
save "$datapath\temp\wave2_imputations.dta", replace
restore

merge mergeid hhid country using "$datapath\temp\wave2_imputations.dta"
tab _m
keep if _m == 1 | _m == 3
drop _m implicat
sort mergeid hhid country



*** generating and cleaning specific variables
gen wave = 2


* age variable
gen birth = yrbirth + (mobirth -1)/12
gen inter = int_year_w2 + (int_month_w2-1)/12
gen age1	  = int(inter - birth)

tab age1
tab1 yrbirth if age1 == 2007 | age1 == 2009 
tab1 mobirth if age1 == 2007 | age1 == 2009 
gen age = age1
replace age = . if age1 == 2007 | age1 == 2009 
drop age1 inter birth int_year_w2 int_month_w2

ren hhid hhid2


drop mobirth yrbirth


save "$datapath\temp\wave2.dta", replace
