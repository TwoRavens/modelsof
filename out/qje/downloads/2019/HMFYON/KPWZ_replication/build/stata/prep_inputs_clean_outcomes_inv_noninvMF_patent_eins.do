
*******************************************************************************
*******************************************************************************
* PREP input files for clean_outcomes_w2
*******************************************************************************
*******************************************************************************
set more off
clear 
set maxvar 8000

*******************************************************************************
*1.0 LOAD CSV OF EIN-YEAR-worker cohort file
*******************************************************************************
local dataset="inv_noninvMF"
insheet using $rawdir/gender_inventor.csv, clear	

*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************
*PAYER_TIN_W2_MAX,tax_yr,
*mean_male_inv_wages,male_invs,mean_female_inv_wages,
*female_invs,male_noninvs,mean_male_noninv_wages,
*female_noninvs,mean_female_noninv_wages

rename payer_tin_w2_max tin
rename tax_yr year
rename mean_male_inv_wages wage_invM
rename male_invs invM
rename mean_female_inv_wages wage_invF
rename female_invs invF
rename male_noninvs noninvM
rename mean_male_noninv_wages wage_noninvM
rename female_noninvs noninvF
rename mean_female_noninv_wages wage_noninvF

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort tin year
save $dumpdir/outcomes_patent_eins_w2_`dataset'.dta, replace
*}
