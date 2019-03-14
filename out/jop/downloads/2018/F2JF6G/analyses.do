* This file conducts all the analyses for Timothy J. Ryan, 
* "Actions Versus Consequences in Political Arguments: Insights 
* from Moral Psychology" (JOP). Analysis was conducted on 
* Stata/SE 14.2 for Mac (64-bit Intel).


* Table 1
use "Study1_working.dta", clear
svyset [pw=weight]
svy: reg qual c.mor##conseq
svy: reg qual c.extfold##conseq c.imp##conseq c.relev##conseq c.mor##conseq


* Table 2
use "study2_working_wide.dta", clear
pwcorr symor ssmor gcmor cbmor numor

use "Study3_working_wide.dta", clear
pwcorr iismor sssmor gcsmor txsmor nusmor


* Table 3
use "study2_working_long.dta", clear
xtset caseid
xtmixed dpref extfold imp relev mor i.issue || caseid:, cluster(caseid)
xtreg dpref extfold imp relev mor i.issue, fe cluster(caseid)

use "Study3_working_long.dta", clear
xtset caseid
xtmixed change extfold imp relev smor i.issue || caseid:, robust cluster(caseid)
xtreg change extfold imp relev smor i.issue, fe robust cluster(caseid)


* Figure 1, Left panel
use "Study1_working.dta", clear
byhist mor, by(issside) frac bin(5) ///
	tw(graphregion(color(white)) ylab(0(.1).5, grid) ///
	legend(order(1 "Proponents" 2 "Opponents")) ///
	xtitle("Moral Conviction") ytitle("Proportion") ///
	xlab(.1 "None" .5 "Moderate" .9 "Max"))

graph save "scdist_s1.gph", replace


* Figure 1, Right panel
use "Study1_working.dta", clear
set seed 1789
twoway (scatter mor extfold, jitter(6) msize(tiny)) ///
	(lowess mor extfold), ///
	graphregion(color(white)) xtitle("Attitude Extremity") ///
	ytitle("Moral Conviction") xlab(0 "0" .33 ".33" .66 ".66" 1 "1") legend(off)
graph save "scmor_smext_s1.gph", replace

