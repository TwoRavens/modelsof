/*--------------------------------------------------------------

Yield benchmarking table
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings ===================================================

cd "${main_dir}"


include paths


*======================= Import data ======================================================

use "${rore}/bld/data_out/rore_core_dataset.dta", clear

*======================= Settings ========================================================

local tosum_bms r_eq_tr r_housing_tr r_housing_tr_low r_housing_tr_high
local labs_bms """  "Baseline"  "Low benchmark" "High benchmark"

local n_bms : word count `tosum_bms'

*======================= Auxillary variables ==============================================

* Sample consistency check
foreach s of local tosum_bms	{
	replace sample = 0 if `s' ==.
}

*
* Scale up
foreach s of local tosum_bms	{
	* Gross return
	gen gr_`s' = 1+`s'
	* Convert net return to percent
	replace `s' = `s'*100
}

* =====================================================================================================
* ====================== Table: old version ===========================================================
* =====================================================================================================

* Arithmetic mean returns and sd
tabstat `tosum_bms' if sample==1, columns(variable) ///
			stat(mean sd ) save
mat rtns=r(StatTotal)
mat colnames rtns= `labs_bms'
mat rownames rtns="\emph{Mean return p.a.}" "Standard deviation"

esttab matrix(rtns, fmt(2 2 2 2 2)) using "${rore}/bld/tables/accuracy/benchmark_comparison.tex", replace ///
postfoot("") nomtitles collabels(none) ///
prehead("\begin{center} {\renewcommand{\arraystretch}{1.15}" ///
"\begin{tabularx}{\textwidth}{@{} l*{4}{C} @{}} \hline \hline \\ [-5mm]" ///
"& Equity & \multicolumn{3}{c}{Housing} \\" ///
"\cmidrule(l{7pt}r{7pt}){3-5}" ///
"&  & Baseline & Low benchmark & High benchmark \\") 

* Geometric mean returns
mat rtns_geo=J(1,`n_bms',.)

local i=0
local a=1
foreach var of local tosum_bms {
	ameans gr_`var' if sample==1
	mat rtns_geo[`a',`i'+1]=(r(mean_g)-1)*100
	local ++i
}

mat rownames rtns_geo="Geometric mean"

esttab matrix(rtns_geo, fmt(2 2 2 2 2)) using "${rore}/bld/tables/accuracy/benchmark_comparison.tex", append nomtitle ///
collabels(none) prehead("") postfoot("") noline

* No. obs
tabstat `tosum_bms'  if sample==1, columns(variable) ///
			stat(n ) save
mat nobs=r(StatTotal)
mat rownames nobs="Observations"

esttab matrix(nobs, fmt(0 0 0 0 0)) using "${rore}/bld/tables/accuracy/benchmark_comparison.tex", append nomtitle ///
collabels(none) prehead("") postfoot("\hline\hline" ///
"\multicolumn{5}{l}{" "}\\ [-4mm]" ///
	" \multicolumn{5}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Average global real returns in 16 countries, equally weighted.}\\" ///
"\end{tabularx} } \end{center}") 

* =====================================================================================================
* ====================== Table: extra bms =============================================================
* =====================================================================================================

local rs_extra r_housing_tr_histbm r_housing_tr_histbm_bs
local labs_extra ""Housing, historical benchmarks" "Housing, balance sheet approach""

local tosum_bms `tosum_bms' `rs_extra'
local labs_bms `labs_bms' `labs_extra'

local n_bms : word count `tosum_bms'

* Sample check (should be zero replacements)
foreach s of local rs_extra	{
	replace sample = 0 if `s' ==.
}

*
* Scale up
foreach s of local rs_extra	{
	* Gross return
	gen gr_`s' = 1+`s'
	* Convert net return to percent
	replace `s' = `s'*100
}

* Arithmetic mean returns and sd
tabstat `tosum_bms' if sample==1, columns(variable) ///
			stat(mean sd ) save
mat rtns=r(StatTotal)
*mat colnames rtns= `labs_bms'
mat rownames rtns="\emph{Mean return p.a.}" "Standard deviation"

esttab matrix(rtns, fmt(2 2 2 2 2)) using "${rore}/bld/tables/accuracy/more_benchmark_comparison.tex", replace ///
postfoot("") nomtitles collabels(none) ///
prehead("\begin{center} {\renewcommand{\arraystretch}{1.15}" ///
"\begin{tabularx}{\textwidth}{@{} l*{6}{C} @{}} \hline \hline \\ [-3mm]" ///
"& Equity & \multicolumn{5}{c}{Housing} \\" ///
"\cmidrule(l{7pt}r{7pt}){3-7}" ///
"&  & Baseline & Low initial benchmark & High intial benchmark & Historical benchmarks & Balance sheet approach \\") 

* Geometric mean returns
mat rtns_geo=J(1,`n_bms',.)

local i=0
local a=1
foreach var of local tosum_bms {
	ameans gr_`var' if sample==1
	mat rtns_geo[`a',`i'+1]=(r(mean_g)-1)*100
	local ++i
}

mat rownames rtns_geo="Geometric mean"

esttab matrix(rtns_geo, fmt(2 2 2 2 2)) using "${rore}/bld/tables/accuracy/more_benchmark_comparison.tex", append nomtitle ///
collabels(none) prehead("") postfoot("") noline

* No. obs
tabstat `tosum_bms'  if sample==1, columns(variable) ///
			stat(n ) save
mat nobs=r(StatTotal)
mat rownames nobs="Observations"

esttab matrix(nobs, fmt(0 0 0 0 0)) using "${rore}/bld/tables/accuracy/more_benchmark_comparison.tex", append nomtitle ///
collabels(none) prehead("") postfoot("\hline\hline" ///
"\multicolumn{7}{l}{" "}\\ [-4mm]" ///
	" \multicolumn{7}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Average total real returns across 16 countries, equally weighted.}\\" ///
"\end{tabularx} } \end{center}") 

copy "${rore}/bld/tables/accuracy/more_benchmark_comparison.tex" "${qje_tables}/Table_04.tex", replace

* =====================================================================================================
* ====================== Table: pure BS bms ===========================================================
* =====================================================================================================

local tosum_purebs r_eq_tr r_housing_tr r_housing_tr_purebs
local labs_purebs ""Equity" "Housing, baseline" "Housing, balance sheet approach""


local n_purebs : word count `tosum_purebs'

* Sample check (should be zero replacements)
gen sample_bs=sample
foreach s of local tosum_purebs	{
	replace sample_bs = 0 if `s' ==.
}

local toscale r_housing_tr_purebs
* Scale up
foreach s of local toscale	{
	* Gross return
	gen gr_`s' = 1+`s'
	* Convert net return to percent
	replace `s' = `s'*100
}

* Arithmetic mean returns and sd
tabstat `tosum_purebs' if sample_bs==1, columns(variable) ///
			stat(mean sd ) save
mat rtns_bs=r(StatTotal)
*mat colnames rtns= `labs_bms'
mat rownames rtns_bs="\emph{Mean return p.a.}" "Standard deviation"

esttab matrix(rtns_bs, fmt(2 2 2 2 2)) using "${rore}/bld/tables/accuracy/bs_benchmark_comparison.tex", replace ///
postfoot("") nomtitles collabels(none) ///
prehead("\begin{center} {\renewcommand{\arraystretch}{1.15}" ///
"\begin{tabularx}{\textwidth}{@{} l*{3}{C} @{}} \hline \hline \\ [-3mm]" ///
"& Equity & \multicolumn{2}{c}{Housing} \\" ///
"\cmidrule(l{7pt}r{7pt}){3-4}" ///
"&  & Rent-price approach (baseline) & Balance sheet approach \\") 

* Geometric mean returns
mat rtns_geo_bs=J(1,`n_purebs',.)

local i=0
local a=1
foreach var of local tosum_purebs {
	ameans gr_`var' if sample_bs==1
	mat rtns_geo_bs[`a',`i'+1]=(r(mean_g)-1)*100
	local ++i
}

mat rownames rtns_geo_bs="Geometric mean"

esttab matrix(rtns_geo_bs, fmt(2 2 2 2 2)) using "${rore}/bld/tables/accuracy/bs_benchmark_comparison.tex", append nomtitle ///
collabels(none) prehead("") postfoot("") noline

* No. obs
tabstat `tosum_purebs'  if sample_bs==1, columns(variable) ///
			stat(n ) save
mat nobs=r(StatTotal)
mat rownames nobs="Observations"

esttab matrix(nobs, fmt(0 0 0 0 0)) using "${rore}/bld/tables/accuracy/bs_benchmark_comparison.tex", append nomtitle ///
collabels(none) prehead("") postfoot("\hline\hline" ///
"\multicolumn{4}{l}{" "}\\ [-4mm]" ///
	" \multicolumn{4}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Average global real returns, equally weighted. Sample only covers countries and periods for which the balance sheet approach yield data are available.}\\" ///
"\end{tabularx} } \end{center}") 

* =====================================================================================================
* ====================== Table: housing only ==========================================================
* =====================================================================================================

* For presentation
local rs_honly r_housing_tr r_housing_tr_low r_housing_tr_high r_housing_tr_histbm r_housing_tr_histbm_bs
local labs_extra ""Baseline" "Low" "High" "Historical benchmarks" "BS approach""

local tosum_bms `tosum_bms' `rs_extra'
local labs_bms `labs_bms' `labs_extra'

local n_bms : word count `tosum_bms'

gen sample_honly = sample
* Sample check (should be zero replacements)
foreach s of local rs_honly	{
	replace sample_honly = 0 if `s' ==.
}


* Arithmetic mean returns
tabstat `rs_honly' if sample_honly==1, columns(variable) ///
			stat(mean) save
mat rtns=r(StatTotal)
*mat colnames rtns= `labs_bms'
mat rownames rtns="Mean return p.a."

esttab matrix(rtns, fmt(1 1 1 1 1 1)) using "${rore}/bld/tables/accuracy/honly_benchmark_comparison.tex", replace ///
postfoot("") nomtitles collabels(none) ///
prehead("\begin{center} \footnotesize {\renewcommand{\arraystretch}{1.2}" ///
"\begin{tabularx}{\textwidth}{@{} p{1.8cm}*{5}{C} @{}} \hline \hline \\ [-3mm]" ///
"&  Baseline & Low & High & Historical BMs & Balance sheet appr. \\") 


* No. obs
tabstat `rs_honly'  if sample_honly==1, columns(variable) ///
			stat(n ) save
mat nobs=r(StatTotal)
mat rownames nobs="Observations"

esttab matrix(nobs, fmt(0 0 0 0 0)) using "${rore}/bld/tables/accuracy/honly_benchmark_comparison.tex", append nomtitle ///
collabels(none) prehead("") postfoot("\hline\hline" ///
"\multicolumn{6}{l}{" "}\\ [-2mm]" ///
	" \multicolumn{6}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Average total real returns across 16 countries, equally weighted.}\\" ///
"\end{tabularx} } \end{center}") 
