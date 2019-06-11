/*--------------------------------------------------------------

Calculation and chart of the following rates:
r - g: global return on wealth and growth
risky and safe returns
----------------------------------------------------------------*/ 


clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths

*======================= Calculate world rates of return =======================================

* Variables to collapse into world returns
local toav r_capital_tr r_capital_tr_simple r_risky_tr r_safe_tr rgdp_growth r_bill_rate r_bond_tr r_eq_tr r_housing_tr bond_tr bill_rate eq_tr housing_tr inflation risk_premium excess_eq_tr excess_housing_tr risky_tr safe_tr capital_tr
local labs ""Real return on wealth" "Return on wealth, simple weights" "Real risky return" "Real safe return" "Real GDP growth" "Real bill rate" "Real bond return" "Real equity return" "Real housing return" "Bond return (nominal)" "Bill rate (nominal)" "Equity return (nominal)" "Housing return (nominal)" "Inflation" "Risk premium" "Equity premium (over bills)" "Housing premium (over bills)" "Risky return, nominal" "Safe return, nominal" "Return on wealth, nominal""
local nvar : word count `toav'


* I. Import data
use "${rore}/bld/data_out/rore_core_dataset.dta", clear

* Within-graph consistent sample
	* r and g
	replace r_capital_tr = . if rgdp_growth ==.
	replace rgdp_growth =. if r_capital_tr ==.
	
	* risky and safe
	replace r_risky_tr = . if r_safe_tr ==.
	replace r_safe_tr =. if r_risky_tr ==.
	
	* equity and housing
	replace r_eq_tr = . if r_housing_tr ==.
	replace r_housing_tr =. if r_eq_tr ==.
	
	* bonds and bills
	replace r_bill_rate = . if r_bond_tr ==.
	replace r_bond_tr = . if r_bill_rate ==.
	

* II. Calculate weighted world averages
collapse (mean) `toav' [iw = weight], by(year)
	
* III. Generate iso for world returns
gen iso = "WORLD"
gen country = "World"


* IV. Merge and save
merge 1:1 iso country year using "${rore}/bld/data_out/rore_core_dataset.dta", gen(_merge`j')

save "${rore}/bld/data_out/r_minus_g.dta", replace


* Rescale
foreach s of local toav	{
	replace `s' = `s'*100
}

