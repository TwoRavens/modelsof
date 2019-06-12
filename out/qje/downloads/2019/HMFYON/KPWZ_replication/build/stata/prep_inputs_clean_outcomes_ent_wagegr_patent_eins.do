
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
local dataset="entrants3"
insheet using $rawdir/entrant_wage_growth.csv, clear	

*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************
*PAYER_TIN_W2_MAX,tax_yr,ent_wage_growth_in3,ent_wage_growth_in3_dhs,ents_who_stay_3yrs

rename payer_tin_w2_max tin
rename tax_yr year
rename ent_wage_growth_in3 wagegr3
rename ent_wage_growth_in3_dhs wagegr3dhs
rename ents_who_stay_3yrs ents_who_stay_3 

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort tin year
save $dumpdir/outcomes_patent_ent_wagegr.dta, replace

