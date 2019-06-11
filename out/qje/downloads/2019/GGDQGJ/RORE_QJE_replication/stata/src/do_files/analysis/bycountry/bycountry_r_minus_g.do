/*--------------------------------------------------------------

Calculate by-country tables for asset returns, r - g, risky vs safe,
	including the various transformations and robustness checks in the apepnndix,
	and statistics across different subperiods
----------------------------------------------------------------*/ 


clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"


include paths

*========================== Settings =============================================

* Periods to consider, and how these are defined
local periods "full post1950 post1980 post50to80 nowar nogfc wars ww1 ww2"
local conds ""if year >=1870" "if tp_post1950 == 1" "if tp_post1980 == 1" "if tp_post50to80 == 1" "if tp_nowar == 1" "if tp_nogfc == 1" "if tp_war == 1" "if tp_ww1 == 1" "if tp_ww2 == 1""
local perlabs ""Full sample" "Post-1950" "Post-1980" "1950--1980" "Excluding wars" "Excluding the Global Fin. Crisis" "World Wars" "World War 1" "World War 2""

* Variables for summary stats
local tocollapse r_capital_tr rgdp_growth r_risky_tr r_safe_tr r_eq_tr r_housing_tr r_bill_rate r_bond_tr ///
	usd_r_eq_tr usd_r_housing_tr usd_r_bond_tr usd_r_bill_rate rc_simple rr_simple

local nper : word count `periods'

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

*======================= Calculate r and g; risky and safe rate =======================================

* R: bonds, bills, equity, housing; portfolio-weighted
* G: real GDP growth
* risky rate: equity, housing; portfolio-weighted
* safe rate: bills, bonds; equally-weighted

* Loop: periods
forvalues i = 1/`nper'	{

	* 1/ Load parameters for periods
	local per`i' : word `i' of `periods'
	local cond`i' : word `i' of `conds'

	* 2/ Import data
	use "${rore}/bld/data_out/rore_core_dataset.dta"
	* Shorten names to ensure they are valid for Stata
	ren (r_capital_tr_simple r_risky_tr_simple) (rc_simple rr_simple)
	
	* 3/ Choose sample: keep only data for specific period
	keep `cond`i''
	local tocollapse_full `tocollapse'
	* 4/ Inconsistent returns, and fully consistent returns
	foreach v of local tocollapse	{
		* Maximum sample: fully inconsistent returns
		gen `v'_max = `v'
		label var `v'_max "Maximum sample (not within-country consistent)"
		gen `v'_min = `v' if sample == 1
		label var `v'_min "Minimum sample (consistent across all asset classes)"
		* Minimum sample: only where we have all four assets
		local tocollapse_full `tocollapse_full' `v'_max `v'_min
	}
	
	* 5/ Within-table consistent sample (baseline):
	* r and g
	replace r_capital_tr = . if rgdp_growth ==.
	replace rgdp_growth =. if r_capital_tr ==.
	replace rc_simple = . if r_capital_tr ==.
	
	* risky and safe
	replace r_risky_tr = . if r_safe_tr ==.
	replace r_safe_tr =. if r_risky_tr ==.
	replace rr_simple = . if r_risky_tr ==.
	
	* equity and housing
	replace r_eq_tr = . if r_housing_tr ==.
	replace r_housing_tr =. if r_eq_tr ==.
	
	* bonds and bills
	replace r_bill_rate = . if r_bond_tr ==.
	replace r_bond_tr = . if r_bill_rate ==.
	
	* Wars sample: exclude Japan and Italy WW2 because of hyperinflations
	if "`per`i''" == "wars" | "`per`i''" == "ww2"	{
		foreach v of local tocollapse_full	{
			replace `v' =. if (iso == "ITA" | iso == "JPN") & tp_ww2 == 1
		}
	}
	
	* USD returns: consistent sample across all
	foreach v of local tocollapse	{
		if strpos("`v'","usd") > 0	{
			replace `v' = . if sample != 1
		}
	}
	
	* Interim save 1
	save "${rore}/bld/data_out/r_minus_g_country_aux1.dta", replace
	
	* 6/ Summaries: by country
	collapse (mean) `tocollapse_full', by(country iso)
	
	* Scale and rename
	foreach s of local tocollapse_full	{
		replace `s' = `s'*100
		format `s' %12.2f
		ren `s' `per`i''_`s'
	}
	
	* interim save 2
	save "${rore}/bld/data_out/r_minus_g_country_aux2.dta", replace
	
	* 7/ World summary
	use "${rore}/bld/data_out/r_minus_g_country_aux1.dta", clear
	* Unweighted
	collapse (mean) `tocollapse_full', by(year)
	collapse (mean) `tocollapse_full'
	gen iso = "WORLD_uw"
	gen country = "z"
	foreach s of local tocollapse_full	{
		replace `s' = `s'*100
		format `s' %12.2f
		ren `s' `per`i''_`s' 
	}
	* add to country data
	merge 1:1 iso country using "${rore}/bld/data_out/r_minus_g_country_aux2.dta", gen(_merge1)
	drop _merge*
	* interim save 3
	save "${rore}/bld/data_out/r_minus_g_country_aux2.dta", replace
	
	* Weighted
	use "${rore}/bld/data_out/r_minus_g_country_aux1.dta", clear
	collapse (mean) `tocollapse_full' [iw = weight], by(year)
	collapse (mean) `tocollapse_full'
	
	* insert zs for odering
	gen iso = "WORLD_gdpw"
	gen country = "zz"
	foreach s of local tocollapse_full	{
		replace `s' = `s'*100
		format `s' %12.2f
		ren `s' `per`i''_`s'
	}
	
	* add to country data
	merge 1:1 iso country using "${rore}/bld/data_out/r_minus_g_country_aux2.dta", gen(_merge1)
	drop _merge*
	
	* 9/ interim save end of loop
	* Merge with other periods' data
	if `i' > 1	{
		merge 1:1 iso country using "${rore}/bld/data_out/r_minus_g_country.dta", gen(_merge`i')
	}
	drop if iso == ""
	save "${rore}/bld/data_out/r_minus_g_country.dta", replace
	
}

