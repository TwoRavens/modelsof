clear all

*******************************************************************************/


use CPS_2000_2013.dta, clear

tab labforce
keep if labforce==2


preserve
collapse  (mean) age [pw=wtsupp], by(statefip year)
rename age avgage
tempfile a
save `a', replace

keep if year==2000
rename avgage avgage2000
tempfile b
save `b', replace

restore

gen educstr="ltbd"
replace educstr="bdplus" if educ==111 | educ==123 | educ==124 | educ==125
tab educstr

gen count=1

collapse (sum) count [pw=wtsupp], by(statefip year educstr)
reshape wide count, i(statefip year) j(educstr) string

egen count=rowtotal(countbdplus countltbd)
gen bdshare=(countbdplus/count)*100
tempfile c
save `c'

keep if year==2000
rename bdshare bdshare2000
tempfile d
save `d'

use `a', clear
merge 1:1 statefip year using `c', nogen
merge m:1 statefip using `b', nogen
merge m:1 statefip using `d', nogen

save cps_allcovariates.dta, replace



preserve

tab age

tab educ
capture drop yeduc
gen yeduc=.
replace yeduc= 0 if educ==2
replace yeduc= 2.5 if educ==10
replace yeduc= 5.5 if educ==20
replace yeduc= 7.5 if educ==30
replace yeduc= 9 if educ==40
replace yeduc= 10 if educ==50
replace yeduc= 11 if educ==60
replace yeduc= 11 if educ==71
replace yeduc= 12 if educ==73
replace yeduc= 13 if educ==81
replace yeduc= 14 if educ==91 | educ==92
replace yeduc= 16 if educ==111
replace yeduc= 18 if educ==123
replace yeduc= 21 if educ==124 | educ==125
label variable yeduc "years of education"

capture drop exper
gen exper= age - yeduc - 6
label variable exper "potential work experience "

collapse  (mean) exper [w=wtsupp], by(statefip year)
rename exper avgexp
tempfile a
save `a', replace

keep if year==2000
rename exper avgexp2000
tempfile b
save `b', replace

restore
