	clear all
	set more off
	
	use "RawData.dta", clear
			
	/*************************************************************************
	* Dropping observations who did not complete risk choice task			 *
	*************************************************************************/
		
	// Missing practical trials
	drop if experiment_leandro_31_ == "" 
	drop if experiment_leandro_32_ == ""

	// Missing actual choices
	forvalues i = 1/25 {
		drop if experiment_leandro_`i'_ == ""
	}
	
	/*************************************************************************
	* Dropping those who answered in the survey that they stayed in school   *
	* until age 17 or older													 *
	*************************************************************************/

	keep if educ_age <= 7 

	/*************************************************************************
	* Dropping those for whom DoB was missing							     *
	*************************************************************************/
	
	replace byear = .	if byear == 9999
	replace bmonth = . 	if bmonth == 97 | bmonth == 99  
	replace bday = .	if bday == 97 | bday == 99
 
	gen DoB = mdy(bmonth,bday,byear)  
 	drop if DoB == . | DoB == .e
 	format DoB %td
	
	/*************************************************************************
	* Running variable, Jumping variable, and Trends					     *
	*************************************************************************/
	
	gen post = (DoB >= mdy(9,1,1957))	
	gen R_days = DoB - mdy(9,1,1957) 
	gen post_R_days = post * R_days
 	gen R_months   = ((byear-1957)*12) + (bmonth-9)	
	gen R_quarters = floor(R_months/3)
	*drop R_months

	/*************************************************************************
	* Endogenous variable												     *
	*************************************************************************/
	
	* Asked in current survey
	 gen edu16 = .
		replace edu16 = 0	if educ_age <= 6
		replace edu16 = 1	if educ_age == 7
	
	* Asked by YouGov in older survey
	 gen edu16_alternative = .
		replace edu16_alternative = 0	if profile_education_age == 1
		replace edu16_alternative = 1	if profile_education_age == 2
	
	/*************************************************************************
	* Qualifications													     *
	*************************************************************************/
	
	gen no_educ = .
		replace no_educ = 0 if profile_education_level >= 1 & profile_education_level <= 18
		replace no_educ = 1 if profile_education_level == 1

	gen qualification = 1 - no_educ
		
	gen low_level_educ = .
		replace low_level_educ = 0 if  profile_education_level >= 1 & profile_education_level <= 18
		replace low_level_educ = 1 if (profile_education_level >= 2 & profile_education_level <= 5) | profile_education_level == 10 

	gen CSE = .
		replace CSE = 0 if profile_education_level >= 1 & profile_education_level <= 18
		replace CSE = 1 if profile_education_level == 8

	gen Olevel = .
		replace Olevel = 0 if profile_education_level >= 1 & profile_education_level <= 18
		replace Olevel = 1 if profile_education_level == 9

	gen high_level_vocational = .
		replace high_level_vocational = 0 if profile_education_level >= 1 & profile_education_level <= 18
		replace high_level_vocational = 1 if profile_education_level == 6 | profile_education_level == 7
		
	gen A_level = .
		replace A_level = 0 if profile_education_level >= 1 & profile_education_level <= 18
		replace A_level = 1 if profile_education_level >= 11 & profile_education_level <= 18
	
	/*************************************************************************
	* Income															     *
	*************************************************************************/
	
	gen high_income = 0					if profile_gross_household <= 15
		replace high_income = 1 		if profile_gross_household >=  6 & profile_gross_household <= 15
	
	gen prsnl_income = .
		replace prsnl_income = 5000		if profile_gross_personal == 1
		replace prsnl_income = 10000	if profile_gross_personal == 2
		replace prsnl_income = 15000	if profile_gross_personal == 3
		replace prsnl_income = 20000	if profile_gross_personal == 4
		replace prsnl_income = 25000	if profile_gross_personal == 5
		replace prsnl_income = 30000	if profile_gross_personal == 6
		replace prsnl_income = 35000	if profile_gross_personal == 7
		replace prsnl_income = 40000	if profile_gross_personal == 8
		replace prsnl_income = 45000	if profile_gross_personal == 9
		replace prsnl_income = 50000	if profile_gross_personal == 10
		replace prsnl_income = 60000	if profile_gross_personal == 11
		replace prsnl_income = 70000	if profile_gross_personal == 12				
		replace prsnl_income = 100000	if profile_gross_personal == 13	
	
	gen hhld_income = .
		replace hhld_income = 5000		if profile_gross_household == 1
		replace hhld_income = 10000		if profile_gross_household == 2
		replace hhld_income = 15000		if profile_gross_household == 3
		replace hhld_income = 20000		if profile_gross_household == 4
		replace hhld_income = 25000		if profile_gross_household == 5
		replace hhld_income = 30000		if profile_gross_household == 6
		replace hhld_income = 35000		if profile_gross_household == 7
		replace hhld_income = 40000		if profile_gross_household == 8
		replace hhld_income = 45000		if profile_gross_household == 9
		replace hhld_income = 50000		if profile_gross_household == 10
		replace hhld_income = 60000		if profile_gross_household == 11
		replace hhld_income = 70000		if profile_gross_household == 12				
		replace hhld_income = 100000	if profile_gross_household == 13
		replace hhld_income = 150000	if profile_gross_household == 14
		replace hhld_income = 200000	if profile_gross_household == 15
	
	/*************************************************************************
	* Whether owns house											     	*
	*************************************************************************/
	
	gen owner = .
		replace owner = 1	if profile_house_tenure >= 1 & profile_house_tenure <= 3
		replace owner = 0	if profile_house_tenure >= 4 & profile_house_tenure <= 9
		
	/*************************************************************************
	* Predetermined variables											     *
	*************************************************************************/
	
	* Gender
	gen male = .
		replace male = 0 if profile_gender == 2
		replace male = 1 if profile_gender == 1

	* Ethnicity
	gen white = .
		replace white = 0 if profile_ethnicity ~= 98
		replace white = 1 if profile_ethnicity == 1
	gen missing_white = (white == . | white == .e)

	* # bedrooms
	clonevar num_bedrooms = raroo
	gen missing_num_bedrooms = (num_bedrooms == . | num_bedrooms == .e)
	format num_bedrooms %9.0g
	
	* # household size at age 10
	clonevar hhld_size = rapeo
	gen missing_hhld_size = (hhld_size == . | hhld_size == .e)	
	format hhld_size %9.0g

	* if parents unemployed for +6 months
	gen parents_unempl = .
		replace parents_unempl = 0	if rsunemp == 2		
		replace parents_unempl = 1	if rsunemp == 1
	gen missing_parents_unempl = (parents_unempl == . | parents_unempl == .e)
	
	* # of books at age 10
	gen num_books_0_10  	= 0 if rabks >= 1 &	rabks <= 5
	gen num_books_11_25 	= 0 if rabks >= 1 &	rabks <= 5
	gen num_books_26_100 	= 0 if rabks >= 1 &	rabks <= 5
	gen num_books_m100 		= 0 if rabks >= 1 &	rabks <= 5
		replace num_books_0_10 		= 1 if rabks == 1 
		replace num_books_11_25 	= 1 if rabks == 2
		replace num_books_26_100 	= 1 if rabks == 3
		replace num_books_m100 		= 1 if rabks == 4 |  rabks == 5
	gen missing_num_books = (rabks == . | rabks == .e)
	
	* Upbringing
	foreach group in both_parents mother_only father_only other_upbringing {
		gen `group' 	= 0	if dikliv >= 1 & dikliv <= 95
	}
		replace both_parents 		= 1	if dikliv == 1
		replace mother_only 		= 1	if dikliv == 4
		replace father_only 		= 1	if dikliv == 5
		replace other_upbringing 	= 1	if dikliv == 2 | dikliv == 3 | (dikliv >= 6 & dikliv <= 95)	
	gen missing_upbringing = (dikliv == . | dikliv == .e)
	
	* Caregiver's main occupation
	forvalues i = 1/5 {
		gen caregiver_occup`i' = 0 if difjob >= 1 & difjob <= 15	
	}	
		replace caregiver_occup1 = 1 if difjob == 2 | difjob == 3   | difjob == 4
		replace caregiver_occup2 = 1 if difjob == 5 | difjob == 7   | difjob == 8
		replace caregiver_occup3 = 1 if difjob == 6	
		replace caregiver_occup4 = 1 if difjob == 9 | difjob == 10  | difjob == 12		
		replace caregiver_occup5 = 1 if difjob == 1 | difjob == 11 | (difjob >= 13 & difjob <= 15)
	gen missing_caregiver_occup = (difjob == . | difjob == .e)
	
	/*************************************************************************
	* Numeracy															     *
	*************************************************************************/

	gen numeracy1 = .
		replace numeracy1 = 0 if cfsumb_answer ~= . 
		replace numeracy1 = 0 if cfsumbs96 == 96
		replace numeracy1 = 1 if cfsumb_answer == 150

	gen numeracy2 = .
		replace numeracy2 = 0 if cfsumc_answer ~= . 
		replace numeracy2 = 0 if cfsumcs96 == 96
		replace numeracy2 = 1 if cfsumc_answer == 100
		
	gen numeracy3 = .
		replace numeracy3 = 0 if cfsumd_answer ~= . 
		replace numeracy3 = 0 if cfsumds96 == 96
		replace numeracy3 = 1 if cfsumd_answer == 9000
	
	gen numeracy = (numeracy1 + numeracy2 + numeracy3)/3
	
	gen high_numeracy = .
		replace high_numeracy = 0 if numeracy < 1
		replace high_numeracy = 1 if numeracy == 1
	
	/*************************************************************************
	* Understanding of the experimental task							     *
	*************************************************************************/
	
	local i = 1
	foreach letter in a b c d e {
		gen understanding`i' = 0	if ft001`letter' ~= . & ft001`letter' ~= .e
		local i = `i' + 1
	}

	replace understanding1 = 1	if ft001a == 0
	replace understanding2 = 1	if ft001b == 25
	replace understanding3 = 1	if ft001c == 10
	replace understanding4 = 1	if ft001d == 15
	replace understanding5 = 1	if ft001e == 22

	gen understanding = (understanding1 + understanding2 + understanding3 + understanding4 + understanding5) / 5  

	drop ft001*


	tempfile Sample
	save `Sample'
	
	/*************************************************************************
	* Reshaping long													     *
	*************************************************************************/
	
	keep prim_key experiment_leandro_*_ log_experiment_leandro_*_ payout_heads_*_ payout_tails_*_ //
	drop experiment_leandro_31_ experiment_leandro_32_ payout_*_*_31_ payout_*_*_32_ log_experiment_leandro_31_ log_experiment_leandro_32_ 
	
	ren *_ *

	reshape long experiment_leandro_ log_experiment_leandro_ payout_heads_a_ payout_tails_a_ payout_heads_b_ payout_tails_b_ ///
		payout_heads_c_ payout_tails_c_ payout_heads_d_ payout_tails_d_ payout_heads_e_ payout_tails_e_, i(prim_key) j(budget_order)

	/*************************************************************************
	* Amount invested on each asset											*
	*************************************************************************/
		
	// Investment Choices
	gen invest_a_ = regexs(1) if regexm(experiment_leandro, "(.*)\~(.*)\~(.*)\~(.*)\~(.*)")
	gen invest_b_ = regexs(2) if regexm(experiment_leandro, "(.*)\~(.*)\~(.*)\~(.*)\~(.*)")
	gen invest_c_ = regexs(3) if regexm(experiment_leandro, "(.*)\~(.*)\~(.*)\~(.*)\~(.*)")
	gen invest_d_ = regexs(4) if regexm(experiment_leandro, "(.*)\~(.*)\~(.*)\~(.*)\~(.*)")
	gen invest_e_ = regexs(5) if regexm(experiment_leandro, "(.*)\~(.*)\~(.*)\~(.*)\~(.*)")

	// Destringing amount invested
	foreach letter in a b c d e {
		destring invest_`letter'_, force replace
	}
	
	/*************************************************************************
	* Payout conditional on outcome of coin toss						     *
	*************************************************************************/
	
	gen x = .	// tails
	gen y = .	// heads
		replace x = 	(invest_a_ * payout_tails_a_) + (invest_b_ * payout_tails_b_)	if budget_order <= 10
		replace y = 	(invest_a_ * payout_heads_a_) + (invest_b_ * payout_heads_b_)	if budget_order <= 10 
		replace x = 	(invest_a_ * payout_tails_a_) + (invest_b_ * payout_tails_b_) + (invest_c_ * payout_tails_c_) + ///
						(invest_d_ * payout_tails_d_) + (invest_e_ * payout_tails_e_)	if budget_order >  10
		replace y = 	(invest_a_ * payout_heads_a_) + (invest_b_ * payout_heads_b_) + (invest_c_ * payout_heads_c_) + ///
						(invest_d_ * payout_heads_d_) + (invest_e_ * payout_heads_e_)	if budget_order >  10 
	
	/*************************************************************************
	* Largest possible payout in each state						   			  *
	*************************************************************************/
	
	egen R_tails = rmax(payout_tails_a_ payout_tails_b_ payout_tails_c_ payout_tails_d_ payout_tails_e_)
	gen  x_max = R_tails * 25
	egen R_heads = rmax(payout_heads_a_ payout_heads_b_ payout_heads_c_ payout_heads_d_ payout_heads_e_)
	gen  y_max = R_heads * 25
	
	/*************************************************************************
	* Return and Risk 							 						     *
	*************************************************************************/
	
	preserve
		 
		gen return 	= (x + y) / 2
		gen EX2    	= ((x^2) + (y^2)) / 2
		gen V  		= EX2 - (return^2)
			replace V = 0	if V < 0
		gen risk   = V ^ .5	
		
		replace return = return * 1.5 	// converting from pounds to dollars
		replace risk   = risk * 1.5		// converting from pounds to dollars
						
		keep prim_key budget_order return risk 

		tempfile temp
		save `temp'
	
	restore
	
	preserve 
			
			use `temp', clear
	
			replace return = .		if budget_order == 5 | budget_order == 19 // all portfolios yield the same return
			
			collapse (mean) return (mean) risk, by(prim_key)

			tempfile Risk_and_Return
			sort prim_key
			save `Risk_and_Return'	

	restore
	
	/*************************************************************************
	* Failure to Minimize Risk 											     *
	*************************************************************************/
	
	preserve 
			
			use `temp' if budget_order == 5 | budget_order == 19 , clear
	
			ren risk min_risk
			collapse (mean) min_risk, by(prim_key)
			
			tempfile Minimize_Risk
			sort prim_key
			save `Minimize_Risk'	

	restore		

	/*************************************************************************
	* First Order Stochastic Dominance 									     *
	*************************************************************************/
	
	preserve
	
		gen y_prime = .
		gen x_prime = .
		gen FOSD 	= .
	
		// y/heads has highest return
		// y < x
		replace y_prime = R_heads * (25 - (y/R_tails))		if (R_heads > R_tails & y <  x) 
		replace FOSD 	= (y_prime - x)						if (R_heads > R_tails & y <  x) 

		replace y_prime = R_heads * (25 - (x/R_tails))		if (R_heads > R_tails & y == x)
		replace FOSD 	= (y_prime - y)						if (R_heads > R_tails & y == x) 
				
		// y > x
		replace y_prime = R_heads * (25 - (x/R_tails))		if (R_heads > R_tails & y >  x)
		replace FOSD 	= (y_prime - y) 					if (R_heads > R_tails & y >  x)
		

		// x/tails has highest return
		// x < y
		replace x_prime = R_tails * (25 - (x/R_heads))		if (R_tails > R_heads & x <  y)
		replace FOSD 	= (x_prime - y) 					if (R_tails > R_heads & x <  y)
		
		replace x_prime = R_tails * (25 - (y/R_heads))		if (R_tails > R_heads & x == y)
		replace FOSD 	= (x_prime - x) 					if (R_tails > R_heads & x == y)		
				 
		// x > y
		replace x_prime = R_tails * (25 - (y/R_heads))		if (R_tails > R_heads & x >  y)
		replace FOSD 	= (x_prime - x)						if (R_tails > R_heads & x >  y)


		// heads and tails have same return
		replace FOSD 	= (R_heads * 12.5 * 2) - (x + y)	if (R_heads == R_tails)  
		
		// No potential for violations (b/c all portfolios have the same expected return and there is no dominated asset)
		replace FOSD 	= .									if budget_order == 5 | budget_order == 19  		
		
		
		replace FOSD = FOSD * 1.5	// converting from pounds to dollars
		replace FOSD = 0 if FOSD < 0


		collapse (mean) FOSD, by(prim_key)

		tempfile FOSD
		sort prim_key
		save `FOSD', replace
		
	restore
	
	
	/*************************************************************************
	* GARP Violations				 									     *
	*************************************************************************/

	preserve
	
		sort prim_key budget_order
	
		keep prim_key y x y_max x_max
		order prim_key y x y_max , before(x_max)

		*outsheet using "", replace nonames

	restore

	/*************************************************************************
	* GARP & FOSD Violations				 								*
	*************************************************************************/
	
	preserve
		
		keep prim_key budget_order y x y_max x_max
		expand 2, gen(duplicate)
	
		tab duplicate, mi
	
		clonevar temp_x = x
		clonevar temp_y = y
		clonevar temp_x_max = x_max
		clonevar temp_y_max = y_max	
	
			replace temp_x = y 			if duplicate == 1
			replace temp_y = x 			if duplicate == 1
			replace temp_x_max = y_max	if duplicate == 1
			replace temp_y_max = x_max 	if duplicate == 1
	
		drop x y x_max y_max duplicate
	
		ren temp_x x
		ren temp_y y
		ren temp_y_max y_max
		ren temp_x_max x_max
	
	
		sort prim_key budget_order
		drop budget_order
	
	
		order prim_key y x y_max , before(x_max)
		*outsheet using "", replace nonames

	restore
	
	/*************************************************************************
	* Financial competence											     	*
	*************************************************************************/
	
	preserve
	
		keep if budget_order == 1 | budget_order == 2 | budget_order == 8 | budget_order == 10 | budget_order == 11 | budget_order == 15 | budget_order == 18 | budget_order == 25 		
	
		gen invested_tails = x/R_tails
		gen invested_heads = y/R_heads
		
		gen amount = . // amount invested in the higher-paying state of the world
			replace amount = invested_tails	if x_max >  y_max
			replace amount = invested_heads	if x_max <= y_max	
	
		keep amount prim_key budget_order
	
		reshape wide amount, i(prim_key) j(budget_order)
		
		gen FC1 = abs(amount18 - amount2)
		gen FC2 = abs(amount15 - amount1)
		gen FC3 = abs(amount11 - amount10)
		gen FC4 = abs(amount25 - amount8)

		egen fin_comp = rmean(FC1 FC2 FC3 FC4)
			replace fin_comp = fin_comp * 1.5 // coverting from pounds to dollars
		keep prim_key fin_comp

		tempfile Financial_Competence
		sort prim_key
		save `Financial_Competence'	
			
	restore

	/*************************************************************************
	* Small-scale risk aversion											     *
	*************************************************************************/
	
	preserve

		gen risk_aversion = .
			replace risk_aversion = y * 1.5	if x_max > y_max	
			replace risk_aversion = x * 1.5	if x_max < y_max	

		collapse (mean) risk_aversion, by(prim_key)
			
		
		tempfile Risk_Aversion
		sort prim_key
		save `Risk_Aversion'	
			
	restore
	
	/*************************************************************************
	* 1/n heuristic														     *
	*************************************************************************/
		
	preserve
	
		gen heuristic_1_n = 0
			replace heuristic_1_n = 1	if invest_a_ == 12.5 & invest_b_ == 12.5  & budget_order <=  10
			replace heuristic_1_n = 1	if invest_a_ == 5    & invest_b_ == 5     & budget_order >   10 & invest_c_ == 5 & invest_d_ == 5 & invest_e_ == 5	

		replace heuristic_1_n = . if budget_order == 5 | budget_order == 19 // in these cases, the 1/n heuristic minimizes the risk

		collapse (mean) heuristic_1_n, by(prim_key)
		
		tempfile Heuristic_1_n
		sort prim_key
		save `Heuristic_1_n'	
	
	restore
	
	/*************************************************************************
	* Default Stickiness												     *
	*************************************************************************/
	
	preserve
	
		gen str temp = ""
			replace temp = regexs(6) if regexm(log_experiment_leandro_, "!~!([0-9]+\.[0-9][0-9])\~([0-9]+\.[0-9][0-9])\~([0-9]+\.[0-9][0-9])\~([0-9]+\.[0-9][0-9])\~([0-9]+\.[0-9][0-9])\!~!(.*)") 	& budget_order >  10
			replace temp = regexs(6) if regexm(log_experiment_leandro_, "!~!([0-9]+\.[0-9][0-9])\~([0-9]+\.[0-9][0-9])\~([A-Z][a-z][A-Z])\~([A-Z][a-z][A-Z])\~([A-Z][a-z][A-Z])\!~!(.*)") 			& budget_order <= 10

		gen default_stickiness = (temp == "")
	
	
		collapse (mean) default_stickiness, by(prim_key)
	
		tempfile Default_Stickiness
		sort prim_key 
		save `Default_Stickiness'	
		
	restore
	
	/*************************************************************************
	* Merging datasets													     *
	*************************************************************************/
	
	use `Sample', clear
	
	merge 1:1 prim_key using `Risk_and_Return', nogenerate
	merge 1:1 prim_key using `FOSD', nogenerate
	merge 1:1 prim_key using "$directory/GARP & FOSD.dta", nogenerate
	merge 1:1 prim_key using `Minimize_Risk', nogenerate
	merge 1:1 prim_key using `Financial_Competence', nogenerate
	merge 1:1 prim_key using `Default_Stickiness', nogenerate
	merge 1:1 prim_key using `Heuristic_1_n', nogenerate
	merge 1:1 prim_key using `Risk_Aversion', nogenerate
	merge 1:1 prim_key using "$directory/Time.dta", nogenerate

	/*************************************************************************
	* Log of Time											     			*
	*************************************************************************/
	
	gen lntime = ln(time)	
	
	/*************************************************************************
	* Decision-making quality index											*
	*************************************************************************/
	
	egen DMQ_idx = rmean(GARP FOSD fin_comp min_risk)

	/*************************************************************************
	* Standardizing outcome variables									  	*
	*************************************************************************/
	
	foreach depvar in return risk GARP FOSD GARP_FOSD fin_comp min_risk risk_aversion { // heuristic_1_n default_stickiness 
	
		qui summ `depvar' if post == 0
		gen `depvar'_sd = (`depvar' - r(mean)) / r(sd)
								
	}
	
	egen DMQ_idx_sd = rmean(GARP_sd FOSD_sd fin_comp_sd min_risk_sd) 	
			
	/*****************************************************************************
	* Change signs such that a value closer to 0 corresponds to a smaller loss   *
	*****************************************************************************/
	
	foreach depvar in GARP FOSD GARP_FOSD fin_comp min_risk DMQ_idx {
		replace `depvar' = -`depvar'
	}


	foreach depvar in GARP FOSD GARP_FOSD fin_comp min_risk DMQ_idx {
		replace `depvar'_sd = -`depvar'_sd
	}

	/*************************************************************************
	* Keep variables used in the paper									     *
	*************************************************************************/
	
	keep prim_key bmonth DoB-DMQ_idx_sd

	/*************************************************************************
	* Order of variables												     *
	*************************************************************************/
	
	order return-DMQ_idx_sd, after(edu16)
	order time lntime, before(numeracy1)
	
	/*************************************************************************
	* Month-of-birth fixed effects										     *
	*************************************************************************/
	
	gen Jan = bmonth == 1 
	gen Feb = bmonth == 2
	gen Mar = bmonth == 3
	gen Apr = bmonth == 4
	gen May = bmonth == 5
	gen Jun = bmonth == 6
	gen Jul = bmonth == 7
 	gen Sep = bmonth == 9
	gen Oct = bmonth == 10
	gen Nov = bmonth == 11
	gen Dec = bmonth == 12
	drop bmonth	
		
	/*************************************************************************
	* Labels															     *
	*************************************************************************/
	
	* Labels for income missing
	label variable prim_key 				"ID"
	label variable DoB 						"Calendar date of birth"
	label variable R_days 					"Running variable - DoB in days"
	label variable post						"1 if born after Sep 1 1957"
	label variable post_R_days				"post * R_days"
	label variable R_quarters				"Running variable - DoB in quarters"
	label variable R_months					"Running variable - DoB in months"
	
	label variable edu16					"1 if stayed in school until 16"
	label variable edu16_alternative		"Asked in older survey"
	
	label variable no_educ 					"No formal qualification"	
	label variable qualification 			"1 if has any qualification"	
	label variable low_level_educ 			"Lower level vocational"
	label variable CSE 						"CSE"
	label variable Olevel 					"GCSE, O level, etc."
	label variable high_level_vocational 	"High level vocational (A level equivalent)"
	label variable A_level 					"A level"
	
	label variable high_income				"1 if hhld income >= £25,000"
	label variable prsnl_income				"Personal annual income"
	label variable hhld_income				"Household annual income"
	label variable owner 					"1 if Owns house"	
	
	label variable return 					"Expected value of portfolio"
	label variable risk 					"Standard deviation of portfolio"	
	label variable min_risk 				"Risk when all portfolios have same return"	
	label variable GARP  					"Money pump index - GARP"
	label variable GARP_FOSD 				"Money pump index - GARP & FOSD"
	label variable FOSD 					"FOSD"	
	label variable fin_comp 				"Financial competence"
	label variable risk_aversion	 		"Risk aversion"
	label variable default_stickiness		"1 if remains at default"
	label variable heuristic_1_n 			"1 if used 1/n heuristic"
	label variable DMQ_idx 					"Decision-making quality index"	
	
	label variable return_sd 				"Expected value - standardized"
	label variable risk_sd 					"Portfolio risk - standardized"
	label variable GARP_sd   				"GARP - standardized"
	label variable FOSD_sd 					"FOSD - standardized"	
	label variable GARP_FOSD_sd 			"GARP & FOSD - standardized"
	label variable fin_comp_sd 				"Financial competence - standardized"	
	label variable min_risk_sd 				"Minimize risk - standardized"	
	label variable risk_aversion_sd 		"Risk aversion - standardized"
	label variable DMQ_idx_sd 				"DMQ index - standardized"	
	
	label variable male  					"1 if male"
	label variable white 					"1 if white British"
	label variable missing_white 			"Missing ethnicity"		
	label variable num_bedrooms 			"# bedrooms when 10 years old"
	label variable missing_num_bedrooms	 	"Missing # of bedrooms"	
	label variable hhld_size 				"# hhld members when 10 years old" 
	label variable missing_hhld_size 		"Missing household size"	
	label variable num_books_0_10	 		"None or very few (0-10 books)"	
	label variable num_books_11_25 			"Enough to fill 1 shelf (11-25 books)"
	label variable num_books_26_100 		"Enough to fill 1 bookcase (26-100 books)"
	label variable num_books_m100			"Enough to fill 2 or more bookcases (more than 100 books)" 	
	label variable missing_num_books 		"Missing # of books"	
	label variable parents_unempl			"Parents unemployed more than 6 months"	
	label variable missing_parents_unempl 	"Missing if parents unemployed"	
	label variable both_parents 			"Lived most of childhood w/ both parents"
	label variable mother_only 				"Lived most of childhood w/ mother only"
	label variable father_only 				"Lived most of childhood w/ father only"
	label variable other_upbringing			"Lived most of childhood - other"
	label variable missing_upbringing 		"Missing upbringing"		
	label variable caregiver_occup1 		"Caregiver occup - Manager, run own business, professional, technical"
	label variable caregiver_occup2 		"Caregiver occup - Admin, clerical, secretarial, caring, personal services, sales, customer service"
	label variable caregiver_occup3 		"Caregiver occup - Skilled trade"
	label variable caregiver_occup4 		"Caregiver occup - Machine operator, other jobs, casual jobs"
	label variable caregiver_occup5 		"Caregiver occup - Other"
	label variable missing_caregiver_occup 	"Missing caregiver occupation"	

	label variable numeracy1 				"£300 sofa at half price"
	label variable numeracy2 				"# sick people out 1,000 if 10% chance of disease"
	label variable numeracy3 				"£6,000 used car selling at 2/3 price of new car"	
	label variable numeracy 				"Fraction correct answers numeracy test"	
	label variable high_numeracy 			"1 if correctly answered all 3 numeracy Qs"	
				
	label variable understanding 			"Overall understanding of experimental task"
	label variable understanding1 			"Understanding - payouts"
	label variable understanding2 			"Understanding - endowment"
	label variable understanding3 			"Understanding - amount invested"
	label variable understanding4 			"Understanding - return of a single asset"
	label variable understanding5 			"Understanding - return of entire portfolio"
	
	label variable Jan						"1 if born in January"
	label variable Feb						"1 if born in February"
	label variable Mar						"1 if born in March"
	label variable Apr						"1 if born in April"
	label variable May						"1 if born in May"
	label variable Jun						"1 if born in June"
	label variable Jul						"1 if born in July"
	label variable Sep						"1 if born in September"
	label variable Oct						"1 if born in October"
	label variable Nov						"1 if born in November"
	label variable Dec						"1 if born in December"	
	
	label variable lntime 					"Log of time"

	
	save "CleanData", replace
