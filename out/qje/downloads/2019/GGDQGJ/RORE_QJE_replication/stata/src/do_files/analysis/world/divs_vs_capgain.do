/*--------------------------------------------------------------

This file compares the returns from dividends and capital gains for
housing and equity
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths



*========================== Import data =============================================

use "${rore}/bld/data_out/rore_core_dataset.dta", clear

* Consistent sample variable
gen div_sample = 1 if eq_tr !=. & housing_tr !=. & eq_div_rtn !=. & housing_rent_rtn !=.
* Exclude hyperinflations
replace div_sample = . if inflation > 1

*========================== Settings =============================================

* 1/ Choose variables to sum ------------------------------------------------------
local tosum_real r_eq_capgain eq_div_rtn r_eq_tr r_housing_capgain housing_rent_rtn r_housing_tr
local tosum_nom eq_capgain eq_div_rtn eq_tr housing_capgain housing_rent_rtn housing_tr

local toscale `tosum_real' eq_capgain eq_tr housing_capgain housing_tr

local nret : word count `tosum_real'
* Column no
local ncol = `nret'+1

* 2/ Choose periods & titles, conditions ------------------------------------------
local periods "full post1950"
local conditions ""if div_sample == 1" "if div_sample == 1 & tp_post1950==1""
local titles ""Full sample: " "Post-1950: ""
local nper : word count `periods'

* 3/ Types
local types real nom
* Footnotes for table
local foot_real "real"
local foot_nom "nominal"
local headcg_real "Real c"
local headcg_nom "C"
local headtr_real "Real t"
local headtr_nom "T"

* 4/ Airthmetic/geometric mean types
local mtypes arith geo
local foot_arith "Arithmetic"
local foot_geo "Geometric"

*========================== Data manipulations =============================================

* Returns to percent; calcualte gross returns
foreach s of local toscale	{
	* Gross return
	gen gr_`s' = 1+`s'
	* Log return
	gen lr_`s' = log(gr_`s')
	* Convert net return to percent
	replace `s' = `s'*100
}

* Country var
qui su ccode
local cnum = r(max)
gen temp = .

*========================== Tables ===============================


* Loop over periods, and real/nominal returns
* Outer loop: nominal/real
foreach t of local types	{
	* Paper, aggregate -----------------------------------
	* Inner loop: periods
	forvalues j = 1/`nper'	{

		local per`j' : word `j' of `periods'
		local cond`j' : word `j' of `conditions'
		local t`j' : word `j' of `titles'

		* i). Arithmetic mean & s.d.

		tabstat `tosum_`t'' `cond`j'', columns(variable) ///
					stat(mean sd ) save
		mat `per`j''arith=r(StatTotal)
		mat rownames `per`j''arith="\emph{Mean return p.a.}" "{Standard deviation}"

		* Start a new table if first in the loop; otherwise append
		if `j' == 1	{
			esttab matrix(`per`j''arith, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/global_cg_vs_divs_`t'.tex", replace ///
			collabels(none) postfoot("") nomtitles ///
			prehead("\begin{center} {\renewcommand{\arraystretch}{1.15} " ///
			"\begin{tabularx}{\textwidth}{@{} l>{\centering}p{2cm}CC>{\centering}p{2cm}CC @{}}" ///	
			"\hline \hline" ///
			" & \multicolumn{`nret'}{c}{""} \\ [-4mm]" ///
			" & \multicolumn{3}{c}{Equity} & \multicolumn{3}{c}{Housing} \\" ///
			" \cmidrule(l{3pt}r{3pt}){2-4} \cmidrule(l{3pt}r{3pt}){5-7}" ///
			" & {`headcg_`t''apital gain} & {Dividend income} & {`headtr_`t''otal return} " ///
			" &  {`headcg_`t''apital gain} & {Rental income} & {`headtr_`t''otal return} \\" ///
			" \hline " ///
			" \multicolumn{`ncol'}{l}{""} \\ [-3mm]" ///
			" \multicolumn{`ncol'}{l}{\emph{`t`j''}} \\ [1mm]") 
		}
		if `j' > 1	{
			esttab matrix(`per`j''arith, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/global_cg_vs_divs_`t'.tex", append ///
				collabels(none) ///
				prehead(" \multicolumn{`ncol'}{l}{""} \\ [-3mm]" ///
				" \multicolumn{`ncol'}{l}{\emph{`t`j''}} \\ [1mm]") postfoot("") nomtitles
		}

		* ii). Geometric mean

		mat `per`j''geo=J(1,`nret',.)
		local i=0
		local a=1
		foreach var of local tosum_`t' {
			ameans gr_`var' `cond`j''
			mat `per`j''geo[`a',`i'+1]=(r(mean_g)-1)*100
			local ++i
		}

		mat rownames `per`j''geo="{Geometric mean}"

		esttab matrix(`per`j''geo, fmt(2 2 2 2 2)) using "${rore}/bld/tables/world/global_cg_vs_divs_`t'.tex", append nomtitle ///
		collabels(none) prehead("") postfoot("") noline

		*_ N

		tabstat `tosum_`t'' `cond`j'', columns(variable) ///
					stat(n ) save
		mat `per`j''n=r(StatTotal)
		mat rownames `per`j''n="{Observations}"
		
		* End the table if last in the loop; otherwise append
		if `j' <`nper'	{
			esttab matrix(`per`j''n, fmt(0 0 0 0 0)) using "${rore}/bld/tables/world/global_cg_vs_divs_`t'.tex", append nomtitle ///
			collabels(none) prehead("") postfoot("\hline")
		}
		if `j' == `nper'	{
			esttab matrix(`per`j''n, fmt(0 0 0 0 0)) using "${rore}/bld/tables/world/global_cg_vs_divs_`t'.tex", append nomtitle ///
			collabels(none) prehead("") postfoot("\hline\hline" ///
			" \multicolumn{`ncol'}{l}{" "} \\ [-3mm]" ///
			" \multicolumn{`ncol'}{@{} p{\textwidth}}{\footnotesize \textit{Note:} Average annual" ///
			" `foot_`t'' capital gain, dividend or rental income, and total return across 16 countries, unweighted." ///
			" Standard deviation in parentheses. Period coverage differs across countries." ///
			" Consistent coverage within countries: each country-year observation used to compute" ///
			" the statistics in this table has data for both equity and housing returns, capital gains" ///
			" and yields. Dividend and rental income expressed in" ///
			" percent of previous year's asset price.}\\" ///
			"\end{tabularx} } \end{center}") 
		}

	}
	* Presentation (aggregate only) -----------------------------------
	* i). Arithmetic mean & s.d.
	local cond : word 1 of `conditions'
	tabstat `tosum_`t'' `cond', columns(variable) ///
					stat(mean sd ) save
	mat arith_pres=r(StatTotal)
	mat rownames arith_pres="\emph{Mean return p.a.}" "Standard deviation"
		
	esttab matrix(arith_pres, fmt(1 1 1 1)) using "${rore}/bld/tables/world/capgain_vs_divs_pres_`t'.tex", replace ///
		postfoot("") nomtitle collabels(none) prehead("\begin{center} {\renewcommand{\arraystretch}{1.15}" ///
		"\begin{tabularx}{\textwidth}{@{} l*{`nret'}C @{}}" ///					
		"\hline \hline" ///
		" \multicolumn{`ncol'}{l}{""} \\ [-2mm]" ///
		" & \multicolumn{3}{c}{Equity} & \multicolumn{3}{c}{Housing} \\" ///
		" \cmidrule(l{3pt}r{3pt}){2-4} \cmidrule(l{3pt}r{3pt}){5-7}" ///
		" & {`headcg_`t''apital gain} & {Dividend income} & {`headtr_`t''otal return}" ///
		" &  {`headcg_`t''apital gain} & {Rental income} & {`headtr_`t''otal return} \\" ///
		" \multicolumn{`ncol'}{l}{""} \\ [-2mm]") 

	* ii). Geometric mean

	mat geo_pres=J(1,`nret',.)

	local i=0
	local a=1
	foreach var of local tosum_`t' {
		ameans gr_`var' `cond'
		mat geo_pres[`a',`i'+1]=(r(mean_g)-1)*100
		local ++i
	}

	mat rownames geo_pres="Geometric mean"

	esttab matrix(geo_pres, fmt(1 1 1 1)) using "${rore}/bld/tables/world/capgain_vs_divs_pres_`t'.tex", append nomtitle ///
	collabels(none) prehead("") postfoot("") noline

	*_ N

	tabstat `tosum_`t'' `cond', columns(variable) ///
				stat(n ) save
	mat n_pres=r(StatTotal)
	mat rownames n_pres="Observations"
		
	esttab matrix(n_pres, fmt(0 0 0 0 0)) using "${rore}/bld/tables/world/capgain_vs_divs_pres_`t'.tex", append nomtitle ///
		collabels(none) prehead("") postfoot("\hline\hline" ///
		"\end{tabularx} } \end{center}") 
		
	* Paper, by-country, -------------------------------------------------------------
	* Full sample only. Store values in variables to put standard errors in parentheses flexibly
	* Country loop
	forvalues k = 1/`cnum'	{
		* Count
		local cc1 = (`k'-1)*2 + 1
		local cc2 = (`k'-1)*2 + 2
		
		* Country name
		qui replace temp = 1 if year == 1900 & ccode ==`k'
		sort temp
		local cname = country[1]
		qui replace temp =.
		sort ccode year
		
		* Create new variable or replace
		if `k' == 1	{
			local cmd gen
		}
		if `k' > 1	{
			local cmd replace
		}
		
		* Fill out country name
		qui `cmd' cname_`t' = "`cname'" in `cc1'
		
		* Summarise ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		* i). Arithmetic mean and sd
		tabstat `tosum_`t'' `cond' & ccode == `k', columns(variable) ///
			stat(mean sd n) save
		mat carith = r(StatTotal)
		* ii). Geometric mean and sd
		mat cgeo=J(2,`nret',.)

		local i=0
		local a=1
		foreach var of local tosum_`t' {
			* Geo mean
			ameans gr_`var' `cond' & ccode == `k'
			mat cgeo[`a',`i'+1]=(r(mean_g)-1)*100
			* For sd use log return
			su lr_`var' `cond' & ccode == `k'
			mat cgeo[2,`i'+1]=r(sd)*100
			local ++i
		}
		
		
		* Populate variables
		foreach mt of local mtypes	{
			forvalues z = 1/`nret'	{
				* Mean returns and sd
				qui `cmd' c`mt'_`t'`z' = string(c`mt'[1,`z'],"%12.2f") in `cc1'
				qui replace c`mt'_`t'`z' = "(" + string(c`mt'[2,`z'],"%12.2f") + ")" in `cc2'
			}
			* Capital gain share
			local c`mt'_eqshare = abs(c`mt'[1,1])/(abs(c`mt'[1,1])+abs(c`mt'[1,2]))
			local c`mt'_housshare = abs(c`mt'[1,4])/(abs(c`mt'[1,5])+abs(c`mt'[1,6]))
			qui `cmd' c`mt'_eqshare_`t' = string(`c`mt'_eqshare',"%12.2f") in `cc1'
			qui `cmd' c`mt'_housshare_`t' = string(`c`mt'_housshare',"%12.2f") in `cc1'
			* No. obs
			qui `cmd' c`mt'_n_`t' = string(c`mt'[3,1],"%12.0f") in `cc1'
		}
	}
}

* QJE rep
copy "${rore}/bld/tables/world/global_cg_vs_divs_real.tex" "${qje_tables}/Table_08.tex", replace
copy "${rore}/bld/tables/world/global_cg_vs_divs_nom.tex" "${qje_tables}/Table_A20.tex", replace


*========================== By-country tables ===============================
gen nobs=_n
su nobs if carith_real1 != ""
local lim = r(max)
local ncol = `ncol' + 2
local nret = `nret' + 2

* 1/ Loop over nominal/real and arithmetic/geometric
foreach t of local types	{
	foreach mt of local mtypes	{
		listtex cname_`t' c`mt'_`t'1 c`mt'_`t'2 c`mt'_`t'3 c`mt'_eqshare_`t' c`mt'_`t'4 c`mt'_`t'5 c`mt'_`t'6 c`mt'_housshare_`t' ///
			using "${rore}/bld/tables/bycountry/country_cg_vs_divs_`t'`mt'.tex" if nobs<=`lim', replace ///
			rstyle(tabular) head("\centering \footnotesize \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
			"{\renewcommand{\arraystretch}{1.15}" ///
			"{ \begin{tabularx}{\textwidth}{@{} l*{`nret'}{C} @{}}\hline \hline \\ [-3mm]" ///
			" & \multicolumn{4}{c}{Equity} & \multicolumn{4}{c}{Housing} \\" ///
			" \cmidrule(l{3pt}r{3pt}){2-5} \cmidrule(l{3pt}r{3pt}){6-9}" ///
			" & {`headcg_`t''apital gain} & {Dividend income} & {`headtr_`t''otal return} & Capital gain share " ///
			" &  {`headcg_`t''apital gain} & {Rental income} & {`headtr_`t''otal return} & Capital gain share \\ \hline" ///
			" \multicolumn{`ncol'}{l}{""} \\ [-2mm]") ///
			foot("\hline\hline" ///
			" \multicolumn{`ncol'}{l}{" "} \\ [-3mm]" ///
			" \multicolumn{`ncol'}{@{} p{\textwidth}}{\footnotesize \textit{Note}: `foot_`mt'' average" ///
			" of annual `foot_`t'' capital gain, dividend or rental income, and total return, full sample. " ///
			" Standard deviation in parentheses. Period coverage differs across countries." ///
			" Consistent coverage within countries: each country-year observation used to compute" ///
			" the statistics in this table has data for both equity and housing returns, capital gains" ///
			" and yields. Dividend and rental income expressed as" ///
			" percentage of previous year's asset price. Capital gain share is the proportion of" ///
			" `foot_`t'' total return attributable to `foot_`t'' capital gains.}\\" ///
			"\end{tabularx} } }")
	}
}

* QJE rep
copy "${rore}/bld/tables/bycountry/country_cg_vs_divs_realarith.tex" "${qje_tables}/Table_09.tex", replace
copy "${rore}/bld/tables/bycountry/country_cg_vs_divs_nomarith.tex" "${qje_tables}/Table_A21.tex", replace
copy "${rore}/bld/tables/bycountry/country_cg_vs_divs_realgeo.tex" "${qje_tables}/Table_A22.tex", replace

