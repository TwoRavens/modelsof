/*********THIS FILE INCLUDES THE 1960 SAMPLE WHICH WAS EXTRACTED FROM IPUMS

This DO-file merges spouses in the 1960 census


*****************************/



/********merging spouses and cohabitors************/

/**creating a data set of women only**/

clear
set mem 4G
set matsize 1500
set more off

use full1960

drop if sex==1 /**dropping all men**/

gen spouseindi1=pernum

gen spouseindi2=sploc


save census60women, replace


/**creating a data set of men only**/

clear
set mem 4G
set matsize 1500
set more off

use full1960

drop if sex==2 /**dropping all women**/


foreach var of varlist * {
rename `var' `var'_m
}

gen spouseindi1=sploc

gen spouseindi2=pernum

rename  year_m year
rename serial_m serial


save census60men, replace


/**merging spouses**/

clear
set mem 6G
set matsize 2000
set more off


use census60women


merge 1:1 year serial spouseindi1 spouseindi2 using census60men

save couples1960.dta,replace

drop if _merge==1
drop if _merge==2

save Couples1960.dta,replace



























