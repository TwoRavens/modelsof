global cluster = "uniqueid"

use DatLL, clear

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
	

