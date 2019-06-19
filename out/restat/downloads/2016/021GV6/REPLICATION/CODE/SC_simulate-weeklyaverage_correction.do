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

gen originalprice=${sales}price
replace ${sales}price=weeklyprice

gen stringprice=string(${sales}price)
split stringprice, parse(.) 

destring stringprice2, force replace
gen imputed=1 if stringprice2>99 & stringprice2!=.

replace ${sales}price=. if imputed==1


tsset id date
*replace weeklyprice with previous (but not on initial and last spells)
tsspell ${sales}price, spell(spell${sales}price) seq(seq${sales}price) end(end${sales}price)
bysort id: egen maxspell${sales}price=max(spell${sales}price)
gen full${sales}price=${sales}price
by id: replace full${sales}price=l.full${sales}price if imputed==1&  ${sales}price==. & spell${sales}price!=maxspell${sales}price & seq${sales}price <=20
gen initialspell=1 if spell${sales}price==1
gen lastspell=1 if spell${sales}price==maxspell${sales}price
drop spell${sales}price seq${sales}price end${sales}price maxspell${sales}price
drop ${sales}price
ren full${sales}price ${sales}price

 

*******************
*SAVE WEEKLY SAMPLED VERSION
save "${dir_rawdata}\weekly_average_correction_${sales}_${database}.dta", replace
*******************

