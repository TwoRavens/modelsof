/*--------------------------------------------------------------

Our returns vs PSZ Distributional National Accounts
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths



* ================================================================================================
* ============================== Import data =====================================================
* ================================================================================================

use "${rore}/bld/data_out/rore_core_dataset.dta", clear
* PSZ returns; tax data
merge 1:1 iso year using "${rore}/bld/data_out/psz_returns.dta", nogen
merge 1:1 iso year using "${rore}/bld/data_out/corp_tax_impact.dta", nogen ///
	keepusing(r_eq_tr_bs_prof_incall)

keep if iso == "USA"
tsset year, yearly

* ================================================================================================
* ============================== Manipulations ===================================================
* ================================================================================================

* Our series grossing up for taxes; alternative
gen r_eq_tr_wdivtax = r_eq_tr + psz_divtax_forcorps
gen r_eq_tr_walltax = r_eq_tr + psz_tottax_forcorps


* ================================================================================================
* ============================== Moving averages =================================================
* ================================================================================================

* Variables to collapse into world returns
local toav r_capital_tr psz_r_capital_tr r_housing_tr psz_r_housing_tr r_eq_tr psz_r_eq_tr r_eq_tr_wdivtax r_eq_tr_walltax r_eq_tr_bs_prof_incall
local labs ""R on total wealth RORE" "R on total wealth Piketty et al." "Housing R, RORE" "Housing R, Piketty et al." "Equity R, RORE" "Equity R, Piketty et al." "Equity R, RORE w Div. tax" "Equity R, RORE w Profit tax" "Equity R, RORE w Corp tax""
local nvar : word count `toav'


*============================== Smoothing ===========================================

* 1-1/ Smoothing ----------------------------------------------------------------------

forvalues i = 1/`nvar'		{
	* Extract variable names and labels
	local v : word `i' of `toav'
	local l : word `i' of `labs'
	
	* Scale to percent
	replace `v' = `v'*100
	
	* 10-year MA
	qui tssmooth ma madec_`v' = `v', window(5,1,5)
	label var madec_`v' "`l', decadal moving average"
	qui replace madec_`v' = . if (l.`v'==. | l1.`v'==. | l2.`v'==. ///
		| l3.`v'==. | l4.`v'==. | l5.`v'==. | `v'==. ///
		| f.`v'==. | f1.`v'==. | f2.`v'==. | f3.`v'==. | ///
		f4.`v'==. |  f5.`v'==. )
	
	* 5-year moving averages
	qui tssmooth ma fiveyr_`v' = `v', window(2,1,2)
	label var fiveyr_`v' "`l', five-year moving average"
	* Only keep if enough observations
	qui replace fiveyr_`v' = . if (l.`v'==. | l1.`v'==. | l2.`v'==. ///
		| `v'==. | f.`v'==. | f1.`v'==. | f2.`v'==. )
}

* ================================================================================================
* ============================== Table ===========================================================
* ================================================================================================

gen sample_pik = 1 if psz_r_capital_tr !=.

* Settings
local tosum_prestable r_housing_tr psz_r_housing_tr r_eq_tr r_eq_tr_bs_prof_incall psz_r_eq_tr
local labs_prestable ""RORE"  "DNA"  "RORE"  "RORE incl. corp. tax" "DNA""

local npres : word count `tosum_prestable'
local nsubcol1 = `npres'/2 - 1
local nsubcol2 = `npres'/2
local nexcess : word count `tosum_excess'
local nexcess_usd : word count `tosum_excess_usd'

* 2/ Choose periods & titles, conditions ------------------------------------------
local periods "full"
local conditions ""if sample_pik == 1""
local nper : word count `periods'

*========================== Transform variables =============================================

* Returns to percent; calcualte gross returns
foreach s of local tosum_prestable	{
	* Gross return
	gen gr_`s' = 1+`s'/100
}


* ================================================================================================
* ============================== Graphs ==========================================================
* ================================================================================================

* 1/ Charts: two-lined ----------------------------------------------------------------------
* Start dates:
local start1 = 1910

* Loop over pairs of variables to plot, and filter types
* Choose type of averaging
local type fiveyr
* Choose pairs of variables
local series ""r_housing_tr psz_r_housing_tr" "r_eq_tr psz_r_eq_tr""
* Graph labels
local plotname ""rhous_psz" "req_psz""
local plottitle ""Housing" "Equity""
local ylab ""-5(5)15" "-10(10)30""
local pnum : word count `series'

* Legend font size
local size medium
local size2 medlarge
local size3 large
local size4 medium
local size5 medsmall

forvalues i = 1/`pnum'	{
	* Load plot characteristics
	local p`i' : word `i' of `series'
	local s1`i' : word 1 of `p`i''
	local s2`i' : word 2 of `p`i''
	local pl`i' : word `i' of `plotname'
	local yl`i' : word `i' of `ylab'
	local tl`i' : word `i' of `plottitle'
	
	* plot chart
	* Without title - for export
	twoway (tsline `type'_`s1`i'' `type'_`s2`i'' if year>=`start1' & `type'_`s2`i'' !=., ///
			yline(0, lcolor(gs8) lpattern(shortdash)) lpattern(solid dash) lcolor(green dkblue) ///
			mcolor(green dkblue) msize(small small)), ///
			scheme(s1color) legend(size(`size') order(1 2) cols(1) label(1 "Baseline, five-year moving average") ///
			label(2 "Distributional National Accounts, five-year moving average") region(lwidth(none))) ///
			xlabel(`start1'(20)2015) ///
			ylabel(`yl`i'', labsize(`size')) xtitle("") ytitle("Per cent", size(`size')) title("`tl`i''", size(`size4')) ///
			tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
			name(`pl`i'',replace) nodraw
			
}

* Combined  graphs
grc1leg rhous_psz req_psz, legendfrom(rhous_psz) ///
	cols(2) scheme(s1color) iscale(*1.5) name(allrets, replace)
graph display allrets, xsize(20) ysize(9)
graph export "${rore}/bld/graphs/accuracy/psz_returns/psz_summary_comparison.pdf", replace
graph export "${qje_figures}/Figure_A09.pdf", replace
graph close

