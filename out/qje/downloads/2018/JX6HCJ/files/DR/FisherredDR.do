
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', `robust'
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', `robust'
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatDR, clear

sum ratio, detail
global ratio_threshold=r(p50)

global controls="wave2 wave3 bg_boda bg_malevendor bg_boda_wave2 bg_malevendor_wave2 bg_married bg_num_children bg_age bg_kis_read bg_rosca_contrib_lyr filled_log "

matrix F = J(36,4,.)
matrix B = J(58,2,.)

global i = 1
global j = 1

*Table 2
foreach X in bank_savings animal_savings rosca_contrib {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table 3
foreach X in total_hours investment investment_t5 revenues {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table 4
foreach X in exp_total exp_food exp_tot_private {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

foreach X in tot_flow_out tot_flow_spouse {
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table A3 
mycmd (treatment) reg investment treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment) reg exp_total treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
foreach X in exp_food exp_tot_private {
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
	}

*Table A4
mycmd (treatment) reg investment treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment) reg exp_total treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
foreach X in exp_food exp_tot_private {
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
	}

generate N = _n
sort Strata N
generate Order = _n
generate double U = .
mata Y = st_data(.,"treatment") 

tab Strata bg_boda
tab Strata bg_malevendor
tab Strata bg_femalevendor

*Their are coding errors on female_vendor, but no treatment_bg_female_vendor entered in regressions
*So, since bg_boda and malevendor constant within strata, can just randomize treatment_bg_boda treatment_bg_malevendor these within strata

mata ResF = J($reps,36,.); ResD = J($reps,36,.); ResDF = J($reps,36,.); ResB = J($reps,58,.); ResSE = J($reps,58,.)
forvalues c = 1/$reps {
	matrix FF = J(36,3,.)
	matrix BB = J(58,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort Strata U
	mata st_store(.,"treatment",Y)
	quietly replace treatment_bg_boda = treatment*bg_boda
	quietly replace treatment_bg_malevendor = treatment*bg_malevendor

global i = 1
global j = 1

*Table 2
foreach X in bank_savings animal_savings rosca_contrib {
	mycmd1 (treatment) reg `X' treatment ${controls}, robust
	mycmd1 (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table 3
foreach X in total_hours investment investment_t5 revenues {
	mycmd1 (treatment) reg `X' treatment ${controls}, robust
	mycmd1 (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table 4
foreach X in exp_total exp_food exp_tot_private {
	mycmd1 (treatment) reg `X' treatment ${controls}, robust
	mycmd1 (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

foreach X in tot_flow_out tot_flow_spouse {
	mycmd1 (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table A3 
mycmd1 (treatment) reg investment treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd1 (treatment treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd1 (treatment treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd1 (treatment) reg exp_total treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd1 (treatment treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
foreach X in exp_food exp_tot_private {
	mycmd1 (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
	}

*Table A4
mycmd1 (treatment) reg investment treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd1 (treatment treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd1 (treatment treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd1 (treatment) reg exp_total treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd1 (treatment treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
foreach X in exp_food exp_tot_private {
	mycmd1 (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..36] = FF[.,1]'; ResD[`c',1..36] = FF[.,2]'; ResDF[`c',1..36] = FF[.,3]'
mata ResB[`c',1..58] = BB[.,1]'; ResSE[`c',1..58] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/36 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/58 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherRedDR, replace



