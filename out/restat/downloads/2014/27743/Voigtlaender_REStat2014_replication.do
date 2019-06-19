clear
clear matrix
set mem 1000m

*cd "C:\Users\Nico Voigtländer\Dropbox\Many Sectors - Empirical Paper\Final Package REStat\Replication Files"

use "Replicate_Dataset_Voigtlaender2014.dta", clear

quietly{
	gen ln_A_rel = ln(A_rel)
	gen ln_s_A_rel_avg = ln(s_A_rel_avg)
	gen ln_s2d_A_rel_avg = ln(s2d_A_rel_avg)
	gen ln_sNC_A_rel_avg = ln(sNC_A_rel_avg)
	gen lnrvship=ln(rvship)

	////Sector-specific trends:
	egen year_tr=group(year)
	tab Sector, gen(trend_)
	forvalues i=1/358 {
		replace trend_`i' = trend_`i' * year_tr
	}

	tsset Sector year

	/// Lagged Variables
	foreach var of varlist h lnHovL ln_A_rel ln_s_A_rel_avg ln_s2d_A_rel_avg s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff lnrelw {
	egen std_`var'=std(`var')
	gen d1_`var' = `var'-L1.`var'
	gen d5_`var' = `var'-L5.`var'
	}
}

/************************************************************************/
/*REGRESSIONS*/
/************************************************************************/
	
//Table 3
	estimates clear
	quietly{
	eststo: reg h s_h_avg [pweight=weight_emp], robust cluster(Sector) 
	eststo: xtreg h s_h_avg [pweight=weight_emp], fe i(Sector) robust cluster(Sector) 
	eststo: xtreg h s_h_avg dummy_t1-dummy_t48 [pweight=weight_emp], fe i(Sector) robust cluster(Sector) 
	eststo: xtreg h s_h_avg equip_pw OCAMovK HT_diff dummy_t1-dummy_t48 [pweight=weight_emp], fe i(Sector) robust cluster(Sector) 
	eststo: xtreg h s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 [pweight=weight_emp], fe i(Sector) robust cluster(Sector) 
	eststo: xtreg h s2d_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
	}
	esttab using Table3.csv, se star(* 0.1 ** 0.05 *** 0.01) r2 drop(dummy_t*) title(Main Results) compress replace

			*Table 3 regs to obtain R^2 including FE
			areg h s_h_avg [pweight=weight_emp], absorb(Sector) robust cluster(Sector) 
			areg h s_h_avg dummy_t1-dummy_t48 [pweight=weight_emp], absorb(Sector) robust cluster(Sector) 
			areg h s_h_avg equip_pw OCAMovK HT_diff dummy_t1-dummy_t48 [pweight=weight_emp], absorb(Sector) robust cluster(Sector) 
			areg h s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 [pweight=weight_emp], absorb(Sector) robust cluster(Sector) 
			areg h s2d_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)

	
	
