/*
This file creates MSA-Datem panels with a number of characteristics 
- investor type
- loan age
- updated FICO 
- Rates on outstanding loans
- ARM share
- Share with second liens
- Jumbo share 
- Origination LTV 
- balance amoumnt

*/ 
set more off
clear

********************************************************************************
** Investor Types

use datem prop_zip investor_type prop_zip prin_bal_amt  using temp/lps_outstanding_ind.dta, clear
drop if prin_bal_amt < 0 

* breaking out different investor types 
gen gse = investor_type == "2" | investor_type == "3" 
gen private = investor_type == "4" 
gen gov = investor_type == "1" | investor_type == "5" | investor_type == "6" | investor_type == "0" 

gen loan = 1

destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) 
drop if mi(msa) 
collapse (sum) gse private gov loan  [fweight = prin_bal_amt], by(datem msa)

gen gse_share = gse / loan 
gen private_share = private / loan 
gen gov_share = gov / loan 
drop gse private gov loan 
save output/investor_msa_panel.dta, replace


********************************************************************************
** Loan Age 

use datem loan_age prop_zip prin_bal_amt using temp/lps_outstanding_ind.dta, clear

drop if prin_bal_amt < 0 
destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3)

drop if mi(msa) 
collapse (mean) age_mean = loan_age (p25) age_p25 = loan_age (p50) age_p50 = loan_age ///
	(p75) age_p75 = loan_age [aweight = prin_bal_amt] , by(datem msa) 

save output/loan_age_msa_panel.dta, replace


********************************************************************************
** FICO 

use datem prop_zip prin_bal_amt ficov5 using temp/lps_outstanding_ind.dta, clear
drop if prin_bal_amt < 0 

destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3)
drop if mi(msa) 

gen below_680 = ficov5 < 680 
gen loan = 1

collapse (mean) fico_mean = ficov5 (p25) fico_p25 = ficov5 (p50) fico_p50 = ficov5 ///
	(p75) fico_p75 = ficov5 (sum) loan below_680 [fweight = prin_bal_amt], by(datem msa) 
 
gen share_below_680 = below_680 / loan 
drop below_680 loan 

save output/fico_msa_panel.dta, replace 


********************************************************************************
** Rates on outstanding 

use datem prin_bal_amt prop_zip cur_int_rate close_datem using temp/lps_outstanding_ind.dta, clear

drop if prin_bal_amt < 0 
destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3)
drop if mi(msa) 

// merge in market mortgage rate, also lagged one or 2 months
merge m:1 close_datem using input/MORTG_fred.dta, keep(1 3) nogen

g sato = cur_int_rate - MORTG_L1 // take 1-month lagged 30-yr FRM rate as "market rate" at origination

collapse (mean) rate_mean = cur_int_rate sato_mean = sato mktrate_atorig_mean = MORTG_L1 (p25) rate_p25 = cur_int_rate (p50) ///
	rate_p50 = cur_int_rate (p75) rate_p75 = cur_int_rate [aweight = prin_bal_amt], ///
	by(datem msa) fast

save output/rates_msa_panel.dta, replace

********************************************************************************
** ARM Share 
use datem prop_zip int_type prin_bal_amt using temp/lps_outstanding_ind.dta, clear 
drop if prin_bal_amt < 0 

destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3)
drop if mi(msa) 

gen arm = int_type == "2" | int_type == "3" 
gen loan = 1 

collapse (sum) arm loan [fweight = prin_bal_amt], by(datem msa) 

gen arm_share = arm / loan 
drop arm loan 

save output/arm_share_msa_panel.dta, replace



********************************************************************************
** Share with second liens 

use datem prop_zip prin_bal_amt second_bal  using temp/${samp}/lps_outstanding_ind.dta, clear 
drop if prin_bal_amt < 0 

destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3)
drop if mi(msa) 

gen has_second = second_bal > 0 

gen loan = 1 

collapse (sum) has_second loan [fweight = prin_bal_amt], by(datem msa) 

gen second_lien_share = has_second / loan 
drop has_second loan 

save output/seconds_share_msa_panel.dta, replace


********************************************************************************
** Original LTV

use datem prop_zip prin_bal_amt orig_amt appraisal_amt  using temp/lps_outstanding_ind.dta, clear 
drop if prin_bal_amt < 0 

destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3)
drop if mi(msa) 

gen orig_ltv = orig_amt / appraisal_amt 

collapse (mean) orig_ltv_mean = orig_ltv (p25) orig_ltv_p25 = orig_ltv /// 
	(p50) orig_ltv_p50 = orig_ltv (p75) orig_ltv_p75 = orig_ltv ///
	[aweight = prin_bal_amt], by(datem msa)

save output/orig_ltv_msa_panel.dta, replace


********************************************************************************
** Jumbo Share 


use datem prin_bal_amt prop_zip second_bal prin_bal_amt  using temp/${samp}/lps_outstanding_ind.dta, clear 
drop if prin_bal_amt < 0 

destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3)
drop if mi(msa) 

rename prop_zip zipcode
merge m:1 zipcode using input/zip_CLL08.dta, keep(1 3) nogen
rename zipcode prop_zip

g jumbo = (prin_bal_amt > cll08) 
replace jumbo = . if cll08 == . | prin_bal_amt == .
g jumbo2 = (prin_bal_amt + second_bal > cll08) 
replace jumbo2 = . if cll08 == . | prin_bal_amt == .

gen loan = 1 

collapse (sum) jumbo jumbo2 loan [fweight = prin_bal_amt], by(datem msa) 

gen jumbo_share = jumbo / loan 
gen jumbo2_share = jumbo2 / loan 

drop jumbo jumbo2 loan 

save output/jumbo_msa_panel.dta, replace 


********************************************************************************
** average loan amount (unweighted), also for non-jumbo only


use datem prin_bal_amt prop_zip second_bal prin_bal_amt  using temp/lps_outstanding_ind.dta, clear 
drop if prin_bal_amt < 0 

destring prop_zip, replace
merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3)
drop if mi(msa) 

rename prop_zip zipcode
merge m:1 zipcode using input/zip_CLL08.dta, keep(1 3) nogen
rename zipcode prop_zip

g jumbo = (prin_bal_amt > cll08) 
replace jumbo = . if cll08 == . | prin_bal_amt == .
g jumbo2 = (prin_bal_amt + second_bal > cll08) 
replace jumbo2 = . if cll08 == . | prin_bal_amt == .

gen prin_bal_amt_nonjumbo  = prin_bal_amt if jumbo!=1 
gen prin_bal_amt_nonjumbo2 = prin_bal_amt if jumbo2!=1 

egen pb = xtile(prin_bal_amt), by(datem) n(10)
tab pb, gen(pb_cat)

collapse prin_bal_amt prin_bal_amt_nonjumbo prin_bal_amt_nonjumbo2 pb_cat* (p50) prin_bal_amt_p50=prin_bal_amt, by(datem msa) fast

save output/prin_bal_msa_panel.dta, replace 


