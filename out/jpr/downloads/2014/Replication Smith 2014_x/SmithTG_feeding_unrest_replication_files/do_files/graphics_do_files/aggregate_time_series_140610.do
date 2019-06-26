********** MOTHER NATURE AND MARKETS **********
********** WRITTEN BY TODD G. SMITH ***********
********** UPDATED 3 APRIL 2013 **************
********** THIS FILE GENERATES SOME TIME SERIES GRAPHICS FOR USE IN THE PAPER.

clear all
set more off

local date	"`c(current_date)'"
local user  "`c(username)'"

cd "/Users/`user'/Documents/active_projects/feeding_unrest_africa/analysis"

*capture log close
*log using "logs/agg_time_series_analysis.log", replace

use "feeding_unrest_africa.dta", clear

**** SCAD EVENTS BY COUNTRY *****

gen nv_events = events - viol_events
lab var nv_events "Number of nonviolent events"
*replace name = "Tazania" if name == "Tanzania, United Republic of"
*replace name = "Central African Rep" if name == "Central African Republic"
graph bar (sum) viol_events nv_events if events != ., ///
	over(name, label(angle(vertical) labsize(small))) stack ///
	ylabel(, labsize(small)) ///
	xsize(5) ysize(2.5) ///
	legend(region(lcolor(none)) position(10) ring(0) size(medsmall) order(1 "Violent events" 2 "Non-violent events")) ///
	ytitle("Number of events", size(medsmall) margin(medsmall)) ///
	title(, size(zero)) ///
	note("Source: SCAD", size(small) span) ///
	scheme(s1mono) name(events_ctry_mono, replace)
*graph bar (sum) nv_events viol_events if events != ., over(name, sort(events) label(angle(vertical) labsize(small)))  xsize(6.5) ysize(3) stack legend(order(1 "non-violent events" 2 "violent events")) title(SCAD Events by Country) scheme(s1mono)
*graph export "graphs/agg_time_series/scad_events_by_country_mono.eps", replace
graph export "graphs/scad_events_by_country_mono.pdf", replace

graph bar (sum) nv_events viol_events if events != ., ///
	over(name, label(angle(vertical) labsize(small))) stack ///
	bar(1, fcolor(dkgreen)) bar(2, fcolor(dkorange)) ///
	xsize(6) ysize(3.5) ///
	ylabel(, labsize(small)) ///
	legend(region(lcolor(none)) position(10) ring(0) size(small) order(1 "Violent events" 2 "Non-violent events")) ///
	ytitle("Number of events", size(medsmall) margin(medsmall)) ///
	title("SCAD Events by Country (1990Ð2012)", margin(medsmall) color (black)) ///
	scheme(s1color) name(events_ctry_color, replace)
*graph bar (sum) nv_events viol_events if events != ., over(name, sort(events) label(angle(vertical) labsize(small)))  xsize(6.5) ysize(3) stack legend(order(1 "non-violent events" 2 "violent events")) title(SCAD Events by Country) scheme(s1mono)
*graph export "graphs/agg_time_series/scad_events_by_country_color.eps", replace
graph export "graphs/scad_events_by_country_color.pdf", replace
preserve

