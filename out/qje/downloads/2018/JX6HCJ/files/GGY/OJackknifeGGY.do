
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end


****************************************
****************************************

global b = 232

use DatGGY1, clear

global covars "male agedum2 agedum3 agedum4 agedum5 agedum6 agedum7 agedum8 agedum9 agedum10 agedum11 agedum12 agedum13 agedum14 agedum15 agedum16 married educdum2 educdum3 educdum4 educdum5 educdum6 educdum7 educdum8 educdum9 educdum10"
global riskfactors "risky hungry late incomesd paprikaexp default nopreviousloan"

matrix B = J($b,1,.)

global j = 1
*Table 3
foreach outcome in approved any_loan {
	mycmd (fingerprint) reg `outcome' fingerprint D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
foreach outcome in total_owed {
	mycmd (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Table 4 
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	mycmd (fingerprint) reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

*Table 3
foreach outcome in approved any_loan {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

*Table 3
foreach outcome in approved any_loan {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

drop if bfirm_club_id == .
egen M = group(bfirm_club_id)
quietly sum M
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if M == `c'

	drop _I* pred* catd top* bot* fp_pred*
	quietly xi: reg frac_paid_sept30 $covars $riskfactors i.focode*i.offer_week if fingerprint==0 & source_oct_repay==1, cluster(bfirm_club_id)
	quietly predict pred_repayment if source_oct_baseline==1, xb
	quietly gen pred_treat=pred_repayment*fingerprint
	quietly tab fingerprint, sum(pred_repayment)
	quietly egen catd=cut(pred_repayment) if any_loan==1, group(5)
	forval n=0/4 {
		quietly egen top`n'=max(pred_repayment) if catd==`n'
		quietly egen bot`n'=min(pred_repayment) if catd==`n'
		}
	quietly egen top=max(top0)
	quietly egen bot=max(bot0)
	quietly replace catd=0 if pred_repayment<=top & pred_repayment>=bot & any_loan==0
	forval n=1/4 {
		quietly drop top bot
		quietly egen bot=max(bot`n')
		quietly egen top=max(top`n')
		quietly replace catd=`n' if pred_repayment<=top & pred_repayment>=bot & any_loan==0
		}
	quietly tab catd, gen(pred_repay_ddum)
	foreach num in 1 2 3 4 5 {
		quietly gen fp_pred_repayd`num'=pred_repay_ddum`num'*fingerprint
		}  

global j = 1
*Table 3
foreach outcome in approved any_loan {
	mycmd1 (fingerprint) reg `outcome' fingerprint D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
foreach outcome in total_owed {
	mycmd1 (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Table 4 
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd1 (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	mycmd1 (fingerprint) reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

*Table 3
foreach outcome in approved any_loan {
	mycmd1 (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd1 (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	mycmd1 (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

*Table 3
foreach outcome in approved any_loan {
	mycmd1 (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd1 (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	mycmd1 (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
svmat double B
gen N = _n
save results\OJackknifeGGY, replace