* Combining Figure 1 Panels
* net install grc1leg,from( http://www.stata.com/users/vwiggins/) // If grc1leg not already installed.
grc1leg "scdist_s1.gph" "scmor_smext_s1.gph", ///
	rows(1) graphregion(color(white)) // Requires grc1leg function. 

*Note: I manually repositioned the legend under the left-hand panel using the graph editor, since the legend only applies to that panel.
graph save "fig1.gph", replace
graph export "fig1.png", replace width(2000)


* Figure 2
use "Study4_working_long.dta"
xtset caseid
xtreg move3 costs##c.extfold costs##c.imp costs##c.relev costs##c.mor i.issue, fe cluster(caseid)
margins, dydx(costs) at(mor=(0 1))
marginsplot, yline(0, lpattern(dash) lcolor(black)) recast(scatter) ///
	xline(0 1, lpattern(shortdash) lcolor(gs7)) ///
	recastci(rspike) ciopts(lcolor(black) lwidth(medthick)) ///
	plotopts(mcolor(black)) xsc(r(-.5 1.5)) xlab(0 "Low" 1 "High") ysc(r(-.15 .3)) ylab(-.1(.1).3) ///
	xtitle("Moral Conviction") ytitle("") title("") scale(1.3) ///
	graphregion(color(white))

graph save "fig2.gph", replace
graph export "fig2.png", replace width(1000)


* Table SI-1, Study 1
use "Study1_working.dta", clear
svyset [pw=weight]
svy: prop agebin
svy: prop female
svy: prop pidr // Add top three categories for Democratic percentage, bottom three for Republican
svy: prop educ
svy: prop race


* Table SI-1, Study 2
use "study2_working_wide.dta", clear
* Age proportion is assumed, on the basis of this being a student sample
prop gender
prop pidr // Add top three categories for Democratic percentage, bottom three for Republican
* Education proportion is assumed, on the basis of this being a student sample


* Table SI-1, Study 3
use "Study3_working_wide.dta", clear
* Age proportion is assumed, on the basis of this being a student sample
prop female
prop pidr // Add top three categories for Democratic percentage, bottom three for Republican
* Education proportion is assumed, on the basis of this being a student sample

* Table SI-1, Study 4
use "Study4_working_wide.dta"
prop agebin
prop female
prop educ
prop race // Add bottom two values together for the "Other" figure. (See note in the SI.)

* Table SI-2
use "manip_check_working.dta"
tabstat mcmor1 mcmor3 mcmor5 deontscale if libexper==1, by(deontcond) stat(mean semean) col(stat) format(%9.2f) // bottom-left portion
tabstat mcmor2 mcmor4 mcmor6 consscale if libexper==1, by(deontcond) stat(mean semean) col(stat) format(%9.2f) // top-left portion

tabstat mcmor1 mcmor3 mcmor5 deontscale if libexper==0, by(deontcond) stat(mean semean) col(stat) format(%9.2f) // bottom-right portion
tabstat mcmor2 mcmor4 mcmor6 consscale if libexper==0, by(deontcond) stat(mean semean) col(stat) format(%9.2f) // top-right portion


* Table SI-3
use "manip_check_working.dta"
tabstat mcthink1 mcthink2 mcthink3 mcthink4 mcthink5 ///
	mcthink6 mcthink7 mcthink8 mcthink9 mcage mctime if libexper==1, by(deontcond) stat(mean semean) col(stat) format(%9.2f) // Left portion

tabstat mcthink1 mcthink2 mcthink3 mcthink4 mcthink5 ///
	mcthink6 mcthink7 mcthink8 mcthink9 mcage mctime if libexper==0, by(deontcond) stat(mean semean) col(stat) format(%9.2f) // Right portion
	
* Table SI-4
use "Study1_working.dta", clear
pwcorr extfold imp relev mor pidr ideol // Table reports statistics from bottom two rows.


* Table SI-5
use "Study1_working.dta", clear
svyset [pw=weight]
svy: reg qual c.extfold##conseq c.imp##conseq c.relev##conseq c.mor##conseq
svy: reg qual c.extfold##conseq c.imp##conseq c.relev##conseq c.mor##conseq conseq##c.pidr
svy: reg qual c.extfold##conseq c.imp##conseq c.relev##conseq c.mor##conseq conseq##c.ideol


* Table SI-6
use "study2_working_long.dta", clear
xtset caseid
xtmixed dpref extfold imp relev mor i.issue || caseid:, cluster(caseid)
xtmixed dpref extfold imp relev mor i.issue || caseid: if effective==0, cluster(caseid)
xtmixed dpref extfold imp relev mor i.issue || caseid: if effective==1, cluster(caseid)
xtmixed dpref c.mor##effective i.issue || caseid:, cluster(caseid)
xtmixed dpref c.extfold##effective c.imp##effective c.relev##effective c.mor##effective i.issue || caseid:, cluster(caseid)
margins, dydx(effective) at(mor=(0 1)) // Statistics reported in text on page SI-23


* Table SI-7
use "study2_working_long.dta", clear
reg dpref extfold imp relev mor if issue==1
reg dpref extfold imp relev mor if issue==2
reg dpref extfold imp relev mor if issue==3
reg dpref extfold imp relev mor if issue==4
reg dpref extfold imp relev mor if issue==5


* Figure SI-1
use "study2_working_long.dta", clear
reg dpref c.extfold##i.issue c.imp##i.issue c.relev##i.issue c.mor##i.issue

margins, dydx(extfold) at(issue=(1 2 3 4 5))
marginsplot, plotopts(connect(none)) graphregion(color(white)) ///
	yline(0) title(Extremity) ytitle("Marginal Effect") xtitle("") ///
	ysc(r(-.4 .6)) ylab(-.4(.2).6)
graph save "s2mfx_ext.gph", replace

margins, dydx(imp) at(issue=(1 2 3 4 5))
marginsplot, plotopts(connect(none)) graphregion(color(white)) ///
	yline(0) title(Importance) ytitle("Marginal Effect") xtitle("") ///
	ysc(r(-.4 .6)) ylab(-.4(.2).6)
graph save "s2mfx_imp.gph", replace

margins, dydx(relev) at(issue=(1 2 3 4 5))
marginsplot, plotopts(connect(none)) graphregion(color(white)) ///
	yline(0) title(Relevance) ytitle("Marginal Effect") xtitle("") ///
	ysc(r(-.4 .6)) ylab(-.4(.2).6)
graph save "s2mfx_relev.gph", replace

reg dpref c.extfold##i.issue c.imp##i.issue c.relev##i.issue c.mor##i.issue
margins, dydx(mor) at(issue=(1 2 3 4 5))
marginsplot, plotopts(connect(none)) graphregion(color(white)) ///
	yline(0) title(Moral Conviction) ytitle("Marginal Effect") xtitle("") ///
	ysc(r(-.4 .6)) ylab(-.4(.2).6)
graph save "s2mfx_mc.gph", replace

graph combine "s2mfx_ext.gph" "s2mfx_imp.gph" ///
	"s2mfx_relev.gph" "s2mfx_mc.gph", rows(2) ///
	graphregion(color(white))
graph export "s2mfx_all.png", replace width(800)


* Table SI-8
use "Study3_working_long.dta", clear
reg change extfold imp relev smor if issue==1
reg change extfold imp relev smor if issue==2
reg change extfold imp relev smor if issue==3
reg change extfold imp relev smor if issue==4
reg change extfold imp relev smor if issue==5


* Figure SI-2
use "Study3_working_long.dta", clear
reg change c.extfold##i.issue c.imp##i.issue c.relev##i.issue c.smor##i.issue

margins, dydx(extfold) at(issue=(1 2 3 4 5))
marginsplot, plotopts(connect(none)) graphregion(color(white)) ///
	yline(0) title(Extremity) ytitle("Marginal Effect") xtitle("") ///
	ysc(r(-.4 .6)) ylab(-.4(.2).6)
graph save "s3mfx_ext.gph", replace

margins, dydx(imp) at(issue=(1 2 3 4 5))
marginsplot, plotopts(connect(none)) graphregion(color(white)) ///
	yline(0) title(Importance) ytitle("Marginal Effect") xtitle("") ///
	ysc(r(-.4 .6)) ylab(-.4(.2).6)
graph save "s3mfx_imp.gph", replace

margins, dydx(relev) at(issue=(1 2 3 4 5))
marginsplot, plotopts(connect(none)) graphregion(color(white)) ///
	yline(0) title(Relevance) ytitle("Marginal Effect") xtitle("") ///
	ysc(r(-.4 .6)) ylab(-.4(.2).6)
graph save "s3mfx_relev.gph", replace

margins, dydx(smor) at(issue=(1 2 3 4 5))
marginsplot, plotopts(connect(none)) graphregion(color(white)) ///
	yline(0) title(Moral Conviction) ytitle("Marginal Effect") xtitle("") ///
	ysc(r(-.4 .6)) ylab(-.4(.2).6)
graph save "s3mfx_mc.gph", replace

graph combine "s3mfx_ext.gph" "s3mfx_imp.gph" ///
	"s3mfx_relev.gph" "s3mfx_mc.gph", rows(2) ///
	graphregion(color(white))
graph export "s3mfx_all.png", replace width(800)


* Table SI-9
use "Study4_working_long.dta"
reg move3 costs##c.extfold costs##c.imp costs##c.relev costs##c.mor if issue==1, cluster(caseid)
reg move3 costs##c.extfold costs##c.imp costs##c.relev costs##c.mor if issue==2, cluster(caseid)


* Table SI-10
use "Study4_working_long.dta"
xtset caseid
xtreg move3 costs##c.extfold costs##c.imp costs##c.relev costs##c.mor i.issue, cluster(caseid)
xtreg move3 costs##c.extfold costs##c.imp costs##c.relev costs##c.mor i.issue, fe cluster(caseid)
