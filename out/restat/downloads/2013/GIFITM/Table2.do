set more off
set mat 800
clear
capture log close
log using Table2.log, replace
use all_vars_40_50

drop if ninc<=0
gen ln_ninc=ln(ninc)

tab age, gen(cohort)

gen ed=0
replace ed=1 if educ99==10
replace ed=2 if educ99>10 & educ99<14
replace ed=3 if educ99==14
replace ed=4 if educ99>14

reg child ln_ninc cohort1-cohort10, robust 

sort ed
by ed: reg child ln_ninc cohort1-cohort10, robust 

**********
*get mean number of children for each group (to calculate elasticity)
********
sum child
bysort ed: sum child

log close
* end
