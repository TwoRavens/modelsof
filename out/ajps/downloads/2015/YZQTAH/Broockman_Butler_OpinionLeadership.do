*****************************************************
**  PROJECT:  "The Causal Effects of Elite Position-Taking on Voter Attitudes: Field Experiments with Elite Communication", American Journal of Political Science
**  AUTHORS: David Broockman, Daniel M. Butler
**  DESCRIPTION: Stata code (Do File) to replicate figures and tables in paper and the appendices
**  DATE: 21 October 2015
*****************************************************

** NON-DEFAULT PACKAGES:*****
** - metan ("ssc install metan")
** - outreg2 ("ssc install outreg2")
******************************


******************************************************
**************  Study 1 - Spring 2013   **************
******************************************************

	clear
	set more off

*Call up the Dataset
	use Study1_data.dta

	
*****************************************************
**************         Study 1         **************
**************Legislator Affect Results**************
*****************************************************
	
*Prepare the Data / Code Variables

	**Add identifiers for questions asked in pre-survey
	forvalues qp = 1/7{
		rename q`qp' q`qp'_pre
	}

	*Coding Issue Opinions in Pre-Survey.  Coding: 1 = agree with Legislator A, 0 = don't know, -1 = disagree with Legislator A
	foreach issue in vouchers incometax propertytax frack{
		gen `issue'_pre = .
		replace `issue'_pre = 1 if agree_`issue' == 1
		replace `issue'_pre = 0 if indifferent_`issue' == 1
		replace `issue'_pre = -1 if disagree_`issue' == 1
		drop agree_`issue' indifferent_`issue' disagree_`issue'
	}

	*Coding Issue Opinions in Post-Survey.  Coding: 1 = agree with Legislator A, 0 = don't know, -1 = disagree with Legislator A
	gen vouchers_post = 1 if q4_post == "2"
		replace vouchers_post = -1 if q4_post == "1"
		replace vouchers_post = 0 if q4_post == "3" | q4_post == "4"
	gen incometax_post = 1 if q5_post == "2"
		replace incometax_post = -1 if q5_post == "1"
		replace incometax_post = 0 if q5_post == "3" | q5_post == "4"
	gen propertytax_post = 1 if q6_post == "1"
		replace propertytax_post = -1 if q6_post == "2"
		replace propertytax_post = 0 if q6_post == "3" | q6_post == "4"
	gen frack_post = 1 if q7_post == "1"
		replace frack_post = -1 if q7_post == "2"
		replace frack_post = 0 if q7_post == "3" | q7_post == "4"
	
	*Attitude towards Obama on Pre-Survey
	encode fdisp, gen(temp)
		gen obama_positivePRE=1 if temp==1
			replace obama_positivePRE=0 if temp==3
			replace obama_positivePRE=-1 if temp==2	

	*Affect for Legislator in Post-survey
	*Strongly positive
	gen LegA_attitude_post = 2 if q2_post == "1"
	*Weakly positive
	replace LegA_attitude_post = 1 if q2_post == "2"
	*Weakly negative
	replace LegA_attitude_post = -1 if q3_post == "2"
	*Strongly negative
	replace LegA_attitude_post = -2 if q3_post == "1"
	*Don't know LegA
	replace LegA_attitude_post = 0 if q1_post == "3" | q1_post == "4"
	
	*Affect for Legislator in Pre-survey
	*Strongly positive
	gen LegA_attitude_pre = 2 if q2_pre == "Strongly positive"
	*Weakly positive
	replace LegA_attitude_pre = 1 if q2_pre == "Not to strongly"
	*Weakly negative
	replace LegA_attitude_pre = -1 if q3_pre == "Not so strongly"
	*Strongly negative
	replace LegA_attitude_pre = -2 if q3_pre == "Strongly negative"
	*Don't know LegA
	replace LegA_attitude_pre = 0 if q1_pre == "Have not heard" | q1_pre == "Undecided/don't know"
	label var LegA_attitude_pre "Prior Approval of Legislator"

	*Rescale Affect Dependent Variable so that it ranges from 0-1
	gen LegA_attitude_post01scale = (LegA_attitude_post+2)/4 

	*Dichotomize Affect for Legislator
	*In Post-Survey
	gen disapprove_LegA_post_binary = LegA_attitude_post <= -1
		replace disapprove_LegA_post_binary =. if LegA_attitude_post == .
	gen approve_LegA_post_binary = LegA_attitude_post >= 1
		replace approve_LegA_post_binary =. if LegA_attitude_post == .
	*In Pre-Survey
	gen disapprove_LegA_pre_binary= LegA_attitude_pre <= -1
		replace disapprove_LegA_pre_binary =. if LegA_attitude_pre == .
		label var disapprove_LegA_pre_binary "Prior Approval of Legislator"
	
	*Create Manipulation check variables
	gen mc_mail_recall = 1 if q8_post == "1"
		replace mc_mail_recall = 0 if q8_post == "2" | q8_post == "3"
		label var mc_mail_recall "Recall Receiving Letter"

	*Label Main Treatment Variable
	label var policy_letter_treat "Sent Policy Letter" 

		
