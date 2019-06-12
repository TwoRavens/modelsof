****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xxx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab anything: `anything'
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
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
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xxx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"
end

****************************************
****************************************

use DatGGY1, clear

*Table 3
global i = 0
foreach outcome in approved any_loan {
	mycmd (fingerprint) reg `outcome' fingerprint D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
foreach outcome in total_owed {
	mycmd (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in approved any_loan {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
foreach outcome in total_owed {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in approved any_loan {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
foreach outcome in total_owed {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}

quietly suest $M, cluster(bfirm_club_id)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

*Table 4 
global i = 0
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}

quietly suest $M, cluster(bfirm_club_id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

*eliminating colinear variables

*Table 5
global i = 0
*foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize {
foreach outcome in frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_not_maize {
	mycmd (fingerprint) reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
*foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize {
foreach outcome in frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_not_maize {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
*foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize {
foreach outcome in frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_not_maize {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

quietly suest $M, cluster(bfirm_club_id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

*eliminating colinear variables

*Table 6
global i = 0
*foreach outcome in seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap {
foreach outcome in seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk inputs_pap_mk manure_kg_pap weed_pap {
	mycmd (fingerprint) reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
*foreach outcome in seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap {
foreach outcome in seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk inputs_pap_mk manure_kg_pap weed_pap {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
*foreach outcome in seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap {
foreach outcome in seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk inputs_pap_mk manure_kg_pap weed_pap {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

quietly suest $M, cluster(bfirm_club_id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

*Table 7
global i = 0
foreach outcome in sales_self home_prod profits_self ln_profits_self {
	mycmd (fingerprint) reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in sales_self home_prod profits_self ln_profits_self {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in sales_self home_prod profits_self ln_profits_self {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

quietly suest $M, cluster(bfirm_club_id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

generate Order = _n
generate double U = .

global N = 249
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,25,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace fingerprint = Y2[`i'] if bfirm_club_id == Y3[`i']
		}

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

*Table 3
global i = 0
foreach outcome in approved any_loan {
	mycmd (fingerprint) reg `outcome' fingerprint D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
foreach outcome in total_owed {
	mycmd (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in approved any_loan {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
foreach outcome in total_owed {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in approved any_loan {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
foreach outcome in total_owed {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}

capture suest $M, cluster(bfirm_club_id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}

*Table 4 
global i = 0
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}

capture suest $M, cluster(bfirm_club_id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

*Table 5
global i = 0
foreach outcome in frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_not_maize {
	mycmd (fingerprint) reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_not_maize {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_not_maize {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

capture suest $M, cluster(bfirm_club_id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}

*Table 6
global i = 0
foreach outcome in seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk inputs_pap_mk manure_kg_pap weed_pap {
	mycmd (fingerprint) reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk inputs_pap_mk manure_kg_pap weed_pap {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk inputs_pap_mk manure_kg_pap weed_pap {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

capture suest $M, cluster(bfirm_club_id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
		}
	}

*Table 7
global i = 0
foreach outcome in sales_self home_prod profits_self ln_profits_self {
	mycmd (fingerprint) reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in sales_self home_prod profits_self ln_profits_self {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}
foreach outcome in sales_self home_prod profits_self ln_profits_self {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

capture suest $M, cluster(bfirm_club_id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',21..25] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 7)
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
save results\FisherSuestGGY, replace

