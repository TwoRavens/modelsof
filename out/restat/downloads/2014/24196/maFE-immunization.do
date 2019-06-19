drop _all
capture log close
set logtype text
log using maFE-immunization, replace
set more off
set mem 3g
set matsize 2000

use world_child3

**********************************
****	THIS DO FILE:
**********************************

* Interacts immunization rates with height100, with FE

**********************************
****	MODIFY DATA TO USE
**********************************

** keep only children with full exposure

tab infant_exp
keep if infant_exp==1

** keep only countries and years for which we have full set of data

keep if yearc>1984 & yearc<2001

tab country if dpt==.
tab country if measles==.

* drop Namibia as it quite a few missings for year-obs for immunization rates
* Senegal is missing 1985 but this is only one year so keep in sample

drop if country=="Namibia"

drop countryid
egen countryid=group(country)

sort caseid2
egen motherid=group(caseid2)

xtset motherid

keep height100 height imputed_height infant tall1 tall2 short1 short2 tallhalf shorthalf urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel country yearc caseid2 id2 countryid *gdp motherid dpt* measles*
count

***********************************************
*******		REGRESSIONS
***********************************************

* (1)

xi: xtreg infant tall1 tall2 short1 short2 shorthalf tallhalf tall1_dpt100 tall2_dpt100 short1_dpt100 short2_dpt100 tallhalf_dpt100 shorthalf_dpt100 dpt100 urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, fe vce(cluster countryid) 
sum dpt100 tall1 tall2 short1 short2 tallhalf shorthalf infant if e(sample)

sum dpt100 if e(sample)

local mean_dpt100=r(mean)
nlcom _b[tallhalf] + _b[tallhalf_dpt100]*`mean_dpt100'
nlcom _b[tall1] + _b[tall1_dpt100]*`mean_dpt100'
nlcom _b[tall2] + _b[tall2_dpt100]*`mean_dpt100'
nlcom _b[shorthalf] + _b[shorthalf_dpt100]*`mean_dpt100'
nlcom _b[short1] + _b[short1_dpt100]*`mean_dpt100'
nlcom _b[short2] + _b[short2_dpt100]*`mean_dpt100'

foreach var of varlist tall1 tall2 tallhalf short1 short2 shorthalf {
	sum `var' if e(sample)
	local mean`var'=r(mean)
	}
	
nlcom _b[dpt100] + _b[tallhalf_dpt100]*`meantallhalf' + _b[tall1_dpt100]*`meantall1' + _b[tall2_dpt100]*`meantall2' + _b[shorthalf_dpt100]*`meanshorthalf' + _b[short1_dpt100]*`meanshort1' + _b[short2_dpt100]*`meanshort2'

* (2)

xi: xtreg infant height100 height100_dpt100 dpt100 urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, fe vce(cluster countryid) 
sum dpt100 height100 infant if e(sample)

sum dpt100 if e(sample)
local mean_dpt100=r(mean)

nlcom _b[height100] + _b[height100_dpt100]*`mean_dpt100'

sum height100 if e(sample)
local mean_ht=r(mean)
nlcom _b[dpt100] + _b[height100_dpt100]*`mean_ht'


* (1)

xi: xtreg infant tall1 tall2 short1 short2 shorthalf tallhalf tall1_measles100 tall2_measles100 short1_measles100 short2_measles100 tallhalf_measles100 shorthalf_measles100 measles100 urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, fe vce(cluster countryid) 
sum measles100 tall1 tall2 short1 short2 tallhalf shorthalf infant if e(sample)

sum measles100 if e(sample)

local mean_measles100=r(mean)
nlcom _b[tallhalf] + _b[tallhalf_measles100]*`mean_measles100'
nlcom _b[tall1] + _b[tall1_measles100]*`mean_measles100'
nlcom _b[tall2] + _b[tall2_measles100]*`mean_measles100'
nlcom _b[shorthalf] + _b[shorthalf_measles100]*`mean_measles100'
nlcom _b[short1] + _b[short1_measles100]*`mean_measles100'
nlcom _b[short2] + _b[short2_measles100]*`mean_measles100'

foreach var of varlist tall1 tall2 tallhalf short1 short2 shorthalf {
	sum `var' if e(sample)
	local mean`var'=r(mean)
	}
	
nlcom _b[measles100] + _b[tallhalf_measles100]*`meantallhalf' + _b[tall1_measles100]*`meantall1' + _b[tall2_measles100]*`meantall2' + _b[shorthalf_measles100]*`meanshorthalf' + _b[short1_measles100]*`meanshort1' + _b[short2_measles100]*`meanshort2'

* (2)

xi: xtreg infant height100 height100_measles100 measles100 urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, fe vce(cluster countryid) 
sum measles100 height100 infant if e(sample)

sum measles100 if e(sample)
local mean_measles100=r(mean)

nlcom _b[height100] + _b[height100_measles100]*`mean_measles100'

sum height100 if e(sample)
local mean_ht=r(mean)
nlcom _b[measles100] + _b[height100_measles100]*`mean_ht'


log close
exit

