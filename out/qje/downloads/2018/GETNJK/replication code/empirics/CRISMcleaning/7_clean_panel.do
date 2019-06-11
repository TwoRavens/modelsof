/* 
This file merges together several MSA panels into one large MSA panel
and computes additional statistics based on the merged data. 

Input: ./temp/refi_panel.dta, ./temp/cashout_panel.dta, ./temp/lps_outstanding, ./temp/lps_outstanding_incl_efx.dta
Output: ./output/msa_refi_panel.dta
*/ 

set more off
clear

use temp/refi_panel.dta, clear // from 6_refi_panel 
merge 1:1 msano datem using temp/cashout_panel.dta // from 6_cashout_panel 

* Merge in denominators (LPS outstanding) by MSA
gen as_of_mon_id_datem = datem - 1
merge 1:1 msano as_of_mon_id_datem using temp/lps_outstanding, keep(2 3) nogen // from 5_lps_outstanding
replace datem = as_of + 1

* refi propensities
renvars *out bal_out_full, prefix(l_)
replace num_refis = 0 if num_refis == .
replace refi_old_bal = 0 if refi_old_bal == .
gen refi_prop = num_refis / l_first_lien_out
gen refi_prop_bw = refi_old_bal / l_first_lien_bal_out 
foreach v in incg0 frm nonjumbo nonjumbo2 gse  {
gen refi_prop_`v' = `v'_refi / l_`v'_num_out
gen refi_prop_`v'_bw = refi_old_bal_`v' / l_`v'_bal_out 
}

* cash out fractions
gen casho_af_refi_share    = cash_out_af     / num_lps_refis
gen casho_af_refi_share_bw = cash_out_bal_af / refi_orig_amt

* cash out amts vs outstanding
gen casho_amt_vsoutst = (cash_out_amt) / l_bal_incl_efx_out
replace casho_amt_vsoutst = 0 if casho_amt_vsoutst == .
save output/msa_refi_panel.dta, replace

keep datem msano refi_prop* casho* l_num_out l_bal_out l_first_lien* num_lps_refis refi_orig_amt l_bal_incl_efx_out cash_out_amt*
save output/msa_refi_panel_short.dta, replace







