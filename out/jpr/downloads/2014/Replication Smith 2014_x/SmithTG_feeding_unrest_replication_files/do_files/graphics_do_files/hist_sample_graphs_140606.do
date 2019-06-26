********** Feeding Unrest in Africa **********
********** Graphics
********** updated 06 June 2014 **************

clear all
set more off
set matsize 800

local user  "`c(username)'"

cd "/Users/`user'/Documents/active_projects/feeding_unrest_africa/analysis"
use "feeding_unrest_africa.dta", clear

ivprobit unrest l_wet_mscp6 l_unrest (std_food_chg = grinst l_dry_mscp9), cl(iso_num) first nolog
gen sample = e(sample)

gen food_chg_pct = food_chg * 100
lab var food_chg_pct "Monthly change in domestic food price indices (%)"

histogram food_chg_pct if sample == 1 & food_chg_pct < 15 & food_chg_pct > -15, by(name, rows(5) imargin(vsmall) legend(off) note(, size(zero)) subtitle(, size(huge)) title("Distribution of Changes in Domestic Food Indices", size(medium) margin(small) span)) normal xlabel(-15(5)15) xmtick(##5) ytitle(, size(small)) xtitle(, size(small)) xsize(8) ysize(6) name(food_chg_hist_by_ctry_color, replace) scheme(s1color)
graph export "graphs/food_chg_hist_by_ctry_color.pdf", replace

histogram food_chg_pct if sample == 1 & food_chg_pct < 15 & food_chg_pct > -15, by(name, rows(5) imargin(vsmall) legend(off) note(, size(zero))) subtitle(, size(huge)) normal xlabel(-15(5)15, labsize(medlarge)) ylabel(, labsize(medlarge)) xmtick(##5) ytitle(, size(medsmall)) xtitle(, size(medsmall)) xsize(5) ysize(2.5) name(food_chg_hist_by_ctry_mono, replace) scheme(s1mono)
graph export "graphs/food_chg_hist_by_ctry_mono.pdf", replace

encode name, gen(name_code)
twoway (scatter name_code time, msize(vsmall) msymbol(smsquare)) if sample == 1, ytitle(, size(zero)) ylabel(#42, labels labsize(vsmall) angle(horizontal) valuelabel) yscale(reverse) xtitle(, size(zero)) xlabel(360(12)635, grid labsize(vsmall) angle(vertical)) xsize(5) ysize(3.5) name(sample_mono, replace) scheme(s1mono)
*graph export "graphs/sample_coverage_mono.eps", replace
graph export "graphs/sample_coverage_mono.pdf", replace

twoway (scatter name_code time, msize(vsmall) msymbol(smsquare)) if sample == 1, ytitle(, size(zero)) ylabel(#42, labels labsize(vsmall) angle(horizontal) valuelabel) yscale(reverse) xtitle(, size(zero)) xlabel(360(12)635, grid labsize(vsmall) angle(vertical)) title("Sample Coverage", size(medsmall) margin(medsmall) span) xsize(6) ysize(5) name(sample_color, replace) scheme(s1color)
*graph export "graphs/sample_coverage_color.eps", replace
graph export "graphs/sample_coverage_color.pdf", replace

exit

histogram std_food_chg if sample == 1, normal xsize(4.5) ysize(4) name(std_food_chg_hist_mono, replace) scheme(s1mono)
*graph export "graphs/std_food_chg_hist_mono.eps", replace
graph export "graphs/std_food_chg_hist_mono.pdf", replace

histogram std_food_chg if sample == 1, normal ylabel(, grid) xsize(4.5) ysize(4) name(std_food_chg_hist_color, replace) scheme(s1color)
*graph export "graphs/std_food_chg_hist_color.eps", replace
graph export "graphs/std_food_chg_hist_color.pdf", replace

histogram mscp9 if sample == 1, normal xscale(range(-7.5 7.5)) xlabel(-6(3)6) xmtick(##3) xsize(4.5) ysize(4) name(mscp9_hist_mono, replace) scheme(s1mono)
*graph export "graphs/mscp9_hist_mono.eps", replace
graph export "graphs/mscp9_hist_mono.pdf", replace

histogram mscp9 if sample == 1, normal xscale(range(-7.5 7.5)) xlabel(-6(3)6) xmtick(##3) ylabel(, grid) xsize(4.5) ysize(4) name(mscp9_hist_color, replace) scheme(s1color)
*graph export "graphs/mscp9_hist_color.eps", replace
graph export "graphs/mscp9_hist_color.pdf", replace

histogram mscp6 if sample == 1, normal xscale(range(-7.5 7.5)) xlabel(-6(3)6) xmtick(##3) xsize(4.5) ysize(4) name(mscp6_hist_mono, replace) scheme(s1mono)
*graph export "graphs/mscp6_hist_mono.eps", replace
graph export "graphs/mscp6_hist_mono.pdf", replace

histogram mscp6 if sample == 1, normal xscale(range(-7.5 7.5)) xlabel(-6(3)6) xmtick(##3) ylabel(, grid) xsize(4.5) ysize(4) name(mscp6_hist_color, replace) scheme(s1color)
*graph export "graphs/mscp6_hist_color.eps", replace
graph export "graphs/mscp6_hist_color.pdf", replace

exit
