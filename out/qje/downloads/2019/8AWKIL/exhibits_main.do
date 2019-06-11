version 14
clear all
adopath + ../../../lib/stata/gslab_misc/ado
adopath + ../../../lib/stata/ado
set more off
loadglob using  "variables_for_tables.txt" // FILE CONTAINS GLOBAL VARS. USED IN THIS CODE

program main
	counts, groups(control lowtouch_s hightouch) name(SP_N) p_columns(1)
	counts, groups(control_en_si lowtouch_s_en_si hightouch_en_si) name(SP_N_en_si) p_columns(1)
    counts, groups(control G3 G4 G5 G6 G1 G2) name(N_all_arms) p_columns(4)
	counts, groups(control_ap lowtouch_s_ap hightouch_ap control_en lowtouch_s_en hightouch_en) name(SP_N_detail) p_columns(3)
	counts, groups(OL IOL_w_ex Isnap Inon_snap SP) name(OL_N)
	counts, groups(control_ca lowtouch_s_ca hightouch_ca) name(SP_N_ca) p_columns(1)
	
	table_1            
	table_2            
    table_3          
	table_4           
	table_5            
    table_A18
	
	use ../temp/exhibit_analysis, clear
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

program table_1
	main_columns, variables(${table_1}) groups(OL IOL_w_ex Isnap Inon_snap SP) ///
		stat(mean) pvalues(no) column_no(5)
	matrix Table_1 = OL_N \ main_columns
	fill_tables, mat(Table_1) save_excel(../output_excel/Exhibits_Main_Tables.xlsx)
	mat drop main_columns
end

program table_2 
	p_values, variables(${table_2}) group_1(hightouch) group_2(lowtouch_s) 		///
		matname(HT_LT_s_pval) weight(pweight)
	main_columns_age, variables(${table_2}) groups(control lowtouch_s hightouch) ///
		stat(mean) pvalues(yes) column_no(3) compare_grp(control)
	matrix Table_2 = (main_columns , HT_LT_s_pval) \ (SP_N)
	fill_tables, mat(Table_2_age) save_excel(../output_excel/Exhibits_Main_Tables.xlsx)
	mat drop main_columns HT_LT_s_pval
end

program table_3
	p_values, variables(${table_2}) group_1(lowtouch_stan) group_2(lowtouch_nop) 		///
		matname(stan_nopost_pval) weight(pweight)
	main_columns, variables(${table_2}) groups(control lowtouch_stan lowtouch_nop) ///
		stat(mean) pvalues(yes) column_no(3) compare_grp(control)
	matrix Table_3 = (main_columns , stan_nopost_pval) \ (N_all_arms[1..2, 1..1] , N_all_arms[1..2, 2..3] , J(2,1,.))
	fill_tables, mat(Table_3) save_excel(../output_excel/Exhibits_Main_Tables.xlsx)
	mat drop main_columns stan_nopost_pval
end

program table_4
	p_values, variables(${table_3}) group_1(hightouch_en) group_2(lowtouch_s_en) 		///
		matname(HT_LT_s_pval_en) weight(pweight)
	main_columns, variables(${table_3}) groups(control_en lowtouch_s_en hightouch_en) ///
		stat(mean) pvalues(yes) column_no(3) compare_grp(control)
	matrix Table_4 =  (main_columns , HT_LT_s_pval_en) \ (SP_N_detail[1..2,4..7])
	fill_tables, mat(Table_4) save_excel(../output_excel/Exhibits_Main_Tables.xlsx)
	mat drop main_columns HT_LT_s_pval_en
end

program table_5
	p_values, variables(${table_4}) group_1(hightouch_ap) group_2(lowtouch_s_ap) 		///
		matname(HT_LT_s_pval_ap) weight(pweight)
	p_values, variables(${table_4}) group_1(hightouch_en) group_2(lowtouch_s_en) 		///
		matname(HT_LT_s_pval_en) weight(pweight)	
	main_columns, variables(${table_4}) groups(control_ap lowtouch_s_ap hightouch_ap control_en lowtouch_s_en hightouch_en) ///
		stat(mean) pvalues(yes) column_no(6) compare_grp(control)
	matrix Table_5 = (main_columns , HT_LT_s_pval_ap , HT_LT_s_pval_en) \ (SP_N_detail[1..2, 1..8]) 
	fill_tables, mat(Table_5) save_excel(../output_excel/Exhibits_Main_Tables.xlsx)
	mat drop main_columns HT_LT_s_pval_ap HT_LT_s_pval_en
end

