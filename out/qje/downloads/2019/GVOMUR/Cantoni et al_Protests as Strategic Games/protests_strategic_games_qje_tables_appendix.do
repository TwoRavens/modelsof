********************************************************************************
*	Protests as Strategic Games
*	Cantoni et al., Quarterly Journal of Economics
*	January 2019

*	Do-file to produce the tables of the appendix
********************************************************************************

*	Variable locals
	local var_demogra_hhecon 				`"monthly_income_total_w3 realest_totalowned_w3 father_educ_hsabove_w123 mother_educ_hsabove_w123"'
	local var_demogra_basic 				`"gender birth_year"'
	local var_demogra_childenv 				`"hs_language_english hkgeneration_w123"'
	local var_azscores_y 					`"az_democratic_support az_independence az_ntlidentity az_statusquo az_polrecent az_polapproach participate_umbrella_w3 vote_legco_2016_party_democ_w3 plan_july1_2016_w3pos az_game_identity demosis_donation_above0_w3"'
	local var_azscores_x_fundamental 		`"az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon az_demogra_childenv"'
	local var_azscores_x_simultaneous 		`"az_belief_institution az_belief_protesteff az_srec_democratic_hkust az_sres_independence_hkust az_sres_ntlidentity_hkust az_sres_statusquo_hkust az_sres_approach_hkust az_social_polnetwork az_social_sociability az_srec_democratic_fri az_sres_independence_fri az_sres_ntlidentity_fri az_sres_statusquo_fri az_sres_approach_fri az_media_frequency az_media_source az_pol_interest az_pol_knowledge"'

********************************************************************************

*	Table A.1		Balance checks wrt Part 1 survey items

	preserve
	keep if belief_treatment_w3 != . & followup_postjuly1st == 1
	keep if hk_local == 1
	
	tempname p
	postfile `p' str50 variable float mu_1 mu_2 pval_0 mu_3 mu_4 pval_1 mu_5 mu_6 pval_2 ///
		using Table_A1, replace
	
	* Control and treatment means
	foreach X of varlist `var_azscores_y' `var_azscores_x_fundamental' `var_azscores_x_simultaneous' gender birth_year religion_none {
		qui sum `X' if belief_treatment_w3 == 0
		local mu_1=r(mean)

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
	use Table_A1
	outsheet using Table_A1.xls, replace
	clear
	erase Table_A1.dta
	restore

	
	
	
*	Table A.2		Interacting treatment with unbalanced characteristics

	preserve

	cap erase Table_A2.xls
	cap erase Table_A2.txt
		
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
	
	** Regressions
	* Panel A
	qui reg guess_july1_2016_partust_w3pos belief_treatment_im guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17, r
	outreg2 using Table_A2.xls, addtext(Interaction, "`X'") br keep(belief_treatment_im) nor2 nonotes nocons

	foreach X of varlist demosis_donation_above0 az_preference_altruism az_preference_reciprocity az_big5_agreebleness az_big5_extraversion az_cognitive_iq az_belief_protesteff az_media_frequency {
		gen tr_X = belief_treatment_w3 * `X'
		qui reg guess_july1_2016_partust_w3pos belief_treatment_im `X' tr_X guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17, r
		outreg2 using Table_A2.xls, addtext(Interaction, "`X'") br keep(belief_treatment_im) nor2 nonotes nocons
		drop tr_X
		}
		
	* Panel B
	qui reg participate_july1_2016_w3pos belief_treatment_im, r
	outreg2 using Table_A2.xls, addtext(Interaction, "`X'") br keep(belief_treatment_im) nor2 nonotes nocons

	foreach X of varlist demosis_donation_above0 az_preference_altruism az_preference_reciprocity az_big5_agreebleness az_big5_extraversion az_cognitive_iq az_belief_protesteff az_media_frequency {
		gen tr_X = belief_treatment_w3 * `X'
		qui reg participate_july1_2016_w3pos belief_treatment_im `X' tr_X, r
		outreg2 using Table_A2.xls, addtext(Interaction, "`X'") br keep(belief_treatment_im) nor2 nonotes nocons
		drop tr_X
		}
	
	restore

			

			
