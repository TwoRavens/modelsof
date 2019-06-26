preserve
describe, replace clear
keep name varlab
tempfile codebook
save `codebook', replace
restore

parmest, norestore
rename parm name
merge m:1 name using `codebook'
drop if _merge != 3
drop _merge
encode varlab, gen(variable)
drop if variable >= 14

gen sig_01 = estimate
replace sig_01 = . if (abs(estimate) - (2.576 * stderr)) < 0
lab var sig_01 "significant at alpha = 0.01"
gen sig_05 = estimate
replace sig_05 = . if (abs(estimate) - (1.96 * stderr)) < 0
lab var sig_05 "significant at alpha = 0.05"

twoway (rcap min95 max95 variable, lcolor(gs9) horizontal) ///
	(scatter variable estimate, msymbol(circle) mlcolor(gs9) mfcolor(white) msize(small))  ///
	(scatter variable sig_05, msymbol(circle) mcolor(gs9) msize(small))  ///
	(scatter variable sig_01, msymbol(circle) mcolor(black) msize(small)), ///
	ytitle(, size(zero)) ///
	yscale(reverse) ///
	ylabel(1(1)14, valuelabel angle(horizontal) labsize(vsmall) noticks) ///
	xtitle("Marginal effect on % change in consumer food prices", size(vsmall)) ///
	xtitle(, size(medsmall) margin(small)) ///
	xlabel(-2(.5)1, grid labsize(small)) xmtick(##5) ///
	legend(cols(4) size(vsmall) region(lcolor(none)) order(1 "95% confidence interval" 2 "not significant at alpha = 0.1" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) ///
	xsize(5) ysize(3) scheme(s1mono)
exit