* Order
encode country, gen(ccode)
sort ccode
replace country = "Average, weighted" if iso == "WORLD_gdpw"
replace country = "Average, unweighted" if iso == "WORLD_uw"

* Tidy up
rm "${rore}/bld/data_out/r_minus_g_country_aux1.dta"
rm "${rore}/bld/data_out/r_minus_g_country_aux2.dta"

*========================== Tables =============================================

* Marker for horizontal line before averages
gen num=_n
sum num if iso == "USA"
local lim = r(mean)


* 1/ Bond vs bill xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
listtex country full_r_bill_rate full_r_bond_tr post1950_r_bill_rate post1950_r_bond_tr ///
	post1980_r_bill_rate post1980_r_bond_tr ///
	using "${rore}/bld/tables/bycountry/pres_globalbillbond.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,max width=\textwidth}" ///
	"{ `tabx_6cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{Full Sample} & \multicolumn{2}{c}{Post 1950} & \multicolumn{2}{c}{Post 1980}\\" ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5} \cmidrule(l{`lsp'}r{`lsp'}){6-7}" ///
	"& Bills & Bonds & Bills & Bonds & Bills & Bonds \\ \hline") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_bill_rate full_r_bond_tr post1950_r_bill_rate post1950_r_bond_tr ///
	post1980_r_bill_rate post1980_r_bond_tr if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/pres_globalbillbond.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{7}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{7}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns." ///
	" Period coverage differs across countries. Consistent coverage within countries: each country-year" ///
	" observation used to compute the statistics in this table has data for both real bill and bond returns." ///
	" The average, unweighted and average, weighted figures are respectively the unweighted and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")

copy "${rore}/bld/tables/bycountry/pres_globalbillbond.tex" "${qje_tables}/Table_10.tex", replace
	
* Excluding wars
listtex country full_r_bill_rate full_r_bond_tr nowar_r_bill_rate nowar_r_bond_tr ///
	using "${rore}/bld/tables/bycountry/nowar_globalbillbond.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,max width=\textwidth}" ///
	"{ `tabx_4cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{Full Sample} & \multicolumn{2}{c}{Excluding wars}\\" ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5}" ///
	"& Bills & Bonds & Bills & Bonds \\ \hline") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_bill_rate full_r_bond_tr nowar_r_bill_rate nowar_r_bond_tr if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/nowar_globalbillbond.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{5}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{5}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns." ///
	" Returns excluding wars omit periods 1914---1919 and 1939---1947. Period coverage differs across countries." ///
	" Consistent coverage within countries: each country-year" ///
	" observation used to compute the statistics in this table has data for both real bill and bond returns." ///
	" The average, unweighted and average, weighted figures are respectively the unweighted" ///
	" and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")

