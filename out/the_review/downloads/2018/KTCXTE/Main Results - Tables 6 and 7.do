****************************************************************************************************************
**																											  **
** This do file is part of the replication material for the following article: 								  **
** "On the Limits on Officials’ Ability to Change Citizens’ Priorities: A Field Experiment in Local Politics" **
** 		Authors: Daniel M. Butler and Hans Hassell															  **
** 		Journal: American Political Science Review															  **
**																											  **
** This file replicates the following things from the article: 												  **
**		Table 6																								  **
**		Table 7																								  **																							  **																						 
**		Table SI.3																							  **
**		Information for the Power Tests																		  **																						  **
**																											  **
****************************************************************************************************************

clear
set more off

** Change directory to where the datasets are stored
	* cd "~/Dropbox/Butler-Hassell/Priorities Project/Archive/"
	cd "~/Dropbox/Coauthors/Butler-Hassell/Priorities Project/Archive/"
	* cd "C:\Users\Hans\Dropbox\Butler-Hassell\Priorities Project\Archive"
	
** Call up the dataset
	use "Leadership-AnalysisData.dta", clear

*******************************
** Individual Level Analysis **
*******************************

	** Create Behavioral Outcome = Visit Petition Page
	egen dv_behavioral=rowtotal(pt_iss1_post pt_iss2_post pt_iss3_post pt_iss4_post pt_iss5_post pt_iss6_post pt_iss7_post)

*****************************
** Table 7: Visit Petition **
*****************************
	** Column 1
	xi: probit dv_behavioral trletter if  mchimp_open==1 & survey_pre!=1
		**Bottom of Table 7
		tab  trletter  dv_behavioral if e(sample)==1, row
		
	** Column 2
	xi: probit dv_behavioral trletter lowprioritysample if  mchimp_open==1 & survey_pre!=1

	** Preparing Data for Imputing Missing Data (Column 3)
		sum female if in_postsample==1
	gen femaleimpute= female==.
	replace female=.4650206 if female==.
		sum age if in_postsample==1
	gen ageimpute= age==.
	replace age=4.644351 if age==.
		sum educ if in_postsample==1
	gen educimpute= educ==.
	replace educ=4.504098 if educ==.
		sum polit_int if in_postsample==1
	gen polit_intimpute= polit_int==.
	replace polit_int=1.647541 if polit_int==.
		sum localfocus if in_postsample==1
	gen localfocusimpute= localfocus==.
	replace localfocus=2.348361 if localfocus==.
	
	gen missing=0
	replace missing=1 if ageimpute==1 | femaleimpute==1
	
	** Column 3
	xi: probit dv_behavioral trletter lowprioritysample female age educ polit_int localfocus missing if mchimp_open==1 & survey_pre!=1
	
	
********************************
** Information for Power Test **
********************************	
	xi: probit dv_behavioral trletter if  mchimp_open==1 & survey_pre!=1
		summ dv_behavioral if trletter==0 & e(sample)==1
		summ  trletter if  e(sample)==1
		tab  trletter  dv_behavioral if e(sample)==1, row
	
********************************************************
** Table SI.2: Accounting for Timing on Petition Page **
********************************************************
	gen dv_time = dv_behavioral
		replace dv_time = 0 if ti_linkpetition_post_3<20
	xi: probit dv_time trletter lowprioritysample  if  mchimp_open==1 & survey_pre!=1
	

********************************************************
** Table SI.3, Col 2: Issue Priorities 1 Email Sample **
********************************************************	
	xi: probit dv_behavioral trletter lowprioritysample if  mchimp_open==1 & survey_pre!=1 & emailedreminder!=1

*************************************
** Prep Data: Issue Level Analysis **
*************************************

	** Prep Data: Expand dataset to 1 observation per issue 
	forvalues var=1/7{
		rename issue`var'_post issuepost`var'
		}
	gen voterid=_n
	reshape long issuepost medpriority lowpriority issue salience , i(voterid) j(issueid)

	** Only keep the observations that were eligible for treatment
	keep if lowpriority==1 | medpriority==1 & lowprioritysample==0
	
	** Generate an issue specific treatment variable
	gen tr_issueletter=0
		replace tr_issueletter=1 if trletter==1 & issueid==trissue	
		
	** Create Strata based on randomization scheme (this is the number of issues on which they were eligbile for treatment)
		gen strata=totallow
			replace strata=totalmed if strata==0
		
