***************************************
* This file takes each raw CRISM file and creates a CID X as_of_mon_id panel with all the Equifax variables,
* and a loan_id X cid X as_of_mon_id panel with all of the LPS variables.
* Input: ./temp/full`x'.dta
* Output: ./temp/full`x'_efx.dta, ./temp/full`x'_lps.dta
***************************************

set more off
clear

foreach y of global list {
*** Keep only equifax variables as a cid x month panel 
use temp/full`y'.dta, clear 
drop  close_dt orig_amt prop_type prop_state prop_zip appraisal_amt occupancy_type fico_orig dti_ratio mort_type loan_type int_type /// 
purpose_type_mcdash io_flg seasoning_nmon arm_init_rate ltv_ratio lien_type termination_type termination_dt cur_int_rate prin_bal_amt mba_stat investor_type

bysort cid as_of_mon_id: keep if _n == 1
bysort cid: egen num_fm = max(fm_num)
bysort cid: egen num_ces = max(ces_num)
bysort cid: egen num_heloc = max(heloc_num)
bysort cid: gen num_efx = _N

foreach v of varlist as_of_mon_id addr_dt {
gen year = floor(`v'/100)
gen month = `v'-year*100
gen `v'_datem = mofd(mdy(month, 1, year))
drop year month `v'
}
bysort cid: egen first_efx = min(as_of_mon_id) 
bysort cid: egen last_efx = max(as_of_mon_id) 
compress
save temp/full`y'_efx.dta, replace
 

*** Keep only LPS variables

use temp/full`y'.dta, clear
gen orig_ltv = orig_amt / appraisal_amt
drop if orig_ltv > 4 & !mi(orig_ltv) // outliers/mistakes
keep loan_id cid conf  primary_flag as_of_mon_id close_dt orig_amt prop_type prop_state prop_zip appraisal_amt occupancy_type fico_orig dti_ratio mort_type loan_type int_type /// 
purpose_type_mcdash io_flg seasoning_nmon arm_init_rate ltv_ratio lien_type termination_type termination_dt cur_int_rate prin_bal_amt mba_stat investor_type ficov5 
gen close_datem = mofd(date(close_dt, "YMD"))
gen term_datem = mofd(date(termination_dt, "YMD"))

foreach v of varlist as_of_mon_id  {
gen year = floor(`v'/100)
gen month = `v'-year*100
gen `v'_datem = mofd(mdy(month, 1, year))
drop year month `v'
}

compress
save temp/full`y'_lps.dta, replace

}

