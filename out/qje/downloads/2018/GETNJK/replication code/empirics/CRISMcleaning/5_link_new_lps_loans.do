/* 
This file identifies refi loans for the cashout panel. 
It starts with all matched first liens with an open date in our sample. 
It then looks at all other loans that were opened by that consumer, and 
looks for any that terminated between -1 and 4 months from the prospective refi
loan's open date. Conditional on finding such a loan, we consider it a refi if:
- If the refi loan is marked as a purchase loan in LPS, we never call it a refi
- If the refi loan is marked as U/Z and linked to another LPS loan, we require the LPS zipcodes to match
- If the refi loan is marked as U/Z and linked to a loan in Equifax, we require the consumer's 
to not "move" in Equifax in the 6 months following the refi
- If the refi loan is marked as a refi in LPS, then we always consider it a refi 
(including cases where there is no previous loan -- home previously owned outright)

INPUT FILES: 
- efx_lps_matched.dta
- efx_lps_all.dta

OUTPUT FILES: 
- linked_nomoves.dta
*/ 


set more off
clear

*** Find all cases where an LPS loan is opened around the time another loan is terminated
use output/efx_lps_matched.dta, clear
keep if lien_type == 1
drop if close_datem <= $fmonth
drop if (first_efx > close_datem - 1) | (last_efx < close_datem + 4)
ds cid, not
renvars `r(varlist)', prefix(refi_)
joinby cid using temp/efx_lps_all.dta, unmatched(master) // also comes from 4_match_efx_lps

*** Link refis with their original loan by termination/open date
gen link_diff = efx_loan_termdatem - refi_close_datem
gen abs_link_diff = abs(link_diff)
gen refi_link = (link_diff >= -1) & (link_diff <= 4)

* take out known purchase loans
drop if refi_purpose_type == "1"
* take out LPS moves
gen lps_move = (refi_prop_zip ~= prop_zip & match)
replace refi_link = 0 if lps_move & (refi_purpose_type == "U" | refi_purpose_type == "Z")
cap log on
tab refi_purpose_type
tabstat lps_move if match, by(refi_purpose_type)

* look for refis where there was no previous open mortgage, and set their previous balance to 0
bysort refi_loan_id: egen num_refi_link = sum(refi_link)
bysort refi_loan_id: gen n = _n
gen purchase_refi = ((num_refi_link == 0) & (refi_purpose_type == "2" | refi_purpose_type == "3" | refi_purpose_type == "5"))
tab purchase_refi if (refi_purpose_type == "2" | refi_purpose_type == "3" | refi_purpose_type == "5")
cap log off
bysort refi_loan_id: drop if purchase_refi & _n > 1 
ds refi* cid *link* purchase_refi n, not
foreach var of varlist `r(varlist)' {
cap replace `var' = . if purchase_refi
cap replace `var' = "" if  purchase_refi
}
replace refi_link = 1 if  purchase_refi
replace efx_loan_lastbal = 0 if purchase_refi
replace efx_loan_bal_orig = 0 if purchase_refi
* keep potential refis
keep if refi_link == 1

* remove equifax moves for unknown/other purpose types 
rename refi_close_datem as_of_mon_id_datem
merge m:1 cid as_of_mon_id_datem using temp/cid_moves.dta, keep(1 3) nogen // comes from 2_clean_efx_moves
rename as_of_mon_id_datem refi_close_datem
gen refi_efx_move = movep6m 
replace refi_link = 0 if refi_efx_move & ~match & (refi_purpose_type == "U" | refi_purpose_type == "Z")
cap log on
tab refi_efx_move if ~match & (refi_purpose_type == "U" | refi_purpose_type == "Z")
cap log off
keep if refi_link == 1
drop _m
save temp/linked_nomoves.dta, replace
