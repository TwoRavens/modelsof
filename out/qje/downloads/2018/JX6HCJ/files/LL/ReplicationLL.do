
*Since linear vs. convex is randomized in some treatments, but a choice variable in others - cannot randomize
*Can only randomize the overarching treatment allowed choice or not, etc.

*Their code with extraneous bits (parts not related to tables) removed 

use fitted_perf_logarithmic, clear
append using augmentation
*I augmented the file with predicted values for feedback == 1 following equation used in spreadsheet
save fitted_perf_logarithmicaugmented, replace

insheet using MasterData.csv, clear
replace treatment = "Choice" if treatment == "No Escalate"
xtset uniqueid period

gen is_overconf = difference_belief > 0
gen is_underconf = difference_belief < 0
merge 1:1 uniqueid period using fitted_perf_logarithmicaugmented.dta, nogenerate

bysort uniqueid: egen temp = mean(difference_belief) if period <= 3
bysort uniqueid: egen init_overconf = max(temp)
drop temp
gen is_init_overconf = init_overconf > 0
gen is_rel_overconf = (guess_num_better > actual_num_better)
gen trivia_abs_diffb = trivia_abs_guess - trivia_num_correct


*NOTE: in earlier versions of Stata (e.g. Stata 10), if simply state re robust, don't get the covariance estimates they report
*have to specify cluster(uniqueid).  In later versions of Stata (e.g. Stata 13), makes no difference.  I adjust code so that it yields
*the same results regardless of version of stata (specifically, I use code that matches their published results in all Stata versions)


*Table 1 - all okay

xi: xtreg difference_belief init_overconf choice escalate practice_score_max period if feedback == 0 & period > 3, re robust
xi: xtreg difference_belief is_rel_overconf choice escalate practice_score_max period if feedback == 0 & period > 3, re robust
xi: xtreg difference_belief trivia_abs_diffb choice escalate practice_score_max  period if feedback == 0 & period > 3, re robust
xi: xtreg difference_belief tc_over_5 choice escalate practice_score_max  period if feedback == 0 & period > 3, re robust
xi: xtreg difference_belief z_overconfidence choice escalate practice_score_max  period if feedback == 0 & period > 3, re robust

xtreg difference_belief init_overconf choice escalate practice_score_max period if feedback == 0 & period > 3, cluster(uniqueid)
xtreg difference_belief is_rel_overconf choice escalate practice_score_max period if feedback == 0 & period > 3, cluster(uniqueid)
xtreg difference_belief trivia_abs_diffb choice escalate practice_score_max  period if feedback == 0 & period > 3, cluster(uniqueid)
xtreg difference_belief tc_over_5 choice escalate practice_score_max  period if feedback == 0 & period > 3, cluster(uniqueid)
xtreg difference_belief z_overconfidence choice escalate practice_score_max  period if feedback == 0 & period > 3, cluster(uniqueid)



*Table 2 - all okay 

gen male = sex == "Male"
replace male = . if sex == "."
replace salary5 = salary5/1000
gen job_media = job_after == "Artist/entertainment/writer"
gen job_doctor = job_after == "Doctor or other health care professional"
gen job_engineer = job_after == "Engineer or computing/technical professional"
gen job_management = job_after == "Management"
gen job_marketing = job_after == "Marketing"
gen job_teacher = job_after == "Professor or teacher"
gen job_researcher = job_after == "Researcher"
gen job_whitecollar = job_after == "White-collar (banking, consultant, lawyer)"

xi: xtreg difference_belief male z_extraversion z_agreeableness z_conscientiousness z_emotionalstability z_openness choice escalate practice_score_max period if feedback == 0 & period > 3 & falseanswers == 0, re robust
xi: xtreg difference_belief salary5 job_media job_doctor job_engineer job_management job_marketing job_teacher job_researcher job_whitecollar choice escalate practice_score_max period if feedback == 0 & period > 3 & falseanswers == 0, re robust

