/* 
This file identifies refis for the refi propensity panel. 
It starts with matched first liens that terminate in voluntary payoffs. 
It then considers all loans belonging to the matched loan's consumer, and 
looks to see if any of them are potential refis of the matched loan. 
A loan is considered a refi if its origination date is within 4 months of the
matched loan's LPS termination date and:
- if the refi loan is in LPS and is marked as a refi
- if the refi loan is in LPS as a U/Z and doesn't change LPS zipcodes
- if the refi loan is in Equifax and the consumer doesn't move in the 6 months following the termination

INPUT FILES: 
- efx_lps_matched
- efx_lps_all

OUTPUT FILES:
- known_refi_purpose.dta
- linked_nomoves_lps_orig.dta

*/ 

set more off
clear

*** Find all cases where another loan is opened around the time an LPS loan is terminated
use output/efx_lps_matched.dta, clear
rename prop_zip zipcode
merge m:1 zipcode using input/zip_CLL08.dta, keep(1 3) nogen
rename zipcode prop_zip
keep if lien_type == 1 & termination_type == "1" 
ds cid, not
renvars `r(varlist)', prefix(orig_)
joinby cid using temp/efx_lps_all.dta
save temp/efx_lps_join.dta, replace

use temp/efx_lps_join.dta, clear
gen link_diff = orig_term_datem - efx_loan_opendatem
gen link = (abs(link_diff)) <= 4

preserve
keep if link
keep orig_loan_id purpose_type link orig_term_datem
gen known_new_loan =  (purpose_type == "1" | purpose_type == "2" | purpose_type == "3" | purpose_type == "5")
replace link = 0 if purpose_type == "1"
duplicates drop
rename orig_loan_id loan_id
drop purpose_type
collapse (max) known_new_loan link, by(loan_id orig_term_datem)
save temp/known_refi_purpose.dta, replace
restore

gen link_known = 1 if (purpose_type == "2" | purpose_type == "3" | purpose_type == "5")
** take out moves
replace link = 0 if purpose_type == "1"
gen lps_move = (orig_prop_zip ~= prop_zip & match)
replace link = 0 if lps_move & (purpose_type == "U" | purpose_type == "Z")
keep if link
rename orig_term_datem as_of_mon_id_datem
merge m:1 cid as_of_mon_id_datem using temp/cid_moves.dta, keep(1 3) // from 2_clean_efx_moves
rename as_of orig_term_datem
replace link = 0 if movep6m & ~match
keep if link
save temp/linked_nomoves_lps_orig.dta, replace



