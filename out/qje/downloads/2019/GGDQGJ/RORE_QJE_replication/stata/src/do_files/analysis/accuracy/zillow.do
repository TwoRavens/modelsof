/*--------------------------------------------------------------

Zillow vs our data comparison
----------------------------------------------------------------*/ 


clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths

*========================== Settings =============================================


* Set parameters for tables
* i). Elastic column width
local tabx_6cols "\begin{tabularx}{\textwidth}{@{} l*{6}{C} @{}}"
local tabx_5cols "\begin{tabularx}{\textwidth}{@{} l*{5}{C} @{}}"
local tabx_4cols "\begin{tabularx}{\textwidth}{@{} l*{4}{C} @{}}"
local tabx_3cols "\begin{tabularx}{\textwidth}{@{} l*{3}{C} @{}}"
* ii). Footnote size
local foot_size "\footnotesize"
local foot_size2 "\scriptsize"
* iii). Subline spacing
local lsp "5pt"
* iv). Top space
local tsp "-4mm"
* v). Footnote space
local fsp "-3mm"

*========================== Import data =============================================

* Zillow
import excel using "${rore}/src/raw_data/excel/zillow_stata_output_pre2015_real.xlsx", clear

ren A series
replace series = "Standard deviation" in 2
replace series = "\emph{Mean real capital gain p.a.}" in 3

foreach var of varlist B - E	{
	local name = `var'[1]
	destring `var', replace force
	ren `var' zillow_`name'
}

drop if _n==1

gen iso = "USA"
gen year = 1870 in 1
replace year = 1871 in 2

* RORE
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen
keep if iso == "USA"

su r_housing_capgain if iso == "USA" & year > 1995
gen rore_National = r(sd)*100 in 1
replace rore_National = r(mean)*100 in 2

keep rore_* zillow* series

format rore_* zillow* %12.2f
keep if _n < 3
sort zillow_National


*========================== Table =============================================


listtex series rore_National zillow_National zillow_States zillow_County zillow_Zipcode ///
	using "${rore}/bld/tables/accuracy/zillow.tex", replace ///
	rstyle(tabular) head("\begin{center} {\renewcommand{\arraystretch}{1.15}" ///
	"{ `tabx_5cols'\hline \hline \\  [-4mm]" ///
	" & Baseline & \multicolumn{4}{c}{Zillow} \\" ///
	" \cmidrule(l{`lsp'}r{`lsp'}){2-2} \cmidrule(l{`lsp'}r{`lsp'}){3-6}" ///
	"& National & National & State & County & Zipcode \\ \hline") ///
	foot("\hline\hline" ///
	" \multicolumn{6}{l}{" "} \\ [-4mm]" ///
	" \multicolumn{6}{@{} p{\textwidth}}{`foot_size'\textit{Note}: US data, 1995--2015. Average annual real capital gain" ///
	" and standard deviation of house prices. Baseline data are sourced from the OFHEO index. Zillow data are sourced" ///
	" from the Zillow Home Value Index which covers around 95\% of the US housing stock, and are averages" ///
	" of monthly values. National data are the returns and volatility of prices for a nationwide housing," ///\
	" and the other figures cover a representative state, county or zipcode level porftolio respectively.}" ///
	"\end{tabularx}  } } \end{center}")
	
copy "${rore}/bld/tables/accuracy/zillow.tex" "${qje_tables}/Table_05.tex", replace
