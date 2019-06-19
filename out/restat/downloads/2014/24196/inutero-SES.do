drop _all
capture clear matrix 
set more off
set virtual on
set memory 3g
set matsize 2000
set logtype text
capture log close
log using inutero-SES, replace

use world_child3

** keep only children with full exposure

tab infant_exp
keep if infant_exp==1

**************************

/* This do file:

Provides estimates for equation 2, for year of inutero GDP, immunization rates and mother's education

*/

**************************

* drop immunization data
drop *measles* *dpt* *merge

* merge in immunization data

sort country yearc
merge country yearc using immunization.dta

tab _merge
tab country if _merge==3

* rescale imm vars
sum lead*

gen dpt100=dpt/100 
gen measles100=measles/100
sum *100

* drop Namibia for imm rates
replace dpt100=. if country=="Namibia"
replace measles100=. if country=="Namibia"

* keep relevant years
replace dpt100=. if yearc<1985
replace measles100=. if yearc<1985

tab yearc if dpt100<.

rename lag_educfyrsc educfyrsc_lag
rename lag_lgdp lgdp_lag

global controls malec urban christian muslim otherrel cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educm2-educm4 educf2-educf4 
keep $controls tall1 tall2 short1 short2 shorthalf tallhalf height100 educfyrsc_lag lgdp_lag dpt100 measles100 countryid yearc country infant

foreach var of varlist tall1 tall2 short1 short2 shorthalf tallhalf height100 {
	gen `var'_educfyrsc_lag=`var'*educfyrsc_lag		
	gen `var'_dpt100=`var'*dpt100
	gen `var'_measles100=`var'*measles100
	gen `var'_lgdp_lag=`var'*lgdp_lag
	}
	
compress

* HEIGHT
* lgdp

xi: reg infant height100 height100_lgdp_lag $controls i.countryid*i.yearc, robust cluster(countryid) 
sum lgdp_lag infant height100 if e(sample)

* EFC
xi: reg infant height100 height100_educfyrsc_lag educfyrsc_lag $controls i.country*i.yearc, robust cluster(countryid) 
sum educfyrsc_lag height100 infant if e(sample)

*DPT
xi: reg infant height100 height100_dpt100 dpt100 $controls i.country*i.yearc, robust cluster(countryid) 
sum dpt100 height100 infant if e(sample)

* measles 

xi: reg infant height100 height100_measles100 measles100 $controls i.country*i.yearc, robust cluster(countryid) 
sum measles100 height100 infant if e(sample)

* HEIGHT DUMMIES
* lgdp

xi: reg infant tallhalf tall1 tall2 shorthalf short1 short2 tallhalf_lgdp_lag tall1_lgdp_lag tall2_lgdp_lag shorthalf_lgdp_lag short1_lgdp_lag short2_lgdp_lag lgdp_lag $controls i.countryid*i.yearc, robust cluster(countryid) 
sum lgdp_lag infant tallhalf tall1 tall2 shorthalf short1 short2 if e(sample)

* EFC
xi: reg infant tall1 tall2 short1 short2 shorthalf tallhalf tall1_educfyrsc_lag tall2_educfyrsc_lag short1_educfyrsc_lag short2_educfyrsc_lag tallhalf_educfyrsc_lag shorthalf_educfyrsc_lag educfyrsc_lag $controls i.country*i.yearc, robust cluster(countryid) 
sum educfyrsc_lag tall1 tall2 short1 short2 tallhalf shorthalf infant if e(sample)

*DPT
xi: reg infant tall1 tall2 short1 short2 shorthalf tallhalf tall1_dpt100 tall2_dpt100 short1_dpt100 short2_dpt100 tallhalf_dpt100 shorthalf_dpt100 dpt100 $controls i.country*i.yearc, robust cluster(countryid) 
sum dpt100 tall1 tall2 short1 short2 tallhalf shorthalf infant if e(sample)

* measles 

xi: reg infant tall1 tall2 short1 short2 shorthalf tallhalf tall1_measles100 tall2_measles100 short1_measles100 short2_measles100 tallhalf_measles100 shorthalf_measles100 measles100 $controls i.country*i.yearc, robust cluster(countryid) 
sum measles100 tall1 tall2 short1 short2 tallhalf shorthalf infant if e(sample)

log close
exit