*=============================================================================================================
*
*	Compare returns across monetary regimes
*
*=============================================================================================================

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths

* ================================================================================================
* ============================== Settings ========================================================
* ================================================================================================

* Legend font size
local size medsmall
local size2 medlarge
local size3 large
local size4 small

* ================================================================================================
* ============================== Import data =====================================================
* ================================================================================================
use "${rore}/bld/data_out/rore_core_dataset.dta", clear


* ================================================================================================
* ============================== Settings =======================================================
* ================================================================================================

* 1/ Choose variables to sum ------------------------------------------------------
* Presentation table, and corresponding labels
*	- arithmetic and geo. means
local tosum_prestable r_bill_rate r_bond_tr r_eq_tr r_housing_tr risk_premium
local labs_prestable ""Bills"  "Bonds"  "Equity"  "Housing" "Risk premium""

local npres : word count `tosum_prestable'
local ncols = `npres' + 1

* 2/ Choose periods & titles, conditions ------------------------------------------
local periods "GS AGS BW Float"
local conditions ""if sample == 1 & year < 1914" "if sample == 1 & tin(1919,1938)" "if sample == 1 & tin(1946,1973)" "if sample == 1 & year>1973""
local titles ""Gold standard (1870--1913)" "Amended gold standard (1919--1938)" "Bretton-Woods (1946--1973)" "Floating exchange rates (1974--2015)""
local nper : word count `periods'

* ================================================================================================
* ============================== Transform variables =======================================================
* ================================================================================================

local allrtns `tosum_prestable'

* Returns to percent; calcualte gross returns
foreach s of local tosum_prestable	{
	* Gross return
	gen gr_`s' = 1+`s'
	* Convert net return to percent
	replace `s' = `s'*100
}


*========================= Tables =============================================

* 1/ Outline table ------------------------------

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
		esttab matrix(`per`j''arith, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/monetary_regimes.tex", replace ///
		collabels(none) postfoot("") nomtitles ///
		prehead("\begin{center} {\renewcommand{\arraystretch}{1.15} \begin{tabularx}{\textwidth}{@{} l*{`npres'}{C} @{}}" ///	
		"\hline \hline" ///
		" \multicolumn{`ncols'}{c}{""} \\ [-4mm]" ///
		" & {Bills} & {Bonds} & {Equity} & {Housing} & {Risk premium} \\" ///
		" \hline " ///
		" \multicolumn{`ncols'}{l}{""} \\ [-3mm]" ///
		" \multicolumn{`ncols'}{l}{\emph{`t`j''}} \\ [1mm]") 
	}
	if `j' > 1	{
		esttab matrix(`per`j''arith, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/monetary_regimes.tex", append ///
			collabels(none) ///
			prehead(" \multicolumn{`ncols'}{l}{""} \\ [-3mm]" ///
			" \multicolumn{`ncols'}{l}{\emph{`t`j''}} \\ [1mm]") postfoot("") nomtitles
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

	esttab matrix(`per`j''geo, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/monetary_regimes.tex", append nomtitle ///
	collabels(none) prehead("") postfoot("") noline


	*_ N

	tabstat `tosum_prestable' `cond`j'', columns(variable) ///
				stat(n ) save
	mat `per`j''n=r(StatTotal)
	mat rownames `per`j''n="{Observations}"
	
	* End the table if last in the loop; otherwise append
	if `j' <`nper'	{
		esttab matrix(`per`j''n, fmt(0 0 0 0 0)) using "${rore}/bld/tables/world/monetary_regimes.tex", append nomtitle ///
		collabels(none) prehead("") postfoot("\hline")
	}
	if `j' == `nper'	{
	esttab matrix(`per`j''n, fmt(0 0 0 0 0)) using "${rore}/bld/tables/world/monetary_regimes.tex", append nomtitle ///
	collabels(none) prehead("") postfoot("\hline\hline" ///
	" \multicolumn{`ncols'}{l}{" "} \\ [-3mm]" ///
	" \multicolumn{`ncols'}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Annual global returns and risk premiums" ///
	" in 16 countries, equally weighted. Period coverage differs across countries. Consistent coverage within countries:" ///
	" each country-year observation used to compute the statistics in this table" ///
	" has data for all four asset returns." ///
	" Risk premium is the risky return (weighted average of equities and housing) minus the safe return" ///
	" (weighted average of bonds and bills).}\\" ///
	"\end{tabularx} } \end{center}") 
	}

}

copy "${rore}/bld/tables/world/monetary_regimes.tex" "${qje_tables}/Table_A10.tex", replace
