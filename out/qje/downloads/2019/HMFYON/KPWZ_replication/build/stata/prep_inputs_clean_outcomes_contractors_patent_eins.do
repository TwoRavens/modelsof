
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
local dataset="contract"
insheet using $rawdir/all_contractors.csv, clear	


*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************
*zero all missing
drop zero*

reshape long non_emp_comp, i(tin tax_yr) j(year)
keep if tax_yr==year

g emp_`dataset'=contractors

rename non_emp_comp wb_`dataset'
keep year tin wb_`dataset' emp_`dataset'

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort tin year
save $dumpdir/outcomes_patent_eins_1099_`dataset'.dta, replace
*}
