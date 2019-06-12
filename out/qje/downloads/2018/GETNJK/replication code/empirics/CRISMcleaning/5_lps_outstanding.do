/*
Calculate outstanding and outstanding split by ARM, FRM, moneyness buckets, jumbo status by MSA 
-	./temp/lps_outstanding_cbsa_newest`x' -> ./temp/lps_outstanding_matched.dta (all loan_ids contained in ./temp/efx_lps_matched)
-	./temp/lps_outstanding_cbsa_full`x' -> ./temp/lps_outstanding_full.dta, everything from full`x'_lps st primary_flag = 1
-	./temp/lps_outstanding_cbsa_incl_efx: matched loan_ids that are first liens, add second liens from Equifax
-	./temp/lps_outstanding.dta: merging of full and matched, lps_share = bal_out / bal_out_full
*/ 

set more off
clear

**** Get FRM rate 
freduse MORTGAGE30US, clear
gen datem = mofd(daten)
collapse (mean) MORTGAGE30US, by(datem)
save temp/frm.tmp, replace

**************************************************************
* Matched loans only
**************************************************************

*** Get matched loan ids
use output/efx_lps_matched.dta, clear
keep loan_id
duplicates drop
save temp/matched_loanids.dta, replace


foreach x of global list {
**** Get LPS outstanding
use temp/HPI_LPS_merged`x'.dta, clear
di "sample `x' matched"
cap log on
keep if primary_flag
tabstat prin_bal_amt, st(sum N)

keep cid loan_id as_of_mon_id prop_zip prin_bal_amt int_type lien_type cur_int_rate term_datem termination_type investor_type appraisal_amt hpi_close hpi ficov5
merge m:1 loan_id using temp/matched_loanids.dta, keep(3) nogen
* percent of universe that our matched sample is able to cover
tabstat prin_bal_amt, st(sum N)
drop cid
cap log off
rename as_of_mon_id_datem datem 
merge 1:1 loan_id datem using temp/second_bal`x'.dta, nogen // comes from 2_second_lien_balances
replace second_bal = 0 if second_bal == .
cap drop bal_incl_efx_out
gen bal_incl_efx_out = prin_bal_amt + second_bal
gen true_value = appraisal_amt / (hpi_close/100)
gen value = true_value *(hpi/100) 
gen CLTV = 100*bal_incl_efx_out / value

merge m:1 datem using temp/frm.tmp, keep(1 3) nogen

destring prop_zip, gen(zipcode)
merge m:1 zipcode using input/zip_CLL08.dta, keep(1 3) nogen

drop if (termination_type == "6" | termination_type == "M") & term_datem == datem + 1

* calculate ARM, first lien, inc, jumbo indicators and balances
gen arm = (int_type == "2" | int_type == "3")
gen frm = (int_type == "1")
gen first_lien = lien_type == 1
gen inc = cur_int_rate - MORTGAGE30US
gen incg0 = inc > 0
gen incg100 = inc > 1
g jumbo = (prin_bal_amt > cll08) 
replace jumbo = . if cll08 == . | prin_bal_amt == .
g jumbo2 = (prin_bal_amt + second_bal > cll08) 
replace jumbo2 = . if cll08 == . | prin_bal_amt == .
g nonjumbo = (jumbo == 0) 
g nonjumbo2 = (jumbo2==0) 
gen gse = (investor_type == "2" | investor_type == "3") 
 

drop int_type lien_type termination_type cur_int_rate term_datem second_bal inc 
foreach v in arm frm first_lien incg0 incg100 jumbo jumbo2 nonjumbo nonjumbo2 gse  {
gen `v'_bal = `v' * prin_bal_amt
}

* collapse by zip
collapse (sum)  bal_incl_efx_out bal_out=prin_bal_amt arm* frm* incg* first_lien* nonjumbo* jumbo* gse* cltv*  (count) num_out=loan_id, by(prop_zip datem) fast
renvars arm frm incg0 incg100 first_lien* jumbo jumbo2 nonjumbo nonjumbo2 gse , postfix(_num)
renvars arm* frm* incg* first_lien* jumbo* nonjumbo* gse* , postfix(_out)

