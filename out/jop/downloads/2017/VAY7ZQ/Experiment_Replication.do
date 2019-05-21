**************************************** Open dataset to replicate the experimental results [note: you should adjust the working directory appropriately]
cd "D:\Dropbox\Mexico Information Acquisition\Replication\"

use "Experiment_Data.dta", clear





	
**************************************** Examining attrition and restricting the sample to those responding within a week of the election

*** Test for differential attrition by treatment

reg remain treatment, ro



*** Test for differential attrition by non-attrition incentive

reg remain attrition, ro



*** Test for differential attrition by treatment and non-attrition incentive

reg remain treatment##attrition, ro



*** Test for differential attrition by treatment and sophistication

reg remain treatment##high_score, ro



*** Table A2: Balance tests from the initial assignment in the baseline survey [results print to a .txt file]

global balance "latitude	longitude	year_birth	male	pol_student	total_org	high_score	interest	interest_friends	high_interest_friends freq_friend_pol_disc	more_than_friends	respect_for_know	conv_part	comfortable	acq_vote_best	acq_speak_with_friends	acq_interest	acq_for_work	acq_civic_duty	acq_demo_knowledge	acq_no_important	acq_DK	attrition_incentive	hours_newspaper_all	hours_internet_all	hours_radio_all	hours_tv_all	local_news	national_news	international_news	state_news	no_news	DK_news	student_org	voluntary_org	sindicate	religious_org	citizen_org	neighbor_org	culture_org	party_org	sports_org	other_org	total_correct	pan_part	pri_part	prd_part	morena_part	no_part"

eststo clear
quietly foreach x of varlist $balance {
	eststo, title("`x'") : reg `x' treatment, ro
}
estout * using "balance.txt", cells(b(star fmt(3)) se(par)) stats(N, fmt(0) labels("Observations")) starlevels(* .1 ** .05 *** .01) keep(_cons treatment) label replace



*** Poor performance of late respondents: less likely to recall treatment and less likely to answer questions correctly

g slow=day>14
reg send_to_three treatment##slow, ro
reg total slow, ro
drop slow



*** Test for differential attrition by treatment within the final sample of those responding within a week

g remain2 = remain==1 & day<=14
reg remain2 treatment, ro



*** Test for differential attrition by treatment and sophistication within the final sample of those responding within a week

reg remain2 treatment##high_score, ro
drop remain2



*** Restrict to people that responded within a week of the election - ie by Sunday 14th June

drop if day>14



*** Drop missing observation on important covariate

drop if interest==.





	
**************************************** Randomization checks

*** Table A1: Balance tests for the final sample [results print to a .txt file]

eststo clear
quietly foreach x of varlist $balance {
	eststo, title("`x'") : reg `x' treatment if total!=., ro
}
estout * using "balance.txt", cells(b(star fmt(3)) se(par)) stats(N, fmt(0) labels("Observations")) starlevels(* .1 ** .05 *** .01) keep(_cons treatment) label replace



*** Define controls on the basis of covariate imbalances in final sample

global controls "i.year_birth interest no_news party_org acq_no_important"





	
**************************************** Manipulation checks
	
*** Table A3: Social treatment manipulation check

