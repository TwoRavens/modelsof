version 14
clear all
adopath + ../../../lib/stata/gslab_misc/ado
adopath + ../../../lib/stata/ado
set more off
loadglob using  "variables_for_tables.txt" // FILE CONTAINS GLOBAL VARS. USED IN THIS CODE

program main
    complier_mean, take(applicant_9m) variables(age_above) weight([pw=pweight]) treat_grp(treat_S_M)
    compute_share, ctake(applicant_9m) ctreat(treat_S_M) cw([pw=pweight]) 
    matrix Complier_5_E_1 = applicant_9m \ (share,.)
    mat drop share applicant_9m

    complier_mean, take(enrollee_9m) variables(age_above) weight([pw=pweight]) treat_grp(treat_S_M)
    compute_share, ctake(enrollee_9m) ctreat(treat_S_M) cw([pw=pweight]) 
    matrix Complier_5_E_2 = enrollee_9m \ (share,.)
    mat drop share enrollee_9m
    matrix Complier_AT_NT = Complier_5_E_1 , Complier_5_E_2

    fill_tables, mat(Complier_AT_NT) save_excel(../output_excel/Exhibits_Complier_Tables.xlsx)
end

program compute_share
    syntax, ctake(str) ctreat(str) cw(str)

    use ../temp/exhibit_analysis, clear
    qui keep if SP == 1
	qui keep treatment pweight treat_group `ctake' `ctreat' control

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
    matrix share = pi_c , pi_at, pi_nt
    mat drop pi_at pi_c pi_nt
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
		
		** Calculate complier means and p-values
		assert !mi(`treat_grp')
		di "##### take-up determined by `take', treatment by `treat_grp', var is `var' #####"
		
		qui cap drop AT_`treat_grp'
		qui gen AT_`treat_grp' = (control == 1 & `take' == 1)
		
		iterations, ivar(`var') itake(`take') itreat_grp(`treat_grp') iw(`weight')
			
		local `treat_grp'_co = `treat_grp'_co[1,1]
		di "complier mean is ``treat_grp'_co'"
		matrix `var'_C = ``treat_grp'_co', `var'_at[1,1] , `var'_nt[1,1]
		
		di "Variable is `var'"
		mat list `var'_C

		preserve
		bootstrap_pvalue, btake(`take') bvar(`var') bw(`weight') btreat_grp(`treat_grp')
		restore
		
		matrix `take' = nullmat(`take') \ (`var'_C, J(1,1,.)) \ (.,`var'_pval)
		
        local dim = colsof(`take')
        matrix `take' = `take' \ J(1,`dim',.)

		matrix drop `var'_C `var'_pval `var'_at `var'_nt
	}
end

	program bootstrap_pvalue
		syntax, btake(str) bvar(str) [bw(str) btreat_grp(str)]
		
		local orig_d_ca = `btreat_grp'_co[1,1] - `bvar'_at[1,1]
        local orig_d_cn = `btreat_grp'_co[1,1] - `bvar'_nt[1,1] 
        local orig_d_an = `bvar'_at[1,1] - `bvar'_nt[1,1]
		mat drop `btreat_grp'_co
		
		use ../temp/exhibit_analysis, clear
        qui keep if SP == 1
		qui keep treatment pweight `bvar' treat_group `btake' `btreat_grp' control

		qui gen AT_`btreat_grp' = (control == 1 & `btake' == 1)
        qui gen NT_`btreat_grp' = (`btreat_grp' == 1 & `btake' == 0)
		
		cap erase "../temp/`btake'`bvar'.dta"
		
		bootstrap diff_ca = r(ca_diff) diff_cn = r(cn_diff) diff_an = r(an_diff), ///
            reps(10000) saving(../temp/`btake'`bvar') seed(12) nodrop: iterations,  ///
            ivar(`bvar') itake(`btake') itreat_grp(`btreat_grp') iw(`bw')
		local comparison = "ca cn an"
		
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

			preserve
			qui keep if control == 1 | `itreat_grp' == 1
				
			*first stage (compliance rate) - fs (pi_c)
			qui reg `itake' `itreat_grp' `iw', robust
			matrix `itreat_grp'_temp = nullmat(`itreat_grp'_temp) , _b[`itreat_grp']
			
			*fraction of always taker - pi_at
			qui reg AT_`itreat_grp' if `itreat_grp' == 0 `iw', robust
			matrix `itreat_grp'_temp =  `itreat_grp'_temp , _b[_cons]
			
			*always taker mean - mu_at
			qui reg `ivar' if `itreat_grp' == 0 & `itake' == 1 `iw', robust
			matrix `itreat_grp'_temp =  `itreat_grp'_temp , _b[_cons]
			
			*mean among treatments who take up - mu_he
			qui reg `ivar' if `itreat_grp' == 1 & `itake' == 1 `iw', robust
			matrix `itreat_grp'_temp =  `itreat_grp'_temp , _b[_cons]
			restore
				
			matrix `itreat_grp'_co = ((`itreat_grp'_temp[1,2] + `itreat_grp'_temp[1,1])*`itreat_grp'_temp[1,4] - `itreat_grp'_temp[1,2]*`itreat_grp'_temp[1,3])/`itreat_grp'_temp[1,1]
			mat drop `itreat_grp'_temp
			local `itreat_grp'_co = `itreat_grp'_co[1,1]

			qui reg `ivar' if control == 1 & `itake' == 1 `iw', robust
			matrix `ivar'_at = _b[_cons]
			local `ivar'_at = `ivar'_at[1,1]

            qui reg `ivar' if `itreat_grp' == 1 & `itake' == 0 `iw', robust
            matrix `ivar'_nt = _b[_cons]
            local `ivar'_nt = `ivar'_nt[1,1]

			scalar ca_diff = ``itreat_grp'_co' - ``ivar'_at'
			return scalar ca_diff = ``itreat_grp'_co' - ``ivar'_at'
				
			scalar cn_diff = ``itreat_grp'_co' - ``ivar'_nt'
			return scalar cn_diff = ``itreat_grp'_co' - ``ivar'_nt'
				
			scalar an_diff = ``ivar'_at' - ``ivar'_nt'
			return scalar an_diff = ``ivar'_at' - ``ivar'_nt'
            di "Exit iterations"
		end
			
main
