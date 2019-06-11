********************************************************************************
*	Protests as Strategic Games
*	Cantoni et al., Quarterly Journal of Economics
*	January 2019

*	Do-file to produce the tables of the main part of the paper
********************************************************************************

*	Variable locals
	local var_demogra_hhecon 				`"monthly_income_total_w3 realest_totalowned_w3 father_educ_hsabove_w123 mother_educ_hsabove_w123"'
	local var_demogra_basic 				`"gender birth_year"'
	local var_demogra_childenv 				`"hs_language_english hkgeneration_w123"'
	local var_azscores_y 					`"az_democratic_support az_independence az_ntlidentity az_statusquo az_polrecent az_polapproach participate_umbrella_w3 vote_legco_2016_party_democ_w3 plan_july1_2016_w3pos az_game_identity demosis_donation_above0_w3"'
	local var_azscores_x_fundamental 		`"az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon az_demogra_childenv"'
	local var_azscores_x_simultaneous 		`"az_belief_institution az_belief_protesteff az_srec_democratic_hkust az_sres_independence_hkust az_sres_ntlidentity_hkust az_sres_statusquo_hkust az_sres_approach_hkust az_social_polnetwork az_social_sociability az_srec_democratic_fri az_sres_independence_fri az_sres_ntlidentity_fri az_sres_statusquo_fri az_sres_approach_fri az_media_frequency az_media_source az_pol_interest az_pol_knowledge"'
	local var_list_counts 					`"list_count_fccp list_count_hkid list_count_indp list_count_viol"'

********************************************************************************	
	
*	Table 1			Summary statistics and balance checks
	
	preserve
	
	* Restricting sample
	keep if belief_treatment_w3 != . & followup_postjuly1st == 1
	keep if hk_local == 1
	
	* Drop if posterior beliefs are missing
	drop if guess_july1_2016_partust_w3pos == .
	
	* Recode variable (to appear in percent in summary statistics tables)
	recode plan_july1_2016_w3pos (1 = 100)
		
	tempname p
	postfile `p' str50 variable float mu_1 mu_2 pval_0 mu_3 mu_4 pval_1 mu_5 mu_6 pval_2 ///
		using Table_1, replace

	* Control and treatment means
	foreach X of varlist gender birth_year az_demogra_childenv religion_none az_demogra_hhecon az_demogra_ownecon plan_july1_2016_w3pos guess_july1_2016_planust_w3 guess_july1_2016_partust_w3pre guess_july1_2016_part_w3pre {
		qui sum `X' if belief_treatment_w3 == 0
		local mu_1 = r(mean)
		
		qui sum `X' if belief_treatment_w3 == 1
		local mu_2=r(mean)
		
		qui sum `X' if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 0
		local mu_3=r(mean)

		qui sum `X' if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 1
		local mu_4=r(mean)

		qui sum `X' if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 0
		local mu_5=r(mean)
		
		qui sum `X' if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1
		local mu_6=r(mean)

		qui ttest `X', by(belief_treatment_w3)
		local pval_0=r(p)
		
		qui ttest `X' if guess_july1_2016_planust_w3 < 17, by(belief_treatment_w3)
		local pval_1=r(p)
		
		qui ttest `X' if guess_july1_2016_planust_w3 >= 17, by(belief_treatment_w3)
		local pval_2=r(p)

		post `p' ("`X'") (`mu_1') (`mu_2') (`pval_0') (`mu_3') (`mu_4') (`pval_1') (`mu_5') (`mu_6') (`pval_2')
	}
	
	* Number of observations
	foreach X of varlist belief_treatment_w3 {
		qui sum `X' if belief_treatment_w3 == 0
		local N_1=r(N)

		qui sum `X' if belief_treatment_w3 == 1
		local N_2=r(N)
		
		qui sum `X' if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 0
		local N_3=r(N)

		qui sum `X' if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 1
		local N_4=r(N)

		qui sum `X' if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 0
		local N_5=r(N)
		
		qui sum `X' if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1
		local N_6=r(N)

		post `p' ("# of observations") (`N_1') (`N_2') (.) (`N_3') (`N_4') (.) (`N_5') (`N_6') (.)		
	}
	
	postclose `p'
	restore
	
	preserve	
	clear
	use Table_1
	outsheet using Table_1.xls, replace
	clear
	erase Table_1.dta
	restore

	
		
	
*	Table 2			Item count experiments and willingness to respond to direct questions
	
	preserve
	
	* Column 1 - direct question
	tempname p
	postfile `p' str50 variable float mu_direct ///
		using Table_2_column1, replace
		
	foreach c in fccp hkid indp viol {
			sum list_dummy_`c'_w3 if hk_local == 1
			if "`c'" == "fccp" {
			local list_direct_`c'_mean: di %4.3f (1-r(mean))			
			}
			if "`c'" != "fccp" {
			local list_direct_`c'_mean: di %4.3f r(mean)
			}			
			post `p' ("`c'") (`list_direct_`c'_mean')
	}
		
	postclose `p'
	restore
	
	preserve	
	clear
	use Table_2_column1
	outsheet using Table_2_column1.xls, replace
	clear
	erase Table_2_column1.dta
	restore

	
	* Column (2) - difference when cover is provided
	preserve
	cap erase Table_2_column2.xls
	cap erase Table_2_column2.txt	
	
	foreach Y in `var_list_counts' {

		qui reg `Y' list_exp_veiled if hk_local == 1, r
		qui summ `Y' if hk_local == 1
		local labelY: var label `Y'
		local t_inference = _b[list_exp_veiled]/_se[list_exp_veiled]
		local p_inference = 2*ttail(e(df_r),abs(`t_inference'))
		outreg2 local_hk using Table_2_column2.xls, addstat("Mean DV", `r(mean)', "Std.Dev.\ DV", `r(sd)', "p-value", `p_inference') label dec(3) adec(3) ctitle(`Y', "`labelY'", ) addtext(Sample, HK locals) br
	}
	restore	
	

	
	
*	Table 3		First-stage effects / treatment effect on posterior beliefs
	
	preserve

	* Restricting sample
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st_w3 == 1
	drop if guess_july1_2016_partust_w3pos == .

	* Generate directional treatment indicator
	gen belief_treatment_im = belief_treatment_w3
	replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1

	* Generate sample splitting indicator and interaction with controls
	gen guess_july1_2016_above17 = (guess_july1_2016_planust_w3 >= 17) 	if guess_july1_2016_planust_w3 != .
	gen guess_july1_2016_partustXabv17 = guess_july1_2016_partust_w3pre * guess_july1_2016_above17
	gen guess_july1_2016_partXabv17 = guess_july1_2016_part_w3pre * guess_july1_2016_above17

	* Generate trimmed prior beliefs
	winsor2 guess_july1_2016_planust_w3, cuts(5 95) trim
	rename guess_july1_2016_planust_w3_tr guess_july1_2016_planust_tr

	
	*** Table
	** Panel A
	eststo clear
	
	* HKUST students
	eststo: reg guess_july1_2016_partust_w3pos belief_treatment_im guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17, r
	eststo: reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 < 17, r
	eststo: reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 >= 17, r

	* HK Population
	eststo: reg guess_july1_2016_part_w3pos belief_treatment_im guess_july1_2016_part_w3pre guess_july1_2016_above17 guess_july1_2016_partXabv17, r
	eststo: reg guess_july1_2016_part_w3pos belief_treatment_w3 guess_july1_2016_part_w3pre if guess_july1_2016_planust_w3 < 17, r
	eststo: reg guess_july1_2016_part_w3pos belief_treatment_w3 guess_july1_2016_part_w3pre if guess_july1_2016_planust_w3 >= 17, r
	
	esttab using Table_3.txt, replace ///
		se keep(belief_treatment_im belief_treatment_w3) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel A", nolabel) ///
		mtitle("All subjects" "Prior below truth" "Prior above truth" "All subjects" "Prior below truth" "Prior above truth") ///
		mgroups("HKUST students" "HK population", pattern(0 0 0 1 1 1))
	
	
	** Panel B
	eststo clear

	* HKUST students
	eststo: reg guess_july1_2016_partust_w3pos belief_treatment_im guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17 `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv', r
	eststo: reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_partust_w3pre `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' if guess_july1_2016_planust_w3 < 17, r
	eststo: reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_partust_w3pre `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' if guess_july1_2016_planust_w3 >= 17, r

	* HK Population
	eststo: reg guess_july1_2016_part_w3pos belief_treatment_im guess_july1_2016_part_w3pre guess_july1_2016_above17 guess_july1_2016_partXabv17 `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv', r
	eststo: reg guess_july1_2016_part_w3pos belief_treatment_w3 guess_july1_2016_part_w3pre `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' if guess_july1_2016_planust_w3 < 17, r
	eststo: reg guess_july1_2016_part_w3pos belief_treatment_w3 guess_july1_2016_part_w3pre `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' if guess_july1_2016_planust_w3 >= 17, r
	
	esttab using Table_3.txt, append ///
		se keep(belief_treatment_im belief_treatment_w3) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel B", nolabel) ///
		nomtitles nonumbers

		
	** Panel C
	eststo clear
	
	* HKUST students
	eststo e_1: reg guess_july1_2016_partust_w3pos belief_treatment_im guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17 if guess_july1_2016_planust_tr != ., r
	eststo e_2: reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_partust_w3pre if (guess_july1_2016_planust_w3 < 17 & guess_july1_2016_planust_tr != .), r
	eststo e_3: reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_partust_w3pre if (guess_july1_2016_planust_w3 >= 17 & guess_july1_2016_planust_tr != .), r
		
	* HK Population
	eststo e_4: reg guess_july1_2016_part_w3pos belief_treatment_im guess_july1_2016_part_w3pre guess_july1_2016_above17 guess_july1_2016_partXabv17 if guess_july1_2016_planust_tr != ., r
	eststo e_5: reg guess_july1_2016_part_w3pos belief_treatment_w3 guess_july1_2016_part_w3pre if (guess_july1_2016_planust_w3 < 17 & guess_july1_2016_planust_tr != .), r
	eststo e_6: reg guess_july1_2016_part_w3pos belief_treatment_w3 guess_july1_2016_part_w3pre if (guess_july1_2016_planust_w3 >= 17 & guess_july1_2016_planust_tr != .), r

		
	** Sumstats
	* Column (1)
	sum guess_july1_2016_partust_w3pos if belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_w3pos
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	estadd scalar obs = N: e_1
	estadd scalar mu_a = mu_1: e_1
	estadd scalar sd_a = sd_1: e_1
	estadd scalar mu_b = mu_2: e_1
	estadd scalar sd_b = sd_2: e_1
	drop mu_1 sd_1 mu_2 sd_2 N
	
	* Column (2)
	sum guess_july1_2016_partust_w3pos if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_w3pos if guess_july1_2016_planust_w3 < 17
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	estadd scalar obs = N: e_2
	estadd scalar mu_a = mu_1: e_2
	estadd scalar sd_a = sd_1: e_2
	estadd scalar mu_b = mu_2: e_2
	estadd scalar sd_b = sd_2: e_2
	drop mu_1 sd_1 mu_2 sd_2 N
	
	* Column (3)
	sum guess_july1_2016_partust_w3pos if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_w3pos if guess_july1_2016_planust_w3 >= 17
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	estadd scalar obs = N: e_3
	estadd scalar mu_a = mu_1: e_3
	estadd scalar sd_a = sd_1: e_3
	estadd scalar mu_b = mu_2: e_3
	estadd scalar sd_b = sd_2: e_3
	drop mu_1 sd_1 mu_2 sd_2 N
	
	* Column (4)
	sum guess_july1_2016_part_w3pos if belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_part_w3pos
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	estadd scalar obs = N: e_4
	estadd scalar mu_a = mu_1: e_4
	estadd scalar sd_a = sd_1: e_4
	estadd scalar mu_b = mu_2: e_4
	estadd scalar sd_b = sd_2: e_4
	drop mu_1 sd_1 mu_2 sd_2 N
		
	* Column (5)
	sum guess_july1_2016_part_w3pos if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_part_w3pos if guess_july1_2016_planust_w3 < 17
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	estadd scalar obs = N: e_5
	estadd scalar mu_a = mu_1: e_5
	estadd scalar sd_a = sd_1: e_5
	estadd scalar mu_b = mu_2: e_5
	estadd scalar sd_b = sd_2: e_5
	drop mu_1 sd_1 mu_2 sd_2 N
		
	* Column (6)
	sum guess_july1_2016_part_w3pos if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 0	
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_part_w3pos if guess_july1_2016_planust_w3 >= 17
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	estadd scalar obs = N: e_6
	estadd scalar mu_a = mu_1: e_6
	estadd scalar sd_a = sd_1: e_6
	estadd scalar mu_b = mu_2: e_6
	estadd scalar sd_b = sd_2: e_6
	drop mu_1 sd_1 mu_2 sd_2 N

	esttab using Table_3.txt, append ///
		se keep(belief_treatment_im belief_treatment_w3) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel C", nolabel) ///
		nomtitles nonumbers ///
		scalars("obs Observations" "mu_a Mean (ctrl)" "sd_a SD (ctrl)" "mu_b Mean (all)" "sd_b SD (all)")

	restore

	
	
	
*	Table 4		Reduced form effects / treatment effect on protest participation

	preserve
	
	* Restricting sample
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st_w3 == 1
	drop if guess_july1_2016_partust_w3pos == .

	* Generate directional treatment indicator
	gen belief_treatment_im = belief_treatment_w3
	replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1

	* Generate trimmed prior beliefs
	winsor2 guess_july1_2016_planust_w3, cuts(5 95) trim
	rename guess_july1_2016_planust_w3_tr guess_july1_2016_planust_tr
	
	
	** Panel A
	eststo clear
	eststo: reg participate_july1_2016_w3pos belief_treatment_im, r
	eststo: reg participate_july1_2016_w3pos belief_treatment_w3 if guess_july1_2016_planust_w3 < 17, r
	eststo: reg participate_july1_2016_w3pos belief_treatment_w3 if guess_july1_2016_planust_w3 >= 17, r
		
	esttab using Table_4.txt, replace ///
		se keep(belief_treatment_im belief_treatment_w3) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel A", nolabel) ///
		mtitle("All subjects" "Prior below truth" "Prior above truth")
		
	** Panel B
	eststo clear
	eststo: reg participate_july1_2016_w3pos belief_treatment_im guess_july1_2016_planust_w3 `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv', r
	eststo: reg participate_july1_2016_w3pos belief_treatment_w3 guess_july1_2016_planust_w3 `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' if guess_july1_2016_planust_w3 < 17, r
	eststo: reg participate_july1_2016_w3pos belief_treatment_w3 guess_july1_2016_planust_w3 `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' if guess_july1_2016_planust_w3 >= 17, r
	
	esttab using Table_4.txt, append ///
		se keep(belief_treatment_im belief_treatment_w3) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel B", nolabel) ///
		nomtitles nonumbers
	
	
	** Panel C
	eststo clear
	eststo e_1: reg participate_july1_2016_w3pos belief_treatment_im if guess_july1_2016_planust_tr != ., r
	eststo e_2: reg participate_july1_2016_w3pos belief_treatment_w3 if (guess_july1_2016_planust_w3 < 17 & guess_july1_2016_planust_tr != .), r
	eststo e_3: reg participate_july1_2016_w3pos belief_treatment_w3 if (guess_july1_2016_planust_w3 >= 17 & guess_july1_2016_planust_tr != .), r
		

	** Sumstats
	* Column (1) - Sumstats
	sum participate_july1_2016_w3pos if belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum participate_july1_2016_w3pos
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	estadd scalar obs = N: e_1
	estadd scalar mu_a = mu_1: e_1
	estadd scalar sd_a = sd_1: e_1
	estadd scalar mu_b = mu_2: e_1
	estadd scalar sd_b = sd_2: e_1
	drop mu_1 sd_1 mu_2 sd_2 N
	
	* Column (2) - Sumstats
	sum participate_july1_2016_w3pos if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum participate_july1_2016_w3pos if guess_july1_2016_planust_w3 < 17
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	estadd scalar obs = N: e_2
	estadd scalar mu_a = mu_1: e_2
	estadd scalar sd_a = sd_1: e_2
	estadd scalar mu_b = mu_2: e_2
	estadd scalar sd_b = sd_2: e_2
	drop mu_1 sd_1 mu_2 sd_2 N
	
	* Column (3) - Sumstats
	sum participate_july1_2016_w3pos if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 0	
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum participate_july1_2016_w3pos if guess_july1_2016_planust_w3 >= 17
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	estadd scalar obs = N: e_3
	estadd scalar mu_a = mu_1: e_3
	estadd scalar sd_a = sd_1: e_3
	estadd scalar mu_b = mu_2: e_3
	estadd scalar sd_b = sd_2: e_3
	drop mu_1 sd_1 mu_2 sd_2 N
	
	esttab using Table_4.txt, append ///
		se keep(belief_treatment_im belief_treatment_w3) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel C", nolabel) ///
		nomtitles nonumbers ///
		scalars("obs Observations" "mu_a Mean (ctrl)" "sd_a SD (ctrl)" "mu_b Mean (all)" "sd_b SD (all)")

	restore
	

	
		
*	Table 5		Interaction treatment x predictors of prior / Heterogeneous treatment effect by prior beliefs

	preserve
	
	* Restricting sample
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st_w3 == 1
	drop if guess_july1_2016_partust_w3pos == .
	
	* Predicted priors
	qui reg guess_july1_2016_planust_w3 `var_azscores_y' `var_azscores_x_fundamental' `var_azscores_x_simultaneous' gender birth_year religion_none
	predict guess_july1_2016_planust_pr
	predict guess_july1_2016_planust_re, res

	* Interactions
	gen treatmentXprior = belief_treatment_w3 * guess_july1_2016_planust_w3
	gen treatmentXprior_pr = belief_treatment_w3 * guess_july1_2016_planust_pr
	gen treatmentXprior_re = belief_treatment_w3 * guess_july1_2016_planust_re
	
	
	** Regressions
	* Panel A: First stage / treatment effect on posterior beliefs
	eststo clear
	eststo: reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_planust_w3 treatmentXprior, r
	eststo: reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_planust_pr treatmentXprior_pr, r
	eststo: reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_planust_pr treatmentXprior_pr guess_july1_2016_planust_re treatmentXprior_re, r

	esttab using Table_5.txt, replace ///
		se keep(belief_treatment_w3 treatmentXprior treatmentXprior_pr treatmentXprior_re) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel A", nolabel)
	
	* Panel B: Reduced form / treatment effect on protest participation
	eststo clear
	eststo e_1: reg participate_july1_2016_w3pos belief_treatment_w3 guess_july1_2016_planust_w3 treatmentXprior, r
	eststo e_2: reg participate_july1_2016_w3pos belief_treatment_w3 guess_july1_2016_planust_pr treatmentXprior_pr, r
	eststo e_3: reg participate_july1_2016_w3pos belief_treatment_w3 guess_july1_2016_planust_pr treatmentXprior_pr guess_july1_2016_planust_re treatmentXprior_re, r
	
	** Sumstats
	* Column (1)
	sum guess_july1_2016_partust_w3pos if belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_w3pos
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	sum participate_july1_2016_w3pos if belief_treatment_w3 == 0
	gen mu_3 = r(mean)
	gen sd_3 = r(sd)
	sum participate_july1_2016_w3pos
	gen mu_4 = r(mean)
	gen sd_4 = r(sd)	
	estadd scalar obs = N: e_1
	estadd scalar mu_a = mu_1: e_1
	estadd scalar sd_a = sd_1: e_1
	estadd scalar mu_b = mu_2: e_1
	estadd scalar sd_b = sd_2: e_1
	estadd scalar mu_c = mu_3: e_1
	estadd scalar sd_c = sd_3: e_1
	estadd scalar mu_d = mu_4: e_1
	estadd scalar sd_d = sd_4: e_1	
	drop mu_1 sd_1 mu_2 sd_2 mu_3 sd_3 mu_4 sd_4 N
	
	
	* Columns (2)/(3)
	sum guess_july1_2016_partust_w3pos if treatmentXprior_pr != . & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_w3pos if treatmentXprior_pr != .
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	sum participate_july1_2016_w3pos if treatmentXprior_pr != . & belief_treatment_w3 == 0
	gen mu_3 = r(mean)
	gen sd_3 = r(sd)
	sum participate_july1_2016_w3pos if treatmentXprior_pr != .
	gen mu_4 = r(mean)
	gen sd_4 = r(sd)	
	estadd scalar obs = N: e_2
	estadd scalar mu_a = mu_1: e_2
	estadd scalar sd_a = sd_1: e_2
	estadd scalar mu_b = mu_2: e_2
	estadd scalar sd_b = sd_2: e_2
	estadd scalar mu_c = mu_3: e_2
	estadd scalar sd_c = sd_3: e_2
	estadd scalar mu_d = mu_4: e_2
	estadd scalar sd_d = sd_4: e_2
	estadd scalar obs = N: e_3
	estadd scalar mu_a = mu_1: e_3
	estadd scalar sd_a = sd_1: e_3
	estadd scalar mu_b = mu_2: e_3
	estadd scalar sd_b = sd_2: e_3
	estadd scalar mu_c = mu_3: e_3
	estadd scalar sd_c = sd_3: e_3
	estadd scalar mu_d = mu_4: e_3
	estadd scalar sd_d = sd_4: e_3
	drop mu_1 sd_1 mu_2 sd_2 mu_3 sd_3 mu_4 sd_4 N
	
	esttab using Table_5.txt, append ///
		se keep(belief_treatment_w3 treatmentXprior treatmentXprior_pr treatmentXprior_re) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel B", nolabel) ///
		nomtitles nonumbers ///
		scalars("obs Observations" "mu_a 1ststage Mean (ctrl)" "sd_a 1ststage SD (ctrl)" "mu_b 1ststage Mean (all)" "sd_b 1ststage SD (all)" "mu_c Reduced Form Mean (ctrl)" "sd_c Reduced Form SD (ctrl)" "mu_d Reduced Form Mean (all)" "sd_d Reduced Form SD (all)")
	
	restore

	

	
*	Table 6		Second stage effects / Two stage estimates of protest participation	

	preserve
	
	* Restricting sample
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st_w3 == 1
	drop if guess_july1_2016_partust_w3pos == .

	* Generate directional treatment indicator
	gen belief_treatment_im = belief_treatment_w3
	replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1

	* Generate sample splitting indicator and interaction with controls
	gen guess_july1_2016_above17 = (guess_july1_2016_planust_w3 >= 17) 	if guess_july1_2016_planust_w3 != .
	gen guess_july1_2016_partustXabv17 = guess_july1_2016_partust_w3pre * guess_july1_2016_above17
	gen guess_july1_2016_partXabv17 = guess_july1_2016_part_w3pre * guess_july1_2016_above17
	
	* Generate trimmed prior beliefs
	winsor2 guess_july1_2016_planust_w3, cuts(5 95) trim
	rename guess_july1_2016_planust_w3_tr guess_july1_2016_planust_tr

	
	** Regressions
	* Panel A
	eststo clear
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_im guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17) guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17, first
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_w3 guess_july1_2016_partust_w3pre) guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 < 17, first
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_w3 guess_july1_2016_partust_w3pre) guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 >= 17, first
	
	esttab using Table_6.txt, replace ///
		se keep(guess_july1_2016_partust_w3pos) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel A", nolabel) ///
		mtitle("All subjects" "Prior below truth" "Prior above truth")
	
	* Panel B
	eststo clear
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_im guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17) guess_july1_2016_above17 guess_july1_2016_partustXabv17 `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_partust_w3pre, first
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_w3 guess_july1_2016_partust_w3pre) `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 < 17, first
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_w3 guess_july1_2016_partust_w3pre) `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 >= 17, first

	esttab using Table_6.txt, append ///
		se keep(guess_july1_2016_partust_w3pos) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel B", nolabel) ///
		nomtitles nonumbers
	
	* Panel C
	eststo clear
	eststo e_1: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_im guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17) guess_july1_2016_above17 guess_july1_2016_partustXabv17 guess_july1_2016_partust_w3pre if guess_july1_2016_planust_tr != ., first
	eststo e_2: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_w3 guess_july1_2016_partust_w3pre) guess_july1_2016_partust_w3pre if (guess_july1_2016_planust_w3 < 17 & guess_july1_2016_planust_tr != .), first
	eststo e_3: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_w3 guess_july1_2016_partust_w3pre) guess_july1_2016_partust_w3pre if (guess_july1_2016_planust_w3 >= 17 & guess_july1_2016_planust_tr != .), first
	
	
	** Sumstats
	* Column (1)
	sum guess_july1_2016_partust_w3pos if belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_w3pos
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	sum participate_july1_2016_w3pos if belief_treatment_w3 == 0
	gen mu_3 = r(mean)
	gen sd_3 = r(sd)
	sum participate_july1_2016_w3pos
	gen mu_4 = r(mean)
	gen sd_4 = r(sd)	
	estadd scalar obs = N: e_1
	estadd scalar mu_a = mu_1: e_1
	estadd scalar sd_a = sd_1: e_1
	estadd scalar mu_b = mu_2: e_1
	estadd scalar sd_b = sd_2: e_1
	estadd scalar mu_c = mu_3: e_1
	estadd scalar sd_c = sd_3: e_1
	estadd scalar mu_d = mu_4: e_1
	estadd scalar sd_d = sd_4: e_1	
	drop mu_1 sd_1 mu_2 sd_2 mu_3 sd_3 mu_4 sd_4 N

	* Column (2)
	sum guess_july1_2016_partust_w3pos if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_w3pos if guess_july1_2016_planust_w3 < 17	
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	sum participate_july1_2016_w3pos if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 0
	gen mu_3 = r(mean)
	gen sd_3 = r(sd)
	sum participate_july1_2016_w3pos if guess_july1_2016_planust_w3 < 17
	gen mu_4 = r(mean)
	gen sd_4 = r(sd)	
	estadd scalar obs = N: e_2
	estadd scalar mu_a = mu_1: e_2
	estadd scalar sd_a = sd_1: e_2
	estadd scalar mu_b = mu_2: e_2
	estadd scalar sd_b = sd_2: e_2
	estadd scalar mu_c = mu_3: e_2
	estadd scalar sd_c = sd_3: e_2
	estadd scalar mu_d = mu_4: e_2
	estadd scalar sd_d = sd_4: e_2	
	drop mu_1 sd_1 mu_2 sd_2 mu_3 sd_3 mu_4 sd_4 N
	
		
	* Column (3)
	sum guess_july1_2016_partust_w3pos if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_w3pos if guess_july1_2016_planust_w3 >= 17
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	sum participate_july1_2016_w3pos if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 0
	gen mu_3 = r(mean)
	gen sd_3 = r(sd)
	sum participate_july1_2016_w3pos if guess_july1_2016_planust_w3 >= 17
	gen mu_4 = r(mean)
	gen sd_4 = r(sd)	
	estadd scalar obs = N: e_3
	estadd scalar mu_a = mu_1: e_3
	estadd scalar sd_a = sd_1: e_3
	estadd scalar mu_b = mu_2: e_3
	estadd scalar sd_b = sd_2: e_3
	estadd scalar mu_c = mu_3: e_3
	estadd scalar sd_c = sd_3: e_3
	estadd scalar mu_d = mu_4: e_3
	estadd scalar sd_d = sd_4: e_3	
	drop mu_1 sd_1 mu_2 sd_2 mu_3 sd_3 mu_4 sd_4 N
		
	
	esttab using Table_6.txt, append ///
		se keep(guess_july1_2016_partust_w3pos) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel C", nolabel) ///
		nomtitles nonumbers ///
		scalars("obs Observations" "mu_a 1ststage Mean (ctrl)" "sd_a 1ststage SD (ctrl)" "mu_b 1ststage Mean (all)" "sd_b 1ststage SD (all)" "mu_c Reduced Form Mean (ctrl)" "sd_c Reduced Form SD (ctrl)" "mu_d Reduced Form Mean (all)" "sd_d Reduced Form SD (all)")
	
	restore
