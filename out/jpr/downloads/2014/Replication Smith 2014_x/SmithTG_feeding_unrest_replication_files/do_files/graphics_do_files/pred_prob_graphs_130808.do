********** MOTHER NATURE AND MARKETS **********
********** WRITTEN BY TODD G. SMITH ***********
********** UPDATED 5 MAY 2013 **************


set more off

local date	"`c(current_date)'"
local user  "`c(username)'"

cd "/Users/`user'/Documents/Projects & Papers/Mother Nature and Markets/analysis"
use "data/mother_nature_markets_final.dta", clear
drop if iso3 == "ZWE" & time >= 550 & time <= 582		// Nov 2005 to Jul 2008
drop if iso3 == "AGO" & time <= 505						// through Feb 2002 (death of Savimbi)

loc index "FAO"
loc dv "unrest"
*loc x "l_unrest elections pop pop_growth pct_urb pct_youth gdppc"
loc x "l_unrest elections pop pop_growth pct_urb pct_youth gdppc democ autoc life_exp inf_mort"
loc z "l_`index'_food_chg l_wet_mscp9"
loc iv "l_dry_mscp9"

quietly ivprobit `dv' `z' `x' i.iso_num i.month i.year (std_food_chg = `iv'), asis cl(iso_num) first nolog ///
	noemptycells difficult tech(nr bhhh dfp) iterate(500) tolerance(1e-4)


***********************************************************
********** GRAPH PREDICTED PROBABILITY OF UNREST **********
***********************************************************

*margins, at(std_food_chg=(.63723(.000001).637231)) pred(pr) vsquish post
***** Indicates that 0.637231 standard deviations above the mean is the point that unrest becomes more likely than not.

margins, at(std_food_chg=(-2(.1)2)) pred(pr) vsquish post

marginsplot, xdimension(at(std_food_chg)) ///
	recast(line) ///
	plotopts(lwidth(thick)) ///
	recastci(rline) ///
	ciopts(lpattern(longdash) lcolor(gs9)) ///
	xlabel(-2(1)2) xmtick(##2) ///
	ylabel(0(.5)1, grid) ymtick(##5) ///
	ytitle(Predicted probability of unrest)  ///
	title (, size(zero)) ///
	note("95% CI displayed; `index' Food Price Index used for international commodity prices; dry MSCP at 9 months used as IV for standardized % change in food prices", size(tiny) span) ///
	xsize(6) ysize(4) xline(.63723, lpattern(dash) lcolor(gs9)) scheme(s1mono) ///
	name(pred_mono, replace)
*graph export "graphs/`index'_graphs/pred_prob_unrest_mono.eps", as(eps) replace
graph export "graphs/`index'_graphs/pred_prob_unrest_sd_mono.pdf", replace

marginsplot, xdimension(at(std_food_chg)) ///
	recast(line) ///
	plotopts(lcolor(orange) ///
	lwidth(thick)) ///
	recastci(rline) ///
	ciopts(lpattern(longdash)) ///
	ytitle(Predicted probability of unrest) ///
	xlabel(-2(1)2) xmtick(##2) ///
	ylabel(0(.5)1, grid) ymtick(##5) ///
	title("Effect of Food Price Changes on Predicted Probability of Unrest", size(medlarge) margin(medium)) ///
	note("95% CI displayed; `index' Food Price Index used for international commodity prices; dry MSCP at 9 months used as IV for standardized % change in food prices", size(tiny) span) ///
	xsize(6) ysize(4.5) xline(.63723, lpattern(dash) lcolor(dkgreen)) scheme(s1color) ///
	name(pred_color, replace)
*graph export "graphs/`index'_graphs/pred_prob_unrest_color.eps", as(eps) replace
*graph export "graphs/`index'_graphs/pred_prob_unrest_sd_color.pdf", replace

marginsplot, xdimension(at(std_food_chg)) ///
	recast(line) ///
	plotopts(lcolor(orange) ///
	lwidth(thick)) ///
	recastci(rline) ///
	ciopts(lpattern(longdash)) ///
	ytitle(Predicted probability of unrest) ///
	xlabel(-2(1)2) xmtick(##2) ///
	ylabel(0(.5)1, grid) ymtick(##5) ///
	title("Effect of Food Price Changes on Predicted Probability of Unrest", size(medlarge) margin(medium)) ///
	note("95% CI displayed; `index' Food Price Index used for international commodity prices; dry MSCP at 9 months used as IV for standardized % change in food prices", size(tiny) span) ///
	xsize(6) ysize(4.5) ///
	xline(.63723, lpattern(dash) lcolor(dkgreen)) ///
	xline(1.478, lpattern(dash) lcolor(dkgreen)) scheme(s1color) ///
	name(pred_color_2line, replace)

marginsplot, xdimension(at(std_food_chg)) ///
	recast(line) ///
	plotopts(lcolor(orange) ///
	lwidth(thick)) ///
	recastci(rline) ///
	ciopts(lpattern(longdash)) ///
	ytitle(Predicted probability of unrest) ///
	xlabel(-2(1)2) xmtick(##2) ///
	ylabel(0(.5)1, grid) ymtick(##5) ///
	title("Effect of Food Price Changes on Predicted Probability of Unrest", size(medlarge) margin(medium)) ///
	note("95% CI displayed; `index' Food Price Index used for international commodity prices; dry MSCP at 9 months used as IV for standardized % change in food prices", size(tiny) span) ///
	xsize(6) ysize(4.5) ///
	addplot(histogram std_food_chg if std_food_chg < 4 & std_food_chg > -3, yaxis(2) recast(area) fcolor(none)) ///
	xline(.63723, lpattern(dash) lcolor(dkgreen)) ///
	xline(1.478, lpattern(dash) lcolor(dkgreen)) ///
	legend(off) ///
	scheme(s1color) ///
	name(pred_color_hist, replace)

collapse (first) name iso3 (mean) mn_fc sd_fc, by(iso_num)
gen tip_pt = mn_fc + (0.637231 * sd_fc)
lab var mn_fc "Long-term mean in percentage change in food prices"
lab var sd_fc "Long-term standard deviation in percentage change in food prices"
lab var tip_pt "Food price inc of 50% prob of unrest (%)"
format tip_pt %3.2f

*graph hbar (asis) tip_pt, over(name, label(labsize(medsmall) labgap(large))) blabel(bar, format(%3.2f)) scheme(s1color) xsize(5) ysize(7.5)

graph hbar (asis) tip_pt, over(name, sort(tip_pt) label(labsize(medsmall) labgap(large))) blabel(bar, format(%3.2f)) scheme(s1color) xsize(5) ysize(7.5)
graph export "graphs/fao_graphs/country_tipping_point.pdf", replace

*margins, at(std_food_chg=(6.5(.1)7.2)) atmeans pred(pr)
*margins, at(std_food_chg=(3(.1)3.7)) atmeans pred(pr)

capture erase `ivprob_res'

exit


