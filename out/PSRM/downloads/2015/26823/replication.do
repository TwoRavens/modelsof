
clear all
set more off
version 12
use "dataset.dta", clear

************************************
** Quantities reported in paper
************************************

**** SECTION 5.2 ****

** 75 municipalities with corruption scandals (~1%)
tab corruption

** 77% of mayors elected in 2007 ran again as candidates in 2011
tab repeats

** 61% of mayors accused of corruption ran again in 2011
tab repeats if corruption == 1

** fn10: mayors accused of welfare-decreasing corruption are
** slightly more likely to run again, but difference is
** not significantly different from zero.
ttest repeats if corruption == 1, by(w_enhance)

** Classification of corruption scandals
count if w_enhance == 1
count if w_decrease == 1

**** SECTION 6.1 ****

** 62.7% of parties whose mayor had been involved in
** corruption scandals stayed in power
tab same_party if corruption == 1

** 67.9% for all incumbent parties
tab same_party if corruption == 0, mis

** Average loss in vote share for incumbent parties
** accused of corruption = -8.5 points 
gen change = percent_curr - percent_prev
sum change if corruption == 1

** -3.4 points for all parties
sum change if corruption == 0

** extreme examples:
list percent_prev percent_curr if municipio == "muela la"
list percent_prev percent_curr if municipio == "torrejon de ardoz"

************************************
** Tables
************************************

** TABLE 2: SUMMARY STATISTICS

gen logpop2007 = log(pop2007)
gen logpop2011 = log(pop2011)

sum percent_prev percent_curr abs_maj retires corruption ///
	w_enhance w_decrease references logpop2007 logpop2011

** TABLE 3: OLS REGRESSIONS ON INCUMBENT VOTE SHARE

* Model 1
xi: reg percent_curr percent_prev corruption retires ///
	abs_maj logpop2007 pp psoe i.ccaa, cluster(ccaa)
margins, dydx(corruption) level(90)

* Model 2
xi: reg percent_curr percent_prev retires ///
	abs_maj logpop2007 w_enhance w_decrease ///
	pp psoe i.ccaa, cluster(ccaa)
margins, dydx(w_enhance w_decrease) level(90)
	
* Model 3
xi: reg percent_curr percent_prev ///
	abs_maj logpop2007 w_enhance##retires w_decrease##retires ///
	pp psoe i.ccaa, cluster(ccaa)
	
* Sensitivity analysis (fn. 16)

*** sensitivity analysis ***
gsort -corruption
gen lb1 = .
gen mean1 = .
gen ub1 = .
gen lb2 = .
gen mean2 = .
gen ub2 = .


foreach i of num 1/75{
	
	qui reg percent_curr percent_prev w_enhance w_decrease retires ///
	abs_maj logpop2007 i.ccaa if _n!=`i', cluster(ccaa)
	qui margins, dydx(w_enhance w_decrease) level(90)
	mat b = r(table)
	local ll = b[5,1]
	local ul = b[6,1]
	local b = b[1,1]
	qui replace lb1 = `ll' in `i'
	qui replace mean1 = `b' in `i'
	qui replace ub1 = `ul' in `i'

	local ll = b[5,2]
	local ul = b[6,2]
	local b = b[1,2]
	qui replace lb2 = `ll' in `i'
	qui replace mean2 = `b' in `i'
	qui replace ub2 = `ul' in `i'
	
}

* distribution of estimated coefficients for w_enhance and w_decrease
* shows robustness to exclusion of possible outliers
sum lb1 mean1 ub1 /* w_enhance */
sum lb2 mean2 ub2 /* w_decrease */

drop lb1 mean1 ub1 lb2 mean2 ub2

** TABLE 4: ROBUSTNESS CHECKS

* Model 1
xi: reg percent_curr percent_prev retires ///
	abs_maj logpop2007 w_enhance w_decrease ///
	pp psoe i.ccaa if shortterm_mix==0, cluster(ccaa)

* Model 2
gen popchange = logpop2011 - logpop2007
label variable popchange "Population Change (2007-2011)"
xi: reg change w_enhance w_decrease popchange ///
	pp psoe i.ccaa , cluster(ccaa)

* Model 3
xi: logit same_party percent_prev w_enhance w_decrease ///
	retires abs_maj logpop2007 pp psoe i.ccaa, cluster(ccaa)

margins, at(w_decrease=0 w_enhance=0) atmeans noatlegend
margins, at(w_decrease=0 w_enhance=1) atmeans noatlegend
margins, at(w_decrease=1 w_enhance=0) atmeans noatlegend

** TABLE 5: MEDIA EFFECTS

* Model 1
gen logref = log(references+1)
reg logref w_enhance logpop2007 if corruption==1

* Model 2
replace logref = 0 if logref==.
gen logref_enhance = logref * w_enhance
gen logref_decrease = logref * w_decrease

xi: reg percent_curr w_enhance logpop2007 percent_prev ///
	w_decrease logref_decrease logref_enhance pp psoe ///
	i.ccaa, cluster(ccaa)

* Generating data for Figure 3
mat V=e(V)
mat B=e(b)

clear
drawnorm beta1-beta27, n(10000) means(B) cov(V)

gen lb = .
gen mean = .
gen ub = .
gen id = _n
gen loop = .
gen simulation = ""

foreach loop of numlist 0(1)750{

	local num = log((`loop')+1)
	gen pred = beta1 + beta6 * `num'
	qui sum pred, detail
	qui replace lb = `r(p5)' if id == `loop'+1
	qui replace mean = `r(mean)' if id == `loop'+1
	qui replace ub = `r(p95)' if id == `loop'+1
	qui replace loop = `loop'*2 if id == `loop'+1
	qui replace simulation = "Welfare-Enhancing Corruption" if id == `loop'+1
	drop pred

}

foreach loop of numlist 0(1)750{

	local num = log((`loop')+1)
	gen pred = beta4 + beta5 * `num'
	qui sum pred, detail
	qui replace lb = `r(p5)' if id == `loop' + 752
	qui replace mean = `r(mean)' if id == `loop' + 752
	qui replace ub = `r(p95)' if id == `loop' + 752
	qui replace loop = `loop'*2 if id == `loop' + 752
	qui replace simulation = "Welfare-Decreasing Corruption" if id == `loop' + 752
	drop pred

}

rename loop references
keep lb mean ub references simulation
drop if mean==.
outsheet using "media-data.csv", comma replace











