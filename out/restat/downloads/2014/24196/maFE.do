drop _all
capture log close
set logtype text
log using maFE, replace
set more off
set mem 3g
set matsize 2000

* this do file:
* 1) interacts height dummies with lgdp, and runs regressions without FE
* 2) as above but with FE
* 3) runs (1) but with height in m rather than ht dummies
* 4) as above but with FE
* 5) interacts height dummies with (avg) mother education, and runs regressions without FE
* 6) as above but with FE
* 7) runs (5) but with height in m rather than ht dummies
* 8) as above but with FE

***********************************************
*******		DATA
***********************************************

use world_child3

** keep only children with full exposure

tab infant_exp
keep if infant_exp==1

sort caseid2
egen motherid=group(caseid2)

xtset motherid

keep height100 height imputed_height infant tall1 tall2 short1 short2 tallhalf shorthalf urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel country yearc caseid2 id2 countryid *gdp motherid educfyrsc educexp
count
drop *_lgdp
foreach var of varlist tall1 tall2 short1 short2 shorthalf tallhalf height100 {
	gen `var'_lgdp=`var'*lgdp
	gen `var'_educfyrsc=`var'*educfyrsc
	}

tab country
compress

***********************************************
*******		REGRESSIONS
***********************************************

* (1)

xi: reg infant tall1 tall2 short1 short2 shorthalf tallhalf tall1_lgdp tall2_lgdp short1_lgdp short2_lgdp tallhalf_lgdp shorthalf_lgdp lgdp urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, robust cluster(countryid)
sum lgdp tall1 tall2 short1 short2 tallhalf shorthalf infant if e(sample) & kids>1

sum lgdp if e(sample)

local mean_gdp=r(mean)
nlcom _b[tallhalf] + _b[tallhalf_lgdp]*`mean_gdp'
nlcom _b[tall1] + _b[tall1_lgdp]*`mean_gdp'
nlcom _b[tall2] + _b[tall2_lgdp]*`mean_gdp'
nlcom _b[shorthalf] + _b[shorthalf_lgdp]*`mean_gdp'
nlcom _b[short1] + _b[short1_lgdp]*`mean_gdp'
nlcom _b[short2] + _b[short2_lgdp]*`mean_gdp'

foreach var of varlist tall1 tall2 tallhalf short1 short2 shorthalf {
	sum `var' if e(sample)
	local mean`var'=r(mean)
	}
	
nlcom _b[lgdp] + _b[tallhalf_lgdp]*`meantallhalf' + _b[tall1_lgdp]*`meantall1' + _b[tall2_lgdp]*`meantall2' + _b[shorthalf_lgdp]*`meanshorthalf' + _b[short1_lgdp]*`meanshort1' + _b[short2_lgdp]*`meanshort2'

* (2)
preserve
keep if e(sample)

xi: xtreg infant tall1 tall2 short1 short2 shorthalf tallhalf tall1_lgdp tall2_lgdp short1_lgdp short2_lgdp tallhalf_lgdp shorthalf_lgdp lgdp urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, fe vce(cluster countryid) 
outreg using maFE, append ctitle("FE") bracket coefast se
sum lgdp tall1 tall2 short1 short2 tallhalf shorthalf infant if e(sample) & kids>1

sum lgdp if e(sample)

local mean_gdp=r(mean)
nlcom _b[tallhalf] + _b[tallhalf_lgdp]*`mean_gdp'
nlcom _b[tall1] + _b[tall1_lgdp]*`mean_gdp'
nlcom _b[tall2] + _b[tall2_lgdp]*`mean_gdp'
nlcom _b[shorthalf] + _b[shorthalf_lgdp]*`mean_gdp'
nlcom _b[short1] + _b[short1_lgdp]*`mean_gdp'
nlcom _b[short2] + _b[short2_lgdp]*`mean_gdp'

foreach var of varlist tall1 tall2 tallhalf short1 short2 shorthalf {
	sum `var' if e(sample)
	local mean`var'=r(mean)
	}
	
nlcom _b[lgdp] + _b[tallhalf_lgdp]*`meantallhalf' + _b[tall1_lgdp]*`meantall1' + _b[tall2_lgdp]*`meantall2' + _b[shorthalf_lgdp]*`meanshorthalf' + _b[short1_lgdp]*`meanshort1' + _b[short2_lgdp]*`meanshort2'

restore

* (3)

xi: reg infant height100 height100_lgdp lgdp urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, robust cluster(countryid)
sum lgdp height100 infant if e(sample) & kids>1

sum lgdp if e(sample)
local mean_lgdp=r(mean)

nlcom _b[height100] + _b[height100_lgdp]*`mean_lgdp'

sum height100 if e(sample)
local mean_ht=r(mean)
nlcom _b[lgdp] + _b[height100_lgdp]*`mean_ht'

* (4)
preserve
keep if e(sample)