*ANALYSIS, Study 1, Affect Results

	** TABLE 4
	reg LegA_attitude_post01scale policy_letter_treat LegA_attitude_pre if disagree_total>=2 | (disagree_total==1 & movable_total==1)
		outreg2 using Study1_LegAffect_Disagreers, dec(3) label word ctitle(Approve) replace
	reg approve_LegA_post_binary policy_letter_treat LegA_attitude_pre if disagree_total>=2 | (disagree_total==1 & movable_total==1)
		outreg2 using Study1_LegAffect_Disagreers, dec(3) label word ctitle(Approve) append
	reg disapprove_LegA_post_binary policy_letter_treat LegA_attitude_pre if disagree_total>=2 | (disagree_total==1 & movable_total==1)
		outreg2 using Study1_LegAffect_Disagreers, dec(3) label word ctitle(Dispprove) append
	* Note: because of the way the random assignment was done, the if condition limits the sample to those who,
	* if they were in the treatment group, received an issue position they disagreed with

		
	**Study 1 Appendix Results
	** TABLE A1, COLUMN 1 (Study 1), Manipulation check: Recall Receiving Letter
	reg mc_mail_recall policy_letter_treat

	** TABLE A2, COLUMNS 1-3, Balance and Attrition Tests, Study 1
	gen completed_post = q1_post != ""
	reg LegA_attitude_pre policy_letter_treat if completed_post==1
		outreg2 using Study1_balance,  dec(3) label word ctitle(Approval)  replace
	reg obama_positivePRE policy_letter_treat if completed_post==1
		outreg2 using Study1_balance,  dec(3) label word ctitle(Obama Affect)  append
	reg disagree_total policy_letter_treat if completed_post==1
		outreg2 using Study1_balance,  dec(3) label word ctitle(Issue Disaggreement)  append
	
	** TABLE A4, COLUMN 1 (Study 1)
	*Coding Variables for the analysis
		gen obamaneutral= obama_positivePRE==0
		gen obamanegative=obama_positivePRE==-1
		gen no_opinion_of_legislator= LegA_attitude_pre==0
		gen neg_opinion_of_legislator=LegA_attitude_pre<0
		gen female=0 if voterbase_gender=="Male"
			replace female=1 if voterbase_gender=="Female"
		gen issue_engagement=abs(vouchers_pre) + abs(incometax_pre) +abs(propertytax_pre) + abs(frack_pre) 
	*Regression Results for Column 1 of Table A4
	reg completed_post obamaneutral obamanegative no_opinion_of_legislator neg_opinion_of_legislator voterbase_age female issue_engagement
		outreg2 using Completed_2Surveys_Study1, dec(3) label word title("Who finished the 2nd Survey?") se replace

	** TABLE A6, COLUMNS 1-3, Legislator Affect, No LDV
	reg LegA_attitude_post01scale policy_letter_treat if disagree_total>=2 | (disagree_total==1 & movable_total==1)
		outreg2 using Study1_LegAffect_Appendix, dec(3) label word ctitle(Approve) replace
	reg approve_LegA_post_binary policy_letter_treat if disagree_total>=2 | (disagree_total==1 & movable_total==1)
		outreg2 using Study1_LegAffect_Appendix, dec(3) label word ctitle(Approve) append
	reg disapprove_LegA_post_binary policy_letter_treat if disagree_total>=2 | (disagree_total==1 & movable_total==1)
		outreg2 using Study1_LegAffect_Appendix, dec(3) label word ctitle(Dispprove) append
		
	** TABLE A10, Study 1, Affect, Heterogeneous Treatment Effects
	** Prepare Moderators
		gen oblike = obama_positivePRE==1
			label var oblike "Like Obama (Pre-Treatment)"
		gen obindiff = obama_positivePRE==0
			label var obindiff "Indifferent/No opinion on Obama (Pre-Treatment)"
		gen oblike_letter=oblike*policy_letter_treat
			label var oblike_letter "Like Obama*Policy Letter"
		gen obindiff_letter=obindiff*policy_letter_treat
			label var obindiff_letter "Indifferent/No opinion*Policy Letter"
	* Regression Results for Table A10
		reg approve_LegA_post_binary policy_letter_treat oblike_let obindiff_let oblike obindiff if disagree_total>=2 |  disagree_total==1 & movable_total==1 
			outreg2 using Study1_LegAffect_Heterogenous, dec(3) label word title("Effect of Letter Treatment on Favorability") se replace
		reg disapprove_LegA_post_binary policy_letter_treat oblike_let obindiff_let oblike obindiff  if disagree_total>=2 |  disagree_total==1 & movable_total==1 
			outreg2 using Study1_LegAffect_Heterogenous, dec(3) label word  se append
		*Drop these variables - We recreate them for the Opinion Leadreship analysis below.
		drop oblike_ obindiff_ 
		
