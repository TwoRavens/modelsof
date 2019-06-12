version 14
clear all
adopath + ../../../lib/stata/gslab_misc/ado
adopath + ../../../lib/stata/ado
set more off
loadglob using  "variables_for_tables.txt" // FILE CONTAINS GLOBAL VARS. USED IN THIS CODE

program main
    complier_mean, take(enrollee_9m) variables(${table_3}) pval_num(1) format("short") ///
                   weight([pw=pweight]) treat_grp(lowtouch_s hightouch) subpop(SP)
    compute_share, ctake(enrollee_9m) ctreat_grp(lowtouch_s hightouch) cw([pw=pweight]) csubpop(SP)
    matrix Complier_C_bene = enrollee_9m \ (share,.)
    mat drop share enrollee_9m
    fill_tables, mat(Complier_C_bene) save_excel(../output_excel/Exhibits_Complier_Tables.xlsx)
    

    complier_mean, take(applicant_9m) variables(${complier_5}) pval_num(1) format("short") ///
                   weight([pw=pweight]) treat_grp(lowtouch_s hightouch) subpop(SP)
    compute_share, ctake(applicant_9m) ctreat_grp(lowtouch_s hightouch) cw([pw=pweight]) csubpop(SP)
    matrix Complier_4 = applicant_9m \ (share,.)
    mat drop share applicant_9m

    complier_mean, take(enrollee_9m) variables(${complier_5}) pval_num(1) format("short") ///
                   weight([pw=pweight]) treat_grp(lowtouch_s hightouch) subpop(SP)
    compute_share, ctake(enrollee_9m) ctreat_grp(lowtouch_s hightouch) cw([pw=pweight]) csubpop(SP)
    matrix Complier_4_dup = enrollee_9m \ (share,.)
    mat drop share enrollee_9m
    matrix Complier_C_x = Complier_4 , Complier_4_dup
    fill_tables, mat(Complier_C_x) save_excel(../output_excel/Exhibits_Complier_Tables.xlsx)
end

