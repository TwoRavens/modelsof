*clustering at treatment level

****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
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

global a = 23
global b = 48

use DatLL, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table 1
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 z_overconfidence {
	mycmd (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period if feedback == 0 & period > 3, cluster(session)
	}

*Table 2
foreach X in "male z_extraversion z_agreeableness z_conscientiousness z_emotionalstability z_openness" "salary5 job_media job_doctor job_engineer job_management job_marketing job_teacher job_researcher job_whitecollar" {
	mycmd (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period if feedback == 0 & period > 3 & falseanswers == 0, cluster(session)
	}

*Table 3 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd (payescalate paydif) xtreg `X' payescalate paydif difference_belief risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(session)
	}

*Table 4 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd (payescalate payover) xtreg `X' payescalate payover overconf_hat risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(session)
	}

*Table 5 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 {
	mycmd (payescalate pay`X') xtreg mistake_convex payescalate pay`X' `X' risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(session)
	}

mycmd (payescalate payz_overconf) xtreg mistake_convex payescalate payz_overconf z_overconf risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1 & falseanswers == 0, cluster(session)

*Table 6 - Randomization in this case will take as given that linear versus convex matter, but testing whether treatment regimes mattered - see discussion in paper
mycmd (choice_linear choice_convex escalate_linear escalate_convex) xtreg number_score choice_linear choice_convex escalate_linear escalate_convex payscheme practice_score_max period if feedback == 0 & period > 3, cluster(session)
	
	
gen Order = _n
sort session Order
gen N = 1
gen Dif = (session ~= session[_n-1])
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
	drop session
	rename obs session
	egen newuniqueid = group(session uniqueid)
	replace uniqueid = newuniqueid
	drop newuniqueid

xtset uniqueid

global i = 1
global j = 1

*Table 1
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 z_overconfidence {
	mycmd1 (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period if feedback == 0 & period > 3, cluster(session)
	}

*Table 2
foreach X in "male z_extraversion z_agreeableness z_conscientiousness z_emotionalstability z_openness" "salary5 job_media job_doctor job_engineer job_management job_marketing job_teacher job_researcher job_whitecollar" {
	mycmd1 (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period if feedback == 0 & period > 3 & falseanswers == 0, cluster(session)
	}

*Table 3 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd1 (payescalate paydif) xtreg `X' payescalate paydif difference_belief risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(session)
	}

*Table 4 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd1 (payescalate payover) xtreg `X' payescalate payover overconf_hat risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(session)
	}

*Table 5 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 {
	mycmd1 (payescalate pay`X') xtreg mistake_convex payescalate pay`X' `X' risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(session)
	}

mycmd1 (payescalate payz_overconf) xtreg mistake_convex payescalate payz_overconf z_overconf risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1 & falseanswers == 0, cluster(session)

*Table 6 - Randomization in this case will take as given that linear versus convex matter, but testing whether treatment regimes mattered - see discussion in paper
mycmd1 (choice_linear choice_convex escalate_linear escalate_convex) xtreg number_score choice_linear choice_convex escalate_linear escalate_convex payscheme practice_score_max period if feedback == 0 & period > 3, cluster(session)
	
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
save results\OBootstrapALL, replace

erase aa.dta
erase aaa.dta