copy "${rore}/bld/tables/bycountry/nowar_globalbillbond.tex" "${qje_tables}/Table_A04.tex", replace

* 2/ Equity vs housing xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
listtex country full_r_eq_tr full_r_housing_tr post1950_r_eq_tr post1950_r_housing_tr ///
	post1980_r_eq_tr post1980_r_housing_tr ///
	using "${rore}/bld/tables/bycountry/pres_globaleqhous.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \footnotesize \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_6cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{Full Sample} & \multicolumn{2}{c}{Post 1950} & \multicolumn{2}{c}{Post 1980}\\" ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5} \cmidrule(l{`lsp'}r{`lsp'}){6-7}" ///
	"& Equity & Housing & Equity & Housing & Equity & Housing \\ \hline") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_eq_tr full_r_housing_tr post1950_r_eq_tr post1950_r_housing_tr ///
	post1980_r_eq_tr post1980_r_housing_tr if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/pres_globaleqhous.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{7}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{7}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns." ///
	" Period coverage differs across countries. Consistent coverage within countries: each country-year" ///
	" observation used to compute the statistics in this table has data for both real housing and equity returns." ///
	" The average, unweighted and average, weighted figures are respectively the unweighted and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")

copy "${rore}/bld/tables/bycountry/pres_globaleqhous.tex" "${qje_tables}/Table_07.tex", replace
	
* Presentation
listtex country full_r_eq_tr full_r_housing_tr post1950_r_eq_tr post1950_r_housing_tr ///
	post1980_r_eq_tr post1980_r_housing_tr ///
	using "${rore}/bld/tables/bycountry/altpres_globaleqhous.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \scriptsize \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_6cols'\hline \hline \\ [-2mm]" ///
	"Country & \multicolumn{2}{c}{Full Sample} & \multicolumn{2}{c}{Post 1950} & \multicolumn{2}{c}{Post 1980}\\" ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5} \cmidrule(l{`lsp'}r{`lsp'}){6-7}" ///
	"& Equity & Housing & Equity & Housing & Equity & Housing \\ \hline") ///
	foot("\hline \\ [-2mm]")
listtex country full_r_eq_tr full_r_housing_tr post1950_r_eq_tr post1950_r_housing_tr ///
	post1980_r_eq_tr post1980_r_housing_tr if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/altpres_globaleqhous.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{7}{l}{" "} \\ [-2mm]" ///
	" \multicolumn{7}{@{} p{\textwidth}}{\scriptsize\textit{Note}: Average annual real returns. Period coverage differs across countries.}" ///
	"\end{tabularx} }")
		

* Excluding wars
listtex country full_r_eq_tr full_r_housing_tr nowar_r_eq_tr nowar_r_housing_tr ///
	using "${rore}/bld/tables/bycountry/nowar_globaleqhous.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,max width=\textwidth}" ///
	"{ `tabx_4cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{Full Sample} & \multicolumn{2}{c}{Excluding wars}\\" ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5}" ///
	"& Equity & Housing & Equity & Housing \\ \hline") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_eq_tr full_r_housing_tr nowar_r_eq_tr nowar_r_housing_tr if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/nowar_globaleqhous.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{5}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{5}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns." ///
	" Returns excluding wars omit periods 1914---1919 and 1939---1947. Period coverage differs across countries." ///
	" Consistent coverage within countries: each country-year" ///
	" observation used to compute the statistics in this table has data for both real housing and equity returns." ///
	" The average, unweighted and average, weighted figures are respectively the " ///
	" unweighted and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")
	
copy "${rore}/bld/tables/bycountry/nowar_globaleqhous.tex" "${qje_tables}/Table_A05.tex", replace
	
