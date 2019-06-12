
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
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
	
bysort uniqueid: gen N = _n
sort N uniqueid
sum N if N == 1
global N = r(N)
mata Y = st_data((1,$N),("choice","escalate"))
generate Order = _n
generate double U = .

mata ResF = J($reps,23,.); ResD = J($reps,23,.); ResDF = J($reps,23,.); ResB = J($reps,48,.); ResSE = J($reps,48,.)
forvalues c = 1/$reps {
	matrix FF = J(23,3,.)
	matrix BB = J(48,2,.)
	display "`c'"
	set seed `c'

	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("choice","escalate"),Y)
	sort uniqueid N
	foreach j in choice escalate {
		quietly replace `j' = `j'[_n-1] if uniqueid == uniqueid[_n-1] 
		}
	quietly replace payescalate = (escalate == 1 & period >= 7)
	quietly replace paydif = payescalate*difference_belief
	quietly replace payover = payescalate*overconf_hat
	foreach j in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 z_overconf {
		quietly replace pay`j' = payescalate*`j'
		}
	quietly replace choice_linear = (payscheme == 0)&(choice == 1)&(escalate == 0)
	quietly replace choice_convex = (payscheme == 1)&(choice == 1)&(escalate == 0)
	quietly replace escalate_linear = (payscheme == 0)&(choice == 1)&(escalate == 1)
	quietly replace escalate_convex = (payscheme == 1)&(choice == 1)&(escalate == 1)

global i = 1
global j = 1

*Table 1
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 z_overconfidence {
	mycmd1 (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period , cluster(uniqueid)
	}

*Table 2
foreach X in "male z_extraversion z_agreeableness z_conscientiousness z_emotionalstability z_openness" "salary5 job_media job_doctor job_engineer job_management job_marketing job_teacher job_researcher job_whitecollar" {
	mycmd1 (choice escalate) xtreg difference_belief choice escalate `X' practice_score_max period  if falseanswers == 0, cluster(uniqueid)
	}

*Table 3 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd1 (payescalate paydif) xtreg `X' payescalate paydif difference_belief risk_cert_equiv practice_score_max period if choice == 1, cluster(uniqueid)
	}

*Table 4 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	mycmd1 (payescalate payover) xtreg `X' payescalate payover overconf_hat risk_cert_equiv practice_score_max period if choice == 1, cluster(uniqueid)
	}

*Table 5 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 {
	mycmd1 (payescalate pay`X') xtreg mistake_convex payescalate pay`X' `X' risk_cert_equiv practice_score_max period if choice == 1, cluster(uniqueid)
	}

mycmd1 (payescalate payz_overconf) xtreg mistake_convex payescalate payz_overconf z_overconf risk_cert_equiv practice_score_max period if choice == 1 & falseanswers == 0, cluster(uniqueid)

*Table 6 
mycmd1 (choice_linear choice_convex escalate_linear escalate_convex) xtreg number_score choice_linear choice_convex escalate_linear escalate_convex payscheme practice_score_max period , cluster(uniqueid)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..23] = FF[.,1]'; ResD[`c',1..23] = FF[.,2]'; ResDF[`c',1..23] = FF[.,3]'
mata ResB[`c',1..48] = BB[.,1]'; ResSE[`c',1..48] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/23 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/48 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\FisherLL, replace


*******************************

