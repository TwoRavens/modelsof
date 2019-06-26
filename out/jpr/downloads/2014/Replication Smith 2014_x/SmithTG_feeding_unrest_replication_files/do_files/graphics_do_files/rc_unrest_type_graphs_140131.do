********** FEEDING UNREST IN AFRICA *************
********** GENERATE RESULTS GRAPHS **************
********** WRITTEN BY TODD G. SMITH *************
********** UPDATED 31 JANUARY 2014 **************

set more off

local user  "`c(username)'"
cd "/Users/`user'/Documents/Active Projects/Feeding Unrest Africa/analysis"
use "results/unrest_rc_estimates.dta", clear

keep if parm == "std_food_chg" | parm == "l_dry_mscp9" | parm == "l_dry_mscp6" | parm == "grinst" | parm == "l_wet_mscp6" | parm == "l_unrest"
gen model = base == 1
replace model = 2 if nofe == 1
replace model = 3 if zaegng == 1
replace model = 4 if post97 == 1
replace model = 5 if pre2007 == 1
replace model = 6 if mscp6 == 1
label define model 	1 "Parsimonious model" ///
					2 "Without fixed effects" ///
					3 "Excluding ZAF, EGY & NGA" ///
					4 "Excluding pre-1997" ///
					5 "Excluding post-2006" ///
					6 "Using 6 month MSCP"
lab val model model
drop zaegng post97 pre2007 mscp6
encode eq, gen(dv)
drop eq
gen variable = 1 if parm == "std_food_chg"
replace variable = 2 if parm == "grinst"
replace variable = 3 if parm == "l_wet_mscp6"
replace variable = 4 if parm == "l_unrest"
replace variable = 5 if parm == "l_dry_mscp6"
replace variable = 6 if parm == "l_dry_mscp9"
lab def variable 	1 "% change in national consumer food prices" ///
					2 "Trade bal adj grain commodity price instrument" ///
					3 "6 month wet MSCP (lagged)" ///
					4 "Occurrence of unrest (lagged)" ///
					5 "9 month dry MSCP (lagged)" ///
					6 "6 month dry MSCP (lagged)"
lab val variable variable

gen min90 = estimate - (1.645 * stderr)
gen max90 = estimate + (1.645 * stderr)
gen sig_01 = estimate
replace sig_01 = . if (abs(estimate) - (2.576 * stderr)) < 0
lab var sig_01 "significant at alpha = 0.01"
gen sig_05 = estimate
replace sig_05 = . if (abs(estimate) - (1.96 * stderr)) < 0
lab var sig_05 "significant at alpha = 0.05"
replace sig_05 = . if sig_01 != .
gen not_sig = estimate
replace not_sig = . if sig_05 != . | sig_01 != .
lab var not_sig "not significant at alpha = 0.1"
format not_sig sig_05 sig_01 %4.3f

gen open = "(0"
gen close = ")"
gen error = round(stderr, .001)
format error %4.3f
egen se = concat(open error close)
drop open close error

keep if variable == 1

twoway (rcap min95 max95 model, lcolor(gs9) horizontal) (scatter model not_sig, msymbol(circle) mlcolor(gs9) mfcolor(white) msize(medium)) (scatter model sig_05, msymbol(circle) mcolor(gs9) msize(medlarge) mlabel(sig_05) mlabcolor(black) mlabposition(6) mlabsize(vsmall)) (scatter model sig_01, msymbol(circle) mcolor(black) msize(medlarge) mlabel(sig_01) mlabcolor(black) mlabposition(6) mlabsize(vsmall)), ytitle(, size(zero)) yscale(reverse) ylabel(1(1)6, valuelabel angle(horizontal) labsize(medium) noticks) xtitle("Marginal effect on standardized change in food prices", size(medium) margin(small)) xlabel(0(.2)1, grid labsize(medsmall)) xmtick(##2) legend(cols(4) size(medsmall) region(lcolor(none)) order(1 "95% confidence interval" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) title(, size(zero)), size(small) span) graphregion(margin(medsmall)) plotregion(margin(medium)) xsize(4) ysize(2) scheme(s1mono) scale(1) name(rc_mono, replace)

twoway (rcap min90 max90 model, lcolor(gs9) horizontal) (scatter model not_sig, msymbol(circle) mlcolor(gs9) mfcolor(white) msize(small)) (scatter model sig_05, msymbol(circle) mcolor(gs9) msize(medsmall) mlabel(sig_05) mlabcolor(black) mlabposition(6) mlabsize(vsmall)) (scatter model sig_01, msymbol(circle) mcolor(black) msize(medsmall) mlabel(sig_01) mlabcolor(black) mlabposition(6) mlabsize(vsmall)), ytitle(, size(zero)) yscale(reverse) ylabel(1(1)6, valuelabel angle(horizontal) labsize(small) noticks) xtitle("Marginal effect on standardized change in food prices", size(medsmall) margin(small)) xlabel(-.3(.1).7, grid labsize(small)) xmtick(##2) legend(cols(4) size(medsmall) region(lcolor(none)) order(1 "90% confidence interval" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) title(, size(zero)) note("Country, year & calendar month fixed effects not displayed; 9,618 observations; cluster robust standard errors employed (40 clusters)", size(small) span) graphregion(margin(medsmall)) plotregion(margin(medium)) xsize(4) ysize(2) scheme(s1mono) scale(1) name(fs_mono, replace)
