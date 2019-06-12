
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in'
	if (_rc == 0) {
		estimates store M$i
		foreach var in `newtestvars' {
			global j = $j + 1
			matrix B[1,$j] = _b[`var']
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatDR, clear

sum ratio, detail
global ratio_threshold=r(p50)
global controls="wave2 wave3 bg_boda bg_malevendor bg_boda_wave2 bg_malevendor_wave2 bg_married bg_num_children bg_age bg_kis_read bg_rosca_contrib_lyr filled_log "

*Table 2
global i = 0
foreach X in bank_savings animal_savings rosca_contrib {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)
matrix B2 = B[1,1..$j]

*Table 3
global i = 0
foreach X in total_hours investment investment_t5 revenues {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)
matrix B3 = B[1,1..$j]

*Table 4
global i = 0
foreach X in exp_total exp_food exp_tot_private {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

foreach X in tot_flow_out tot_flow_spouse {
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)
matrix B4 = B[1,1..$j]

*Table A3 
global i = 0
mycmd (treatment) reg investment treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment) reg exp_total treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
foreach X in exp_food exp_tot_private {
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
	}

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 103)
matrix B103 = B[1,1..$j]

*Table A4
global i = 0
mycmd (treatment) reg investment treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment) reg exp_total treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
foreach X in exp_food exp_tot_private {
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
	}

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 104)
matrix B104 = B[1,1..$j]

gen N = _n
sort N
save aa, replace

egen NN = max(N)
keep NN
save aaa, replace

mata ResF = J($reps,25,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa

*Table 2
global i = 0
foreach X in bank_savings animal_savings rosca_contrib {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B2)*invsym(V)*(B[1,1..$j]-B2)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
		}
	}

*Table 3
global i = 0
foreach X in total_hours investment investment_t5 revenues {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

*Table 4
global i = 0
foreach X in exp_total exp_food exp_tot_private {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

foreach X in tot_flow_out tot_flow_spouse {
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
		}
	}

*Table A3 
global i = 0
mycmd (treatment) reg investment treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment) reg exp_total treatment ${controls} if total_wd_loan==. | total_wd_loan==0, robust
mycmd (treatment treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
foreach X in exp_food exp_tot_private {
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if total_wd_loan==. | total_wd_loan==0, robust
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B103)*invsym(V)*(B[1,1..$j]-B103)'
		mata test = st_matrix("test"); ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', test[1,1], 103)
		}
	}

*Table A4
global i = 0
mycmd (treatment) reg investment treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_boda) reg investment treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_boda) reg investment_t5 treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment) reg exp_total treatment ${controls} if (ratio<$ratio_threshold | ratio==.), robust
mycmd (treatment treatment_bg_boda) reg exp_total treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
foreach X in exp_food exp_tot_private {
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls} if (ratio<$ratio_threshold | ratio==.), robust
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B104)*invsym(V)*(B[1,1..$j]-B104)'
		mata test = st_matrix("test"); ResF[`c',21..25] = (`r(p)', `r(drop)', `r(df)', test[1,1], 104)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/25 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save results\OBootstrapSuestRedDR, replace

erase aa.dta
erase aaa.dta

