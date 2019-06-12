version 14
set more off
clear all
adopath + ../../../lib/stata/gslab_misc/ado
adopath + ../../../lib/stata/ado
set more off
loadglob using  "variables_for_tables.txt" // FILE CONTAINS GLOBAL VARS. USED IN THIS CODE

program main
    regressions
    bos_char
end

program regressions
    use ../temp/exhibit_analysis, clear
    keep if hightouch == 1 & Icaller_9m == 1
    assert _N == 3179
	save ../temp/bos_analysis, replace

	foreach R in F {
        foreach v in age exp {
            preserve
            collapse (mean) `R'BOS_`v', by(`R'BOS_id)
            drop if `R'BOS_`v' == .
            sum `R'BOS_`v', de
            local `R'_`v'_m = r(p50)
            restore
            gen `R'BOS_`v'_above = `R'BOS_`v' > ``R'_`v'_m'
            replace `R'BOS_`v'_above = . if mi(`R'BOS_`v')
        }
        foreach o in applicant enrollee {
            foreach v in age exp {s
                reg `o'_9m `R'BOS_`v', robust
                matrix results = r(table)
                matrix `v' 	= nullmat(`v') \ results[1,1]
                matrix `v'  = `v' \ results[4,1] \ J(1,1,.)

                reg `o'_9m `R'BOS_`v'_above, robust
                matrix results = r(table)
                matrix `v' 	= `v' \ results[1,1]
                matrix `v'  = `v' \ results[4,1] \ J(1,1,.)
            }
            reg `o'_9m `R'BOS_male, robust
            matrix results = r(table)
            matrix male 	= nullmat(male) \ results[1,1]
            matrix male  = male \ results[4,1] \ J(1,1,.)

            reg `o'_9m `R'BOS_male##male, robust
            matrix results = r(table)
            matrix male 	= male \ results[1,8]
            matrix male  = male \ results[4,8] \ J(1,1,.)
			
			count if `R'BOS_age != .
			local N = r(N)
            mat `R'`o' = age \ exp \ male \ `N'
            mat `R'`o'_c = age_c \ exp_c \ male_c \ `N'
            mat drop age exp male age_c exp_c male_c
        }
    }
    mat BOS = Fapplicant, Fenrollee
   
    fill_tables, mat(BOS) save_excel(../output_excel/Analysis_BOS_Tables.xlsx)
end

program bos_char
    use ../temp/bos_analysis, clear
    gen Ncall = 1
    collapse (mean) FBOS_age FBOS_male FBOS_exp (sum) Ncall, by(FBOS_id)
    rename Ncall FBOS_ncall
    foreach v in age exp male ncall {
        sum FBOS_`v', de
        matrix `v' = (r(mean), r(min), r(p25), r(p50), r(p75), r(p95), r(max))\(r(sd), J(1,6,.))\J(1,7,.)
        local N = r(N)
        matrix BOS_char = nullmat(BOS_char)\ `v'
    }
    matrix BOS_char = BOS_char\(`N',J(1,6,.))
    fill_tables, mat(BOS_char) save_excel(../output_excel/Analysis_BOS_Tables.xlsx)
end

main
