/*
Now that we have identified refis, we calculate cash-out statistics for these refis.
First we add all loans linked to a particular refi together, to account for consolidation of two loans into one, etc.
Then for a given consumer and refi date, we take only the largest refi, and then separately merge in any "piggyback seconds."
Finally we calculate different cash out statistics and indicators. 
*/ 

set more off
clear

**** Calculate cashouts

use temp/linked_nomoves.dta, clear
gen diff = refi_efx_loan_termdatem - refi_close_datem  
gen fm_efx_loan_lastbal = efx_loan_lastbal * (efx_loan_type == "fm")

* eliminate likely data errors in Efx -- loans that stick around less than 3 months  
gen loan_length = efx_loan_termdatem - efx_loan_opendatem
drop if loan_length < 3

keep refi* *efx_loan_lastbal  num_refi_link  match efx_loan_opendatem efx_loan_termdatem efx_loan_bal_orig cid  efx_loan_type loan_length

**** Keep only one observation per equifax open/term/origination date (gets rid of two copies from the two owners)
ds refi_loan_id efx_loan_opendatem efx_loan_termdatem efx_loan_bal_orig, not
collapse (last) `r(varlist)', by(refi_loan_id efx_loan_opendatem efx_loan_termdatem efx_loan_bal_orig) fast

* add last balances, and take one observation per refi
* if two first mortgages, we take the one whose balance is closest to that of the refi mortgage
bys refi_loan_id efx_loan_type: gen loan_type_obs = _n
egen loan_group = group(refi_loan_id efx_loan_type)
gen diff = abs(efx_loan_lastbal - refi_orig_amt)

sort loan_group diff
by loan_group: gen drop = _n
drop if drop > 1 & efx_loan_type == "fm"

ds efx_loan_lastbal efx_loan_bal_orig refi_loan_id refi_n, not
collapse (sum) efx_loan_lastbal efx_loan_bal_orig (count) num_orig = refi_n (last) `r(varlist)', by(refi_loan_id) fast
bysort cid refi_close_datem refi_orig_amt: keep if _n == 1

* take the largest refi amount for a particular consumer and close date, and then add any piggyback seconds to this loan
sort refi_orig_amt
ds cid refi_close_datem , not
collapse (last) `r(varlist)', by(refi_close_datem cid) fast
rename refi_close_datem close_datem_match
merge 1:1 cid close_datem_match using temp/piggy.dta, keep(1 3) nogen // from 5_piggybackseconds
replace piggy_second_bal = 0 if piggy_second_bal == .
rename close_datem_match refi_close_datem
replace refi_orig_amt = refi_orig_amt + piggy_second_bal

keep cid refi_close_datem refi_orig_amt refi_msano efx* fm* refi_appraisal_amt piggy_second_bal efx_loan_type
save temp/linked_col.dta, replace

use temp/linked_col.dta, clear

gen cash_out_amt_noseconds = refi_orig_amt - piggy_second_bal - efx_loan_lastbal
gen cash_out_amt = refi_orig_amt - efx_loan_lastbal
gen cash_out_amt_nocashin = max(cash_out_amt, 0)

replace cash_out_amt = . if abs(cash_out_amt) > 1e6

g cash_out_amt_net = refi_orig_amt*0.98 - efx_loan_lastbal // allowing for 2% closing costs
g cash_out_af = cash_out_amt_net >=5000 & cash_out_amt <. // AF definition: after 2% closing costs, have at least 5k left over.

gen alt_cash_out = refi_orig_amt - fm_efx_loan_lastbal

replace cash_out_amt_net = . if abs(cash_out_amt) > 1e6

gen cash_out_bal_af = refi_orig_amt * cash_out_af

tabstat cash_out_amt_net, st(p10 p25 p50 p75 p90 p99 mean)
tabstat cash_out_amt, st(p1 p10 p25 p50 p75 p90 p99 mean)

/* For text: descriptive stats on individual refinances -- in the aggregate we use the MSA-sum of "cash_out_amt" */
preserve
	keep if refi_close_datem>=m(2009m1) & refi_close_datem<=m(2009m6)
	
	sum fm_efx_loan_lastbal, det // first lien balance
	sum fm_efx_loan_lastbal if fm_efx_loan_lastbal>0, det // first lien balance conditional on being positive -- mean 205, median 177

	sum cash_out_amt, det  // median: 7300; mean 25k (when dropping outliers <-1M or >1M)
	tab cash_out_af if cash_out_amt_net<. // 42% cash out
	sum cash_out_amt if cash_out_af == 1, det // median 30k; mean 62k
	sum cash_out_amt_net if cash_out_amt_net>0, det // median 7k; mean 33k
restore


//////////////

collapse (count) num_lps_refis = refi_orig_amt (sum) cash_out_af cash_out_bal_af cash_out_amt* refi_orig_amt* second_lien_cons (mean) avg_cash_out=cash_out_amt (p50) median_cash_out=cash_out_amt , by(refi_msano refi_close_datem) fast
rename refi_msano msano
rename refi_close_datem datem
save temp/cashout_panel.dta, replace


