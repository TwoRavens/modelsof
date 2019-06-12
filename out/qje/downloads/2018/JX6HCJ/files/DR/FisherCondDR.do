
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

use DatDR, clear

sum ratio, detail
global ratio_threshold=r(p50)

global controls="wave2 wave3 bg_boda bg_malevendor bg_boda_wave2 bg_malevendor_wave2 bg_married bg_num_children bg_age bg_kis_read bg_rosca_contrib_lyr filled_log "

matrix F = J(36,4,.)
matrix B = J(80,2,.)

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

*Since bg_boda and malevendor constant within strata, can just randomize treatment treatment_bg_boda treatment_bg_malevendor within strata
global treatvars = "treatment treatment_bg_boda treatment_bg_malevendor" 

global i = 0

*Table 2
foreach X in bank_savings animal_savings rosca_contrib {

global i = $i + 1
	randcmdc ((treatment) reg `X' treatment ${controls}, robust), treatvars($treatvars) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

	forvalues j = 1/3 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}
	}

*Table 3
foreach X in total_hours investment investment_t5 revenues {

global i = $i + 1
	randcmdc ((treatment) reg `X' treatment ${controls}, robust), treatvars($treatvars) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

	forvalues j = 1/3 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}
	}

*Table 4
foreach X in exp_total exp_food exp_tot_private {

global i = $i + 1
	randcmdc ((treatment) reg `X' treatment ${controls}, robust), treatvars($treatvars) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

	forvalues j = 1/3 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}
	}

foreach X in tot_flow_out tot_flow_spouse {
	forvalues j = 1/3 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}
	}

*Table A3 
global i = $i + 1
	randcmdc ((treatment) reg investment treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust), treatvars($treatvars) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

	forvalues j = 1/6 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}

global i = $i + 1
	randcmdc ((treatment) reg exp_total treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust), treatvars($treatvars) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

	forvalues j = 1/3 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}
foreach X in exp_food exp_tot_private {
	forvalues j = 1/3 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}
	}

*Table A4
global i = $i + 1
	randcmdc ((treatment) reg investment treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust), treatvars($treatvars) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

	forvalues j = 1/6 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}

global i = $i + 1
	randcmdc ((treatment) reg exp_total treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust), treatvars($treatvars) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 

	forvalues j = 1/3 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}

foreach X in exp_food exp_tot_private {
	forvalues j = 1/3 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}
	}


matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondDR, replace