* Tidy
keep iso country year `toav' sample

encode country, generate(ccode)

* Interim save -----------------------------------------------------------------------
save "${rore}/bld/data_out/r_minus_g.dta", replace



*============================== Filtering ===========================================

* 1/ World broad trends -----------------------------------------------------------------

keep if iso == "WORLD"
xtset ccode year


* 1-1/ Smoothing ----------------------------------------------------------------------

forvalues i = 1/`nvar'		{
	* Extract variable names and labels
	local s`i' : word `i' of `toav'
	local l`i' : word `i' of `labs'
	
	* Decadal moving averages
	tssmooth ma madec_`s`i'' = `s`i'', window(5,1,5)
	label var madec_`s`i'' "`l`i'': decadal moving average"
	* Only keep if enough observations
	replace madec_`s`i'' = . if year <= 1874
	replace madec_`s`i'' = . if year >= 2011
	
	* Decadal averages
	gen dec_`s`i'' = .
	local step 10
	local z = floor((2015-1870)/`step')
		
	forvalues k = 0(1)`z'	{
		local bottom = 1870 + `k'*`step'
		local top = 1870 + (`k' + 1)*`step'
		local mid = `top' - round(`step'/2)
				
		* Calculate decadal averages
		su `s`i'' if tin(`bottom',`top')
		replace dec_`s`i'' = r(mean) if year ==`mid'		
	}
	
	* HP filter, two-sided
	hprescott `s`i'', stub(HP2) smooth(1000)
	ren HP2_`s`i''_sm_1 hp_trend_`s`i''
	ren HP2_`s`i''_1 hp_shock_`s`i''
	label var hp_trend_`s`i'' "`l`i'': HP-filtered trend (2-sided)"
	label var hp_shock_`s`i'' "`l`i'' : HP-filtered stochastic component (2-sided)"
	
	* Bandpass Filter (Baxter-King)
	tsfilter bk bp_cyc_`s`i'' = `s`i'', minperiod(12) maxperiod(150) stationary trend(bp_trend_`s`i'')
			
	* Save filtered series before adding back average of stochastic trend
	gen bp_cyc_2_`s`i'' = bp_cyc_`s`i''
			
	* Final filtered series: take cyclical component + average of stochastic trend
	qui su bp_trend_`s`i''
	replace bp_trend_`s`i'' = bp_trend_`s`i'' - r(mean)
	replace bp_cyc_`s`i'' = bp_cyc_`s`i'' + r(mean)
	
			
	label var bp_cyc_`s`i'' "`l`i''. Bandpass filter cyclical (12 -- 150 year frequency)"
	label var bp_trend_`s`i'' "`l`i''. Bandpass filter stochastic trend (12 -- 150 year frequency)"
	

}

* Risk premium and r-g derived from the risky and safe return series
local filters madec hp_trend bp_cyc
local labs ""Decadal moving average" "HP-filtered" "Bandpass-filtered""
local nfil : word count `filters'

forvalues i = 1/`nfil'	{
	local f`i' : word `i' of `filters'
	local l`i' : word `i' of `labs'
	gen `f`i''_resid_risk_premium = `f`i''_r_risky_tr - `f`i''_r_safe_tr
	label var `f`i''_resid_risk_premium "Risk premium. `l`i''"
	gen `f`i''_r_g_gap = `f`i''_r_capital_tr - `f`i''_rgdp_growth
	label var `f`i''_r_g_gap "r - g gap. `l`i''"
	gen `f`i''_rs_g_gap = `f`i''_r_safe_tr - `f`i''_rgdp_growth
	label var `f`i''_rs_g_gap "r{subscript:safe} - g gap. `l`i''"
}

save "${rore}/bld/data_out/r_minus_g_world_filtered.dta", replace

*============================== Graphs: paper ===========================================

* 1/ Charts: two-lined ----------------------------------------------------------------------
* Start dates:
local start1 = 1870

* Loop over pairs of variables to plot, and filter types
* Choose type of averaging
local type madec
* Choose pairs of variables
local series ""r_capital_tr rgdp_growth" "r_risky_tr r_safe_tr" "r_safe_tr rgdp_growth" "r_bill_rate r_bond_tr" "r_eq_tr r_housing_tr""
* Graph labels
local plotname ""global_rg_weight" "global_sr_weight" "global_rsg_weight" "global_bondbill_weight" "global_eqhous_weight""
local plotname_qje """ "" "Figure_12" "Figure_10" "Figure_07""
local plottitle ""Return on wealth and growth" "Risky and Safe returns" "Safe returns and growth""
local ylab ""-2(2)10" "-6(3)12" "-6(2)8" "-6(3)9" "-4(4)16" """
local pnum : word count `series'

* Legend font size
local size medsmall
local size2 medlarge
local size3 large
local size4 medium

forvalues i = 1/`pnum'	{
	* Load plot characteristics
	local p`i' : word `i' of `series'
	local s1`i' : word 1 of `p`i''
	local s2`i' : word 2 of `p`i''
	local pl`i' : word `i' of `plotname'
	local yl`i' : word `i' of `ylab'
	local tl`i' : word `i' of `plottitle'
	local pl_qje`i' : word `i' of `plotname_qje'
	
	* plot chart
	twoway (tsline `type'_`s1`i'' `type'_`s2`i'' if year>=`start1', ///
			lpattern(dash) lcolor(dkblue green) ///
			yline(0, lcolor(gs8) lpattern(shortdash)) lpattern(dash solid) lcolor(dkblue green) ///
			mcolor(dkblue green) msize(small small)), ///
			scheme(s1color) legend(size(`size') order(1 2) cols(1) region(lwidth(none))) xlabel(`start1'(20)2015, labsize(`size')) ///
			ylabel(`yl`i'', labsize(`size')) xtitle("") ytitle("Per cent", size(`size')) title("") ///
			tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
			name(`pl`i'',replace)
			graph export "${rore}/bld/graphs/world/time_trends/png/`pl`i''.png", width(2000) height(1500) replace
			* Normal
			graph export "${rore}/bld/graphs/world/time_trends/`pl`i''.pdf", replace
			if "`pl_qje`i''" != ""	{
				graph export "${qje_figures}/`pl_qje`i''.pdf", replace

			}
			* Wide - for wide presentation
			graph display `pl`i'', xsize(20) ysize(13)
			graph export "${rore}/bld/graphs/world/time_trends/wide/`pl`i''.pdf", replace
			window manage close graph
			
		* Risky vs safe with title, for combined graph
	if  `i' <=3	{
	twoway (tsline `type'_`s1`i'' `type'_`s2`i'' if year>=`start1', ///
			lpattern(dash) lcolor(dkblue green) ///
			yline(0, lcolor(gs8) lpattern(shortdash)) lpattern(dash solid) lcolor(dkblue green) ///
			mcolor(dkblue green) msize(small small)), ///
			scheme(s1color) legend(size(`size2') order(1 2) cols(1) region(lwidth(none))) xlabel(`start1'(20)2015, labsize(`size2')) ///
			ylabel(`yl`i'', labsize(`size2')) xtitle("") ytitle("Per cent", size(`size2')) ///
			title("`tl`i''", size(`size3')) ///
			tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
			name(`pl`i''_title,replace) nodraw
	}
}

* 2/ Single-lined charts ----------------------------------------------------------------------
local series_single  "resid_risk_premium r_g_gap rs_g_gap"
local singname  "global_riskpr_weight global_r_g_gap global_rs_g_gap"
local singtitles ""Risk Premium" "r minus g" "Safe return minus growth""
local singylab "0(2)14"
local spnum : word count `series_single'

forvalues i = 1/`spnum'	{
	* Load plot characteristics
	local p`i' : word `i' of `series_single'
	local pl`i' : word `i' of `singname'
	local yl`i' : word `i' of `singylab'
	local tl`i' : word `i' of `singtitles'
	
	* plot chart
	twoway (tsline `type'_`p`i'' if year>=`start1', ///
			lpattern(dash) lcolor(dkblue green) ///
			yline(0, lcolor(gs8) lpattern(shortdash)) lpattern(solid) lcolor(red) ///
			mcolor(dkblue green) msize(small small)), ///
			scheme(s1color) legend(size(`size2') cols(1) on region(lwidth(none))) xlabel(`start1'(20)2015, labsize(`size2')) ///
			ylabel(`yl`i'', labsize(`size2')) xtitle("") ytitle("Per cent", size(`size2')) ///
			title("`tl`i''", size(`size3')) ///
			tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
			name(`pl`i'',replace)
			graph export "${rore}/bld/graphs/world/time_trends/png/`pl`i''.png",  width(2000) height(1500) replace
			graph export "${rore}/bld/graphs/world/time_trends/`pl`i''.pdf", replace
			* Wide - for wide presentation
			graph display `pl`i'', xsize(20) ysize(13)
			graph export "${rore}/bld/graphs/world/time_trends/wide/`pl`i''.pdf", replace
			window manage close graph
}

* Combine risk premium and risky vs safe
graph combine global_sr_weight_title global_riskpr_weight, cols(2) xsize(8) scheme(s1color)
graph export "${rore}/bld/graphs/world/time_trends/png/global_sr_and_premium_weight.png", width(2000) height(1000) replace
graph export "${rore}/bld/graphs/world/time_trends/global_sr_and_premium_weight.pdf", replace
graph export "${qje_figures}/Figure_13.pdf", replace
graph close

* Combine r and g and r-g
graph combine global_rg_weight_title global_r_g_gap, cols(2) xsize(8) scheme(s1color)
graph export "${rore}/bld/graphs/world/time_trends/png/global_rg_and_gap_weight.png", width(2000) height(1000) replace
graph export "${rore}/bld/graphs/world/time_trends/global_rg_and_gap_weight.pdf", replace
graph export "${qje_figures}/Figure_15.pdf", replace
graph close

* Combine r safe and g and r-g
graph combine global_rsg_weight_title global_rs_g_gap, cols(2) xsize(8) scheme(s1color)
*graph export "${rore}/bld/graphs/world/time_trends/png/global_rg_and_gap_weight.png", width(2000) height(1000) replace
graph export "${rore}/bld/graphs/world/time_trends/global_rsg_and_gap_weight.pdf", replace
graph close

*============================== Graphs: presentation ===========================================
* Charts for presentation: smaller labels, resize
* Relabel
local series_relab "r_capital_tr rgdp_growth r_risky_tr r_safe_tr resid_risk_premium r_g_gap"
local new_labs ""Weighted return on wealth" "Real GDP growth" "Real risky return" "Real safe return" "Risk premium" "r - g gap""
local new_lab_num : word count `series_relab'
forvalues i=1/`new_lab_num'	{
	local s`i' : word `i' of `series_relab'
	local l`i' : word `i' of `new_labs'
	label var madec_`s`i'' "`l`i''"
}

* Select which graphs to replot
local presnum = 2

* Graphs
* 1/ Two-lined
forvalues i = 1/`presnum'	{
	* Load plot characteristics
	local p`i' : word `i' of `series'
	local s1`i' : word 1 of `p`i''
	local s2`i' : word 2 of `p`i''
	local pl`i' : word `i' of `plotname'
	local yl`i' : word `i' of `ylab'
	local tl`i' : word `i' of `plottitle'
	
	* plot chart
	twoway (tsline `type'_`s1`i'' `type'_`s2`i'' if year>=`start1', ///
			lpattern(dash) lcolor(dkblue green) ///
			yline(0, lcolor(gs8) lpattern(shortdash)) lpattern(dash solid) lcolor(dkblue green) ///
			mcolor(dkblue green) msize(small small)), ///
			scheme(s1color) legend(size(`size4') order(1 2) cols(1) region(lwidth(none))) xlabel(`start1'(20)2015, labsize(`size4')) ///
			ylabel(`yl`i'', labsize(`size4')) xtitle("") ytitle("Per cent", size(`size4')) title("") ///
			tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
			name(`pl`i''_pres,replace)
			graph export "${rore}/bld/graphs/world/time_trends/png/`pl`i''_pres.png", width(2000) height(1500) replace
			graph export "${rore}/bld/graphs/world/time_trends/`pl`i''_pres.pdf", replace
			* Wide - for wide presentation
			graph display `pl`i''_pres, xsize(20) ysize(13)
			graph export "${rore}/bld/graphs/world/time_trends/wide/`pl`i''_pres.pdf", replace
			window manage close graph
			
		* Risky vs safe with title, for combined graph
	if  `i' <=2	{
	twoway (tsline `type'_`s1`i'' `type'_`s2`i'' if year>=`start1', ///
			lpattern(dash) lcolor(dkblue green) ///
			yline(0, lcolor(gs8) lpattern(shortdash)) lpattern(dash solid) lcolor(dkblue green) ///
			mcolor(dkblue green) msize(small small)), ///
			scheme(s1color) legend(size(`size2') order(1 2) cols(1) region(lwidth(none))) xlabel(`start1'(20)2015, labsize(`size2')) ///
			ylabel(`yl`i'', labsize(`size2')) xtitle("") ytitle("Per cent", size(`size2')) ///
			title("`tl`i''", size(`size3')) ///
			tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
			name(`pl`i''_title_pres,replace) nodraw
	}
}

* 2/ Single-lined
forvalues i = 1/`spnum'	{
	* Load plot characteristics
	local p`i' : word `i' of `series_single'
	local pl`i' : word `i' of `singname'
	local yl`i' : word `i' of `singylab'
	local tl`i' : word `i' of `singtitles'
	
	* plot chart
	twoway (tsline `type'_`p`i'' if year>=`start1', ///
			lpattern(dash) lcolor(dkblue green) ///
			yline(0, lcolor(gs8) lpattern(shortdash)) lpattern(solid) lcolor(red) ///
			mcolor(dkblue green) msize(small small)), ///
			scheme(s1color) legend(size(`size2') cols(1) on region(lwidth(none))) xlabel(`start1'(20)2015, labsize(`size2')) ///
			ylabel(`yl`i'', labsize(`size2')) xtitle("") ytitle("Per cent", size(`size2')) ///
			title("`tl`i''", size(`size3')) ///
			tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
			name(`pl`i''_pres,replace) nodraw
}

* Combined graphs
* Risky vs safe and risk premium
graph combine global_sr_weight_title_pres global_riskpr_weight_pres, cols(2) xsize(8) scheme(s1color)
graph export "${rore}/bld/graphs/world/time_trends/png/global_sr_and_premium_weight_pres.png", width(2000) height(1000) replace
graph export "${rore}/bld/graphs/world/time_trends/global_sr_and_premium_weight_pres.pdf", replace
graph close


* Combine r and g and r-g
graph combine global_rg_weight_title_pres global_r_g_gap_pres, cols(2) xsize(8) scheme(s1color)
graph export "${rore}/bld/graphs/world/time_trends/png/global_rg_and_gap_weight_pres.png", width(2000) height(1000) replace
graph export "${rore}/bld/graphs/world/time_trends/global_rg_and_gap_weight_pres.pdf", replace


graph close