//Table 4	
	estimates clear
	quietly{
	eststo: reg h s_h_avg s_h_w_avg80 [pweight=weight_emp], robust cluster(Sector) 
	eststo: xtreg h s_h_avg s_h_w_avg80 [pweight=weight_emp], fe i(Sector) robust cluster(Sector) 
	eststo: xtreg h s_h_avg s_h_w_avg80 dummy_t1-dummy_t48 [pweight=weight_emp], fe i(Sector) robust cluster(Sector) 
	eststo: xtreg h s_h_avg s_h_w_avg80 equip_pw equip_pw80 OCAMovK OCAMovK80 HT_diff HT_diff80 RD_int_lag RD_int_lag80 Outs_na Outs_na80 Outs_diff Outs_diff80 ///
		dummy_t1-dummy_t48 [pweight=weight_emp], fe i(Sector) robust cluster(Sector) 
	eststo: xtreg h s_h_avg s_h_w_avg80 equip_pw equip_pw80 OCAMovK OCAMovK80 HT_diff HT_diff80 RD_int_lag RD_int_lag80 Outs_na Outs_na80 Outs_diff Outs_diff80 /// 
		dummy_t1-dummy_t48 [pweight=weight_emp], fe i(Sector) robust cluster(Sector) 
	eststo: xtreg h s2d_h_avg s2d_h_avg80 equip_pw equip_pw80 OCAMovK OCAMovK80 HT_diff HT_diff80 RD_int_lag RD_int_lag80 Outs_na Outs_na80 Outs_diff Outs_diff80 /// 
		dummy_t1-dummy_t48 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
	}
	esttab using Table4.csv, se star(* 0.1 ** 0.05 *** 0.01) r2 drop(dummy_t*) title(Main Results) compress replace
	
			*Table 4 regs to obtain R^2 including FE
			areg h s_h_avg s_h_w_avg80 [pweight=weight_emp], absorb(Sector) robust cluster(Sector) 
			areg h s_h_avg s_h_w_avg80 dummy_t1-dummy_t48 [pweight=weight_emp], absorb(Sector) robust cluster(Sector) 
			areg h s_h_avg s_h_w_avg80 equip_pw equip_pw80 OCAMovK OCAMovK80 HT_diff HT_diff80 RD_int_lag RD_int_lag80 Outs_na Outs_na80 Outs_diff Outs_diff80 ///
				dummy_t1-dummy_t48 [pweight=weight_emp], absorb(Sector) robust cluster(Sector) 
			areg h s_h_avg s_h_w_avg80 equip_pw equip_pw80 OCAMovK OCAMovK80 HT_diff HT_diff80 RD_int_lag RD_int_lag80 Outs_na Outs_na80 Outs_diff Outs_diff80 /// 
				dummy_t1-dummy_t48 [pweight=weight_emp], absorb(Sector) robust cluster(Sector) 
			areg h s2d_h_avg s2d_h_avg80 equip_pw equip_pw80 OCAMovK OCAMovK80 HT_diff HT_diff80 RD_int_lag RD_int_lag80 Outs_na Outs_na80 Outs_diff Outs_diff80 /// 
				dummy_t1-dummy_t48 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
	

//Table 5
	estimates clear
	quietly{
	eststo: xtreg h sig_h tau_h rho_h dummy_t1-dummy_t48 ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
	eststo: xtreg h sig_h tau_h rho_h equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
	eststo: xtreg h sig_N2d_h tau_N2d_h rho_N2d_h  dummy_t1-dummy_t48 ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
	eststo: xtreg h sig_N2d_h tau_N2d_h rho_N2d_h equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
	eststo: xtreg h s_h  dummy_t1-dummy_t48 ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)	
	eststo: xtreg h s_h equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)		
	}
	esttab using Table5.csv, se star(* 0.1 ** 0.05 *** 0.01) r2 drop(dummy_t*) title(Main Results) compress replace
			
			*Table 5 regs to obtain R^2 including FE	
			areg h sig_h tau_h rho_h dummy_t1-dummy_t48 ///
				if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
			areg h sig_h tau_h rho_h equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 ///
				if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
			areg h sig_N2d_h tau_N2d_h rho_N2d_h  dummy_t1-dummy_t48 ///
				if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
			areg h sig_N2d_h tau_N2d_h rho_N2d_h equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 ///
				if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
			areg h s_h  dummy_t1-dummy_t48 ///
				if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)	
			areg h s_h equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 ///
				if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)	


