
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
insheet using $rawdir/wage_growth.csv, clear	

*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************

rename payer_tin_w2_max tin
rename tax_yr year
rename cont_wrkrs   emp_cont
rename wage_growth  cont_wagegr
rename cont_males   emp_contM
rename cont_females emp_contF
rename male_wage_growth   cont_wagegrM
rename female_wage_growth cont_wagegrF
rename cont_inventors   emp_cont_inv
rename cont_noninventors emp_cont_noninv
rename inventor_wage_growth   cont_wagegr_inv
rename noninventor_wage_growth cont_wagegr_noninv

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort tin year
save $dumpdir/outcomes_patent_cont_wagegr.dta, replace

