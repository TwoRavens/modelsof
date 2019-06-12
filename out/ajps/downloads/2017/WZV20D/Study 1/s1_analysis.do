* This file conducts the analyses pertinent to Study 1 of Ryan,
* "How Do Indifferent Voters Decide?" (AJPS). Analysis was conducted on 
* Stata/SE 14.2 for Mac (64-bit Intel).

clear all
set more off

* Figure 2, left panel
use "study1_qualtrics_working.dta", clear
set seed 1789
twoway (scatter implicit explicit, graphregion(color(white)) msize(tiny) msymbol(circle) jitter(1) mcolor(black)) ///
	(lowess implicit explicit, lpattern(dash)), ///
	legend(off) ytitle("Implicit Democratic Preference") title("Study 1") ///
	xtitle("Explicit Democratic Preference") ysc(r(-2 2)) xlab(-1(.5)1) ylab(-2(.5)2)

* Table 2, left three columns
use "study1_qualtrics_working.dta", clear
reg qual i.proarg##c.implicit i.proarg##c.explicit if oiacat==0, robust
reg qual i.proarg##c.implicit i.proarg##c.explicit if oiacat==1, robust
reg qual i.proarg##c.implicit i.proarg##c.explicit if oiacat==2, robust

* Text: Sample sizes
use "study1_qualtrics_working.dta", clear
tab oiacat if d!=. // Individuals for whom there is both implict and explict information. N=360.


* Text: Internal consistency of IAT
use "study1_qualtrics_working.dta", clear
alpha d_s1 d_s2 // 0.84


* Text: P-values for Interaction terms: Simply review the results for the relevant table above.

* Text: Predicted values at specific levels of implicit attitudes
use "study1_qualtrics_working.dta", clear
quietly: reg qual i.proarg##c.implicit i.proarg##c.explicit if oiacat==1, robust // Table 2 model for indifferent
margins, at(proarg=1 implicit=(-1 1)) // 
di .443 - .300 // 14% of dependent measure's range (0-1)

* Figure SI-7, left panel
use "study1_qualtrics_working.dta", clear
set seed 1789
twoway (scatter explicit2 intensity if oiacat==0, m(o) mcolor(red) msize(tiny) jitter(4)) ///
	(scatter explicit2 intensity if oiacat==2, m(o) mcolor(green) msize(tiny) jitter(4)) ///
	(scatter explicit2 intensity if oiacat==1, m(o) mcolor(blue) msize(tiny) jitter(4)) ///
	(scatter explicit2 intensity if starttime=="turkey", m(o) mcolor(red) msize(*2)) /// // "Turkey" here is silliness. (I wrote this file the day after Thanksgiving.) You need a condition that is never fulfilled, as the purpose of this line is to add a larger point to the legend, and to add nothing at all to the actual plot.
	(scatter explicit2 intensity if starttime=="turkey", m(o) mcolor(green) msize(*2)) ///
	(scatter explicit2 intensity if starttime=="turkey", m(o) mcolor(blue) msize(*2)), ///
	title("Study 1") graphregion(color(white)) xlab(0(1)6) ylab(-6(1)6) ///
	xtitle("Intensity score") ytitle("") yline(0) ytitle("Democratic - Republican Liking") ///
	legend(order(4 "One-sided" 5 "Ambivalent" 6 "Indifferent") rows(1))
