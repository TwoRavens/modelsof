********** FEEDING UNREST IN AFRICA **********
********** WRITTEN BY TODD G. SMITH ***********
********** UPDATED 4 JUNE 2014 **************

set more off

local user  "`c(username)'"
cd "/Users/`user'/Documents/active_projects/feeding_unrest_africa/analysis"
use "feeding_unrest_africa.dta", clear

loc dv "unrest"
loc x1 "l_unrest"
loc x2 "l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
loc iv "grinst l_dry_mscp9"
loc z "l_wet_mscp6"

ivprobit `dv' `z' `x2' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num) first nolog
est sto ivprob_best

preserve
describe, replace clear
save codebook, replace
restore

***** GRAPH RESULTS OF FIRST STAGE MODEL *****

parmest, norestore

gen variable = .
replace variable = 1 if parm == "l_dry_mscp9"
replace variable = 2 if parm == "grinst"
replace variable = 3 if parm == "l_unrest"
replace variable = 4 if parm == "l_wet_mscp6"
replace variable = 5 if parm == "elections"
replace variable = 6 if parm == "democ"
replace variable = 7 if parm == "autoc"
replace variable = 8 if parm == "ucdp"
replace variable = 9 if parm == "pct_urb"
replace variable = 10 if parm == "pct_youth"
replace variable = 11 if parm == "pop"
replace variable = 12 if parm == "pop_growth"
replace variable = 13 if parm == "gdppc"
replace variable = 14 if parm == "life_exp"
replace variable = 15 if parm == "inf_mort"
replace variable = 16 if parm == "std_food_chg"

lab def variable ///
	16 "Standardized change in food prices* " ///
	1 "9 month dry MSCP (lagged) " ///
	2 "Grain commodity instrument " ///
	3 "Occurrence of unrest (lagged) " ///
	4 "6 month wet MSCP (lagged) " ///
	5 "National elections " ///
	6 "Polity IV democracy " ///
	7 "Polity IV autocracy " ///
	8 "Occurence of armed conflict (UCDP)" ///
	9 "Urban Population (% of total) " ///
	10 "Youth Population (% of total 14 & under) " ///
	11 "Population (log) " ///
	12 "Population Growth (monthly %) " ///
	13 "GDP per capita (log of const 2005 USD) " ///
	14 "Life expectancy at birth total (years) " ///
	15 "Mortality rate infant (per 1000 live births) " ///
	, replace
lab val variable variable
keep if variable <= 16
encode eq, gen(stage)
save "ivprob_res.dta", replace

keep if stage == 1

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
replace se = "(0.020)" if se == "(0.02)"

