/*--------------------------------------------------------------

   World returns by asset class: bar charts

----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"



include paths


*========================== Settings =============================================

* Variables to plot
local tocollapse r_bill_rate r_bond_tr r_eq_tr r_housing_tr excess_bond_tr excess_eq_tr excess_housing_tr
local nvar : word count `tocollapse'

* Colours
local colour edkblue
local colour2 eltblue
* Periods to consider:
*	First we take time splits that are consistent within country only
*	Second, as a consistency check, we take periods that are consistent both within and across countries
local periods "full post1900 post1950 post1980 cons1 cons2 cons3 cons4 nowar"
local conds ""if sample ==1" "if sample ==1 & tp_post1900 == 1" "if sample ==1 & tp_post1950 == 1" "if sample ==1 & tp_post1980 == 1" "if sample == 1 & cons1==1" "if sample == 1 & cons2==1" "if sample == 1 & cons3==1" "if sample == 1 & cons4==1" "if sample == 1 & tp_nowar==1""
local perlabs ""Full sample" "Post-1900" "Post-1950" "Post-1980" "Post-1890 (7 countries)" "Post-1910 (12 countries)" "Post-1930 (15 countries)" "Post-1948 (16 countries)" "Full sample, no wars""

* Weights
local weight_types "uw gdpw"
local weight_conds """ "[iw = weight]"
local weight_labs ""Unweighted" "GDP-weighted""

local nper : word count `periods'
local nweight : word count `weight_types'

*========================== Calcualte summary statistics ===========================

* Here we calculate average returns. First calculate, then reshape long so that we have type of asset as "x variable" in rows.
*	Then calculate again to have type of asset as stata variable in colums. That way we can make a 2x2 return comparison

* Outer loop: weights
forvalues j = 1/`nweight'	{
	* Load parameters for weightings
	local w`j' : word `j' of `weight_types'
	local condw`j' : word `j' of `weight_conds'

* Inner loop: periods
forvalues i = 1/`nper'	{

	* Load parameters for periods
	local per`i' : word `i' of `periods'
	local cond`i' : word `i' of `conds'

	* 1/ Generate row variables with mean returns for each asset class; for this particular period ==========================
	* Import data
	use "${rore}/bld/data_out/rore_core_dataset.dta", clear
	* Choose sample
	keep `cond`i''

	foreach s of local tocollapse	{
		replace `s' = `s'*100
	}

	collapse (mean) `tocollapse' `condw`j'', by(year)
	collapse (mean) `tocollapse'

	* Rename before reshaping: change this manually if change variables
	ren (r_bill_rate r_bond_tr r_eq_tr r_housing_tr excess_bond_tr excess_eq_tr excess_housing_tr) ///
		(`per`i''_`w`j''_r_tr1 `per`i''_`w`j''_r_tr2 `per`i''_`w`j''_r_tr3 `per`i''_`w`j''_r_tr4 ///
		`per`i''_`w`j''_er2 `per`i''_`w`j''_er3 `per`i''_`w`j''_er4)

	gen country = "World"

	reshape long `per`i''_`w`j''_r_tr `per`i''_`w`j''_er, i(country) j(id)

	* Interim save -----------------------------------
	if `i' == 1 & `j' == 1	{
	* First time save
		save "${rore}/bld/data_out/rore_chart_data.dta", replace
	}
	if (`i' > 1	| `j' > 1) {
	* Or append to previously summarised data
		merge 1:1 country id using "${rore}/bld/data_out/rore_chart_data.dta", generate(_merge_`i'`j'1)
		save "${rore}/bld/data_out/rore_chart_data.dta", replace
	}

	
	* 2/ Generate column variables with mean returns for each asset class; for this particular period ==========================
	use "${rore}/bld/data_out/rore_core_dataset.dta", clear

	keep `cond`i''

	collapse (mean) `tocollapse' `condw`j'', by(year)
	collapse (mean) `tocollapse'

	foreach s of local tocollapse	{
		replace `s' = `s'*100
		ren `s' `per`i''_`w`j''_`s'
	}

	gen id = 1

	merge 1:1 id using "${rore}/bld/data_out/rore_chart_data.dta", generate(_merge_`i'`j'2)

	foreach s of local tocollapse	{
		replace `per`i''_`w`j''_`s' = `per`i''_`w`j''_`s'[_n-1] if `per`i''_`w`j''_`s' ==.
	}

	gen `per`i''_`w`j''_r_bill_rate_abs = abs(`per`i''_`w`j''_r_bill_rate)
	gen `per`i''_`w`j''_er_dif = `per`i''_`w`j''_er - `per`i''_`w`j''_r_bill_rate
	gen `per`i''_`w`j''_r_tr_dif = `per`i''_`w`j''_r_tr - `per`i''_`w`j''_r_bill_rate
	*replace `per`i''_er = 0 if id == 1
	
	* Interim save -----------------------------------
	save "${rore}/bld/data_out/rore_chart_data.dta", replace

}
}

* Standard deviation

forvalues i = 1/`nper'	{

	* Load parameters for periods
	local per`i' : word `i' of `periods'
	local cond`i' : word `i' of `conds'
	
	use "${rore}/bld/data_out/rore_core_dataset.dta", clear
	
	tabstat `tocollapse' `cond`i'', columns(variable) ///
				stat(sd ) save
	mat `per`i''arith=r(StatTotal)
	
	forvalues j = 1/`nvar'	{
		local v`j' : word `j' of `tocollapse'
		* Save standard deviation (multiply by 100 for scaling)
		gen `per`i''_sd_`v`j'' = 100*`per`i''arith[1,`j']
	}
	
	* Prepare for merging with return summary data
	gen id = _n
	drop if _n > 4
	
	* Append to the dataset
	keep id `per`i''_sd*
	merge 1:1 id using "${rore}/bld/data_out/rore_chart_data.dta", gen(_merge`i')
	drop _merge`i'
	
	save "${rore}/bld/data_out/rore_chart_data.dta", replace
}




gen base = 0


*========================== Plot graphs =============================================

* Settings xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
local colour edkblue
local size medlarge
local size2 large
local size3 small

* Outer loop: weights
forvalues j = 1/`nweight'	{

	* Load parameters for weightings
	local w`j' : word `j' of `weight_types'
	local wl`j' : word `j' of `weight_labs'

	* Inner loop: periods
	forvalues i = 1/`nper'	{

		* 1/ Load parameters for periods xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
		local per`i' : word `i' of `periods'
		local lab`i' : word `i' of `perlabs'
		
		* 2/ Return graphs with period-specific labels xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
		* For 2x1 graphs, medium-size legends
		if strpos("`per`i''","cons") == 0	{
			twoway (rbar base `per`i''_`w`j''_r_bill_rate id, color(dkgreen) fint(full) barwidth(0.33)  horizontal) ///
			 (rbar `per`i''_`w`j''_r_tr `per`i''_`w`j''_r_bill_rate_abs id if  `per`i''_`w`j''_r_bill_rate>=0, color(`colour2') fint(full) barwidth(0.33) horizontal) ///
			 (rbar `per`i''_`w`j''_r_tr_dif `per`i''_`w`j''_r_bill_rate_abs id if  `per`i''_`w`j''_r_bill_rate<0, color(`colour2') fint(full) barwidth(0.33) horizontal) ///
			 (rbar `per`i''_`w`j''_r_bill_rate_abs `per`i''_`w`j''_r_bill_rate id if  id==1, color(dkgreen) fint(full) barwidth(0.33) horizontal) ///
			 (dot `per`i''_`w`j''_r_tr id if id >1, msymbol(D) color(orange) horizontal), ///
			  title("`lab`i''", size(`size2'))  scheme(s1color) /// 
			 ylabel(1 "Bills" 2 "Bonds" 3 "Equity" 4 "Housing", angle(fourty_five) labgap(vsmall) labsize(`size2') ) ytitle("") ///
			 xline(0, lcolor(gs12)) ///
			 xtitle("Mean annual return, per cent", size(`size2')) ///
			 legend( order(1 "Bills" 2 "Excess Return vs Bills" 5 "Mean Annual Return") size(`size') rows(1)) ///
			 xlabel(,labsize(`size2')) name(Ret_`per`i''_`w`j'', replace)   nodraw
		 }
		* For 2x2 graphs, larger legends
		if strpos("`per`i''","cons") > 0	{
			twoway (rbar base `per`i''_`w`j''_r_bill_rate id, color(dkgreen) fint(full) barwidth(0.33)  horizontal) ///
			 (rbar `per`i''_`w`j''_r_tr `per`i''_`w`j''_r_bill_rate_abs id if  `per`i''_`w`j''_r_bill_rate>=0, color(`colour2') fint(full) barwidth(0.33) horizontal) ///
			 (rbar `per`i''_`w`j''_r_tr_dif `per`i''_`w`j''_r_bill_rate_abs id if  `per`i''_`w`j''_r_bill_rate<0, color(`colour2') fint(full) barwidth(0.33) horizontal) ///
			 (rbar `per`i''_`w`j''_r_bill_rate_abs `per`i''_`w`j''_r_bill_rate id if  id==1, color(dkgreen) fint(full) barwidth(0.33) horizontal) ///
			 (dot `per`i''_`w`j''_r_tr id if id >1, msymbol(D) color(orange) horizontal), ///
			  title("`lab`i''", size(`size2'))  scheme(s1color) /// 
			 ylabel(1 "Bills" 2 "Bonds" 3 "Equity" 4 "Housing", angle(fourty_five) labgap(vsmall) labsize(`size2') ) ytitle("") ///
			 xline(0, lcolor(gs12)) ///
			 xtitle("Mean annual return, per cent", size(`size2')) ///
			 legend( order(1 "Bills" 2 "Excess Return vs Bills" 5 "Mean Annual Return") size(`size3') rows(1)) ///
			 xlabel(,labsize(`size2')) name(Ret_`per`i''_`w`j'', replace) nodraw
		 }
	 
		 * Some graphs only do for selected periods, to save time
		 
		 * 3/ Risk-return tradeoff graphs  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
		 if ("`per`i''" == "full") & "`w`j''" == "uw"	{
			* 3-1/ Return, diff. label  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
			 twoway (rbar base `per`i''_`w`j''_r_bill_rate id, color(dkgreen) fint(full) barwidth(0.33)  horizontal) ///
				 (rbar `per`i''_`w`j''_r_tr `per`i''_`w`j''_r_bill_rate_abs id if  `per`i''_`w`j''_r_bill_rate>=0, color(`colour2') fint(full) barwidth(0.33) horizontal) ///
				 (rbar `per`i''_`w`j''_r_tr_dif `per`i''_`w`j''_r_bill_rate_abs id if  `per`i''_`w`j''_r_bill_rate<0, color(`colour2') fint(full) barwidth(0.33) horizontal) ///
				 (rbar `per`i''_`w`j''_r_bill_rate_abs `per`i''_`w`j''_r_bill_rate id if  id==1, color(dkgreen) fint(full) barwidth(0.33) horizontal), ///
				 title("Real returns", size(`size2'))  scheme(s1color) /// 
				 ylabel(1 "Bills" 2 "Bonds" 3 "Equity" 4 "Housing", angle(fourty_five) labgap(vsmall) labsize(`size2') ) ytitle("") ///
				 xline(0, lcolor(gs12)) ///
				 xtitle("", size(`size2')) ///
				 legend(off) ///
				 xlabel(,labsize(`size2')) name(Ret_`per`i''_`w`j''_diflab, replace) nodraw
		 
			* 3-2/ Standard deviation  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
			 twoway (rbar base `per`i''_sd_r_bill_rate id if id == 1, color(`colour') fint(full) barwidth(0.33)  horizontal) ///
				 (rbar base `per`i''_sd_r_bond_tr id if id == 2, color(`colour') fint(full) barwidth(0.33) horizontal) ///
				 (rbar base `per`i''_sd_r_eq_tr id if id == 3, color(`colour') fint(full) barwidth(0.33) horizontal) ///
				 (rbar base `per`i''_sd_r_housing_tr id if id == 4, color(`colour') fint(full) barwidth(0.33) horizontal), ///
				 title("Standard deviation", size(`size2'))  scheme(s1color) /// 
				 ylabel(1 "Bills" 2 "Bonds" 3 "Equity" 4 "Housing", angle(fourty_five) labgap(vsmall) labsize(`size2') ) ytitle("") ///
				 xline(0, lcolor(gs12)) ///
				 xtitle("", size(`size2')) ///
				 legend(off) ///
				 xlabel(,labsize(`size2')) name(sd_`per`i'', replace) nodraw
		 }
		 
		 * 4/ Graph without labels: for weighted/unweighted in one chart xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx	 
		 if "`per`i''" == "full" | "`per`i''" == "post1950" {
			 twoway (rbar base `per`i''_`w`j''_r_bill_rate id, color(dkgreen) fint(full) barwidth(0.33)  horizontal) ///
			 (rbar `per`i''_`w`j''_r_tr `per`i''_`w`j''_r_bill_rate_abs id if  `per`i''_`w`j''_r_bill_rate>=0, color(`colour2') fint(full) barwidth(0.33) horizontal) ///
			 (rbar `per`i''_`w`j''_r_tr_dif `per`i''_`w`j''_r_bill_rate_abs id if  `per`i''_`w`j''_r_bill_rate<0, color(`colour2') fint(full) barwidth(0.33) horizontal) ///
			 (rbar `per`i''_`w`j''_r_bill_rate_abs `per`i''_`w`j''_r_bill_rate id if  id==1, color(dkgreen) fint(full) barwidth(0.33) horizontal) ///
			 (dot `per`i''_`w`j''_r_tr id if id >1, msymbol(D) color(orange) horizontal), ///
			  title("", size(`size2'))  scheme(s1color) /// 
			 ylabel(1 "Bills" 2 "Bonds" 3 "Equity" 4 "Housing", angle(fourty_five) labgap(small) labsize(`size') ) ytitle("") ///
			 xline(0, lcolor(gs12)) ///
			 xtitle("Mean annual return, per cent", size(`size')) ///
			 legend( order(1 "Bills" 2 "Excess Return vs Bills" 5 "Mean Annual Return") size(`size') ring(0) position(5) rows(1)) ///
			 xlabel(,labsize(`size')) name(Ret_`per`i''_`w`j''_nolab, replace) nodraw
		 }
		 * 5/ Graph with weighting labels: excluding wars xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx	 
		 if "`per`i''" == "nowar" | "`per`i''" == "post1950" {
			 twoway (rbar base `per`i''_`w`j''_r_bill_rate id, color(dkgreen) fint(full) barwidth(0.33)  horizontal) ///
			 (rbar `per`i''_`w`j''_r_tr `per`i''_`w`j''_r_bill_rate_abs id if  `per`i''_`w`j''_r_bill_rate>=0, color(`colour2') fint(full) barwidth(0.33) horizontal) ///
			 (rbar `per`i''_`w`j''_r_tr_dif `per`i''_`w`j''_r_bill_rate_abs id if  `per`i''_`w`j''_r_bill_rate<0, color(`colour2') fint(full) barwidth(0.33) horizontal) ///
			 (rbar `per`i''_`w`j''_r_bill_rate_abs `per`i''_`w`j''_r_bill_rate id if  id==1, color(dkgreen) fint(full) barwidth(0.33) horizontal) ///
			 (dot `per`i''_`w`j''_r_tr id if id >1, msymbol(D) color(orange) horizontal), ///
			  title("`wl`j''", size(`size2'))  scheme(s1color) /// 
			 ylabel(1 "Bills" 2 "Bonds" 3 "Equity" 4 "Housing", angle(fourty_five) labgap(small) labsize(`size') ) ytitle("") ///
			 xline(0, lcolor(gs12)) ///
			 xtitle("Mean annual return, per cent", size(`size')) ///
			 legend( order(1 "Bills" 2 "Excess Return vs Bills" 5 "Mean Annual Return") size(`size') ring(0) position(5) rows(1)) ///
			 xlabel(,labsize(`size')) name(Ret_`per`i''_`w`j''_weightlab, replace) nodraw
		 }
		 
	}

	* 5/ 2x1 panels; GDP-weighted vs unweighted; post-1950 vs current xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
	* 5-1/ Returns by period, consistent within country only
	grc1leg Ret_full_`w`j'' Ret_post1950_`w`j'', legendfrom(Ret_full_`w`j'') ///
	 scheme(s1color) xcommon iscale(*1.1) name(Ret_`w`j''_summary, replace)
	graph display Ret_`w`j''_summary, xsize(20) ysize(11)
	graph export "${rore}/bld/graphs/world/bar_charts/png/Ret_`w`j''_summary.png", width(2500) height(1200) replace
	graph export "${rore}/bld/graphs/world/bar_charts/Ret_`w`j''_summary.pdf", replace
	if "`w`j''" == "uw"	{
		graph export "${qje_figures}/Figure_02.pdf", replace
	}
	if "`w`j''" == "gdpw"	{
		graph export "${qje_figures}/Figure_A01.pdf", replace
	}
	window manage close graph
	
	* 5-2/ Robustness check: returns consistent across countries
	grc1leg Ret_cons1_`w`j'' Ret_cons2_`w`j'' Ret_cons3_`w`j'' Ret_cons4_`w`j'', legendfrom(Ret_cons1_`w`j'') ///
	 scheme(s1color) xcommon iscale(*0.8) name(Ret_cons_`w`j'', replace)
	graph display Ret_cons_`w`j'', xsize(20) ysize(15)
	 graph export "${rore}/bld/graphs/world/bar_charts/png/Ret_cons_`w`j''.png", width(2800) height(2000) replace
	 graph export "${rore}/bld/graphs/world/bar_charts/Ret_cons_`w`j''.pdf", replace
	if "`w`j''" == "uw"	{
		graph export "${qje_figures}/Figure_A02.pdf", replace
	}
	  window manage close graph
	  

	  
	
}


* Combine more graphs

* 5-3/ Returns and sd
graph combine Ret_full_uw_diflab sd_full, ///
	 scheme(s1color) iscale(*1.1) name(ret_and_sd, replace)
graph display ret_and_sd, xsize(20) ysize(11)
*graph export "${rore}/bld/graphs/world/bar_charts/extra/png/ret_and_sd.png", width(2800) height(2000) replace
graph export "${rore}/bld/graphs/world/bar_charts/extra/ret_and_sd.pdf", replace
graph close

* 5-4/ Returns excluding wars
grc1leg Ret_nowar_uw_weightlab Ret_nowar_gdpw_weightlab, legendfrom(Ret_nowar_uw_weightlab) ///
	 scheme(s1color) xcommon iscale(*1.1) name(Ret_nowar_summary, replace)
graph display Ret_nowar_summary, xsize(20) ysize(11)
graph export "${rore}/bld/graphs/world/bar_charts/png/Ret_nowar_summary_png.png", width(2500) height(1200) replace
graph export "${rore}/bld/graphs/world/bar_charts/Ret_nowar_summary.pdf", replace
graph export "${qje_figures}/Figure_A03.pdf", replace
graph close