* During wars
listtex country ww1_r_eq_tr_max ww1_r_housing_tr_max ww2_r_eq_tr_max ww2_r_housing_tr_max ///
	using "${rore}/bld/tables/bycountry/wars_globaleqhous.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,max width=\textwidth}" ///
	"{ `tabx_4cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{World War 1} & \multicolumn{2}{c}{World War 2}\\ " ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5}" ///
	"& Equity & Housing & Equity & Housing \\ \hline") ///
	foot("\hline \\ [`tsp']")
listtex country ww1_r_eq_tr_max ww1_r_housing_tr_max ww2_r_eq_tr_max ww2_r_housing_tr_max if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/wars_globaleqhous.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{5}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{5}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns." ///
	" We include one year from the immediate aftermath of the war, such that World war 1 covers" ///
	" years 1914---1919, and World War 2 -- 1939---1946. Period coverage differs across and within countries." ///
	" We exclude World War 2 periods for Italy and Japan because of hyperinflation." ///
	" The average, unweighted and average, weighted figures are respectively the unweighted" ///
	" and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")
	
copy "${rore}/bld/tables/bycountry/wars_globaleqhous.tex" "${qje_tables}/Table_A03.tex", replace
	
* 3/ Risky vs safe xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
listtex country full_r_risky_tr full_r_safe_tr post1950_r_risky_tr post1950_r_safe_tr ///
	post1980_r_risky_tr post1980_r_safe_tr ///
	using "${rore}/bld/tables/bycountry/pres_globalrs.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_6cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{Full Sample} & \multicolumn{2}{c}{Post 1950} & \multicolumn{2}{c}{Post 1980}\\" ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5} \cmidrule(l{`lsp'}r{`lsp'}){6-7}" ///
	"& Risky return & Safe return & Risky return & Safe return & Risky return & Safe return \\ \hline") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_risky_tr full_r_safe_tr post1950_r_risky_tr post1950_r_safe_tr ///
	post1980_r_risky_tr post1980_r_safe_tr if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/pres_globalrs.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{7}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{7}{@{} p{\textwidth}}{`foot_size2'\textit{Note}: Average annual real returns." ///
	" Real risky return is a weighted average of equity and housing, and safe return - of bonds and bills." ///
	" The weights correspond to the shares of the respective asset in the country's wealth portfolio." ///
	" Period coverage differs across countries. Consistent coverage within countries: each country-year" ///
	" observation used to compute the statistics in this table has data for both the risky and safe return." ///
	" The average, unweighted and average, weighted figures are respectively the unweighted and" ///
	" real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")


* 3-2/ Risky vs safe: different subperiods, for paper
listtex country full_r_risky_tr full_r_safe_tr post50to80_r_risky_tr post50to80_r_safe_tr ///
	post1980_r_risky_tr post1980_r_safe_tr  ///
	using "${rore}/bld/tables/bycountry/paper_globalrs.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_6cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{Full Sample} & \multicolumn{2}{c}{1950--1980} & \multicolumn{2}{c}{Post 1980} \\ " ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5} \cmidrule(l{`lsp'}r{`lsp'}){6-7}" ///
	"& Risky return & Safe return & Risky return & Safe return & Risky return & Safe return \\ \hline") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_risky_tr full_r_safe_tr post50to80_r_risky_tr post50to80_r_safe_tr ///
	post1980_r_risky_tr post1980_r_safe_tr if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/paper_globalrs.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{7}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{7}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns." ///
	" Real risky return is a weighted average of equity and housing, and safe return - of bonds and bills." ///
	" The weights correspond to the shares of the respective asset in the country's wealth portfolio." ///
	" Period coverage differs across countries. Consistent coverage within countries: each country-year" ///
	" observation used to compute the statistics in this table has data for both the risky and safe return." ///
	" The average, unweighted and average, weighted figures are respectively the unweighted and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")

copy "${rore}/bld/tables/bycountry/paper_globalrs.tex" "${qje_tables}/Table_11.tex", replace
	
