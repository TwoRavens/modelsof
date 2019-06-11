/*--------------------------------------------------------------

Housing vs equity for non-overlapping windows
----------------------------------------------------------------*/ 


clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths

* =====================================================================================================
* ====================== Import data ==================================================================
* =====================================================================================================

use "${rore}/bld/data_out/rore_core_dataset.dta", replace

* =====================================================================================================
* ====================== Settings =====================================================================
* =====================================================================================================

* Variables to smooth
local toav r_housing_tr r_eq_tr r_capital_tr rgdp_growth
local nvar : word count `toav'

* Horizons to smooth over
local horizons 1 5 10 20

* 1/ Set parameters for tables xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
* i). Elastic column width
local tabx_10cols "\begin{tabularx}{\textwidth}{@{} l*{9}{C} @{}}"
local tabx_8cols "\begin{tabularx}{\textwidth}{@{} l*{7}{C} @{}}"
local tabx_7cols "\begin{tabularx}{\textwidth}{@{} l*{6}{C} @{}}"
local tabx_5cols "\begin{tabularx}{\textwidth}{@{} l*{4}{C} @{}}"
local tabx_6cols "\begin{tabularx}{\textwidth}{@{} l*{5}{C} @{}}"
local tabx_4cols "\begin{tabularx}{\textwidth}{@{} l*{3}{C} @{}}"
local tabx_3cols "\begin{tabularx}{\textwidth}{@{} l*{2}{C} @{}}"
* ii). Footnote size
local foot_size "\footnotesize"
local foot_size2 "\scriptsize"
* iii). Subline spacing
local lsp "5pt"
* iv). Top space
local tsp "-4mm"
* v). Footnote space
local fsp "-2mm"
* vi). Space next to numbers the top
local nsp "-4mm"


* =====================================================================================================
* ====================== Filtering ====================================================================
* =====================================================================================================

xtset ccode year, yearly


* 1-1/ Smoothing ----------------------------------------------------------------------


forvalues i = 1/`nvar'		{
	* Extract variable names and labels
	local v : word `i' of `toav'
	
	* Country-level variables
	* 10-year ma
	qui tssmooth ma av10_`v' = `v', window(4,1,5)
	qui replace av10_`v' = . if (l.`v'==. | l1.`v'==. | l2.`v'==. | l3.`v'==. ///
		| l4.`v'==. | `v'==. | f.`v'==. | f1.`v'==. | f2.`v'==. | f3.`v'==. | ///
		f4.`v'==. |  f5.`v'==. )
	qui replace av10_`v' = . if (l.sample!=1 | l1.sample!=1 | l2.sample!=1 ///
		| l3.sample!=1 | l4.sample!=1 | sample!=1 ///
		| f.sample!=1 | f1.sample!=1 | f2.sample!=1 | f3.sample!=1 | ///
		f4.sample!=1 |  f5.sample!=1 )
	
	* 5-year moving averages
	qui tssmooth ma av5_`v' = `v', window(2,1,2)
	* Only keep if enough observations
	qui replace av5_`v' = . if (l.`v'==. | l1.`v'==. | l2.`v'==. ///
		| `v'==. | f.`v'==. | f1.`v'==. | f2.`v'==. )
	replace av5_`v' = . if (l.sample!=1 | l1.sample!=1 | l2.sample!=1 ///
		| sample!=1 | f.sample!=1 | f1.sample!=1 | f2.sample!=1 )

	* 20-year moving average
	qui tssmooth ma av20_`v' = `v', window(9,1,10)
	* Only keep if enough observations
	qui replace av20_`v' = . if (l.`v'==. | l1.`v'==. | l2.`v'==. | l3.`v'==. | l4.`v'==. ///
		| l5.`v'==. | l6.`v'==. | l7.`v'==. | l8.`v'==. | l9.`v'==. |  `v'==.   | f.`v'==. ///
		| f1.`v'==. | f2.`v'==. | f3.`v'==. | f4.`v'==. |  f5.`v'==.  |  f6.`v'==.  ///
		|  f7.`v'==.  |  f8.`v'==.  |  f9.`v'==.  |  f10.`v'==.)
	replace av20_`v' = . if (l.sample!=1 | l1.sample!=1 | l2.sample!=1 | l3.sample!=1 ///
		| l4.sample!=1 | l5.sample!=1 | l6.sample!=1 | l7.sample!=1 | l8.sample!=1 ///
		| l9.sample!=1 | sample !=1 | f.sample!=1 | f1.sample!=1 | f2.sample!=1 ///
		| f3.sample!=1 | f4.sample!=1 |  f5.sample!=1 | f6.sample!=1 |  f7.sample!=1 ///
		| f8.sample!=1 |  f9.sample!=1 | f10.sample!=1)	
					
	* 1-year: normal sample
	gen av1_`v' = `v' if sample == 1
}

