
*******************************************************************************
*******************************************************************************
* PREP input files for clean_outcomes_w2
*******************************************************************************
*******************************************************************************
set more off
clear 
set maxvar 8000

*******************************************************************************
*1.0 LOAD CSV OF EIN-YEAR-worker wage growth
*******************************************************************************
local dataset="dbvars"
insheet using $rawdir/firm_ages_college_tenttax.csv, clear	

*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************
*PAYER_TIN_W2_MAX,tax_yr,mean_age,over40s,under40s,mean_over40wages,mean_under40wages,share_college,college_reported,
*mean_tentative_taxes,tentative_taxes_reported

rename payer_tin_w2_max tin
rename tax_yr year
rename mean_age age
rename over40s n_over40
rename under40s n_under40
rename mean_over40wages wage_over40
rename mean_under40wages wage_under40
rename college_reported n_college
rename mean_tentative_taxes avg_tax
rename tentative_taxes_reported n_tax

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort tin year
save $dumpdir/outcomes_patent_db_vars.dta, replace

