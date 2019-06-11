
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `robust'
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
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', cluster(`cluster') `robust'
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

global a = 29
global b = 29

use DatGGY1, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
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

*Note bootstrapping all bfirms, including those that were not in 249 bfirm experimental sample, because this is 
*how they calculate s.e. later on - i.e. bootstrapping from this larger sample (reproducing systematic error in their code)
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

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop bfirm_club_id
	rename obs bfirm_club_id

global i = 1
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
save ip\OBootstrapGGY1, replace

************************************
************************************

global a = 29
global b = 58

use DatGGY2, clear

global covars "male agedum2 agedum3 agedum4 agedum5 agedum6 agedum7 agedum8 agedum9 agedum10 agedum11 agedum12 agedum13 agedum14 agedum15 agedum16 married educdum2 educdum3 educdum4 educdum5 educdum6 educdum7 educdum8 educdum9 educdum10"
global riskfactors "risky hungry late incomesd paprikaexp default nopreviousloan"

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
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

*This reproduces (shortens) their code for standard errors and extracts the full covariance matrix - identical results to their code
matrix BS = J(200,58,.)
set seed 111111111
forvalues c = 1/200 {
preserve
	drop _I* pred* catd top* bot* fp_pred*
	display "`c'"
	quietly bsample, cluster(bfirm_club_id)
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
	local j = 1
	*Table 3	
	foreach outcome in approved any_loan {
		quietly reg `outcome' fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, cluster(bfirm_club_id)
			matrix BS[`c',`j'] = _b[fingerprint] , _b[pred_treat] 
		local j = `j' + 2
		}
	*Tables 3 & 4 
	foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
		quietly reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
			matrix BS[`c',`j'] = _b[fingerprint] , _b[pred_treat] 
		local j = `j' + 2
		}
	*Tables 5, 6 & 7
	foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
		quietly reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
			matrix BS[`c',`j'] = _b[fingerprint] , _b[pred_treat] 
		local j = `j' + 2
		}
restore
	}

preserve
drop _all
svmat double BS
forvalues i = 1/29 {
	local k1 = 2*(`i'-1)+1 
	local k2 = 2*`i'
	quietly corr BS`k1'-BS`k2', cov
	matrix t = r(C)
	matrix tt = B[`k1'..`k2',1]'*invsym(t)*B[`k1'..`k2',1]
	matrix F[`i',1] = chi2tail(2,tt[1,1]), 0, . , 2
	}
collapse (sd) BS*, fast
mkmat BS1-BS58, matrix(t)
matrix B[1,2] = t'
restore

*Note bootstrapping all bfirms, including those that were not in 249 bfirm experimental sample, because this is 
*how they calculate s.e. later on - i.e. bootstrapping from this larger sample 
drop if bfirm_club_id == .
gen Order = _n
sort bfirm_club_id Order
gen N = 1
gen Dif = (bfirm_club_id ~= bfirm_club_id[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save bb, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop bfirm_club_id
	rename obs bfirm_club_id

global i = 1
global j = 1
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

*This reproduces (shortens) their code for standard errors and extracts the full covariance matrix - follows their code
matrix BS = J(200,58,.)
set seed 111111111
forvalues cc = 1/200 {
preserve
	drop _I* pred* catd top* bot* fp_pred*
	display "`cc'"
	quietly bsample, cluster(bfirm_club_id)
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
	local j = 1
	*Table 3	
	foreach outcome in approved any_loan {
		quietly reg `outcome' fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, cluster(bfirm_club_id)
			matrix BS[`cc',`j'] = _b[fingerprint] , _b[pred_treat] 
		local j = `j' + 2
		}
	*Tables 3 & 4 
	foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
		quietly reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
			matrix BS[`cc',`j'] = _b[fingerprint] , _b[pred_treat] 
		local j = `j' + 2
		}
	*Tables 5, 6 & 7
	foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
		quietly reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
			matrix BS[`cc',`j'] = _b[fingerprint] , _b[pred_treat] 
		local j = `j' + 2
		}
restore
	}

preserve
drop _all
svmat double BS
forvalues i = 1/29 {
	local k1 = 2*(`i'-1)+1 
	local k2 = 2*`i'
	quietly corr BS`k1'-BS`k2', cov
	matrix t = r(C)
	matrix tt = BB[`k1'..`k2',1]'*invsym(t)*BB[`k1'..`k2',1]
	matrix FF[`i',1] = chi2tail(2,tt[1,1])
	matrix tt = (B[`k1'..`k2',1]-BB[`k1'..`k2',1])'*invsym(t)*(B[`k1'..`k2',1]-BB[`k1'..`k2',1])
	matrix FF[`i',4] = chi2tail(2,tt[1,1])
	}
collapse (sd) BS*, fast
mkmat BS1-BS58, matrix(t)
matrix BB[1,2] = t'
restore

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
save ip\OBootstrapGGY2, replace

************************************
************************************

global a = 29
global b = 145

use DatGGY3, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global covars "male agedum2 agedum3 agedum4 agedum5 agedum6 agedum7 agedum8 agedum9 agedum10 agedum11 agedum12 agedum13 agedum14 agedum15 agedum16 married educdum2 educdum3 educdum4 educdum5 educdum6 educdum7 educdum8 educdum9 educdum10"
global riskfactors "risky hungry late incomesd paprikaexp default nopreviousloan"

global i = 1
global j = 1
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

*This reproduces (shortens) their code for standard errors and extracts the full covariance matrix
matrix BS = J(200,145,.)
set seed 111111111
forvalues c = 1/200 {
preserve
	drop _I* pred* catd top* bot* fp_pred*
	display "`c'"
	quietly bsample, cluster(bfirm_club_id)
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
	  
	local j = 1
	*Table 3	
	foreach outcome in approved any_loan {
		quietly reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* D2-D32 if samp1 == 1, cluster(bfirm_club_id)
			matrix BS[`c',`j'] = (_b[fp_pred_repayd1], _b[fp_pred_repayd2], _b[fp_pred_repayd3], _b[fp_pred_repayd4], _b[fp_pred_repayd5]) 
		local j = `j' + 5
		}
	*Tables 3 &  4 
	foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
		quietly reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
			matrix BS[`c',`j'] = (_b[fp_pred_repayd1], _b[fp_pred_repayd2], _b[fp_pred_repayd3], _b[fp_pred_repayd4], _b[fp_pred_repayd5]) 
		local j = `j' + 5
		}
	*Tables 5, 6 & 7
	foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
		quietly reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
			matrix BS[`c',`j'] = (_b[fp_pred_repayd1], _b[fp_pred_repayd2], _b[fp_pred_repayd3], _b[fp_pred_repayd4], _b[fp_pred_repayd5]) 
		local j = `j' + 5
		}
restore
	}	

preserve
drop _all
svmat double BS
forvalues i = 1/29 {
	local k1 = 5*(`i'-1)+1 
	local k2 = 5*`i'
	quietly corr BS`k1'-BS`k2', cov
	matrix t = r(C)
	matrix tt = B[`k1'..`k2',1]'*invsym(t)*B[`k1'..`k2',1]
	matrix F[`i',1] = chi2tail(5,tt[1,1]), 0, . , 5
	}
collapse (sd) BS*, fast
mkmat BS1-BS145, matrix(t)
matrix B[1,2] = t'
restore

*Note bootstrapping all bfirms, including those that were not in 249 bfirm experimental sample, because this is 
*how they calculate s.e. later on - i.e. bootstrapping from this larger sample 
drop if bfirm_club_id == .
gen Order = _n
sort bfirm_club_id Order
gen N = 1
gen Dif = (bfirm_club_id ~= bfirm_club_id[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save cc, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using cc
	drop bfirm_club_id
	rename obs bfirm_club_id

global i = 1
global j = 1
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

*This reproduces (shortens) their code for standard errors and extracts the full covariance matrix
matrix BS = J(200,145,.)
set seed 111111111
forvalues cc = 1/200 {
preserve
	drop _I* pred* catd top* bot* fp_pred*
	display "`cc'"
	quietly bsample, cluster(bfirm_club_id)
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
	  
	local j = 1
	*Table 3	
	foreach outcome in approved any_loan {
		quietly reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* D2-D32 if samp1 == 1, cluster(bfirm_club_id)
			matrix BS[`cc',`j'] = (_b[fp_pred_repayd1], _b[fp_pred_repayd2], _b[fp_pred_repayd3], _b[fp_pred_repayd4], _b[fp_pred_repayd5]) 
		local j = `j' + 5
		}
	*Tables 3 &  4 
	foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
		quietly reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
			matrix BS[`cc',`j'] = (_b[fp_pred_repayd1], _b[fp_pred_repayd2], _b[fp_pred_repayd3], _b[fp_pred_repayd4], _b[fp_pred_repayd5]) 
		local j = `j' + 5
		}
	*Tables 5, 6 & 7
	foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
		quietly reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
			matrix BS[`cc',`j'] = (_b[fp_pred_repayd1], _b[fp_pred_repayd2], _b[fp_pred_repayd3], _b[fp_pred_repayd4], _b[fp_pred_repayd5]) 
		local j = `j' + 5
		}
restore
	}	

preserve
drop _all
svmat double BS
forvalues i = 1/29 {
	local k1 = 5*(`i'-1)+1 
	local k2 = 5*`i'
	quietly corr BS`k1'-BS`k2', cov
	matrix t = r(C)
	matrix tt = BB[`k1'..`k2',1]'*invsym(t)*BB[`k1'..`k2',1]
	matrix FF[`i',1] = chi2tail(5,tt[1,1])
	matrix tt = (BB[`k1'..`k2',1]-B[`k1'..`k2',1])'*invsym(t)*(BB[`k1'..`k2',1]-B[`k1'..`k2',1])
	matrix FF[`i',4] = chi2tail(5,tt[1,1])
	}
collapse (sd) BS*, fast
mkmat BS1-BS145, matrix(t)
matrix BB[1,2] = t'
restore

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
save ip\OBootstrapGGY3, replace

************************************
************************************

matrix count = (29,29,29) \ (29, 58, 145)

*Combining files

drop _all
use ip\OBootstrapGGY1
global N = count[1,1]
global k = count[2,1]
mkmat F1-F4 in 1/$N, matrix(F)
mkmat B1 B2 in 1/$k, matrix(B)

foreach j in 2 3 {
	use ip\OBootstrapGGY`j', clear
	sort N
	global N1 = count[1,`j']
	global k1 = count[2,`j']
mkmat F1-F4 in 1/$N1, matrix(FF)
mkmat B1 B2 in 1/$k1, matrix(BB)
	matrix F = F \ FF
	matrix B = B \ BB
	drop F1-F4 B1-B2 
	forvalues i = $k1(-1)1 {
		local k = `i' + $k
		rename ResB`i' ResB`k'
		rename ResSE`i' ResSE`k'
		}
	forvalues i = $N1(-1)1 {
		local k = `i' + $N
		rename ResFF`i' ResFF`k'
		rename ResF`i' ResF`k'
		rename ResDF`i' ResDF`k'
		rename ResD`i' ResD`k'
		}
	global k = $k + $k1
	global N = $N + $N1
	save a`j', replace
	}

use ip\OBootstrapGGY1, clear
drop F1-F4 B1-B2 
foreach j in 2 3 {
	sort N
	merge N using a`j'
	tab _m
	drop _m
	sort N
	}
aorder
svmat double F
svmat double B
save results\OBootstrapGGY, replace

foreach file in aaa aa bb cc {
	capture erase `file'.dta
	}