******************************************************
**************         Study 1          **************
**************Opinion Leadership Results**************
******************************************************

*Prepare Data for Analysis
	
	*Create issue-specific variables
	foreach issue in vouchers incometax propertytax frack{
	gen treat_letter_`issue' = 0 if movable_`issue' == 1
	replace treat_letter_`issue' = 1 if issue_1_name == "`issue'" & policy_letter_treat == 1
	replace treat_letter_`issue' = 1 if issue_2_name == "`issue'" & policy_letter_treat == 1
	replace treat_letter_`issue' = . if movable_`issue' == 0
	}

	*Create Individual-Issue observations.  We create 4 observations per-respondent because they were asked about 4 issues in the pre-survey 
	expand 4
	sort serial
	gen issue_num = mod(_n,4)

	*Note that these issue number was an arbitrary decision
	gen issue_name = "frack" if issue_num == 0
	replace issue_name = "vouchers" if issue_num == 1
	replace issue_name = "incometax" if issue_num == 2
	replace issue_name = "propertytax" if issue_num == 3
	drop issue_num

	*Create variables associated with each individual-issue observation.
	gen movable_this_issue = .
	gen treat_letter_this_issue = .
	gen issue_post = .
	gen issue_pre = .

	*Recode the Treatment and pre-opinion variables for each Individual-Issue observation
	foreach issue in vouchers incometax propertytax frack{
	replace movable_this_issue = movable_`issue' if issue_name == `"`issue'"'
	replace treat_letter_this_issue = treat_letter_`issue' if issue_name == `"`issue'"'
	replace issue_post = `issue'_post if issue_name == `"`issue'"'
	replace issue_pre = `issue'_pre if issue_name == `"`issue'"'
		}

	*Dichotomize issue pre opinion
	gen issue_agree_pre_binary = issue_pre == 1
		replace issue_agree_pre_binary = . if issue_pre == .
	gen issue_disagree_pre_binary = issue_pre == -1
		replace issue_disagree_pre_binary = . if issue_pre == .

	*Dichotomize issue post opinion		
	gen issue_agree_post_binary = issue_post == 1
		replace issue_agree_post_binary = . if issue_post == .
	gen issue_disagree_post_binary = issue_post == -1
		replace issue_disagree_post_binary = . if issue_post == .

	*Rescale Opinion Agreement Dependent Variable so that it ranges from 0-1
	gen issue_post_01scale = (issue_post+1)/2
		
	*Label key variables to be used in the regression
	label var treat_letter_this_issue "Sent Policy Letter on this Issue"
	label var issue_disagree_pre_binary "Lagged Opinion: Disagreed with Legislator (vs. No Opinion)"


	*CREATE STRATA INDICATORS -- Fixed Effects are included in regressions to account for how the randomization was performed - see text for description.
	gen strata = ""
	*If >=2 disagree issues, randomized among disagree issues with no opportunity for indifferent issues
	replace strata = "disagree_on_" + string(disagree_total) + "_including_this_issue" if disagree_total >= 2 & issue_pre == -1
	replace treat_letter_this_issue = .  if disagree_total >= 2 & issue_pre == 0
	*If 1 disagree issue, randomized among remaining indifferent issues
	replace strata = "disagree_on_1_indiff_on_" + string(indifferent_total) if disagree_total == 1
	replace strata = strata + "_this_issue_indifferent" if issue_pre == 0 & disagree_total == 1
	replace strata = strata + "_this_issue_disagree" if issue_pre == -1 & disagree_total == 1
	*If 0 disagree issues, randomized among all indifferent issues
	replace strata = "disagree_on_0_indifferent_on_" + string(indifferent_total) if disagree_total == 0
	replace treat_letter_this_issue = . if issue_pre == 1 | issue_pre == .
	replace strata = "INELIGIBLE: AGREED_ON_THIS_ISSUE" if issue_pre == 1
	replace strata = "INELIGIBLE: DID NOT GIVE OPINION THIS ISSUE" if issue_pre == .

