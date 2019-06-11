/*--------------------------------------------------------------

Returns during hyperinflations
----------------------------------------------------------------*/ 


clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths


*======================= Import data =============================================

use "${rore}/bld/data_out/rore_core_dataset.dta"

*======================= Settings =============================================

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

*======================= Summary stats =============================================

drop inflation
gen inflation = (cpi-l.cpi)/l.cpi

* Hyperinflation variable
gen nhyp = 1 if  iso == "FIN" & year == 1918

replace nhyp = 2 if  iso == "DEU" & tin(1920,1924)

replace nhyp = 3 if  iso == "ITA" & year == 1944

replace nhyp = 4 if  iso == "JPN" & tin(1945,1947)

local hyplabs ""Finland, 1917--1918" "Germany, 1920--1924" "Italy, 1943--1944" "Japan, 1944--1947""
local starts 1918 1920 1944 1945
local durations 1 5 1 3
local isos FIN DEU ITA JPN

local vars eq_tr bill_rate bond_tr inflation

* Interpolate bill rate
replace bill_rate = (l.bill_rate + f.bill_rate)/2 if iso == "DEU" & year == 1923 & bill_rate ==.

* Cumulative returns and inflation
foreach g of local vars	{
	gen `g'_5yr = ((1+f4.`g')*(1+f3.`g')*(1+f2.`g')*(1+f.`g')*(1+`g')-1)
	gen `g'_3yr = ((1+f2.`g')*(1+f.`g')*(1+`g')-1)
	gen `g'_2yr = ((1+f.`g')*(1+`g')-1)
	gen `g'_1yr = `g'
}

* Real cumulative returns: cumulative nominal return net of cumulative inflation
local toreal_cum eq_tr bill_rate bond_tr
local toreal_years 1yr 2yr 3yr 5yr
foreach r of local toreal_cum	{
	foreach y of local toreal_years	{
	gen r_`r'_`y' = (1+`r'_`y')/(1 + inflation_`y')-1
	}
}

local tosum r_eq_tr r_bill_rate r_bond_tr inflation bond_tr bill_rate eq_tr
gen text_lab = ""

foreach s of local tosum	{
	gen text_`s' = .
}


* Loop over hyperinflations
forvalues i = 1/4	{
	* Parameters
	local lab : word `i' of `hyplabs'
	local dur : word `i' of `durations'
	local start : word `i' of `starts'
	local iso : word `i' of `isos'
	
	* Label
	replace text_lab = "`lab'" in `i'
	
	* Returns
	foreach s of local tosum	{
		su `s'_`dur'yr if year == `start' & iso == "`iso'"
		replace text_`s' = r(mean)*100 in `i'
	}
}

* Formatting
foreach s of local tosum	{
	format text_`s' %12.2f
	gen text2_`s' = string(text_`s',"%12.2f")
}

keep text*

*======================= Table =============================================

* Nominal and real returns, hyperinflations only
listtex text_lab text_r_bill_rate text_r_bond_tr text_r_eq_tr text_bill_rate ///
	text_bond_tr text_eq_tr text_inflation ///
	using "${rore}/bld/tables/accuracy/hyperinflations.tex" if _n<=4, replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,max width=\textwidth}" ///
	"{\renewcommand{\arraystretch}{1.15}" ///
	"{ \begin{tabularx}{\textwidth}{@{} l*{7}{C} @{}}\hline \hline \\ [-5mm]" ///
	"Episode & \multicolumn{3}{c}{Real returns} & \multicolumn{3}{c}{Nominal returns} & Inflation \\" ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-4} \cmidrule(l{`lsp'}r{`lsp'}){5-7}" ///
	"& Bills & Bonds & Equity & Bills & Bonds & Equity & \\ \hline") ///
	foot("\hline\hline" ///
	" \multicolumn{8}{l}{" "} \\ [-5mm]" ///
	" \multicolumn{8}{@{} p{\textwidth}}{\footnotesize \textit{Note}: Cumulative real and" ///
	" nominal returns during hyperinflations. No housing returns data are available" ///
	" for these episodes." ///
	" Because of potential timing differences and uncertainties about inflation rates," ///
	" the returns are potentially subject to a large measurement error.}" ///
	"\end{tabularx} } }")
	
copy "${rore}/bld/tables/accuracy/hyperinflations.tex" "${qje_tables}/Table_A12.tex", replace