eststo clear
quietly foreach y of varlist send_to_three {
	eststo, title("`y'") : reg `y' 1.treatment $controls, ro
		sum `y' if e(sample)==1 & treatment==0
		estadd scalar Outcome_Mean=`r(mean)'
		sum treatment if e(sample)
		estadd scalar Treatment_Mean=`r(mean)'
	eststo, title("`y'"): reg `y' treatment##c.high_score $controls, ro
		sum `y' if e(sample) & treatment==0
		estadd scalar Outcome_Mean=`r(mean)'
		sum treatment if e(sample)
		estadd scalar Treatment_Mean=`r(mean)'
		sum high_score if e(sample)
		estadd scalar Interaction_Mean=`r(mean)'
		test 1.treatment + 1.treatment#c.high_score = 0
		estadd scalar Test=`r(p)'
}
estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N Outcome_Mean Treatment_Mean Interaction_Mean Test, fmt(0 2 2 2 2) labels("Observations" "Control outcome mean" "Social treatment mean" ///
	"Sophistcated mean" "Test: Social treatment + Social treatment $ \times$ Sophisticated = 0 ($ p$ value)")) starlevels(* .1 ** .05 *** .01) keep(1.treatment 1.treatment#c.high_score high_score) ///
	label varlabel(1.treatment "Social treatment" high_score "Sophisticated" 1.treatment#c.high_score "Social treatment $ \times$ Sophisticated")





	
**************************************** Average and main heterogeneous treatment effects

*** Table 1: Effect of the social treatment on election quiz scores, by student political sophistication

eststo clear
quietly { 
	eststo, title("`y'"): reg total 1.treatment $controls, ro
	sum total if e(sample) & treatment==0
	estadd scalar Outcome_Mean=`r(mean)'
	estadd scalar Outcome_SD=`r(sd)'
	sum treatment if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'
	foreach x of varlist high_score national_news hours_internet_all {
		foreach y of varlist total {
			eststo, title("`y'"): reg `y' treatment##c.`x' $controls, ro
				sum `y' if e(sample) & treatment==0
				estadd scalar Outcome_Mean=`r(mean)'
				estadd scalar Outcome_SD=`r(sd)'
				sum treatment if e(sample)
				estadd scalar Treatment_Mean=`r(mean)'
				sum `x' if e(sample)
				estadd scalar Interaction_Mean=`r(mean)'
				test 1.treatment + 1.treatment#c.`x' = 0
				estadd scalar Test=`r(p)'
		}
	}
}
estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N Outcome_Mean Outcome_SD Treatment_Mean Interaction_Mean Test, fmt(0 2 2 2 2 2) ///
	labels("Observations" "Control outcome mean" "Control outcome standard deviation" "Social treatment mean" "Interaction mean" "Test: Social treatment $+$ Interaction = 0 ($ p$ value)")) starlevels(* .1 ** .05 *** .01) ///
	keep(1.treatment high_score hours_internet_all national_news 1.treatment#c.high_score 1.treatment#c.hours_internet_all 1.treatment#c.national_news) /// 
	label varlabel(1.treatment "Social treatment" high_score "Sophisticated" national_news "Follow national news" hours_internet_all "Hours of internet news a week (baseline)" ///
	1.treatment#c.high_score "Social treatment $ \times$ Sophisticated" 1.treatment#c.national_news "Social treatment $ \times$ Follow national news" 1.treatment#c.hours_internet_all ///
	"Social treatment $ \times$ Hours of internet news a week (baseline)")

  




**************************************** Mechanism checks

*** Table 2: Mechanisms underpinning the effect of the social treatment on election quiz scores

eststo clear

** Self-reported learning more
eststo, title("learn"): reg learn treatment##c.high_score $controls, ro
	sum learn if e(sample) & treatment==0
	estadd scalar Outcome_Mean=`r(mean)'
	estadd scalar Outcome_SD=`r(sd)'
	sum treatment if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'
	sum high_score if e(sample)
	estadd scalar Interaction_Mean=`r(mean)'

** Heterogeneity by prior self-reported desire to demonstrate knowledge
eststo, title("total"): reg total treatment##c.acq_demo_knowledge $controls, ro
	sum total if e(sample) & treatment==0
	estadd scalar Outcome_Mean=`r(mean)'
	estadd scalar Outcome_SD=`r(sd)'
	sum treatment if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'
	sum acq_demo_knowledge if e(sample)
	estadd scalar Interaction2_Mean=`r(mean)'
	test 1.treatment + 1.treatment#c.acq_demo_knowledge = 0
	estadd scalar Test=`r(p)'

** Heterogeneity by sophistication and interest of friends
eststo, title("total"): reg total treatment##c.high_score##c.high_interest_friends $controls, ro
	sum total if e(sample) & treatment==0
	estadd scalar Outcome_Mean=`r(mean)'
	estadd scalar Outcome_SD=`r(sd)'
	sum treatment if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'
	sum high_score if e(sample)
	estadd scalar Interaction_Mean=`r(mean)'
	sum high_interest_friends if e(sample)
	estadd scalar Interaction2_Mean=`r(mean)'
	test 1.treatment + 1.treatment#c.high_interest_friends = 0
	estadd scalar Test2=`r(p)'
	test 1.treatment + 1.treatment#c.high_score = 0
	estadd scalar Test3=`r(p)'

estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N Outcome_Mean Outcome_SD Treatment_Mean Interaction_Mean Interaction2_Mean Test Test2 Test3, fmt(0 2 2 2 2 2 2 2) ///
	labels("Observations" "Control outcome mean" "Control outcome standard deviation" "Social treatment mean" "Voter sophistication mean" "Other interaction mean" ///
	"Test: Social treatment + Interaction = 0 ($ p$ value)" "Test: Social treatment + Social treatment $ \times$ High interest friends = 0 ($ p$ value)" ///
	"Test: Social treatment + Social treatment $ \times$ Sophisticated = 0 ($ p$ value)")) starlevels(* .1 ** .05 *** .01) ///
	keep(1.treatment high_score acq_demo_knowledge high_interest_friends 1.treatment#c.high_score 1.treatment#c.acq_demo_knowledge 1.treatment#c.high_interest_friends ///
	1.treatment#c.high_score#c.high_interest_friends c.high_score#c.high_interest_friends) /// 
	label varlabel(1.treatment "Social treatment" high_score "Sophisticated" acq_demo_knowledge "Demonstrate knowledge" high_interest_friends "High interest friends" ///
	1.treatment#c.high_score "Social treatment $ \times$ Sophisticated" 1.treatment#c.high_interest_friends "Social treatment $ \times$ High interest friends" ///
	1.treatment#c.acq_demo_knowledge "Social treatment $ \times$ Demonstrate knowledge" ///
	1.treatment#c.high_score#c.high_interest_friends "Social treatment $ \times$ Sophisticated $\times$ High interest friends" c.high_score#c.high_interest_friends "Sophisticated $\times$ High interest friends")



*** Table 3: Alternative interpretations

eststo clear

** Test to see if the result is driven by differential cheating
eststo, title("list_outcome"): reg list_outcome i.treated_list_experiment $controls, ro
	sum list_outcome if e(sample) & treatment==0
	estadd scalar Outcome_Mean=`r(mean)'
	estadd scalar Outcome_SD=`r(sd)'
	sum treated_list_experiment if e(sample)
	estadd scalar List_Treatment_Mean=`r(mean)'
eststo, title("list_outcome"): reg list_outcome treated_list_experiment##treatment##c.high_score $controls, ro
	sum list_outcome if e(sample) & treatment==0
	estadd scalar Outcome_Mean=`r(mean)'
	estadd scalar Outcome_SD=`r(sd)'
	sum treated_list_experiment if e(sample)
	estadd scalar List_Treatment_Mean=`r(mean)'
	sum treatment if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'
	sum high_score if e(sample)
	estadd scalar Interaction_Mean=`r(mean)'

** Test to see if the result is driven by talking to others about the study
eststo, title("talk") : reg talk treatment##c.high_score $controls, ro
	sum talk if e(sample)==1 & treatment==0
	estadd scalar Outcome_Mean=`r(mean)'
	sum treatment if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'

** Test to see if the result is driven by trying hard on the quiz
foreach y of varlist ave_response_time ave_number_clicks {
	eststo, title("`y'"): reg `y' treatment##c.high_score $controls, ro
		sum `y' if e(sample) & treatment==0
		estadd scalar Outcome_Mean=`r(mean)'
		estadd scalar Outcome_SD=`r(sd)'
		sum treatment if e(sample)
		estadd scalar Treatment_Mean=`r(mean)'
		sum high_score if e(sample)
		estadd scalar Interaction_Mean=`r(mean)'
}

** Test to see if the result is driven by greater individual interest in politics
eststo, title("pol_int"): reg pol_int treatment##c.high_score $controls, ro
	sum pol_int if e(sample) & treatment==0
	estadd scalar Outcome_Mean=`r(mean)'
	estadd scalar Outcome_SD=`r(sd)'
	sum treatment if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'
	sum high_score if e(sample)
	estadd scalar Interaction_Mean=`r(mean)'

** Test to see if the result is driven by new reasons to acquire information
foreach y of varlist acq_vote_best_post acq_interest_post acq_civic_duty_post {
	eststo, title("`y'"): reg `y' treatment##c.high_score $controls, ro
		sum `y' if e(sample) & treatment==0
		estadd scalar Outcome_Mean=`r(mean)'
		estadd scalar Outcome_SD=`r(sd)'
		sum treatment if e(sample)
		estadd scalar Treatment_Mean=`r(mean)'
		sum high_score if e(sample)
		estadd scalar Interaction_Mean=`r(mean)'
}

** Test to see if treatment affects perceptions of peer knowledge
eststo, title("friend_cor"): reg friend_cor treatment##c.high_score $controls, ro
	sum friend_cor if e(sample) & treatment==0
	estadd scalar Outcome_Mean=`r(mean)'
	estadd scalar Outcome_SD=`r(sd)'
	sum treatment if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'
	sum high_score if e(sample)
	estadd scalar Interaction_Mean=`r(mean)'

eststo, title("pol_int_fr"): reg pol_int_fr treatment##c.high_score $controls, ro
	sum pol_int_fr if e(sample) & treatment==0
	estadd scalar Outcome_Mean=`r(mean)'
	estadd scalar Outcome_SD=`r(sd)'
	sum treatment if e(sample)
	estadd scalar Treatment_Mean=`r(mean)'
	sum high_score if e(sample)
	estadd scalar Interaction_Mean=`r(mean)'

estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N Outcome_Mean Outcome_SD List_Treatment_Mean Treatment_Mean Interaction_Mean, fmt(0 2 2 2 2 2 2) ///
	labels("Observations" "Control outcome mean" "Control outcome standard deviation" "List experiment treatment mean" "Social treatment mean" "Interaction mean")) starlevels(* .1 ** .05 *** .01) ///
	keep(1.treatment high_score 1.treated_list_experiment 1.treatment#c.high_score 1.treated_list_experiment#c.high_score 1.treated_list_experiment#1.treatment 1.treated_list_experiment#1.treatment#c.high_score) /// 
	label varlabel(1.treatment "Social treatment" high_score "Sophisticated" 1.treated_list_experiment "List experiment treatment" 1.treatment#c.high_score "Social treatment $ \times$ Sophisticated" /// 
	1.treated_list_experiment#1.treatment "Social treatment $ \times$ List experiment treatment" 1.treated_list_experiment#c.high_score "Sophisticated $ \times$ List experiment treatment" 1.treated_list_experiment#1.treatment#c.high_score "Social treatment $ \times$ Sophisticated $\times$ List experiment treatment")

  
  
  
  

**************************************** Robustness checks in the online appendix

*** Table A4: Main experimental results without controls for imbalances

quietly {
	eststo clear
	eststo, title("`y'") : reg total 1.treatment, ro
		sum total if e(sample) & treatment==0
		estadd scalar Outcome_Mean=`r(mean)'
		estadd scalar Outcome_SD=`r(sd)'
		sum treatment if e(sample)
		estadd scalar Treatment_Mean=`r(mean)'
	eststo, title("`y'"): reg total treatment##c.high_score, ro
		sum total if e(sample) & treatment==0
		estadd scalar Outcome_Mean=`r(mean)'
		estadd scalar Outcome_SD=`r(sd)'
		sum treatment if e(sample)
		estadd scalar Treatment_Mean=`r(mean)'
		sum high_score if e(sample)
		estadd scalar Interaction_Mean=`r(mean)'
	eststo, title("total"): reg total treatment##c.high_score##c.high_interest_friends, ro
		sum total if e(sample) & treatment==0
		estadd scalar Outcome_Mean=`r(mean)'
		estadd scalar Outcome_SD=`r(sd)'
		sum treatment if e(sample)
		estadd scalar Treatment_Mean=`r(mean)'
		sum high_score if e(sample)
		estadd scalar Interaction_Mean=`r(mean)'
		sum high_interest_friends if e(sample)
		estadd scalar Interaction2_Mean=`r(mean)'
		test 1.treatment + 1.treatment#c.high_interest_friends = 0
		estadd scalar Test=`r(p)'
		test 1.treatment + 1.treatment#c.high_score = 0
		estadd scalar Test2=`r(p)'
}
estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N Outcome_Mean Outcome_SD Treatment_Mean Interaction_Mean Interaction2_Mean Test Test2, fmt(0 2 2 2 2 2 2) ///
	labels("Observations" "Control outcome mean" "Control outcome standard deviation" "Social treatment mean" "Sophisticated mean" "Other interaction mean" ///
	"Test: Social treatment + Social treatment $ \times$ High interest friends = 0 ($ p$ value)" "Test: Social treatment + Social treatment $ \times$ Sophisticated = 0 ($ p$ value)")) starlevels(* .1 ** .05 *** .01) ///
	keep(1.treatment high_score high_interest_friends 1.treatment#c.high_score 1.treatment#c.high_interest_friends 1.treatment#c.high_score#c.high_interest_friends c.high_score#c.high_interest_friends) /// 
	label varlabel(1.treatment "Social treatment" high_score "Sophisticated" more_than_friends "Believe know more than friends" acq_demo_knowledge "Acquire information to demonstrate knowledge" high_interest_friends "High interest friends" ///
	1.treatment#c.high_score "Social treatment $ \times$ Sophisticated" 1.treatment#c.more_than_friends "Social treatment $ \times$ Believe know more than friends" 1.treatment#c.high_interest_friends "Social treatment $ \times$ High interest friends" ///
	1.treatment#c.acq_demo_knowledge "Social treatment $ \times$ Acquire information to demonstrate knowledge" 1.treatment#c.high_score#c.more_than_friends "Social treatment $ \times$ Sophisticated $\times$ Believe know more than friends" ///
	1.treatment#c.high_score#c.high_interest_friends "Social treatment $ \times$ Sophisticated $\times$ High interest friends" c.high_score#c.more_than_friends "Sophisticated $\times$ Believe know more than friends" c.high_score#c.high_interest_friends "Sophisticated $\times$ High interest friends")


	
*** Table A5: Main experimental results using ordered logit estimation

quietly {
	eststo clear
	eststo, title("`y'") : ologit total 1.treatment $controls, ro
		sum total if e(sample) & treatment==0
		estadd scalar Outcome_Mean=`r(mean)'
		estadd scalar Outcome_SD=`r(sd)'
		sum treatment if e(sample)
		estadd scalar Treatment_Mean=`r(mean)'
	eststo, title("`y'"): ologit total treatment##c.high_score $controls, ro
		sum total if e(sample) & treatment==0
		estadd scalar Outcome_Mean=`r(mean)'
		estadd scalar Outcome_SD=`r(sd)'
		sum treatment if e(sample)
		estadd scalar Treatment_Mean=`r(mean)'
		sum high_score if e(sample)
		estadd scalar Interaction_Mean=`r(mean)'
	eststo, title("total"): ologit total treatment##c.high_score##c.high_interest_friends $controls, ro
		sum total if e(sample) & treatment==0
		estadd scalar Outcome_Mean=`r(mean)'
		estadd scalar Outcome_SD=`r(sd)'
		sum treatment if e(sample)
		estadd scalar Treatment_Mean=`r(mean)'
		sum high_score if e(sample)
		estadd scalar Interaction_Mean=`r(mean)'
		sum high_interest_friends if e(sample)
		estadd scalar Interaction2_Mean=`r(mean)'
		test 1.treatment + 1.treatment#c.high_interest_friends = 0
		estadd scalar Test=`r(p)'
		test 1.treatment + 1.treatment#c.high_score = 0
		estadd scalar Test2=`r(p)'
}
estout, style(tex) cells(b(star fmt(3)) se(par)) stats(N Outcome_Mean Outcome_SD Treatment_Mean Interaction_Mean Interaction2_Mean Test Test2, fmt(0 2 2 2 2 2 2) ///
	labels("Observations" "Control outcome mean" "Control outcome standard deviation" "Social treatment mean" "Sophisticated mean" "Other interaction mean" ///
	"Test: Social treatment + Social treatment $ \times$ High interest friends = 0 ($ p$ value)" "Test: Social treatment + Social treatment $ \times$ Sophisticated = 0 ($ p$ value)")) starlevels(* .1 ** .05 *** .01) ///
	keep(1.treatment high_score high_interest_friends 1.treatment#c.high_score 1.treatment#c.high_interest_friends 1.treatment#c.high_score#c.high_interest_friends c.high_score#c.high_interest_friends) /// 
	label varlabel(1.treatment "Social treatment" high_score "Sophisticated" more_than_friends "Believe know more than friends" acq_demo_knowledge "Acquire information to demonstrate knowledge" high_interest_friends "High interest friends" ///
	1.treatment#c.high_score "Social treatment $ \times$ Sophisticated" 1.treatment#c.more_than_friends "Social treatment $ \times$ Believe know more than friends" 1.treatment#c.high_interest_friends "Social treatment $ \times$ High interest friends" ///
	1.treatment#c.acq_demo_knowledge "Social treatment $ \times$ Acquire information to demonstrate knowledge" 1.treatment#c.high_score#c.more_than_friends "Social treatment $ \times$ Sophisticated $\times$ Believe know more than friends" ///
	1.treatment#c.high_score#c.high_interest_friends "Social treatment $ \times$ Sophisticated $\times$ High interest friends" c.high_score#c.more_than_friends "Sophisticated $\times$ Believe know more than friends" c.high_score#c.high_interest_friends "Sophisticated $\times$ High interest friends")


