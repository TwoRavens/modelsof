*GENERAL INSTRUCTIONS*
*--------------------*
*Set the directory of your preference in the "global" command below
*Copy the database inside the directory chosen
*Ready to do the entire current file with no break
*All the log files with the impact results will be store at the folder "child_labor_results" in your directory
*--------------------------------------------------------------------------*

clear
set mem 600m
global a "C:\directory_of_choice"
use "$a\BDS_database_child_REStat.dta", replace
mkdir "$a\child_labor_results"
set more off

*-----------------------------*
*DATA ANALYSIS FOR CHILD LABOR*
*-----------------------------*

*IMPACT RESULTS (TABLE 3 - CHILD LABOR SECTION)*
************************************************

for X in var ch_labor hh_labor labor school prop_dias \ Y in num 1/5: gen childY=X

foreach x of varlist child1-child5  {
log using "$a\child_labor_results\table3_`x'.log", replace

codebook codigo if `x'~=. & cofficer_lb~=. 
reg `x' treatment if cofficer_lb~=.
 predictnl pt = _b[treatment]*1 + _b[_cons]*1 if e(sample)
 predictnl pc = _b[treatment]*0 + _b[_cons]*1 if e(sample)
 sum pt pc
 drop pt pc
*OLS Without Covariates (clustering)
areg `x' treatment, absorb(cofficer_lb) cl(idbank)
*OLS With Covariates (clustering)
areg `x' treatment sexo ed2 ed3 ed_mas married size missing, absorb(cofficer_lb) cl(idbank)

log close
}
