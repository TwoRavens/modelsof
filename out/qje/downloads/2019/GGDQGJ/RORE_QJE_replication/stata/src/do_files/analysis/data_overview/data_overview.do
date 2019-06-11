//============================================================================//
//	           		Table: coverage by country and asset					  //
//============================================================================//

*======================= Path settings =============================================

cd "${main_dir}"

include paths

*======================= Import data =============================================

use "${rore}/bld/data_out/rore_core_dataset.dta", clear

xtset ccode year

*======================= Variables and labels =============================================

local tokeep eq_tr housing_tr bond_tr bill_rate
local labs "Equity Housing Bonds Bills"

keep iso ccode country year `tokeep'

local num : word count `tokeep'
forvalues i = 1/`num'	{
	local l`i' : word `i' of `labs'
	local v`i' : word `i' of `tokeep'
	
	label var `v`i'' "`l`i''"
}

* Order for table
order year country iso ccode `tokeep'

*======================= Measure coverage =============================================

foreach v of local tokeep	{
	by ccode: gen start_`v'_aux=year if l.`v' ==. & `v' !=.
	by ccode: egen start_`v' = min(start_`v'_aux)
	by ccode: gen end_`v'_aux = year if f.`v' ==. & `v' !=.
	by ccode: egen end_`v' = max(end_`v'_aux)
	by ccode: gen text_`v' = string(start_`v') + "--" + string(end_`v')
	
	drop start_`v'_aux end_`v'_aux
}

keep if year == 1900

*============================ Table ================================================

* Paper
listtex country text_bill_rate text_bond_tr text_eq_tr text_housing_tr ///
	using "${rore}/bld/tables/data/data_overview.tex", ///
rstyle(tabular) head("\begin{table}[H] \centering \small" ///
	"\caption{Data coverage} \label{tab:DataCvg}" ///
  "\centering " ///
  "{\renewcommand{\arraystretch}{1.1}" ///
  "{ \begin{tabularx}{\textwidth}{@{} LCCCC @{}}\hline \hline""Country & Bills & Bonds & Equity & Housing  \\" ///
  "\hline") ///
foot("\hline \hline \end{tabularx} } }" ///
	 "\end{table}") ///
	replace

* Paper
listtex country text_bill_rate text_bond_tr text_eq_tr text_housing_tr ///
	using "${qje_tables}/Table_01.tex", ///
rstyle(tabular) head("\begin{table}[H] \centering \small" ///
	"\caption{Data coverage} \label{tab:DataCvg}" ///
  "\centering " ///
  "{\renewcommand{\arraystretch}{1.1}" ///
  "{ \begin{tabularx}{\textwidth}{@{} LCCCC @{}}\hline \hline""Country & Bills & Bonds & Equity & Housing  \\" ///
  "\hline") ///
foot("\hline \hline \end{tabularx} } }" ///
	 "\end{table}") ///
	replace


