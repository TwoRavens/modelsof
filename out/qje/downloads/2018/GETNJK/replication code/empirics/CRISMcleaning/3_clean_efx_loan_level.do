/*
This file constructs a loan-level dataset from the Equifax panel variables. 
The basic structure of this is to assume that loans in Equifax are uniquely identified by
a CID X opendt X bal_orig combination. 

This assumption takes care of cases where loans disappear for a few months and then reappear. 
Some cleaning is done to correct for cases where the bal_orig changes in Equifax but they seem to be
referring to the same loan. 

We start by only considering cases where a consumer never has more than 2 loans of a given type in a month, 
meaning that with the Equifax tradeline variabels we observe all loans belonging to this consumer every month. 

In a separate section, we also use consumers that start the sample with no more than 2 loans of any type, but 
then can have up to 3 loans during any of the following months. For these loans, even though we do not 
directly observe all loans in every month, we can infer the unobserved loan using the consumer totals and the 
other two tradelines. 

Input: ./temp/full`x'_efx.dta
Output: ./temp/efx`x'_loans.dta
*/ 

set more off
clear

quietly {
* keep only consumers that have 2 or less loans of each type in each month 
foreach y of global list {

use temp/full`y'_efx.dta, clear
noi di "total number of cids in sample `y'"
noi distinct cid
drop if (num_fm > 2 & num_fm ~= .) | (num_ces > 2 & num_ces ~= .) | (num_heloc > 2 & num_heloc ~= .)
noi di "number with 2 or less loans in every month"
noi distinct cid

** loop through each loan type and identify each distinct origination/termination
foreach loant in fm ces heloc   {
preserve
keep cid conf zipcode as_of conf primary_flag first_efx last_efx num_efx `loant'*

*** some basic cleaning
foreach v of varlist *opendt {
gen year = floor(`v'/100)
gen month = `v'-year*100
gen `v'_datem = mofd(mdy(month, 1, year))
drop `v' year month
}
replace `loant'_lrg_opendt = . if `loant'_lrg_bal == 0
replace `loant'_lrg_bal_orig = . if `loant'_lrg_bal == 0
replace `loant'_2lrg_opendt = . if `loant'_2lrg_bal == 0
replace `loant'_2lrg_bal_orig = . if `loant'_2lrg_bal == 0

****  corrects for cases where the second largest field is filled in, but the largest field is missing
gen fake2 = `loant'_lrg_opendt == . & `loant'_2lrg_opendt ~= .
foreach v in bal bal_orig opendt {
replace `loant'_lrg_`v' = `loant'_2lrg_`v' if fake2
replace `loant'_2lrg_`v' = . if fake2
}
drop fake2

****  corrects cases where the origination balance changes somewhat
bysort cid (as_of_mon_id): gen x = 1 if `loant'_lrg_opendt == `loant'_lrg_opendt[_n-1] ///
& `loant'_num == `loant'_num[_n-1] & ( abs((`loant'_lrg_bal_orig-`loant'_lrg_bal_orig[_n-1])/(`loant'_lrg_bal_orig[_n-1])) < .2)
replace `loant'_lrg_bal_orig = `loant'_lrg_bal_orig[_n-1] if x == 1
drop x
bysort cid (as_of_mon_id): gen x = 1 if `loant'_2lrg_opendt == `loant'_2lrg_opendt[_n-1] ///
& `loant'_num == `loant'_num[_n-1] & ( abs((`loant'_2lrg_bal_orig-`loant'_2lrg_bal_orig[_n-1])/(`loant'_2lrg_bal_orig[_n-1])) < .2)
replace `loant'_2lrg_bal_orig = `loant'_2lrg_bal_orig[_n-1] if x == 1
drop x

****  makes num variables consistent with line variables
replace `loant'_num = 0 if  `loant'_lrg_opendt == . & `loant'_2lrg_opendt == .
replace `loant'_num = 1 if  `loant'_lrg_opendt ~= . & `loant'_2lrg_opendt == . 
replace `loant'_num = 2 if  `loant'_lrg_opendt ~= . & `loant'_2lrg_opendt ~= . 
drop if `loant'_num == 0

*******************************************************************
* EXPAND by 2 and then collapse to make loan-level dataset

gen long obs = _n
expand 2
bysort obs: gen n = _n
tab n
drop if `loant'_2lrg_opendt == . & n == 2
foreach v in opendt bal bal_orig  {
gen efx_loan_`v' = `loant'_lrg_`v' if n == 1
replace efx_loan_`v' = `loant'_2lrg_`v' if n == 2
} 

drop if efx_loan_bal_orig == .
*** keep the last observation of each mortgage (should have the correct termination date and balance
sort as_of_mon_id
egen mode_zip = mode(zipcode), by(cid efx_loan_bal_orig efx_loan_bal_orig efx_loan_opendt) minmode
collapse (last) conf efx_loan_bal mode_zip last_as_of=as_of_mon_id (first) first_as_of=as_of_mon_id, by(cid efx_loan_bal_orig efx_loan_opendt first_efx last_efx num_efx )
drop if efx_loan_opendt == .
gen efx_loan_type = "`loant'"
replace last_as_of = . if last_as_of == last_efx
save temp/efx`y'_`loant'loans.dta, replace
restore
}
}


*********************************************************************************************************************************************************************************************************



*******************************************************************
** 3 loans in some months, but not in first month
*******************************************************************
foreach y of global list {
use temp/full`y'_efx.dta, clear

rename heloc_lim heloc_bal_orig
noi di "total number of cids in sample `y'"
noi distinct cid
keep if (num_fm > 2 & num_fm ~= .) | (num_ces > 2 & num_ces ~= .) | (num_heloc > 2 & num_heloc ~= .)
keep if num_fm <= 3 & num_ces <= 3 & num_heloc <= 3
foreach loant in  fm ces heloc  {
bysort cid (as_of_mon_id): egen first_`loant'_num = first(`loant'_num)
}
keep if first_fm_num <= 2 & first_ces_num <= 2 & first_heloc_num <= 2
noi di "sample `y' extra loans"
noi distinct cid
foreach loant in  fm ces heloc  {
preserve

*******************************************************************
* CLEANING
*******************************************************************
keep cid conf zipcode as_of conf primary_flag first_efx last_efx num_efx `loant'* num_`loant'
sort as_of_mon_id
foreach v of varlist *opendt {
gen year = floor(`v'/100)
gen month = `v'-year*100
gen `v'_datem = mofd(mdy(month, 1, year))
drop `v' year month
}
replace `loant'_lrg_opendt = . if `loant'_lrg_bal == 0
replace `loant'_lrg_bal_orig = . if `loant'_lrg_bal == 0
replace `loant'_2lrg_opendt = . if `loant'_2lrg_bal == 0
replace `loant'_2lrg_bal_orig = . if `loant'_2lrg_bal == 0
*** corrects for cases where the second largest field is filled in, but the largest field is missing
gen fake2 = `loant'_lrg_opendt == . & `loant'_2lrg_opendt ~= .
foreach v in bal bal_orig opendt {
replace `loant'_lrg_`v' = `loant'_2lrg_`v' if fake2
replace `loant'_2lrg_`v' = . if fake2
}
drop fake2
*** makes num variables consistent with line variables
replace `loant'_num = 0 if  `loant'_lrg_opendt == . & `loant'_2lrg_opendt == .
replace `loant'_num = 1 if  `loant'_lrg_opendt ~= . & `loant'_2lrg_opendt == . 
replace `loant'_num = 2 if  `loant'_lrg_opendt ~= . & `loant'_2lrg_opendt ~= . & `loant'_num < 2
drop if `loant'_num == 0
**** corrects cases where the origination balance changes somewhat
bysort cid (as_of_mon_id): gen x = 1 if `loant'_lrg_opendt == `loant'_lrg_opendt[_n-1] ///
& `loant'_num == `loant'_num[_n-1] & ( abs((`loant'_lrg_bal_orig-`loant'_lrg_bal_orig[_n-1])/(`loant'_lrg_bal_orig[_n-1])) < .2)
replace `loant'_lrg_bal_orig = `loant'_lrg_bal_orig[_n-1] if x == 1
drop x
bysort cid (as_of_mon_id): gen x = 1 if `loant'_2lrg_opendt == `loant'_2lrg_opendt[_n-1] ///
& `loant'_num == `loant'_num[_n-1] & ( abs((`loant'_2lrg_bal_orig-`loant'_2lrg_bal_orig[_n-1])/(`loant'_2lrg_bal_orig[_n-1])) < .2)
replace `loant'_2lrg_bal_orig = `loant'_2lrg_bal_orig[_n-1] if x == 1
drop x

*******************************************************************
* Infer 3rd loan variables
*******************************************************************
gen `loant'_3lrg_bal_orig = `loant'_bal_orig - `loant'_lrg_bal_orig - `loant'_2lrg_bal_orig
replace `loant'_3lrg_bal_orig = 0 if `loant'_3lrg_bal_orig < 0
gen `loant'_3lrg_bal = `loant'_bal - `loant'_lrg_bal - `loant'_2lrg_bal
replace `loant'_3lrg_bal = 0 if `loant'_3lrg_bal < 0
gen `loant'_3lrg_opendt = `loant'_lrg_opendt[_n-1] if `loant'_3lrg_bal_orig == `loant'_lrg_bal_orig[_n-1]
replace `loant'_3lrg_opendt = `loant'_2lrg_opendt[_n-1] if `loant'_3lrg_bal_orig == `loant'_2lrg_bal_orig[_n-1]
replace `loant'_3lrg_opendt = as_of_mon_id_datem if `loant'_3lrg_opendt == . & /// 
`loant'_2lrg_opendt == `loant'_2lrg_opendt[_n-1] & `loant'_lrg_opendt == `loant'_lrg_opendt[_n-1] & `loant'_3lrg_bal_orig ~= 0
replace `loant'_3lrg_opendt = as_of_mon_id_datem if `loant'_3lrg_opendt == . & (`loant'_num - `loant'_num[_n-1]  > 1)
replace `loant'_3lrg_opendt = `loant'_3lrg_opendt[_n-1] if `loant'_3lrg_bal_orig == `loant'_3lrg_bal_orig[_n-1]
replace `loant'_3lrg_opendt = . if `loant'_3lrg_bal_orig == 0
replace `loant'_3lrg_bal_orig = . if `loant'_3lrg_bal_orig == 0

*******************************************************************
* Expand by 3 and collapse to get loan-level dataset
*******************************************************************
gen long obs = _n
expand 3
bysort obs: gen n = _n
tab n
drop if `loant'_2lrg_opendt == . & n == 2
drop if `loant'_3lrg_opendt == . & n == 3
foreach v in opendt bal bal_orig  {
gen efx_loan_`v' = `loant'_lrg_`v' if n == 1
replace efx_loan_`v' = `loant'_2lrg_`v' if n == 2
replace efx_loan_`v' = `loant'_3lrg_`v' if n == 3
} 

drop if efx_loan_bal_orig == .
*** keep the last observation of each mortgage (should have the correct termination date and balance
sort as_of_mon_id
egen mode_zip = mode(zipcode), by(cid efx_loan_bal_orig efx_loan_bal_orig efx_loan_opendt) minmode
collapse (last) conf efx_loan_bal mode_zip last_as_of=as_of_mon_id (first) first_as_of=as_of_mon_id, by(cid efx_loan_bal_orig efx_loan_opendt first_efx last_efx num_efx )
drop if efx_loan_opendt == .
gen efx_loan_type = "`loant'"
replace last_as_of = . if last_as_of == last_efx
save temp/efx`y'_`loant'loans_more.dta, replace
restore
}
}

*******************************************************************
* Append by loan type
*******************************************************************
foreach y of global list {
foreach loant in fm ces heloc {
use "temp/efx`y'_`loant'loans.dta", clear
append using "temp/efx`y'_`loant'loans_more.dta"
save "temp/efx`y'_`loant'loans.dta", replace
rm "temp/efx`y'_`loant'loans_more.dta"
}
}


*******************************************************************
* Append and collapse all loan types
*******************************************************************
foreach y of global list {
use temp/efx`y'_fmloans.dta, clear
append using temp/efx`y'_cesloans.dta
append using temp/efx`y'_helocloans.dta
sort first_as_of
noi di "combine sample `y' loans by origination date and amount"
noi count
collapse (last) efx_loan_bal last_as_of efx_loan_type mode_zip (first) first_as_of, by(cid efx_loan_bal_orig efx_loan_opendt first_efx last_efx num_efx)
noi count
* termination date is the first month where the loan doesn't appear in equifax
gen efx_loan_termdt = last_as_of + 1
drop last_as_of
rename efx_loan_bal efx_loan_lastbal
gen efx_loanid = _n

rename efx_loan_opendt efx_loan_opendatem 
rename efx_loan_termdt efx_loan_termdatem
format *datem %tm
save temp/efx_loans`y'.dta, replace
}
}
