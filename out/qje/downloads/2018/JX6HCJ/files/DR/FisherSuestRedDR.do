
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* xxx* Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
	if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
	quietly generate Ssample$i = e(sample)
	if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
	if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
	quietly predict double yyy$i if Ssample$i, resid
	local newtestvars = ""
	foreach var in `testvars' {
		if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
		quietly predict double xxx`var'$i if Ssample$i, resid
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	quietly reg yyy$i `newtestvars', noconstant
	estimates store M$i
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

*Table 3
global i = 0
foreach X in total_hours investment investment_t5 revenues {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}
quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

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

mata ResF = J($reps,25,.)
forvalues c = 1/$reps {
	matrix FF = J(36,3,.)
	matrix BB = J(80,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort Strata U
	mata st_store(.,"treatment",Y)
	quietly replace treatment_bg_boda = treatment*bg_boda
	quietly replace treatment_bg_malevendor = treatment*bg_malevendor

*Table 2
global i = 0
foreach X in bank_savings animal_savings rosca_contrib {
	mycmd (treatment) reg `X' treatment ${controls}, robust
	mycmd (treatment treatment_bg_boda) reg `X' treatment treatment_bg_malevendor treatment_bg_boda ${controls}, robust
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
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
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
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
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
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
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 103)
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
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',21..25] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 104)
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
sort N
save results\FisherSuestredDR, replace



