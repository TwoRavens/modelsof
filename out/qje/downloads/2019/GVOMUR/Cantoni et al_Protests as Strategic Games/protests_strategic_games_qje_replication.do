********************************************************************************
*	Protests as Strategic Games
*	Cantoni et al., Quarterly Journal of Economics
*	January 2019

*	Main Replication File: Statistics, Figures, and Tables
********************************************************************************

	clear all
	set more off, perm
	capture log close
		
* 	Define root name for replication folder
	global directory_path 	`"TYPE IN PATH OF THE REPLICATION FOLDER"'
	cd "$directory_path"
				
********************************************************************************
*	Data Preparation
********************************************************************************

*	Load the data
	use protests_strategic_games_qje_data, clear
	
	
*	Generate additional variables

	* Birth_place indicator
	gen birth_place_hk = (birth_place == "HK")
	label variable birth_place_hk "Born in Hong Kong"

	
	* HK local: self
	gen hk_local = .
	replace hk_local = 1 	if (birth_place == "HK" | move_hk_age <= 10)
	replace hk_local = 0 	if (birth_place != "HK" & move_hk_age > 10)
	label variable hk_local "Hong Kong local"
	
	
	* Birthyear
	gen birth_year_bin = birth_year
	replace birth_year_bin = 1993 	if birth_year < 1993
	replace birth_year_bin = 1998 	if birth_year > 1998
	label variable birth_year_bin "Birth year bin"
	
	
	* List experiments
	foreach c in ipad indp hkid fccp viol {
		* Calculate overall count for direct group
		gen list_countd_`c'_direct = list_count_`c'_direct_w3 + list_dummy_`c'_w3
		gen list_count_`c' = .
		replace list_count_`c' = list_countd_`c'_direct 	if list_exp_direct_w3 == 1
		replace list_count_`c' = list_count_`c'_veiled_w3	if list_exp_direct_w3 == 0
	}	 
	label variable list_countd_ipad_direct "List experiment: Control set (total) - ipad"
	label variable list_countd_indp_direct "List experiment: Control set (total) - independence"
	label variable list_countd_hkid_direct "List experiment: Control set (total) - HK identity"
	label variable list_countd_fccp_direct "List experiment: Control set (total) - CCP"
	label variable list_countd_viol_direct "List experiment: Control set (total) - violence"

	label variable list_count_ipad "List experiment: All - ipad"
	label variable list_count_indp "List experiment: All - independence"
	label variable list_count_hkid "List experiment: All - HK identity"
	label variable list_count_fccp "List experiment: All - CCP"
	label variable list_count_viol "List experiment: All - violence"

	
	* Indicator for provision of veil
	gen list_exp_veiled = 1 - list_exp_direct_w3
	label variable list_exp_veiled "Veiled question in list experiment (Treatment group)"

	
	* Indicators for participation in previous protests
		* July-1st protests (both of them)
		gen participate_july1st_previous = (participate_july1_2014 == 1 & participate_july1_2015_w3 == 1)
		
		* Additional protets
		gen participate_otherprotests = ((participate_june4_2014 + participate_june4_2015 + participate_antimainlmoms + participate_anti_curricl) > 0)
				
		* Standardize
		egen participate_umbrella_std = std(participate_umbrella_w3)
		label variable participate_umbrella_std "Participated in Umbrella Revolution"

		egen participate_july1st_previous_std = std(participate_july1st_previous)
		label variable participate_july1st_previous_std "Participated in previous July 1st protests"

		egen participate_otherprotests_std = std(participate_otherprotests)
		label variable participate_otherprotests_std "Participated in other protests"	
						
	
