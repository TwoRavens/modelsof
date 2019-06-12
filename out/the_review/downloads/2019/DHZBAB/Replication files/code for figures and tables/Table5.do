clear all

* only keep children of the household head
use FNIdataset if relate==3, clear

gen postwar=(birthyear>=1917)   
gen inter=postwar*german

* for father's arrival year fixed effects
replace yrsusa1_pop=. if yrsusa1_pop==0
gen arrivalyr_pop=year-yrsusa1_pop

* linear trend 
sum birthyear, det
local minyear=r(min)
local maxyear=r(max)-r(min)
gen t=birthyear-`minyear'+1

* make unique household identifier
egen group=group(serial year)

* keep households with more than one member (i.e. at least two siblings)
by group, sort: egen hhmembers=count(pernum) 
keep if hhmembers>1

* create birth order variable
by group, sort: egen birthorder=rank(age), field

* drop observations with missing values in any of the variables we need for regressions (to speed things up)
drop if FNI==.|inter==.|birthyear==.|birthorder==.|group==.


* Regression without FE in the sample of families
estimates clear
areg FNI inter i.ethnicgroup, cluster(ethnicgroup) absorb(birthyear)
eststo m1
* Regression with family FE in the same sample
areg FNI inter i.ethnicgroup i.birthyear, cluster(ethnicgroup) absorb(group)
eststo m2
areg FNI inter i.birthyear i.ethnicgroup i.bpl, cluster(ethnicgroup) absorb(group)
eststo m3
areg FNI inter i.birthyear i.ethnicgroup i.birthorder i.bpl, cluster(ethnicgroup) absorb(group)
eststo m4
areg FNI inter i.birthyear i.ethnicgroup i.birthorder i.bpl i.arrivalyr_pop, cluster(ethnicgroup) absorb(group)
eststo m5

esttab m* using "Table5.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) stats(N r2) keep(inter)
