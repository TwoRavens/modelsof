/*--------------------------------------------------------------

  Housing returns: sensitivity to location

----------------------------------------------------------------*/ 



clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data =============================================

use "${rore}/bld/data_out/rore_core_dataset.dta", clear

xtset ccode year

*======================= Settings =============================================

* Variables
local tosum_prestable r_housing_tr r_housing_tr_loclow r_housing_tr_lochigh

local npres : word count `tosum_prestable'

local periods "full post1950 post1980"
local conditions ""if sample == 1" "if sample == 1 & tp_post1950==1" "if sample == 1 & tp_post1980==1""

local nper : word count `periods'

* Graph
local colour edkblue
local size medium
local size2 large
local size3 small

*========================== Transform variables =============================================

local allrtns `tosum_prestable'

* Returns to percent; calcualte gross returns
foreach s of local allrtns	{
	* Gross return
	gen gr_`s' = 1+`s'
	* Convert net return to percent
	replace `s' = `s'*100
}

*======================= Calculate means =============================================

forvalues j = 1/`nper'	{

	local per`j' : word `j' of `periods'
	local cond`j' : word `j' of `conditions'
	local t`j' : word `j' of `titles'

	* Save means; loop over returns
	foreach r of local tosum_prestable	{
		ameans gr_`r' `cond`j''
		gen `r'_`per`j''_g = (r(mean_g)-1)*100
		gen `r'_`per`j''_am = (r(mean)-1)*100
	}
}


local types am g
local pers full post1950 post1980
foreach t of local types	{
	foreach r of local tosum_prestable	{
		gen `r'_`t' = `r'_full_`t' in 1
		replace `r'_`t' = r_housing_tr_post1950_`t' in 2
		replace `r'_`t' = r_housing_tr_post1980_`t' in 3
	}
}


foreach r of local tosum_prestable	{
	local j = 0
	foreach t of local types	{
		gen `r'_comb_`t' = .
	}
	foreach p of local pers	{
		foreach t of local types	{
			local j = `j' + 1
			replace `r'_comb_`t' = `r'_`p'_`t' in `j'
		}
		local j = `j' + 1
	}
}

gen lab = _n
replace lab = lab*2
replace lab = 3 if lab == 40
label define example 3 "Full sample" 9 "Post-1950" 15 "Post-1980"
label val lab example
sort lab

graph twoway (bar r_housing_tr_comb_am lab if lab<18, barwidth(2) color(green)) ///
	(bar r_housing_tr_comb_g lab if lab<18, barwidth(2) color(edkblue)) ///
	(rcap r_housing_tr_lochigh_comb_am r_housing_tr_loclow_comb_am lab if lab<18, lcolor(red) lwidth(medthick)) ///
	(rcap r_housing_tr_lochigh_comb_g r_housing_tr_loclow_comb_g lab if lab<18, lcolor(red) lwidth(medthick)), ///
	xlabel(3 9 15,valuelabel noticks labsize(`size')) xtitle("") ///
	ylab(0(2)8, labsize(`size')) ///
	scheme(s1color) ///
	legend(order(1 "Arithmetic mean" 2 "Geometric mean") size(`size')) 
graph export "${rore}/bld/graphs/accuracy/location_sensitivity.pdf", replace
graph export "${qje_figures}/Figure_05.pdf", replace
graph close
