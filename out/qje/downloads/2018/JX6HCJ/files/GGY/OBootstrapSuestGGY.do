

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		matrix B = J(1,100,.)
		estimates clear
		global j = 0
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab anything: `anything'
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' [`weight' `exp'] if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' [`weight' `exp'] if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture reg yyy$i `newtestvars' [`weight' `exp'], noconstant
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	else {
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' 
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture `cmd' `dep' `newtestvars' `anything' `if' `in', 
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
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
matrix B3 = B[1,1..$j]

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
matrix B4 = B[1,1..$j]

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
matrix B5 = B[1,1..$j]

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
matrix B6 = B[1,1..$j]

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
matrix B7 = B[1,1..$j]

drop if bfirm_club_id == .
gen Order = _n
sort bfirm_club_id Order
gen N = 1
gen Dif = (bfirm_club_id ~= bfirm_club_id[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,25,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop bfirm_club_id
	rename obs bfirm_club_id

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
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
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
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
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
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
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
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B6)*invsym(V)*(B[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
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
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B7)*invsym(V)*(B[1,1..$j]-B7)'
		mata test = st_matrix("test"); ResF[`c',21..25] = (`r(p)', `r(drop)', `r(df)', test[1,1], 7)
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
save results\OBootstrapSuestGGY, replace

erase aa.dta
erase aaa.dta
