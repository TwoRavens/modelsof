*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
* Appendix-Figure-1.do								*
*************************************************************************

drop _all

* food stamp start date
use foodstamps
sort stfips countyfips
keep stfips countyfips fs_year fs_month
save temppop1, replace

use fscbdata_short
sort stfips countyfips

merge stfips countyfips using temppop1
tab _merge

list countyname stfips  pop if pop<1000
drop if pop<1000

* list areas with no food stamp data

list countyname stfips countyfips fs_year if fs_year==.

* drop alaska
drop if stfips==2

* drop if bad farm land percent variable (>100%)
drop if farmlandpct>100

gen date = (fs_year-1961)*12 + fs_month

* make date pretty

gen day=15
gen edate=mdy(fs_month, day,fs_year)
format edate %dm-CY

** variable labels

label var farmlandpct60 "Percent of Land in Farming, 1960"
label var inc3k60 "Percent with Income<$3,000, 1960"
label var urban60 "Percent Urban, 1960"
label var black60 "Percent Black, 1960"
label var age560 "Percent of Population <5, 1960"
label var age6560 "Percent of Population >65, 1960"
label var date "Month Food Stamp Program Initiated (1=Jan 1961)"
label var edate "Month Food Stamp Program Initiated"


************
* figures
************

foreach var of varlist farmlandpct60 inc3k60 urban60 black60 age560 age6560 pop60 {

*twoway scatter edate `var' [weight=pop], msymbol(Oh) saving(`var', replace)  || lfit edate `var'[weight=pop]
twoway scatter edate `var' [weight=pop] if pop>10000, msymbol(Oh) saving(`var'1, replace)  || lfit edate `var'[weight=pop] if pop>10000

}

shell rm temppop1.dta
 


