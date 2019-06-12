/*--------------------------------------------------------------

Check US REIT / property funds returns vs housing
----------------------------------------------------------------*/ 

set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data =============================================

use "${rore}/bld/data_out/reits.dta", clear

*======================= Data manipulations ======================================

* Use RORE years
drop if year > 2015

* Which REIT returns to use
local rreits reit_tr NAREIT_res_tr NAREIT_eq_tr

* Unlevered REITs TRs; assume 45% leverage following Giaccomi et al (2014)
foreach r of local rreits	{
	gen nolev_`r' = `r'/1.45
}
*======================= Combine w RORE/smooth ===================================

merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", keepusing(housing* r_housing* inflation eq* r_eq*)

keep if iso == "USA"
tsset year, yearly

foreach r of local rreits	{
	gen r_`r' = (1+`r')/(1 + inflation)-1
	gen r_nolev_`r' = (1+nolev_`r')/(1 + inflation)-1
}

* Smoothing: full-sample variables
local toav reit_tr nolev_reit_tr NAREIT_eq_tr nolev_NAREIT_eq_tr housing_tr eq_tr
local labs ""US REITs" "US REITs, unlevered" "NAREIT equity" "NAREIT equity, unlevered"  "US Housing" "US Equity""
local nvar : word count `toav'

* Sample: if have REIT data
gen sample = 1 if reit_tr !=.

su year if sample == 1
local min = r(min) + 2
local max = r(max) - 2

forvalues i = 1/`nvar'		{
	* Extract variable names and labels
	local s`i' : word `i' of `toav'
	local l`i' : word `i' of `labs'
	
	* Scale to percent
	replace `s`i'' = `s`i''*100
	
	tssmooth ma madec_`s`i'' = `s`i'', window(2,1,2)
	tssmooth ma madec_r_`s`i'' = `s`i'', window(2,1,2)
	label var madec_`s`i'' "`l`i'': 5-year moving average"
	label var madec_r_`s`i'' "`l`i'': 5-year moving average"
	* Only keep if enough observations
	replace madec_`s`i'' = . if year <= `min'
	replace madec_r_`s`i'' = . if year <= `min'
	replace madec_`s`i'' = . if year >= `max'
	replace madec_r_`s`i'' = . if year >= `max'
}

* Smoothing: limited-sample variables
* For residential REIT, we only have a shorter time series
gen sample_short = 1 if NAREIT_res_tr !=.
local toav_short NAREIT_res_tr nolev_NAREIT_res_tr
local labs_short ""NAREIT residential" "NAREIT residential, unlevered""
local nvar_short : word count `toav_short'

su year if sample_short == 1
local min_short = r(min) + 2
local max_short = r(max) - 2

forvalues i = 1/`nvar_short'		{
	* Extract variable names and labels
	local s`i' : word `i' of `toav_short'
	local l`i' : word `i' of `labs_short'
	
	* Scale to percent
	replace `s`i'' = `s`i''*100
	
	tssmooth ma madec_`s`i'' = `s`i'', window(2,1,2)
	tssmooth ma madec_r_`s`i'' = `s`i'', window(2,1,2)
	label var madec_`s`i'' "`l`i'': 5-year moving average"
	label var madec_r_`s`i'' "`l`i'': 5-year moving average"
	* Only keep if enough observations
	replace madec_`s`i'' = . if year <= `min_short'
	replace madec_r_`s`i'' = . if year <= `min_short'
	replace madec_`s`i'' = . if year >= `max_short'
	replace madec_r_`s`i'' = . if year >= `max_short'
}


*======================= Graphs ===================================


* settings
local size medium
local size2 medlarge

* Graph for full time period
* No title: separately standing
twoway (tsline madec_r_housing_tr madec_r_nolev_reit_tr if year>=`min' & year <= `max', ///
		yline(0, lcolor(gs8) lpattern(shortdash)) recast(connected) lpattern(dash solid) lcolor(green red) ///
		mcolor(green red) msize(small small) msymbol(x none)), ///
		scheme(s1color) legend(size(`size') order(3 2 1) cols(1) region(lwidth(none))) xlabel(1975(10)2015) ///
		ylabel(, labsize(`size')) xtitle("") ytitle("Per cent", size(`size')) title("") ///
		name(usa_reit_filter,replace)
		
	graph export "${rore}/bld/graphs/accuracy/us_reits.pdf", replace
	window manage close graph

* Title: to combine with France
twoway (tsline madec_r_housing_tr madec_r_nolev_reit_tr if year>=`min' & year <= `max', ///
		yline(0, lcolor(gs8) lpattern(shortdash)) recast(connected) lpattern(dash solid) lcolor(green red) ///
		mcolor(green red) msize(small small) msymbol(x none)), ///
		scheme(s1color) legend(size(`size') order(3 2 1) cols(1) region(lwidth(none))) xlabel(1975(10)2015) ///
		ylabel(, labsize(`size')) xtitle("") ytitle("Per cent", size(`size')) title("USA") ///
		name(usa_reit_filter_title,replace) nodraw
		
