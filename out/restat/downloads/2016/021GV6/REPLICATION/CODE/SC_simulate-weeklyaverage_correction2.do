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

gen secondigit=substr(stringprice2,2,1)

gen imputed=1 if secondigit!="5" &  secondigit!="9" & secondigit!=""

replace ${sales}price=. if imputed==1


tsset id date
*replace weeklyprice with previous (but not on initial and last spells)
tsspell ${sales}price, spell(spellprice) seq(seqprice) end(endprice)
bysort id: egen maxspellprice=max(spellprice)
by id: replace ${sales}price=l.${sales}price if imputed==1&  ${sales}price==. & spellprice!=maxspellprice & seqprice <=20
gen initialspell=1 if spellprice==1
gen lastspell=1 if spellprice==maxspellprice
drop spellprice seqprice endprice maxspellprice
*drop price
 

*******************
*SAVE WEEKLY SAMPLED VERSION
save "${dir_rawdata}\weekly_average_correction2_${sales}_${database}.dta", replace
*******************

