/*********THIS FILE INCLUDES THE 1970 SAMPLE WHICH WAS EXTRACTED FROM IPUMS

This DO-file creates spousal observations using the 1970 census


*****************************/



/********merging spouses and cohabitors************/

/**creating a data set of women only**/

clear
set mem 6G
set matsize 1500
set more off

/***specify directory***/

use full1970.dta

drop if sex==1 /**dropping all men**/

gen spouseindi1=pernum

gen spouseindi2=sploc


save census70women.dta,replace


/**creating a data set of men only**/

clear
set mem 6G
set matsize 1500
set more off

/***specify directory***/

use full1970.dta

drop if sex==2 /**dropping all women**/


foreach var of varlist * {
rename `var' `var'_m
}

gen spouseindi1=sploc

gen spouseindi2=pernum

rename  year_m year
rename serial_m serial


save census70men.dta,replace


/**merging spouses**/

clear
set mem 6G
set matsize 2000
set more off

/***specify directory***/

use census70women.dta

merge 1:1 year serial spouseindi1 spouseindi2 using census70men.dta

save Couples1970.dta,replace

drop if _merge==1
drop if _merge==2

save Couples1970.dta,replace



























