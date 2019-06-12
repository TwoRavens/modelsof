version 14
clear all
adopath + ../../../lib/stata/gslab_misc/ado
adopath + ../../../lib/stata/ado
set more off
loadglob using  "variables_for_tables.txt" // FILE CONTAINS GLOBAL VARS. USED IN THIS CODE

program main
	counts, groups(control G3 G4 G5 G6 G1 G2) name(N_all_arms) p_columns(4)
	counts, groups(control_en G3_en G4_en G5_en G6_en G1_en G2_en) name(N_all_arms_en) p_columns(4)
	counts, groups(control_ap G3_ap G4_ap G5_ap G6_ap G1_ap G2_ap) name(N_all_arms_ap) p_columns(4)
	counts, groups(control_ca G3_ca G4_ca G5_ca G6_ca G1_ca G2_ca) name(N_all_arms_ca) p_columns(4)

	counts, groups(control lowtouch_s hightouch) name(SP_N) p_columns(1)
	counts, groups(control_fy lowtouch_s_fy hightouch_fy) name(SP_N_fy) p_columns(1)
	counts, groups(lowtouch_s_ca hightouch_ca) name(SP_N_ca) p_columns(1)
    counts, groups(lowtouch_s_nca hightouch_nca) name(SP_N_nca) p_columns(1)
    counts, groups(control Icaller_9m Inoncaller_T) name(Caller_N) p_columns(1)
    counts, groups(control Icaller_9m_S_M Inoncaller_T_S_M) name(Caller_S_M_N) p_columns(1)
	counts, groups(control_re lowtouch_s_re hightouch_re) name(Rejection_N) p_columns(1)
	counts, groups(control_ap lowtouch_s_ap hightouch_ap control_en lowtouch_s_en hightouch_en) name(SP_N_detail) p_columns(3)
	counts, groups(control_ap_fy lowtouch_s_ap_fy hightouch_ap_fy control_en_fy lowtouch_s_en_fy hightouch_en_fy) name(SP_N_detail_fy) p_columns(3)
	
	Table_6
	
	Appendix_3            
	Appendix_4           
	Appendix_5             
	Appendix_6 
	
	Appendix_8 
	Appendix_9 
	Appendix_10  
	
	Appendix_13
	Appendix_14            
	Appendix_15 
	Appendix_16   
	Appendix_17           
end

