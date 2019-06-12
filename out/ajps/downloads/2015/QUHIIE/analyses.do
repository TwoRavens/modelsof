clear all

* Table 2 - Students
use "students_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor i.issue, fe vce(cluster idno)

* Table 2 - MTurkA
use "mturka_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor i.issue, fe vce(cluster idno)

* Table 2 - MTurkB
use "mturkb_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor i.issue, fe vce(cluster idno)

* Table 2 - SSI
use "ssi_working.dta", clear
xtset idno
xtreg comp extfold imp relev smor i.issue, fe vce(cluster idno)

* Table 3
use "GfKWorking.dta", clear
svyset [pw=weight]
svy: reg comppref extfold imp relev mc
svy: reg comppref extfold imp relev mc income
svy: reg comppref extfold imp relev mc dpidstr rpidstr church

* Table 4
use "GfKWorking.dta", clear
svyset [pw=weight]
svy: prop wta if VERSION==1 // Tea Party version
svy: prop wta if VERSION==2 // PCCC version

* Table 5
use "GfKWorking.dta", clear
svyset [pw=weight]
svy: oprobit wta extfold imp relev mc
svy: oprobit wta extfold imp relev mc income
svy: oprobit wta extfold imp relev mc dpidstr rpidstr church
svy: oprobit wta extfold imp relev mc dpidstr rpidstr church if socsecop<.5 & socsecop!=.
svy: oprobit wta extfold imp relev mc dpidstr rpidstr church if socsecop>.5 & socsecop!=.

* Figure 1
use "ssi_working.dta", clear
gen compse = comp // avoids a name conflict when you collapse the dataset
collapse (mean) comp (semean) compse, by(smorhigh exthigh)

gen sehigh = comp+compse
gen selow = comp-compse
gen space = .
replace space = 1 if exthigh==0 & smorhigh==0
replace space = 2 if exthigh==0 & smorhigh==1
replace space = 3.5 if exthigh==1 & smorhigh==0
replace space = 4.5 if exthigh==1 & smorhigh==1

twoway (bar comp space if smorhigh==0) ///
	(bar comp space if smorhigh==1)  ///
	(rcap sehigh selow space, lcolor(black)), ///
	legen(row(1) order(1 "Moral conviction < 1" 2 "Moral conviction = 1")) ///
	xlabel(1.5 "Extremity < 1" 4 "Extremity = 1") ///
	xtitle("") title("") ysc(r(.3 .6)) ylab(.3(.05).6) ///
	graphregion(color(white))
