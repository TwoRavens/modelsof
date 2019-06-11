/* 
This file creates MSA-level CLTV measures, based on lps_outstanding_ind.dta
*/ 

set more off
clear

use temp/lps_outstanding_ind.dta

gen value = appraisal_amt / hpi_close * hpi 
gen CLTV = 100*bal_incl_efx_out / value
drop if appraisal_amt>3000000
drop if CLTV == .
format datem %tm 

// to see evolution of mean/median CLTVs
preserve 
	collapse (mean) CLTV (median) CLTV_med = CLTV, by(datem) fast
	line CLTV datem , name(CLTVmean, replace)
	line CLTV_med datem , name(CLTVmedian, replace)
restore 

destring prop_zip, replace
rename prin_bal_amt loan_amt

preserve 
	keep if datem == tm(2007m1) 
	merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) 
	save temp/updated_LTVs_200701_zip.dta, replace
restore

preserve
	keep if datem == tm(2008m11) 
	merge m:1 prop_zip using input/zipTOmsadiv.dta, keep(1 3) 
	save temp/updated_LTVs_200811_zip.dta, replace
restore

foreach m in 200701 200811 {
use temp/updated_LTVs_`m'_zip.dta, clear

foreach x of numlist 0 10 20 30 40 50 60 70 80 90 { 
local y = `x'+10
gen num_`x'    = CLTV > `x' & CLTV<=`y'
gen num_`x'_aw = num_`x' * loan_amt
}
gen num_100 	  = CLTV > 100 & CLTV <.
gen num_100_aw = num_100 * loan_amt

gen second_lien = second_bal ~= 0
gen bal_w_second_lien = second_lien * loan_amt

collapse (sum) num* loan_amt  second_bal (count) num_loans=loan_id (sum) second_lien bal_w_second_lien, by(msa datem)

foreach x of numlist 0 10 20 30 40 50 60 70 80 90 100 { 
local y = `x'+10
gen pct_zip_`x'_`y' = num_`x' / num_loans
gen pct_zip_`x'_`y'_aw = num_`x'_aw / loan_amt
}
renvars *100_110*, subst(100_110 100)

gen pct_zip_80_aw = pct_zip_80_90_aw + pct_zip_90_100_aw + pct_zip_100_aw // measure used in earlier versions of paper -- fraction above 80

gen second_lien_pct = second_lien / num_loans
gen second_lien_pct_bw = bal_w_second_lien / loan_amt
drop num*
save output/msa`m'_ltvs_zip.dta, replace // only temp; merged again below

use temp/updated_LTVs_`m'_zip.dta, clear
drop if appraisal_amt>3000000
drop if CLTV == .
drop if loan_amt < 0 
collapse CLTV_avg_`m' = CLTV (p50) CLTV_p50 = CLTV [aw = loan_amt], by(msa) fast // weighted averages and medians
merge 1:1 msa using output/msa`m'_ltvs_zip.dta, nogen

save output/msa`m'_ltvs_zip.dta, replace
} 



