/* 
This file matches Equifax loans to LPS loans.
The structure of the code is as follows.
- Join on CID the Equifax loan level dataset and the LPS loan level dataset. (temp/efx_lps_join`x'.dta)
- Find best match for each Equifax loan_id. Not all will be matched; for the unmatched, set  all of their LPS variables to missing. (temp/efx_lps_all.dta)
- A match is when the origination date is within 1 month and the origination balance within $10000.
- Make a dataset with just the matched loans (temp/efx_lps_matched.dta)
 that has just one Equifax loan per LPS loan (since sometimes multiple Equifax loans get matched to the same LPS loan).
 
Note: this file is very time consuming to run. 

Input: ./temp/efx_loans`x'.dta, ./temp/lps_loans_primary`x'.dta
Output: ./temp/efx_lps_matched.dta, ./temp/efx_lps_all.dta
*/ 

set more off
clear

**********************************************************************************
*** Join EFX and LPS
**********************************************************************************
foreach y of global list {

use temp/efx_loans`y'.dta, clear
preserve
keep if mod(_n, 2) == 0
joinby cid using temp/lps_loans_primary`y'.dta
save temp/efx_lps_join`y'.dta, replace
restore
keep if mod(_n, 2) == 1
joinby cid using temp/lps_loans_primary`y'.dta
append using temp/efx_lps_join`y'.dta
sort efx_loan_opendatem efx_loan_termdatem
save temp/efx_lps_join`y'.dta, replace

**********************************************************************************
*** Find matches of Equifax->LPS
**********************************************************************************
use temp/efx_lps_join`y'.dta, clear
cap log on
bysort loan_id: gen n = _n
count if n == 1
drop if last_efx - first_efx + 1 >  num_efx //drop if we don't have a full Equifax record for this loan
count if n == 1
cap log off

* match loans by date and origination balance to their equivalents in equifax
gen date_diff = (close_datem - efx_loan_opendatem) 
gen bal_diff = orig_amt - efx_loan_bal_orig
gen match = (date_diff == 1 | date_diff == 0 | date_diff == -1) & (abs(bal_diff) < 10000) 
gen perfect_match = ( date_diff == 0 & abs(bal_diff) <= 1) 

* construct differences in zipcode, end balance, termination date, etc. to use 
* as match diagnostics/tiebreakers
destring mode_zip, replace
gen abs_zip_diff = abs(mode_zip - prop_zip)
gen abs_bal_diff = abs(bal_diff)
replace abs_bal_diff = 0 if abs_bal_diff == 1
gen abs_date_diff = abs(date_diff)
replace abs_date_diff = 0 if abs_date_diff == 1
bysort loan_id: egen num_match = sum(match)
bysort loan_id: egen num_perfect_match = sum(perfect_match)
cap log on
tab num_match if n == 1 & close_datem ~= . & orig_amt ~= .
tab num_perfect_match if n == 1 & close_datem ~= . & orig_amt ~= .
drop n
cap log off
gen term_diff = efx_loan_termdatem - term_datem
replace term_diff = 0 if efx_loan_termdatem == . & term_datem == .
gen abs_term_diff = abs(term_diff)
gen last_bal_diff = efx_loan_lastbal - last_nz_bal
gen abs_last_bal_diff = abs(last_bal_diff) 
replace abs_last_bal_diff = 9999999 if abs_last_bal_diff == .
gen clean_term = (termination_type ~= "6" & termination_type ~= "M")

* keep one observation per equifax loan, using other variables as tiebreakers
* if Equifax loan ends up being unmatched, set all of its LPS variables to missing
bysort efx_loanid match perfect_match (abs_term_diff abs_zip_diff abs_last_bal_diff clean_term abs_bal_diff abs_date_diff): keep if _n == 1
bysort efx_loanid (match perfect_match): keep if _n == _N
ds loan_id cur_int_rate orig_amt prop_type prop_state prop_zip mort_type loan_type int_type purpose_type_mcdash io_flg lien_type termination_type prin_bal_amt appraisal_amt last_nz_bal close_datem term_datem occupancy_type *diff, has(type string) 
foreach var of varlist `r(varlist)'{
replace `var' = "" if ~match
}
ds loan_id cur_int_rate orig_amt prop_type prop_state prop_zip mort_type loan_type int_type purpose_type_mcdash io_flg lien_type termination_type prin_bal_amt appraisal_amt last_nz_bal close_datem term_datem occupancy_type *diff, not(type string)
foreach var of varlist `r(varlist)' {
replace `var' = . if ~match
}
save temp/efx_lps_all`y'.dta, replace
}



clear

foreach y of global list {
append using temp/efx_lps_all`y'.dta
}
drop efx_loanid
gen efx_loanid = _n
save temp/efx_lps_all.dta, replace



foreach y of global list {
rm temp/efx_lps_all`y'.dta
}


**********************************************************************************
*** Construct a dataset containing all LPS loans that we found Equifax matches for
**********************************************************************************
* only one match
cap log on
use temp/efx_lps_all.dta, clear
count
bysort loan_id (abs_bal_diff abs_date_diff abs_term_diff abs_term_diff abs_zip_diff abs_last_bal_diff): gen n = _n
drop abs_bal_diff
keep if n == 1
save output/efx_lps_matched.dta, replace
cap log off
