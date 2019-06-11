
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust'
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		quietly `anything' if M ~= `i', cluster(`cluster') `robust'
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			capture matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			}
		matrix F = J(1,3,.)
		capture testparm `testvars'
		if (_rc == 0) matrix F = r(p), r(drop), e(df_r)
		mata BB = st_matrix("BB"); F = st_matrix("F"); ResB[`i',1..$k] = BB[1..$k,1]'; ResSE[`i',1..$k] = BB[1..$k,2]'; ResF[`i',1..3] = F
		}
	quietly drop _all
	quietly set obs $N
	global kk = $j + $k - 1
	forvalues i = $j/$kk {
		quietly generate double ResB`i' = .
		}
	forvalues i = $j/$kk {
		quietly generate double ResSE`i' = .
		}
	quietly generate double ResF$i = .
	quietly generate double ResD$i = .
	quietly generate double ResDF$i = .
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	quietly svmat double B
	quietly rename B2 SE$i
	capture rename B1 B$i
	save ip\JK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
end



*******************

global cluster = "bfirm_club_id"

global i = 1
global j = 1

use DatGGY1, clear

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

******************************************

*Since they use all 311 bfirms in calculation of s.e., predicted treatment terms and cutoffs, jackknife using 311 bfirms (although only 249 have treatment 0/1)

global a = 29
global b = 58

use DatGGY2, clear

global covars "male agedum2 agedum3 agedum4 agedum5 agedum6 agedum7 agedum8 agedum9 agedum10 agedum11 agedum12 agedum13 agedum14 agedum15 agedum16 married educdum2 educdum3 educdum4 educdum5 educdum6 educdum7 educdum8 educdum9 educdum10"
global riskfactors "risky hungry late incomesd paprikaexp default nopreviousloan"

matrix B = J($b,2,.)

local j = 1
*Table 3
foreach outcome in approved any_loan {
	reg `outcome' fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	matrix B[`j',1] = _b[fingerprint] \ _b[pred_treat] 
	local j = `j' + 2
	}
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	matrix B[`j',1] = _b[fingerprint] \ _b[pred_treat] 
	local j = `j' + 2
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	matrix B[`j',1] = _b[fingerprint] \ _b[pred_treat] 
	local j = `j' + 2
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
collapse (sd) BS*, fast
mkmat BS1-BS58, matrix(t)
matrix B[1,2] = t'
restore

drop if bfirm_club_id == .
egen MM = group(bfirm_club_id) 
quietly sum MM
global N = r(max)
save bb, replace

mata ResB = J($N,$b,.); ResSE = J($N,$b,.); ResF = J($N,$a,.)
forvalues cc = 1/$N {
	matrix FF = J($a,1,.)
	matrix BB = J($b,2,.)

	use bb, clear
	quietly drop if MM == `cc'

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

local j = 1
*Table 3
foreach outcome in approved any_loan {
	quietly reg `outcome' fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	matrix BB[`j',1] = _b[fingerprint] \ _b[pred_treat] 
	local j = `j' + 2
	}
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	quietly reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	matrix BB[`j',1] = _b[fingerprint] \ _b[pred_treat] 
	local j = `j' + 2
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	quietly reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	matrix BB[`j',1] = _b[fingerprint] \ _b[pred_treat] 
	local j = `j' + 2
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
forvalues i = 1/$a {
	local k1 = 2*(`i'-1)+1 
	local k2 = 2*`i'
	quietly corr BS`k1'-BS`k2', cov
	matrix t = r(C)
	matrix tt = BB[`k1'..`k2',1]'*invsym(t)*BB[`k1'..`k2',1]
	matrix FF[`i',1] = chi2tail(2,tt[1,1])
	}
collapse (sd) BS*, fast
mkmat BS1-BS58, matrix(t)
matrix BB[1,2] = t'
restore

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`cc',1..$a] = FF[.,1]'; ResB[`cc',1..$b] = BB[.,1]'; ResSE[`cc',1..$b] = BB[.,2]'

}

	quietly drop _all
	quietly set obs $N
	forvalues i = 30/87 {
		quietly generate double ResB`i' = .
		}
	forvalues i = 30/87 {
		quietly generate double ResSE`i' = .
		}
	forvalues i = 30/58 {
		quietly generate double ResF`i' = .
		}
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	forvalues i = 30/58 {
		quietly generate double ResD`i' = 0
		}
	forvalues i = 30/58 {
		quietly generate double ResDF`i' = .
		}
	quietly svmat double B
	quietly rename B2 SE30
	capture rename B1 B30
	save ip\JK30, replace

*****************************************************

global a = 29
global b = 145

use DatGGY3, clear

matrix B = J($b,2,.)

global covars "male agedum2 agedum3 agedum4 agedum5 agedum6 agedum7 agedum8 agedum9 agedum10 agedum11 agedum12 agedum13 agedum14 agedum15 agedum16 married educdum2 educdum3 educdum4 educdum5 educdum6 educdum7 educdum8 educdum9 educdum10"
global riskfactors "risky hungry late incomesd paprikaexp default nopreviousloan"

local j = 1
*Table 3
foreach outcome in approved any_loan {
	reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 D2-D32 if samp1 == 1, cluster(bfirm_club_id)
		matrix B[`j',1] = (_b[fp_pred_repayd1] \ _b[fp_pred_repayd2] \ _b[fp_pred_repayd3] \ _b[fp_pred_repayd4] \ _b[fp_pred_repayd5]) 
	local j = `j' + 5
	}
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
		matrix B[`j',1] = (_b[fp_pred_repayd1] \ _b[fp_pred_repayd2] \ _b[fp_pred_repayd3] \ _b[fp_pred_repayd4] \ _b[fp_pred_repayd5]) 
	local j = `j' + 5
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
		matrix B[`j',1] = (_b[fp_pred_repayd1] \ _b[fp_pred_repayd2] \ _b[fp_pred_repayd3] \ _b[fp_pred_repayd4] \ _b[fp_pred_repayd5]) 
	local j = `j' + 5
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
collapse (sd) BS*, fast
mkmat BS1-BS145, matrix(t)
matrix B[1,2] = t'
restore

drop if bfirm_club_id == .
egen MM = group(bfirm_club_id) 
quietly sum MM
global N = r(max)
save cc, replace

mata ResB = J($N,$b,.); ResSE = J($N,$b,.); ResF = J($N,$a,.)
forvalues cc = 1/$N {
	matrix FF = J($a,1,.)
	matrix BB = J($b,2,.)

	use cc, clear
	quietly drop if MM == `cc'

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

local j = 1
*Table 3
foreach outcome in approved any_loan {
	quietly reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 D2-D32 if samp1 == 1, cluster(bfirm_club_id)
		matrix BB[`j',1] = (_b[fp_pred_repayd1] \ _b[fp_pred_repayd2] \ _b[fp_pred_repayd3] \ _b[fp_pred_repayd4] \ _b[fp_pred_repayd5]) 
	local j = `j' + 5
	}
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	quietly reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
		matrix BB[`j',1] = (_b[fp_pred_repayd1] \ _b[fp_pred_repayd2] \ _b[fp_pred_repayd3] \ _b[fp_pred_repayd4] \ _b[fp_pred_repayd5]) 
	local j = `j' + 5
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	quietly reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
		matrix BB[`j',1] = (_b[fp_pred_repayd1] \ _b[fp_pred_repayd2] \ _b[fp_pred_repayd3] \ _b[fp_pred_repayd4] \ _b[fp_pred_repayd5]) 
	local j = `j' + 5
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
forvalues i = 1/$a {
	local k1 = 5*(`i'-1)+1 
	local k2 = 5*`i'
	quietly corr BS`k1'-BS`k2', cov
	matrix t = r(C)
	matrix tt = BB[`k1'..`k2',1]'*invsym(t)*BB[`k1'..`k2',1]
	matrix FF[`i',1] = chi2tail(5,tt[1,1])
	}
collapse (sd) BS*, fast
mkmat BS1-BS145, matrix(t)
matrix BB[1,2] = t'
restore

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`cc',1..$a] = FF[.,1]'; ResB[`cc',1..$b] = BB[.,1]'; ResSE[`cc',1..$b] = BB[.,2]'

}

	quietly drop _all
	quietly set obs $N
	forvalues i = 88/232 {
		quietly generate double ResB`i' = .
		}
	forvalues i = 88/232 {
		quietly generate double ResSE`i' = .
		}
	forvalues i = 59/87 {
		quietly generate double ResF`i' = .
		}
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	forvalues i = 59/87 {
		quietly generate double ResD`i' = 0
		}
	forvalues i = 59/87 {
		quietly generate double ResDF`i' = .
		}
	quietly svmat double B
	quietly rename B2 SE31
	capture rename B1 B31
	save ip\JK31, replace


*******************************************
use ip\JK1, clear
forvalues i = 2/31 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/31 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeGGY, replace

foreach file in aaa aa bb cc {
	capture erase `file'.dta
	}