twoway (rcap min95 max95 variable, lcolor(gs9) horizontal) (scatter variable not_sig, msymbol(circle) mlcolor(gs9) mfcolor(white) msize(small)) (scatter variable sig_05, msymbol(circle) mcolor(gs9) msize(medsmall) mlabel(sig_05) mlabcolor(black) mlabposition(6) mlabsize(vsmall)) (scatter variable sig_01, msymbol(circle) mcolor(black) msize(medsmall) mlabel(sig_01) mlabcolor(black) mlabposition(6) mlabsize(vsmall)), ytitle(, size(zero)) yscale(reverse) ylabel(1(1)15, valuelabel angle(horizontal) labsize(small) noticks) xtitle("Marginal effect on standardized change in food prices", size(medsmall) margin(small)) xlabel(-.4(.1).3, grid labsize(small)) xmtick(##2) legend(cols(4) size(medsmall) region(lcolor(none)) order(1 "95% confidence interval" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) title("First Stage: DV = standardized change in domestic food prices", size(medium) margin(medsmall) span) note("Country, year & calendar month fixed effects not displayed; 10,080 observations; cluster robust standard errors employed (40 clusters)", size(small) span) graphregion(margin(medsmall)) plotregion(margin(medium)) xsize(5) ysize(2.5) scheme(s1mono) scale(1) name(fs_mono, replace)
graph export "graphs/marg_effs_fs_mono.eps", replace
graph export "graphs/marg_effs_fs_mono.pdf", replace

twoway (rcap min95 max95 variable, lcolor(dkgreen) horizontal) (scatter variable not_sig, msymbol(circle) mlcolor(dkgreen) mfcolor(white) msize(medsmall))  (scatter variable sig_05, msymbol(circle) mcolor(dkgreen) msize(medsmall) mlabel(sig_05) mlabcolor(black) mlabposition(6) mlabsize(vsmall)) (scatter variable sig_01, msymbol(circle) mcolor(dkorange) msize(medsmall) mlabel(sig_01) mlabcolor(black) mlabposition(6) mlabsize(vsmall)), ytitle(, size(zero)) yscale(reverse) ylabel(1(1)15, valuelabel angle(horizontal) labsize(small) noticks) xtitle("Marginal effect on standardized change in food prices", size(medsmall) margin(small)) xlabel(-.4(.1).3, grid labsize(small)) xmtick(##2) legend(cols(4) size(medsmall) region(lcolor(none)) order(1 "95% confidence interval"  3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) title("First Stage: DV = standardized change in domestic food prices", size(medium) margin(medsmall) span) note("Country, year & calendar month fixed effects not displayed; 10,080 observations; cluster robust standard errors employed (40 clusters)", size(small) span) graphregion(margin(medsmall)) plotregion(margin(medium)) xsize(6) ysize(3) scheme(s1mono) scale(1) name(fs_color, replace)
graph export "graphs/marg_effs_fs_color.eps", replace
graph export "graphs/marg_effs_fs_color.pdf", replace

twoway (rcap min95 max95 variable, lcolor(gs9) horizontal) (scatter variable not_sig, msymbol(circle) mlcolor(gs9) mfcolor(white) msize(medsmall)) (scatter variable sig_05, msymbol(circle) mcolor(gs9) msize(medlarge) mlabel(sig_05) mlabcolor(black) mlabposition(6) mlabsize(small) mlabgap(medium)) (scatter variable sig_01, msymbol(circle) mcolor(black) msize(medlarge) mlabel(sig_01) mlabcolor(black) mlabposition(6) mlabsize(small), if variable != 1) (scatter variable sig_05, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(6) mlabsize(small) mlabgap(tiny)) (scatter variable sig_01, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(6) mlabsize(small) mlabgap(medium), if variable != 1) (scatter variable sig_01, msymbol(circle) mcolor(black) msize(medlarge) mlabel(sig_01) mlabcolor(black) mlabposition(6) mlabsize(small), if variable == 1) (scatter variable sig_01, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(6) mlabsize(small) mlabgap(medium), if variable == 1) if variable <= 7, ytitle(, size(zero)) yscale(reverse) ylabel(1(1)7, valuelabel angle(horizontal) labsize(medium) noticks) xlabel(-.1(.05).15, grid labsize(small)) xmtick(##2) xtitle("Marginal effect on standardized change in food prices", size(medium) margin(small)) legend(cols(3) size(medsmall) region(lcolor(none)) order(1 "95% confidence interval" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) title("First Stage: DV = standardized change in consumer food prices", size(medlarge) margin(medsmall) span) note("Country, year, calendar month fixed effects & non-significant covariates not displayed; n = 10,080; cluster robust standard errors in parentheses (40 clusters)", size(small) span) xsize(5) ysize(2.5)  graphregion(margin(medsmall)) plotregion(margin(medlarge)) scheme(s1mono) scale(1) name(fs_sig_mono, replace)
graph export "graphs/marg_effs_fs_sig_mono.eps", replace
graph export "graphs/marg_effs_fs_sig_mono.pdf", replace

twoway (rcap min95 max95 variable, lcolor(dkgreen) horizontal) (scatter variable not_sig, msymbol(circle) mlcolor(dkgreen) mfcolor(white) msize(medsmall)) (scatter variable sig_05, msymbol(circle) mcolor(dkgreen) msize(medlarge) mlabel(sig_05) mlabcolor(black) mlabposition(6) mlabsize(small) mlabgap(medium)) (scatter variable sig_01, msymbol(circle) mcolor(dkorange) msize(medlarge) mlabel(sig_01) mlabcolor(black) mlabposition(6) mlabsize(small)) (scatter variable sig_05, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(6) mlabsize(small) mlabgap(tiny)) (scatter variable sig_01, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(6) mlabsize(small) mlabgap(medium)) if variable <= 7, ytitle(, size(zero)) yscale(reverse) ylabel(1(1)7, valuelabel angle(horizontal) labsize(medium) noticks) xlabel(-.1(.05).15, grid labsize(small)) xmtick(##2) xtitle("Marginal effect on standardized change in food prices", size(medium) margin(small)) legend(cols(3) size(medsmall) region(lcolor(none)) order(1 "95% confidence interval" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) title("First Stage: DV = standardized change in consumer food prices", size(medlarge) margin(medsmall) span) note("Country, year, calendar month fixed effects & non-significant covariates not displayed; n = 10,080; cluster robust standard errors in parentheses (40 clusters)", size(small) span) graphregion(margin(medsmall)) plotregion(margin(medlarge)) xsize(6) ysize(3) scheme(s1color) scale(1) name(fs_sig_color, replace)
graph export "graphs/marg_effs_fs_sig_color.eps", replace
graph export "graphs/marg_effs_fs_sig_color.pdf", replace

**** GRAPHS CHANGE IN ODDS IN SECOND STAGE *****

use "ivprob_res.dta", clear

replace variable = 16 if parm == "l_dry_mscp9"
replace variable = 15 if parm == "grinst"
replace variable = 1 if parm == "std_food_chg"
replace variable = 2 if parm == "l_unrest"
replace variable = 3 if parm == "l_wet_mscp6"
replace variable = 4 if parm == "elections"
replace variable = 5 if parm == "democ"
replace variable = 6 if parm == "autoc"
replace variable = 7 if parm == "ucdp"
replace variable = 8 if parm == "pct_urb"
replace variable = 9 if parm == "pct_youth"
replace variable = 10 if parm == "pop"
replace variable = 11 if parm == "pop_growth"
replace variable = 12 if parm == "gdppc"
replace variable = 13 if parm == "life_exp"
replace variable = 14 if parm == "inf_mort"

lab def variable ///
	1 "Std change in food prices* " ///
	16 "9 month dry MSCP (lagged) " ///
	15 "Grain commodity instrument " ///
	2 "Occurrence of unrest (lagged) " ///
	3 "6 month wet MSCP (lagged) " ///
	4 "National elections " ///
	5 "Polity IV democracy " ///
	6 "Polity IV autocracy " ///
	7 "Occurence of armed conflict (UCDP)" ///
	8 "Urban Population (% of total) " ///
	9 "Youth Population (% of total 14 & under) " ///
	10 "Population (log) " ///
	11 "Population Growth (monthly %) " ///
	12 "GDP per capita (log of const 2000 USD) " ///
	13 "Life expectancy at birth total (years) " ///
	14 "Mortality rate infant (per 1000 live births) " ///
	, modify

keep if stage == 2

gen sig_01 = estimate
replace sig_01 = . if (abs(estimate) - (2.576 * stderr)) < 0
lab var sig_01 "significant at alpha = 0.01"
gen sig_05 = estimate
replace sig_05 = . if (abs(estimate) - (1.96 * stderr)) < 0
lab var sig_05 "significant at alpha = 0.05"
replace sig_05 = . if sig_01 != .
gen not_sig = estimate
lab var not_sig "not significant at alpha = 0.1"
replace not_sig = . if sig_05 != . | sig_01 != .

foreach var of varlist estimate stderr not_sig sig_01 sig_05 min95 max95 {
	replace `var' = exp(`var')
	replace `var' = (`var' - 1) * 100
	}

gen open = "("
gen close = ")"
gen error = round(stderr, .1)
format error %3.1f
egen se = concat(open error close)
drop open close error
replace se = "(2.0)" if se == "(2)"
replace se = "(0.5)" if se == "(.5)"

format not_sig sig_05 sig_01 %3.1f

twoway (rcap min95 max95 variable, lcolor(dkgreen) horizontal) ///
	(scatter variable not_sig, msymbol(circle) mlcolor(dkgreen) mfcolor(white) msize(medsmall)) ///
	(scatter variable sig_05, msymbol(circle) mcolor(dkgreen) msize(medsmall) mlabel(sig_05) mlabcolor(black) mlabposition(12) mlabsize(vsmall)) ///
	(scatter variable sig_01 if variable != 5, msymbol(circle) mcolor(dkorange) msize(medsmall)  mlabel(sig_01) mlabcolor(black) mlabposition(12) mlabsize(vsmall)) ///
	(scatter variable sig_01 if variable == 5, msymbol(circle) mcolor(dkorange) msize(medsmall)  mlabel(sig_01) mlabcolor(black) mlabposition(12) mlabsize(vsmall)), ///
	ytitle(, size(zero)) yscale(reverse) ylabel(1(1)14, valuelabel angle(horizontal) labsize(small) noticks) ///
	xtitle("Marginal percentage change in the odds of unrest", size(medium) margin(medsmall)) ///
	xlabel(-40(20)140, grid labsize(small)) xmtick(##2) legend(off) title("Endogenous Probit Model Results", margin(medsmall) span) ///
	subtitle("Main Stage: DV = Occurence of unrest", size(medium) margin(medsmall) span) ///
	note("* instrumented using 9 month dry MSCP (lagged), trade balance adjusted grain instrument & all other covariates", size(small) span) ///
	graphregion(margin(medsmall)) plotregion(margin(medium)) xsize(6) ysize(3) scheme(s1color) scale(1) name(main_color, replace)
graph export "graphs/marg_effs_ivprobit_color.eps", replace
graph export "graphs/marg_effs_ivprobit_color.pdf", replace

twoway (rcap min95 max95 variable, lcolor(gs9) horizontal) ///
	(scatter variable not_sig, msymbol(circle) mlcolor(gs9) mfcolor(white) msize(medsmall)) ///
	(scatter variable sig_05, msymbol(circle) mcolor(gs9) msize(medsmall) mlabel(sig_05) mlabcolor(black) mlabposition(12) mlabsize(vsmall)) ///
	(scatter variable sig_01 if variable != 5, msymbol(circle) mcolor(black) msize(medsmall) mlabel(sig_01) mlabcolor(black) mlabposition(12) mlabsize(vsmall)) ///
	(scatter variable sig_01 if variable == 5, msymbol(circle) mcolor(black) msize(medsmall) mlabel(sig_01) mlabcolor(black) mlabposition(12) mlabsize(vsmall)), ///
	ytitle(, size(zero)) yscale(reverse) ylabel(1(1)14, valuelabel angle(horizontal) labsize(small) noticks) ///
	xtitle("Marginal percentage change in the odds of unrest", size(medium) margin(medium)) ///
	xlabel(-40(20)140, grid labsize(small)) xmtick(##2) legend(off) ///
	subtitle("Main Stage: DV = Occurence of unrest", size(medium) margin(medium) span) ///
	note("* instrumented using 9 month dry MSCP (lagged), trade balance adjusted grain instrument & all other covariates", size(small) span) ///
	graphregion(margin(medsmall)) plotregion(margin(medium)) xsize(5) ysize(2.5) scheme(s1mono) scale(1) name(main_mono, replace)
graph export "graphs/marg_effs_ivprobit_mono.eps", replace
graph export "graphs/marg_effs_ivprobit_mono.pdf", replace

twoway (rcap min95 max95 variable, lcolor(dkgreen) horizontal) ///
	(scatter variable not_sig, msymbol(circle) mlcolor(dkgreen) mfcolor(white) msize(medsmall)) ///
	(scatter variable sig_01 if variable < 5, msymbol(circle) mcolor(dkorange) msize(medlarge) mlabel(sig_01) mlabcolor(black) mlabposition(6) mlabsize(small)) ///
	(scatter variable sig_01 if variable < 5, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(6) mlabsize(small) mlabgap(medium)) ///
	(scatter variable sig_01 if variable >= 5, msymbol(circle) mcolor(dkorange) msize(medlarge) mlabel(sig_01) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(medium)) ///
	(scatter variable sig_01 if variable >= 5, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(tiny)) ///
	(scatter variable sig_05, msymbol(circle) mcolor(dkgreen) msize(medlarge) mlabel(sig_05) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(medium)) ///
	(scatter variable sig_05, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(tiny)) if variable <= 6, ///
	ytitle(, size(zero)) yscale(reverse) ylabel(1(1)6, valuelabel angle(horizontal) labsize(medium) noticks) ///
	xtitle("Marginal percentage change in the odds of unrest", size(medium) margin(medium)) ///
	xlabel(-20(20)140, grid labsize(small)) xmtick(##2) legend(off) ///
	title("Endogenous Probit Model Results", margin(medsmall) span) ///
	subtitle("Main Stage: DV = Occurence of unrest", size(medlarge) margin(small) span) ///
	note("* instrumented using 9 month dry MSCP (lagged), trade balance adjusted grain instrument & all other covariates", size(small) span) ///
	graphregion(margin(medsmall)) plotregion(margin(medlarge)) xsize(6) ysize(3) scheme(s1color) scale(1) name(main_sig_color, replace)
graph export "graphs/marg_effs_ivprobit_sig_color.eps", replace
graph export "graphs/marg_effs_ivprobit_sig_color.pdf", replace

twoway (rcap min95 max95 variable, lcolor(dkgreen) horizontal) ///
	(scatter variable not_sig, msymbol(circle) mlcolor(dkgreen) mfcolor(white) msize(medsmall)) ///
	(scatter variable sig_01 if variable < 5, msymbol(circle) mcolor(dkorange) msize(medlarge) mlabel(sig_01) mlabcolor(black) mlabposition(6) mlabsize(small)) ///
	(scatter variable sig_01 if variable < 5, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(6) mlabsize(small) mlabgap(medium)) ///
	(scatter variable sig_01 if variable >= 5, msymbol(circle) mcolor(dkorange) msize(medlarge) mlabel(sig_01) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(medium)) ///
	(scatter variable sig_01 if variable >= 5, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(tiny)) ///
	(scatter variable sig_05, msymbol(circle) mcolor(dkgreen) msize(medlarge) mlabel(sig_05) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(medium)) ///
	(scatter variable sig_05, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(tiny)) if variable <= 6, ///
	ytitle(, size(zero)) yscale(reverse) ylabel(1(1)6, valuelabel angle(horizontal) labsize(medium) noticks) ///
	xtitle("Marginal percentage change in the odds of unrest", size(medium) margin(small)) ///
	xlabel(-20(20)140, grid labsize(small)) xmtick(##2) ///
	legend(cols(4) size(small) region(lcolor(none)) order(1 "95% confidence interval" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) ///
	title("Endogenous Probit Model Results", margin(medsmall) span) subtitle("Main Stage: DV = Occurence of unrest", size(medlarge) margin(medsmall) span) ///
	note("* instrumented using 9 month dry MSCP (lagged), trade balance adjusted grain instrument & all other covariates", size(small) span) xsize(6) ysize(3) ///
	graphregion(margin(medsmall)) plotregion(margin(medlarge)) scheme(s1color) scale(1) name(main_sig_legend_color, replace)
graph export "graphs/marg_effs_ivprobit_sig_legend_color.eps", replace
graph export "graphs/marg_effs_ivprobit_sig_legend_color.pdf", replace

twoway (rcap min95 max95 variable, lcolor(gs9) horizontal) ///
	(scatter variable not_sig, msymbol(circle) mlcolor(gs9) mfcolor(white) msize(medsmall)) ///
	(scatter variable sig_01 if variable < 5, msymbol(circle) mcolor(black) msize(medlarge) mlabel(sig_01) mlabcolor(black) mlabposition(6) mlabsize(small)) ///
	(scatter variable sig_01 if variable < 5, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(6) mlabsize(small) mlabgap(medium)) ///
	(scatter variable sig_01 if variable >= 5, msymbol(circle) mcolor(black) msize(medlarge) mlabel(sig_01) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(medium)) ///
	(scatter variable sig_01 if variable >= 5, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(tiny)) ///
	(scatter variable sig_05, msymbol(circle) mcolor(gs9) msize(medlarge) mlabel(sig_05) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(medium)) ///
	(scatter variable sig_05, msymbol(none) mlabel(se) mlabcolor(black) mlabposition(12) mlabsize(small) mlabgap(tiny)) if variable <= 6, ///
	ytitle(, size(zero)) yscale(reverse) ylabel(1(1)6, valuelabel angle(horizontal) labsize(medium) noticks) ///
	xtitle("Marginal percentage change in the odds of unrest", size(medium) margin(medium)) ///
	xlabel(-20(20)140, grid labsize(small)) xmtick(##2) legend(off) subtitle("Main Stage: DV = Occurence of unrest", size(medlarge) margin(medium) span) ///
	note("* instrumented using 9 month dry MSCP (lagged), trade balance adjusted grain instrument & all other covariates", size(small) span) xsize(5) ysize(2.5) ///
	graphregion(margin(medsmall)) plotregion(margin(medlarge)) scheme(s1mono) scale(1) name(main_sig_mono, replace)
graph export "graphs/marg_effs_ivprobit_sig_mono.eps", replace
graph export "graphs/marg_effs_ivprobit_sig_mono.pdf", replace

********** GRAPH PREDICTED PROBABILITY OF UNREST **********

set more off

local user  "`c(username)'"
cd "/Users/`user'/Documents/active_projects/feeding_unrest_africa/analysis"
use "feeding_unrest_africa.dta", clear

loc dv "unrest"
loc x1 "l_unrest"
loc x2 "l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
loc iv "l_dry_mscp9 grinst"
loc z "l_wet_mscp6"
	
eststo ivprob_best: ivprobit `dv' `z' `x2' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num) first nolog
gen sample = e(sample)
estat classification
*** likelihood ratio positive
*** sensitivity / (1 - specificity)
display r(P_p1) / (1 - r(P_n0))
*** likelihood ratio negative
*** (1 - sensitivity) / specificity
display (1 - r(P_p1)) / r(P_n0)

margins, at(std_food_chg=0) pred(pr) vce(unconditional) vsquish post
local zero = round(_b[_cons],.001)
display "if food_chg == 0 prob of unrest == `zero'"

est res ivprob_best
margins, at(std_food_chg=(-1(.1)2.5)) pred(pr) vce(unconditional) vsquish post
*est res ivprob_best
*margins, at(std_food_chg=(1.1(.01)1.2)) pred(pr) vsquish post
*margins, at(std_food_chg=(1.14(.001)1.15)) pred(pr) vsquish post
*margins, at(std_food_chg=(1.15)) pred(pr) vsquish post

*margins, at(std_food_chg=0) atmeans over(iso_num) pred(pr) vce(unconditional) vsquish post
*margins, at(std_food_chg=1.150) atmeans over(iso_num) pred(pr) vce(unconditional) vsquish post

**** 1.150 ****
marginsplot, xdimension(at(std_food_chg)) recast(line) plotopts(lwidth(thick)) recastci(rline) ciopts(lpattern(longdash) lcolor(gs9)) xlabel(-1 0 1 1.150 2) xmtick(-0.5 .5 1.5 2.5) ylabel(0 `zero' 0.5 1, angle(horizontal) grid) ymtick(##5) ytitle("Probability", size(medium) margin(small)) xtitle("Monthly change in domestic food prices (standard deviations)*", size(medium) margin(small)) title(, size(zero)) note("* instrumented using 9 month dry MSCP (lagged), trade balance adjusted grain instrument & all other covariates", size(vsmall)) xsize(5) ysize(4) yline(`zero', lpattern(solid) lcolor(gs14)) xline(1.150, lpattern(solid) lcolor(gs14)) xline(0, lpattern(solid) lcolor(gs14)) scheme(s1mono) name(pred_mono, replace)
graph export "graphs/pred_prob_unrest_mono.eps", as(eps) replace
graph export "graphs/pred_prob_unrest_mono.pdf", replace

marginsplot, xdimension(at(std_food_chg)) recast(line) plotopts(lcolor(orange) lwidth(thick)) recastci(rline) ciopts(lpattern(longdash)) ytitle("Probability", size(medium) margin(medsmall)) xtitle("Monthly change in domestic food prices (standard deviations)*", size(medium) margin(small)) xlabel(-1 0 1 1.150 2) xmtick(-0.5 .5 1.5 2.5) ylabel(0 `zero' 0.5 1, angle(horizontal) grid) ymtick(##5) title("Predicted Probability of Unrest (with 95% CI)", size(medlarge) margin(medium)) note("* instrumented using 9 month dry MSCP (lagged), trade balance adjusted grain instrument & all other covariates", size(vsmall)) xsize(6) ysize(5) yline(`zero', lpattern(solid) lcolor(gs14)) xline(1.150, lpattern(solid) lcolor(gs14)) xline(0, lpattern(solid) lcolor(gs14)) scheme(s1color) name(pred_color, replace)
graph export "graphs/pred_prob_unrest_color.eps", as(eps) replace
graph export "graphs/pred_prob_unrest_color.pdf", replace

drop if sample != 1
collapse (first) name iso3 (mean) mn_fc sd_fc, by(iso_num)
replace mn_fc = mn_fc * 100
replace sd_fc = sd_fc * 100
gen effect = sd_fc * .081
gen tip_pt = mn_fc + (1.150 * sd_fc)
lab var mn_fc "Long-term mean monthly change in domestic food prices (%)"
lab var sd_fc "Long-term SD of monthly change in domestic food prices (%)"
*lab var tip_pt "Percentage increase in food prices"
format mn_fc sd_fc tip_pt effect %3.2f

graph bar (asis) tip_pt, over(name, sort(tip_pt) label(labsize(small) angle(90))) blabel(bar, format(%3.1f) orientation(vertical)) ylabel(0(5)16, angle(horizontal) nogrid) ymtick(##5) ytitle("Percentage increase in food prices", size(medium) margin(medsmall)) title("Food Price Increase Corresponding to 1.150 Standard Deviations", margin(medsmall)) scheme(s1color) xsize(6) ysize(3) name(country_threshold_color, replace)
graph export "graphs/country_threshold_color.pdf", replace

graph bar (asis) tip_pt, over(name, sort(tip_pt) label(labsize(medsmall) angle(90))) blabel(bar, format(%3.1f) orientation(vertical)) ylabel(0(5)16, angle(horizontal) nogrid) ymtick(##5) ytitle("Percentage increase in food prices", size(medium) margin(medsmall)) scheme(s1mono) xsize(5) ysize(2.5) name(country_threshold_mono, replace)
graph export "graphs/country_threshold_mono.pdf", replace

capture erase "ivprob_res.dta"

********************************************************************************

use "feeding_unrest_africa.dta", clear
quietly ivprobit unrest l_unrest l_wet_mscp6 elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort i.iso_num i.month i.year (std_food_chg = l_dry_mscp9 grinst), cl(iso_num) nolog
est sto best
gen sample = e(sample)
drop if sample == 0
tempfile temp
save `temp', replace
margins, at(std_food_chg=(0 1)) atmeans over(iso_num) pred(pr) post
parmest, sa(marg, replace)
use marg.dta, clear
split parm, p("._at#")
destring parm1, gen(std_food_chg)
replace std_food_chg = std_food_chg - 1
destring parm2, i(".iso_num") gen(iso_num)
drop parm parm1 parm2 z p
rename min95 min
rename max95 max
save marg.dta, replace

use `temp', clear
est res best
local fceff = _b[unrest:std_food_chg]
local dryeff = _b[std_food_chg:l_dry_mscp9]
local greff = _b[std_food_chg:grinst]
collapse (mean) iso_num mn_fc = food_chg mn_unrest = unrest (sd) sd_fc = food_chg, by(name)
replace mn_fc = mn_fc * 100
replace sd_fc = sd_fc * 100
gen greff = mn_fc + (`greff' * sd_fc)
gen dryeff = mn_fc + (`dryeff' * sd_fc)

merge 1:m iso_num using marg.dta
drop _merge
encode name, gen(country)
xtset iso_num std_food_chg
save marg.dta, replace

drop if std_food_chg == 2
replace country = country + .4 if std_food_chg == 1
gen sig = l.max < min
replace sig = 1 if f.sig == 1

twoway (bar estimate country if std_food_chg == 0, barwidth(.4) fcolor(gs12) lcolor(gs12) lwidth(none)) ///
	(rcap min max country if std_food_chg == 0, lcolor(black) lwidth(vthin) msize(small)) ///
	(bar estimate country if std_food_chg == 1, barwidth(.4) fcolor(gs8) lcolor(gs8) lwidth(none)) ///
	(rcap min max country if std_food_chg == 1, lcolor(black) lwidth(vthin) msize(small)), ///
	xlabel(1(1)40, valuelabel labsize(small) angle(90) notick) ///
	xscale(noline titleg(-3)) xtitle(, size(zero)) ///
	ylabel(, labsize(small) grid) yscale(noline) ///
	ytitle("Predicted probability of unrest", size(small) height(5)) ///
	legend(cols(2) size(small) region(lcolor(none)) ///
	order(1 "Increase in food prices equal to long-term mean" 2 "95% confidence interval" 3 "1 SD increase in food prices over long-term mean")) ///
	plotregion(margin(small)) xsize(6) ysize(3) scheme(s1mono) name(pred_prob1, replace)
graph export "graphs/prhat_ctry_stdfc_mono1.pdf", replace

twoway (bar estimate country if std_food_chg == 0, barwidth(.4) fcolor(gs12) lcolor(gs12) lwidth(none)) ///
	(rcap min max country if std_food_chg == 0, lcolor(black) lwidth(vthin) msize(small)) ///
	(bar estimate country if std_food_chg == 1, barwidth(.4) fcolor(gs8) lcolor(gs8) lwidth(none)) ///
	(bar estimate country if sig == 1, barwidth(.4) fcolor(none) lcolor(black) lwidth(thin)) ///
	(rcap min max country if std_food_chg == 1, lcolor(black) lwidth(vthin) msize(small)), ///
	xlabel(1(1)40, valuelabel labsize(small) angle(90) notick) ///
	xscale(noline titleg(-3)) xtitle(, size(zero)) ///
	ylabel(, labsize(small) grid) yscale(noline) ///
	ytitle("Predicted probability of unrest", size(small) height(4)) ///
	legend(cols(2) size(small) region(lcolor(none)) ///
	order(1 "Increase in food prices equal to long-term mean" 2 "95% confidence interval" 3 "1 SD increase in food prices over long-term mean" 4 "signifcant difference")) ///
	plotregion(margin(small)) xsize(6) ysize(3) scheme(s1mono) name(pred_prob2, replace)
graph export "graphs/prhat_ctry_stdfc_mono2.pdf", replace

use marg.dta, clear
keep name mn_fc sd_fc estimate min max std_food_chg
foreach var of varlist estimate min max {
	gen str4 str`var' = string(round(`var'*100,.1), "%3.1f")
	drop `var'
	rename str`var' `var'
	}
reshape wide estimate min max, i(name) j(std_food_chg)
replace mn_fc = round(mn_fc,.01)
gen str4 mean = string(round(mn_fc*100), "%2.0f")
gen str4 sd = string(round(sd_fc*100), "%2.0f")
drop mn_fc sd_fc
lab var name "Country"
lab var mean "Long-term mean monthly change in domestic food prices (%)"
lab var sd "Long-term SD of monthly change in domestic food prices (%)"
lab var estimate0 "predicted probability"
lab var min0 "95\% lower bound"
lab var max0 "95\% upper bound"
lab var estimate1 "predicted probability"
lab var min1 "95\% lower bound"
lab var max1 "95\% upper bound"
order name mean sd
replace name = "C\^ote d'Ivoire" if name == "C™te d'Ivoire"
compress
gen end = "\\"
export delimited using "results/ctry_spec_table.tex", delimiter("&") novarnames replace
erase marg.dta

exit
