/*--------------------------------------------------------------

Check French housing trust returns vs overall index
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data =============================================

import excel using "${rore}/src/raw_data/excel/fourmi_immobiliere.xlsx", clear

drop A
keep if _n > 5
local vars dp tr
ren (B C D) (year `vars')
destring `vars', replace
foreach v of local vars	{
	replace `v' = `v'/100
	ren `v' fourmi_`v'
}

gen iso = "FRA"

merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "FRA"
sort year
tsset year, yearly

gen r_fourmi_tr = (1+fourmi_tr)/(1 + inflation)-1



* 1/ Choose variables to sum ------------------------------------------------------
* Presentation table, and corresponding labels
*	- arithmetic and geo. means
local tosum_prestable r_fourmi_tr r_housing_tr r_eq_tr fourmi_tr housing_tr eq_tr
local labs_prestable ""Fourmi imm."  "Housing"  "Equities"  "Fourmi imm."  "Housing"  "Equities""

local npres : word count `tosum_prestable'

* Sample adjustment
replace sample = 1
foreach v of local tosum_prestable	{
	replace sample = 0 if `v' ==.
}



*========================== Transform variables =============================================

local allrtns `tosum_prestable'

* Returns to percent; calcualte gross returns
foreach s of local allrtns	{
	* Gross return
	gen gr_`s' = 1+`s'
	* Convert net return to percent
	replace `s' = `s'*100
}


*========================= Graphs =============================================

* Filtering
local toav r_eq_tr r_housing_tr r_fourmi_tr
local labs ""French Equity" "French Housing" "La Fourmi immobiliere""
local nvar : word count `toav'

su year if sample == 1
local min = r(min) + 4
local max = r(max) - 4

forvalues i = 1/`nvar'		{
	* Extract variable names and labels
	local s`i' : word `i' of `toav'
	local l`i' : word `i' of `labs'
	tssmooth ma madec_`s`i'' = `s`i'', window(5,1,5)
	label var madec_`s`i'' "`l`i'': decadal moving average"
	* Only keep if enough observations
	replace madec_`s`i'' = . if year <= `min'
	replace madec_`s`i'' = . if year >= `max'
}

* Graph

* settings
local size medium
local size2 medlarge

	
* Graph pre-merger; ending in 1985
twoway (tsline madec_r_housing_tr madec_r_fourmi_tr if year>=`min' & year <= 1980, ///
		yline(0, lcolor(gs8) lpattern(shortdash)) recast(connected) lpattern(dash solid) lcolor(green red) ///
		mcolor(green red) msize(small small) msymbol(x none)), ///
		scheme(s1color) legend(size(`size') order(2 1) cols(1) region(lwidth(none))) xlabel(1910(10)1980) ///
		ylabel(, labsize(`size')) xtitle("") ytitle("Per cent", size(`size')) title("") ///
		tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vvthick)) ///
		name(fourmi_filter,replace)
	graph export "${rore}/bld/graphs/accuracy/fourmi_immobiliere_pres.pdf", replace
	graph close

* Graph pre-merger w title, for combining
twoway (tsline madec_r_housing_tr madec_r_fourmi_tr if year>=`min' & year <= 1980, ///
		yline(0, lcolor(gs8) lpattern(shortdash)) recast(connected) lpattern(dash solid) lcolor(green red) ///
		mcolor(green red) msize(small small) msymbol(x none)), ///
		scheme(s1color) legend(size(`size') order(2 1) cols(1) symxsize(*0.8) region(lwidth(none))) xlabel(1910(10)1980) ///
		ylabel(, labsize(`size')) xtitle("") ytitle("Per cent", size(`size')) title("France", size(`size2')) ///
		tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vvthick)) ///
		name(fourmi_filter_title,replace) nodraw


