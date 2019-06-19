set more off
set mat 800
clear
capture log close
log using Table3.log, replace

************
*Panel A: keep 50 largest MSAs
***********
use all_vars_40_50

drop if ninc<=0
gen ln_ninc=ln(ninc)

tab age, gen(cohort)

gen ed=0
replace ed=1 if educ99==10
replace ed=2 if educ99>10 & educ99<14
replace ed=3 if educ99==14
replace ed=4 if educ99>14

keep if metaread==160 | metaread==520| metaread==640 | metaread==720 | metaread==1000 | metaread==1120 | metaread==1280 | metaread==1520| metaread==1600 | metaread==1640 | metaread==1680 | metaread==1840 | metaread==1920 | metaread==2000 | metaread==2080 | metaread==2160 | metaread==3120 | metaread==3320 | metaread==3360 |metaread==3480 | metaread==3760 | metaread==4120 | metaread==4480 | metaread==4520 | metaread==4920 | metaread==5000 | metaread==5080 | metaread==5120 | metaread==5360 | metaread==5560 | metaread==5600 | metaread==5720 | metaread==5880 | metaread==5960 | metaread==6160 | metaread==6200 | metaread==6280 |metaread==6440 | metaread==6760 | metaread==6840 | metaread==6920 | metaread==7040 | metaread==7160 | metaread==7240 | metaread==7320 | metaread==7360 | metaread==7600 | metaread==8280 | metaread==8840 | metaread==8960

sort ed
xtreg child ln_ninc cohort1-cohort10, fe i(metaread) robust
by ed: xtreg child ln_ninc cohort1-cohort10, fe i(metaread)robust

sort metaread
merge metaread using qrent1990
drop if _merge<3
drop _merge

sort ed
reg child ln_ninc qrent cohort1-cohort10, robust 
by ed: reg child ln_ninc qrent cohort1-cohort10, robust 

**********
*get mean number of children for each group (to calculate elasticity)
********
sum child
bysort ed: sum child

**********
*Panel B: keep only MSAs that are smaller than 50 largest MSAs
***********
clear 
use all_vars_40_50
drop if ninc<=0
gen ln_ninc=ln(ninc)

tab age, gen(cohort)

gen ed=0
replace ed=1 if educ99==10
replace ed=2 if educ99>10 & educ99<14
replace ed=3 if educ99==14
replace ed=4 if educ99>14

drop if  metaread==0 |  metaread==160 | metaread==520| metaread==640 | metaread==720 | metaread==1000 | metaread==1120 | metaread==1280 | metaread==1520| metaread==1600 | metaread==1640 | metaread==1680 | metaread==1840 | metaread==1920 | metaread==2000 | metaread==2080 | metaread==2160 | metaread==3120 | metaread==3320 | metaread==3360 |metaread==3480 | metaread==3760 | metaread==4120 | metaread==4480 | metaread==4520 | metaread==4920 | metaread==5000 | metaread==5080 | metaread==5120 | metaread==5360 | metaread==5560 | metaread==5600 | metaread==5720 | metaread==5880 | metaread==5960 | metaread==6160 | metaread==6200 | metaread==6280 |metaread==6440 | metaread==6760 | metaread==6840 | metaread==6920 | metaread==7040 | metaread==7160 | metaread==7240 | metaread==7320 | metaread==7360 | metaread==7600 | metaread==8280 | metaread==8840 | metaread==8960

sort ed
xtreg child ln_ninc cohort1-cohort10, fe i(metaread)robust
by ed: xtreg child ln_ninc cohort1-cohort10, fe i(metaread) robust

sort metaread
merge metaread using qrent1990
drop if _merge<3
drop _merge

sort ed
reg child ln_ninc qrent cohort1-cohort10, robust 
by ed: reg child ln_ninc qrent cohort1-cohort10, robust 

**********
*get mean number of children for each group (to calculate elasticity)
********

sum child
bysort ed: sum child

log close
* end

 