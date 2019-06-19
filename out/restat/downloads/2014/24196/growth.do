drop _all
set more off
set logtype text
capture log close
set mem 3g
set matsize 5000

log using growth, replace

use world_child3

* rescale height

* this do file runs cohort regressions on three samples 
* 1) those with substantial amounts of growth i.e. growth > 1.5%
* 2) those with significant negative growth i.d. growth > - 1.5%
* 3) those with growth not significantly different from zero

* two cohort groups: 1970-75, 1990-95

gen pos_growth=(country=="Egypt" | country=="Lesotho" | country=="Morocco" | country=="Mali" | country=="Colombia" | country=="Dominican Republic" | country=="India" | country=="Turkey")
tab country if pos_growth==1
sum pos_growth

gen neg_growth=(country=="Gabon" | country=="Madagascar" | country=="Togo" | country=="Zambia" | country=="Nicaragua" | country=="Cambodia")
tab country if neg_growth==1
sum neg_growth

gen insig_growth=(country=="Benin" | country=="Cameroon" | country=="Chad" | country=="Comoros" | country=="Cote d'Ivoire" | country=="Ghana" | country=="Guinea" | country=="Mozambique" | country=="Namibia" | country=="Rwanda" | country=="Senegal" | country=="Tanzania" | country=="Uganda" | country=="Zimbabwe" | country=="Haiti")
tab country if insig_growth==1
sum insig_growth

drop cohort*

gen cohort1=(yearc>1969 & yearc<1976)
replace cohort1=. if yearc==.
sum cohort1

gen cohort2=(yearc>1989 & yearc<1996)
replace cohort2=. if yearc==.
sum cohort2

tab yearc if cohort1==1
tab yearc if cohort2==1

* (1) pos growth countries

xi: reg infant height100 malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 urban age915 age1618 age2530 age3149 christian muslim otherrel educf2-educf4 educm2-educm4 i.countryid*i.yearc if pos_growth==1 & cohort1==1
sum infant height100 lgdp if e(sample)

xi: reg infant height100 malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 urban age915 age1618 age2530 age3149 christian muslim otherrel educf2-educf4 educm2-educm4 i.countryid*i.yearc if pos_growth==1 & cohort2==1
sum infant height100 lgdp if e(sample)

* (2) neg growth countries

xi: reg infant height100 malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 urban age915 age1618 age2530 age3149 christian muslim otherrel educf2-educf4 educm2-educm4 i.countryid*i.yearc if neg_growth==1 & cohort1==1
sum infant height100 lgdp if e(sample)

xi: reg infant height100 malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 urban age915 age1618 age2530 age3149 christian muslim otherrel educf2-educf4 educm2-educm4 i.countryid*i.yearc if neg_growth==1 & cohort2==1
sum infant height100 lgdp if e(sample)

* (3) insig growth countries

xi: reg infant height100 malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 urban age915 age1618 age2530 age3149 christian muslim otherrel educf2-educf4 educm2-educm4 i.countryid*i.yearc if insig_growth==1 & cohort1==1
sum infant height100 lgdp if e(sample)

xi: reg infant height100 malec cbirthmth2-cbirthmth12 chld2-chld3 chldm4 urban age915 age1618 age2530 age3149 christian muslim otherrel educf2-educf4 educm2-educm4 i.countryid*i.yearc if insig_growth==1 & cohort2==1
sum infant height100 lgdp if e(sample)

log close
exit
