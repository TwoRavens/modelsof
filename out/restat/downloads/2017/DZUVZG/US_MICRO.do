********************************************************************************
*** Stata code to replicate the US Census results.
*** Date: 12/03/2017			
********************************************************************************

********************************************************************************
* PREAMBLE
********************************************************************************

clear
clear matrix
set more off
set matsize 10000

* cd "..."

use US_CENSUS, clear

gen age2 = age*age
gen age3 = age2*age
gen age4 = age2*age2
egen cl = group(statefip birthyr)
recode race (1=1) (2=2) (3/9=3)
recode marst (1/2=1)
gen institution=0
replace institution=1 if gq==3
gen institution_alt = institution
replace institution_alt = 0 if year==1980 & gqtype==3
replace institution_alt = 0 if year==1980 & gqtype==4

* restrict attention to those aged over 17, not in school and born in the United States

keep if (bpl>0 & bpl<57) & age>17 & school==1


********************************************************************************
* TABLE 5 
********************************************************************************

* State entry U rate (Panel A: 1, 2, 3, 4)

probit institution IUR age age2 age3 age4 i.marst i.educ i.race i.vetstat i.year i.race#i.statefip i.birthyr i.bpl [pw=perwt], cluster(cl)
margins, dydx(IUR)
probit institution IUR age age2 age3 age4 i.marst i.educ i.race i.vetstat i.year i.race#i.statefip i.birthyr i.bpl [pw=perwt] if educ<6, cluster(cl)
margins, dydx(IUR)
probit institution IUR age age2 age3 age4 i.marst i.race i.vetstat i.year i.race#i.statefip i.birthyr i.bpl [pw=perwt] if educ==6, cluster(cl)
margins, dydx(IUR)
probit institution IUR age age2 age3 age4 i.marst i.educ i.race i.vetstat i.year i.race#i.statefip i.birthyr i.bpl [pw=perwt] if (educ==10 | educ==11), cluster(cl)
margins, dydx(IUR)

* State entry U rate - 1980 measure of institutions (Panel B: 1, 2, 3, 4)

probit institution_alt IUR age age2 age3 age4 i.marst i.educ i.race i.vetstat i.year i.race#i.statefip i.birthyr i.bpl [pw=perwt], cluster(cl)
margins, dydx(IUR)
probit institution_alt IUR age age2 age3 age4 i.marst i.educ i.race i.vetstat i.year i.race#i.statefip i.birthyr i.bpl [pw=perwt] if educ<6, cluster(cl)
margins, dydx(IUR)
probit institution_alt IUR age age2 age3 age4 i.marst i.race i.vetstat i.year i.race#i.statefip i.birthyr i.bpl [pw=perwt] if educ==6, cluster(cl)
margins, dydx(IUR)
probit institution_alt IUR age age2 age3 age4 i.marst i.educ i.race i.vetstat i.year i.race#i.statefip i.birthyr i.bpl [pw=perwt] if (educ==10 | educ==11), cluster(cl)
margins, dydx(IUR)