//Table 6
	estimates clear
	quietly{
	eststo: reg d5_h d5_s_h_avg d5_equip_pw d5_OCAMovK d5_HT_diff d5_RD_int_lag d5_Outs_na d5_Outs_diff dummy_t1-dummy_t48 /// 
		if year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002  [pweight=weight_emp], robust cluster(Sector) 	
	*(2)	
	eststo: xtreg h s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff Indic_inp Inp_Variety lnrelw lnrvship lnTFP vaddshare dummy_t1-dummy_t48 /// 
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)	
	*(3)	
	eststo: xtreg h_w s_h_w_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 /// 
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)	
	*(4)	
	eststo: reg h s2d_h equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff Indic_inp Inp_Variety if year==1967 [pweight=emp], robust	
	*(5)	
	eststo: reg h s2d_h equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff Indic_inp Inp_Variety if year==1992 [pweight=emp], robust	
	*(6)	
	eststo: reg h s2d_h equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff Indic_inp Inp_Variety if year==2002 [pweight=emp], robust	
	}
	esttab using Table6.csv, se star(* 0.1 ** 0.05 *** 0.01) r2 drop(dummy_t*) title(Main Results) compress replace
	

	*To obtain the R^2 including FE:	
		/*(2):*/areg h s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff Indic_inp Inp_Variety lnrelw lnrvship lnTFP vaddshare dummy_t1-dummy_t48 /// 
			if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)	
		/*(3):*/areg h_w s_h_w_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 /// 
			if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_wb], absorb(Sector) robust cluster(Sector)	


/************************************************************************/


//Table 7
	estimates clear
	quietly{
	*(1) unweighted
	eststo: xtreg h s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 /// 
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002, fe i(Sector) robust cluster(Sector)
	*(2) only till 1992 (SIC benchmark years)
	eststo: xtreg h s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 /// 
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)	
	*(3) sector-specific time trends
	eststo: xtreg h s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 /// 
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
	*(4) sector-specific time trends
	eststo: xtreg h s2d_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 /// 
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
	*(5) sector-specific time trends	
	eststo: xtreg h_w s_h_w_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 /// 
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)	
}
	esttab using Table7.csv, se star(* 0.1 ** 0.05 *** 0.01) r2 drop(dummy_t* trend_*) title(Main Results) compress replace

		*Table 7 regs to obtain R2 including FE	
		areg h s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 /// 
			if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002, absorb(Sector) robust cluster(Sector)
		areg h s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 /// 
			if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)	
		areg h s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 /// 
			if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		areg h s2d_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 /// 
			if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		areg h_w s_h_w_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 /// 
			if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		
	
/*********************** Table 8 **********************************/
/*Generate variables*/
quietly{
	gen s_h_int= s_h_avg*zR_lib_na_avg
	gen s2d_h_int= s2d_h_avg*zR_lib_na_avg
	gen sNC_h_int= sNC_h_avg*zR_lib_na_avg
	gen s_h_w_int= s_h_w_avg*zR_lib_na_avg

	gen equip_pw_int= equip_pw*zR_lib_na_avg
	gen OCAMovK_int= OCAMovK*zR_lib_na_avg
	gen HT_diff_int= HT_diff*zR_lib_na_avg
	gen RD_lag_int= RD_int_lag*zR_lib_na_avg
	gen Outs_na_int= Outs_na*zR_lib_na_avg
	gen Outs_diff_int= Outs_diff*zR_lib_na_avg
}

/*Generate weighted average input differentiation:*/

	gen pr_zR_lib_na_avg=zR_lib_na_avg*weight_emp
	bysort year: egen avg_R_lib = sum(pr_zR_lib_na_avg)
	drop pr_zR_lib_na_avg

/*REGRESSIONS*/

