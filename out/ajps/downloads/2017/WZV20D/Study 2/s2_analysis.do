* This file conducts the analyses pertinent to Study 2 of Ryan,
* "How Do Indifferent Voters Decide?" (AJPS). Analysis was conducted on 
* Stata/SE 14.2 for Mac (64-bit Intel).

clear all
set more off

* Figure 2, right panel
use "study2_qualtrics_working.dta", clear
set seed 1789
twoway (scatter implicit explicit, graphregion(color(white)) msize(tiny) msymbol(circle) jitter(1) mcolor(black)) ///
	(lowess implicit explicit, lpattern(dash)), ///
	legend(off) ytitle("Implicit Democratic Preference") title("Study 2") ///
	xtitle("Explicit Democratic Preference") ysc(r(-2 2)) xlab(-1(.5)1) ylab(-2(.5)2, nolabels)

* Table 2, right three columns
use "study2_qualtrics_working.dta", clear
reg presinfluence goodnews##c.implicit goodnews##c.explicit if oiacat==0, robust
reg presinfluence goodnews##c.implicit goodnews##c.explicit if oiacat==1, robust
reg presinfluence goodnews##c.implicit goodnews##c.explicit if oiacat==2, robust

* Text: Sample sizes
use "study2_qualtrics_working.dta", clear
sum d if presinfluence!=. // Individuals for whom there is both implicit and explicit information. N=156

* Text: Median lag between waves in Study 2
use "study2_qualtrics_working.dta", clear
gen samp = 0
quietly: reg presinfluence goodnews##c.implicit goodnews##c.explicit if oiacat!=. // This is simply to identify which subjects are in the main analysis
replace samp = 1 if e(sample)
keep if samp==1
gen start_w1 = substr(starttime_w1,1,10)
gen start_w2 = substr(starttime_w2,1,10)
gen d1 = date(start_w1, "20YMD")
gen d2 = date(start_w2, "20YMD")
gen lag = d2-d1
sum lag, detail // Examine 50th percentile. Median lag = 35 days

* Text: Internal consistency of IAT
use "study2_qualtrics_working.dta", clear
alpha d_s1 d_s2

* Text: P-values for Interaction terms: Simply review the results for the relevant table above.

* Figure SI-7, right panel
use "study2_qualtrics_working.dta", clear
set seed 1789
twoway (scatter explicit2 intensity if oiacat==0, m(o) mcolor(red) msize(tiny) jitter(4)) ///
	(scatter explicit2 intensity if oiacat==2, m(o) mcolor(green) msize(tiny) jitter(4)) ///
	(scatter explicit2 intensity if oiacat==1, m(o) mcolor(blue) msize(tiny) jitter(4)) ///
	(scatter explicit2 intensity if starttime_w1=="turkey", m(o) mcolor(red) msize(*2)) /// 
	(scatter explicit2 intensity if starttime_w1=="turkey", m(o) mcolor(green) msize(*2)) ///
	(scatter explicit2 intensity if starttime_w1=="turkey", m(o) mcolor(blue) msize(*2)), ///
	title("Study 2") graphregion(color(white)) xlab(0(1)6) ylab(-6(1)6) ///
	xtitle("Intensity score") ytitle("") yline(0) ytitle("Democratic - Republican Liking") ///
	legend(order(4 "One-sided" 5 "Ambivalent" 6 "Indifferent") rows(1))
