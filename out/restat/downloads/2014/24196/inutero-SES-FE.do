drop _all
set more off
set virtual on
set memory 3g
set matsize 2000
set logtype text
capture log close
log using inutero-SES-FE, replace

* This do file:

******************************
***	THIS DO FILE
******************************

* runs SES regs for LAGGED SES, to relate to fetal origins work
* includes FE

* create mother education avgs

use world_child

* keep only relevant countries ie for which hts data exist, from the "original" world file - where we do not trim births

keep if country=="Benin" | country=="Brazil" | country=="Burkina Faso" | country=="CAR" | country=="Cambodia" | country=="Cameroon" | country=="Chad" | country=="Colombia" | country=="Comoros" | country=="Cote d'Ivoire" | country=="Dominican Republic" | country=="Egypt" | country=="Ethiopia" | country=="Gabon" | country=="Ghana" | country=="Guinea" | country=="Haiti" | country=="Honduras" | country=="India" | country=="Kenya" | country=="Lesotho" | country=="Madagascar" | country=="Malawi" | country=="Mali" | country=="Morocco" | country=="Mozambique" | country=="Namibia" | country=="Nicaragua" | country=="Niger" | country=="Peru" | country=="Rwanda" | country=="Senegal" | country=="Tanzania" | country=="Togo" | country=="Turkey" | country=="Uganda" | country=="Zambia" | country=="Zimbabwe"

collapse (mean) educfyrs, by(country yearc)
rename educfyrs educfyrsc

egen countryid=group(country)

xtset countryid yearc

gen educfyrsc_lag=L.educfyrsc

keep country yearc educfyrsc_lag

sort country yearc
save educflag-temp.dta, replace

clear

* create lagged gdp

use penn

xtset countryid yearc

gen lgdp_lag=l.lgdp

keep country yearc lgdp_lag
sort country yearc

save laggdp-temp.dta, replace

clear

* create lagged immunization rates

use immunization.dta

keep if yearc>1984 & yearc<2001
egen countryid=group(country)

xtset countryid yearc

* rescale imm vars
gen dpt100=dpt/100
gen measles100=measles/100

* generate lags
gen dpt100_lag=l.dpt100
gen measles100_lag=l.measles100

* drop Namibia
drop if country=="Namibia"

keep country yearc dpt100_lag measles100_lag
sort country yearc

save imm-lag-temp.dta, replace

* merge newly created vars into our world file

use world_child3

* merge in mother education avgs

sort country yearc
merge country yearc using educflag-temp.dta, _merge(educ_merge)
tab yearc if educ_merge==1

tab educ_merge

* merge in lgdp

sort country yearc
merge country yearc using laggdp-temp.dta, _merge(gdp_lag_merge)
tab gdp_lag_merge

* merge in immunization

sort country yearc
merge country yearc using imm-lag-temp.dta, _merge(imm_merge)

tab imm_merge

** keep only children with full exposure

tab infant_exp
keep if infant_exp==1

* rescale height

gen height100=imputed_height/100

sort caseid2
egen motherid=group(caseid2)

xtset motherid

* generate interactions

gen height100_educfyrsc_lag=height100*educfyrsc_lag
gen height100_lgdp_lag=height100*lgdp_lag
gen height100_dpt100_lag=height100*dpt100_lag
gen height100_measles100_lag=height100*measles100_lag

* gen var for if women have > 1 kids
bys caseid2: gen kids=_N

***********************************
****		REGRESSIONS
***********************************

* education of mothers, average

xi: xtreg infant height100 height100_educfyrsc_lag educfyrsc_lag urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, fe vce(cluster countryid) 
sum educfyrsc_lag height100 infant if e(sample)

* lgdp

xi: xtreg infant height100 height100_lgdp_lag lgdp_lag malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 urban age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.countryid*yearc i.yearc, fe vce(cluster countryid) 
outreg using SES-lagged-FE-ht, append ctitle("interactions with gdp") bracket coefast se
sum lgdp_lag height100 infant if e(sample) 

* dpt imm

xi: xtreg infant height100 height100_dpt100_lag dpt100_lag urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, fe vce(cluster countryid) 
outreg using SES-lagged-FE-ht, append ctitle("FE") bracket coefast se
sum dpt100_lag height100 infant if e(sample) 

* measles imm

xi: xtreg infant height100 height100_measles100_lag measles100_lag urban malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 christian muslim otherrel i.country*yearc i.yearc, fe vce(cluster countryid) 
outreg using SES-lagged-FE-ht, append ctitle("FE") bracket coefast se
sum measles100_lag height100 infant if e(sample) 

************************************************

log close
exit