* Excluding wars
listtex country full_r_risky_tr full_r_safe_tr nowar_r_risky_tr nowar_r_safe_tr ///
	using "${rore}/bld/tables/bycountry/nowar_globalrs.tex" if num<=`lim', replace ///
	rstyle(tabular) head(" \centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,max width=\textwidth}" ///
	"{ `tabx_4cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{Full Sample} & \multicolumn{2}{c}{Excluding wars}\\ " ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5}" ///
	"& Risky return & Safe return & Risky return & Safe return \\ \hline") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_risky_tr full_r_safe_tr nowar_r_risky_tr nowar_r_safe_tr if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/nowar_globalrs.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{5}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{5}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns." ///
	" Returns excluding wars omit periods 1914---1919 and 1939---1947. Real risky return is" ///
	" a weighted average of equity and housing, and safe return - of bonds and bills." ///
	" The weights correspond to the shares of the respective asset in the country's wealth portfolio." ///
	" Period coverage differs across countries. Consistent coverage within countries: each country-year" ///
	" observation used to compute the statistics in this table has data for both the risky and safe return." ///
	" The average, unweighted and average, weighted figures are respectively the unweighted and" ///
	" real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")

copy "${rore}/bld/tables/bycountry/nowar_globalrs.tex" "${qje_tables}/Table_A06.tex", replace

* 4/ R vs G xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
listtex country full_r_capital_tr full_rgdp_growth post1950_r_capital_tr post1950_rgdp_growth ///
	post1980_r_capital_tr post1980_rgdp_growth ///
	using "${rore}/bld/tables/bycountry/pres_globalrg.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_6cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{Full Sample} & \multicolumn{2}{c}{Post 1950} & \multicolumn{2}{c}{Post 1980}\\" ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5} \cmidrule(l{`lsp'}r{`lsp'}){6-7}" ///
	"& Return on wealth & GDP growth & Return on wealth & GDP growth & Return on wealth & GDP growth \\ \hline ") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_capital_tr full_rgdp_growth post1950_r_capital_tr post1950_rgdp_growth ///
	post1980_r_capital_tr post1980_rgdp_growth if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/pres_globalrg.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{7}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{7}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns." ///
	" Real return on wealth is a weighted average of bonds, bills, equity and housing." ///
	" The weights correspond to the shares of the respective asset in each country's wealth portfolio." ///
	" Period coverage differs across countries. Consistent coverage within countries: each country-year" ///
	" observation used to compute the statistics in this table has data for both the real return" ///
	" on wealth and the real GDP growth rate." ///
	" The average, unweighted and average, weighted figures are respectively the unweighted and" ///
	" real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")
	
copy "${rore}/bld/tables/bycountry/pres_globalrg.tex" "${qje_tables}/Table_12.tex", replace

* Excluding wars
listtex country full_r_capital_tr full_rgdp_growth nowar_r_capital_tr nowar_rgdp_growth ///
	using "${rore}/bld/tables/bycountry/nowar_globalrg.tex" if num<=`lim', replace ///
	rstyle(tabular) head(" \centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,max width=\textwidth}" ///
	"{ `tabx_4cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{Full Sample} & \multicolumn{2}{c}{Excluding wars}\\ " ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5}" ///
	"& Return on wealth & GDP growth & Return on wealth & GDP growth \\ \hline") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_capital_tr full_rgdp_growth nowar_r_capital_tr nowar_rgdp_growth if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/nowar_globalrg.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{5}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{5}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns." ///
	" Returns excluding wars omit periods 1914---1919 and 1939---1947. Real return on wealth" ///
	" is a weighted average of bonds, bills, equity and housing. The weights correspond to the" ///
	" shares of the respective asset in each country's wealth portfolio. Period coverage" ///
	" differs across countries. Consistent coverage within countries: each country-year" ///
	" observation used to compute the statistics in this table has data for both the real return" ///
	" on wealth and the real GDP growth rate." ///
	" The average, unweighted and average, weighted figures are respectively the unweighted and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")
	
copy "${rore}/bld/tables/bycountry/nowar_globalrg.tex" "${qje_tables}/Table_A07.tex", replace

* 5/ USD returns xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
listtex country full_usd_r_bill_rate full_usd_r_bond_tr full_usd_r_eq_tr full_usd_r_housing_tr ///
	using "${rore}/bld/tables/bycountry/usd_country_returns.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_4cols'\hline \hline \\ [`tsp']" ///
	"Country & Bills & Bonds & Equity & Housing \\ \hline ") ///
	foot("\hline \\ [`tsp']")
