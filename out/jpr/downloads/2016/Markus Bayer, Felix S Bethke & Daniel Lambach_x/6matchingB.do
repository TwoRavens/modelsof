***generate sample based on optimal matching
***Ulfelder data
cd "D:\Felix\JPR\replication files"
use "Ulfelderdatafinal.dta", clear
stset regdur, failure(failure) scale(1)
merge 1:1 ccode begin using "optmulf.dta"
drop _m
rename weights optweight
rename subclass optpair
rename distance optps
keep if optweight==1
save optimalsampleulf.dta, replace
outsheet ccode regid begin RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup using "optimalulf.csv", comma replace

***GWF data
use "GWFdatafinal.dta", clear
stset regdur, failure(failure) scale(1)
merge 1:1 ccode begin using "optmgwf.dta"
drop _m
rename weights optweight
rename subclass optpair
rename distance optps
keep if optweight==1
save optimalsamplegwf.dta, replace
outsheet ccode begin RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup using "optimalgwf.csv", comma replace