program table_A18
    p_values_age, variables(enrollee_9m applicant_9m Icaller_9m) key_var(age) group_1(hightouch) group_2(lowtouch_s) 		///
		matname(HT_LT_s_pval) weight(pweight)
	main_columns_age, variables(enrollee_9m applicant_9m Icaller_9m) key_var(age) groups(control lowtouch_s hightouch) ///
		stat(mean) column_no(3) compare_grp(control)
	matrix Table_A18 = (main_columns, HT_LT_s_pval) \ (SP_N)
	fill_tables, mat(Table_A18) save_excel(../output_excel/Exhibits_Main_Tables.xlsx)
	mat drop main_columns HT_LT_s_pval
end

	program main_columns_age
		syntax, key_var(str) variables(str) groups(str) stat(str) [compare_grp(str) column_no(integer 1)]
		use ../temp/exhibit_analysis, clear
		foreach var in `variables' {
			qui count if `var' != .
			di "`stat' and `var', `r(N)' is available"
			foreach group in `groups' {
                if strmatch("`group'", "`compare_grp'*") == 0 {
                    count if `var' != . & (control == 1 | `group' == 1)
					sum `key_var' if SP == 1 [aw=aweight]
					di "`SP mean age is `r(mean)'"
					local mean_age = r(mean)
                    qui reg `var' `group' `key_var' `group'#c.`key_var' [pw=pweight] if control == 1 | `group' == 1, robust
                    matrix results = r(table)
					reg `var' `group' `key_var' `group'#c.`key_var' [pw=pweight] if control == 1 | `group' == 1, robust
					local local_effect = _b[`group'] + _b[1.`group'#c.`key_var']*`mean_age'
					test _b[`group'] + _b[1.`group'#c.`key_var']*`mean_age' = 0
					matrix `var'_`group' = round(r(p),0.0001), `local_effect'
                    matrix `var' 	= nullmat(`var'), round(results[1,4], 0.000000001)
                    matrix p = round(results[4,4],0.0001)
                }
                matrix pval = nullmat(pval) , p
			}
			matrix main_columns = nullmat(main_columns) \ `var' \ pval
			local columns_no = colsof(main_columns)
			matrix main_columns = main_columns \ J(1,`columns_no',.)	
			matrix drop pval `var'
		}
	end
	
	program p_values_age
		syntax, variables(str) key_var(str) group_1(str) group_2(str) matname(str) [weight(str) time(str)]
		use ../temp/exhibit_analysis, replace
		foreach var in `variables' {
			count if `var' != . & (`group_1' == 1 | `group_2' == 1)
                reg `var' `group_1' `key_var' `group_1'#c.`key_var' [pw=`weight'] if (`group_1' == 1 | `group_2' == 1), robust
                matrix results = r(table)
                matrix pval_`var' = . \ results[4,4]
			matrix `matname' = nullmat(`matname') \ pval_`var' \ J(1,1,.)
			mat drop pval_`var'
		}
	end

    program main_columns
		syntax, variables(str) groups(str) stat(str) pvalues(str) [compare_grp(str) column_no(integer 1)]
		use ../temp/exhibit_analysis, clear
		foreach var in `variables' {
			qui count if `var' != .
			di "`stat' and `var', `r(N)' is available"
			foreach group in `groups' {
				if strmatch("`pvalues'", "yes") == 1 {
					sum `var' [aw = aweight] if `group' == 1 
					matrix `var' 	= nullmat(`var'), r(`stat')
					if strmatch("`group'", "`compare_grp'*") == 0 {
						if strmatch("`group'" , "*ap") == 1 {
							count if `var' != . & (control_ap == 1 | `group' == 1)
							qui reg `var' `group' [pw=pweight] if control_ap == 1 | `group' == 1, robust
						}
						else if strmatch("`group'" , "*en") == 1 {
							count if `var' != . & (control_en == 1 | `group' == 1)
							qui reg `var' `group' [pw=pweight] if control_en == 1 | `group' == 1, robust
						}
						else if strmatch("`group'" , "*en_si") == 1 {
							count if `var' != . & (control_en_si == 1 | `group' == 1)
							qui reg `var' `group' [pw=pweight] if control_en_si == 1 | `group' == 1, robust
						}
						else {
							count if `var' != . & (control == 1 | `group' == 1)
							qui reg `var' `group' [pw=pweight] if control == 1 | `group' == 1, robust
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
		syntax, variables(str) group_1(str) group_2(str) matname(str) [weight(str) time(str)]
		use ../temp/exhibit_analysis, replace
		foreach var in `variables' {
			count if `var' != . & (`group_1' == 1 | `group_2' == 1)
			reg `var' `group_1' [pw=`weight'] if (`group_1' == 1 | `group_2' == 1), robust
			matrix results = r(table)
			matrix pval_`var' = . \ results[4,1]
			matrix `matname' = nullmat(`matname') \ pval_`var' \ J(1,1,.)
			mat drop pval_`var'
		}
	end
	
main
