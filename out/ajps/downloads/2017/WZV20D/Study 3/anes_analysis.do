* This file analyzes the 2008-2009 ANES Panel dataset for use in Study 3 of Ryan,
* "How Do Indifferent Voters Decide" (AJPS). Analysis was conducted on 
* Stata/SE 14.2 for Mac (64-bit Intel).

clear all
set more off

* Figure 1
use "anes_working.dta", clear
drop if omampbad==1
set seed 1789 // Arbitrary number (year UNC founded)
sample 10 // Sample 10% of responses. Otherwise figure is too cluttered.
twoway (scatter explicit2 intensity if oiacat==0, m(x) mcolor(gs0) msize(2) jitter(5)) ///
	(scatter explicit2 intensity if oiacat==2, m(Sh) mcolor(gs8) mlw(thin) msize(2) jitter(5)) ///
	(scatter explicit2 intensity if oiacat==1, m(O) mcolor(gs9) mlc(gs0) mlw(thin) msize(1) jitter(5)) ///
	(scatter explicit2 intensity if intensity==., m(x) mcolor(gs0) msize(*2)) ///
	(scatter explicit2 intensity if intensity==., m(Sh) mcolor(gs8) msize(*2)) ///
	(scatter explicit2 intensity if intensity==., m(O) mcolor(gs9) mlc(gs0) mlw(thin) msize(*2)), ///
	title("") graphregion(color(white)) xlab(0(1)6) ylab(-6(1)6) ///
	xtitle("Intensity score") ytitle("") yline(0, lcolor(black)) ytitle("Obama - McCain Liking") ///
	legend(order(4 "One-sided" 5 "Ambivalent" 6 "Indifferent") rows(1))

* Figure 3
use "anes_working.dta", clear
drop if omampbad==1
set seed 1789
twoway (scatter implicit explicit, graphregion(color(white)) msize(vtiny) mcolor(black) jitter(2)) ///
	(lowess implicit explicit, lpattern(dash)), ///
	legend(off) ytitle("Implicit Obama Preference") ///
	xlab(-1(.5)1) xtitle("Explicit Obama Preference") ylab(-1(.5)1) title("")
	
* Table 1: Main entries
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1

svy: mean knowlsum3 if oiacat==0
svy: mean knowlsum3 if oiacat==1
svy: mean knowlsum3 if oiacat==2

svy: mean polint if oiacat==0
svy: mean polint if oiacat==1
svy: mean polint if oiacat==2

svy: mean needcog if oiacat==0
svy: mean needcog if oiacat==1
svy: mean needcog if oiacat==2

svy: mean news if oiacat==0
svy: mean news if oiacat==1
svy: mean news if oiacat==2

svy: mean efficacy if oiacat==0
svy: mean efficacy if oiacat==1
svy: mean efficacy if oiacat==2

svy: mean voter if oiacat==0
svy: mean voter if oiacat==1
svy: mean voter if oiacat==2

svy: mean educ if oiacat==0
svy: mean educ if oiacat==1
svy: mean educ if oiacat==2

svy: mean pidstr if oiacat==0
svy: mean pidstr if oiacat==1
svy: mean pidstr if oiacat==2

svy: mean ideolext if oiacat==0
svy: mean ideolext if oiacat==1
svy: mean ideolext if oiacat==2

svy: mean abortfold if oiacat==0
svy: mean abortfold if oiacat==1
svy: mean abortfold if oiacat==2

svy: mean envirofold if oiacat==0
svy: mean envirofold if oiacat==1
svy: mean envirofold if oiacat==2

svy: mean floater if oiacat==0
svy: mean floater if oiacat==1
svy: mean floater if oiacat==2

tab oiacat if wgtcs11!=0 // N for each column

* Table 1: Hypothesis tests (for table superscripts)
* Column 1 vs. Cols 2 and 3:
svy: reg knowlsum3 i.oiacat
svy: reg polint i.oiacat
svy: reg needcog i.oiacat
svy: reg news i.oiacat
svy: reg efficacy i.oiacat
svy: reg voter i.oiacat
svy: reg educ i.oiacat
svy: reg pidstr i.oiacat
svy: reg ideolext i.oiacat
svy: reg abortfold i.oiacat
svy: reg envirofold i.oiacat
svy: reg floater i.oiacat

* Column 2 vs. Column 3
svy: reg knowlsum3 b2.oiacat
svy: reg polint b2.oiacat
svy: reg needcog b2.oiacat
svy: reg news b2.oiacat
svy: reg efficacy b2.oiacat
svy: reg voter b2.oiacat
svy: reg educ b2.oiacat
svy: reg pidstr b2.oiacat
svy: reg ideolext b2.oiacat
svy: reg abortfold b2.oiacat
svy: reg envirofold b2.oiacat
svy: reg floater b2.oiacat

