
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
local dataset="ent"

insheet using $rawdir/allworker_entrants.csv, clear	

*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************
rename payer_tin_w2_max tin

reshape long entrants wagebill_entrants priorwagebill_entrants, i(tin tax_yr) j(year)
keep if tax_yr==year

recode entrants (.=0)
g emp_`dataset'=entrants


rename wagebill_entrants wb_`dataset'
rename priorwagebill_entrants priorwb_`dataset'
keep year tin emp_`dataset' wb_`dataset'  priorwb_`dataset'

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort tin year
save $dumpdir/outcomes_patent_eins_w2_`dataset'.dta, replace
*}