*ANALYSIS, Study 1, Opinion Leadership
	** TABLE 3 - Study 1, Opinion Leadership
	xi: reg issue_post_01scale treat_letter_this_issue issue_disagree_pre_binary i.strata, cl(serial)
		outreg2 using Study1_opinion_OLS, dec(3) label word ctitle(issuescale01) replace
	xi: reg issue_agree_post_binary treat_letter_this_issue issue_disagree_pre_binary i.strata, cl(serial)
		outreg2 using Study1_opinion_OLS, dec(3) label word ctitle(Agree) append
	xi: reg issue_disagree_post_binary treat_letter_this_issue issue_disagree_pre_binary i.strata, cl(serial)
		outreg2 using Study1_opinion_OLS, dec(3) label word ctitle(Disagree) append

	** Appendix Results for Opinion Leadership in Study 1
	**TABLE A5 - Study 1, Opinion Leadership, no LDV
	xi: reg issue_post_01scale treat_letter_this_issue i.strata, cl(serial)
		outreg2 using Study1_opinion_OLS_binary, dec(3) label word ctitle(Agree) replace
	xi: reg issue_agree_post_binary treat_letter_this_issue i.strata, cl(serial)
		outreg2 using Study1_opinion_OLS_binary, dec(3) label word ctitle(Agree) append
	xi: reg issue_disagree_post_binary treat_letter_this_issue i.strata, cl(serial)
		outreg2 using Study1_opinion_OLS_binary, dec(3) label word ctitle(Disagree) append
	
	** TABLE A9 - Heterogeneous Effects, Study 1, Opinion Leadership
	** Prepare Moderators
		gen oblike_letter=oblike*treat_letter_this_issue
			label var oblike_letter "Like Obama*Policy Letter"
		gen obindiff_letter=obindiff*treat_letter_this_issue
			label var obindiff_letter "Indifferent/No opinion*Policy Letter"
		gen disagree_letter=issue_disagree_pre_binary*treat_letter_this_issue	
			label var disagree_letter "Disagree*Policy Letter"
	*Regression Results	
	xi: reg issue_agree_post_binary treat_letter_this_issue oblike_let obindiff_let oblike  obindiff   i.strata, cl(serial)
		outreg2 using Study1_heterogenous, dec(3) label word ctitle(Agree) replace
	xi: reg issue_disagree_post_binary treat_letter_this_issue oblike_let obindiff_let oblike  obindiff   i.strata, cl(serial)
		outreg2 using Study1_heterogenous, dec(3) label word ctitle(Disgree) append
	xi: reg issue_agree_post_binary treat_letter_this_issue disagree_letter issue_disagree_pre_binary i.strata, cl(serial)
		outreg2 using Study1_heterogenous, dec(3) label word ctitle(Agree) append
	xi: reg issue_disagree_post_binary treat_letter_this_issue disagree_letter issue_disagree_pre_binary  i.strata, cl(serial)
		outreg2 using Study1_heterogenous, dec(3) label word ctitle(Disagree) append



		
		
		
		