* r-g gap and consistent r - g sample
foreach h of local horizons	{
	gen av`h'_r_g_gap = av`h'_r_capital_tr - av`h'_rgdp_growth
	replace av`h'_r_capital_tr = . if av`h'_r_g_gap ==.
	replace av`h'_rgdp_growth = . if av`h'_r_g_gap ==.
}


* =====================================================================================================
* ====================== Non-overlapping windows ======================================================
* =====================================================================================================

* Markers non-overlapping data -----------------------------------
* 1-year: normal sample
gen samp1y = 1 if sample == 1

* 5-year
gen yr5 = year + 2
gen rem5 = mod(yr5,5)
gen samp5y = 1 if rem5 == 0

* 10-year
gen yr2 = year+5
gen rem10 =  mod(yr2,10)
gen samp10y = 1 if rem10 == 0

* 20-year
gen yr3 = year + 10
gen rem20 =  mod(yr3,20)
gen samp20y = 1 if rem20 == 0

local toav_extra `toav' r_g_gap

* Reduce the sample -----------------------------------
foreach h of local horizons	{
	foreach v of local toav_extra	{
		gen av`h'_nolap_`v'= av`h'_`v' if samp`h'y == 1
	}
}

* =====================================================================================================
* ====================== Housing vs equity returns ====================================================
* =====================================================================================================

local tosum av1_nolap_r_eq_tr av1_nolap_r_housing_tr av5_nolap_r_eq_tr av5_nolap_r_housing_tr  ///
	av10_nolap_r_eq_tr av10_nolap_r_housing_tr av20_nolap_r_eq_tr av20_nolap_r_housing_tr 

local n_sum : word count `tosum'


* Scale up
foreach s of local tosum	{
	* Gross return
	gen gr_`s' = 1+`s'
	* Convert net return to percent
	replace `s' = `s'*100
}


* Arithmetic mean returns and sd
tabstat `tosum', columns(variable) ///
			stat(mean sd ) save
mat rtns=r(StatTotal)
mat rownames rtns="\emph{Mean return p.a.}" "Standard deviation"

esttab matrix(rtns, fmt(2 2 2 2 2 2 2 2)) using "${rore}/bld/tables/accuracy/houseq_nonoverlap_windows.tex", replace ///
postfoot("") nomtitles collabels(none) ///
prehead("\begin{center} {\renewcommand{\arraystretch}{1.15}" ///
"\begin{tabularx}{\textwidth}{@{} l*{8}{C} @{}} \hline \hline \\ [-5mm]" ///
"& \multicolumn{2}{c}{1-year (baseline)} & \multicolumn{2}{c}{5-year} & " ///
" \multicolumn{2}{c}{10-year} &  \multicolumn{2}{c}{20-year} \\" ///
"\cmidrule(l{7pt}r{7pt}){2-3} \cmidrule(l{7pt}r{7pt}){4-5} \cmidrule(l{7pt}r{7pt}){6-7} \cmidrule(l{7pt}r{7pt}){8-9}" ///
"& Equity & Housing & Equity & Housing & Equity & Housing & Equity & Housing \\") 

* No. obs
tabstat `tosum'  if sample==1, columns(variable) ///
			stat(n ) save
mat nobs=r(StatTotal)
mat rownames nobs="Observations"