keep if iso_num == 894
keep time IMF_food IMF_food_chg FAO_food FAO_food_chg pallfnf-poilapsp_chg
tempfile `intl'
save intl, replace

restore

keep iso_num time year month unrest violence events viol_events nv_events
collapse (firstnm) year month (sum) events viol_events nv_events, by(time)

lab var events "Number of unrest events"
lab var viol_events "Number of violent events"
lab var nv_events "Number of nonviolent events"

replace events = . if year < 1990
replace nv_events = . if year < 1990
replace viol_events = . if year < 1990

merge 1:1 time using intl
drop _merge

tsset time
sort time

capture drop ma_events
tssmooth ma ma_events = events, window(4 1 4)
lab var ma_events "9 month moving average"
lab var events "Unrest events"
twoway (tsline events, lwidth(vthin) connect(stairstep) lpattern(solid) lcolor(gs12)) ///
	(tsline ma_events, lcolor(gs6) lpattern(dash) lwidth(medthick)) ///
	if year > 1989 & year < 2013, ///
	xsize(5) ysize(2) ///
	xlabel(360(24)624, labsize(small) angle(45)) xmtick(##8) ///
	ylabel(, labsize(small)) ///
	ytitle("Number of events", size(medsmall) margin(small)) ///
	xtitle(, size(medsmall) margin(small)) ///
	title(, size(zero)) ///
	legend(region(lcolor(none)) position(10) ring(0) size(medsmall)) ///
	ttitle(, size(zero)) scheme(s1mono) name(events_mono, replace)
*graph export "graphs/agg_time_series/agg_scad_events_mono.eps", replace
graph export "graphs/events_mono.pdf", replace

twoway (tsline events, lwidth(thin) connect(stairstep) lpattern(solid) lcolor(ebg)) ///
	(tsline ma_events, lcolor(edkblue) lpattern(solid) lwidth(medthick)) ///
	if year > 1989 & year < 2013, ///
	xsize(6) ysize(3.5) ///
	xlabel(360(24)624, labsize(small) angle(45)) xmtick(##8) ///
	ylabel(, labsize(small)) ///
	ytitle("Number of events", size(medsmall) margin(medsmall)) ///
	title("SCAD Events by Month", margin(medsmall) color (black)) ///
	legend(region(lcolor(none)) position(10) ring(0) size(medsmall)) ///
	ttitle(, size(zero)) scheme(s1color) name(events_color, replace)
*graph export "graphs/agg_time_series/agg_scad_events_color.eps", replace
graph export "graphs/events_color.pdf", replace

***** Changes in FAO index and SCAD events *****

prais events l.FAO_food_chg, robust
prais events FAO_food_chg if year >= 1900, robust
loc FAO_b = round(_b[FAO_food_chg], .001)
loc t = _b[FAO_food_chg] / _se[FAO_food_chg]
loc FAO_p = round(2 * ttail(e(df_r),abs(`t')), .0001)