* Table 3
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1
svy, subpop(if oiacat!=0): probit obvote c.implicit##i.oiacat c.explicit##i.oiacat i.educ2 i.region white black hispanic income female i.pid2 if oiacat!=0
margins, dydx(implicit) at(oiacat=(1 2)) atmeans
margins, dydx(explicit) at(oiacat=(1 2)) atmeans
quietly: probit obvote c.implicit##i.oiacat c.explicit##i.oiacat i.educ2 i.region white black hispanic income female i.pid2 if oiacat!=0 // Same model, but unweighted, to set up the next command.
tab oiacat if e(sample) & wgtcs11!=0 // Reveal N for model. (Table caption.)

* Table 4
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1
svy: reg w19state c.w9state##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
quietly: reg w19state c.w9state##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2 // unweighted model
tab oiacat if e(sample) & wgtcs11!=0 // Reveal N for model. (Table caption.)

* Table 5
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1
svy: reg w19approve17 c.w17approve17##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.educ2 i.region white black hispanic income female i.pid2 // health care
margins, dydx(implicit) at(oiacat=(0 1 2))
margins, dydx(explicit) at(oiacat=(0 1 2))
svy: reg w19approve15 c.w17approve15##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.educ2 i.region white black hispanic income female i.pid2 // education
margins, dydx(implicit) at(oiacat=(0 1 2))
margins, dydx(explicit) at(oiacat=(0 1 2))

* Text: Proportion of respondents in each OIA category
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1
svy: tab oiacat

* Text: Sample size
use "anes_working.dta", clear
tab w10flag

* Text: Internal consistency of AMP: See separate file AMP_Reliability.

* Text: Voting pattern among the one-sided. How many voted against one-sided preference?
use "anes_working.dta", clear
drop if omampbad==1
tab oiacat if obvote!=. // 1,109 one-sided voters
sort explicit2
by explicit2: tab obvote if oiacat==0 // Count instances were explicit2 is negative and obvote==1, or instances where explicit2 is positive and obvote==0. There are only 4 such cases. So 4 of 1,109 one-sided voters voted against one-sided preference.

* Text: reliability of national assessments
use "anes_working.dta", clear
drop if omampbad==1
alpha w9state1-w9state12 // September reliability = .84
alpha w19state1-w19state14 // July reliability = .84

* Figure SI-1
use "anes_working.dta", clear
gen one = 1
collapse (count) one [pw=wgtcs11], by(ambiv)
drop if ambiv==. 
sum one // 18 * 139.2734 = total weighted N of 2506.9212
gen prop = one / 2506.9212 // Calculate proportions
twoway (bar prop ambiv if ambiv<3.5, barw(.4) color(red)) ///
	(bar prop ambiv if ambiv>=3.5 & ambiv<=4.5, barw(.4) color(green)) ///
	(bar prop ambiv if ambiv>4.5, barw(.4) color(blue)), ///
	xlab(-2(1)7) legend(order(1 "One-sided" 2 "Indifferent" 3 "Ambivalent") row(1)) ///
	graphregion(color(white)) ytitle("Proportion") xtitle("Ambivalence Score (Standard)")

* Figure SI-2: Left panel
use "anes_working.dta", clear
drop if omampbad==1
set seed 1789
twoway (scatter explicit2 intensity if oiacat_alt==0, m(o) mcolor(red) msize(tiny) jitter(7)) ///
	(scatter explicit2 intensity if oiacat_alt==2, m(o) mcolor(green) msize(tiny) jitter(7)) ///
	(scatter explicit2 intensity if oiacat_alt==1, m(o) mcolor(blue) msize(tiny) jitter(7)) ///
	(scatter explicit2 intensity if intensity==., m(o) mcolor(red) msize(*2)) ///
	(scatter explicit2 intensity if intensity==., m(o) mcolor(green) msize(*2)) ///
	(scatter explicit2 intensity if intensity==., m(o) mcolor(blue) msize(*2)), ///
	graphregion(color(white)) xlab(0(1)6) ylab(-6(1)6) ///
	title("Rudolph (2011)") legend(order(4 "One-sided" 5 "Ambivalent" 6 "Indifferent") rows(1)) ///
	graphregion(color(white)) xlab(0(1)6) ylab(-6(1)6) xtitle("Intensity score") ///
	ytitle("Obama - McCain Liking") yline(0)
	
* Figure SI-2: Right panel
set seed 1789
twoway (scatter explicit2 intensity if oiacat==0, m(o) mcolor(red) msize(tiny) jitter(7)) ///
	(scatter explicit2 intensity if oiacat==2, m(o) mcolor(green) msize(tiny) jitter(7)) ///
	(scatter explicit2 intensity if oiacat==1, m(o) mcolor(blue) msize(tiny) jitter(7)) ///
	(scatter explicit2 intensity if intensity==., m(o) mcolor(red) msize(*2)) ///
	(scatter explicit2 intensity if intensity==., m(o) mcolor(green) msize(*2)) ///
	(scatter explicit2 intensity if intensity==., m(o) mcolor(blue) msize(*2)), ///
	graphregion(color(white)) xlab(0(1)6) ylab(-6(1)6) ///
	title("Revised") legend(order(4 "One-sided" 5 "Ambivalent" 6 "Indifferent") rows(1)) ///
	graphregion(color(white)) xlab(0(1)6) ylab(-6(1)6) xtitle("Intensity score") ///
	ytitle("Obama - McCain Liking") yline(0)
	
