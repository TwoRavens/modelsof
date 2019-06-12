/*--------------------------------------------------------------

Balance sheet approach vs our estimates
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data ==============================================

use "${rore}/bld/data_out/rore_core_dataset.dta", clear

*======================= Auxillary variables ======================================

* Convert yields to percent
local toscale housing_rent_yd bs_netrent_pct i_bs_netrent_pct bs_rent_pct
foreach s of local toscale	{
	replace `s' = `s'*100
	
	* Absolute change
	gen d_`s' = d.`s'
	
	* Aus temp fix
	*replace `s'=. if iso=="AUS" & year==1950
}

*======================= Graph settings ===========================================
local start1 = 1890
local size small
local size2 medsmall
local size3 vsmall
local size4 medium

* Countries
local countries AUS FRA GBR SWE USA DNK ITA JPN DEU
local cnames Australia France UK Sweden USA Denmark Italy Japan Germany
local cnum : word count `countries'
* Scale for each country
local scales ""0(2)8" "0(2)8" "0(3)12" "0(3)12" "0(2)10" "0(3)12" "0(2)8" "0(2)8""
* Start for each country
local xscales ""1900(20)2000" "1890(20)2010" "1900(20)2000" "1930(20)2010" "1930(20)2010" "1960(10)2010" "1960(10)2010" "1930(10)2010" "1870(20)2010""
* Colours & symbols
local colours dkblue brown
local symbols d t
* Marker size
local msize vsmall
* Line width
local lw medthin

*======================= Sample settings ===========================================

* Only use countries with a reasonably long run of data; select these manually in the countries local above
gen samp_bs = 0
foreach c of local countries	{
	replace samp_bs = 1 if iso == "`c'"
}

*======================= BS approach graphs =======================================

* 45 degree line
gen yx_line = -10 in 1
replace yx_line = _n-11 if _n > 1

* 1/ Scatter plot of changes and yields xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
* Change in yield
twoway (scatter d_housing_rent_yd d_bs_netrent_pct if abs(d_housing_rent_yd) <2 & abs(d_bs_netrent_pct)<2 & samp_bs==1, ///
		msymbol(c) mcolor(black) msize(tiny)) ///
		(line yx_line yx_line if abs(yx_line)<2.1, sort lpattern(shortdash) lcolor(black) lw(medthin)), ///
		scheme(s1color) legend(off) ///
		ylabel(-2(1)2, labsize(`size')) xlabel(-2(1)2, labsize(`size')) ///
		ytitle("Change in rent-price yield", size(`size3')) ///
		xtitle("Change in balance-sheet yield", size(`size3')) ///
		title("Yield co-movement", size(`size')) ///
		name(scatter_changes,replace) nodraw

* Yield absolute value
twoway (scatter housing_rent_yd bs_netrent_pct if abs(housing_rent_yd) <15 & abs(bs_netrent_pct)<15  & samp_bs==1, ///
		msymbol(c) mcolor(black) msize(tiny)) ///
		(line yx_line yx_line if yx_line<15.1 & yx_line >=0, sort lpattern(shortdash) lcolor(black) lw(medthin)), ///
		scheme(s1color) legend(off) ///
		ylabel(0(3)15, labsize(`size')) xlabel(0(3)15, labsize(`size')) ///
		ytitle("Yield, rent-price", size(`size')) ///
		xtitle("Yield, balance sheet", size(`size')) ///
		title("Yield comparison", size(`size')) ///
		name(scatter_abs,replace) nodraw

* 2/ Time trends xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
* Loop over countries
* No interpolation
forvalues i = 1/`cnum'	{
	local c : word `i' of `countries'
	local cn : word `i' of `cnames'
	local scale : word `i' of `scales'
	local xscale : word `i' of `xscales'
	local start = substr("`xscale'",1,4)

* If start date before WW1, two gray lines
if `start' < 1919	{
	twoway (tsline housing_rent_yd bs_netrent_pct if year>=`start' & iso == "`c'", ///
		recast(connected) lpattern(shortdash shortdash) lcolor(`colours') lw(`lw' `lw') msymbol(`symbols') ///
		mcolor(`colours') msize(`msize' `msize')), ///
		scheme(s1color) legend(size(`size3') cols(2) label(1 "Rent-price approach") label(2 "Balance sheet approach") region(lwidth(none)) color(none) symxsize(*0.8)) ///
		xlabel(`xscale',labsize(`size')) ///
		ylabel(`scale', labsize(`size')) xtitle("") ytitle("") title("`cn'", size(`size')) ///
		tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
		name(`c',replace) nodraw
}	
* If start date after WW1, only one gray line
if `start' >= 1919	{
	twoway (tsline housing_rent_yd bs_netrent_pct if year>=`start' & iso == "`c'", ///
		recast(connected) lpattern(shortdash shortdash) lcolor(`colours') lw(`lw' `lw') msymbol(`symbols') ///
		mcolor(`colours') msize(`msize' `msize')), ///
		scheme(s1color) legend(size(`size3') cols(2) label(1 "Rent-price approach") label(2 "Balance sheet approach") region(lwidth(none)) color(none) symxsize(*0.7)) ///
		xlabel(`xscale',labsize(`size')) ///
		ylabel(`scale', labsize(`size')) xtitle("") ytitle("") title("`cn'", size(`size')) ///
		tline(1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
		name(`c',replace) nodraw	
}
* If start date after WW2, no gray lines
if `start' >= 1945	{
	twoway (tsline housing_rent_yd bs_netrent_pct if year>=`start' & iso == "`c'", ///
		recast(connected) lpattern(shortdash shortdash) lcolor(`colours') lw(`lw' `lw') msymbol(`symbols') ///
		mcolor(`colours') msize(`msize' `msize')), ///
		scheme(s1color) legend(size(`size3') cols(2) label(1 "Rent-price approach") label(2 "Balance sheet approach") region(lwidth(none)) color(none) symxsize(*0.7)) ///
		xlabel(`xscale',labsize(`size')) ///
		ylabel(`scale', labsize(`size')) xtitle("") ytitle("") title("`cn'", size(`size')) ///
		name(`c',replace) nodraw
}

* Export graphs for presentation
if "`c'" == "USA" | "`c'" == "SWE"	{
	twoway (tsline housing_rent_yd bs_netrent_pct if year>=`start' & iso == "`c'", ///
		recast(connected) lpattern(shortdash shortdash) lcolor(`colours') lw(`lw' `lw') msymbol(`symbols') ///
		mcolor(`colours') msize(`msize' `msize')), ///
		scheme(s1color) legend(size(`size4') cols(2) label(1 "Rent-price approach") label(2 "Balance sheet approach") region(lwidth(none)) color(none) symxsize(*0.5)) ///
		xlabel(`xscale',labsize(`size')) ///
		ylabel(`scale', labsize(`size')) xtitle("") ytitle("Per cent",size(`size')) title("`cn'", size(`size')) ///
		tline(1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
		name(`c'_pres,replace) nodraw
		graph display `c'_pres, ysize(5) scale(1.5)
	graph export "${rore}/bld/graphs/accuracy/bycountry/bs_approach_`c'_pres.pdf", replace
	graph close
}
}

* Graph for paper
grc1leg FRA SWE USA scatter_changes, cols(2) legendfrom(FRA) scheme(s1color) iscale(*1.05) ///
	name(bs_approach_summary, replace)

graph display bs_approach_summary, xsize(20) ysize(18)
graph export "${rore}/bld/graphs/accuracy/bs_approach_comparison.pdf", replace
graph export "${qje_figures}/Figure_04.pdf", replace
graph close

* Graph for presentation
grc1leg USA_pres SWE_pres, cols(2) legendfrom(USA_pres) scheme(s1color) iscale(*1.2) ///
	name(bs_approach_usaswe, replace)
graph display bs_approach_usaswe, xsize(20) ysize(10)
graph export "${rore}/bld/graphs/accuracy/bycountry/bs_approach_usaswe.pdf", replace
graph close


