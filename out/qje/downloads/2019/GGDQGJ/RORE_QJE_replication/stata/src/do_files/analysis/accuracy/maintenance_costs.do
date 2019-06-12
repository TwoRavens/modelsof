/*--------------------------------------------------------------

Maintenance costs historical analysis
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data =============================================

use "${rore}/bld/data_out/rore_core_dataset.dta", clear

*======================= Auxillary variables ========================================

* Cost-to-rent ratios
* % RORE yields
gen bs_allcosts_pctyd = bs_allcosts_pct/(housing_rent_yd + bs_allcosts_pct)
gen bs_allcosts_pctbsyd = bs_allcosts_pct/bs_rent_pct

* Country-specific cost series
local vars bs_allcosts_pct bs_allcosts_pctyd bs_allcosts_pctbsyd
local countries AUS FRA GBR USA
local cnames Australia France UK US
local cnum : word count `countries'
foreach v of local vars	{
	forvalues i = 1/`cnum'	{
		local c : word `i' of `countries'
		local cn : word `i' of `cnames'
		* Scale to percent
		gen `v'_`c' = `v'*100 if iso == "`c'"
		* Australia: note that data before 1948 are a rough proxy and should be treated with caution
		label var `v'_`c' "`cn'"
	}
}

*======================= Graph settings ============================================
local start1 = 1910
local size medsmall
local size2 medium
local size3 medsmall

* Colours & symbols for each country (alphabetical: Australia, France, UK, US)
local colours dkblue brown green red
local symbols d x t o
* Marker size
local msize small
* Series to plot
local series bs_allcosts_pct bs_allcosts_pctyd
* Scales
local scales ""0(0.5)3" "0(10)50""
* Titles
local titles ""Proportion of Housing Value, per cent" "Proportion of Gross Rent, per cent""
* Legends
local legends ""on" "off"
local ns : word count `series'
*======================= Maintenance cost graphs ====================================

forvalues i = 1/`ns'	{
	local s : word `i' of `series'
	local scale : word `i' of `scales'
	local t : word `i' of `titles'
	local leg : word `i' of `legends'
	
	twoway (tsline `s'_AUS `s'_FRA `s'_GBR `s'_USA if year>=`start1', ///
		recast(connected) lpattern(shortdash shortdash shortdash) lcolor(`colours') msymbol(`symbols') ///
		mcolor(`colours') msize(`msize' `msize' `msize' `msize')), ///
		scheme(s1color) legend(size(`size3') cols(2) region(lwidth(none)) ring(0) position(5) color(none) symxsize(*0.7) `leg') ///
		xlabel(`start1'(20)2015,labsize(`size')) ///
		ylabel(`scale', labsize(`size')) xtitle("") ytitle("") title("`t'", size(`size2')) ///
		tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
		name(`s',replace) nodraw
}

graph combine `series', cols(2) scheme(s1color) scale(1.3)  xsize(8)
graph export "${rore}/bld/graphs/accuracy/maintenance_costs.pdf", replace
graph export "${qje_figures}/Figure_03.pdf", replace
window manage close graph
