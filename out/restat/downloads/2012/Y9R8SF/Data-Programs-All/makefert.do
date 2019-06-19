*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
*************************************************************************

************************
* makefert.do
* makes fertility data to be used in fertility of "at risk" population analysis
* this program merges together birth counts (from natality files) and 
*  population counts (from NBER) to use in fertility rate regressions
*
************************

drop _all
set memory 500m
set more off
capture log close

tempfile tfcount tf tf1 tfcount1


***************
* (1) Data set 1: Births by race x stfips x countyfips x year x month
***************

* created in mergenat.do

use natality_main, clear
keep if mom_race==1|mom_race==2
collapse (max) fs* (sum) nbirths, by(mom_race stfips countyfips year month)
save `tf', replace

sum

sort mom_race stfips countyfips year month

save `tfcount'

*
* merge with (annual) population counts 
*

use pop6879long, clear

*we only need 68-77
drop if year>1977

*drop AK (missing fs data)
drop if stfips==2

/* variables in the pop file
racesex1=White male
2=White female
3=Black male
4=Black female
5=Other male
6=Other female
*/

drop if racesex==1|racesex==3|racesex==5|racesex==6

gen mom_race=1 if racesex==2
replace mom_race=2 if racesex==4

drop racesex

*fix (some) VA counties
do countyfix.do

collapse (sum) pop*, by(mom_race stfips countyfips year)

*need to make into 12 months - this way when it merges we can assign 0 births to county months that don't merge
expand 12
gen month=.
sort mom_race stfips countyfips year
by mom_race stfips countyfips year: replace month=_n

sort mom_race stfips countyfips year month

merge mom_race stfips countyfips year month using `tfcount'
tab _merge
tab stfips _merge

* construct denominators for population to create fertility rates
* Notes: all population figures are women, white and black separately, other dropped
*        all population figures are ANNUAL, now we just assign annual value to all months
* Base regs use women age 15-44
* Alt regs estimate fertility model by age of mom: 15-19, 20-24, 25-34, 35-44
* (Those are added below)

egen pop1544=rsum(pop1519_-pop3544_)
replace pop1544=. if _merge==2

*the mismerged items (1) are the result of being places with few people - and consequently, there are low prob of having births
tab _merge if pop1544>1000
tab _merge if pop1544>500
tab _merge if pop1544>100

tab _merge mom_race


**********
*drop counties that didn't merge correctly
*IMPORTANT: _merge = 1 => items did not merge becuase they are countyxmonth with no birth's - so we should set nbirths to 0 (I do this below)
*thus, keep counties that had merge=1 if there was another county entry ==3, or there was another countyxmonth with non-zero births for the same county
*counties that failed to merge b/c no pop data, _merge==2 , are dropped here.
**********
sort stfips countyfips
egen _merge2=max(_merge), by(mom_race stfips countyfips)

tab _merge _merge2

drop if _merge2!=3
drop if _merge==2
tab _merge
sum pop1544 if _merge==1

drop _merge*

sum

compress

desc

************
*FOR COUNTIES WITH 0 birth months, fs data goes to missing b/c the way code works above - this fixes that
************

foreach var of varlist fs* {
sort stfips countyfips
egen dum=max(`var'), by(stfips countyfips)
replace `var'=dum if `var'==.
drop dum
}

replace nbirths=0 if nbirths==.

* get a sense if the magnitudes are correct
* tabulate the total number of numerator and denomonitor by race and total
*
* sum of population is only month 1 because it is annual pop for each month

table year mom_race, c(sum nbirths)
table year mom_race if month==1, c(sum pop1544)

save fertility, replace



****************
* Data set 2: Births by momage x race x stfips x countyfips x year x month
****************

* created by mergedat.do

use natality_agedet, clear

* Note with detailed ages, we never need all races, so I drop mom_race==9

keep if mom_race==1|mom_race==2
collapse (max) fs* (sum) nbirths, by(mom_race mom_agedet stfips countyfips year month)
save `tf1', replace

sum

sort mom_race stfips countyfips year month mom_agedet

save `tfcount1'

*
* merge with (annual) population counts 
*

use pop6879long, clear

*we only need 68-77
drop if year>1977

*drop AK (missing fs data)
drop if stfips==2

/* variables in the pop file
racesex1=White male
2=White female
3=Black male
4=Black female
5=Other male
6=Other female
*/

* Again, do not need other races for detailed age work

drop if racesex==1|racesex==3|racesex==5|racesex==6

gen mom_race=1 if racesex==2
replace mom_race=2 if racesex==4

drop racesex

*fix (some) VA counties
do countyfix.do

collapse (sum) pop*, by(mom_race stfips countyfips year)

*need to make into 12 months - this way when it merges we can assign 0 births to county months that don't merge
expand 12
gen month=.
sort mom_race stfips countyfips year
by mom_race stfips countyfips year: replace month=_n

sort mom_race stfips countyfips year month

* note: since birth counts are by age of mom and pop counts are for all so multiple matches
merge mom_race stfips countyfips year month using `tfcount1'
tab _merge
tab stfips _merge

* construct denominators for population to create fertility rates
* Notes: all population figures are white and black separately, other dropped
*        all population figures are ANNUAL, now we just assign annual value to all months
* 	these tabs are for regs by age of mom, so denominator has to match numerator
* 	15-19, 20-24, 25-34, 35-44
* 

gen popage=pop1519_ if mom_agedet==1
replace popage=pop2024_ if mom_agedet==2
replace popage=pop2534_ if mom_agedet==3
replace popage=pop3544_ if mom_agedet==4
replace popage=. if _merge==2


*the mismerged items (1) are the result of being places with few people - and consequently, there are low prob of having births
tab _merge if popage>1000
tab _merge if popage>500
tab _merge if popage>100

tab _merge mom_race
tab _merge mom_agedet


**********
* Drop counties that didn't merge correctly
*
* IMPORTANT: _merge = 1 => items did not merge becuase they are countyxmonth with no birth's 
*	This means we have to set nbirths to 0 (I do this below)
* 
* We keep counties that had _merge=1 if there was another county entry with _merge==3, 
* or there was another countyxmonth with non-zero births for the same county
*
* Counties that failed to merge b/c no pop data, _merge==2 , are dropped here.
**********

sort stfips countyfips
egen _merge2=max(_merge), by(mom_race stfips countyfips)

tab _merge _merge2

drop if _merge2!=3
drop if _merge==2
tab _merge
sum popage if _merge==1

drop _merge*

sum

compress

desc

************
*FOR COUNTIES WITH 0 birth months, fs data goes to missing b/c the way code works above - this fixes that
************

foreach var of varlist fs* {
sort stfips countyfips
egen dum=max(`var'), by(stfips countyfips)
replace `var'=dum if `var'==.
drop dum
}

replace nbirths=0 if nbirths==.

* get a sense if the magnitudes are correct
* tabulate the total number of numerator and denomonitor by race and total
*
* sum of population is only month 1 because it is annual pop for each month

table year mom_agedet if mom_race==1, c(sum nbirths)
table year mom_agedet if mom_race==2, c(sum nbirths)

table year mom_agedet if month==1 & mom_race==1, c(sum popage)
table year mom_agedet if month==1 & mom_race==2, c(sum popage)

save fertility_age, replace


log close