******************************************************
**************  Study 2 - Summer 2014   **************
******************************************************

*Call up dataset for Study 2
	use Study2_data.dta, clear
	set more off

*****************************************************
**************         Study 2         **************
**************Legislator Affect Results**************
*****************************************************
	
*Prepare the Data / Code Variables

	*Legislator approve/disapprove binary
	gen leg_approve_POST_binary = legislator_positivePOST > 0
		replace leg_approve_POST_binary = . if legislator_positivePOST == .
	gen leg_disapprove_POST_binary = legislator_positivePOST < 0
		replace leg_disapprove_POST_binary = . if legislator_positivePOST == .

	*Code and Label Treatment Variables
	gen treat_argument = 0
		replace treat_argument = 1 if lettertreatment=="argument"
		label var treat_argument "Extensive Justification"
	gen treat_direct = 0
		replace treat_direct = 1 if lettertreatment=="direct"
		label var treat_direct "Basic Justification"
	
	*Redefine treatment as receiving a disagreement letter
	gen treat_disagree = 0 if disagreePRE_num_issues >= 1
		forvalues var=1/4{
		*Note: For Placebo group, issuetreatmentnumber==. so treat_disagree=0
		replace treat_disagree = 1 if issuetreatmentnumber == `var' & issue`var'pre == -1
		}

	gen treat_disagree_direct = 0 if treat_disagree != .
		replace treat_disagree_direct = 1 if treat_disagree == 1 & lettertreatment == "direct"
	gen treat_disagree_argument = 0 if treat_disagree != .
		replace treat_disagree_argument = 1 if treat_disagree == 1 & lettertreatment == "argument"
	label var treat_disagree_direct "Basic Justification for Disagreeing Position"
	label var treat_disagree_argument "Extensive Justification for Disagreeing Position"

	
	forvalues var=1/4{
	foreach treatvar in treat_disagree treat_disagree_direct treat_disagree_argument{
		* People who receive a letter on an issue they were INDIFFERENT on excluded from these comparisons
		* Recall, no one received a letter on an issue they AGREED with
		replace `treatvar' = . if issuetreatmentnumber == `var' & issue`var'pre == 0
		}
		}

	*Rescale Legislator Affect to Range 0-1
	gen legislator_positivePOST_01scale = (legislator_positivePOST + 3) / 6
		label var legislator_positivePOST_01scale "Legislator Approval (0-1 Scale)"
	
	*CREATE STRATA INDICATORS -- Fixed Effects are included in regressions to account for how the randomization was performed - see text for description.
	gen strata = "disagrees_on_" + string(disagreePRE_num_issues) + "_moveable_on_" + string(moveable_total)


*ANALYSIS, Study 2, Affect Results	
	** TABLE 8, Study 2, Legislator Approval, OLS
	xi: reg legislator_positivePOST_01scale treat_disagree_direct treat_disagree_argument legislator_positivePRE i.strata if disagreePRE_num_issues!=0
		outreg2 using Study2_Approval,  dec(3) label word ctitle("Legislator Approval, 0-1 Scale") replace
	xi: reg leg_approve_POST_binary treat_disagree_direct treat_disagree_argument legislator_positivePRE i.strata if disagreePRE_num_issues!=0
		outreg2 using Study2_Approval,  dec(3) label word ctitle(Approve-Binary) append
	xi: reg leg_disapprove_POST_binary treat_disagree_direct treat_disagree_argument legislator_positivePRE i.strata if disagreePRE_num_issues!=0
		outreg2 using Study2_Approval,  dec(3) label word ctitle(Disapprove-Binary) append