xtreg difference_belief male z_extraversion z_agreeableness z_conscientiousness z_emotionalstability z_openness choice escalate practice_score_max period if feedback == 0 & period > 3 & falseanswers == 0, cluster(uniqueid)
xtreg difference_belief salary5 job_media job_doctor job_engineer job_management job_marketing job_teacher job_researcher job_whitecollar choice escalate practice_score_max period if feedback == 0 & period > 3 & falseanswers == 0, cluster(uniqueid)


replace payscheme = payscheme - 1
gen mistake_linear = (payscheme == 0)& (payoff_answers_b > payoff_answers_a)
gen mistake_convex = (payscheme == 1)& (payoff_answers_b < payoff_answers_a)

gen overconf_hat = (guess_num_correct - perf_hat)
gen overconf_hat_pct = overconf_hat/perf_hat
gen overconf_hat10 = overconf_hat_pct >= 0.10
gen underconf_hat10 = overconf_hat_pct <= -0.10

*Table 3 - all okay

gen mistake_linear_cost_pct = 0
replace mistake_linear_cost_pct = (payoff_answers_b - payoff_answers_a)/payoff_answers_a if mistake_linear == 1
gen mistake_convex_cost_pct = 0
replace mistake_convex_cost_pct = (payoff_answers_a - payoff_answers_b)/payoff_answers_b if mistake_convex == 1

xi: xtreg payscheme difference_belief payescalate i.payescalate|difference_belief risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_convex difference_belief payescalate i.payescalate|difference_belief risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_convex_cost_pct difference_belief payescalate i.payescalate|difference_belief risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_linear difference_belief payescalate i.payescalate|difference_belief risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_linear_cost_pct difference_belief payescalate i.payescalate|difference_belief risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust

generate paydif = payescalate*difference_belief


xtreg payscheme difference_belief payescalate paydif risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_convex difference_belief payescalate paydif risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_convex_cost_pct difference_belief payescalate paydif risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_linear difference_belief payescalate paydif risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_linear_cost_pct difference_belief payescalate paydif risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)


*Table 4 - all okay

xi: xtreg payscheme overconf_hat payescalate i.payescalate|overconf_hat risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_convex overconf_hat payescalate i.payescalate|overconf_hat risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_convex_cost_pct overconf_hat payescalate i.payescalate|overconf_hat risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_linear overconf_hat payescalate i.payescalate|overconf_hat risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_linear_cost_pct overconf_hat payescalate i.payescalate|overconf_hat risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust

generate payover = payescalate*overconf_hat

xtreg payscheme overconf_hat payescalate payover risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_convex overconf_hat payescalate payover risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_convex_cost_pct overconf_hat payescalate payover risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_linear overconf_hat payescalate payover risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_linear_cost_pct overconf_hat payescalate payover risk_cert_equiv practice_score_max  period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)



*Table 5 - all okay

xi: xtreg mistake_convex init_overconf payescalate i.payescalate|init_overconf risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_convex is_rel_overconf payescalate i.payescalate|is_rel_overconf risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_convex trivia_abs_diffb payescalate i.payescalate|trivia_abs_diffb risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_convex tc_over_5 payescalate i.payescalate|tc_over_5 risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, re robust
xi: xtreg mistake_convex z_overconf payescalate i.payescalate|z_overconf risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1 & falseanswers == 0, re robust

generate payinit_overconf = payescalate*init_overconf
generate payis_rel_overconf = payescalate*is_rel_overconf
generate paytrivia_abs_diffb = payescalate*trivia_abs_diffb
generate paytc_over_5 = payescalate*tc_over_5
generate payz_overconf = payescalate*z_overconf


xtreg mistake_convex init_overconf payescalate payinit risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_convex is_rel_overconf payescalate payis risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_convex trivia_abs_diffb payescalate paytrivia risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_convex tc_over_5 payescalate paytc risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1, cluster(uniqueid)
xtreg mistake_convex z_overconf payescalate payz risk_cert_equiv practice_score_max period if period > 3 & riskswitch >= 0 & feedback == 0 & choice == 1 & falseanswers == 0, cluster(uniqueid)




