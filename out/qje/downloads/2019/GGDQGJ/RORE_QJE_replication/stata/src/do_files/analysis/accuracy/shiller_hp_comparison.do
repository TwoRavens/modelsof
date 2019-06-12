/*--------------------------------------------------------------

Comparison w. Shiller
----------------------------------------------------------------*/ 


clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"

include paths

*========================== Import data =============================================

* Shiller
import excel using "${rore}/src/raw_data/excel/shiller_hp_data.xls", sheet("Data") clear

keep H I
drop if _n<8
gen year = substr(H,1,4)
destring year, replace
gen month = substr(H,5,3) if year >= 1953
destring month H I, replace
ren (H I) (date shiller_hpnom)

* Annual data
keep if year <1953 | month == 0.95
keep year shiller_hpnom
gen iso = "USA"

* RORE
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen ///
	keepusing(housing_capgain r_housing_capgain cpi housing_rent_rtn r_housing_tr)

keep if iso == "USA"

*========================== Variables and summary ====================================

tsset year, yearly

gen shiller_hpr = shiller_hpnom/cpi
gen shiller_cgnom = d.shiller_hpnom/l.shiller_hpnom
gen shiller_cgr = d.shiller_hpr/l.shiller_hpr
gen prices = 1 if year == 1891
replace prices = l.prices*(1+housing_capgain) if year > 1891 & prices==.

* Real return for our HP index
gen r_prices = prices/cpi

* Normalise to 1 in 1941
local tonorm shiller_hpr r_prices
foreach r of local tonorm	{
	su `r' if year == 1941
	replace `r' = `r'/r(mean)
	
	* Logs
	*gen log_`r' = log10(`r')
}

gen s1=1 if shiller_cgr !=. & r_housing_capgain !=.

*============================== Settings ===============================================

* Set parameters for tables
* i). Elastic column width
local tabx_6cols "\begin{tabularx}{\textwidth}{@{} l*{6}{C} @{}}"
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


*============================== Variables ===============================================

local sumvars shiller_cgr r_housing_capgain housing_rent_rtn r_housing_tr 
local sumlabs ""Shiller CG" "RORE CG" "RORE RY" "RORE TR""

local nv : word count `sumvars'

* Returns to percent; calcualte gross returns
foreach s of local sumvars	{
	* Gross return
	gen gr_`s' = 1+`s'
	* Convert net return to percent
	replace `s' = `s'*100
}

*============================== Table ===============================================

* Arithmetic
tabstat `sumvars' if s1==1, columns(variable) ///
			stat(mean sd ) save
mat rtns=r(StatTotal)
mat colnames rtns= `sumlabs'
mat rownames rtns="\emph{Mean return p.a.}" "Standard deviation"

esttab matrix(rtns, fmt(2 2 2 2 2)) using "${rore}/bld/tables/accuracy/shiller_hp_compare.tex", replace ///
postfoot("") nomtitles collabels(none) ///
prehead("\begin{center} {\renewcommand{\arraystretch}{1.15}" ///
"\begin{tabularx}{\textwidth}{@{} lCCCC @{}} \hline \hline \\ [-5mm]" ///
"& Shiller (2000) & \multicolumn{3}{c}{Our baseline}  \\[1mm]" ///
"\cmidrule(l{7pt}r{7pt}){2-2} \cmidrule(l{7pt}r{7pt}){3-5}" ///
"& Real capital gain & Real capital gain & Rental yield & Total return  \\")

mat geo=J(1,`nv',.)

local i=0
local a=1
foreach var of local sumvars {
	ameans gr_`var' if s1==1
	mat geo[`a',`i'+1]=(r(mean_g)-1)*100
	local ++i
}

mat rownames geo="{Geometric mean}"

esttab matrix(geo, fmt(2 2 2 2 2)) using "${rore}/bld/tables/accuracy/shiller_hp_compare.tex", append nomtitle ///
collabels(none) prehead("") postfoot("") noline 

* No. obs
tabstat `sumvars' if s1==1, columns(variable) ///
			stat(n ) save
mat nobs=r(StatTotal)
mat rownames nobs="Observations"

esttab matrix(nobs, fmt(0 0 0 0 0)) using "${rore}/bld/tables/accuracy/shiller_hp_compare.tex", append nomtitle ///
collabels(none) prehead("") postfoot("\hline\hline" ///
"\multicolumn{5}{l}{" "}\\ [-4mm]" ///
	" \multicolumn{5}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Real housing returns," ///
	" capital gains and rental yield for the US. Shiller data use the house price index" ///
	" from \citet{shiller:2000}.} \\" ///
"\end{tabularx} } \end{center}") 

copy "${rore}/bld/tables/accuracy/shiller_hp_compare.tex" "${qje_tables}/Table_A19.tex", replace

* ================================================================================================
* ============================== Graphs ==========================================================
* ================================================================================================

* Legend font size
local size medsmall
local size2 medlarge
local size3 large
local size4 medium

* plot chart
twoway (tsline r_prices shiller_hpr if year>=1890, ///
	lpattern(solid dash) lcolor(green dkblue)), ///
	scheme(s1color) ///
	legend(size(`size2') cols(1) region(lwidth(none)) pos(5) ring(0) ///
	label(1 "Baseline") label(2 "Shiller (2000)")) ///
	xlabel(1890(20)2015, labsize(`size2')) ///
	ylabel(0(1)3, labsize(`size2')) xtitle("") ytitle("Index: 1941 = 1", size(`size2')) ///
	title("", size(`size3')) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(ltbluishgray ) lw(vthick)) ///
	name(hp_shiller_comparison,replace)

	graph export "${rore}/bld/graphs/accuracy/hp_shiller_comparison.pdf",  replace
	graph export "${qje_figures}/Figure_A04.pdf",  replace
	graph close
