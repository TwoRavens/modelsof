/*--------------------------------------------------------------

This file plots correlations in asset returns
across assets and countries
----------------------------------------------------------------*/ 


clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*========================== Import data =============================================

use "${rore}/bld/data_out/correlations_crosscountry.dta", clear
gen iso = "WORLD"

merge 1:1 iso year using "${rore}/bld/data_out/correlations.dta", gen(_merge1)

*========================== Settings =============================================

* Re-label
local vars correl_c_av_bond_inf correl_c_av_bill_inf correl_c_av_hous_inf correl_c_av_eq_inf ///
	correl_c_av_risky_inf correl_c_av_safe_inf correl_r_bond_tr correl_r_bill_rate correl_r_eq_tr ///
	correl_r_housing_tr correl_r_safe_tr correl_r_risky_tr correl_risk_premium
local labs ""Bonds (nom.)" "Bills (nominal)" "Housing (nominal)" "Equity (nom.)" "Risky r (nom.)" "Safe r (nom.)" "Bonds (real)" "Bills (real)" "Equity (real)" "Housing (real)" "Safe r (real)" "Risky r (real)" "Risk premium""
	
local nl : word count `vars'

forvalues j = 1/`nl'	{
	local v : word `j' of `vars'
	local l : word `j' of `labs'
	label var `v' "`l'"
}

* One-series
local tograph_single ""bond_bill" "eq_hous" "risky_safe" "bond_eq" "bond_hous"" 
local titles_single ""Bonds vs Bills" "Equity vs Housing" "Risky vs Safe" "Equity vs Bonds" "Housing vs Bonds""
local scales_single ""0(0.2)1" "0(0.2)0.6" "-0.4(0.2)0.6""

local nsing : word count `tograph_single'

* Two-series
local tograph_double ""bond_inf bill_inf" "eq_inf hous_inf" "risky_inf safe_inf""
local double_legend ""Bonds Bills" "Equity Housing" ""Risky return" "Safe return"""
local titles_double ""Comovement with inflation" "Comovement with inflation" "Comovement with inflation""

local ndoub : word count `tograph_double'

* Cross-country
local tograph_cross ""r_bond_tr r_bill_rate" "r_eq_tr r_housing_tr" "r_risky_tr r_safe_tr""
local cross_legend ""Bonds Bills" "Equity Housing" ""Risky return" "Safe return"""
local titles_cross ""Cross-country comovement" "Cross-country comovement" "Cross-country returns""

local ncross : word count `tograph_cross'

* Risk premium do separately (cross-country single series)

* Graph settings

local start1 = 1870
local size small
local size2 medsmall
local size3 small

*========================== Graphs =============================================

* Single series
forvalues i = 1/`nsing'	{
	* Load settings
	* What to graph
	local g`i' : word `i' of `tograph_single'
	* Titles etc
	local t`i' : word `i' of `titles_single'
	* Scale
	local s`i' : word `i' of `scales_single'
	
	* Graphs: world
	twoway (tsline correl_c_av_`g`i'' if year>=`start1' & iso == "WORLD", ///
		recast(connected) lpattern(dash) lcolor(dkblue) msymbol(o + t) ///
		yline(0, lcolor(gs8) lpattern(shortdash)) ///
		mcolor(dkblue) msize(small)), ///
		scheme(s1color) ///
		xlabel(`start1'(20)2015,labsize(`size')) ///
		ylabel(`s`i'', labsize(`size')) xtitle("") ytitle("") title("`t`i''", size(`size2')) ///
		tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) nodraw ///
		name(world_single_`g`i'',replace)
}
	
* Double series
forvalues i = 1/`ndoub'	{
	* Load settings
	* What to graph
	local g`i' : word `i' of `tograph_double'
	local g1`i' : word 1 of `g`i''
	local g2`i' : word 2 of `g`i''
	* Titles etc
	local t`i' : word `i' of `titles_double'
	* Scale
	*local s`i' : word `i' of `scales_double'
	
	* Graphs: world
	twoway (tsline correl_c_av_`g1`i'' correl_c_av_`g2`i'' if year>=`start1' & iso == "WORLD", ///
		recast(connected) lpattern(dash dash) lcolor(dkblue red) msymbol(o t) ///
		yline(0, lcolor(gs8) lpattern(shortdash)) ///
		mcolor(dkblue red) msize(small small)), ///
		scheme(s1color) legend(size(`size3') rows(1) region(lwidth(none))) ///
		xlabel(`start1'(20)2015,labsize(`size')) ///
		ylabel(, labsize(`size')) xtitle("") ytitle("") title("`t`i''", size(`size2')) ///
		tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) nodraw ///
		name(world_double_`g1`i'',replace)
}
	
* Double series: cross-country
forvalues i = 1/`ncross'	{
	* Load settings
	* What to graph
	local g`i' : word `i' of `tograph_cross'
	local g1`i' : word 1 of `g`i''
	local g2`i' : word 2 of `g`i''
	* Titles etc
	local t`i' : word `i' of `titles_cross'
	* Scale
	*local s`i' : word `i' of `scales_double'
	
	* Graphs: world
	twoway (tsline correl_`g1`i'' correl_`g2`i'' if year>=`start1' & iso == "WORLD", ///
		recast(connected) lpattern(dash dash) lcolor(dkgreen brown) msymbol(x +) ///
		yline(0, lcolor(gs8) lpattern(shortdash)) ///
		mcolor(dkgreen brown) msize(small small)), ///
		scheme(s1color) legend(size(`size3') rows(1) region(lwidth(none))) ///
		xlabel(`start1'(20)2015,labsize(`size')) ///
		ylabel(, labsize(`size')) xtitle("") ytitle("") title("`t`i''", size(`size2')) ///
		tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) nodraw ///
		name(world_cross_`g1`i'',replace)
}


* Risk premium cross-country
twoway (tsline correl_risk_premium if year>=`start1' & iso == "WORLD", ///
	recast(connected) lpattern(dash) lcolor(red) msymbol(x) ///
	yline(0, lcolor(gs8) lpattern(shortdash)) ///
	mcolor(red) msize(small)), ///
	scheme(s1color) legend(size(`size3') on rows(1) region(lwidth(none))) ///
	xlabel(`start1'(20)2015,labsize(`size')) ///
	ylabel(-0.3(0.3)0.9, labsize(`size')) xtitle("") ytitle("") title("Cross-country risk", size(`size2')) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) nodraw ///
	name(world_cross_risk_premium,replace)

* Combine graphs for paper

* Safe
graph combine world_single_bond_bill world_double_bond_inf world_cross_r_bond_tr, ///
	cols(2) scheme(s1color) ysize(5)
graph export "${rore}/bld/graphs/correlations/safe_combined_correls.pdf", replace
graph export "${qje_figures}/Figure_11.pdf", replace
graph close

* Risky
graph combine world_single_eq_hous world_double_eq_inf world_cross_r_eq_tr, ///
	cols(2) scheme(s1color) ysize(5)
graph export "${rore}/bld/graphs/correlations/risky_combined_correls.pdf", replace
graph export "${qje_figures}/Figure_08.pdf", replace
graph close
	
* Risky vs safe
graph combine world_single_risky_safe world_double_risky_inf world_cross_r_risky_tr world_cross_risk_premium, ///
	cols(2) scheme(s1color) ysize(5)
graph export "${rore}/bld/graphs/correlations/riskysafe_combined_correls.pdf", replace
graph export "${qje_figures}/Figure_14.pdf", replace
graph close
