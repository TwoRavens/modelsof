/*************************************************************************************************************
This .do file makes figure 4 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use $monthlydataset, clear
lab var phi `"Change in Fraction Receiving UI (PP)"'

local_projection phi if phi_sample, filename(fig4a) figure rhs(epsilon) leads(0(1)8) controls(L(1/12).u_revised) hdfe vce(cluster(state_n monthly)) absorb(state_n monthly) list restore noembed yvalues(-1(0.5)1.5) yscale(r(-1 1.1) titlegap(4.00)) yformat(%9.1f) ci(90)				

foreach part in Correct Error {
	local_projection phi`part' if phi_sample & monthly>=tm(2008m1), saveirf(phi`part'irf) rhs(epsilon) leads(0(1)8) controls(L(1/12).u_revised) hdfe vce(cluster(state_n monthly)) absorb(state_n monthly) list restore ci(90)					
}
preserve
qui use phiCorrectirf
ren epsilon* Correct*
merge 1:1 lead using phiErrorirf, nogenerate
ren epsilon* Error*
erase phiCorrectirf.dta
erase phiErrorirf.dta

tsset lead
local bars = 0 /*Dummy in case I decide to add recession bars*/
local xsize=$xsize_split
local ysize=2.5
local labsize=12/min(`xsize',`ysize')

local taxis `"tlabel(0(1)8,tposition(outside) labsize(`labsize') format(%9.0f)) ttitle("", size(`labsize'))"'
local yaxis `"ylabel(-1(0.5)1.5,nogrid tposition(outside) angle(horizontal) labsize(`labsize') format(%9.1f)) yscale(r(-1 1.1)) ytitle("Change in Fraction Receiving UI (PP)", size(`labsize'))"'

local colors gs4 gs10
local symbols x triangle
local patterns solid longdash
local msizes 1 0.35
foreach var in Error Correct {
	local c = `c'+1
	local color: word `c' of `colors'
	local symbol: word `c' of `symbols'
	local pattern: word `c' of `patterns'
	local msize: word `c' of `msizes'
	local lines `"`lines' (scatter `var'_b lead, msymbol(`symbol') mcolor(`color') msize(`=`msize'*`labsize'')) (line `var'_b `var'_l `var'_u lead, lpattern(`pattern' shortdash shortdash) lwidth(medthick medium medium) lcolor(`color' `color' `color'))"' 	
}
local legend `"on row(2) rowgap(0) size(`labsize') position(1) region(lcolor(white)) ring(0) order(1 5) label(1 `"Affected tiers"') label(5 `"Unaffected tiers"') "'
		
twoway `lines', yline(0, lpattern(dash) lwidth(medthin)) legend(`legend') scheme(s2mono) graphregion(color(white) margin(l=$l_m_p r=$r_m_p)) plotregion(style(none) margin(zero)) `yaxis' `taxis' xsize(`xsize') ysize(`ysize')
qui graph export output/fig4b.eps, replace
qui graph export output/fig4b.pdf, replace
restore
