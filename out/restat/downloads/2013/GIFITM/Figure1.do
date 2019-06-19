set more off
set mat 800
clear
capture log close
log using Figure1.log, replace

************************
*HS grads
*
*step 1: weights
*
use regdata
drop dec
keep if age>39
keep if educ99==10 | educ99==14
xtile dec=ninc, nq(10)
drop wgt
keep if educ99==10
egen all=sum(perwt)
egen cell=sum(perwt), by (age)
gen wgt=cell/all
drop all cell
*
*step 2: mean CEB for each cell
*
egen N=sum(1), by(dec r)
collapse N child wgt  [aw=perwt], by(age dec r)
collapse N child [aw=wgt], by (dec r)
save HighSchoolWomenData, replace
*********************************************
*College grads
*
*step 1: weights
*
clear 
use regdata
drop dec
drop wgt
keep if age>39
keep if educ99==10 | educ99==14
xtile dec=ninc, nq(10)
keep if educ99==14
egen all=sum(perwt)
egen cell=sum(perwt), by (age)
gen wgt=cell/all
drop all cell
*
*stop 2: mean CEB for each cell
*
egen N=sum(1), by(dec r)
collapse N child wgt  [aw=perwt], by(age dec r)
collapse N child [aw=wgt], by (dec r)
save CollegeWomenData, replace

log close
*end