twoway (tsline events, lwidth(thin) connect(stairstep) lpattern(solid) lcolor(ebg)) ///
	(tsline ma_events, lcolor(edkblue) lpattern(dash) lwidth(medthick)) ///
	(tsline FAO_food_chg, lcolor(black) lpattern(solid) lwidth(medthick) yaxis(2)) ///
	if year >= 1990 & year < 2013, ///
	xsize(5) ysize(2) ///
	xlabel(360(24)624, labsize(small) angle(45)) xmtick(##8) ///
	ylabel(, labsize(small) axis(2)) ///
	ytitle("Number of events", size(medsmall) margin(medsmall)) ///
	ytitle(, size(medsmall) margin(medsmall) axis(2)) ///
	title(, size(zero)) ///
	legend(region(lcolor(none))) ///
	note("Univariate Prais-Winsten AR1 regression of % change in FAO Food Price Index (lagged) on number of SCAD events yields a coef. of `FAO_b' (p = 0`FAO_p')", size(vsmall)) ///
	ttitle(, size(zero)) scheme(s1mono) name(events_fao_chg_mono, replace)
graph export "graphs/events_fao_chg_mono.pdf", replace

twoway (tsline events, lwidth(thin) connect(stairstep) lpattern(solid) lcolor(ebg)) ///
	(tsline ma_events, lcolor(edkblue) lpattern(dash) lwidth(medthick)) ///
	(tsline FAO_food_chg, lcolor(dkorange) lpattern(solid) lwidth(medthick) yaxis(2)) ///
	if year >= 1990 & year < 2013, ///
	xsize(6) ysize(3) ///
	xlabel(360(24)624, labsize(small) angle(45)) xmtick(##8) ///
	ylabel(, labsize(small) axis(2)) ///
	ytitle("Number of events", size(medsmall) margin(medsmall)) ///
	ytitle(, size(medsmall) margin(medsmall) axis(2)) ///
	legend(region(lcolor(none))) ///
	title("Unrest Events & FAO Food Price Changes", margin(medsmall) color (black)) ///
	note("Univariate Prais-Winsten AR1 regression of % change in FAO Food Price Index (lagged) on number of SCAD events yields a coef. of `FAO_b' (p = 0`FAO_p')", size(vsmall)) ///
	ttitle(, size(zero)) scheme(s1color) name(events_fao_chg_color, replace)
graph export "graphs/events_fao_chg_color.pdf", replace

***** SCAD EVENTS & FAO INDEX *****

prais ma_events FAO_food, robust
loc FAO_b = string(round(_b[FAO_food], .001), "%4.3f")
loc FAO_se = string(round(_se[FAO_food], .001), "%4.3f")
loc t = _b[FAO_food] / _se[FAO_food]
loc FAO_p = string(round(2 * ttail(e(df_r),abs(`t')), .001), "%4.3f")
prais events l.FAO_food, robust

prais ma_events IMF_food, robust
loc IMF_b = string(round(_b[IMF_food], .001), "%4.3f")
loc IMF_se = string(round(_se[IMF_food], .001), "%4.3f")
loc t = _b[IMF_food] / _se[IMF_food]
loc IMF_p = string(round(2 * ttail(e(df_r),abs(`t')), .001), "%4.3f")

twoway (tsline events, lwidth(vthin) connect(stairstep) lpattern(solid) lcolor(gs12)) ///
	(tsline ma_events, lcolor(gs6) lpattern(dash) lwidth(medthick)) ///
	(tsline FAO_food, lcolor(black) lpattern(solid) lwidth(medthick) yaxis(2) ytitle(, size(medsmall) margin(medium))) ///
	if time >= 360 & time <= 635, ///
	xsize(5) ysize(2.5) ///
	xlabel(360(24)624, labsize(small) angle(45)) xmtick(##8) ///
	ylabel(, labsize(small) axis(2)) ///
	ytitle("Number of events", size(medsmall) margin(medsmall)) ///
	ytitle(, size(medsmall) margin(medsmall) axis(2)) ///
	legend(col(3) region(lcolor(none)) size(small)) ///
	note("Sources: FAO & SCAD; Prais-Winsten reg results: FAO Index on mvg avg of SCAD events coef = `FAO_b' (SE = `FAO_se')", size(vsmall) span) ///
	ttitle(, size(zero)) name(events_fao_mono, replace) scheme(s1mono)
graph export "graphs/events_fao_mono.pdf", replace

twoway (tsline events, lwidth(thin) connect(stairstep) lpattern(solid) lcolor(ebg)) ///
	(tsline ma_events, lcolor(edkblue) lpattern(dash) lwidth(medthick)) ///
	(tsline FAO_food, lcolor(dkorange) lpattern(solid) lwidth(medthick) yaxis(2) ytitle(, size(medsmall) margin(medium))) ///
	if time >= 360 & time <= 635, ///
	xsize(6) ysize(3.5) ///
	xlabel(360(24)624, labsize(small) angle(45)) xmtick(##8) ///
	ylabel(, labsize(small) axis(2)) ///
	ytitle("Number of events", size(medsmall) margin(medsmall)) ///
	ytitle(, size(medsmall) margin(medsmall) axis(2)) ///
	legend(col(3) region(lcolor(none)) size(small)) ///
	title("Unrest Events & FAO Food Price Changes", margin(medsmall) color(black)) ///
	note("Sources: FAO, IMF & Scad; Prais-Winsten reg results: FAO Index on mvg avg of SCAD events coef = `FAO_b' (SE = `FAO_se'); IMF Index on mg avg of SCAD events coef = `IMF_b' (SE = `IMF_se')", size(vsmall) span) ///
	ttitle(, size(zero)) name(events_fao_color, replace) scheme(s1color)
graph export "graphs/events_fao_color.pdf", replace

capture erase intl.dta
*log close
exit
