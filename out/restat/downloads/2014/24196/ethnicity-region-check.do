drop _all
capture clear matrix 
set more off
set virtual on
set memory 4g
set matsize 2000
set logtype text
capture log close
log using ethnicity-region-check, replace

use world_child3

** keep only children with full exposure

tab infant_exp
keep if infant_exp==1

**************************

/*
> v131 = ethnicity, not available for all samples
> v101 = region, available for some samples
> 
> v131/v101 not in world_child3 so merge in from world_child file (this is a larger DHS file not used for this analysis)
*/

**************************

dmerge caseid2 using world_child, ukeep(v131 v101)
keep if _merge==3

* check which countries we have v131 for
count
tab country if v131==.
tab country if v101==.

tab country if v131<.
tab country if v101<.

keep infant height100 lgdp malec urban christian muslim otherrel cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 countryid country yearc v131 v101
global controls malec urban christian muslim otherrel cbirthmth2-cbirthmth12 chld2-chld3 chldm4 age915 age1618 age2530 age3149 educf2-educf4 educm2-educm4 
compress

* eqn (1)
xi: reg infant height100 lgdp $controls i.v131 i.countryid*yearc i.yearc, cluster(countryid)
xi: reg infant height100 lgdp $controls i.v101 i.countryid*yearc i.yearc, cluster(countryid)

* now interact v131/v101 with country 

xi: reg infant height100 lgdp $controls i.countryid*i.v131 i.countryid*yearc i.yearc, cluster(countryid)
xi: reg infant height100 lgdp $controls i.countryid*i.v101 i.countryid*yearc i.yearc, cluster(countryid)

log close
exit