*******************************
** Table 6: Issue Priorities **
*******************************
	** Column 1
	xi: oprobit issuepost tr_issueletter  i.strata  if mchimp_open==1 & survey_pre!=1, cl(voterid)
	
	** Column 2
	xi: oprobit issuepost tr_issueletter lowprioritysample i.strata  if mchimp_open==1 & survey_pre!=1, cl(voterid)
	
	** Column 3
	xi: oprobit issuepost tr_issueletter lowprioritysample female age educ  polit_int localfocus missing i.strata  if mchimp_open==1 & survey_pre!=1, cl(voterid)

	**********************************
	** Results at bottom of Table 6 **
	**********************************
	
	** Prep-work
	gen in_sample=1 if e(sample)==1
	egen samplesize=total(in_sample)
	keep if in_sample==1
	** IPW calculations for Percent in Outcomes
	xi: logit tr_issueletter i.strata if in_sample==1
		predict prob_treatment
	* gen prob_treatment=.5*(1/strata)
	gen inverse_prob= (1/prob_treatment)*tr_issueletter + (1/(1-prob_treatment))*(1-tr_issueletter)
	gen chose_against=issuepost==1
	gen chose_low=issuepost==2
	gen chose_med=issuepost==3
	gen chose_high=issuepost==4
	
	
	** Create Inverse Probability Weights
	** IPW calculation for treatment group
	gen outcome_against_tr=chose_against*inverse_prob*tr_issueletter*in_sample
		egen sum_against_tr=total(outcome_against_tr)
			gen perc_against_tr=sum_against_tr/samplesize
	gen outcome_low_tr=chose_low*inverse_prob*tr_issueletter*in_sample
		egen sum_low_tr=total(outcome_low_tr)
			gen perc_low_tr=sum_low_tr/samplesize	
	gen outcome_med_tr=chose_med*inverse_prob*tr_issueletter*in_sample
		egen sum_med_tr=total(outcome_med_tr)
			gen perc_med_tr=sum_med_tr/samplesize
	gen outcome_high_tr=chose_high*inverse_prob*tr_issueletter*in_sample
		egen sum_high_tr=total(outcome_high_tr)
			gen perc_high_tr=sum_high_tr/samplesize
	** IPW calculation for placebo group
	gen outcome_against_con=chose_against*inverse_prob*(1-tr_issueletter)*in_sample
		egen sum_against_con=total(outcome_against_con)
			gen perc_against_con=sum_against_con/samplesize
	gen outcome_low_con=chose_low*inverse_prob*(1-tr_issueletter)*in_sample
		egen sum_low_con=total(outcome_low_con)
			gen perc_low_con=sum_low_con/samplesize	
	gen outcome_med_con=chose_med*inverse_prob*(1-tr_issueletter)*in_sample
		egen sum_med_con=total(outcome_med_con)
			gen perc_med_con=sum_med_con/samplesize
	gen outcome_high_con=chose_high*inverse_prob*(1-tr_issueletter)*in_sample
		egen sum_high_con=total(outcome_high_con)
			gen perc_high_con=sum_high_con/samplesize
	** Final Calucations for bottom of Table 6
	summ perc_against_tr perc_low_tr perc_med_tr perc_high_tr perc_against_con perc_low_con perc_med_con perc_high_con
	
********************************************************
** Table SI.3, Col 1: Issue Priorities 1 Email Sample **
********************************************************
	xi: oprobit issuepost tr_issueletter lowprioritysample i.strata  if mchimp_open==1 & survey_pre!=1 & emailedreminder!=1, cl(voterid)

********************************
** Information for Power Test **
********************************
	xi: reg issuepost tr_issueletter  i.strata  if mchimp_open==1 & survey_pre!=1, cl(voterid)
		summ issuepost if tr_issueletter==0 & in_sample==1
		* Gives mean and sd for input for simulation
		summ  tr_issueletter if in_sample==1
		* Proportion treated = .3
		tab strata if in_sample==1