program compute_share
    syntax, ctake(str) ctreat_grp(str) cw(str) csubpop(str)

    use ../temp/exhibit_analysis, clear
    qui keep if SP == 1
    qui keep if `csubpop' == 1
	qui keep treatment pweight treat_group `ctake' `ctreat_grp' control

    foreach ctreat in `ctreat_grp' {
        preserve
        qui keep if control == 1 | `ctreat' == 1
        cap drop AT_`ctreat'
        qui gen AT_`ctreat' = (control == 1 & `ctake' == 1)

        qui reg `ctake' `ctreat' `cw', robust
		matrix pi_c = nullmat(pi_c) , _b[`ctreat']

        qui reg AT_`ctreat' if `ctreat' == 0 `cw', robust
		matrix pi_at =  _b[_cons]
        restore
	}
    matrix share = pi_at , pi_c
    mat drop pi_at pi_c
end

program complier_mean
    syntax, take(str) variables(str) subpop(str) [pval_num(integer 0) format(str) weight(str) treat_grp(str)] 

	foreach var in `variables' {
		use ../temp/exhibit_analysis, clear
		
		** Clean data
        qui keep if SP == 1
		qui keep if `subpop' == 1
		qui keep treatment pweight `variables' treat_group `take' `treat_grp' control
		
		assert !mi(`take')
		cap assert !mi(`var')
		if _rc != 0 {
			di "**************** `var' is missing"
		}
		else {
			di "`var' is non-missing"
		}
		
		** Calculate complier means and p-values
		foreach treat in `treat_grp' {
			assert !mi(`treat')
			di "##### take-up determined by `take', treatment by `treat', var is `var' #####"
		
			qui cap drop AT_`treat'
			qui gen AT_`treat' = (control == 1 & `take' == 1)
		}
		
		iterations, ivar(`var') itake(`take') itreat_grp(`treat_grp') iw(`weight')
			
		foreach treat in `treat_grp' {
			local `treat'_co = `treat'_co[1,1]
			di "complier mean is ``treat'_co'"
			matrix `var'_C = nullmat(`var'_C) , ``treat'_co'
		}
		matrix `var'_C = `var'_at[1,1] , `var'_C , J(1,`pval_num',.)
		
		di "Variable is `var'"
		mat list `var'_C

		preserve
		bootstrap_pvalue, btake(`take') bvar(`var') bw(`weight') btreat_grp(`treat_grp') bformat(`format') bsubpop(`subpop')
		restore
		
		matrix `take' = nullmat(`take') \ `var'_C \ (.,`var'_pval)
		
        local dim = colsof(`take')
        matrix `take' = `take' \ J(1,`dim',.)

		matrix drop `var'_C `var'_pval `var'_at
	}
end

	program bootstrap_pvalue
		syntax, btake(str) bvar(str) bformat(str) bsubpop(str) [bw(str) btreat_grp(str)]
		
		if strmatch("`bformat'", "short") == 1 {
			di "bformat is short"
			local orig_d_l_h = lowtouch_s_co[1,1] - hightouch_co[1,1]
		}
		
		if strmatch("`bformat'", "long") == 1 {
			di "bformat is long"
			local orig_d_c_t = treat_S_M_co[1,1] - `bvar'_at[1,1]
			local orig_d_s_m = standard_co[1,1] - marketing_co[1,1]
			local orig_d_g3_g6 = G3_co[1,1] - G6_co[1,1]
			local orig_d_g3_g4 = G3_co[1,1] - G4_co[1,1]
		}
		
		foreach btreat in `btreat_grp' {
			local orig_d_`btreat' = `btreat'_co[1,1] - `bvar'_at[1,1]
			mat drop `btreat'_co
		}
		
		use ../temp/exhibit_analysis, clear
        qui keep if SP == 1
		qui keep if `bsubpop' == 1
		qui keep treatment pweight `bvar' treat_group `btake' `btreat_grp' control
		
		foreach btreat in `btreat_grp' {
			qui gen AT_`btreat' = (control == 1 & `btake' == 1)
		}
		
		cap erase "../temp/`btake'`bvar'.dta"
		
		if strmatch("`bformat'", "short") == 1 {
			di "bformat is short"
			bootstrap diff_lt = r(lt_diff) diff_ht = r(ht_diff) diff_l_h = r(l_h_diff), ///
				reps(10000) saving(../temp/`btake'`bvar') seed(12) nodrop: iterations, ivar(`bvar') itake(`btake') itreat_grp(`btreat_grp') iw(`bw') iformat(`bformat')
			local orig_d_lt = `orig_d_lowtouch_s'
			local orig_d_ht = `orig_d_hightouch'
			local comparison = "lt ht l_h"
		}
		
		if strmatch("`bformat'", "long") == 1 {
			di "bformat is long"
			bootstrap diff_G1 = r(G1_diff) diff_G2 = r(G2_diff) diff_G3 = r(G3_diff) diff_G4 = r(G4_diff) diff_G5 = r(G5_diff) diff_G6 = r(G6_diff)	///
						  diff_c_t = r(c_t_diff) diff_s_m = r(s_m_diff) diff_g3_g6 = r(g3_g6_diff) diff_g3_g4 = r(g3_g4_diff), 	///
				reps(10000) saving(../temp/`btake'`bvar') seed(12) nodrop: iterations, ivar(`bvar') itake(`btake') itreat_grp(`btreat_grp') iw(`bw') iformat(`bformat')
			local comparison = "G3 G4 G5 G6 G1 G2 c_t s_m g3_g6 g3_g4"
		}
		
		use ../temp/`btake'`bvar', clear
		
		foreach pair in `comparison' {
			if `orig_d_`pair'' > 0 {
            di "1"
				qui gen pvalue_`pair' = diff_`pair' < 0
			}
			else {
				di "2"
				if `orig_d_`pair'' < 0 {
					di "3"
					qui gen pvalue_`pair' = diff_`pair' > 0
				}
				else {
					di "4"
					sum diff_`pair'
					if r(mean) > 0 {
						di "5"
						qui gen pvalue_`pair' = diff_`pair' < 0
					}
					else {
						di "6"
						if r(mean) < 0 {
							di "7"
							qui gen pvalue_`pair' = diff_`pair' > 0
						}
						else {
							di "8"
							qui gen pvalue_`pair' = 0.5
						}
					}
				}
			}
			qui sum pvalue_`pair'
			local pval_`pair' = round(r(mean)*2, 0.00001)
		
			di "P-value is `pval_`pair''"
			matrix `bvar'_pval = nullmat(`bvar'_pval) , `pval_`pair''
		}
	end
	
		program iterations, rclass
			syntax, ivar(str) itake(str) itreat_grp(str) iw(str) [iformat(str)]
			di "Enter iterations"
			
			foreach itreat in `itreat_grp' {
				preserve
				qui keep if control == 1 | `itreat' == 1
				
				*first stage (comliance rate) - fs (pi_c)
				qui reg `itake' `itreat' `iw', robust
				matrix `itreat'_temp = nullmat(`itreat'_temp) , _b[`itreat']
			
				*fraction of always taker - pi_at
				qui reg AT_`itreat' if `itreat' == 0 `iw', robust
				matrix `itreat'_temp =  `itreat'_temp , _b[_cons]
			
				*always taker mean - mu_at
				qui reg `ivar' if `itreat' == 0 & `itake' == 1 `iw', robust
				matrix `itreat'_temp =  `itreat'_temp , _b[_cons]
			
				*mean among treatments who take up - mu_he
				qui reg `ivar' if `itreat' == 1 & `itake' == 1 `iw', robust
				matrix `itreat'_temp =  `itreat'_temp , _b[_cons]
				restore
				
				matrix `itreat'_co = ((`itreat'_temp[1,2] + `itreat'_temp[1,1])*`itreat'_temp[1,4] - `itreat'_temp[1,2]*`itreat'_temp[1,3])/`itreat'_temp[1,1]
				mat drop `itreat'_temp
				local `itreat'_co = `itreat'_co[1,1]
			}
			
			qui reg `ivar' if control == 1 & `itake' == 1 `iw', robust
			matrix `ivar'_at = _b[_cons]
			local `ivar'_at = `ivar'_at[1,1]
			
			if strmatch("`iformat'", "short") == 1 {
				scalar lt_diff = `lowtouch_s_co' - ``ivar'_at'
				return scalar lt_diff = `lowtouch_s_co' - ``ivar'_at'
				
				scalar ht_diff = `hightouch_co' - ``ivar'_at'
				return scalar ht_diff = `hightouch_co' - ``ivar'_at'
				
				scalar l_h_diff = `lowtouch_s_co' - `hightouch_co'
				return scalar l_h_diff = `lowtouch_s_co' - `hightouch_co'
			}
			if strmatch("`iformat'", "long") == 1 {
				foreach itreat in `itreat_grp' {
					scalar `itreat'_diff = ``itreat'_co' - ``ivar'_at'
					return scalar `itreat'_diff = ``itreat'_co' - ``ivar'_at'
				}
				scalar c_t_diff = `treat_S_M_co' - ``ivar'_at'
                return scalar c_t_diff = `treat_S_M_co' - ``ivar'_at'

				scalar s_m_diff = `standard_co' - `marketing_co'
                return scalar s_m_diff = `standard_co' - `marketing_co'

				scalar g3_g6_diff = `G3_co' - `G6_co'
                return scalar g3_g6_diff = `G3_co' - `G6_co'

				scalar g3_g4_diff = `G3_co' - `G4_co'
                return scalar g3_g4_diff = `G3_co' - `G4_co'
				
			}
		end
			
main
