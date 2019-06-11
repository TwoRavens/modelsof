
/* 
This file looks for any piggyback seconds associated to any of the matched loans in our universe.
A piggyback second
- has the same open month in Equifax within three months of the matched loan's Equifax open month
- has an origination balance of less than 125% of the LPS loan's origination balance if it's a CES or HELOC, OR 
- has an origination balance of less than 25% of the LPS loan's origination balance if it's a FM
*/ 


set more off
clear

use temp/efx_lps_all.dta, clear
keep cid efx_loanid close_datem efx_loan_opendatem efx_loan_type lien_type efx_loan_bal_orig orig_amt
save temp/efx_all_short.dta, replace


* allow the second lien to be a piggyback if it occurs within three months 
forval i = -3/3 { 
	use temp/efx_lps_all.dta, clear
	keep cid efx_loanid close_datem efx_loan_opendatem efx_loan_type lien_type efx_loan_bal_orig orig_amt
	* move the open date up or back to allow for matching 
	replace efx_loan_opendatem = efx_loan_opendatem + `i' 
	save temp/efx_all_short_`i'.dta, replace
	
} 

* loop through the three months before and after 
forval i = -3/3 { 
	use output/efx_lps_matched.dta, clear
	keep cid efx_loanid loan_id orig_amt close_datem loan_type efx_loan_opendatem efx_loan_type
	ds cid efx_loan_opendatem, not
	renvars `r(varlist)', postfix(_match)
	joinby cid efx_loan_opendatem using temp/efx_all_short_`i'.dta 
	save temp/piggy_`i'.dta, replace
} 
use temp/piggy_-3.dta, clear
forval i = -2/3 { 
	append using temp/piggy_`i'.dta
} 

gen piggy_second_lien = (efx_loanid ~= efx_loanid_match) & (efx_loan_bal_orig <= 1.25 * orig_amt_match) & inlist(efx_loan_type, "ces", "heloc") 
replace piggy_second_lien = 1 if (efx_loanid ~= efx_loanid_match) & (efx_loan_bal_orig <= .25 * orig_amt_match) & inlist(efx_loan_type, "fm") 
gen piggy_second_bal = efx_loan_bal_orig * piggy_second_lien

collapse (sum) piggy_second_bal, by(cid close_datem_match)
keep if piggy_second_bal ~= 0
save temp/piggy.dta, replace