* merge in MSAs and collapse by MSA
destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) 
drop _merge
collapse (sum)  *out , by(msa datem) fast

replace msa = 999 if msa == .

save temp/lps_outstanding_cbsa_newest`x'.dta, replace
}

clear
foreach y of global list {
append using temp/lps_outstanding_cbsa_newest`y'.dta
}
collapse (sum) *out, by(datem msano)
rename datem as_of_mon_id_datem
save temp/lps_outstanding_matched.dta, replace

**************************************************************
* Full LPS sample
**************************************************************

foreach x of global list {
**** Get LPS outstanding
use input/full`x'_lps.dta, clear
di "sample `x' full"
cap log on
keep if primary_flag
drop if close_dt == ""
keep  loan_id as_of_mon_id prop_zip prin_bal_amt termination_type term_datem lien_type

bysort loan_id as_of_mon_id: keep if _n == 1
cap log off

* merge in FRM, second balances, CLLs
gen year = floor(as_of_mon_id/100)
gen month = as_of_mon_id-year*100
gen datem = mofd(mdy(month, 1, year))
drop as_of_mon_id

* collapse by zip
collapse (sum)  bal_out=prin_bal_amt  (count) num_out=loan_id, by(prop_zip datem) fast
* merge in MSAs and collapse by MSA
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) 
drop _merge
collapse (sum)  *out , by(msa datem) fast

replace msa = 999 if msa == .
save temp/lps_outstanding_cbsa_full`x'.dta, replace
}

clear
foreach y of global list {
append using temp/lps_outstanding_cbsa_full`y'.dta
}
collapse (sum) *out, by(datem msano)
rename datem as_of_mon_id_datem
save temp/lps_outstanding_full.dta, replace


**************************************************************
* Including second liens
**************************************************************

foreach x of global list {
**** Get LPS outstanding
use temp/HPI_LPS_merged`x'.dta, clear

keep if primary_flag & lien_type == 1

gen loan_age = as_of_mon_id_datem - close_datem 
keep cid loan_id as_of_mon_id prop_zip prin_bal_amt hpi ficov5 cur_int_rate int_type investor_type loan_age hpi_close appraisal_amt orig_amt loan_age close_datem arm_init_rate fico_orig purpose_type_mcdash
merge m:1 loan_id using temp/matched_loanids.dta, keep(3) nogen
bysort loan_id as_of_mon_id: keep if _n == 1 

* merge in FRM, second balances, CLLs
rename as_of_mon_id_datem datem 
merge 1:1 loan_id datem using temp/second_bal`x'.dta, nogen // comes from 2_second_lien_balances
replace second_bal = 0 if second_bal == .
g bal_incl_efx_out = prin_bal_amt + second_bal

* outsheeting non-collapsed version 
save temp/lps_outstanding_ind`x'.dta, replace

keep bal_incl_efx_out prop_zip datem

* collapse by zip
collapse (sum)  bal_incl_efx_out , by(prop_zip datem) fast
* merge in MSAs and collapse by MSA
destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) 
drop _merge
collapse (sum)  *out , by(msa datem) fast

replace msa = 999 if msa == .
save temp/lps_outstanding_cbsa_incl_efx`x'.dta, replace
}

clear
foreach y of global list {
append using temp/lps_outstanding_cbsa_incl_efx`y'.dta
}
collapse (sum) *out, by(datem msano)
rename datem as_of_mon_id_datem
save temp/lps_outstanding_incl_efx.dta, replace

**************************************************************
* Combine
**************************************************************

use temp/lps_outstanding_full.dta, clear
keep msano as_of bal_out
rename bal_out bal_out_full
merge 1:1 msano as_of using temp/lps_outstanding_incl_efx.dta, nogen
merge 1:1 msano as_of using temp/lps_outstanding_matched.dta, nogen
gen lps_share = bal_out / bal_out_full
save temp/lps_outstanding.dta, replace

clear 
foreach y of global list { 
append using temp/lps_outstanding_ind`y'.dta
} 

save temp/lps_outstanding_ind.dta, replace