*	Table A.3		Balance checks - attrition across survey parts
	
	* Duplicate observations
	preserve
	keep if hk_local == 1
	gen complete_both = (belief_treatment_w3 != . & followup_postjuly1st == 1)
	keep if complete_both == 1
	replace complete_both = 0
	gen dupp = 1
	save duplicate_temp, replace
	restore
	
	preserve
	keep if hk_local == 1

	gen complete_both = (belief_treatment_w3 != . & followup_postjuly1st == 1 & guess_july1_2016_partust_w3pos != .)
	
	* Append duplicates
	append using duplicate_temp
	erase duplicate_temp.dta

	* Recode variable (to appear in percent in summary statistics tables)
	recode plan_july1_2016_w3pos (1 = 100)
	
	tempname p
	postfile `p' str50 variable float mu_0 sd_0 mu_3 sd_3 tscore_03 pval_03 N_0 N_3 ///
		using Table_A3, replace
	
	foreach X of varlist gender birth_year az_demogra_childenv religion_none az_demogra_hhecon az_demogra_ownecon plan_july1_2016_w3pos guess_july1_2016_planust_w3 guess_july1_2016_partust_w3pre guess_july1_2016_part_w3pre {
		
		* Completed at least Part 1
		qui sum `X' if dupp != 1
		local N_0=r(N)
		local mu_0=r(mean)
		local sd_0=r(sd)

		* Complete only Part 1
		qui sum `X' if belief_treatment_w3 == . & dupp != 1
		local N_1=r(N)
		local mu_1=r(mean)
		local sd_1=r(sd)

		* Completed Part 1 and Part 2 only
		qui sum `X' if belief_treatment_w3 != . & followup_postjuly1st == 0 & dupp != 1
		local N_2=r(N)
		local mu_2=r(mean)
		local sd_2=r(sd)

		* Completed Part 1, Part 2, and Part 3
		qui sum `X' if belief_treatment_w3 != . & followup_postjuly1st == 1 & dupp != 1 & guess_july1_2016_partust_w3pos != .
		local N_3=r(N)
		local mu_3=r(mean)
		local sd_3=r(sd)
		
		// ttest of 
		qui ttest `X', by(complete_both)
		local tscore_03=r(t)
		local pval_03=r(p)
	
		post `p' ("`X'") /// 
		(`mu_0') (`sd_0') ///
		(`mu_3') (`sd_3') ///
		(`tscore_03') (`pval_03') ///
		(`N_0') (`N_3')
	}

	foreach X of varlist belief_treatment_w3 {

	* Completed Part 1, Part 2, and Part 3
		qui sum `X' if belief_treatment_w3 != . & followup_postjuly1st == 1 & dupp != 1 & guess_july1_2016_partust_w3pos != .
		local N_3=r(N)
		local mu_3=r(mean)
		local sd_3=r(sd)

		post `p' ("`X'") /// 
		(.) (.) ///
		(`mu_3') (`sd_3') ///
		(.) (.) (.) (`N_3') 
	}
		
	postclose `p'
	restore
	
	preserve	
	clear
	use Table_A3
	outsheet using Table_A3.xls, replace
	clear
	erase Table_A3.dta
	restore

	
	
	
*	Table A.4		Sample representativeness	
	
	preserve
	tempname p
	postfile `p' str50 variable float population_ratio sample_ratio p_value ///
		using Table_A4, replace
	
	* Population data (from the HKUST Student Affairs office)
	local male_2015 = 1224
	local male_2014 = 1163
	local male_2013 = 1209
	local male_2012 = 1094
	local female_2015 = 763
	local female_2014 = 702
	local female_2013 = 720
	local female_2012 = 731
	local seng_2015 = 775
	local seng_2014 = 711
	local seng_2013 = 737
	local seng_2012 = 649.5
	local ssci_2015 = 461
	local ssci_2014 = 440
	local ssci_2013 = 457
	local ssci_2012 = 446.5
	local sbm_2015 = 705
	local sbm_2014 = 667
	local sbm_2013 = 685
	local sbm_2012 = 653
	local shss_2015 = 44
	local shss_2014 = 45
	local shss_2013 = 48
	local shss_2012 = 44
	local ipo_2015 = 2
	local ipo_2014 = 2
	local ipo_2013 = 2
	local ipo_2012 = 50
	
	* Population ratios
	local popr_total = `seng_2015' + `seng_2014' + `seng_2013' + `seng_2012' ///
						+ `ssci_2015' + `ssci_2014' + `ssci_2013' + `ssci_2012' ///
						+ `sbm_2015' + `sbm_2014' + `sbm_2013' + `sbm_2012' ///
						+ `shss_2015' + `shss_2014' + `shss_2013' + `shss_2012' ///
						+ `ipo_2015' + `ipo_2014' + `ipo_2013' + `ipo_2012'
	local popr_total_coh = `male_2015' + `male_2014' + `male_2013' + `male_2012' + `female_2015' + `female_2014' + `female_2013' + `female_2012'						
	local popr_gender = (`male_2015' + `male_2014' + `male_2013' + `male_2012')/`popr_total'
	local popr_hkust_cohort_2012 = (`male_2012' + `female_2012')/`popr_total_coh'
	local popr_hkust_cohort_2013 = (`male_2013' + `female_2013')/`popr_total_coh'
	local popr_hkust_cohort_2014 = (`male_2014' + `female_2014')/`popr_total_coh'
	local popr_hkust_cohort_2015 = (`male_2015' + `female_2015')/`popr_total_coh'
	local popr_hkust_school_seng_w3 = (`seng_2015' + `seng_2014' + `seng_2013' + `seng_2012')/`popr_total'
	local popr_hkust_school_ssci_w3 = (`ssci_2015' + `ssci_2014' + `ssci_2013' + `ssci_2012')/`popr_total'
	local popr_hkust_school_sbm_w3 = (`sbm_2015' + `sbm_2014' + `sbm_2013' + `sbm_2012')/`popr_total'
	local popr_hkust_school_shss_w3 = (`shss_2015' + `shss_2014' + `shss_2013' + `shss_2012')/`popr_total'
	local popr_hkust_school_ipo_w3 = (`ipo_2015' + `ipo_2014' + `ipo_2013' + `ipo_2012')/`popr_total'
	
	
	* Cohort at HKUST
	replace hkust_cohort = 2015 	if birth_year >= 1997
	replace hkust_cohort = 2014  	if birth_year == 1996
	replace hkust_cohort = 2013  	if birth_year == 1995
	replace hkust_cohort = 2012  	if birth_year <= 1994	
	
	foreach yy in 12 13 14 15 {
		gen hkust_cohort_20`yy' = .
		replace hkust_cohort_20`yy' = 0 if hkust_cohort != .
		replace hkust_cohort_20`yy' = 1 if hkust_cohort == 20`yy'
	}
		
	
	** Table
	foreach var of varlist gender hkust_cohort_20* hkust_school_seng_w3 hkust_school_ssci_w3 hkust_school_sbm_w3 hkust_school_shss_w3 hkust_school_ipo_w3 {
		
		* Population ratios (column 1)
		local popratio = round(`popr_`var'',0.001)
		
		* Sample ratios (column 2)
		sum `var' if followup_prejuly1st == 1 & followup_postjuly1st == 1
		local sampratio: di %4.3f r(mean)

		* T-tests (column 3)
		ttest `var' == `popratio' if followup_prejuly1st == 1 & followup_postjuly1st == 1
		local p_value: di %4.3f r(p)
		
		post `p' ("`var'") (`popratio') (`sampratio') (`p_value')
	}

	postclose `p'
	restore
	
	preserve	
	clear
	use Table_A4
	outsheet using Table_A4.xls, replace
	clear
	erase Table_A4.dta
	restore
	
	
	
	
*	Table A.5		Predictors of planned participation and prior beliefs	

	* Column 1: Planned participation	
	preserve
	keep if hk_local == 1
	
	cap erase Table_A5_column1.xls
	cap erase Table_A5_column1.txt		

	foreach X of varlist `var_azscores_y' `var_azscores_x_fundamental' gender birth_year_bin religion_none `var_azscores_x_simultaneous' {

		if "`X'" != "plan_july1_2016_w3pos" {			

			qui reg plan_july1_2016_w3pos `X', r
			local t_X = _b[`X']/_se[`X']
			local p_X = 2*ttail(e(df_r),abs(`t_X'))
			qui summ `X'
			outreg2 using Table_A5_column1.xls, addstat(p-value, `p_X', "Mean X", `r(mean)', "Std.Dev.\ X", `r(sd)') addtext(Specification, OLS) br 
		}
	}
	restore
	
	* Column 2: Prior belief on planned participation
	preserve
	keep if hk_local == 1
	
	cap erase Table_A5_column2.xls
	cap erase Table_A5_column2.txt		

	foreach X of varlist `var_azscores_y' `var_azscores_x_fundamental' gender birth_year_bin religion_none `var_azscores_x_simultaneous' {
	
		qui reg guess_july1_2016_planust_w3 `X', r
		local t_X = _b[`X']/_se[`X']
		local p_X = 2*ttail(e(df_r),abs(`t_X'))
		qui summ `X'
		outreg2 using Table_A5_column2.xls, addstat(p-value, `p_X', "Mean X", `r(mean)', "Std.Dev.\ X", `r(sd)') addtext(Specification, OLS) br		
	}
	restore
	
	
	
*	Table A.6		First-stage effects / treatment effect on posterior beliefs

	preserve
	
	* Restricting sample
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st_w3 == 1
	drop if guess_july1_2016_partust_w3pos == .

	* Generate belief related variables
	gen guess_july1_2016_partust_d17 = abs(guess_july1_2016_partust_w3pos - 17)
	gen guess_july1_2016_partust_up = guess_july1_2016_partust_w3pos - guess_july1_2016_partust_w3pre
	gen guess_july1_2016_part_up = guess_july1_2016_part_w3pos - guess_july1_2016_part_w3pre	

	* Generate directional treatment indicator
	gen belief_treatment_im = belief_treatment_w3
	replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1

	* Generate trimmed prior beliefs
	winsor2 guess_july1_2016_planust_w3, cuts(5 95) trim
	rename guess_july1_2016_planust_w3_tr guess_july1_2016_planust_tr

	
	*** Table
	** Panel A
	eststo clear
		
	* HKUST students
	eststo: reg guess_july1_2016_partust_up belief_treatment_im, r
	eststo: reg guess_july1_2016_partust_up belief_treatment_w3 if guess_july1_2016_planust_w3 < 17, r
	eststo: reg guess_july1_2016_partust_up belief_treatment_w3 if guess_july1_2016_planust_w3 >= 17, r

	* HK Population
	eststo: reg guess_july1_2016_part_up belief_treatment_im, r
	eststo: reg guess_july1_2016_part_up belief_treatment_w3 if guess_july1_2016_planust_w3 < 17, r
	eststo: reg guess_july1_2016_part_up belief_treatment_w3 if guess_july1_2016_planust_w3 >= 17, r
	
	esttab using Table_A6.txt, replace ///
		se keep(belief_treatment_im belief_treatment_w3) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel A", nolabel) ///
		mtitle("All subjects" "Prior below truth" "Prior above truth" "All subjects" "Prior below truth" "Prior above truth") ///
		mgroups("HKUST students" "HK population", pattern(0 0 0 1 1 1))
	
	
	** Panel B
	eststo clear
	
	* HKUST students
	eststo: reg guess_july1_2016_partust_up belief_treatment_im `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3, r
	eststo: reg guess_july1_2016_partust_up belief_treatment_w3 `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3 if guess_july1_2016_planust_w3 < 17, r
	eststo: reg guess_july1_2016_partust_up belief_treatment_w3 `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3 if guess_july1_2016_planust_w3 >= 17, r

	* HK Population
	eststo: reg guess_july1_2016_part_up belief_treatment_im `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3 , r
	eststo: reg guess_july1_2016_part_up belief_treatment_w3 `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3 if guess_july1_2016_planust_w3 < 17, r
	eststo: reg guess_july1_2016_part_up belief_treatment_w3 `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3 if guess_july1_2016_planust_w3 >= 17, r
	
	esttab using Table_A6.txt, append ///
		se keep(belief_treatment_im belief_treatment_w3) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel B", nolabel) ///
		nomtitles nonumbers

		
	** Panel C
	eststo clear
	
	* HKUST students
	eststo e_1: reg guess_july1_2016_partust_up belief_treatment_im if guess_july1_2016_planust_tr != ., r
	eststo e_2: reg guess_july1_2016_partust_up belief_treatment_w3 if guess_july1_2016_planust_w3 < 17 & guess_july1_2016_planust_tr != ., r
	eststo e_3: reg guess_july1_2016_partust_up belief_treatment_w3 if guess_july1_2016_planust_w3 >= 17 & guess_july1_2016_planust_tr != ., r
		
	* HK Population
	eststo e_4: reg guess_july1_2016_part_up belief_treatment_im if guess_july1_2016_planust_tr != ., r
	eststo e_5: reg guess_july1_2016_part_up belief_treatment_w3 if guess_july1_2016_planust_w3 < 17 & guess_july1_2016_planust_tr != ., r
	eststo e_6: reg guess_july1_2016_part_up belief_treatment_w3 if guess_july1_2016_planust_w3 >= 17 & guess_july1_2016_planust_tr != ., r

		
	** Sumstats
	* Column (1)
	sum guess_july1_2016_partust_up if belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_up
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
	sum guess_july1_2016_partust_up if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_up if guess_july1_2016_planust_w3 < 17
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
	sum guess_july1_2016_partust_up if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_up if guess_july1_2016_planust_w3 >= 17
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
	sum guess_july1_2016_part_up if belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_part_up
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
	sum guess_july1_2016_part_up if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_part_up if guess_july1_2016_planust_w3 < 17
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
	sum guess_july1_2016_part_up if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 0	
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_part_up if guess_july1_2016_planust_w3 >= 17
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	estadd scalar obs = N: e_6
	estadd scalar mu_a = mu_1: e_6
	estadd scalar sd_a = sd_1: e_6
	estadd scalar mu_b = mu_2: e_6
	estadd scalar sd_b = sd_2: e_6
	drop mu_1 sd_1 mu_2 sd_2 N

	esttab using Table_A6.txt, append ///
		se keep(belief_treatment_im belief_treatment_w3) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel C", nolabel) ///
		nomtitles nonumbers ///
		scalars("obs Observations" "mu_a Mean (ctrl)" "sd_a SD (ctrl)" "mu_b Mean (all)" "sd_b SD (all)")

	restore

	
	
	
*	Table A.7		Variance Decomposition

	preserve
	
	cap erase Table_A7.txt		
	
	* Restricting sample
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st_w3 == 1
	drop if guess_july1_2016_partust_w3pos == .

	* Generate directional treatment indicator
	gen belief_treatment_im = belief_treatment_w3
	replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1	
	
		
	tempname p
	postfile `p' str50 variable float univ_r2 marg_r2 ///
		using Table_A7, replace
		
	** Univariate r2: individual
	foreach X of varlist belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none {
		qui reg participate_july1_2016_w3pos `X'
		local univ_r2: di %4.3f e(r2)
		post `p' ("`X'") ///
			(`univ_r2') (.)
	}	

	** Univariate r2: categorical
	qui reg participate_july1_2016_w3pos az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist
	local univ_r2: di %4.3f e(r2)
	post `p' ("Economic Preferences") ///
		(`univ_r2') (.)
	
	qui reg participate_july1_2016_w3pos az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion
	local univ_r2: di %4.3f e(r2)
	post `p' ("Personality Traits") ///
		(`univ_r2') (.)
	
	qui reg participate_july1_2016_w3pos az_cognitive_iq az_cognitive_gpa
	local univ_r2: di %4.3f e(r2)
	post `p' ("Cognitive Ability") ///
		(`univ_r2') (.)
	
	qui reg participate_july1_2016_w3pos az_demogra_hhecon az_demogra_ownecon
	local univ_r2: di %4.3f e(r2)
	post `p' ("Economic Status") ///
		(`univ_r2') (.)

	qui reg participate_july1_2016_w3pos gender birth_year_bin az_demogra_childenv religion_none
	local univ_r2: di %4.3f e(r2)
	post `p' ("Background Characteristics") ///
		(`univ_r2') (.)

			
	** Marginal r2: individual
	* All regressors
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local r2_all: di %4.3f e(r2)
	
	* Regressions leaving out one regressor
	qui reg participate_july1_2016_w3pos az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("belief_treatment_im") ///
		(.) (`marg_r2')
		
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_preference_risk") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_preference_time") ///
		(.) (`marg_r2')

	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_preference_altruism") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_preference_reciprocity") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_preference_redist") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_big5_openness") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_big5_agreebleness") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_big5_conscientious") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_big5_neuroticism") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_big5_extraversion") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_cognitive_iq") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_cognitive_gpa") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_demogra_hhecon") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_demogra_ownecon") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("gender") ///
		(.) (`marg_r2')

	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("birth_year_bin") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("az_demogra_childenv") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("religion_none") ///
		(.) (`marg_r2')

		
	* Marginal r2: categorical
	qui reg participate_july1_2016_w3pos belief_treatment_im az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("Economic Preferences") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("Personality Traits") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_demogra_hhecon az_demogra_ownecon gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("Cognitive Ability") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa gender birth_year_bin az_demogra_childenv religion_none
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("Economic Status") ///
		(.) (`marg_r2')
	
	qui reg participate_july1_2016_w3pos belief_treatment_im az_preference_risk az_preference_time az_preference_altruism az_preference_reciprocity az_preference_redist az_big5_openness az_big5_agreebleness az_big5_conscientious az_big5_neuroticism az_big5_extraversion az_cognitive_iq az_cognitive_gpa az_demogra_hhecon az_demogra_ownecon
	local marg_r2_lo: di %4.3f e(r2)
	local marg_r2 = `r2_all' - `marg_r2_lo'
	post `p' ("Background Characteristics") ///
		(.) (`marg_r2')
		

	postclose `p'
	restore
	
	preserve	
	clear
	use Table_A7
	outsheet using Table_A7.xls, replace
	clear
	erase Table_A7.dta
	restore
		
		
	
	
*	Table A.8	Plans to participate and subsequent treatment effects	

	preserve

	* Restricting sample
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st_w3 == 1
	drop if guess_july1_2016_partust_w3pos == .

	* Generate directional treatment indicator
	gen belief_treatment_im = belief_treatment_w3
	replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1	
	
	* Generate indicators of change in behavior
	gen july1st_planno_actualgo = (plan_july1_2016_w3pre >= 2 & participate_july1_2016_w3pos == 100) * 100 	if (plan_july1_2016_w3pre != . & participate_july1_2016_w3pos != .)

	* Generate trimmed prior beliefs
	winsor2 guess_july1_2016_planust_w3, cuts(5 95) trim
	rename guess_july1_2016_planust_w3_tr guess_july1_2016_planust_tr
	
			
	*** Table
	** Panel A
	eststo clear
		
	* Participated
	eststo: reg participate_july1_2016_w3pos belief_treatment_im, r
	eststo: reg participate_july1_2016_w3pos belief_treatment_im if plan_july1_2016_w3pre != 4 & plan_july1_2016_w3pre != ., r
	eststo: reg participate_july1_2016_w3pos belief_treatment_im if plan_july1_2016_w3pre != 1 & plan_july1_2016_w3pre != ., r
			
	* Plan changed: participated
	eststo: reg july1st_planno_actualgo belief_treatment_im if july1st_planno_actualgo != ., r
	
	esttab using Table_A8.txt, replace ///
		se keep(belief_treatment_im) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel A", nolabel) ///
		mtitle("All subjects" "Excl. part. w/ plan not to attend" "Excl. part. w/ plan not to attend" "All subjects") ///
		mgroups("Participated in 2016 July 1st March" "Plan changed: participated", pattern(0 0 0 1))
	
	
	** Panel B
	eststo clear
	
	* Participated
	eststo: reg participate_july1_2016_w3pos belief_treatment_im `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3, r
	eststo: reg participate_july1_2016_w3pos belief_treatment_im `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3 if plan_july1_2016_w3pre != 4 & plan_july1_2016_w3pre != ., r
	eststo: reg participate_july1_2016_w3pos belief_treatment_im `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3 if plan_july1_2016_w3pre != 1 & plan_july1_2016_w3pre != ., r
	
	* Plan changed: participated
	eststo: reg july1st_planno_actualgo belief_treatment_im `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3 if july1st_planno_actualgo != ., r
	
	esttab using Table_A8.txt, append ///
		se keep(belief_treatment_im) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel B", nolabel) ///
		nomtitles nonumbers

		
	** Panel C
	eststo clear
	
	* Participated
	eststo e_1: reg participate_july1_2016_w3pos belief_treatment_im if guess_july1_2016_planust_tr != ., r
	eststo e_2: reg participate_july1_2016_w3pos belief_treatment_im if plan_july1_2016_w3pre != 4 & plan_july1_2016_w3pre != . & guess_july1_2016_planust_tr != ., r
	eststo e_3: reg participate_july1_2016_w3pos belief_treatment_im if plan_july1_2016_w3pre != 1 & plan_july1_2016_w3pre != . & guess_july1_2016_planust_tr != ., r
		
	* Plan changed: participated
	eststo e_4: reg july1st_planno_actualgo belief_treatment_im if july1st_planno_actualgo != . & guess_july1_2016_planust_tr != ., r

		
	** Sumstats
	* Column (1)
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
	
	* Column (2)
	sum participate_july1_2016_w3pos if plan_july1_2016_w3pre != 4 & plan_july1_2016_w3pre != . & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum participate_july1_2016_w3pos if plan_july1_2016_w3pre != 4 & plan_july1_2016_w3pre != .
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
	sum participate_july1_2016_w3pos if plan_july1_2016_w3pre != 1 & plan_july1_2016_w3pre != . & belief_treatment_w3 == 0	
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum participate_july1_2016_w3pos if plan_july1_2016_w3pre != 1 & plan_july1_2016_w3pre != .
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
	sum july1st_planno_actualgo if belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum july1st_planno_actualgo
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	estadd scalar obs = N: e_4
	estadd scalar mu_a = mu_1: e_4
	estadd scalar sd_a = sd_1: e_4
	estadd scalar mu_b = mu_2: e_4
	estadd scalar sd_b = sd_2: e_4
	drop mu_1 sd_1 mu_2 sd_2 N

	esttab using Table_A8.txt, append ///
		se keep(belief_treatment_im) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel C", nolabel) ///
		nomtitles nonumbers ///
		scalars("obs Observations" "mu_a Mean (ctrl)" "sd_a SD (ctrl)" "mu_b Mean (all)" "sd_b SD (all)")

	restore	
	
	

	
*	Table A.9	Heterogeneous treatment effects by friends' expectated participation

	preserve

	* Restricting sample
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st_w3 == 1
	drop if guess_july1_2016_partust_w3pos == .

	* Generate interaction term
	gen guess_july1_2016_planfri_above0 = (guess_july1_2016_planfri > 0) if guess_july1_2016_planfri != .
	reg guess_july1_2016_planfri_above0 belief_treatment_w3, r
	gen treatmentXfriends = belief_treatment_w3 * guess_july1_2016_planfri_above0

	
	** Regressions
	* Panel A: 1st stage
	eststo clear
	eststo: reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_planfri_above0 treatmentXfriends if guess_july1_2016_planust_w3 < 17, r
	eststo: reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_planfri_above0 treatmentXfriends if guess_july1_2016_planust_w3 >= 17, r
 	
	esttab using Table_A9.txt, replace ///
		se keep(belief_treatment_w3 guess_july1_2016_planfri_above0 treatmentXfriends) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_w3 "Panel A", nolabel) ///
		mtitle("Prior below truth" "Prior above truth")
	
	* Panel B: reduced form
	eststo clear
	eststo e_1: reg participate_july1_2016_w3pos belief_treatment_w3 guess_july1_2016_planfri_above0 treatmentXfriends if guess_july1_2016_planust_w3 < 17, r
	eststo e_2: reg participate_july1_2016_w3pos belief_treatment_w3 guess_july1_2016_planfri_above0 treatmentXfriends if guess_july1_2016_planust_w3 >= 17, r

	** Sumstats
	* Column (1)
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

	esttab using Table_A9.txt, append ///
		se keep(belief_treatment_w3 guess_july1_2016_planfri_above0 treatmentXfriends) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_w3 "Panel B", nolabel) ///
		nomtitles nonumbers ///
		scalars("obs Observations" "mu_a 1ststage Mean (ctrl)" "sd_a 1ststage SD (ctrl)" "mu_b 1ststage Mean (all)" "sd_b 1ststage SD (all)" "mu_c Reduced Form Mean (ctrl)" "sd_c Reduced Form SD (ctrl)" "mu_d Reduced Form Mean (all)" "sd_d Reduced Form SD (all)")
	
	restore	
		
		
		
	
*	Table A.10		Second stage effects / Two stage estimates on protest participation (changes in beliefs)
	
	preserve
	
	* Restricting sample
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st_w3 == 1
	drop if guess_july1_2016_partust_w3pos == .

	* Generate belief related variables
	gen guess_july1_2016_partust_d17 = abs(guess_july1_2016_partust_w3pos - 17)
	gen guess_july1_2016_partust_up = guess_july1_2016_partust_w3pos - guess_july1_2016_partust_w3pre
	gen guess_july1_2016_part_up = guess_july1_2016_part_w3pos - guess_july1_2016_part_w3pre

	* Generate directional treatment indicator
	gen belief_treatment_im = belief_treatment_w3
	replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1	
	
	* Generate trimmed prior beliefs
	winsor2 guess_july1_2016_planust_w3, cuts(5 95) trim
	rename guess_july1_2016_planust_w3_tr guess_july1_2016_planust_tr
	
	
	** Regressions
	* Panel A
	eststo clear
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_up = belief_treatment_im), first
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_up = belief_treatment_w3) if guess_july1_2016_planust_w3 < 17, first
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_up = belief_treatment_w3) if guess_july1_2016_planust_w3 >= 17, first

	esttab using Table_A10.txt, replace ///
		se keep(guess_july1_2016_partust_up) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(guess_july1_2016_partust_up "Panel A", nolabel) ///
		mtitle("All subjects" "Prior below truth" "Prior above truth")

		
	* Panel B
	eststo clear
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_up = belief_treatment_im) `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3, first
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_up = belief_treatment_w3) `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3 if guess_july1_2016_planust_w3 < 17, first
	eststo: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_up = belief_treatment_w3) `var_demogra_basic' `var_demogra_hhecon' `var_demogra_childenv' guess_july1_2016_planust_w3 if guess_july1_2016_planust_w3 >= 17, first

	esttab using Table_A10.txt, append ///
		se keep(guess_july1_2016_partust_up) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(guess_july1_2016_partust_up "Panel B", nolabel) ///
		nomtitles nonumbers
	
	
	* Panel C
	eststo clear
	eststo e_1: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_up = belief_treatment_im) if guess_july1_2016_planust_tr != ., first
	eststo e_2: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_up = belief_treatment_w3) if (guess_july1_2016_planust_w3 < 17 & guess_july1_2016_planust_tr != .), first
	eststo e_3: ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_up = belief_treatment_w3) if (guess_july1_2016_planust_w3 >= 17 & guess_july1_2016_planust_tr != .), first


	** Sumstats
	* Column (1)
	sum guess_july1_2016_partust_up if belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_up
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
	sum guess_july1_2016_partust_up if guess_july1_2016_planust_w3 < 17 & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_up if guess_july1_2016_planust_w3 < 17	
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
	sum guess_july1_2016_partust_up if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 0
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_up if guess_july1_2016_planust_w3 >= 17
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
		
		
	esttab using Table_A10.txt, append ///
		se keep(guess_july1_2016_partust_up) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(guess_july1_2016_partust_up "Panel B", nolabel) ///
		nomtitles nonumbers ///
		scalars("obs Observations" "mu_a 1ststage Mean (ctrl)" "sd_a 1ststage SD (ctrl)" "mu_b 1ststage Mean (all)" "sd_b 1ststage SD (all)" "mu_c Reduced Form Mean (ctrl)" "sd_c Reduced Form SD (ctrl)" "mu_d Reduced Form Mean (all)" "sd_d Reduced Form SD (all)")
	
	restore	
	
	

	
*	Table A.11		Reweighted samples

	*** Part 1 subjects (column 2)	
	preserve
	
	* Restrict sample
	keep if hk_local == 1
	drop if guess_july1_2016_partust_w3pos == .	
		
	* Generate sample splitting indicator and interaction with controls
	gen guess_july1_2016_above17 = (guess_july1_2016_planust_w3 >= 17) 	if guess_july1_2016_planust_w3 != .
	gen guess_july1_2016_partustXabv17 = guess_july1_2016_partust_w3pre * guess_july1_2016_above17
	
	* Generate sample weights
	gen count = 1
	gen az_demogra_childenv_above0 = (az_demogra_childenv > 0)
	gen az_demogra_hhecon_above0 = (az_demogra_hhecon > 0)
	gen az_demogra_ownecon_above0 = (az_demogra_ownecon > 0)
	
	bysort gender birth_year az_demogra_childenv_above0 religion_none az_demogra_hhecon_above0 az_demogra_ownecon_above0: egen cell_sum_part1 = sum(count)	
	bysort gender birth_year az_demogra_childenv_above0 religion_none az_demogra_hhecon_above0 az_demogra_ownecon_above0: egen cell_sum_final = sum(count) if (belief_treatment_w3 != . & followup_postjuly1st == 1)
	gen attrition_weight = cell_sum_part1 / cell_sum_final
	
	* Generate directional treatment indicator
	gen belief_treatment_im = belief_treatment_w3
	replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1
	
	* Reweighted regression
	keep if hk_local == 1
	keep if belief_treatment_w3 != .
	drop if guess_july1_2016_partust_w3pos == .

	
	** Table
	* Panel A
	eststo clear
	ivreg2 participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_im guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17) guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17 [w=attrition_weight], first savefirst savefprefix(firststage)
	estimates restore firststage*

	esttab using Table_A11_column2.txt, replace ///
		se keep(belief_treatment_im) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel A", nolabel) ///
		mtitle("Part 1 subjects")

		
	* Panel B
	eststo clear
	eststo e_2: reg participate_july1_2016_w3pos belief_treatment_im [w=attrition_weight], r
	
	* Sumstats
	sum guess_july1_2016_partust_w3pos if belief_treatment_w3 == 0 [w=attrition_weight]
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_w3pos [w=attrition_weight]
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	sum participate_july1_2016_w3pos if belief_treatment_w3 == 0 [w=attrition_weight]
	gen mu_3 = r(mean)
	gen sd_3 = r(sd)
	sum participate_july1_2016_w3pos [w=attrition_weight]
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
		
	esttab using Table_A11_column2.txt, append ///
		se keep(belief_treatment_im) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel B", nolabel) ///
		nomtitles nonumbers ///
		scalars("obs Observations" "mu_a 1ststage Mean (ctrl)" "sd_a 1ststage SD (ctrl)" "mu_b 1ststage Mean (all)" "sd_b 1ststage SD (all)" "mu_c Reduced Form Mean (ctrl)" "sd_c Reduced Form SD (ctrl)" "mu_d Reduced Form Mean (all)" "sd_d Reduced Form SD (all)")
	
	restore	
	
	
	*** All HKUST student population (column 3)
	preserve
	
	* Cohort at HKUST
	replace hkust_cohort = 2015 	if birth_year >= 1997
	replace hkust_cohort = 2014  	if birth_year == 1996
	replace hkust_cohort = 2013  	if birth_year == 1995
	replace hkust_cohort = 2012  	if birth_year <= 1994
	
	gen hkust_school_other = (hkust_school_seng == 0 & hkust_school_ssci == 0)
	gen hkust_weight = 0

	replace hkust_weight = 6.66 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2012 & hkust_school_seng == 1
	replace hkust_weight = 5.90 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2012 & hkust_school_ssci == 1
	replace hkust_weight = 7.02 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2012 & hkust_school_other == 1
	replace hkust_weight = 4.15 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2012 & hkust_school_seng == 1
	replace hkust_weight = 4.59 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2012 & hkust_school_ssci == 1
	replace hkust_weight = 6.20 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2012 & hkust_school_other == 1

	replace hkust_weight = 7.19 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2013 & hkust_school_seng == 1
	replace hkust_weight = 8.58 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2013 & hkust_school_ssci == 1
	replace hkust_weight = 6.50 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2013 & hkust_school_other == 1
	replace hkust_weight = 6.75 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2013 & hkust_school_seng == 1
	replace hkust_weight = 4.83 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2013 & hkust_school_ssci == 1
	replace hkust_weight = 4.52 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2013 & hkust_school_other == 1

	replace hkust_weight = 7.24 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2014 & hkust_school_seng == 1
	replace hkust_weight = 5.91 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2014 & hkust_school_ssci == 1
	replace hkust_weight = 5.27 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2014 & hkust_school_other == 1
	replace hkust_weight = 4.34 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2014 & hkust_school_seng == 1
	replace hkust_weight = 5.17 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2014 & hkust_school_ssci == 1
	replace hkust_weight = 4.60 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2014 & hkust_school_other == 1

	replace hkust_weight = 6.77 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2015 & hkust_school_seng == 1
	replace hkust_weight = 5.08 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2015 & hkust_school_ssci == 1
	replace hkust_weight = 4.99 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 1 & hkust_cohort == 2015 & hkust_school_other == 1
	replace hkust_weight = 5.15 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2015 & hkust_school_seng == 1
	replace hkust_weight = 4.82 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2015 & hkust_school_ssci == 1
	replace hkust_weight = 3.24 	if followup_prejuly1st == 1 & followup_postjuly1st == 1 & gender == 0 & hkust_cohort == 2015 & hkust_school_other == 1	

	* Generate sample splitting indicator and interaction with controls
	gen guess_july1_2016_above17 = (guess_july1_2016_planust_w3 >= 17) 	if guess_july1_2016_planust_w3 != .
	gen guess_july1_2016_partustXabv17 = guess_july1_2016_partust_w3pre * guess_july1_2016_above17

	* Generate directional treatment indicator
	gen belief_treatment_im = belief_treatment_w3
	replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1

	* Reweighted regression
	keep if hk_local == 1
	keep if belief_treatment_w3 != .
	drop if guess_july1_2016_partust_w3pos == .	
	

	** Table A11, column 3
	* Panel A
	eststo clear
	ivreg2 participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_im guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17) guess_july1_2016_partust_w3pre guess_july1_2016_above17 guess_july1_2016_partustXabv17 [w=hkust_weight], first savefirst savefprefix(firststage)
	estimates restore firststage*

	esttab using Table_A11_column3.txt, replace ///
		se keep(belief_treatment_im) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel A", nolabel) ///
		mtitle("All HKUST")

		
	* Panel B
	eststo clear
	eststo e_3: reg participate_july1_2016_w3pos belief_treatment_im [w=hkust_weight], r

	* Sumstats
	sum guess_july1_2016_partust_w3pos if belief_treatment_w3 == 0 [w=hkust_weight]
	gen mu_1 = r(mean)
	gen sd_1 = r(sd)
	sum guess_july1_2016_partust_w3pos [w=hkust_weight]
	gen mu_2 = r(mean)
	gen sd_2 = r(sd)
	gen N = r(N)
	sum participate_july1_2016_w3pos if belief_treatment_w3 == 0 [w=hkust_weight]
	gen mu_3 = r(mean)
	gen sd_3 = r(sd)
	sum participate_july1_2016_w3pos [w=hkust_weight]
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
		
	esttab using Table_A11_column3.txt, append ///
		se keep(belief_treatment_im) ///
		star(* 0.1 ** 0.05 *** 0.01) ///
		noobs nonotes nogaps ///
		refcat(belief_treatment_im "Panel B", nolabel) ///
		nomtitles nonumbers ///
		scalars("obs Observations" "mu_a 1ststage Mean (ctrl)" "sd_a 1ststage SD (ctrl)" "mu_b 1ststage Mean (all)" "sd_b 1ststage SD (all)" "mu_c Reduced Form Mean (ctrl)" "sd_c Reduced Form SD (ctrl)" "mu_d Reduced Form Mean (all)" "sd_d Reduced Form SD (all)")
	
	restore
	
	
	

*	Table A.12		Protest participation and pro-sociality	

	preserve
	
	* Restricting sample
	keep if belief_treatment_w3 != .
	keep if hk_local == 1
	keep if followup_postjuly1st_w3 == 1
	drop if guess_july1_2016_partust_w3pos == .

	* Generate directional treatment indicator
	gen belief_treatment_im = belief_treatment_w3
	replace belief_treatment_im = -1 			if guess_july1_2016_planust_w3 >= 17 & belief_treatment_w3 == 1	
	
	* Regressions
	reg participate_july1_2016_w3pos az_preference_social, r
	sum participate_july1_2016_w3pos if belief_treatment_w3 == 0
	local mu_1: di %4.3f r(mean)
	local sd_1: di %4.3f r(sd)
	sum participate_july1_2016_w3pos
	outreg2 using Table_A12.xls, replace keep(az_preference_social) nor2 nonotes nocons addtext(Mean_ctrl, `mu_1', SD_ctrl, `sd_1') addstat(Mean_all, r(mean), SD_all, r(sd))

	reg participate_july1_2016_w3pos az_preference_social belief_treatment_im, r
	sum participate_july1_2016_w3pos if belief_treatment_w3 == 0
	local mu_1: di %4.3f r(mean)
	local sd_1: di %4.3f r(sd)
	sum participate_july1_2016_w3pos
	outreg2 using Table_A12.xls, append keep(az_preference_social) nor2 nonotes nocons addtext(Mean_ctrl, `mu_1', SD_ctrl, `sd_1') addstat(Mean_all, r(mean), SD_all, r(sd))
		
	reg participate_july1_2016_w3pos az_preference_social guess_july1_2016_partust_w3pos, r
	sum participate_july1_2016_w3pos if belief_treatment_w3 == 0
	local mu_1: di %4.3f r(mean)
	local sd_1: di %4.3f r(sd)
	sum participate_july1_2016_w3pos
	outreg2 using Table_A12.xls, append keep(az_preference_social) nor2 nonotes nocons addtext(Mean_ctrl, `mu_1', SD_ctrl, `sd_1') addstat(Mean_all, r(mean), SD_all, r(sd))
		
	reg participate_july1_2016_w3pos az_preference_social az_antiauthoritarian_stated, r
	sum participate_july1_2016_w3pos if belief_treatment_w3 == 0
	local mu_1: di %4.3f r(mean)
	local sd_1: di %4.3f r(sd)
	sum participate_july1_2016_w3pos
	outreg2 using Table_A12.xls, append keep(az_preference_social) nor2 nonotes nocons addtext(Mean_ctrl, `mu_1', SD_ctrl, `sd_1') addstat(Mean_all, r(mean), SD_all, r(sd))
		
	reg participate_july1_2016_w3pos az_preference_social belief_treatment_im guess_july1_2016_partust_w3pos az_antiauthoritarian_stated, r	
	sum participate_july1_2016_w3pos if belief_treatment_w3 == 0
	local mu_1: di %4.3f r(mean)
	local sd_1: di %4.3f r(sd)
	sum participate_july1_2016_w3pos
	outreg2 using Table_A12.xls, append keep(az_preference_social) nor2 nonotes nocons addtext(Mean_ctrl, `mu_1', SD_ctrl, `sd_1') addstat(Mean_all, r(mean), SD_all, r(sd))

	restore