**Results in Appendix
	** TABLE A1, COLUMN 2: Recall receiving a letter in Study 2
		reg letter_recallPOST treat_argument treat_direct

	** TABLE A3, Balance and Attrition Tests, Study 2 
		*Create Dependent Variable for Attrition Test
		gen completed_post=legislator_positivePOST!=.	
	xi: reg legislator_positivePRE treat_direct treat_argument i.strata if completed_post==1
		outreg2 using Study2_balance,  dec(3) label word ctitle(Approval)  replace
	xi: reg obama_positivePRE treat_direct treat_argument i.strata if completed_post==1
		outreg2 using Study2_balance,  dec(3) label word ctitle(Obama Affect)  append
	xi: reg disagreePRE_num_issues treat_direct treat_argument if completed_post==1
		outreg2 using Study2_balance,  dec(3) label word ctitle(Issue Disaggreement)  append

	** TABLE A4, Col 2 (Study 2), Predicting Panel Attrition
		* Create Variables for the Analysis
			gen obamaneutral=obama_positivePRE==0
			gen obamanegative= obama_positivePRE==-1
			gen no_opinion_of_legislator= legislator_positivePRE==0
			gen neg_opinion_of_legislator= legislator_positivePRE<0
			gen female=0 if voterbase_gender=="Male"
				replace female=1 if voterbase_gender=="Female"
			gen issue_engagement=abs(issue1pre) + abs(issue2pre) +abs(issue3pre) + abs(issue4pre) 
		*Regression Result
		reg completed_post obamaneutral obamanegative no_opinion_of_legislator neg_opinion_of_legislator voterbase_age female issue_engagement
			outreg2 using Completed_2Surveys_Study2, dec(3) label word ctitle(Issue) title("STUDY 2: Who finished the 2nd Survey?") replace

	** TABLE A8, Study 2, Legislator Approval, w/o LDV
	xi: reg legislator_positivePOST_01scale treat_disagree_direct treat_disagree_argument  i.strata i.legislator if disagreePRE_num_issues!=0
		outreg2 using Study2_Approval_Appendix,  dec(3) label word ctitle("Legislator Approval, 0-1 Scale") replace
	xi: reg leg_approve_POST_binary treat_disagree_direct treat_disagree_argument i.strata i.legislator if disagreePRE_num_issues!=0
		outreg2 using Study2_Approval_Appendix,  dec(3) label word ctitle(Approve-Binary) append
	xi: reg leg_disapprove_POST_binary treat_disagree_direct treat_disagree_argument i.strata i.legislator if disagreePRE_num_issues!=0
		outreg2 using Study2_Approval_Appendix,  dec(3) label word ctitle(Disapprove-Binary) append

	** TABLE A12, Study 2, Affect, Heterogeneous Treatment Effects
	** Prepare Moderators
		gen oblike = obama_positivePRE==1
			label var oblike "Like Obama (Pre-Treatment)"
		gen oblike_direct=oblike*treat_disagree_direct
			label var oblike_direct "Like Obama*Basic"
		gen oblike_argument=oblike*treat_disagree_argument
			label var oblike_argument "Like Obama*Extensive"

		gen obindiff = obama_positivePRE==0
			label var obindiff "Indifferent/No opinion on Obama (Pre-Treatment)"
		gen obindiff_direct=obindiff*treat_disagree_direct
			label var obindiff_direct "Indifferent/No opinion*Basic"
		gen obindiff_argument=obindiff*treat_disagree_argument
			label var obindiff_argument "Indifferent/No opinion*Extensive"
	
	*Regression Results
	xi: reg leg_approve_POST_binary treat_disagree_direct treat_disagree_argument oblike_direct oblike_argument obindiff_direct obindiff_argument  oblike obindiff  i.strata i.legislator if disagreePRE_num_issues!=0
		outreg2 using Study2_Approval_Heterogeneous,  dec(3) label word ctitle(Approve-Binary) replace
	xi: reg leg_disapprove_POST_binary treat_disagree_direct treat_disagree_argument oblike_direct oblike_argument obindiff_direct obindiff_argument  oblike obindiff  i.strata i.legislator if disagreePRE_num_issues!=0
		outreg2 using Study2_Approval_Heterogeneous, dec(3) label word ctitle(Disapprove-Binary) append

		drop oblike_* obindiff_* 			
		

******************************************************
**************         Study 2          **************
**************Opinion Leadership Results**************
******************************************************

