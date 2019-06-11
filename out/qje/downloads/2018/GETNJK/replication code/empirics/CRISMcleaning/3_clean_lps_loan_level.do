/*
This file creates a dataset with one observation per loan 
with the origination and termination information from LPS
- also merges in MSA
- takes only primary owner observations
- records last balance
*/

set more off
clear


foreach y of global list {
use temp/HPI_LPS_merged`y'.dta, clear

keep if primary_flag

drop if close_dt == ""
* keep LPS variables only
keep loan_id cid primary_flag close_datem  orig_amt prop* loan_type mort_type int_type occupancy_type /// 
purpose_type_mcdash io_flg termination_type term_datem lien_type appraisal_amt cur_int_rate  as_of_mon_id_datem prin_bal_amt investor_type ///
fico_orig dti_ratio ltv_ratio seasoning_nmon arm* hpi* ficov5

* fill in investor type if missing
bys loan_id ( as_of_mon_id_datem): replace investor_type = investor_type[_n-1] if mi(investor_type) & !mi(investor_type[_N]) 
by loan_id: replace investor_type = investor_type[_N] if mi(investor_type) & !mi(investor_type[_N]) 

** record last nonzero balance 
gen last_nz_bal = prin_bal_amt
bysort loan_id  (as_of_mon_id): replace last_nz_bal = last_nz_bal[_n-1] if (last_nz_bal == 0 | last_nz_bal == .) & (last_nz_bal[_n-1] ~= .) & (last_nz_bal[_n-1] ~= 0)
bysort loan_id  (as_of_mon_id): keep if _n == _N 
rename as_of_mon_id last_lps_month

* merge in MSA for prop_zip
destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) nogen
replace msa = 999 if msa == .
save temp/lps_loans_primary`y'.dta, replace
}