* Table SI-4
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1

svy: mean black if oiacat==0
svy: mean black if oiacat==1
svy: mean black if oiacat==2

svy: mean white if oiacat==0
svy: mean white if oiacat==1
svy: mean white if oiacat==2

svy: mean hispanic if oiacat==0
svy: mean hispanic if oiacat==1
svy: mean hispanic if oiacat==2

svy: mean age if oiacat==0
svy: mean age if oiacat==1
svy: mean age if oiacat==2

svy: mean female if oiacat==0
svy: mean female if oiacat==1
svy: mean female if oiacat==2

svy: mean income if oiacat==0
svy: mean income if oiacat==1
svy: mean income if oiacat==2

svy: mean trust if oiacat==0
svy: mean trust if oiacat==1
svy: mean trust if oiacat==2

svy: mean resent if oiacat==0
svy: mean resent if oiacat==1
svy: mean resent if oiacat==2

tab oiacat if wgtcs11!=0 // N for each column

* Table SI-5
use "anes_working.dta", clear
svyset [pw=wgtcs11]
svy: tab oiacat_party oiacat
di .354 + .2656 + .0423 // Add the diagonal. 66.1% classified the same.

* Table SI-6
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1
svy, subpop(if oiacat!=0): probit obvote c.implicit##i.oiacat c.explicit##i.oiacat i.educ2 i.region white black hispanic income female i.pid2 if oiacat!=0
tab oiacat if e(sample) & wgtcs11!=0 // Real N

* Table SI-7
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1
svy: reg w19state c.w9state##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
tab oiacat if e(sample) & wgtcs11!=0 // Real N

* Table SI-8a-l (setup)
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1

* SI-8a (Economy)
svy: reg w19state1 c.w9state1##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state1) at(oiacat=(0 1 2))

* SI-8b (Foreign relations)
svy: reg w19state2 c.w9state2##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state2) at(oiacat=(0 1 2))

* SI-8c (Moral values)
svy: reg w19state3 c.w9state3##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state3) at(oiacat=(0 1 2))

* SI-8d (Budget deficit)
svy: reg w19state4 c.w9state4##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state4) at(oiacat=(0 1 2))

* SI-8e (Military)
svy: reg w19state5 c.w9state5##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state5) at(oiacat=(0 1 2))

* SI-8f (Environment)
svy: reg w19state6 c.w9state6##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state6) at(oiacat=(0 1 2))

* SI-8g (Crime)
svy: reg w19state7 c.w9state7##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state7) at(oiacat=(0 1 2))

* SI-8h (Education)
svy: reg w19state8 c.w9state8##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state8) at(oiacat=(0 1 2))

* SI-8i (Health care)
svy: reg w19state9 c.w9state9##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state9) at(oiacat=(0 1 2))

* SI-8j (Poverty)
svy: reg w19state10 c.w9state10##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state10) at(oiacat=(0 1 2))

* SI-8k (Terrorist attacks)
svy: reg w19state11 c.w9state11##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state11) at(oiacat=(0 1 2))

* SI-8l (Blacks and whites)
svy: reg w19state12 c.w9state12##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implicit) at(oiacat=(0 1 2)) 
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state12) at(oiacat=(0 1 2))

* Table SI-9
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1
svy: reg w19approve17 c.w17approve17##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.educ2 i.region white black hispanic income female i.pid2 // health care
tab oiacat if e(sample) & wgtcs11!=0 // Real N
svy: reg w19approve15 c.w17approve15##i.oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.educ2 i.region white black hispanic income female i.pid2 // education
tab oiacat if e(sample) & wgtcs11!=0 // Real N

* Table SI-10
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1
drop if bwampbad==1

svy, subpop(if oiacat!=0): probit obvote c.implicit##i.oiacat c.implic_race##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implic_race) at(oiacat=(1 2)) atmeans
margins, dydx(implicit) at(oiacat=(1 2)) atmeans
margins, dydx(explicit) at(oiacat=(1 2)) atmeans

* Table SI-11
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1
drop if bwampbad==1

svy: reg w19state c.w9state##i.oiacat c.implic_race##oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implic_race) at(oiacat=(0 1 2))
margins, dydx(implicit) at(oiacat=(0 1 2))
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w9state) at(oiacat=(0 1 2))

* Table SI-12
use "anes_working.dta", clear
svyset [pw=wgtcs11]
drop if omampbad==1
drop if bwampbad==1

svy: reg w19approve17 c.w17approve17##i.oiacat c.implic_race##oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implic_race) at(oiacat=(0 1 2))
margins, dydx(implicit) at(oiacat=(0 1 2))
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w17approve17) at(oiacat=(0 1 2))

svy: reg w19approve15 c.w17approve15##i.oiacat c.implic_race##oiacat c.implicit##i.oiacat c.explicit##i.oiacat i.region i.educ2 female white black hispanic income i.pid2
margins, dydx(implic_race) at(oiacat=(0 1 2))
margins, dydx(implicit) at(oiacat=(0 1 2))
margins, dydx(explicit) at(oiacat=(0 1 2))
margins, dydx(w17approve15) at(oiacat=(0 1 2))
