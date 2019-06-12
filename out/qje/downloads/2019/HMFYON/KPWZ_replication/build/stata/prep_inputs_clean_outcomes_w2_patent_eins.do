
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
foreach dataset in  "inventor" "noninventor" "all" "M" "F" "allworkers_jani" {
*local dataset="all"



if "`dataset'"!="allworkers_jani"{
insheet using $rawdir/`dataset'_workers.csv, clear	
}

if "`dataset'"=="allworkers_jani"{
insheet using $rawdir/`dataset'.csv, clear	
}


*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************
rename employees cht_`dataset'
rename payer_tin_w2_max tin

if "`dataset'"=="M"{
 keep if gnd_ind=="M"
}
if "`dataset'"=="F"{
 keep if gnd_ind=="F"
}

reshape long zerowages wagebill, i(tin tax_yr) j(year)
keep if tax_yr==year

recode zerowages (.=0)
rename zerowages zerowages_`dataset'
g emp_`dataset'=cht_`dataset'-zerowages_`dataset'


rename wagebill wb_`dataset'
keep year tin wb_`dataset' emp_`dataset'

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort tin year
save $dumpdir/outcomes_patent_eins_w2_`dataset'.dta, replace
}
