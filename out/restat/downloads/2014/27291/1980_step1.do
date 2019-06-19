/********merging spouses************/

/**creating a data set of women only**/

clear
set mem 8G
set matsize 1500
set more off


use full1980.dta

drop if sex==1 /**dropping all men**/

gen spouseindi1=pernum

gen spouseindi2=sploc


save census80women.dta,replace


/**creating a data set of men only**/

clear
set mem 8G
set matsize 1500
set more off

use full1980.dta

drop if sex==2 /**dropping all women**/


foreach var of varlist * {
rename `var' `var'_m
}

gen spouseindi1=sploc

gen spouseindi2=pernum

rename  year_m year
rename serial_m serial



save census80men.dta,replace



/**merging spouses**/

clear
set mem 8G
set matsize 2000
set more off

use census80women.dta

merge 1:1 year serial spouseindi1 spouseindi2 using census80men.dta

save Couples1980.dta,replace

drop if _merge==1
drop if _merge==2

save Couples1980.dta,replace




































