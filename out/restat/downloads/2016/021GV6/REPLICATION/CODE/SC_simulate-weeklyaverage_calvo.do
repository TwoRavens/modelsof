clear 
set more off
display "Starting ${sales}_${database}"
****************************************************************************************
***WEEKLY SAMPLING. PRICE CALCULATIONS***********
use "${dir_rawdata}\\${database}.dta", clear


*IMPORTANT --> ERASE ALL PRICE CHANGE DATA
keep id date price0 ${sales}price miss cat* bppcat 

*In this case we are not removing the carried forwarded/filled prices. So comment below (unless the non-filled version)
*replace ${sales}price=. if ${sales}sale==1

gen weekyear=wofd(date)
gen monthyear=mofd(date)
gen quarteryear=qofd(date)
gen dow=dow(date)

bysort id weekyear: egen weeklyprice=mean(${sales}price)

* *to randomize price chosen within a week
* drop if miss==1
* gen random=uniform()
* sort id weekyear random 
* drop tag
egen tag=tag(id weekyear)
*drop others
drop if tag!=1
drop tag

ren date daydate
gen date=weekyear 

* ****

replace ${sales}price=weeklyprice

*******************
*SAVE WEEKLY SAMPLED VERSION
save "${dir_rawdata}\weekly_average_${sales}_${database}.dta", replace
*******************