gen perf_incr = (number_score - practice_score_max)/practice_score_max
bysort uniqueid: egen convex_count = sum(payscheme) if period > 3
tab convex_count if period == 4 & feedback == 0 & choice == 1
gen linear_only = convex_count == 0

*Table 6 - all okay

gen nochoice_convex = (payscheme == 1)&(choice == 0)
gen choice_linear = (payscheme == 0)&(choice == 1)&(escalate == 0)
gen choice_convex = (payscheme == 1)&(choice == 1)&(escalate == 0)
gen escalate_linear = (payscheme == 0)&(choice == 1)&(escalate == 1)
gen escalate_convex = (payscheme == 1)&(choice == 1)&(escalate == 1)

xtreg number_score nochoice_convex choice_linear choice_convex escalate_linear escalate_convex practice_score_max period if feedback == 0 & period > 3, re robust

xtreg number_score nochoice_convex choice_linear choice_convex escalate_linear escalate_convex practice_score_max period if feedback == 0 & period > 3, cluster(uniqueid)


gen max_payoff = max(payoff_answers_a, payoff_answers_b)
gen min_payoff = min(payoff_answers_a, payoff_answers_b)
gen mistake = mistake_convex + mistake_linear
by uniqueid: egen total_real_payoff = sum(payoff_answers) if period > 3
by uniqueid: egen total_max_payoff = sum(max_payoff) if period > 3
by uniqueid: egen total_min_payoff = sum(min_payoff) if period > 3
gen payoff_pct_incr = (total_real_payoff - total_min_payoff)/(total_max_payoff - total_min_payoff)
gen pay_rate = payoff_answers/number_score


*Other tables means or only involve one treatment


*************************


*Recoding


*Table 1
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 z_overconfidence {
	xtreg difference_belief `X' choice escalate practice_score_max period if feedback == 0 & period > 3, cluster(uniqueid)
	}

*Table 2
foreach X in "male z_extraversion z_agreeableness z_conscientiousness z_emotionalstability z_openness" "salary5 job_media job_doctor job_engineer job_management job_marketing job_teacher job_researcher job_whitecollar" {
	xtreg difference_belief choice escalate `X' practice_score_max period if feedback == 0 & period > 3 & falseanswers == 0, cluster(uniqueid)
	}

*Table 3 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	xtreg `X' difference_belief payescalate paydif risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(uniqueid)
	}

*Table 4 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in payscheme mistake_convex mistake_convex_cost_pct mistake_linear mistake_linear_cost_pct {
	xtreg `X' overconf_hat payescalate payover risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(uniqueid)
	}

*Table 5 (riskswitch >= 0 is no constraint, applies to entire sample - dropped)
foreach X in init_overconf is_rel_overconf trivia_abs_diffb tc_over_5 {
	xtreg mistake_convex `X' payescalate pay`X' risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1, cluster(uniqueid)
	}

xtreg mistake_convex z_overconf payescalate payz_overconf risk_cert_equiv practice_score_max period if period > 3 & feedback == 0 & choice == 1 & falseanswers == 0, cluster(uniqueid)

*Table 6 - Randomization in this case will take as given that linear versus convex matter, but testing whether treatment regimes mattered
xtreg number_score nochoice_convex choice_linear choice_convex escalate_linear escalate_convex practice_score_max period if feedback == 0 & period > 3, cluster(uniqueid)
*Restate as test of whether response to linear or convex varies by treatment
xtreg number_score payscheme choice_linear choice_convex escalate_linear escalate_convex practice_score_max period if feedback == 0 & period > 3, cluster(uniqueid)
*Note that my restatement does not change significance of the treatment variables they find to be significant

log using a.log, replace
bysort treatment: sum
log close
*All necessary variables for all treatments

drop if feedback == 1
drop if period <= 3
*These sessions & treatment not used in any of the regressions I examine

save DatLL, replace

