
/* Calculating individual rate changes of refinanced loans: 

"We note that in the CRISM data over the first half of 2009, the median rate on the old
loan was 6.125%, while the median rate on the new (refinance) loan was 4.875%.  The average balance
of the first-lien mortgage being refinanced was $206,000..."
*/
use "CRISMcleaning/temp/linked_nomoves_lps_orig.dta", clear // from 5_link_old_lps_loans.do

capture program drop get_duplicates
program define get_duplicates
cap drop d
duplicates tag orig_loan_id, gen(d)
end

gen frm = orig_int_type=="1"

rename orig_last_nz_bal refi_old_bal
rename efx_loan_bal_orig refi_new_bal
replace refi_old_bal = 0 if refi_old_bal == .
replace refi_new_bal = 0 if refi_new_bal == .

drop orig_term_datem 
rename efx_loan_opendatem orig_term_datem 


keep *cur_int_rate cid *refi_old_bal*   *term_datem   ///
refi_new_bal *loan_id   *int_type *refi_new*

rename orig_term_datem refi_datem
renvars orig*, presub("orig_" "old_")
renvars   loan_id  int_type cur_int_rate , prefix("new_")
renvars refi_old_bal refi_new_bal, presub("refi_" "")

drop if new_loan_id == .
drop if refi_datem > m(2009m12) | refi_datem < m(2009m1)

g rate_ratio = new_cur_int_rate / old_cur_int_rate
tabstat rate_ratio if refi_datem>=m(2009m1)&refi_datem<=m(2009m12), by(refi_datem ) stat(mean p50 N) // very close to the Freddie Mac refi reports numbers

// THIS IS WHAT IS MENTIONED IN PAPER:
tabstat new_cur_int_rate if refi_datem>=m(2009m1)&refi_datem<=m(2009m6), by(refi_datem ) stat(mean p50 N) 
tabstat old_cur_int_rate if refi_datem>=m(2009m1)&refi_datem<=m(2009m6), by(refi_datem ) stat(mean p50 N) 
