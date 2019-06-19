
********************************************************************************
****** The Effects of WWII on Economic and Health Outcomes across Europe *******
********************************************************************************
* Authors: Iris Kesternich, Bettina Siflinger, James P. Smith, Joachim Winter
* Review of Economics and Statistics, 2014
********************************************************************************
* DOFILE: MERGES SHARE DATA, WAVES 1-3
********************************************************************************


clear
clear matrix
clear mata
set more off


*** define the path to the directory containing the data files here 
*** or leave "." if the do files are in the current directory 

global datapath "."


********************************************************************************
*** MERGE SHARE DATA: WAVE 1, WAVE 2, WAVE 3
********************************************************************************

* wave 1
use "$datapath\temp\wave1.dta", clear
global var1 "ph003_ ph006d1 ph006d5 height dn004_ dn014_ dn026_1 dn026_2 dn027_1 dn027_2 dn028_1 dn028_2 iscedy_r depress hnetwv wave age ch002_ ch006_*"
 foreach x of global var1 {
ren `x' `x'1
}
ren hhid2 hhid1
sort mergeid country
 

 
* wave 2
preserve
use "$datapath\temp\wave2.dta", clear
global var2 "ph003_ ph006d1 ph006d5 height dn004_ dn014_ dn026_1 dn026_2 dn027_1 dn027_2 dn028_1 dn028_2 depress hnetwv wave age ac012_ ch002_ ch006_*"
 foreach x of global var2 {
ren `x' `x'2
}
sort mergeid country
save "$datapath\temp\wave2_sorted.dta", replace
restore

merge mergeid using "$datapath\temp\wave2_sorted.dta"
tab _m
drop _m
sort mergeid country



* wave 3
set more off
preserve
use "$datapath\temp\wave3_sharelife.dta", clear

global var3 "mobirth yrbirth age"
 foreach x of global var3 {
ren `x' `x'3
}
sort mergeid country
save "$datapath\temp\wave3_sorted.dta", replace
restore

merge mergeid using "$datapath\temp\wave3_sorted.dta"
tab _m
keep if _m == 3
drop _m


* select observations, since only those observations are interesting that participated in SHARELIFE
tab wave3
keep if wave3 ~= .
tab wave3 if wave2 == . & wave1 == .





save "$datapath\temp\SHARE_merged.dta", replace