esttab matrix(nobs, fmt(0 0 0 0 0 0 0 0)) using "${rore}/bld/tables/accuracy/houseq_nonoverlap_windows.tex", append nomtitle ///
collabels(none) prehead("") postfoot("\hline\hline" ///
"\multicolumn{9}{l}{" "}\\ [-4mm]" ///
	" \multicolumn{9}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Average global real returns in 16 countries " ///
	" averaged over 1-year, 5-year, 10-year and 20-year non-overlapping windows.}\\" ///
"\end{tabularx} } \end{center}") 

copy "${rore}/bld/tables/accuracy/houseq_nonoverlap_windows.tex" "${qje_tables}/Table_A17.tex", replace

* =====================================================================================================
* ====================== r-g vs g correlations ========================================================
* =====================================================================================================

foreach h of local horizons	{
	* r-g, g
	correl av`h'_nolap_r_g_gap av`h'_nolap_rgdp_growth
	gen corr_`h'y = r(rho) in 1
	gen corr_`h'y_N = r(N) in 4

	* Post-1950
	correl av`h'_nolap_r_g_gap av`h'_nolap_rgdp_growth if year > 1950
	replace corr_`h'y = r(rho) in 5
	replace corr_`h'y_N = r(N) in 8

	* r-g, r
	correl av`h'_nolap_r_g_gap av`h'_nolap_r_capital_tr
	replace corr_`h'y = r(rho) in 3

	* Post-1950
	correl av`h'_nolap_r_g_gap av`h'_nolap_r_capital_tr if year > 1950
	replace corr_`h'y = r(rho) in 7

	* r, g
	correl av`h'_nolap_rgdp_growth av`h'_nolap_r_capital_tr
	replace corr_`h'y = r(rho) in 2

	* Post-1950
	correl av`h'_nolap_rgdp_growth av`h'_nolap_r_capital_tr if year > 1950
	replace corr_`h'y = r(rho) in 6
	
	* Format
	format corr_`h'y %9.2f
	format corr_`h'y_N %9.0f
}

gen lab = "r-g, g" if _n == 1 | _n ==5
replace lab = "r-g, r" if _n == 3 | _n ==7
replace lab = "r, g" if _n == 2 | _n ==6
replace lab = "Observations" if _n == 4 | _n ==8

order lab corr_*


* No columns
local c = 5

* Table
listtex lab  corr_1y corr_5y corr_10y corr_20y ///
	using "${rore}/bld/tables/world/r_g_correls.tex" if _n<=3, replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,max width=\textwidth}" ///
	"{ `tabx_`c'cols'\hline \hline \\ [`tsp']" ///
	" & 1-year & 5-year & 10-year & 20-year \\ \hline \\ [`tsp']" ///
	"\multicolumn{`c'}{l}{\textit{Full sample:}} \\ \hline \\ [`tsp']") ///
	foot("\hline \\ [`tsp']")
listtex lab  corr_1y_N corr_5y_N corr_10y_N corr_20y_N if _n==4, ///
		appendto("${rore}/bld/tables/world/r_g_correls.tex") ///
		rstyle(tabular) head("") ///
		foot("\hline \\ [`tsp']")
listtex lab  corr_1y corr_5y corr_10y corr_20y if _n>4 & _n<8, ///
		appendto("${rore}/bld/tables/world/r_g_correls.tex") ///
		rstyle(tabular) head("\multicolumn{`c'}{l}{\textit{Post-1950:}} \\ \hline \\ [`tsp']") ///
		foot("\hline \\ [`tsp']")
listtex lab  corr_1y_N corr_5y_N corr_10y_N corr_20y_N if _n==8, ///
		appendto("${rore}/bld/tables/world/r_g_correls.tex") ///
		rstyle(tabular) head("") ///
		foot(" \\ [`tsp'] \hline\hline" ///
		" \multicolumn{`c'}{l}{" "} \\ [`fsp']" ///
		" \multicolumn{`c'}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Pairwise correlations of data" ///
		" averaged over 1-year, 5-year, 10-year and 20-year non-overlapping moving windows." ///
		" 16 countries, equally weighted. $ r $ is the real return on capital," ///
		" $ g $ is real GDP growth, and $ r - g $ is the gap between the two.}" ///
		"\end{tabularx} }")
		
copy "${rore}/bld/tables/world/r_g_correls.tex" "${qje_tables}/Table_A26.tex", replace