xi: xtreg infant height100 height100_lgdp lgdp urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, fe vce(cluster countryid) 
sum lgdp height100 infant if e(sample) & kids>1

sum lgdp if e(sample)
local mean_lgdp=r(mean)

nlcom _b[height100] + _b[height100_lgdp]*`mean_lgdp'

sum height100 if e(sample)
local mean_ht=r(mean)
nlcom _b[lgdp] + _b[height100_lgdp]*`mean_ht'

restore

* (5)

xi: reg infant tall1 tall2 short1 short2 shorthalf tallhalf tall1_educfyrsc tall2_educfyrsc short1_educfyrsc short2_educfyrsc tallhalf_educfyrsc shorthalf_educfyrsc educfyrsc urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, robust cluster(countryid)
sum educfyrsc tall1 tall2 short1 short2 tallhalf shorthalf infant if e(sample) & kids>1

sum educfyrsc if e(sample)

local mean_educfyrsc=r(mean)
nlcom _b[tallhalf] + _b[tallhalf_educfyrsc]*`mean_educfyrsc'
nlcom _b[tall1] + _b[tall1_educfyrsc]*`mean_educfyrsc'
nlcom _b[tall2] + _b[tall2_educfyrsc]*`mean_educfyrsc'
nlcom _b[shorthalf] + _b[shorthalf_educfyrsc]*`mean_educfyrsc'
nlcom _b[short1] + _b[short1_educfyrsc]*`mean_educfyrsc'
nlcom _b[short2] + _b[short2_educfyrsc]*`mean_educfyrsc'

foreach var of varlist tall1 tall2 tallhalf short1 short2 shorthalf {
	sum `var' if e(sample)
	local mean`var'=r(mean)
	}
	
nlcom _b[educfyrsc] + _b[tallhalf_educfyrsc]*`meantallhalf' + _b[tall1_educfyrsc]*`meantall1' + _b[tall2_educfyrsc]*`meantall2' + _b[shorthalf_educfyrsc]*`meanshorthalf' + _b[short1_educfyrsc]*`meanshort1' + _b[short2_educfyrsc]*`meanshort2'

* (6)
preserve
keep if e(sample)

xi: xtreg infant tall1 tall2 short1 short2 shorthalf tallhalf tall1_educfyrsc tall2_educfyrsc short1_educfyrsc short2_educfyrsc tallhalf_educfyrsc shorthalf_educfyrsc educfyrsc urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, fe vce(cluster countryid) 
sum educfyrsc tall1 tall2 short1 short2 tallhalf shorthalf infant if e(sample) & kids>1

sum educfyrsc if e(sample)

local mean_educfyrsc=r(mean)
nlcom _b[tallhalf] + _b[tallhalf_educfyrsc]*`mean_educfyrsc'
nlcom _b[tall1] + _b[tall1_educfyrsc]*`mean_educfyrsc'
nlcom _b[tall2] + _b[tall2_educfyrsc]*`mean_educfyrsc'
nlcom _b[shorthalf] + _b[shorthalf_educfyrsc]*`mean_educfyrsc'
nlcom _b[short1] + _b[short1_educfyrsc]*`mean_educfyrsc'
nlcom _b[short2] + _b[short2_educfyrsc]*`mean_educfyrsc'

foreach var of varlist tall1 tall2 tallhalf short1 short2 shorthalf {
	sum `var' if e(sample)
	local mean`var'=r(mean)
	}
	
nlcom _b[educfyrsc] + _b[tallhalf_educfyrsc]*`meantallhalf' + _b[tall1_educfyrsc]*`meantall1' + _b[tall2_educfyrsc]*`meantall2' + _b[shorthalf_educfyrsc]*`meanshorthalf' + _b[short1_educfyrsc]*`meanshort1' + _b[short2_educfyrsc]*`meanshort2'

restore

* (7)

xi: reg infant height100 height100_educfyrsc educfyrsc urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, robust cluster(countryid)
sum educfyrsc height100 infant if e(sample) & kids>1

sum educfyrsc if e(sample)
local mean_educfyrsc=r(mean)

nlcom _b[height100] + _b[height100_educfyrsc]*`mean_educfyrsc'

sum height100 if e(sample)
local mean_ht=r(mean)
nlcom _b[educfyrsc] + _b[height100_educfyrsc]*`mean_ht'

* (8)
preserve
keep if e(sample)

xi: xtreg infant height100 height100_educfyrsc educfyrsc urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, fe vce(cluster countryid) 
sum educfyrsc height100 infant if e(sample) & kids>1

sum educfyrsc if e(sample)
local mean_educfyrsc=r(mean)

nlcom _b[height100] + _b[height100_educfyrsc]*`mean_educfyrsc'

sum height100 if e(sample)
local mean_ht=r(mean)
nlcom _b[educfyrsc] + _b[height100_educfyrsc]*`mean_ht'

restore

log close
exit