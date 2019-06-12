/*************************************************************************************************************
This .do file makes figure 1 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use crck_ui_macro_dataset_weekly if state=="Vermont" & tin(1jan2001,31dec2015), clear

local xsize = $xsize_full
local ysize=2.5
local labsize = 12/min(`xsize',`ysize')
local legend `"on row(2) rowgap(0) size(`labsize') position(6) region(lcolor(white)) ring(1) label(`=`bars'+1' `"Real-Time Weeks"') label(`=`bars'+2' `"Revised Weeks"') label(`=`bars'+3' `"Real-Time U"') label(`=`bars'+4' `"Revised U"') "'	
local prog EB
local yaxis1 `"ylabel(0 13 20 ,nogrid tposition(outside) angle(horizontal) labsize(`labsize') format(%9.0f)) yscale(titlegap(3.00)) ytitle("Additional Weeks Available", size(`labsize'))"'
local yaxis2 `"ylabel(`yvalues',nogrid tposition(outside) angle(horizontal) labsize(`labsize') format(%9.1f) axis(2)) yscale(titlegap(3.00) axis(2)) ytitle("Unemployment Rate", size(`labsize') axis(2))"'
local yaxis `"`yaxis1' `yaxis2'"'
local lines `"(tsline Tstar_`prog', lpattern(solid) lwidth(thick) lcolor(gs10)) (tsline T_`prog', lpattern(longdash) lwidth(thick) lcolor(gs4)) (tsline RealtimeTURma, lpattern(longdash_dot) lwidth(medthin) lcolor(gs10) yaxis(2)) (tsline RevisedTURma, lpattern(longdash_dot) lwidth(medthin) lcolor(gs4) yaxis(2))"'
sum date, meanonly
forvalues ccyy = `=year(r(min))'(2)`=year(r(max))' {
	local tvalues `"`tvalues' `=td(1jan`ccyy')'"'
}
local taxis `"tlabel(`tvalues',tposition(outside) labsize(`labsize') format(%tdCCYY)) ttitle("", size(`labsize'))"'
local filename fig1	

twoway `lines', legend(`legend') scheme(s2mono) graphregion(color(white) margin(l=$l_m_p r=$r_m_p)) plotregion(style(none) margin(zero)) `yaxis' `taxis' xsize(`xsize') ysize(`ysize')
qui graph export output/`filename'.pdf, replace
qui graph export output/`filename'.eps, replace
