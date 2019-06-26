***Set working dir, this has to be changed
cd "D:\Felix\JPR\replication files"
set more off
****Matching Ulfelder
***Create matched datasets
**Greedy Matching
use "Ulfelderdatafinal.dta", clear
sort regid
outsheet ccode regid begin RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup using "fullulf.csv", comma replace
stset regdur, failure(failure) scale(1)
logit RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup
predict double ps
*Evaluate Common Support
bysort RCdum: tab ps 
sort regid
set seed 333
generate x=uniform()
sort x
psmatch2 RCdum, pscore(ps) neighbor(1) noreplace common
keep if _weight==1
save greedysampleulf.dta, replace
outsheet ccode regid begin RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup using "greedyulf.csv", comma replace

**Caliper Matching
use "Ulfelderdatafinal.dta", clear
stset regdur, failure(failure) scale(1)
logit RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup
predict double ps
gen logit1=log((1-ps)/ps)
sum logit1
display 0.25*0.67
sort regid
set seed 333
generate x=uniform()
sort x
psmatch2 RCdum, pscore(ps) neighbor(1) noreplace caliper(0.1675) common
keep if _weight==1
save calipersampleulf.dta, replace
outsheet ccode regid begin RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup using "caliperulf.csv", comma replace

**Optimal Matching
use "Ulfelderdatafinal.dta", clear
sort regid
outsheet ccode regid begin RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup using "nvrulf.csv", comma replace

****Matching GWF
***Create matched datasets
**Greedy Matching
use "GWFdatafinal.dta", clear
outsheet ccode begin RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup using "fullgwf.csv", comma replace
stset regdur, failure(failure) scale(1)
logit RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup
predict double ps
*Evaluate Common Support
bysort RCdum: tab ps
sort regid
set seed 333
generate x=uniform()
sort x
psmatch2 RCdum, pscore(ps) neighbor(1) noreplace common
keep if _weight==1
save greedysamplegwf.dta, replace
outsheet ccode begin RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup using "greedygwf.csv", comma replace

**Caliper Matching
use "GWFdatafinal.dta", clear
stset regdur, failure(failure) scale(1)
logit RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup
predict double ps
gen logit1=log((1-ps)/ps)
sum logit1
display 0.20*0.73
sort regid
set seed 333
generate x=uniform()
sort x
psmatch2 RCdum, pscore(ps) neighbor(1) noreplace caliper(0.146) common
keep if _weight==1
save calipersamplegwf.dta, replace
outsheet ccode begin RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup using "calipergwf.csv", comma replace

**Optimal Matching
use "GWFdatafinal.dta", clear
sort regid
stset regdur, failure(failure) scale(1)
outsheet ccode regid begin RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup using "nvrgwf.csv", comma replace