*Prepare Data for Analysis		
		
	*Drop variables not appropriate for below analysis to make sure we don't use them.
		drop leg_approve_POST_binary - treat_disagree_argument legislator_positivePOST_01scale

	*Rename variables 
	forvalues var=1/4{
		rename issue`var'pre issuepre`var'
		rename issue`var'post issuepost`var'
		rename issue`var'know issueknow`var'
		rename issue`var'name issuename`var'
		}

	*Create respondent id for analyzing the data at the respondent-issue level.
	gen voter_id = _n
	reshape long moveable disagree issuepre issuepost issueknow issuename, i(voter_id) j(issueid)

	*We didn't ask questions on these issues and they weren't eligible for treatment
	drop if moveable == 0

	*Rescaled Outcome, 0-1
	gen issue_agreement_post_01scale = (issuepost+1)/3
		label var issue_agreement_post_01scale "Issue Agreement (0-1 Scale)"
		
	*Dichotomize outcomes
	gen issue_disagree_binary_post = issuepost == -1
		replace issue_disagree_binary_post = . if issuepost == .
	gen issue_agree_binary_post = issuepost == 1
		replace issue_agree_binary_post = . if issuepost == .

	*Create outcome for the manipulation check of whether the voters learned the legislators' position from the letter
	gen correct=0 if issueknow!=.
		replace correct=1 if issueknow==1
				
	*Create the lagged variable
	gen issue_disagree_binary_pre = issuepre == -1
		label var issue_disagree_binary_pre "Lagged Opinion: Disagree with Legislator"
		
	*Create the issue specific treatment for the analysis
	gen issue_specific_treat = "nothing"
		replace issue_specific_treat = "argument" if lettertreatment == "argument" & issueid == issuetreatmentnumber
		replace issue_specific_treat = "direct" if lettertreatment == "direct" & issueid == issuetreatmentnumber
	gen treat_argument = issue_specific_treat == "argument"
	gen treat_direct = issue_specific_treat == "direct"
	gen treat_position = treat_argument + treat_direct
	
	label var treat_direct "Position with Basic Justification"
	label var treat_argument "Position with Extensive Justification"
	label var treat_position "Position"

		
	** Prepare Moderators
		gen oblike_direct=oblike*treat_direct
			label var oblike_direct "Obama Like*Basic"
		gen oblike_argument=oblike*treat_argument
			label var oblike_argument "Obama Like*Extensive"
		gen obindiff_direct=obindiff*treat_direct
			label var obindiff_direct "Indifferent/No opinion*Basic"
		gen obindiff_argument=obindiff*treat_argument
			label var obindiff_argument "Indifferent/No opinion*Extensive"

		gen disagree_direct=issue_disagree_binary_pre*treat_direct	
			label var disagree_direct "Disagree*Basic"
		gen disagree_argument=issue_disagree_binary_pre*treat_argument	
			label var disagree_argument "Disagree*Extensive"
			
			
*Study 2: Opinion Leadership Results
	** TABLE 6, Study 2, Manipulation check, Did Constituents Learn Correct Position?
	xi: reg correct  treat_direct treat_argument i.strata
		outreg2 using Study2_LearnOpinion,  dec(3) label word ctitle(Know Opinion) replace
		
	** TABLE 7, Study 2, Approval
	xi: reg issue_agreement_post_01scale treat_direct treat_argument issue_disagree_binary_pre i.strata, cl(voter_id)
		outreg2 using Study2_LeadOpinion_OLS, dec(3) label word ctitle("Agree, 0-1 Scale") replace
	xi: reg issue_agree_binary_post treat_direct treat_argument issue_disagree_binary_pre i.strata, cl(voter_id)
		outreg2 using Study2_LeadOpinion_OLS, dec(3) label word ctitle("Agree, Binary") append
	xi: reg issue_disagree_binary_post treat_direct treat_argument issue_disagree_binary_pre i.strata, cl(voter_id)
		outreg2 using Study2_LeadOpinion_OLS,  dec(3) label word ctitle("Disagree, Binary") append

		
