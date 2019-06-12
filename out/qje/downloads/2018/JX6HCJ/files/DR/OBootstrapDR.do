
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust ]
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
	syntax anything [if] [in] [, robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `robust'
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			matrix V = V[1..$k,1..$k]
			matrix b = b[1,1..$k]
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) capture matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) capture matrix FF[$i,4] = chi2tail($k,f[1,1])
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

global a = 36
global b = 80

use DatDR, clear

sum ratio, detail
global ratio_threshold=r(p50)
global controls="wave2 wave3 bg_boda bg_malevendor bg_boda_wave2 bg_malevendor_wave2 bg_married bg_num_children bg_age bg_kis_read bg_rosca_contrib_lyr filled_log "

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table 2
foreach X in bank_savings animal_savings rosca_contrib {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table 3
foreach X in total_hours investment investment_t5 revenues {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table 4
foreach X in exp_total exp_food exp_tot_private {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

foreach X in tot_flow_out tot_flow_spouse {
	mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table A3 
mycmd (treatment) reg investment treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment) reg exp_total treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
foreach X in exp_food exp_tot_private {
	mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
	}

*Table A4
mycmd (treatment) reg investment treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment) reg exp_total treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
foreach X in exp_food exp_tot_private {
	mycmd (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
	}

gen N = _n
sort N
save aa, replace

egen NN = max(N)
keep NN
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

global i = 1
global j = 1

*Table 2
foreach X in bank_savings animal_savings rosca_contrib {
	mycmd1 (treatment) reg `X' treatment ${controls}, robust
	mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table 3
foreach X in total_hours investment investment_t5 revenues {
	mycmd1 (treatment) reg `X' treatment ${controls}, robust
	mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table 4
foreach X in exp_total exp_food exp_tot_private {
	mycmd1 (treatment) reg `X' treatment ${controls}, robust
	mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

foreach X in tot_flow_out tot_flow_spouse {
	mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

*Table A3 
mycmd1 (treatment) reg investment treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd1 (treatment) reg exp_total treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
foreach X in exp_food exp_tot_private {
	mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
	}

*Table A4
mycmd1 (treatment) reg investment treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd1 (treatment) reg exp_total treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
foreach X in exp_food exp_tot_private {
	mycmd1 (treatment treatment_bg_malevendor treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\OBootstrapDR, replace

erase aa.dta
erase aaa.dta


