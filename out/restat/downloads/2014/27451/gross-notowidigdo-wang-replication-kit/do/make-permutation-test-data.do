#delim cr
set more off
*version 11
pause on
graph set ps logo off

capture log close
set linesize 250
set logtype text
log using ../log/make-permutation-test-data.log , replace

/* --------------------------------------

Prepare data for permutation tests.

--------------------------------------- */

clear all
estimates clear
set matsize 10000

use ../dta/collapsed_data_2001.dta
global week_var = "r2001_week"
global day0 = mdy(7,20,2001)

keep filecount ssn2 paper_date_2001 $week_var chapter
reshape wide filecount, i(ssn2 paper_date_2001 $week_var) j(chapter)

gen past_their_paper_week = 0
replace past_their_paper_week = 1 if $week_var > floor((paper_date_2001 - $day0) / 7)

gen filecounta = filecount7+filecount13
gen log_filecount7 = log(filecount7)
gen log_filecount13 = log(filecount13)
gen log_filecounta = log(filecount7 + filecount13)

	xi i.$week_var

matrix results = J(10000, 6, .)

qui areg filecount7 past_their_paper_week _I*, `se' absorb(ssn2)
matrix results[1,1] = _b[past_their_paper_week]

qui areg log_filecount7 past_their_paper_week _I*, `se' absorb(ssn2)
matrix results[1,2] = _b[past_their_paper_week]

qui areg filecount13 past_their_paper_week _I*, `se' absorb(ssn2)
matrix results[1,3] = _b[past_their_paper_week]

qui areg log_filecount13 past_their_paper_week _I*, `se' absorb(ssn2)
matrix results[1,4] = _b[past_their_paper_week]

qui areg filecounta past_their_paper_week _I* , `se' absorb(ssn2)
matrix results[1,5] = _b[past_their_paper_week]

qui areg log_filecounta past_their_paper_week _I* , `se' absorb(ssn2)
matrix results[1,6] = _b[past_their_paper_week]


preserve
 keep ssn2 $week_var past_their_paper_week
 bysort ssn2 $week_var: keep if _n == 1
 sort ssn2 $week_var
 save ../dta/ssn2_to_post.dta, replace
restore


forvalues b = 2/10000 {

preserve

rename ssn2 ssn2_orig
drop past_their_paper_week
gen ssn2_raw = uniform()
sort ssn2_orig
by ssn2_orig: replace ssn2_raw = ssn2_raw[1]
egen ssn2 = group(ssn2_raw)
replace ssn2 = ssn2 - 1
*tab ssn2, missing
sort ssn2 $week_var
merge ssn2 $week_var using ../dta/ssn2_to_post.dta, uniqusing
*tab ssn2 _merge, missing
*tab $week_var _merge, missing
drop if _merge == 2
drop _merge

sort ssn2 $week_var
forvalues i = 1/10 {
 by ssn2: replace past_their_paper_week = past_their_paper_week[_n+1] if missing(past_their_paper_week) & past_their_paper_week[_n+1] == 0
}

sort ssn2 $week_var
forvalues i = 1/10 {
 by ssn2: replace past_their_paper_week = past_their_paper_week[_n-1] if missing(past_their_paper_week) & past_their_paper_week[_n-1] == 1
}

*tab $week_var past_their_paper_week, missing
assert(past_their_paper_week < .)

qui areg filecount7 past_their_paper_week _I*, `se' absorb(ssn2)
matrix results[`b',1] = _b[past_their_paper_week]

qui areg log_filecount7 past_their_paper_week _I*, `se' absorb(ssn2)
matrix results[`b',2] = _b[past_their_paper_week]

qui areg filecount13 past_their_paper_week _I*, `se' absorb(ssn2)
matrix results[`b',3] = _b[past_their_paper_week]

qui areg log_filecount13 past_their_paper_week _I*, `se' absorb(ssn2)
matrix results[`b',4] = _b[past_their_paper_week]

qui areg filecounta past_their_paper_week _I* , `se' absorb(ssn2)
matrix results[`b',5] = _b[past_their_paper_week]

qui areg log_filecounta past_their_paper_week _I* , `se' absorb(ssn2)
matrix results[`b',6] = _b[past_their_paper_week]

drop _all
svmat results
list if _n == 1
summ results* if _n > 1, det
save ../dta/randomization_inference_results.dta, replace

restore

}

preserve
drop _all
svmat results
list if _n == 1
summ results* if _n > 1, det
save ../dta/randomization_inference_results.dta, replace
restore