** Appendix		
	** TABLE A11, Study 2, Opinion Leadership, Heterogenous Treatment Effect
	xi: reg issue_agree_binary_post treat_direct treat_argument oblike_direct oblike_argument obindiff_direct obindiff_argument oblike obindiff  i.strata i.legislator, cl(voter_id)
		outreg2 using Study2_heterogenous, dec(3) label word ctitle(Agree) replace
	xi: reg issue_disagree_binary_post treat_direct treat_argument   oblike_direct oblike_argument obindiff_direct obindiff_argument oblike obindiff  i.strata i.legislator, cl(voter_id)
		outreg2 using Study2_heterogenous, dec(3) label word ctitle(Disagree) append
	xi: reg issue_agree_binary_post treat_direct treat_argument disagree_direct disagree_argument issue_disagree_binary_pre  i.strata i.legislator, cl(voter_id)
		outreg2 using Study2_heterogenous, dec(3) label word ctitle(Agree) append
	xi: reg issue_disagree_binary_post treat_direct treat_argument disagree_direct disagree_argument issue_disagree_binary_pre  i.strata i.legislator, cl(voter_id)
		outreg2 using Study2_heterogenous, dec(3) label word ctitle(Disagree) append
		
	** TABLE A7, Study 2, Approval, OLS Without Lagged DV
	xi: reg issue_agreement_post_01scale treat_direct treat_argument i.strata i.legislator, cl(voter_id)
		outreg2 using Study2_LeadOpinion_OLS_noldv, dec(3) label word ctitle("Agree, 0-1 Scale") replace
	xi: reg issue_agree_binary_post treat_direct treat_argument i.strata i.legislator, cl(voter_id)
		outreg2 using Study2_LeadOpinion_OLS_noldv, dec(3) label word ctitle("Agree, Binary") append
	xi: reg issue_disagree_binary_post treat_direct treat_argument i.strata i.legislator, cl(voter_id)
		outreg2 using Study2_LeadOpinion_OLS_noldv,  dec(3) label word ctitle("Disagree, Binary") append


** FOOTNOTE 23.  Coparing variance by treatment
	bysort issue_specific_treat: summ issuepost
	sdtest issuepost, by(treat_position)
	
	

	
	
************************************************************
*****************         Study 2          *****************
**************Meta Analysis - Appendix Figures**************
************************************************************

	
*Measuring Opinion Leadership Effects by Issue
	foreach issue in budget cocainemom districting expunge gastax licenses marijuana minwage pensions pregnant proptaxes rail redistricting seventeen tuition voterid vouchers{
		xi: reg issuepost treat_position  i.strata if issuename == "`issue'", cl(voter_id)
	if `"`issue'"' == "budget"{	
		regsave treat_position using "metan-persuasion.dta", addlabel(issue, `issue') replace
	}
	else{
		regsave treat_position using "metan-persuasion.dta", addlabel(issue, `issue') append
	}
	}

*Call up dataset for Study 2
	use Study2_data.dta, clear
	set more off	
	
	foreach issue in budget cocainemom districting expunge gastax licenses marijuana minwage pensions pregnant proptaxes rail redistricting seventeen tuition voterid vouchers{
	gen eligible_this_issue = .
	gen treat_position = .
	forvalues inum=1/4{
		replace eligible_this_issue = 1 if issue`inum'name == "`issue'" & disagree`inum'PRE == 1
		replace treat_position = 1 if eligible_this_issue == 1 & issuetreatmentname == "`issue'"
	}
	replace treat_position = 0 if eligible_this_issue == 1 & lettertreatment == "placebo"
	
	xi: reg legislator_positivePOST treat_position legislator_positivePRE i.moveable_total i.legislator, robust
	if `"`issue'"' == "budget"{	
		regsave treat_position using metan-main.dta, addlabel(issue, `issue') replace
	}
	else{
		regsave treat_position using metan-main.dta, addlabel(issue, `issue') append
	}
	
	drop eligible_this_issue treat_position
	}

	use metan-main.dta, clear
	drop var r2
	rename coef coef_approval
	rename stderr stderr_approval
	rename N N_approval
	merge 1:1 issue using metan-persuasion.dta
	drop var r2
	rename coef coef_persuasion
	rename stderr stderr_persuasion
	rename N N_persuasion

	*FIGURE A1
	metan coef_persuasion stderr_persuasion, lcols(issue N_persuasion) title(Effects of Position-taking Shown by Issue) xtitle(Effect on Issue Opinion) sortby(N_persuasion) nobox
	gr export metan-persuasion.png, replace
		
	*FIGURE A2
	metan coef_approval stderr_approval, lcols(issue N_approval) title(Effects of Disagreeing Shown by Issue) xtitle(Effect on Legislator Favorability) sortby(N_approval) nobox
	gr export metan-main.png, replace
		
************THE END**************
		

