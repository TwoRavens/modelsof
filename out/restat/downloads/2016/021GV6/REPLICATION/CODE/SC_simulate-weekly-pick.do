clear 
set more off
display "Starting ${sales}_${database}"


use "${dir_rawdata}\\${database}.dta", clear

* if "${sales}"=="nsfull" {
* display "nsfull"
* replace price=. if ${sales}sale==1
* }


*IMPORTANT --> ERASE ALL PRICE CHANGE DATA
keep id date price0 ${sales}price miss cat* bppcat 
*replace ${sales}price=. if miss==1

* merge m:1 id using "sample_ids_${sales}_${database}", keepusing(tag)
* keep if tag==1
* unique id

gen weekyear=wofd(date)
gen monthyear=mofd(date)
gen quarteryear=qofd(date)
gen dow=dow(date)
gen day=day(date)
*bysort id monthyear: egen monthlyprice=mean(price)

*keep only the price on dow=3 (wednesday)
keep if dow==${dow}

ren date daydate
gen date=weekyear
*reset panel structure
duplicates drop id date, force
tsset id date
tsfill
gen miss2=1 if ${sales}price==.

*complete variables in panel structure
by id: replace cat_url=cat_url[_n-1] if missing(cat_url)
by id: replace cat_url=cat_url[_N]

by id: replace category=category[_n-1] if missing(category)
by id: replace category=category[_N]

drop miss 
ren miss2 miss

*select category level to get average
drop category
gen category=bppcat


*******************
*SAVE MONTHLY SAMPLED VERSION
save "${dir_rawdata}\weekly_${dow}_${sales}_${database}.dta", replace
*******************