********************************************************************************
*	Statistics in Main Text
********************************************************************************

	* Section III.B
	
		* HK locals having completed Part 1
		tab hk_local

		* HK locals having completed Part 1 & 2
		preserve
		drop if belief_treatment_w3 == .
		tab hk_local
		restore
		
		* HK locals having completed Part 1, 2, and 3
		preserve
		keep if belief_treatment_w3 != . & followup_postjuly1st == 1
		keep if hk_local == 1
		drop if guess_july1_2016_partust_w3pos == .		
		tab hk_local
		restore
		
	
	* Section III.C
	preserve
	
		* Restricting sample to experimental sample
		keep if belief_treatment_w3 != . & followup_postjuly1st == 1
		keep if hk_local == 1
		drop if guess_july1_2016_partust_w3pos == .
			
		* Prior on planned participation (in %)
		sum guess_july1_2016_planust_w3
		
		* Prior on actual participation (in %)
		sum guess_july1_2016_partust_w3pre

		* Correlation of prior beliefs on planned and actual participation
		corr guess_july1_2016_planust_w3 guess_july1_2016_partust_w3pre
		
		* Prior on total participation
		sum guess_july1_2016_part_w3pre

		* Posterior on actual participation (in %)
		sum guess_july1_2016_partust_w3pos
		
		* Posterior on total participation
		sum guess_july1_2016_part_w3pos
		
		* Participation in July 1 2016 March
		sum participate_july1_2016_w3pos

	restore

	
	* Section IV.A
	preserve
	
		* Restricting sample to experimental sample
		keep if belief_treatment_w3 != . & followup_postjuly1st_w3 == 1	
		keep if hk_local == 1
		drop if guess_july1_2016_partust_w3pos == .

		* Kolmogorov-Smirnov test of distribution: posterior beliefs between control and treatment group
		ksmirnov guess_july1_2016_partust_w3pos, by(belief_treatment_w3)

		* Equality of coefficients (Table III)		
		reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 < 17
		est store first_below
		reg guess_july1_2016_partust_w3pos belief_treatment_w3 guess_july1_2016_partust_w3pre if guess_july1_2016_planust_w3 >= 17
		est store first_above
		suest first_below first_above
		test [first_below_mean]belief_treatment = [first_above_mean]belief_treatment
		
	restore
	

	* Section IV.B
	preserve
	
		* Restricting sample to experimental sample
		keep if belief_treatment_w3 != . & followup_postjuly1st_w3 == 1	
		keep if hk_local == 1
		drop if guess_july1_2016_partust_w3pos == .
		
		* Equality of coefficients (Table IV)
		reg participate_july1_2016_w3pos belief_treatment_w3 if guess_july1_2016_planust_w3 < 17
		est store reduced_below
		reg participate_july1_2016_w3pos belief_treatment_w3 if guess_july1_2016_planust_w3 >= 17
		est store reduced_above
		suest reduced_below reduced_above
		test [reduced_below_mean]belief_treatment = [reduced_above_mean]belief_treatment
			
		* Persuasion rate (DellaVigna and Gentzkow, 2010): Individuals with priors above the provided information
		local e_T = 1				// share of treatment group receiving the information
		local e_C = 0				// share of control group receiving the information
		qui sum participate_july1_2016_w3pos if belief_treatment_w3 == 1 & guess_july1_2016_planust_w3 >= 17
		local y_T = r(mean)/100		// treatment group: individuals with prior above 17% which received the information
		qui sum participate_july1_2016_w3pos if belief_treatment_w3 == 0 & guess_july1_2016_planust_w3 >= 17
		local y_C = r(mean)/100		// control group: individuals with prior above 17% which did not receive the information
		local y_0 = `y_C'
		local persuasion_rate_above = 100*(`y_T' - `y_C')/(`e_T' - `e_C')*1/(1-`y_0')
		dis "Persuasion Rate (prior above the provided information): `persuasion_rate_above' percent"	
			
	restore
		
	
*	Section IV.C
	tempfile tempdata
	save "`tempdata'", replace
	
		* Restricting sample to experimental sample
		keep if belief_treatment_w3 != . & followup_postjuly1st_w3 == 1	
		keep if hk_local == 1
		drop if guess_july1_2016_partust_w3pos == .
		
		* Equality of coefficients (Table VI)
		gen below = 0
		replace below = 1 if guess_july1_2016_planust_w3 < 17
		gen above = 0
		replace above = 1 if guess_july1_2016_planust_w3 >= 17
		
		ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_w3 guess_july1_2016_partust_w3pre) guess_july1_2016_partust_w3pre if below, first
		est store second_below
		esttab second_below
		ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos = belief_treatment_w3 guess_july1_2016_partust_w3pre) guess_july1_2016_partust_w3pre if above, first	
		est store second_above
			
		preserve
		gen idcode = _n
		expand 2
		bys idcode: gen n=_n
		keep if (n==1&below)|(n==2&above)
		gen guess_july1_2016_partust_w3pos_1 = guess_july1_2016_partust_w3pos*!(n==1&below)
		gen guess_july1_2016_partust_w3pos_2 = guess_july1_2016_partust_w3pos*!(n==2&above)
		gen belief_treatment_w3_1 = belief_treatment_w3*!(n==1&below)
		gen belief_treatment_w3_2 = belief_treatment_w3*!(n==2&above)
		gen guess_july1_2016_partust_w3pre_1 = guess_july1_2016_partust_w3pre*!(n==1&below)
		gen guess_july1_2016_partust_w3pre_2 = guess_july1_2016_partust_w3pre*!(n==2&above)
		
		ivregress 2sls participate_july1_2016_w3pos (guess_july1_2016_partust_w3pos_? = belief_treatment_w3_? guess_july1_2016_partust_w3pre_?) guess_july1_2016_partust_w3pre_? n, cl(idcode)
		est sto second_stacked
		esttab second_below second_above second_stacked, nogaps mti
		restore
		
		test guess_july1_2016_partust_w3pos_1 = guess_july1_2016_partust_w3pos_2

	use "`tempdata'", clear
	

********************************************************************************
*	Figures
********************************************************************************

*	Set current directory to Figures folder
	cd "$directory_path\Figures"

	
*	Figures of the main part of the paper (attention: takes ~20 minutes to run)
	run "$directory_path\protests_strategic_games_qje_figures_main"

	
*	Figures of the appendix
	run "$directory_path\protests_strategic_games_qje_figures_appendix"

		
********************************************************************************
*	Tables
********************************************************************************

*	Set current directory to Tables folder
	cd "$directory_path\Tables"
	
	
*	Tables of the main part of the paper
	run "$directory_path\protests_strategic_games_qje_tables_main"

	
*	Tables of the appendix
	run "$directory_path\protests_strategic_games_qje_tables_appendix"
	
