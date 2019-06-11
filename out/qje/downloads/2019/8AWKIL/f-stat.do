version 14
clear all 
set more off
set trace off
set matsize 11000
set seed 12345
adopath + ../../../lib/stata/gslab_misc/ado
adopath + ../../../lib/stata/ado
loadglob using  "variables_for_tables.txt" // FILE CONTAINS GLOBAL VARS. USED IN THIS CODE

program main
	permutation_test, group1(hightouch) group2(control) weighting([pw=sim_pweight]) missing_var(spending_cen)
	permutation_test, group1(lowtouch_s) group2(control) weighting([pw=sim_pweight]) missing_var(spending_cen)
	permutation_test, group1(hightouch) group2(lowtouch_s) weighting([pw=sim_pweight]) missing_var(spending_cen)
	
	permutation_test, group1(G1) group2(control) missing_var(spending_cen)
	permutation_test, group1(G2) group2(control) missing_var(spending_cen)
	permutation_test, group1(G3) group2(control) missing_var(spending_cen)
	permutation_test, group1(G4) group2(control) missing_var(spending_cen)
	permutation_test, group1(G5) group2(control) missing_var(spending_cen)
	permutation_test, group1(G6) group2(control) missing_var(spending_cen)
	
	permutation_test, group1(treat_S_M) group2(control) weighting([pw=sim_pweight]) missing_var(spending_cen)
	permutation_test, group1(G3) group2(G6) weighting([pw=sim_pweight]) missing_var(spending_cen)
	permutation_test, group1(marketing) group2(standard) weighting([pw=sim_pweight]) missing_var(spending_cen)
	permutation_test, group1(G3) group2(G4) weighting([pw=sim_pweight]) missing_var(spending_cen)
end

program permutation_test
	syntax, group1(str) group2(str) [weighting(str) missing_var(str)]
	mat drop _all
	use ../temp/exhibit_analysis, clear
	keep if treat_group != .
	keep if `group1' == 1 | `group2' == 1
	cap drop id
	local variables "age age_80plus male race_white race_black non_english city_pitt Ibefore_2011 Ifull_year hospital ED doctor SNF chronic `missing_var'" //need to add back spending_cen
	
	foreach var in `variables' {
		cap assert !mi(`var')
		if _rc != 0 {
			di "`var' is not non-missing"
		}
		replace `var' = -99999 if `var' == .
		gen missing_`var' = `var' == -99999
	}
	di "Start stacked regression"
	sim_stacked, covs(`variables') grp(`group1') iter(1000) matname("F_`group1'`group2'") weights(`weighting') miss_var(`missing_var')
end


