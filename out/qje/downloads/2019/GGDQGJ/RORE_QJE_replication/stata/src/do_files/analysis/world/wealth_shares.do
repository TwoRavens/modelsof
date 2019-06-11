/*--------------------------------------------------------------

Calculate wealth shares for different assets
----------------------------------------------------------------*/ 


clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths

* =================================================================================
* ====================== Settings =================================================
* =================================================================================

* Labels in pie charts
local size1 "*0.65"
* Title size
local size2 "*1.4"

* World graphs - one pie size
local size3 "*2"


* ==========================================================================================
*======================== Graphs ===========================================================
* ==========================================================================================

use "${rore}/bld/data_out/wealth_shares.dta", clear

gen zero = 0
label var zero ""

local types invest hhgross hhnet

* 1/ Investable assets, total assets, hh wealth

foreach t of local types	{
	* I. Total investable assets; household total assets
	* Combine bonds and bills for household graphs
	if "`t'" == "hhgross"	{
		local lab "Household Assets"
		local comb "`t'_bondbill"
		local combratio "`t'_ratio_bondbill"
	}
	if "`t'" == "hhnet"	{
		local lab "Household Wealth"
		local comb "`t'_bondbill"
		local combratio "`t'_ratio_bondbill"
	}
	if "`t'" == "invest"	{
		local lab "Investable Assets"
		local comb "`t'_bonds `t'_bills"
		local combratio "`t'_ratio_bonds `t'_ratio_bills"
	}
	
	* 3/ World average
	if "`t'" == "invest"	{
	graph pie `t'_ratio_housing `t'_ratio_equity `t'_ratio_bonds `t'_ratio_bills `t'_ratio_deposits ///
		`t'_ratio_otherfin `t'_ratio_othernonfin  ///
		if country == "world_av", ///
		plabel(1 name, size(`size3') color(white) gap(5))  ///
		plabel(2 name, size(`size3') color(white) gap(-5))  ///
		plabel(3 name, size(`size3') color(white))  ///
		plabel(4 name, size(`size3') color(white) gap(-10))  ///
		plabel(5 name, size(`size3') color(white))  ///
		plabel(6 name, size(`size3') color(white) gap(-5))  ///
		plabel(7 name, size(`size3') color(white) gap(-5))  ///
		title("`lab'", size(`size2')) legend(off) scheme(s1color) ///
		plotregion(color(white) lwidth(none)) ///
		name(worldav_`t')	
	graph export "${rore}/bld/graphs/wealth_shares/detail/worldav_`t'.pdf", replace
	graph close
	}
	else	{
		graph pie `t'_ratio_housing `t'_ratio_equity `t'_ratio_bondbill zero `t'_ratio_deposits ///
		`t'_ratio_otherfin `t'_ratio_othernonfin  ///
		if country == "world_av", ///
		plabel(1 name, size(`size3') color(white))  ///
		plabel(2 name, size(`size3') color(white) gap(-5))  ///
		plabel(3 name, size(`size3') color(white) gap(5))  ///
		plabel(4 name)  ///
		plabel(5 name, size(`size3') color(white))  ///
		plabel(6 name, size(`size3') color(white) gap(-5))  ///
		plabel(7 name, size(`size3') color(white) gap(-5))  ///
		title("`lab'", size(`size2')) legend(off) scheme(s1color) ///
		plotregion(color(white) lwidth(none)) ///
		name(worldav_`t')
	graph export "${rore}/bld/graphs/wealth_shares/detail/worldav_`t'.pdf", replace
	graph close
	}
}

		
* 2/ Physical capital

* World: averages
graph pie k_ratio_housing k_ratio_other_buildings k_ratio_machinery_equip ///
		k_ratio_other_non_fin  ///
		if country == "world_av", ///
		plabel(1 name, size(`size3') color(white))  ///
		plabel(2 name, size(`size3') color(white) gap(-5))  ///
		plabel(3 name, size(`size3') color(white) gap(-5))  ///
		plabel(4 name, size(`size3') color(white) gap(-10))  ///
		title("Capital Stock", size(`size2')) legend(off) scheme(s1color) ///
		graphregion(color(white) lwidth(none)) ///
		plotregion(color(white) lwidth(none)) name(worldav_k)
	graph export "${rore}/bld/graphs/wealth_shares/detail/worldav_k.pdf", replace
	graph close


* RORE paper graph: combine physical capital 
graph combine worldav_invest worldav_k, cols(2) xsize(8) scheme(s1color)
graph export "${rore}/bld/graphs/wealth_shares/wealth_shares_pie.pdf", replace
*graph save "${rore}/bld/graphs/wealth_shares/gph/wealth_shares_pie.gph", replace

graph export "${qje_figures}/Figure_01.pdf", replace
graph close

* ==========================================================================================
* ======================== Tables ==========================================================
* ==========================================================================================

* Drop cumulative world series
drop if country == "world"

* Create coutry labels
gen country_lab = "France" if country == "FRA"
replace country_lab = "Germany" if country == "DEU"
replace country_lab = "Japan" if country == "JPN"
replace country_lab = "UK" if country == "UK"
replace country_lab = "USA" if country == "USA"
replace country_lab = "Average share" if country == "world_av"

* Types
local types invest hhgross hhnet
local tlabs ""investable assets" "total household assets" "household wealth""
local ntyp : word count `types'
* Investable Assets, household wealth, household gross
* Set column width
local w "{\parbox{0.09\textwidth}{\centering"

* Table
forvalues i = 1/`ntyp'	{
	local t : word `i' of `types'
	local tlab : word `i' of `tlabs'
	listtex country_lab `t'_ratio_housing `t'_ratio_equity `t'_ratio_bonds `t'_ratio_bills ///
		`t'_ratio_deposits 	`t'_ratio_otherfin `t'_ratio_othernonfin  ///
		using "${rore}/bld/tables/wealth_shares/`t'_wealth_shares.tex" if _n<=5, replace ///
		rstyle(tabular) head("\begin{table}[H] \small  \centering \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
		"{\renewcommand{\arraystretch}{1.2}" ///
		"{ \begin{tabularx}{\textwidth}{@{} L*{7}{S} @{}}\hline \hline" ///
		"{Country} &  `w' Housing}} & `w' Equity}} & `w' Bonds}} & `w' Bills}} & `w' Deposits}} & `w' Other}} & {Other} \\" ///
		"		   &		   &		  &		    &		  &			   & `w' financial}} & {non-financial} \\ \hline") ///
		foot("\hline")
	listtex country_lab `t'_ratio_housing `t'_ratio_equity `t'_ratio_bonds `t'_ratio_bills ///
		`t'_ratio_deposits 	`t'_ratio_otherfin `t'_ratio_othernonfin  if _n >5, ///
		appendto("${rore}/bld/tables/wealth_shares/`t'_wealth_shares.tex") ///
		rstyle(tabular) head("") ///
		foot("\hline \hline" ///
		"\multicolumn{8}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Ratios to" ///
		" total `tlab', percentage points. End-2015.}" ///
		"\end{tabularx} } }" ///
		"\end{table}")
}

copy "${rore}/bld/tables/wealth_shares/invest_wealth_shares.tex" "${qje_tables}/Table_A23.tex", replace

local w "{\parbox{0.18\textwidth}{\centering"
* Table for capital
	listtex country_lab k_ratio_housing k_ratio_other_buildings k_ratio_machinery_equip k_ratio_other_non_fin  ///
		using "${rore}/bld/tables/wealth_shares/capital_shares.tex" if _n<=5, replace ///
		rstyle(tabular) head("\begin{table}[H] \small  \centering \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
		"{\renewcommand{\arraystretch}{1.2}" ///
		"{ \begin{tabularx}{\textwidth}{@{} L*{4}{S} @{}}\hline \hline" ///
		"{Country} &  `w' Housing}} & `w' Other}} & `w' Machinery and }} & `w' Other}} \\" ///
		"		   &		   &	`w' buildings}}	  &		`w' equipment}}   & `w' non-financial}} \\ \hline") ///
		foot("\hline")
	listtex country_lab k_ratio_housing k_ratio_other_buildings k_ratio_machinery_equip k_ratio_other_non_fin  if _n >5, ///
		appendto("${rore}/bld/tables/wealth_shares/capital_shares.tex") ///
		rstyle(tabular) head("") ///
		foot("\hline \hline" ///
		"\multicolumn{5}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Ratios to" ///
		" total capital stock, percentage points. End-2015.}" ///
		"\end{tabularx} } }" ///
		"\end{table}")
		
copy "${rore}/bld/tables/wealth_shares/capital_shares.tex" "${qje_tables}/Table_A24.tex", replace
