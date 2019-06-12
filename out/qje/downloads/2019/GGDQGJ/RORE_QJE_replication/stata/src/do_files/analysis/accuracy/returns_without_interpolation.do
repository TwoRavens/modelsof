*=============================================================================================================
*
*	Compare housing returns with and without interpolation
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
* ============================== Sample ==========================================================
* ================================================================================================

gen r_housing_tr_nointerp = r_housing_tr if prices_ipolated !=1 & rent_ipolated != 1
gen r_eq_tr_nointerp = r_eq_tr if eq_tr_interp != 1

* New sample variable
drop sample
gen sample = 1
replace sample = . if r_housing_tr ==. | r_eq_tr ==.

* ================================================================================================
* ============================== Table ===============================================
* ================================================================================================

* Table

local tosum r_eq_tr r_housing_tr r_eq_tr_nointerp r_housing_tr_nointerp

* Scale up
foreach s of local tosum	{
	* Convert net return to percent
	replace `s' = `s'*100
}


tabstat `tosum' if sample==1, columns(variable) ///
			stat(mean sd ) save
mat rtns=r(StatTotal)
mat rownames rtns="\emph{Mean return p.a.}" "Standard deviation"

* Returns and sd
esttab matrix(rtns, fmt(2 2 2 2 2)) using "${rore}/bld/tables/accuracy/no_interpolation.tex", replace ///
postfoot("") nomtitles collabels(none) ///
prehead("\begin{center} {\renewcommand{\arraystretch}{1.15}" ///
"\begin{tabularx}{\textwidth}{@{} lCCCC @{}} \hline \hline \\ [-4mm]" ///
"& \multicolumn{2}{c}{Baseline} &  \multicolumn{2}{c}{No interpolation} \\" ///
"\cmidrule(l{7pt}r{7pt}){2-3} \cmidrule(l{7pt}r{7pt}){4-5}" ///
"& Equity & Housing & Equity & Housing  \\") 

* No. obs
tabstat `tosum'  if sample==1, columns(variable) ///
			stat(n ) save
mat nobs=r(StatTotal)
mat rownames nobs="Observations"

esttab matrix(nobs, fmt(0 0 0 0 0 0)) using "${rore}/bld/tables/accuracy/no_interpolation.tex", append nomtitle ///
collabels(none) prehead("") postfoot("\hline\hline" ///
"\multicolumn{5}{l}{" "}\\ [-4mm]" ///
	" \multicolumn{5}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Equity and housing returns with (baseline)" ///
	" and without interpolation. Interpolation only used to cover the following disaster periods. Equity: Spanish Civil War," ///
	" Portuguese Carnation Revolution. Housing: Belgium WW1, Sweden WW1, Spanish Civil War. We only interpolate either" ///
	" house prices or rents, never both. 16 countries, unweighted.}\\" ///
"\end{tabularx} } \end{center}") 

copy "${rore}/bld/tables/accuracy/no_interpolation.tex" "${qje_tables}/Table_A13.tex", replace