program stacked_reg
	syntax, covs(str) grp(str) [weight(str) covs_w_lags(str) controls(str) lagyear1(str) lagyear2(str)]
	
	gen id = _n
	local numtest : word count `covs' `covs_w_lags'
	local numlags : word count `covs_w_lags'
	local lags_start = `numtest' - `numlags' + 1
	
	* Expanding dataset for stacked regressions
	qui compress
	qui expand `numtest'
	bysort id: gen order = _n
	gen outcome = .		

	* Creating variables for stacked regressions
	local i = 0
	gen constant = 1

	foreach var in `covs' `covs_w_lags' {
		local i = `i'+1
		replace outcome = `var' if (order == `i')
		gen Itreat_`i' = (`grp')*(order == `i') 
		gen constant_`i' = constant*(order == `i') 
		foreach cont in `controls'{
			gen X`i'`cont' = `cont'*(order==`i')
		}
		if `i' >= `lags_start'  {
			gen X`i'`var'_`lagyear1' = `var'_`lagyear1'*(order == `i')
			gen X`i'`var'_`lagyear2' = `var'_`lagyear2'*(order == `i')
		}
		gen X`i'missing_`var' = missing_`var'*(order == `i')
	}
	
	*** CHECK THAT DATA SET IS CORRECT ***
	
	* This checks that only LHS of the vars have lagged outcomes on RHS
	* Lagged outcome only enters on RHS if the same var is on LHS
	local numlags : word count `covs_w_lags'
	if `numlags' != 0 {
		foreach var in `covs' `covs_w_lags' {
			forvalues i = 1/`numtest'  {
				foreach year in `lagyear1' `lagyear2' {
					capture confirm variable X`i'`var'`year' if order != `i'
					if !_rc {
						clear all
						di "Error: X`i'`lag' exists!"
					}
				}
			}
		}
	}
	
	* This checks that the missing indicator only enters the RHS when the same var is on LHS
	forvalues i = 1/`numtest' {
		assert X`i'missing_ == 0 if order != `i'
	}
	
	* Double check that the RHS vars are correct
	foreach var in `covs' `covs_w_lags' {
		local i = `i' + 1
		sum X`i'missing_`var' if order == `i'
		local stack_mean = r(mean)
		sum missing_`var'
		local original_mean = r(mean)
		assert abs(`stack_mean' - `original_mean') < 0.00001
	}
	
	if `numlags' != 0 {
		local i = `lags_start' - 1
		foreach var in `covs_w_lags' {
			local i = `i' + 1
			foreach year in `lagyear1' `lagyear2' {
				sum X`i'`var'_`year' if order == `i'
				local stack_mean = r(mean)
				sum `var'_`year'
				local original_mean = r(mean)
				assert abs(`stack_mean' - `original_mean') < 0.00001
			}
		}
	}
	
	save ../temp/block_reg_f_test_data, replace
	
	* Running stacked regressions and f-tests
	reg outcome Itreat_* constant_* X* `weight', cluster(id) nocons

	* for check
	local i = 0
	foreach var in `covs' `covs_w_lags' {
		local i = `i'+1
		local `var'_s_beta = round(_b[Itreat_`i'],0.001)
	}
		
	testparm Itreat_*
		
	matrix stacked = (r(F) , r(p), r(df_r), r(df))
	matrix colnames stacked = "f" "p" "df_r" "df"
	
	*** CHECK THAT STACKED REG PRODUCES SAME BETA AS ORIGINAL REG ***
	cap matrix drop stacked_beta 
	local i = 0
	local rowname = ""
	foreach var in `covs' `covs_w_lags' {
		local i = `i' + 1
		reg `var' `grp' X`i'* `weight' if order == `i', r
		matrix results=r(table)
		local `var'_d_beta = round(results[1,1],0.001)
		di "`var': simple reg: ``var'_d_beta', stacked: ``var'_s_beta'"
		assert round(``var'_d_beta',0.001) == round(``var'_s_beta',0.001)
			
		qui sum `var' if `grp' == 0 & order == `i' & missing_`var' == 0
		local mean_control = r(mean)
		qui sum `var' if `grp' == 1 & order == `i' & missing_`var' == 0
		local mean_treat = r(mean)
		matrix stacked_beta = (nullmat(stacked_beta)\(`mean_control', `mean_treat', (abs(min(-1*results[4,1],0)))))
		local rowname = "`rowname' `var'"
	}
	
	matrix rownames stacked_beta = `rowname'
	matrix colnames stacked_beta = "control" "treat" "p"
	
	di "Covariates: `covs'"
	di "Controls: `controls'"
	matrix list stacked
end


program sim_stacked
	syntax, covs(str) grp(str) iter(str) matname(str) ///
            [weights(str) stratum_id(str) covs_w_lags(str) controls(str) lagyear1(str) lagyear2(str) miss_var(str)] 
	
	*clear matrices at beginning so can run sequentially
	cap matrix drop sim_stacked
	cap matrix drop sim_mat
	set more off
	
	save ../temp/orig.dta,replace
	gen sim_pweight = pweight

	timer on 1
	qui stacked_reg, covs(`covs') grp(`grp') weight(`weights')
	timer off 1
	timer list 1

	local orig_f = stacked[1,1]
	local orig_p = stacked[1,2]
	
	qui count if `grp' ==1
	local treat = r(N)
	
	local it = 1500
	cap local it = `iter'
	local mat = `it'+1
	di "matsize: `mat'"
	if `it'>1000 {
	set matsize `mat'
	}
	
	*simulation
	local loop_counter = 1
	forval i = 1/`it' {
		use ../temp/orig.dta,clear
		local seed = 2*`i'
		set seed `seed'
		gen random = runiform() 
		gsort random
		count if `grp' == 1
		gen T = _n <= r(N)

        gen sim_pweight = .

		gen simulated_treat = T == 1 
		drop T

        levelsof pweight if `grp' == 1, local(PofT)
        local a = 0
        foreach pw of local PofT {
            local a = `a' + 1
            local pw_T_`a' = `pw'
            count if `grp' == 1 & abs(pweight - `pw') < 0.0001
            local Npw_T_`a' = r(N)
        }

        levelsof pweight if `grp' == 0, local(PofC)
        local b = 0
        foreach pw of local PofC {
            local b = `b' + 1
            local pw_C_`b' = `pw'
            count if `grp' == 0 & abs(pweight - `pw') < 0.0001
            local Npw_C_`b' = r(N)
        }
        gsort random
        local Npw_T_0 = 0
        local Npw_C_0 = 0
		forval c = 1/`a' {
            local d = `c' - 1
            di "T: c is `c', d is `d', pw is `pw_T_`c''"
            replace sim_pweight = `pw_T_`c'' if _n > `Npw_T_`d'' & _n <= (`Npw_T_`c'' + `Npw_T_`d'')
        }
        gsort -random
        forval c = 1/`b' {
            di "C: c is `c', d is `d', pw is `pw_C_`c''"
            local d = `c' - 1
            replace sim_pweight = `pw_C_`c'' if _n > `Npw_C_`d'' & _n <= (`Npw_C_`c'' + `Npw_C_`d'')
        }
        assert !mi(sim_pweight)
        drop random

		qui stacked_reg, covs(`covs') grp(simulated_treat) weight(`weights')
		matrix sim_mat = nullmat(sim_mat) \ (stacked)

		drop simulated_treat sim_pweight
		di "Iteration number: `loop_counter' " 
		local loop_counter=`loop_counter'+1
	}
	matrix colnames sim_mat = "f" "p" "df_r" "df"
	
	*summarize matrix
	clear
	svmat sim_mat, names(col)
	qui sum f 
	matrix sim_stacked= (r(mean), r(sd))
	qui sum p
	matrix sim_stacked = (sim_stacked, r(mean))
	qui sum df_r
	matrix sim_stacked = (sim_stacked, r(mean))
	qui sum df
	matrix sim_stacked = (sim_stacked, r(mean))
	gen pval = (f >`orig_f')
	qui sum pval
	local p = r(mean)
	matrix sim_stacked = (`p', `orig_p', `orig_f', sim_stacked)
	matrix colnames sim_stacked = "sim_pvalue" "orig_pval" "orig_fstat" ///
		"mn_fstat" "mn_fstat_sd" "mn_fstat_p" "df_r" "df"
	matrix list sim_stacked

    if "`miss_var'" != "" {
        mat2txt, matrix(sim_stacked) saving("../output_excel/F-stats/`matname'.txt") replace
    }
    else {
        mat2txt, matrix(sim_stacked) saving("../output_excel/F-stats/`matname'_t.txt") replace
    }
	
	*save sim data
	foreach var in `covs' {
		local covariates = `"`covariates'_`var'"' //"correct syntax hilighting
	}
	di "Covariates: `covariates'"
	
	save ../temp/sim_stacked.dta, replace
	
	*load original dataset
	use ../temp/orig.dta,clear
	 
	*remove datasets
	rm ../temp/orig.dta
	matrix list sim_stacked

end
	

* Execute
main
