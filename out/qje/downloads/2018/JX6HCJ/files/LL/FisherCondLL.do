
*randomizing at their clustering level


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster')
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

use DatLL, clear

matrix F = J(23,4,.)
matrix B = J(48,2,.)

global i = 1
global j = 1

*Table 1
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 z_overconfidence {
	mycmd (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period, cluster(uniqueid)
	}

*Table 2
foreach X in "male z_extraversion z_agreeableness z_conscientiousness z_emotionalstability z_openness" "salary5 job_media job_doctor job_engineer job_management job_marketing job_teacher job_researcher job_whitecollar" {
	mycmd (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period  if falseanswers == 0, cluster(uniqueid)
	}

*Table 3 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd (payescalate paydif) xtreg `X' payescalate paydif difference_belief risk_cert_equiv practice_score_max period if choice == 1, cluster(uniqueid)
	}

*Table 4 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd (payescalate payover) xtreg `X' payescalate payover overconf_hat risk_cert_equiv practice_score_max period if choice == 1, cluster(uniqueid)
	}

*Table 5 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 {
	mycmd (payescalate pay`X') xtreg mistake_convex payescalate pay`X' `X' risk_cert_equiv practice_score_max period if choice == 1, cluster(uniqueid)
	}

mycmd (payescalate payz_overconf) xtreg mistake_convex payescalate payz_overconf z_overconf risk_cert_equiv practice_score_max period if choice == 1 & falseanswers == 0, cluster(uniqueid)

*Table 6 
mycmd (choice_linear choice_convex escalate_linear escalate_convex) xtreg number_score choice_linear choice_convex escalate_linear escalate_convex payscheme practice_score_max period , cluster(uniqueid)
	

global i = 0

*Table 1
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 z_overconfidence {
	foreach var in choice escalate {
		global i = $i + 1
		local a = "choice escalate"
		local a = subinstr("`a'","`var'","",1)
		capture drop Strata
		egen Strata = group(`a')
		randcmdc ((`var') xtreg difference_belief choice escalate `X' practice_score_max period, cluster(uniqueid)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(uniqueid)
		}
	}

*Table 2
foreach X in "male z_extraversion z_agreeableness z_conscientiousness z_emotionalstability z_openness" "salary5 job_media job_doctor job_engineer job_management job_marketing job_teacher job_researcher job_whitecollar" {
	foreach var in choice escalate {
		global i = $i + 1
		local a = "choice escalate"
		local a = subinstr("`a'","`var'","",1)
		capture drop Strata
		egen Strata = group(`a')
		randcmdc ((`var') xtreg difference_belief choice escalate `X' practice_score_max period  if falseanswers == 0, cluster(uniqueid)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(uniqueid)
		}
	}

forvalues j = 1/34 {
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
save results\FisherCondLL, replace





