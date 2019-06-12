/*--------------------------------------------------------------

 Risk and return trade-off charts
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================


cd "${main_dir}"


include paths


*========================== Settings =============================================

* Variables
local vars r_eq_tr r_housing_tr eq_tr housing_tr bill_rate
local varlabs Equity Housing Equity Housing Bills
local vnum : word count `vars'

* Graph settings
local colour edkblue
local size large
local size2 vlarge


*========================== Import data =============================================
use "${rore}/bld/data_out/rore_core_dataset.dta", clear
* Sample
gen sample_excess = 1
foreach v of local vars	{
	replace sample_excess = 0 if `v' ==.
}



*======================= Construct variables =============================================

* 1/ Empty variables: returns, sd, returns per unit of risk xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
foreach v of local vars	{
	* Scale up
	replace `v' = `v'*100
	* Create empty variables for scatter plot
	gen `v'_mean =.
	gen `v'_sd =.
	gen `v'_var =.
	gen `v'_perunit =.
}

* 2/ Empty variables: sharpe ratios xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
gen eq_sharpe=.
gen housing_sharpe =.

* 3/ Means, sd etc xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
* Country loop
sum ccode
local cnum = r(max)

forvalues y = 1/`cnum' {

	* Calculate return and risk
	* Loop over variables
	forvalues i = 1/`vnum'	{
		* Load parameters
		local v : word `i' of `vars'
		local lab : word `i' of `varlabs'
		sum `v' if ccode==`y' & sample_excess == 1
		replace `v'_mean=r(mean) if ccode==`y'
		label var `v'_mean "`lab'"
		replace `v'_sd=r(sd) if ccode==`y'
		label var `v'_sd "`lab'"
		replace `v'_var=r(Var) if ccode==`y'
		label var `v'_var "`lab'"
		replace `v'_perunit = `v'_mean/`v'_sd if ccode==`y'
		label var `v'_perunit "`lab'"
	}
	* Sharpe ratio
	replace eq_sharpe = (eq_tr_mean-bill_rate_mean)/eq_tr_sd if ccode==`y'
	label var eq_sharpe "Equity"
	replace housing_sharpe = (housing_tr_mean-bill_rate_mean)/housing_tr_sd if ccode==`y'
	label var housing_sharpe "Housing"
	
}

*======================= Graphs =============================================

* Returns and sd scatter for paper
twoway (scatter r_eq_tr_mean r_eq_tr_sd, mlabel(iso) msymbol(circle) mlabsize(medlarge)) ///
		(scatter r_housing_tr_mean r_housing_tr_sd, mlabel(iso) msymbol(X) mlabsize(medlarge)), ///
		title("Return and Risk", size(`size2')) xtitle("Standard Deviation", size(`size')) ///
		xlabel(0(10)40, labsize(`size')) ylabel(0(3)12, labsize(`size')) ///
		ytitle("Mean annual return, per cent", size(`size')) ///
		scheme(s1color) legend(ring(0) position(5) size(`size')) ///
		name(eq_hous_r_and_sd, replace) nodraw

* Returns and sd scatter for the presentation: without title
twoway (scatter r_eq_tr_mean r_eq_tr_sd, mlabel(iso) msymbol(circle) mlabsize(medlarge)) ///
		(scatter r_housing_tr_mean r_housing_tr_sd, mlabel(iso) msymbol(X) mlabsize(medlarge)), ///
		title("", size(vlarge)) xtitle("Standard Deviation", size(large)) ///
		xlabel(0(10)40, labsize(`size')) ylabel(0(3)12, labsize(`size')) ///
		ytitle("Mean annual return, per cent", size(large)) ///
		scheme(s1color) legend(ring(0) position(5) size(large)) ///
		name(eq_hous_r_and_sd_pres, replace)
		graph export "${rore}/bld/graphs/byasset/png/eq_hous_r_and_sd_pres.png", width(2000) height(1500) replace
		graph export "${rore}/bld/graphs/byasset/eq_hous_r_and_sd_pres.pdf", replace
		window manage close graph
		
* Sharpe ratios
graph hbar eq_sharpe housing_sharpe, over(iso, sort(1) label(labsize(`size'))) ///
			title("Sharpe ratios", size(`size2')) ytitle("", size(`size')) ylabel(,labsize(`size')) scheme(s1color) ///
			ylabel(0(0.25)1.25, labsize(`size')) legend( order(1 "Equity" 2 "Housing") size(`size') ring(0) position(4) cols(1)) ///
			name(eq_hous_sharpe,replace)
		
* Return per unit of risk
graph hbar r_eq_tr_perunit r_housing_tr_perunit, over(iso, sort(1) label(labsize(`size'))) ///
			title("Return per unit of Risk", size(`size2')) ytitle("Per cent", size(`size')) ylabel(,labsize(`size')) scheme(s1color) ///
			legend( order(1 "Equity" 2 "Housing") size(`size') ring(0) position(3) cols(1)) ///
			name(r_per_unit_of_risk,replace) nodraw

* Combined risk vs return & return per unit of risk
graph combine eq_hous_r_and_sd r_per_unit_of_risk, cols(2) xsize(8) scheme(s1color)
graph export "${rore}/bld/graphs/byasset/png/ret_and_risk_per_unit.png", width(2000) height(1000) replace
graph export "${rore}/bld/graphs/byasset/ret_and_risk_per_unit.pdf", replace
graph close	

* Combined risk vs return & sharpe ratios
graph combine eq_hous_r_and_sd eq_hous_sharpe, cols(2) xsize(8) scheme(s1color)
graph export "${rore}/bld/graphs/byasset/png/retrisk_and_sharpe.png", width(2000) height(1000) replace
graph export "${rore}/bld/graphs/byasset/retrisk_and_sharpe.pdf", replace
graph export "${qje_figures}/Figure_09.pdf", replace
graph close	
