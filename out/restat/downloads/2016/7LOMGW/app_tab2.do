
********************************************************************************************************
*THIS DO-FILE REPLICATES APPENDIX TABLE 2 IN:                                                  			   
* PATRICIA FUNK: 							                       	
* "HOW ACCURATE ARE SURVEYED PREFERENCES FOR PUBLIC POLICIES? EVIDENCE FROM
* A UNIQUE INSTITUTIONAL SETUP"                                                                                         
********************************************************************************************************

global data ="[your path]"

clear all
set more off
set matsize 2000


use "$data\VOX_prepared", clear 


 
bysort votenr: sum yes yes_official survey_bias
gen share_yes_realp = yes_official/100

gen language_strat=.
replace language_strat=1 if German==1
replace language_strat=2 if French==1
replace language_strat=3 if Italian==1


**note: no strata possible for votes 371, 381, 382

*******************Analysis 1: Where Strata are possible

drop if votenr==371 |  votenr==381 |votenr==382 

egen groupvotenr = group(votenr)
save "$data\apptab2"

*ssc install regsave

***save confidence intervals
foreach i of num 1/181 {
use "$data\apptab2"
svyset _n, strata(language_strat)
svy, subpop(turnout): mean yes if groupvotenr==`i'
regsave, ci
list
save "$data\groupvotenr`i'"
gen groupvotenr=`i'
save "$data\groupvotenr`i'", replace
}

use   "$data\groupvotenr1"
foreach i of num 2/181 {
append using "$data\groupvotenr`i'"
save "$data\ci", replace
  }

sort groupvotenr
save "$data\ci", replace
  
use "$data\apptab2"
sort groupvotenr
merge   groupvotenr using  "$data\ci"
keep votenr var- ci_upper
sort votenr


collapse coef- ci_upper, by(votenr)

save "$data\apptab2", replace  

foreach i of num 1/181  {
erase "$data\groupvotenr`i'.dta"
}


**Calculate Statistical Significance   
   
use "$data\VOX_prepared"   

set more off

drop if votenr==371 |  votenr==381 |votenr==382 
gen share_yes_realp = yes_official/100

gen language_strat=.
replace language_strat=1 if German==1
replace language_strat=2 if French==1
replace language_strat=3 if Italian==1


levelsof votenr, local(levels) 
foreach l of local levels {
svyset _n, strata(language_strat)
svy, subpop(turnout): mean yes if votenr==`l'
su share_yes_realp if votenr==`l'
test yes==`=r(mean)'  
gen pvaluer`l'=`r(p)' if votenr==`l'
}
egen pvaluesstrata=rsum(pvaluer321- pvaluer941)
drop pvaluer321- pvaluer941

keep votenr pvaluesstrata
sort votenr

duplicates drop votenr, force

sort votenr

save "$data\mergeapp2"



use "$data\apptab2"

sort votenr

merge votenr using  "$data\mergeapp2"

drop _m
 
 
save "$data\apptab2", replace

*******************Analysis 2: Where Strata are not possible (votes 371, 381, 382)

use "$data\VOX_prepared"   


set more off

gen share_yes_realp = yes_official/100

gen language_strat=.
replace language_strat=1 if German==1
replace language_strat=2 if French==1
replace language_strat=3 if Italian==1

keep if votenr==371 |  votenr==381 |votenr==382 
 
egen groupvotenr = group(votenr) 
save  "$data\apptab2B"
 
***save confidence intervals
foreach i of num 1/3 {
use "$data\apptab2B"
svyset _n
svy, subpop(turnout): mean yes if groupvotenr==`i'
regsave, ci
list
save "$data\groupvotenr`i'"
gen groupvotenr=`i'
save "$data\groupvotenr`i'", replace
}

use   "$data\groupvotenr1"
foreach i of num 2/3 {
append using "$data\groupvotenr`i'"
save "$data\ci", replace
  }

sort groupvotenr
save "$data\ci", replace
  
use "$data\apptab2B"  
sort groupvotenr
merge   groupvotenr using  "$data\ci"
keep votenr coef- ci_upper
sort votenr
duplicates drop votenr, force
save "$data\apptab2B", replace



use "$data\apptab2"
sort votenr
merge votenr using "$data\apptab2B", update
drop _m

save "$data\apptab2", replace

***Calculate Statistical Significance without strata (do it for all votes)

use "$data\VOX_prepared"   

set more off

gen share_yes_realp = yes_official/100

levelsof votenr, local(levels) 
foreach l of local levels {
svyset _n
svy, subpop(turnout): mean yes if votenr==`l'
su share_yes_realp if votenr==`l'
test yes==`=r(mean)'  
gen pvaluer`l'=`r(p)' if votenr==`l'
}

egen pvalues=rsum(pvaluer321- pvaluer941)
drop pvaluer321- pvaluer941

keep votenr pvalues
duplicates drop votenr, force
keep if votenr==371 |  votenr==381 |votenr==382 
sort votenr
save "$data\mergeapp2", replace
 
use "$data\apptab2"

sort votenr

merge votenr using "$data\mergeapp2"

replace pvaluesstrata= pvalues if  pvaluesstrata==.

keep votenr- pvaluesstrata

collapse coef- pvaluesstrata, by(votenr)

save "$data\apptab2", replace

use "$data\VOX_prepared"   

keep votenr survey_bias survey_biasabs cooprate revrate turnoutgap share_yes_reported yes_official

duplicates drop votenr, force
sort votenr
save "$data\mergeapp2", replace

use "$data\apptab2"
sort votenr
merge votenr using  "$data\mergeapp2"

gen survey_biasl=ci_lower*100-yes_official

gen survey_biasu=ci_upper*100-yes_official

gsort- survey_biasabs

br



