version 14
clear all
adopath + ../../../lib/stata/gslab_misc/ado
adopath + ../../../lib/stata/ado
set more off
loadglob using  "variables_for_tables.txt" // FILE CONTAINS GLOBAL VARS. USED IN THIS CODE

program main
    complier_mean, take(applicant_9m) variables(${complier_5}) weight([pw=pweight]) treat_grp(lowtouch_s hightouch)
    compute_share, ctake(applicant_9m) ctreat_grp(lowtouch_s hightouch) cw([pw=pweight]) 
    matrix Complier_NT_C_1 = applicant_9m \ (share,.,.)
    mat drop share applicant_9m
    fill_tables, mat(Complier_NT_C_1) save_excel(../output_excel/Exhibits_Complier_Tables.xlsx)

    complier_mean, take(enrollee_9m) variables(${complier_5}) weight([pw=pweight]) treat_grp(lowtouch_s hightouch)
    compute_share, ctake(enrollee_9m) ctreat_grp(lowtouch_s hightouch) cw([pw=pweight]) 
    matrix Complier_NT_C_2 = enrollee_9m \ (share,.,.)
    mat drop share enrollee_9m
    fill_tables, mat(Complier_NT_C_2) save_excel(../output_excel/Exhibits_Complier_Tables.xlsx)
end

program compute_share
    syntax, ctake(str) ctreat_grp(str) cw(str)

    use ../temp/exhibit_analysis, clear
    qui keep if SP == 1
	qui keep treatment pweight treat_group `ctake' `ctreat_grp' control

    foreach ctreat in `ctreat_grp' {
        preserve
        qui keep if control == 1 | `ctreat' == 1
        cap drop AT_`ctreat'
        qui gen AT_`ctreat' = (control == 1 & `ctake' == 1)

        qui reg `ctake' `ctreat' `cw', robust
        matrix pi_c = _b[`ctreat']

        qui reg AT_`ctreat' if `ctreat' == 0 `cw', robust
        matrix pi_at =  _b[_cons]

        qui reg `ctake' if `ctreat' == 1 `cw', robust
        matrix pi_nt = 1 - _b[_cons]
        
        restore
        assert pi_c[1,1] + pi_at[1,1] + pi_nt[1,1] > 0.999 ///
            & pi_c[1,1] + pi_at[1,1] + pi_nt[1,1] < 1.001
        matrix share_`ctreat' = pi_nt, pi_c
        mat drop pi_at pi_c pi_nt
        mat share = nullmat(share) , share_`ctreat'
    }
end

program complier_mean
    syntax, take(str) variables(str) treat_grp(str) weight(str)

	foreach var in `variables' {
		use ../temp/exhibit_analysis, clear
		
		** Clean data
        qui keep if SP == 1
		qui keep treatment pweight `variables' treat_group `take' `treat_grp' control
		
		assert !mi(`take')
		cap assert !mi(`var')
		if _rc != 0 {
			di "**************** `var' is missing"
		}
		else {
			di "`var' is non-missing"
		}
		
        foreach treat in `treat_grp' {
            ** Calculate complier means and p-values
            assert !mi(`treat')
            di "##### take-up determined by `take', treatment by `treat', var is `var' #####"
		
            qui cap drop AT_`treat'
            qui gen AT_`treat' = (control == 1 & `take' == 1)
		}

        iterations, ivar(`var') itake(`take') itreat_grp(`treat_grp') iw(`weight')
        
        foreach treat in `treat_grp' {
			local `treat'_co = `treat'_co[1,1]
            local `treat'_nt = `treat'_nt[1,1]
			matrix `var'_C = nullmat(`var'_C) , ``treat'_nt' , ``treat'_co'
		}
		
		di "Variable is `var'"
		mat list `var'_C

		preserve
		bootstrap_pvalue, btake(`take') bvar(`var') bw(`weight') btreat_grp(`treat_grp')
		restore
		
		matrix `take' = nullmat(`take') \ (`var'_C, J(1,2,.)) \ (`var'_pval)
		
        local dim = colsof(`take')
        matrix `take' = `take' \ J(1,`dim',.)

		matrix drop `var'_C `var'_pval
	}
end

	program bootstrap_pvalue
		syntax, btake(str) bvar(str) [bw(str) btreat_grp(str)]
		
		local orig_d_l_h = lowtouch_s_nt[1,1] - hightouch_nt[1,1]

        foreach btreat in `btreat_grp' {
			local orig_d_`btreat' = `btreat'_co[1,1] - `btreat'_nt[1,1]
			mat drop `btreat'_co `btreat'_nt
		}
		
		use ../temp/exhibit_analysis, clear
        qui keep if SP == 1
		qui keep treatment pweight `bvar' treat_group `btake' `btreat_grp' control

        foreach btreat in `btreat_grp' {
			qui gen AT_`btreat' = (control == 1 & `btake' == 1)
		}
		
		cap erase "../temp/`btake'`bvar'.dta"
		
		bootstrap diff_lt = r(lt_diff) diff_ht = r(ht_diff) diff_l_h = r(l_h_diff), ///
            reps(10000) saving(../temp/`btake'`bvar') seed(12) nodrop: iterations,  ///
            ivar(`bvar') itake(`btake') itreat_grp(`btreat_grp') iw(`bw')
        local orig_d_lt = `orig_d_lowtouch_s'
		local orig_d_ht = `orig_d_hightouch'
		local comparison = "lt ht l_h"
		
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
			matrix `bvar'_pval = nullmat(`bvar'_pval) , J(1,1,.) , `pval_`pair''
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
				
                *complier mean - mu_co
				matrix `itreat'_co = ((`itreat'_temp[1,2] + `itreat'_temp[1,1])*`itreat'_temp[1,4] - `itreat'_temp[1,2]*`itreat'_temp[1,3])/`itreat'_temp[1,1]
				
                *never taker mean - mu_nt
                qui reg `ivar' if `itreat' == 1 & `itake' == 0 `iw', robust
                matrix `itreat'_nt = _b[_cons]
                mat drop `itreat'_temp

				local `itreat'_co = `itreat'_co[1,1]
                local `itreat'_nt = `itreat'_nt[1,1]
			}
			
            scalar lt_diff = `lowtouch_s_co' - `lowtouch_s_nt'
			return scalar lt_diff = `lowtouch_s_co' - `lowtouch_s_nt'
				
			scalar ht_diff = `hightouch_co' - `hightouch_nt'
			return scalar ht_diff = `hightouch_co' - `hightouch_nt'
				
			scalar l_h_diff = `lowtouch_s_nt' - `hightouch_nt'
			return scalar l_h_diff = `lowtouch_s_nt' - `hightouch_nt'
			
            di "Exit iterations"
		end
			
main
