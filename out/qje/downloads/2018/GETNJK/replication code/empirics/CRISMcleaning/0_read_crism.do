
/*
This file produces the files: temp/full`x'.dta where x goes from 1-5.
Each of these files corresponds to a 10% sample of the data by CID (cnid_rand_no in the CRISM version available via RADAR to users within the Federal Reserve System)
For each file we made 4 CRISM queries corresponding to each of the years 2007, 2008, 2009, 2010
One example query is below:

SELECT loan_id,cid,conf,primary_flag,as_of_mon_id,zipcode,addr_code,addr_dt,ficov5,ces_bal,ces_bal_orig,
ces_num,ces_lrg_bal,ces_lrg_bal_orig,ces_lrg_opendt,ces_2lrg_bal,ces_2lrg_bal_orig,ces_2lrg_opendt,
fm_bal,fm_bal_orig,fm_num,fm_lrg_bal,fm_lrg_bal_orig,fm_lrg_opendt,fm_2lrg_bal,fm_2lrg_bal_orig,fm_2lrg_opendt,
heloc_bal,heloc_lim,heloc_num,heloc_lrg_bal,heloc_lrg_bal_orig,heloc_lrg_opendt,heloc_2lrg_bal,
heloc_2lrg_bal_orig,heloc_2lrg_opendt, close_dt,orig_amt,prop_type,prop_state,prop_zip,appraisal_amt,
occupancy_type,fico_orig,dti_ratio,mort_type,loan_type,int_type,purpose_type_mcdash,io_flg,term_nmon,
arm_init_rate,seasoning_nmon,ltv_ratio,lien_type,termination_type,termination_dt,cur_int_rate,investor_type,
prin_bal_amt,mba_stat FROM crism.view_primary_cobwr_join_lps_crism 
WHERE (cnid_rand_no >= 100 AND cnid_rand_no < 200 AND as_of_mon_id >= 201001 AND as_of_mon_id <= 201012)

An example of the code that appends the 4 years into one file is below:
*/

cd [working directory]

foreach s in 032627_2941425932821 032393_4911425068881 032400_7491425075002 032408_8261425137701 {
insheet using input/crism`s'.csv, clear
foreach var of varlist *bal*  *lim* {
replace `var' = . if `var' >= 9999994 
}
foreach var of varlist *num {
replace `var' = . if `var' >= 96
}
foreach var of varlist *opendt {
replace `var' = . if `var' >= 999994
}
cap append using temp/full1.dta
save temp/full1.dta, replace
}
// then repeat for the next 4 files (another 10% sample based on cnid_rand_no) -> full2.dta, etc.

