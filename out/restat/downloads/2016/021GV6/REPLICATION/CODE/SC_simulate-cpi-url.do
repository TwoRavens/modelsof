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
replace ${sales}price=. if miss==1

* merge m:1 id using "sample_ids_${sales}_${database}", keepusing(tag)
* keep if tag==1
* unique id

gen weekyear=wofd(date)
gen monthyear=mofd(date)
gen quarteryear=qofd(date)
gen dow=dow(date)
gen day=day(date)
*bysort id monthyear: egen monthlyprice=mean(price)

*keep only the price on day=15 each month
keep if day==15

**to randomize price chosen within a month. Randomize the day per id. Then choose the price on that same day of the month for each id. 
* gen random=uniform()
* bysort id day: egen dayrandom=max(random)
* bysort id : egen maxrandom=max(dayrandom)
* gen keep=1 if maxrandom==dayrandom
* sort id monthyear day 
* drop tag
* keep if keep==1
* egen tag=tag(id monthyear)
* *drop others
* drop if tag!=1


ren date daydate
gen date=monthyear
*reset panel structure
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


***PRICE IMPUTATION, USING BLS "Cell-relative" method, BLS manual, page 23
* First, use original price to get relative (note, no mprice here)
gen relative=${sales}price/l.${sales}price
* correct for outliers (5 times previous price or 0.1 of previous price)
replace relative=1 if relative>5 & relative!=. 
replace relative=1 if relative<0.1 & relative!=. 


bysort cat_url date: egen cat_mean_nonmiss=gmean(relative)
* Sometime ALL items within a category are missing. In that case, assume relative in the category==1
replace cat_mean_nonmiss=1 if cat_mean_nonmiss==.
* Now impute price (previous times inflation of the category non-miising items)
tsset id date
gen imputedprice0=.
replace imputedprice0=cond(l.imputedprice0==.,l.${sales}price*cat_mean_nonmiss, l.imputedprice0*cat_mean_nonmiss) if miss==1 
*& initialspell!=1 & lastspell!=1  

* combine it
gen imputedprice=${sales}price if miss==.
replace imputedprice=imputedprice0 if miss==1

drop relative cat_mean_nonmiss imputedprice0
drop ${sales}price
gen ${sales}price=imputedprice


*******************
*SAVE MONTHLY SAMPLED VERSION
save "${dir_rawdata}\cpi_url_${sales}_${database}.dta", replace
*******************