program counts
	syntax, groups(str) name(str) [p_columns(integer 0)]
	use ../temp/exhibit_analysis, replace
	foreach group in `groups' {             
		count if `group' == 1
		matrix `name' = nullmat(`name'), r(N)
    }
	if strmatch("`p_columns'", "0") != 1 {
		forval i = 1/`p_columns' {
			matrix `name' = `name' , .
		}
	}
	local columns = colsof(`name')
	matrix `name' = `name' \ J(1,`columns',.)
end

program Table_6
	p_values, variables(${appendix_9}) group_1(Icaller_9m_S_M) group_2(Inoncaller_T_S_M) 		///
		matname(ca_nca_sm_pval) weight(pweight)
    main_columns, variables(${appendix_9}) groups(control Icaller_9m_S_M Inoncaller_T_S_M) stat(mean) 	///
		pvalues(yes) column_no(2) weighting([pw=pweight]) compare_grp(control)
    matrix Table_6 = (main_columns , ca_nca_sm_pval) \ (Caller_S_M_N)
	fill_tables, mat(Table_6) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop main_columns ca_nca_sm_pval
end

program Appendix_3
	p_values, variables(${appendix_1}) group_1(hightouch) group_2(lowtouch_s) 		///
		matname(HT_LT_s_pval) weight(pweight)
	main_columns, variables(${appendix_1}) groups(control lowtouch_s hightouch) 	///
		stat(mean) pvalues(yes) column_no(3) compare_grp(control) weighting([pw=pweight])
	foreach file in lowtouch_scontrol hightouchcontrol hightouchlowtouch_s {
		import delimited "../output_excel/F-stats/F_`file'.txt", clear
		sum sim_pvalue
		local p = r(mean)
		sum orig_fstat
		local f = r(mean)
		matrix Fstat = nullmat(Fstat), (`f' \ `p')
	}
	matrix Appendix_3 = (main_columns , HT_LT_s_pval) \ (SP_N) \ (J(2,1,.), Fstat)
	fill_tables, mat(Appendix_3) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop main_columns HT_LT_s_pval Fstat
end

program Appendix_4
	p_values, variables(${appendix_1}) group_1(control) group_2(treat_S_M) 		///
		matname(control_treat) weight(pweight)
	p_values, variables(${appendix_1}) group_1(lowtouch_stan) group_2(framing) 		///
		matname(stan_framing) weight(pweight)
    p_values, variables(${appendix_1}) group_1(standard) group_2(marketing) 		///
		matname(stan_mkt) weight(pweight)
	p_values, variables(${appendix_1}) group_1(lowtouch_stan) group_2(lowtouch_nop) 		///
		matname(stan_nop) weight(pweight)
	main_columns, variables(${appendix_1}) groups(control G3 G4 G5 G6 G1 G2) ///
		stat(mean) pvalues(yes) column_no(7) compare_grp(control)
	foreach file in G3control G4control G5control G6control G1control G2control treat_S_Mcontrol marketingstandard G3G6 G3G4 {
		import delimited "../output_excel/F-stats/F_`file'.txt", clear
		sum sim_pvalue
		local p = r(mean)
		sum orig_fstat
		local f = r(mean)
		matrix Fstat = nullmat(Fstat), (`f' \ `p')
	}
	matrix Appendix_4 = (main_columns , control_treat , stan_mkt , stan_framing , stan_nop) \ (N_all_arms) \ (J(2,1,.), Fstat)
	fill_tables, mat(Appendix_4) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop main_columns control_treat stan_framing stan_mkt stan_nop Fstat
end

program Appendix_5
	p_values, variables(${table_2}) group_1(control) group_2(treat_S_M) 		///
		matname(control_treat) weight(pweight)
	p_values, variables(${table_2}) group_1(lowtouch_stan) group_2(framing) 		///
		matname(stan_framing) 
    p_values, variables(${table_2}) group_1(standard) group_2(marketing) 		///
		matname(stan_mkt) weight(pweight)
	p_values, variables(${table_2}) group_1(lowtouch_stan) group_2(lowtouch_nop) 		///
		matname(stan_nop) 
	main_columns, variables(${table_2}) groups(control G3 G4 G5 G6 G1 G2) ///
		stat(mean) pvalues(yes) column_no(7) compare_grp(control)
	matrix Appendix_5 = (main_columns , control_treat , stan_mkt , stan_framing , stan_nop) \ (N_all_arms)
	fill_tables, mat(Appendix_5) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop main_columns control_treat stan_framing stan_mkt stan_nop
end

program Appendix_6
	p_values, variables(${table_3}) group_1(control_en) group_2(treat_S_M_en) 		///
		matname(control_treat) weight(pweight)
	p_values, variables(${table_3}) group_1(lowtouch_stan_en) group_2(framing_en) 		///
		matname(stan_framing) 
    p_values, variables(${table_3}) group_1(standard_en) group_2(marketing_en) 		///
		matname(stan_mkt) weight(pweight)
	p_values, variables(${table_3}) group_1(lowtouch_stan_en) group_2(lowtouch_nop_en) 		///
		matname(stan_nop) 
	main_columns, variables(${table_3}) groups(control_en G3_en G4_en G5_en G6_en G1_en G2_en) ///
		stat(mean) pvalues(yes) column_no(7) compare_grp(control_en)
	matrix Appendix_6 = (main_columns , control_treat , stan_mkt , stan_framing , stan_nop) \ (N_all_arms_en)
	fill_tables, mat(Appendix_6) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop main_columns control_treat stan_framing stan_mkt stan_nop
end

program Appendix_10
	p_values, variables(${table_4_app}) group_1(hightouch_ap) group_2(lowtouch_s_ap) 		///
		matname(HT_LT_s_pval_ap) weight(pweight)
	p_values, variables(${table_4_app}) group_1(hightouch_en) group_2(lowtouch_s_en) 		///
		matname(HT_LT_s_pval_en) weight(pweight)
	p_values, variables(${table_4_app}) group_1(control_ap) group_2(treat_S_M_ap) 		///
		matname(C_T_pval_ap) weight(pweight)
	p_values, variables(${table_4_app}) group_1(control_en) group_2(treat_S_M_en) 		///
		matname(C_T_pval_en) weight(pweight)		
	main_columns, variables(${table_4_app}) groups(control_ap lowtouch_s_ap hightouch_ap control_en lowtouch_s_en hightouch_en) ///
		stat(mean) pvalues(yes) column_no(6) compare_grp(control) weighting([pw=pweight])
	matrix Appendix_10 = (main_columns , HT_LT_s_pval_ap , HT_LT_s_pval_en, C_T_pval_ap , C_T_pval_en) ///
						    \ (SP_N_detail , J(2,1,.)) 
	fill_tables, mat(Appendix_10) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop main_columns HT_LT_s_pval_ap HT_LT_s_pval_en C_T_pval_ap C_T_pval_en
end

program Appendix_14
	p_values, variables(${table_4}) group_1(control_ap) group_2(treat_S_M_ap) 		///
		matname(control_treat) weight(pweight)
	p_values, variables(${table_4}) group_1(lowtouch_stan_ap) group_2(framing_ap) 		///
		matname(stan_framing)
    p_values, variables(${table_4}) group_1(standard_ap) group_2(marketing_ap) 		///
		matname(stan_mkt) weight(pweight)
	p_values, variables(${table_4}) group_1(lowtouch_stan_ap) group_2(lowtouch_nop_ap) 		///
		matname(stan_nop) 
	main_columns, variables(${table_4}) groups(control_ap G3_ap G4_ap G5_ap G6_ap G1_ap G2_ap) ///
		stat(mean) pvalues(yes) column_no(7) compare_grp(control_ap)
	matrix Appendix_14 = (main_columns , control_treat , stan_mkt , stan_framing , stan_nop) \ (N_all_arms_ap)
	fill_tables, mat(Appendix_14) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop main_columns control_treat stan_framing stan_mkt stan_nop
end

program Appendix_15
	p_values, variables(${table_4}) group_1(control_en) group_2(treat_S_M_en) 		///
		matname(control_treat) weight(pweight)
	p_values, variables(${table_4}) group_1(lowtouch_stan_en) group_2(framing_en) 		///
		matname(stan_framing) 
    p_values, variables(${table_4}) group_1(standard_en) group_2(marketing_en) 		///
		matname(stan_mkt) weight(pweight)
	p_values, variables(${table_4}) group_1(lowtouch_stan_en) group_2(lowtouch_nop_en) 		///
		matname(stan_nop)
	main_columns, variables(${table_4}) groups(control_en G3_en G4_en G5_en G6_en G1_en G2_en) ///
		stat(mean) pvalues(yes) column_no(7) compare_grp(control_en)
	matrix Appendix_15 = (main_columns , control_treat , stan_mkt , stan_framing , stan_nop) \ (N_all_arms_en)
	fill_tables, mat(Appendix_15) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop main_columns control_treat stan_framing stan_mkt stan_nop
end

program Appendix_8
	use ../temp/cleaned_calls_9m, clear
	
	forval i = 0/6 {
		forval x = 2/6 {
			unique hh_id if group_from == `i' & group_to == `x'
			matrix call_from_`i' = nullmat(call_from_`i'), r(sum)
		}
		matrix Call_contamination = nullmat(Call_contamination) \ call_from_`i'
		mat drop call_from_`i'
		unique hh_id if group_from == `i'
		matrix Call_total = nullmat(Call_total) \ r(sum)
	}
	matrix Call_contamination_caller = Call_contamination, Call_total
	mat drop Call_contamination Call_total
	matrix Appendix_8 = Call_contamination_caller
	fill_tables, mat(Appendix_8) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop Call_contamination_caller
end

program Appendix_16
	p_values, variables(${table_2}) group_1(hightouch) group_2(lowtouch_s) 		///
		matname(HT_LT_s_pval) weight(pweight) rob_var(${appendix_7_cov} i.letter_batch_date)
    p_values, variables(${table_2}) group_1(control) group_2(treat_S_M) 		///
		matname(C_T_pval) weight(pweight) rob_var(${appendix_7_cov} i.letter_batch_date)
	main_columns, variables(${table_2}) groups(control lowtouch_s hightouch) ///
		stat(mean) pvalues(yes) column_no(3) compare_grp(control) 			 ///
		rob_var(${appendix_7_cov} i.letter_batch_date) weighting([pw=pweight])
	matrix Appendix_16 = (main_columns , HT_LT_s_pval , C_T_pval) \ (SP_N, J(2,1,.))
	fill_tables, mat(Appendix_16) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop main_columns HT_LT_s_pval C_T_pval
end

program Appendix_17
	p_values, variables(${appendix_8}) group_1(hightouch_ap_fy) group_2(lowtouch_s_ap_fy) 		///
		matname(HT_LT_s_pval_ap_fy) weight(pweight)
	p_values, variables(${appendix_8}) group_1(hightouch_en_fy) group_2(lowtouch_s_en_fy) 		///
		matname(HT_LT_s_pval_en_fy) weight(pweight)
	p_values, variables(${appendix_8}) group_1(control_ap_fy) group_2(treat_S_M_ap_fy) 		///
		matname(C_T_pval_ap_fy) weight(pweight)
	p_values, variables(${appendix_8}) group_1(control_en_fy) group_2(treat_S_M_en_fy) 		///
		matname(C_T_pval_en_fy) weight(pweight)
		
	main_columns, variables(${appendix_8}) groups(control_ap_fy ///
		lowtouch_s_ap_fy hightouch_ap_fy control_en_fy lowtouch_s_en_fy hightouch_en_fy) ///
		stat(mean) pvalues(yes) column_no(6) compare_grp(control) weighting([pw=pweight])
	matrix Appendix_17 = (main_columns , HT_LT_s_pval_ap_fy , HT_LT_s_pval_en_fy , C_T_pval_ap_fy , C_T_pval_en_fy) ///
				   \ (SP_N_detail_fy , J(2,1,.)) 
	fill_tables, mat(Appendix_17) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop main_columns HT_LT_s_pval_ap_fy HT_LT_s_pval_en_fy C_T_pval_ap_fy C_T_pval_en_fy
end

program Appendix_13
    p_values, variables(${appendix_9}) group_1(hightouch_ca) group_2(lowtouch_s_ca) 		///
		matname(HT_LT_pval_ca) weight(pweight)
    main_columns, variables(${appendix_9}) groups(lowtouch_s_ca hightouch_ca) stat(mean) 	///
		pvalues(yes) column_no(2) weighting([pw=pweight])
    matrix Appendix_13_A = (main_columns , HT_LT_pval_ca) \ (SP_N_ca)
    mat drop main_columns HT_LT_pval_ca

    p_values, variables(${appendix_9}) group_1(hightouch_nca) group_2(lowtouch_s_nca) 		///
		matname(HT_LT_pval_nca) weight(pweight)
	main_columns, variables(${appendix_9}) groups(lowtouch_s_nca hightouch_nca) stat(mean) 	///
		pvalues(yes) column_no(2) weighting([pw=pweight])
    matrix Appendix_13_B = (main_columns , HT_LT_pval_nca) \ (SP_N_nca)
	matrix Appendix_13 = Appendix_13_A , Appendix_13_B
	fill_tables, mat(Appendix_13) save_excel(../output_excel/Exhibits_Main_Tables.xlsx)
	mat drop main_columns HT_LT_pval_nca
end

program Appendix_9
	p_values, variables(${appendix_10}) group_1(hightouch) group_2(lowtouch_s) 		///
		matname(HT_LT_s_pval) weight(pweight)
    p_values, variables(${appendix_10}) group_1(control) group_2(treatment) 		///
		matname(C_T_pval) weight(pweight)
	main_columns, variables(${appendix_10}) groups(control lowtouch_s hightouch) ///
		stat(mean) pvalues(yes) column_no(3) compare_grp(control) weighting([pw=pweight])
	matrix Appendix_9 = (main_columns , HT_LT_s_pval , C_T_pval) \ (Rejection_N, J(2,1,.))
	fill_tables, mat(Appendix_9) save_excel(../output_excel/Exhibits_Appendix_Tables.xlsx)
	mat drop main_columns HT_LT_s_pval C_T_pval
end


	program main_columns
		syntax, variables(str) groups(str) stat(str) pvalues(str) [compare_grp(str) column_no(integer 1) rob_var(str) weighting(str)]
		use ../temp/exhibit_analysis, clear
		foreach var in `variables' {
			qui count if `var' != .
			di "`stat' and `var', `r(N)' is available"
			foreach group in `groups' {
				if strmatch("`pvalues'", "yes") == 1 {
                    di "compute p-values"
					sum `var' [aw = aweight] if `group' == 1 
					matrix `var' 	= nullmat(`var'), r(`stat')
					if strmatch("`group'", "`compare_grp'*") == 0 {
                        di "compute for non-control groups"
						if strmatch("`group'" , "*ap") == 1 {
							reg `var' `group' `rob_var' `weighting' if control_ap == 1 | `group' == 1, robust
						}
						else if strmatch("`group'" , "*en") == 1 {
							reg `var' `group' `rob_var' `weighting' if control_en == 1 | `group' == 1, robust
						}
                        else if strmatch("`group'" , "*ca") == 1 {
							reg `var' `group' `rob_var' `weighting' if control_ca == 1 | `group' == 1, robust
						}
						else if strmatch("`group'" , "*fy") == 1 {
							if strmatch("`group'" , "*ap_fy*") == 1 {
								reg `var' `group' `rob_var' `weighting' if control_ap_fy == 1 | `group' == 1, robust
							}
							else if strmatch("`group'" , "*en_fy*") == 1 {
								reg `var' `group' `rob_var' `weighting' if control_en_fy == 1 | `group' == 1, robust
							}
							else {
								reg `var' `group' `rob_var' `weighting' if control_fy == 1 | `group' == 1, robust
							}
						}
						else {
                                di "compare with control"
							reg `var' `group' `rob_var' `weighting' if control == 1 | `group' == 1, robust
						}
						matrix results = r(table)
						matrix p = results[4,1]
					}
					else {
						matrix p = J(1,1,.)
					}
					matrix pval = nullmat(pval) , p
				}
				else {
                    di "do not compute p-values"
					sum `var' if `group' == 1 
					matrix `var' 	= nullmat(`var'), r(`stat')
					matrix pval = J(1,`column_no',.)
				}
			}
			matrix main_columns = nullmat(main_columns) \ `var' \ pval
			if strmatch("`pvalues'", "yes") == 1 {
				local columns_no = colsof(main_columns)
				matrix main_columns = main_columns \ J(1,`columns_no',.)	
			}
			matrix drop pval `var'
		}
	end
	
	program p_values
		syntax, variables(str) group_1(str) group_2(str) matname(str) [weight(str) time(str) rob_var(str)]
		use ../temp/exhibit_analysis, replace
		foreach var in `variables' {
            if strmatch("`weight'", "*weigh*") == 1 {
                reg `var' `group_1' `rob_var' [pw=`weight'] if (`group_1' == 1 | `group_2' == 1), robust
            }
            else {
                reg `var' `group_1' `rob_var' if (`group_1' == 1 | `group_2' == 1), robust
            }
			matrix results = r(table)
			matrix pval_`var' = . \ results[4,1]
			matrix `matname' = nullmat(`matname') \ pval_`var' \ J(1,1,.)
			mat drop pval_`var'
		}
	end

main
