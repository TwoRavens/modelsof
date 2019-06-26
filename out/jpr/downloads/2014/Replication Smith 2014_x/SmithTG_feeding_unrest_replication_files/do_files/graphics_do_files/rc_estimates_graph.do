*** GENERATE GRAPHS OF ROBUSTNESS OF ESTIMATES ***
*** WRITTEN BY TODD G SMITH ***
*** 17 MARCH 2013 ***


loc index `1'
loc dv `2'

use "results/`dv'_rc_estimates.dta", clear


gen sig_01 = estimate
replace sig_01 = . if (abs(estimate) - (2.576 * stderr)) < 0
lab var sig_01 "significant at alpha = 0.01"
gen sig_05 = estimate
replace sig_05 = . if (abs(estimate) - (1.96 * stderr)) < 0
lab var sig_05 "significant at alpha = 0.05"
replace sig_05 = . if sig_01 != .
replace estimate = . if sig_01 != . | sig_05 != .

foreach var of varlist estimate sig_01 sig_05 min95 max95 {
	replace `var' = ((exp(`var') - 1) * 100) if dv == 2 & `var' != .
	}

twoway (rcap min95 max95 model, lcolor(gs9) horizontal) ///
	(scatter model estimate, msymbol(circle) mlcolor(gs9) mfcolor(white) msize(medium))  ///
	(scatter model sig_05, msymbol(circle) mcolor(gs9) msize(medium))  ///
	(scatter model sig_01, msymbol(circle) mcolor(black) msize(medium)) ///
	if dv == 2 & variable == 1, ///
	ytitle(, size(zero)) ///
	yscale(reverse) ///
	ylabel(1(1)8, valuelabel angle(horizontal) labsize(medsmall) noticks) ///
	xtitle("Marginal percentage change in the odds of unrest", size(vsmall)) ///
	xtitle(, size(medsmall) margin(small)) ///
	xlabel(, grid labsize(small)) xmtick(##5) ///
	legend(cols(4) size(small) region(lcolor(none)) order(1 "95% confidence interval" 2 "not significant at alpha = 0.1" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) ///
	xsize(5) ysize(3) scheme(s1mono) name(`dv'_food_chg_mono, replace)
graph export "graphs/`index'_graphs/`dv'_rc_food_chg_mono.pdf", replace

twoway (rcap min95 max95 model, lcolor(dkgreen) horizontal) ///
	(scatter model estimate, msymbol(circle) mlcolor(dkgreen) mfcolor(white) msize(medium))  ///
	(scatter model sig_05, msymbol(circle) mcolor(dkgreen) msize(medium))  ///
	(scatter model sig_01, msymbol(circle) mcolor(dkorange) msize(medium)) ///
	if dv == 2 & variable == 1, ///
	ytitle(, size(zero)) ///
	yscale(reverse) ///
	ylabel(1(1)8, valuelabel angle(horizontal) labsize(medsmall) noticks) ///
	xtitle("Marginal percentage change in the odds of unrest", size(vsmall)) ///
	xtitle(, size(medsmall) margin(small)) ///
	xlabel(, grid labsize(small)) xmtick(##5) ///
	legend(cols(4) size(small) region(lcolor(none)) order(1 "95% confidence interval" 2 "not significant at alpha = 0.1" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) ///
	title("Robustness of Change in Consumer Food Prices", size(medium) margin(medsmall) span) ///
	xsize(5) ysize(3) scheme(s1color) name(`dv'_food_chg_color, replace)
graph export "graphs/`index'_graphs/`dv'_rc_food_chg_color.pdf", replace


