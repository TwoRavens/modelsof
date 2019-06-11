/*--------------------------------------------------------------

Returns during consumption disasters
----------------------------------------------------------------*/ 


clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data =============================================

import excel using "${rore}/src/raw_data/excel/consumption_disasters.xlsx", sheet("Data") ///
	cellrange(A6:S63) firstrow clear

replace disaster_iso = disaster_iso[_n-1] if disaster_iso==""
keep if include_disaster==1
gen n_disaster = _n

append using "${rore}/bld/data_out/rore_core_dataset.dta"

*======================= Disaster settings =============================================

* Disaster inclusion: conservative or not
local tdata disaster_data
* Start and end dates: barro-ursua or own peaks/troghs
local tdate barro_disaster

* Set parameters for tables
* i). Elastic column width
local tabx_7cols "\begin{tabularx}{\textwidth}{@{} l*{7}{C} @{}}"
local tabx_6cols "\begin{tabularx}{\textwidth}{@{} l*{6}{C} @{}}"
local tabx_4cols "\begin{tabularx}{\textwidth}{@{} l*{4}{C} @{}}"
local tabx_3cols "\begin{tabularx}{\textwidth}{@{} l*{3}{C} @{}}"
* ii). Footnote size
local foot_size "\footnotesize"
local foot_size2 "\scriptsize"
* ii). Subline spacing
local lsp "5pt"

*======================= Generate variables =============================================

* Loop over disasters
su n_disaster
local ndis = r(max)

* And assets
local assets eq housing bond bill
local atypes cum py

* Empty variables
foreach a of local assets	{
	gen `a'_change_cum =.
	gen `a'_change_py =.
}

* Rename bills for consistency
ren cum_r_bill_rate cum_r_bill_tr

forvalues i = 1/`ndis'	{
	* Extract data for each episode
	local diso = disaster_iso[`i']
	di "Iso: `diso'"
	local start = `tdate'_rstart[`i']
	di "Start: `start'"
	local end = `tdate'_rend[`i']
	di "End: `end'"
	local ny = `end'-`start'
	di "Length: `ny'"
	
	* Populate asset return changes
	foreach a of local assets	{
		if `tdata'_`a' == 1	{
			di "Asset: `a'"
			su cum_r_`a'_tr if year == `start' & iso == "`diso'"
			local start_r = r(mean)
			su cum_r_`a'_tr if year == `end' & iso == "`diso'"
			local end_r = r(mean)

			replace `a'_change_cum = (`end_r'-`start_r')*100/`start_r' in `i'
			replace `a'_change_py = `a'_change_cum/`ny' in `i'
			
			* Average
			if `i' == `ndis'	{
				local count = `i'+1
				foreach t of local atypes	{
					sum `a'_change_`t'
					replace `a'_change_`t' = r(mean) in `count'
				}
			}
		}
	}


}

keep disaster* c_trough c_peak c_decline barro_* cons_disaster* *change_cum *change_py ww2_disaster
local lim = `ndis'+3
local count2 = `ndis'+2
drop if _n>`lim'

order disaster_iso disaster_country c_peak c_trough c_decline `tdate'_rstart `tdate'_rend ///
	eq_change_cum eq_change_py housing_change_cum housing_change_py bond_change_cum ///
	bond_change_py bill_change_cum bill_change_py ww2_disaster
	
*======================= Table =============================================

* Additional formatting
replace c_decline = c_decline*100
* 2 parts over 2 pages
* Variables
local vars_num c_decline eq_change_cum housing_change_cum bond_change_cum ///
	bill_change_cum
local vars disaster_country c_peak c_trough `vars_num'

format `vars_num' %12.2f

* Extra variables
replace disaster_country="All disasters" in `count'
replace disaster_country="Consistent sample" in `count2'
replace disaster_country="No WW2" in `lim'
foreach a of local assets	{
	foreach t of local atypes	{
		sum `a'_change_`t' if eq_change_`t' !=. & housing_change_`t' !=. & bond_change_`t' !=. & ///
		bill_change_`t' !=.
		replace `a'_change_`t' = r(mean) in `count2'
		sum `a'_change_`t' if ww2_disaster==0
		replace `a'_change_`t' = r(mean) in `lim'
	}
}
su c_decline
replace c_decline = r(mean) if _n==`count'
su c_decline if eq_change_cum !=. & housing_change_cum !=. & bond_change_cum !=. & ///
	bill_change_cum !=.
replace c_decline = r(mean) if _n==`count2'
format c_decline %12.1f
sum c_decline if ww2_disaster==0
replace c_decline = r(mean) in `lim'

* Table break
local break = 36

* Pt1
listtex `vars' ///
	using "${rore}/bld/tables/accuracy/disaster_r_pt1.tex" if _n<`break', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,max width=\textwidth}" ///
	"{\renewcommand{\arraystretch}{1.15}" ///
	"{ \begin{tabularx}{\textwidth}{@{} l*{7}{C} @{}}\hline \hline \\ [-5mm]" ///
	"Country & \multicolumn{3}{c}{Consumption} & \multicolumn{4}{c}{Real returns} \\ " ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-4} \cmidrule(l{`lsp'}r{`lsp'}){5-8}" ///
	" & Peak & Trough & Drop & Equity & Housing & Bonds & Bills \\ \hline") ///
	foot("\hline\hline" ///
	" \multicolumn{8}{l}{" "} \\ [-2mm]" ///
	" \multicolumn{8}{c}{Continued overleaf} " ///
	"\end{tabularx} } }")
* Pt2
listtex `vars' ///
	using "${rore}/bld/tables/accuracy/disaster_r_pt2.tex" if _n>=`break' & _n<=`ndis', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,max width=\textwidth}" ///
	"{\renewcommand{\arraystretch}{1.15}" ///
	"{ \begin{tabularx}{\textwidth}{@{} l*{7}{C} @{}}\hline \hline \\ [-5mm]" ///
	"Country & \multicolumn{3}{c}{Consumption} & \multicolumn{4}{c}{Real returns} \\ " ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-4} \cmidrule(l{`lsp'}r{`lsp'}){5-8}" ///
	" & Peak & Trough & Drop & Equity & Housing & Bonds & Bills \\ \hline") ///
	foot("\hline \\ [-5mm]")
listtex `vars'  if _n>`ndis', ///
	appendto("${rore}/bld/tables/accuracy/disaster_r_pt2.tex") ///
	rstyle(tabular) head("\multicolumn{8}{l}{\emph{Averages:}} \\ \hline") ///
	foot("\hline\hline" ///
	" \multicolumn{8}{l}{" "} \\ [-5mm]" ///
	" \multicolumn{8}{@{} p{\textwidth}}{\footnotesize \textit{Note}: Consumption and cumulative real total returns " ///
	" on each asset class during consumptions disasters. " ///
	" Disaster dates from \citet{barroursuaBP:2008}." ///
	" Cumulative consumption drop from peak to trough year, and" ///
	" cumulative real returns from one year before consumption peak to one year before the trough." ///
	" Negative return means an asset return drop during disaster. Disasters with" ///
	" missing or poor quality asset return data excluded. All-disaster average uses all disasters" ///
	" where we have data for the particular asset class." ///
	" Consistent sample average uses only those disasters with data for all four assets." ///
	" No WW2 average excludes World War 2.}" ///
	"\end{tabularx} } }")

copy "${rore}/bld/tables/accuracy/disaster_r_pt1.tex" "${qje_tables}/Table_A11_pt1.tex", replace
copy "${rore}/bld/tables/accuracy/disaster_r_pt2.tex" "${qje_tables}/Table_A11_pt2.tex", replace
