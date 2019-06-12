use "Data_programs/Data/CountryData.dta", clear

mi unset, asis

keep if frac_native>=.5 & frac_native!=. 


forvalues i=1500(100)1600{
gen ln_pd`i'=ln(1+popd`i')
}

forvalues i=1700(10)1950{
gen ln_pd`i'=ln(1+popd`i')
}


*** Compute OLS coefficients over time

foreach j in ln_pd urbfrac{

	forvalues i=1500(100)1600{
		qui reg `j'`i' kinship_score small_scale, ro
		gen coef_`j'_`i'=_b[kinship_score]
		gen `j'_p_value_`i'=(2 * ttail(e(df_r), abs(_b[kinship_score]/_se[kinship_score])))
		gen `j'_sig_`i'=0
		replace `j'_sig_`i'=1 if `j'_p_value_`i'<0.1
		replace `j'_sig_`i'=2 if `j'_p_value_`i'<0.05
		replace `j'_sig_`i'=3 if `j'_p_value_`i'<0.01

		qui reg `j'`i' kinship_score small_scale colony_*, ro
		gen coef_`j'_col_`i'=_b[kinship_score]
		gen `j'_p_value_col_`i'=(2 * ttail(e(df_r), abs(_b[kinship_score]/_se[kinship_score])))
		gen `j'_sig_col_`i'=0
		replace `j'_sig_col_`i'=1 if `j'_p_value_col_`i'<0.1
		replace `j'_sig_col_`i'=2 if `j'_p_value_col_`i'<0.05
		replace `j'_sig_col_`i'=3 if `j'_p_value_col_`i'<0.01
	}

	
	
	forvalues i=1700(10)1950{
		qui reg `j'`i' kinship_score small_scale, ro
		gen coef_`j'_`i'=_b[kinship_score]
		gen `j'_p_value_`i'=(2 * ttail(e(df_r), abs(_b[kinship_score]/_se[kinship_score])))
		gen `j'_sig_`i'=0
		replace `j'_sig_`i'=1 if `j'_p_value_`i'<0.1
		replace `j'_sig_`i'=2 if `j'_p_value_`i'<0.05
		replace `j'_sig_`i'=3 if `j'_p_value_`i'<0.01

		qui reg `j'`i' kinship_score small_scale colony_*, ro
		gen coef_`j'_col_`i'=_b[kinship_score]
		gen `j'_p_value_col_`i'=(2 * ttail(e(df_r), abs(_b[kinship_score]/_se[kinship_score])))
		gen `j'_sig_col_`i'=0
		replace `j'_sig_col_`i'=1 if `j'_p_value_col_`i'<0.1
		replace `j'_sig_col_`i'=2 if `j'_p_value_col_`i'<0.05
		replace `j'_sig_col_`i'=3 if `j'_p_value_col_`i'<0.01
	}
}







*** Collapse data

rename *ln_pd* *pd*

collapse coef_* *_sig*

rename *_1* *1*
gen a=0
reshape long coef_urbfrac coef_urbfrac_col coef_pd coef_pd_col urbfrac_sig urbfrac_sig_col pd_sig pd_sig_col, i(a) j(time)

destring time, replace




*** Do plots


twoway (line coef_urbfrac time) (scatter coef_urbfrac time if urbfrac_sig==3,msymbol(Oh) mcolor(red) yline(0,lstyle(grid)))  (scatter coef_urbfrac time if urbfrac_sig==2,msymbol(Dh) mcolor(blue)) (scatter coef_urbfrac time if urbfrac_sig==1,msymbol(Th) mcolor(magenta)) (scatter coef_urbfrac time if urbfrac_sig==0), title("{it:Urbanization rate and kinship tightness}") legend(off) ytitle("Coefficient on kinship tightness") xtitle("Year") graphregion(fcolor(white) lcolor(white))
graph export Source_files/Figs/Urbfrac.pdf, replace

twoway (line coef_pd time, lcolor(navy)) (scatter coef_pd time if pd_sig==3,msymbol(Oh) mcolor(red))  (scatter coef_pd time if pd_sig==2,msymbol(Dh) mcolor(blue)) (scatter coef_pd time if pd_sig==1,msymbol(Th) mcolor(magenta)) (scatter coef_pd time if pd_sig==0,mcolor(green)), title("{it:Log Population density and kinship tightness}") ytitle("Coefficient of kinship tightness") yline(0, lstyle(grid)) xtitle("Year") legend(off) graphregion(fcolor(white) lcolor(white))
graph export Source_files/Figs/Pd.pdf, replace




