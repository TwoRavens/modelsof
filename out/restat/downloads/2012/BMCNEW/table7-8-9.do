clear
clear matrix
capture program drop _all
set more off
set mem 900m
set matsize 1000
set scheme s2mono

cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm"


*=====================
program define casestudy
*=====================

gen man_cat_prop_u = units if man != . & cat != . & prop != .
gen man_nocat_prop_u = units if man != . & cat == . & prop != .
gen man_cat_noprop_u = units if man != . & cat != . & prop == .
gen man_nocat_noprop_u = units if man != . & cat == . & prop == .
gen noman_cat_prop_u = units if man == . & cat != . & prop != .
gen noman_nocat_prop_u = units if man == . & cat == . & prop != .
gen noman_cat_noprop_u = units if man == . & cat != . & prop == .
gen noman_nocat_noprop_u = units if man == . & cat == . & prop == .

gen man_cat_prop_t = transactions if man != . & cat != . & prop != .
gen man_nocat_prop_t = transactions if man != . & cat == . & prop != .
gen man_cat_noprop_t = transactions if man != . & cat != . & prop == .
gen man_nocat_noprop_t = transactions if man != . & cat == . & prop == .
gen noman_cat_prop_t = transactions if man == . & cat != . & prop != .
gen noman_nocat_prop_t = transactions if man == . & cat == . & prop != .
gen noman_cat_noprop_t = transactions if man == . & cat != . & prop == .
gen noman_nocat_noprop_t = transactions if man == . & cat == . & prop == .


collapse (sum) *_u *_t, by(year_qt)
global category_u man_cat_prop_u man_nocat_prop_u man_cat_noprop_u man_nocat_noprop_u noman_cat_prop_u noman_nocat_prop_u noman_cat_noprop_u noman_nocat_noprop_u


keep year_qt *_u *_t
gen id = 1
reshape wide *_u *_t , i(id) j(year_qt) 
foreach x in $category_u {
	gen `x'q4rawdiff07 = (`x'200704-`x'200604)
	gen `x'q4perchng07 = (`x'200704-`x'200604)/`x'200604
	gen `x'ratio06_q1 = `x'200604/`x'200601
	gen `x'ratio07_q1 = `x'200704/`x'200701
	gen `x'ratperch_q1 = (`x'ratio07_q1- `x'ratio06_q1)/`x'ratio06_q1
}

keep *u200601 *u200602 *u200603 *u200604 *u200701 *u200702 *u200703 *u200704 *q4rawdiff07 *q4perchng07 *ratperch_q1 id *t200604
order *u200601 *u200602 *u200603 *u200604 *u200701 *u200702 *u200703 *u200704 *q4rawdiff07 *q4perchng07 *ratperch_q1 *t200604
reshape long man_cat_prop man_nocat_prop man_cat_noprop man_nocat_noprop noman_cat_prop noman_nocat_prop noman_cat_noprop noman_nocat_noprop , i(id) j(stat) string


end
*=====================


/*	RC2 - Thomas - PS Vehicles - 6/13/07 and 9/26/07	*/

use ..\data\toys_qtr, clear
replace units = units/1000
gen man = 1 if parent_company == "RC2"
gen cat = 1 if category == 12
gen prop = 1 if brand == "THOMAS AND FRIENDS" | license == "THOMAS AND FRIENDS"
casestudy
outsheet using ..\output\table7.csv, c replace


/*-----------------------------------------------------------*/


/*	Mattel - Dora - PS Figures and Playsets - 8/2/07	*/

use ..\data\toys_qtr, clear
gen man = 1 if parent_company == "MATTEL"
gen cat = 1 if category == 7
gen prop = 1 if brand == "DORA THE EXPLORER" | license == "DORA THE EXPLORER"
casestudy
outsheet using ..\output\table8.csv, c replace


/*-----------------------------------------------------------*/

/*	Mattel - Sesame Street - Many Categories - 8/2/07	*/

use ..\data\toys_qtr, clear
gen man = 1 if parent_company == "MATTEL"
gen cat = 1 if category == 1 | ///
		  category == 3 | ///
		  category == 6 | ///
		  category == 7 | ///
		  category == 8 | ///
		  category == 10 | ///
		  category == 11 | ///
		  category == 12
gen prop = 1 if brand == "SESAME STREET" | license == "SESAME STREET"
casestudy
outsheet using ..\output\table9.csv, c replace