listtex country full_usd_r_bill_rate full_usd_r_bond_tr full_usd_r_eq_tr full_usd_r_housing_tr if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/usd_country_returns.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{5}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{5}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real US-Dollar returns. Calculated as nominal US-Dollar return minus US inflation. Period coverage differs across countries. Consistent coverage within countries. The average, unweighted and average, weighted figures are respectively the unweighted and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")
	
copy "${rore}/bld/tables/bycountry/usd_country_returns.tex" "${qje_tables}/Table_A15.tex", replace
	
* 6/ Maximum / inconsistent sample xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
listtex country full_r_bill_rate_max full_r_bond_tr_max full_r_eq_tr_max full_r_housing_tr_max ///
	using "${rore}/bld/tables/bycountry/longest_sample_returns.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \footnotesize \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_4cols'\hline \hline \\ [`tsp']" ///
	"Country & Bills & Bonds & Equity & Housing \\ \hline ") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_bill_rate_max full_r_bond_tr_max full_r_eq_tr_max full_r_housing_tr_max if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/longest_sample_returns.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{5}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{5}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns. Longest possible sample used for each asset class, i.e. returns are not consistent across assets or within countries. The average, unweighted and average, weighted figures are respectively the unweighted and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")
	
copy "${rore}/bld/tables/bycountry/longest_sample_returns.tex" "${qje_tables}/Table_A01.tex", replace
	
* 7/ Minimum / consistent sample xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
listtex country full_r_bill_rate_min full_r_bond_tr_min full_r_eq_tr_min full_r_housing_tr_min ///
	using "${rore}/bld/tables/bycountry/shortest_sample_returns.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \footnotesize \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_4cols'\hline \hline \\ [`tsp']" ///
	"Country & Bills & Bonds & Equity & Housing \\ \hline ") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_bill_rate_min full_r_bond_tr_min full_r_eq_tr_min full_r_housing_tr_min if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/shortest_sample_returns.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{5}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{5}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns. Returns consistent within countries, i.e. each yearly observation for a country has data on each of the four asset classes. The average, unweighted and average, weighted figures are respectively the unweighted and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")

copy "${rore}/bld/tables/bycountry/shortest_sample_returns.tex" "${qje_tables}/Table_A02.tex", replace
	
* 8/ No Global Financial Crisis xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
listtex country nogfc_r_bill_rate nogfc_r_bond_tr nogfc_r_eq_tr nogfc_r_housing_tr ///
	using "${rore}/bld/tables/bycountry/nogfc_returns.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_4cols'\hline \hline \\ [`tsp']" ///
	"Country & Bills & Bonds & Equity & Housing \\ \hline ") ///
	foot("\hline \\ [`tsp']")
listtex country nogfc_r_bill_rate nogfc_r_bond_tr nogfc_r_eq_tr nogfc_r_housing_tr if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/nogfc_returns.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{5}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{5}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns excluding the" ///
	" Global Financial Crisis (i.e. sample ends in 2007). Period coverage differs across countries." ///
	" Consistent coverage within countries: each country-year observation used to compute" ///
	" the statistics in this table has data for returns on all four asset classes." ///
	" The average, unweighted and average, weighted figures are respectively the unweighted and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")
	
copy "${rore}/bld/tables/bycountry/nogfc_returns.tex" "${qje_tables}/Table_A08.tex", replace
	
* 9/ Full vs GFC; risky and safe xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
listtex country full_r_risky_tr full_r_safe_tr nogfc_r_risky_tr nogfc_r_safe_tr ///
	using "${rore}/bld/tables/bycountry/nogfc_sr.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_4cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{Full Sample} & \multicolumn{2}{c}{Excluding the GFC} \\" ///
	" & Risky return & Safe return & Risky return & Safe return \\ \hline ") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_risky_tr full_r_safe_tr nogfc_r_risky_tr nogfc_r_safe_tr  if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/nogfc_sr.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{5}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{5}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns" ///
	" excluding the Global Financial Crisis (i.e. sample ends in 2007). Real risky return is" ///
	" a weighted average of equity and housing, and safe return - of bonds and bills." ///
	" The weights correspond to the shares of the respective asset in the country's" ///
	" wealth portfolio. Period coverage differs across countries. Consistent coverage" ///
	" within countries: each country-year observation used to compute" ///
	" the statistics in this table has data for both the real risky and the real safe return." ///
	" The average, unweighted and average, weighted figures are respectively the unweighted and" ///
	" real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")
	
