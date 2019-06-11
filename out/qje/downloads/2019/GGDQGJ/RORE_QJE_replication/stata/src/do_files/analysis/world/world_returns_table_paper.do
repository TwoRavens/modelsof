/*--------------------------------------------------------------

World returns by asset class: summary table
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths

*======================= Import data =============================================

use "${rore}/bld/data_out/rore_core_dataset.dta", clear

xtset ccode year

*========================== Settings =============================================

* 1/ Choose variables to sum ------------------------------------------------------
* Presentation table, and corresponding labels
*	- arithmetic and geo. means
local tosum_prestable r_bill_rate r_bond_tr r_eq_tr r_housing_tr bill_rate bond_tr eq_tr housing_tr
local labs_prestable ""Bills"  "Bonds"  "Equity"  "Housing" "Bills"  "Bonds"  "Equity"  "Housing""
*	- excess returns
local tosum_excess excess_bond_tr excess_eq_tr excess_housing_tr

* USD locals
local tosum_prestable_usd ""
local tosum_excess_usd ""
foreach v of local tosum_prestable	{
	local tosum_prestable_usd `tosum_prestable_usd' usd_`v'
}
local tosum_excess_usd usd_excess_bill_rate usd_excess_bond_tr usd_excess_eq_tr usd_excess_housing_tr

local npres : word count `tosum_prestable'
local nsubcol1 = `npres'/2 - 1
local nsubcol2 = `npres'/2
local nexcess : word count `tosum_excess'
local nexcess_usd : word count `tosum_excess_usd'

* 2/ Choose periods & titles, conditions ------------------------------------------
local periods "full post1950"
local conditions ""if sample == 1" "if sample == 1 & tp_post1950==1""
local titles ""Full sample: " "Post-1950: ""
local nper : word count `periods'

*========================== Transform variables =============================================

local allrtns `tosum_prestable' `tosum_excess'
local allrtns_usd `tosum_prestable_usd' `tosum_excess_usd'

* Returns to percent; calcualte gross returns
foreach s of local allrtns	{
	* Gross return
	gen gr_`s' = 1+`s'
	* Convert net return to percent
	replace `s' = `s'*100
}
foreach s of local allrtns_usd	{
	* Gross USD return
	gen gr_`s' = 1 + `s'
	* Convert net return to percent
	replace `s' = `s'*100
}

*========================= Tables =============================================

* 1/ Outline table: real and nominal; equally weighted; including wars ------------------------------

* Loop over periods
forvalues j = 1/`nper'	{

	local per`j' : word `j' of `periods'
	local cond`j' : word `j' of `conditions'
	local t`j' : word `j' of `titles'

	* i). Arithmetic mean & s.d.

	tabstat `tosum_prestable' `cond`j'', columns(variable) ///
				stat(mean sd ) save
	mat `per`j''arith=r(StatTotal)
	mat colnames `per`j''arith= `labs_prestable'
	mat rownames `per`j''arith="\emph{Mean return p.a.}" "{Standard deviation}"
	
	* Start a new table if first in the loop; otherwise append
	if `j' == 1	{
		esttab matrix(`per`j''arith, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/Returns_world_paper.tex", replace ///
		collabels(none) postfoot("") nomtitles ///
		prehead("\begin{center} {\renewcommand{\arraystretch}{1.15} \begin{tabularx}{\textwidth}{@{} l*{`nsubcol1'}{C}{C}*{`nsubcol2'}{C} @{}}" ///	
		"\hline \hline" ///
		" & \multicolumn{8}{c}{""} \\ [-4mm]" ///
		" & \multicolumn{4}{c}{Real returns} & \multicolumn{4}{c}{Nominal Returns} \\ \cmidrule(l{3pt}r{3pt}){2-5} \cmidrule(l{3pt}r{3pt}){6-9}" ///
		" & {Bills} & {Bonds} & {Equity} & {Housing} & {Bills} & {Bonds} & {Equity} & {Housing} \\" ///
		" \hline " ///
		" \multicolumn{9}{l}{""} \\ [-3mm]" ///
		" \multicolumn{9}{l}{\emph{`t`j''}} \\ [1mm]") 
	}
	if `j' > 1	{
		esttab matrix(`per`j''arith, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/Returns_world_paper.tex", append ///
			collabels(none) ///
			prehead(" \multicolumn{9}{l}{""} \\ [-3mm]" ///
			" \multicolumn{9}{l}{\emph{`t`j''}} \\ [1mm]") postfoot("") nomtitles
	}

	* ii). Geometric mean

	mat `per`j''geo=J(1,`npres',.)

	local i=0
	local a=1
	foreach var of local tosum_prestable {
	ameans gr_`var' `cond`j''
	mat `per`j''geo[`a',`i'+1]=(r(mean_g)-1)*100
	local ++i
	}

	mat rownames `per`j''geo="{Geometric mean}"

	esttab matrix(`per`j''geo, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/Returns_world_paper.tex", append nomtitle ///
	collabels(none) prehead("") postfoot("") noline

	* iii). Excess returns arithmetic

	tabstat `tosum_excess' `cond`j'', columns(variable) ///
				stat(mean sd ) save
	mat `per`j''excess_values=r(StatTotal)
	
	mat empty=(.\.)
	mat `per`j''excess=empty,`per`j''excess_values
	mat rownames `per`j''excess="\emph{Mean excess return p.a.}" "{Standard deviation}"
				
	esttab matrix(`per`j''excess, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/Returns_world_paper.tex", append nomtitle ///
	collabels(none) prehead("") postfoot("") noline

	* iv). Excess returns geometric

	* Don't compute excess returns for bills and inflation

	mat `per`j''excess_geo_values=J(1,`nexcess',.)

	local i=0
	local a=1
	foreach var of local tosum_excess {
	ameans gr_`var'	`cond`j''
	mat `per`j''excess_geo_values[`a',`i'+1]=(r(mean_g)-1)*100
	local ++i
	}

	mat empty=(.)
	mat `per`j''excess_geo=empty,`per`j''excess_geo_values
	mat rownames `per`j''excess_geo="{Geometric mean}"

	esttab matrix(`per`j''excess_geo, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/Returns_world_paper.tex", append nomtitle ///
	collabels(none) prehead("") postfoot("") noline

	*_ N

	tabstat `tosum_prestable' `cond`j'', columns(variable) ///
				stat(n ) save
	mat `per`j''n=r(StatTotal)
	mat rownames `per`j''n="{Observations}"
	
	* End the table if last in the loop; otherwise append
	if `j' <`nper'	{
		esttab matrix(`per`j''n, fmt(0 0 0 0 0)) using "${rore}/bld/tables/world/Returns_world_paper.tex", append nomtitle ///
		collabels(none) prehead("") postfoot("\hline")
	}
	if `j' == `nper'	{
	esttab matrix(`per`j''n, fmt(0 0 0 0 0)) using "${rore}/bld/tables/world/Returns_world_paper.tex", append nomtitle ///
	collabels(none) prehead("") postfoot("\hline\hline" ///
	" \multicolumn{9}{l}{" "} \\ [-3mm]" ///
	" \multicolumn{9}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Annual global returns in 16 countries," ///
	" equally weighted. Period coverage differs across countries. Consistent coverage within countries:" ///
	" each country-year observation used to compute the statistics in this table has data for all four" ///
	" asset returns. Excess returns are computed relative to bills.}\\" ///
	"\end{tabularx} } \end{center}") 
	}

}

	copy "${rore}/bld/tables/world/Returns_world_paper.tex" "${qje_tables}/Table_02.tex", replace


* 2/ USD returns and excess returns ------------------------------

* Loop over periods
forvalues j = 1/`nper'	{

	local per`j' : word `j' of `periods'
	local cond`j' : word `j' of `conditions'
	local t`j' : word `j' of `titles'

	* i). Arithmetic mean & s.d.

	tabstat `tosum_prestable_usd' `cond`j'', columns(variable) ///
				stat(mean sd ) save
	mat `per`j''arith=r(StatTotal)
	mat colnames `per`j''arith= `labs_prestable'
	mat rownames `per`j''arith="\emph{Mean return p.a.}" "Standard deviation"
	
	* Start a new table if first in the loop; otherwise append
	if `j' == 1	{
		esttab matrix(`per`j''arith, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/USD_Returns_world_paper.tex", replace ///
		collabels(none) postfoot("") nomtitles ///
		prehead("\begin{center} {\renewcommand{\arraystretch}{1.15} \begin{tabularx}{\textwidth}{@{} l*{`nsubcol1'}{C}{C}*{`nsubcol2'}{C} @{}}" ///	
		"\hline \hline" ///
		" & \multicolumn{8}{c}{""} \\ [-4mm]" ///
		" & \multicolumn{4}{c}{Real returns} & \multicolumn{4}{c}{Nominal Returns} \\ \cmidrule(l{3pt}r{3pt}){2-5} \cmidrule(l{3pt}r{3pt}){6-9}" ///
		" & Bills & Bonds & Equity & Housing & Bills & Bonds & Equity & Housing  \\" ///
		" \hline " ///
		" \multicolumn{9}{l}{""} \\ [-3mm]" ///
		" \multicolumn{9}{l}{\emph{`t`j''}} \\ [1mm]") 
	}
	if `j' > 1	{
		esttab matrix(`per`j''arith, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/USD_Returns_world_paper.tex", append ///
			collabels(none) ///
			prehead(" \multicolumn{9}{l}{""} \\ [-3mm]" ///
			" \multicolumn{9}{l}{\emph{`t`j''}} \\ [1mm]") postfoot("") nomtitles
	}

	* ii). Geometric mean

	mat `per`j''geo=J(1,`npres',.)

	local i=0
	local a=1
	foreach var of local tosum_prestable_usd {
	ameans gr_`var' `cond`j''
	mat `per`j''geo[`a',`i'+1]=(r(mean_g)-1)*100
	local ++i
	}

	mat rownames `per`j''geo="Geometric mean"

	esttab matrix(`per`j''geo, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/USD_Returns_world_paper.tex", append nomtitle ///
	collabels(none) prehead("") postfoot("") noline

	* iii). Excess returns arithmetic

	tabstat `tosum_excess_usd' `cond`j'', columns(variable) ///
				stat(mean sd ) save
	mat `per`j''excess=r(StatTotal)
	mat rownames `per`j''excess="\emph{Mean excess return p.a.}" "Standard deviation"
				
	esttab matrix(`per`j''excess, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/USD_Returns_world_paper.tex", append nomtitle ///
	collabels(none) prehead("") postfoot("") noline

	* iv). Excess returns geometric

	* Don't compute excess returns for bills and inflation

	mat `per`j''excess_geo_values=J(1,`nexcess_usd',.)

	local i=0
	local a=1
	foreach var of local tosum_excess_usd {
	ameans gr_`var'	`cond`j''
	mat `per`j''excess_geo[`a',`i'+1]=(r(mean_g)-1)*100
	local ++i
	}

	mat rownames `per`j''excess_geo="Geometric mean"

	esttab matrix(`per`j''excess_geo, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/USD_Returns_world_paper.tex", append nomtitle ///
	collabels(none) prehead("") postfoot("") noline

	*_ N

	tabstat `tosum_prestable_usd' `cond`j'', columns(variable) ///
				stat(n ) save
	mat `per`j''n=r(StatTotal)
	mat rownames `per`j''n="Observations"
	
	* End the table if last in the loop; otherwise append
	if `j' <`nper'	{
		esttab matrix(`per`j''n, fmt(0 0 0 0 0)) using "${rore}/bld/tables/world/USD_Returns_world_paper.tex", append nomtitle ///
		collabels(none) prehead("") postfoot("\hline")
	}
	if `j' == `nper'	{
	esttab matrix(`per`j''n, fmt(0 0 0 0 0)) using "${rore}/bld/tables/world/USD_Returns_world_paper.tex", append nomtitle ///
	collabels(none) prehead("") postfoot("\hline\hline" ///
	" \multicolumn{9}{l}{" "} \\ [-3mm]" ///
	" \multicolumn{9}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Global average US-Dollar returns, equally weighted." ///
	" Real returns subtract US inflation. Excess returns are over US Treasury bills. Period coverage differs across countries." ///
	" Consistent coverage within countries: each country-year observation used to compute the statistics in this table" ///
	" has data for all four asset returns.}\\" ///
	"\end{tabularx} } \end{center}") 
	}

}

copy "${rore}/bld/tables/world/USD_Returns_world_paper.tex" "${qje_tables}/Table_A14.tex", replace
