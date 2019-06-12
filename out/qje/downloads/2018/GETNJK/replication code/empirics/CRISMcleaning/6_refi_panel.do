/*
This file calculates refi propensities by MSA, also for different subpopulations.
Input: ./temp/linked_nomoves_lps_orig.dta
Output: ./temp/refi_panel.dta
*/ 

set more off
clear

**** Calculate refi propensities using LPS orig loans
use temp/linked_nomoves_lps_orig.dta, clear

rename orig_term_datem datem
merge m:1 datem using temp/frm.tmp, keep(1 3) nogen
rename loan_id loan_id_temp
rename orig_loan_id loan_id

* Merge in second balances
merge m:1 loan_id datem using temp/second_bal.dta, nogen keep(1 3) // from 2_second_lien_balances

rename loan_id orig_loan_id
rename loan_id_temp loan_id
save temp/linked_nomoves_lps_orig_secondbal.dta, replace

use temp/linked_nomoves_lps_orig_secondbal.dta, clear
rename datem orig_term_datem


merge m:1 zipcode using input/zip_CLL08.dta, keep(1 3) nogen

gen orig_true_value = orig_appraisal_amt / (orig_hpi_close/100)
gen orig_value = orig_true_value *(orig_hpi/100)
gen bal_incl_efx_out = orig_last_nz_bal + second_bal
gen orig_CLTV = 100*bal_incl_efx_out / orig_value
drop bal_incl_efx_out 

* Define subsamples
g jumbo = (orig_last_nz_bal > cll08) 
g jumbo2 = (orig_last_nz_bal + second_bal > cll08)
replace jumbo = . if cll08 == . | orig_last_nz_bal == .
replace jumbo2 = . if cll08 == . | orig_last_nz_bal == . | second_bal == .
gen nonjumbo = jumbo == 0
gen nonjumbo2 = jumbo2 == 0
gen inc = orig_cur_int_rate - MORTGAGE30US 
gen incg0 = inc > 0 & inc ~= .
gen frm = (orig_int_type ~= "2" & orig_int_type ~= "3" & orig_int_type ~= "")
gen gse = (investor_type == "2" | investor_type == "3") 

* Get counts, balance-weighted and not 
rename orig_last_nz_bal refi_old_bal
rename efx_loan_bal_orig refi_new_bal
replace refi_old_bal = 0 if refi_old_bal == .
replace refi_new_bal = 0 if refi_new_bal == .
foreach v in incg0 frm nonjumbo jumbo nonjumbo2 jumbo2 gse {
gen refi_old_bal_`v' = refi_old_bal * `v'
gen refi_new_bal_`v' = refi_new_bal * `v'
rename `v' `v'_refi
}

gen diff = orig_term_datem - efx_loan_opendatem

drop orig_term_datem 
rename efx_loan_opendatem orig_term_datem 

collapse (sum) refi_new_bal*, by(refi_old_bal* *refi orig_loan_id orig_msano orig_term_datem) fast

save temp/refi_panel_individuals.dta, replace 

* Collapse by MSA
collapse (count) num_refis = orig_loan_id (sum) *refi refi_old_bal* refi_new_bal* , by(orig_msano orig_term_datem) fast
rename orig_term_datem datem
rename orig_msano msano
save temp/refi_panel.dta, replace