*** Full sample
estimates clear
/*(1):*/eststo: xtreg h s_h_avg s_h_int [pweight=weight_emp], fe i(Sector) robust cluster(Sector) 
		quietly{
			gen reg_coeff=.
			matrix b1=e(b)
			local i=1
			while `i'<3 {
			replace reg_coeff=b1[1,`i'] in `i'
			local i = `i' + 1
			}
			gen beta_1=reg_coeff[1]+reg_coeff[2]*avg_R_lib[1]
			drop reg_coeff
		}
test  (s_h_avg + s_h_int*.5471249=0)

/*(2):*/eststo: xtreg h s_h_avg s_h_int equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff equip_pw_int OCAMovK_int HT_diff_int RD_lag_int Outs_na_int Outs_diff_int ///
			[pweight=weight_emp], fe i(Sector) robust cluster(Sector)
		quietly{
			gen reg_coeff=.
			matrix b1=e(b)
			local i=1
			while `i'<3 {
			replace reg_coeff=b1[1,`i'] in `i'
			local i = `i' + 1
			}
			gen beta_2=reg_coeff[1]+reg_coeff[2]*avg_R_lib[1]
			drop reg_coeff
		}
test  (s_h_avg + s_h_int*.5471249=0)

/*(3):*/eststo: xtreg h s2d_h_avg s2d_h_int equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff equip_pw_int OCAMovK_int HT_diff_int RD_lag_int Outs_na_int Outs_diff_int ///  
			[pweight=weight_emp], fe i(Sector) robust cluster(Sector)
		quietly{
			gen reg_coeff=.
			matrix b1=e(b)
			local i=1
			while `i'<3 {
			replace reg_coeff=b1[1,`i'] in `i'
			local i = `i' + 1
			}
			gen beta_3=reg_coeff[1]+reg_coeff[2]*avg_R_lib[1]
			drop reg_coeff
		}
test  (s2d_h_avg + s2d_h_int*.5471249=0)
*** Benchmark years
/*(4):*/eststo: xtreg h s_h_avg s_h_int dummy_t1-dummy_t48  if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 ///
			[pweight=weight_emp], fe i(Sector) robust cluster(Sector) 
		quietly{
			gen reg_coeff=.
			matrix b1=e(b)
			local i=1
			while `i'<3 {
			replace reg_coeff=b1[1,`i'] in `i'
			local i = `i' + 1
			}
			gen beta_4=reg_coeff[1]+reg_coeff[2]*avg_R_lib[1]
			drop reg_coeff
		}
test  (s_h_avg + s_h_int*.5471249=0)

/*(5):*/eststo: xtreg h s_h_avg s_h_int equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff equip_pw_int OCAMovK_int HT_diff_int RD_lag_int Outs_na_int Outs_diff_int ///  
			dummy_t1-dummy_t48 if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
		quietly{
			gen reg_coeff=.
			matrix b1=e(b)
			local i=1
			while `i'<3 {
			replace reg_coeff=b1[1,`i'] in `i'
			local i = `i' + 1
			}
			gen beta_5=reg_coeff[1]+reg_coeff[2]*avg_R_lib[1]
			drop reg_coeff
		}
test  (s_h_avg + s_h_int*.5471249=0)

/*(6):*/eststo: xtreg h s2d_h_avg s2d_h_int equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff equip_pw_int OCAMovK_int HT_diff_int RD_lag_int Outs_na_int Outs_diff_int ///  
	 dummy_t1-dummy_t48 if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
		quietly{
			gen reg_coeff=.
			matrix b1=e(b)
			local i=1
			while `i'<3 {
			replace reg_coeff=b1[1,`i'] in `i'
			local i = `i' + 1
			}
			gen beta_6=reg_coeff[1]+reg_coeff[2]*avg_R_lib[1]
			drop reg_coeff
		}
test  (s2d_h_avg + s2d_h_int*.5471249=0)

esttab using Table9.csv, se star(* 0.1 ** 0.05 *** 0.01) r2 drop(dummy_t*) title(Main Results) compress replace

outsheet beta_1-beta_6 in 1/2  using "Table_interaction_total_coeff.xls", replace

		/************************************************************************/
		*To obtain the R^2 including FE:
		/*(1):*/  areg h s_h_avg s_h_int [pweight=weight_emp], absorb(Sector) robust cluster(Sector)  
		/*(2):*/  areg h s_h_avg s_h_int equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff equip_pw_int OCAMovK_int HT_diff_int RD_lag_int Outs_na_int Outs_diff_int ///
					[pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(3):*/  areg h s2d_h_avg s2d_h_int equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff equip_pw_int OCAMovK_int HT_diff_int RD_lag_int Outs_na_int Outs_diff_int ///  
					[pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(4):*/  areg h s_h_avg s_h_int dummy_t1-dummy_t48  if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 ///
					[pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(5):*/  areg h s_h_avg s_h_int equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff equip_pw_int OCAMovK_int HT_diff_int RD_lag_int Outs_na_int Outs_diff_int ///  
					dummy_t1-dummy_t48 if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(6):*/  areg h s2d_h_avg s2d_h_int equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff equip_pw_int OCAMovK_int HT_diff_int RD_lag_int Outs_na_int Outs_diff_int ///  
					dummy_t1-dummy_t48 if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/************************************************************************/

/*By quintile of input differentiation:*/

		centile zR_lib_na_avg, centile(20 40 60 80)
		gen quintile_1=.3510671
		gen quintile_2=.4608518
		gen quintile_3=.5708495
		gen quintile_4=.6893 
		gen s_h_quint_1=0
		replace s_h_quint_1=s_h_avg if zR_lib_na_avg<=quintile_1
		gen s_h_quint_2=0
		replace s_h_quint_2=s_h_avg if zR_lib_na_avg>quintile_1 & zR_lib_na_avg<=quintile_2
		gen s_h_quint_3=0
		replace s_h_quint_3=s_h_avg if zR_lib_na_avg>quintile_2 & zR_lib_na_avg<=quintile_3
		gen s_h_quint_4=0
		replace s_h_quint_4=s_h_avg if zR_lib_na_avg>quintile_3 & zR_lib_na_avg<=quintile_4
		gen s_h_quint_5=0
		replace s_h_quint_5=s_h_avg if zR_lib_na_avg>quintile_4

	/*Now regression 2 again...*/
	xtreg h s_h_quint_1 s_h_quint_2 s_h_quint_3 s_h_quint_4 s_h_quint_5 equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff  ///  
	 dummy_t1-dummy_t48 if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)


	

///////////////////////  Importance of ITSC ////////////////////////////////

**********  Table 9, Panels A-B ********************

*Panel A -- Full Sample
estimates clear
quietly{
/*(1):*/eststo: reg  lnHovL ln_s_A_rel_avg [pweight=weight_emp], robust cluster(Sector)
/*(2):*/eststo: xtreg  lnHovL ln_s_A_rel_avg dummy_t1-dummy_t48  [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
/*(3):*/eststo: xtreg  lnHovL ln_s_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48  [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
/*(4):*/eststo: xtreg  lnHovL ln_s_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
/*(5):*/eststo: xtreg  lnHovL ln_s2d_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
/*(6):*/eststo: xtreg  lnHovL ln_s2d_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
}
esttab using Table8a.csv, se star(* 0.1 ** 0.05 *** 0.01) r2 drop(dummy_t* trend_*) title(Main Results) compress replace
*Panel B -- Benchmark years
estimates clear
quietly{
/*(1):*/eststo: reg  lnHovL ln_s_A_rel_avg ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], robust cluster(Sector)
/*(2):*/eststo: xtreg  lnHovL ln_s_A_rel_avg dummy_t1-dummy_t48  ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
/*(3):*/eststo: xtreg  lnHovL ln_s_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48  ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
/*(4):*/eststo: xtreg  lnHovL ln_s_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
/*(5):*/eststo: xtreg  lnHovL ln_s2d_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
/*(6):*/eststo: xtreg  lnHovL ln_s2d_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 ///
		if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], fe i(Sector) robust cluster(Sector)
}		
esttab using Table8b.csv, se star(* 0.1 ** 0.05 *** 0.01) r2 drop(dummy_t* trend_*) title(Main Results) compress replace



	*To obtain the R^2 including FE:
	*Panel A:
		/*(2):*/areg  lnHovL ln_s_A_rel_avg dummy_t1-dummy_t48  [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(3):*/areg  lnHovL ln_s_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48  [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(4):*/areg  lnHovL ln_s_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(5):*/areg  lnHovL ln_s2d_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(6):*/areg  lnHovL ln_s2d_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
	*Panel C:	
		/*(2):*/areg  lnHovL ln_s_A_rel_avg dummy_t1-dummy_t48  ///
					if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(3):*/areg  lnHovL ln_s_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48  ///
					if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(4):*/areg  lnHovL ln_s_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 ///
					if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(5):*/areg  lnHovL ln_s2d_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 ///
					if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)
		/*(6):*/areg  lnHovL ln_s2d_A_rel_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_t1-dummy_t48 trend_1-trend_358 ///
					if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 [pweight=weight_emp], absorb(Sector) robust cluster(Sector)

					
	
	
	
/************************************************************************/
/*Figure 2*/
/************************************************************************/	
	
bysort year: egen median_z = median(zR_lib_na_avg)

reg h s_h_avg equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_i1-dummy_i358 ///
	dummy_t1-dummy_t48 if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002, robust cluster(Sector)
	
	quietly{
		gen reg1_coeff=.
		gen reg1_se=.
		matrix b1=e(b)
		matrix b2=e(V)
		local i=1
		while `i'<2 {
		replace reg1_coeff=b1[1,`i'] in `i'
		replace reg1_se=sqrt(b2[`i',`i']) in `i'
		local i = `i' + 1
		}
	}
	
predict fit_full if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002
gen lhs_full=h-(fit_full-reg1_coeff[1]*s_h_avg) if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002


*title(Partial Scatter Plot)
twoway (lfit lhs_full s_h_avg) (scatter lhs_full s_h_avg, yscale(range(0 .42)) msymbol(th) mcolor(green) ), scheme(s1mono) ///
title(Full Sample) xtitle(Input skill intensity, size(medium)) ytitle(h to be explained by input skill intensity, size(medium))legend(off)


/******************************************************************************/
/*     Partial Scatterplot, all explanatory variables have the same coeff     */
/******************************************************************************/
gen s_h_avg_low = s_h_avg if (year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002) & zR_lib_na_avg <= median_z
recode s_h_avg_low .=0
gen s_h_avg_high = s_h_avg if (year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002) & zR_lib_na_avg > median_z
recode s_h_avg_high .=0
gen dummy_kappa = 1 if (year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002) & zR_lib_na_avg > median_z
recode dummy_kappa .=0

reg h s_h_avg_low s_h_avg_high dummy_kappa equip_pw OCAMovK HT_diff RD_int_lag Outs_na Outs_diff dummy_i1-dummy_i358 ///
	dummy_t1-dummy_t48 if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002 , robust cluster(Sector)

	quietly{
		gen reg4_coeff=.
		gen reg4_se=.
		matrix b1=e(b)
		matrix b2=e(V)
		local i=1
		while `i'<3 {
		replace reg4_coeff=b1[1,`i'] in `i'
		replace reg4_se=sqrt(b2[`i',`i']) in `i'
		local i = `i' + 1
		}
	}
predict fit_full_1 if year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002
gen lhs_low_1 =h-(fit_full_1 -reg4_coeff[1]*s_h_avg_low) if (year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002) & zR_lib_na_avg <= median_z 
label variable lhs_low_1 "Below median (less differentiated)"	
gen lhs_high_1 =h-(fit_full_1 -reg4_coeff[2]*s_h_avg_high) if (year==1967 | year==1972 | year==1977 | year==1982 | year==1987 | year==1992 | year==1997 | year==2002) & zR_lib_na_avg > median_z 
label variable lhs_high_1 "Above median (more differentiated)"
	

*title(Partial Scatter Plot) 
twoway(lfit lhs_high_1 s_h_avg_high)(scatter lhs_high_1 s_h_avg_high, yscale(range(0 .42)) msymbol(smx) mcolor(blue))(lfit lhs_low_1 s_h_avg_low)/*
*/(scatter lhs_low_1 s_h_avg_low, yscale(range(0 .42)) msymbol(smcircle_hollow) mlcolor(black)), scheme(s1mono) ///
title(Above- and below-median input differentiation) xtitle(Input skill intensity, size(median)) ///
ytitle(h to be explained by input skill intensity, size(median)) legend(order(2 4) pos(1) col(1) ring(0) )					