copy "${rore}/bld/tables/bycountry/nogfc_sr.tex" "${qje_tables}/Table_A09.tex", replace

* 10/ Simple weighting xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
listtex country full_r_risky_tr full_r_capital_tr full_rr_simple full_rc_simple ///
	using "${rore}/bld/tables/bycountry/simple_weights.tex" if num<=`lim', replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_4cols'\hline \hline \\ [`tsp']" ///
	"Country & \multicolumn{2}{c}{Portfolio weights} & \multicolumn{2}{c}{Equal weights} \\" ///
	"\cmidrule(l{`lsp'}r{`lsp'}){2-3} \cmidrule(l{`lsp'}r{`lsp'}){4-5}" ///
	" & Risky return & Return on wealth & Risky return & Return on wealth \\ \hline ") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_risky_tr full_r_capital_tr full_rr_simple full_rc_simple if num >`lim', ///
	appendto("${rore}/bld/tables/bycountry/simple_weights.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{5}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{5}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real returns" ///
	" for the full sample. The portfolio-weighted averages use country-specific stocks of housing," ///
	" equity, bonds and bills as weights for the individual asset returns. Portfolio-weighted" ///
	" risky return is a weighted average of housing and equity, using stock market capitalization" ///
	" and hosuing wealth as weights. Portfolio-weighted real return on wealth is a weighted average" ///
	" of equity, housing, bonds and bills, using stock market capitalization, housing wealth and" ///
	" public debt stock as weights. Equally-weighted risky return is an unweighted average" ///
	" of housing an equity. Equally-weighted return on wealth is an unweighted average" ///
	" of housing, equity and bonds. Period coverage differs across countries." ///
	" Consistent coverage within countries: each country-year observation used to compute" ///
	" the statistics in this table has data for both the real risky return, and the return" ///
	" on overall wealth. The average, unweighted and average, weighted figures are respectively" ///
	" the unweighted and real-GDP-weighted arithmetic averages of individual country returns.}" ///
	"\end{tabularx} }")
	
copy "${rore}/bld/tables/bycountry/simple_weights.tex" "${qje_tables}/Table_A25.tex", replace
	
* 11/ Risky rate ranked by country xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
gen neg = -full_r_risky_tr
sort neg
qui gen newnum = _n
su newnum if iso == "WORLD_uw"
local lim2 = r(mean)
listtex country full_r_risky_tr_max post1950_r_risky_tr post1980_r_risky_tr ///
	using "${rore}/bld/tables/bycountry/risky_ranked.tex" if newnum < `lim2' & iso != "WORLD_gdpw", replace ///
	rstyle(tabular) head("\centering \small \adjustbox{max height=\dimexpr\textheight-1.5cm\relax,width=\textwidth}" ///
	"{  `tabx_3cols'\hline \hline \\ [`tsp']" ///
	"Country & Full sample & Post-1950 & Post-1980 \\ \hline ") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_risky_tr post1950_r_risky_tr post1980_r_risky_tr if newnum ==`lim2' & iso != "WORLD_gdpw", ///
	appendto("${rore}/bld/tables/bycountry/risky_ranked.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline \\ [`tsp']")
listtex country full_r_risky_tr post1950_r_risky_tr post1980_r_risky_tr if newnum >`lim2' & iso != "WORLD_gdpw", ///
	appendto("${rore}/bld/tables/bycountry/risky_ranked.tex") ///
	rstyle(tabular) head("") ///
	foot("\hline\hline" ///
	" \multicolumn{4}{l}{" "} \\ [`fsp']" ///
	" \multicolumn{4}{@{} p{\textwidth}}{`foot_size'\textit{Note}: Average annual real risky returns." ///
	" Real risky return is a weighted average of equity and housing. The weights" ///
	" correspond to the shares of the respective asset in the country's wealth portfolio." ///
	" Period coverage differs across countries. The ``Average, unweighted'' figure is the" ///
	" unweighted arithmetic average of individual country returns.}" ///
	"\end{tabularx} }")

copy "${rore}/bld/tables/bycountry/risky_ranked.tex" "${qje_tables}/Table_A16.tex", replace
