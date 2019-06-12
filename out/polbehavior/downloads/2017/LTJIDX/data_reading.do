******************************************************************************************
******************************************************************************************
**		Date: July 2017																	**
**																						**
**		Replication files for article													**
**		DO INDIVIDUALS VALUE DISTRIBUTIONAL FAIRNESS? 									**
**		HOW INEQUALITY AFFECTS MAJORITY DECISIONS										**
**		in: Political Behavior															**
**																						**
**		Author: JAN SAUERMANN															**
**				Cologne Center for Comparative Politics									**
**				University of Cologne													**
**																						**
**																						**
**		Note: 	Complete analysis can be run from file "Analyses_Political_Behavior.do".**
**																	 					**
**																						**
******************************************************************************************
******************************************************************************************

clear


use "Data_Sauermann_PoBe.dta"
set more off
set more off, permanently



*********************************************
***	Definitions of labels used in dataset ***
*********************************************


		label define lb_sessionid 1 "09.07.2013, 12:00", add
		label define lb_sessionid 2 "09.07.2013, 16:15", add
		label define lb_sessionid 3 "10.07.2013, 12:00", add
		label define lb_sessionid 4 "10.07.2013, 14:00", add
		label define lb_sessionid 5 "10.09.2013, 12:00", add
		label define lb_sessionid 6 "11.09.2013, 12:00", add

		label define lb_treatment 1 "Low inequality treatment (LIT)"
		label define lb_treatment 2 "High inequality treatment (HIT)", add
		label define lb_treatment 3 "Misery treatment (MT)", add

		label define lb_type 1 "Player A"
		label define lb_type 2 "Player B", add
		label define lb_type 3 "Player C", add
		label define lb_type 4 "Player D", add
		label define lb_type 5 "Player E", add

		label define lb_yes_no 1 "yes"
		label define lb_yes_no 0 "no", add

		label define lb_prop -99 "Proposer maintains status quo. No new proposal"

		label define lb_high_low 1 "high"
		label define lb_high_low 0 "low", add

		label define lb_new_proposal 0 "Proposer maintains status quo in period"
		label define lb_new_proposal 1 "Proposer proposes new point", add

		label define lb_core 0 "Core empty"
		label define lb_core 1 "Core non-empty", add

		label define lb_core2 -99 "Core empty"

		label define lb_core3 -999 "Core empty"

		label define lb_win 0 "Group selects status quo point"
		label define lb_win 1 "Group selects proposed point", add
		label define lb_win 2 "Proposer maintains status quo point", add

		label define lb_vote 0 "no"
		label define lb_vote 1 "yes", add
		label define lb_vote -99 "Proposer maintained status quo. No group vote necessary", add

		label define lb_altru_vote 0 "no"
		label define lb_altru_vote 1 "yes", add
		label define lb_altru_vote -79 "Subject is proposer", add
		label define lb_altru_vote -99 "Proposer maintained status quo. No group vote necessary", add

		label define lb_num_betterwin -89 "Proposer maintains status quo without trying out other points in decision space"

		label define lb_loss_ag_betterwin -89 "Proposer maintains status quo without trying out other points in decision space"
		label define lb_loss_ag_betterwin -99 "num_betterwin == 0", add
		
		label define lb_noanswer -99 "no answer"

		label define lb_sex 0 "female"
		label define lb_sex 1 "male", add
		label define lb_sex -99 "no answer", add

		label define lb_yes_no_noanswer 0 "no"
		label define lb_yes_no_noanswer 1 "yes", add
		label define lb_yes_no_noanswer -99 "no answer", add


***********************************************************
***  LABELING PRE-EXISTING VARIABLES IN THE DATASET		***
***********************************************************

		* sessionid
		label variable sessionid "Session ID"
		label values sessionid lb_sessionid
		notes sessionid : Date and starting time of session

		*decisionid1
		label variable decisionid1 "Decision ID 1"
		notes decisionid1: Treatment_Period_Group_Type

		*decisionid2
		label variable decisionid2 "Decision ID 2"
		notes decisionid2: Treatment_Group_Type_Period

		*decisionid3
		label variable decisionid3 "Decision ID 3"
		notes decisionid3: Treatment_Group_Period

		*groupid
		label variable groupid "Group ID"
		notes groupid: Treatment_Group

		*subjectid
		label variable subjectid "Subject ID"
		notes subjectid: Treatment_Group_Type

		*treatment
		label variable treatment "Treatment"
		label values treatment lb_treatment
		notes treatment: Treatment 1 consist of 11 groups while all other treatments consist of 12 groups.
		notes treatment: In treatment 1 group 12 does not exist due to non-showups.


		*period
		label variable period "Period"

		*type
		label variable type "Type"
		label values type lb_type

		*subject
		label variable subject "Subject ID in session"

		*profit
		label variable profit "Profit in current period"

		*totalprofit
		label variable totalprofit "Sum of profits from current and all previous period"

		*opt_x
		label variable opt_x "x-coordinate of ideal point of player"

		*opt_y
		label variable opt_y "y-coordinate of ideal point of player"

		*opt_x1
		label variable opt_x1 "x-coordinate of ideal point of player A"

		*opt_y1
		label variable opt_y1 "y-coordinate of ideal point of player A"

		*opt_x2
		label variable opt_x2 "x-coordinate of ideal point of player B"

		*opt_y2
		label variable opt_y2 "y-coordinate of ideal point of player B"

		*opt_x3
		label variable opt_x3 "x-coordinate of ideal point of player C"

		*opt_y3
		label variable opt_y3 "y-coordinate of ideal point of player C"

		*opt_x4
		label variable opt_x4 "x-coordinate of ideal point of player D"

		*opt_y4
		label variable opt_y4 "y-coordinate of ideal point of player D"

		*opt_x5
		label variable opt_x5 "x-coordinate of ideal point of player E"

		*opt_y5
		label variable opt_y5 "y-coordinate of ideal point of player E"

		*agendasetter
		label variable agendasetter "Proposer in period"
		label values agendasetter lb_type

		*proposer
		label variable proposer "Is player proposer in period?"
		label values proposer lb_yes_no

		*prop_x
		label variable prop_x "x-coordinate of proposed point"
		label values prop_x lb_prop

		*prop_y
		label variable prop_y "y-coordinate of proposed point"
		label values prop_y lb_prop

		*sq_x
		label variable sq_x "x-coordinate of status quo in period"

		*sq_y
		label variable sq_y "y-coordinate of status quo in period"

		*final_x
		label variable final_x "x-coordinate of selected point in period"

		*final_y
		label variable final_y "y-coordinate of selected point in period"

		*new_proposal
		label variable new_proposal "New proposal?"
		label values new_proposal lb_new_proposal

		*sum_sq
		label variable sum_sq "Number of votes for status quo point"
		label values sum_sq lb_prop

		*sum_alt
		label variable sum_alt "Number of votes for proposed point"
		label values sum_alt lb_prop

		*core
		label variable core "Core"
		label values core lb_core

		*core_x
		label variable core_x "x-coordinate of core"
		label values core_x lb_core2

		*core_y
		label variable core_y "y-coordinate of core"
		label values core_y lb_core2

		*dist_core
		label variable dist_core "Distance of final result to core (Euclidean distance in points)"
		label values dist_core lb_core2

		*dist_sq_core
		label variable dist_sq_core "Distance of status quo to core (Euclidean distance in points)"
		label values dist_sq_core lb_core2

		*change_dist_core
		label variable change_dist_core "Difference between distance of final result to core and status quo to core"
		label values change_dist_core lb_core3
		notes change_dist_core: positive values indicate increasing difference to core

		*dist_res_sq
		label variable dist_res_sq "Euclidean distance in points from final result to status quo"

		*win
		label variable win "Type of decision outcome"
		label values win lb_win

		*vote_a_sq
		label variable vote_a_sq "Did player A vote for status quo?"
		label values vote_a_sq lb_vote

		*vote_a_alt
		label variable vote_a_alt "Did player A vote for the proposal?"
		label values vote_a_alt lb_vote

		*vote_b_sq
		label variable vote_b_sq "Did player B vote for status quo?"
		label values vote_b_sq lb_vote

		*vote_b_alt
		label variable vote_b_alt "Did player B vote for the proposal?"
		label values vote_b_alt lb_vote

		*vote_c_sq
		label variable vote_c_sq "Did player C vote for status quo?"
		label values vote_c_sq lb_vote

		*vote_c_alt
		label variable vote_c_alt "Did player C vote for the proposal?"
		label values vote_c_alt lb_vote

		*vote_d_sq
		label variable vote_d_sq "Did player D vote for status quo?"
		label values vote_d_sq lb_vote

		*vote_d_alt
		label variable vote_d_alt "Did player D vote for the proposal?"
		label values vote_d_alt lb_vote

		*vote_e_sq
		label variable vote_e_sq "Did player E vote for status quo?"
		label values vote_e_sq lb_vote

		*vote_e_alt
		label variable vote_e_alt "Did player E vote for the proposal?"
		label values vote_e_alt lb_vote

		*altru_vote
		label variable altru_vote "Altruistic vote"
		notes altru_vote: Subject voted for proposal even though status offered more points OR Subject voted for status quo even though proposal offered more points
		label values altru_vote lb_altru_vote

		*altru_vote_a
		label variable altru_vote_a "Altruistic vote player A"
		notes altru_vote_a: Player A voted for proposal even though status offered more points OR Player A voted for status quo even though proposal offered more points
		label values altru_vote_a lb_altru_vote

		*altru_vote_b
		label variable altru_vote_b "Altruistic vote player B"
		notes altru_vote_b: Player B voted for proposal even though status offered more points OR Player A voted for status quo even though proposal offered more points
		label values altru_vote_b lb_altru_vote

		*altru_vote_c
		label variable altru_vote_c "Altruistic vote player C"
		notes altru_vote_c: Player C voted for proposal even though status offered more points OR Player A voted for status quo even though proposal offered more points
		label values altru_vote_c lb_altru_vote

		*altru_vote_d
		label variable altru_vote_d "Altruistic vote player D"
		notes altru_vote_d: Player D voted for proposal even though status offered more points OR Player A voted for status quo even though proposal offered more points
		label values altru_vote_d lb_altru_vote

		*altru_vote_e
		label variable altru_vote_e "Altruistic vote player E"
		notes altru_vote_e: Player E voted for proposal even though status offered more points OR Player A voted for status quo even though proposal offered more points
		label values altru_vote_e lb_altru_vote

		*dist_prop
		label variable dist_prop "Euclidean distance between proposed point and player’s ideal point"
		label values dist_prop lb_prop

		*points_prop
		label variable points_prop "Points earned by player if proposal is selected by group"
		label values points_prop lb_prop

		*dist_sq
		label variable dist_sq "Euclidean distance between status quo and player’s ideal point"

		*points_sq
		label variable points_sq "Points earned by player if status quo is selected by group"

		*points_prop_a
		label variable points_prop_a "Points earned by player A if proposal is selected by group"
		label values points_prop_a lb_prop

		*points_sq_a
		label variable points_sq_a "Points earned by player A if status quo is selected by group"

		*points_prop_b
		label variable points_prop_b "Points earned by player B if proposal is selected by group"
		label values points_prop_b lb_prop

		*points_sq_b
		label variable points_sq_b "Points earned by player B if status quo is selected by group"

		*points_prop_c
		label variable points_prop_c "Points earned by player C if proposal is selected by group"
		label values points_prop_c lb_prop

		*points_sq_c
		label variable points_sq_c "Points earned by player C if status quo is selected by group"

		*points_prop_d
		label variable points_prop_d "Points earned by player D if proposal is selected by group"
		label values points_prop_d lb_prop

		*points_sq_d
		label variable points_sq_d "Points earned by player D if status quo is selected by group"

		*points_prop_e
		label variable points_prop_e "Points earned by player E if proposal is selected by group"
		label values points_prop_e lb_prop

		*points_sq_e
		label variable points_sq_e "Points earned by player E if status quo is selected by group"

		*ag_prop_points
		label variable ag_prop_points "Points earned by proposer if group selects proposal"
		label values ag_prop_points lb_prop

		*ag_sq_points
		label variable ag_sq_points "Points earned by proposer if group selects status quo"

		*ag_dec_x
		label variable ag_dec_x "x-coordinate of proposer’s decision (new proposal or maintenance of status quo)"

		*ag_dec_y
		label variable ag_dec_y "y-coordinate of proposer’s decision (new proposal or maintenance of status quo)"

		*ag_altru1
		label variable ag_altru1 "Altruistic proposer 1"
		notes ag_altru1: Did proposer propose a point offering him/her less points than the current status quo?
		label values ag_altru1 lb_ag_altru1

		*agenda_try
		label variable agenda_try "Did proposer try points in decision space?"
		label values agenda_try lb_yes_no

		*agenda_try_max
		label variable agenda_try_max "Number of points looked at by agenda setter before submitting a decision"

		*num_betterwin
		label variable num_betterwin "Number alternatives looked at better than proposer's decision"
		notes num_betterwin: Number of points looked at by agenda setter before submitting a decision guaranteeing the agenda setter MORE points than the proposal and which are preferred by majority in comparison to status quo.
		label values num_betterwin lb_num_betterwin

		*dist_best_try
		label variable dist_best_try "Distance proposer's best try"
		notes dist_best_try: Distance in points between proposer’s ideal point and point offering agenda setter the maximal number of points of all tried points offering him/her more points than the point actually proposed and which are majority preferred by in comparison to status quo.
		label values dist_best_try lb_loss_ag_betterwin

		*points_best_try
		label variable points_best_try "Points proposer's best try"
		notes points_best_try: Maximum number of points gained by proposer of all tried points offering him/her more points than the point actually proposed and which are majority preferred by in comparison to status quo.
		label values points_best_try lb_loss_ag_betterwin

		*x_best_try
		label variable x_best_try "x-coordinate of proposer's best try"
		notes x_best_try: x-coordinate of point offering proposer the maximal number of points of all tried points offering him/her more points than the point actually proposed and which are majority preferred by in 
		label values x_best_try lb_loss_ag_betterwin

		*y_best_try
		label variable y_best_try "y-coordinate of proposer's best try"
		notes y_best_try: y-coordinate of point offering proposer the maximal number of points of all tried points offering him/her more points than the point actually proposed and which are majority preferred by in comparison to status quo.
		label values y_best_try lb_loss_ag_betterwin

		*ag_x_opt
		label variable ag_x_opt "x-coordinate of optimal proposal of proposer given status quo"

		*ag_y_opt
		label variable ag_y_opt "y-coordinate of optimal proposal of proposer given status quo"

		*distanceag_opt
		label variable distanceag_opt "Distance between proposer’s ideal point and optimal proposal of proposer"

		*distanceag_sq
		label variable distanceag_sq "Distance between proposer’s ideal point and the current status quo"

		*points_ag_opt
		label variable points_ag_opt "Number of points gained by proposer for proposer’s optimal proposal"

		*points_a_opt
		label variable points_a_opt "Number of points gained by player A for proposer’s optimal proposal"

		*points_b_opt
		label variable points_b_opt "Number of points gained by player B for proposer’s optimal proposal"

		*points_c_opt
		label variable points_c_opt "Number of points gained by player C for proposer’s optimal proposal"

		*points_d_opt
		label variable points_d_opt "Number of points gained by player D for proposer’s optimal proposal"

		*points_e_opt
		label variable points_e_opt "Number of points gained by player E for proposer’s optimal proposal"

		*perf_rat
		label variable perf_rat "Perfectly rational decision?"
		notes perf_rat: DiffAG_prop_opt =!0 OR altru_vote_A==1 OR altru_vote_B==1 OR altru_vote_C==1 OR altru_vote_D==1 OR altru_vote_E==1
		label values perf_rat lb_yes_no

		*x
		label variable x "Last x-coordinate tried by proposer before making a decision"

		*y
		label variable y "Last y-coordinate tried by proposer before making a decision"

		*totalprofit_a
		label variable totalprofit_a "Sum of profits of player A from current and all previous period"

		*totalprofit_b
		label variable totalprofit_b "Sum of profits of player B from current and all previous period"

		*totalprofit_c
		label variable totalprofit_c "Sum of profits of player C from current and all previous period"

		*totalprofit_d
		label variable totalprofit_d "Sum of profits of player D from current and all previous period"

		*totalprofit_e
		label variable totalprofit_e "Sum of profits of player E from current and all previous period"

		*time_decision_proposer
		label variable time_decision_proposer "Decision time of proposer (in seconds)"

		*time_decision_voter
		label variable time_decision_voter "Decision time of voter (in seconds)"

		*time_in_stage1
		label variable time_in_stage1 "Time for group decision (in seconds)"

		*profit_a
		label variable profit_a "Profit of player A in current period"

		*profit_b
		label variable profit_b "Profit of player B in current period"

		*profit_c
		label variable profit_c "Profit of player C in current period"

		*profit_d
		label variable profit_d "Profit of player D in current period"

		*profit_e
		label variable profit_e "Profit of player E in current period"

		*age
		label variable age "Age of participant"
		label values age lb_noanswer

		*sex
		label variable sex "Participant's sex"
		label values sex lb_sex

		*student
		label variable student "Is participant student?"
		label values student lb_yes_no_noanswer

		*econ_student
		label variable econ_student "Is participant student of economics, management or related field?"
		label values econ_student lb_yes_no_noanswer

		*semester
		label variable semester "Number of semesters studied by participant"
		label values semester lb_noanswerlabel

		*experimental_experience
		label variable experimental_experience "Experimental experience"
		label values experimental_experience lb_noanswer
		notes experimental_experience: In how many prior experiments do you have participated so far? (If you do not know the exact number, please guess.)

		*similar_experiment
		label variable similar_experiment "Similar experiment"
		label values similar_experiment lb_yes_no_noanswer
		notes similar_experiment: Have you ever participated in an experiment with similar rules like today’s experiment?

		*question1
		label variable question1 "Evaluation own payouts"
		notes question1: How content are you with your own personal payout from this experiment?
		notes question1: 0 = very discontent; 5 = very content

		*question2
		label variable question2 "Evaluation other payouts"
		notes question2: How fair do you consider the payouts of the other members of your group in this experiment?
		notes question2: 0 = not fair at all; 5 = very fair

		*question3
		label variable question3 "Evaluation fairness as useful category"
		notes question3: Fairness is no useful category for the evaluation of the outcomes of this experiment 
		notes question3: 0 = don’t agree at all; 5 = fully agree



		
********************************************************************************
***			 DEFINITIONS OF NEW VARIABLES FOR ANALYSES						 ***
********************************************************************************

		* Number of groups
		gen num_groups=.
		replace num_groups=12 if treatment==2 | treatment==3
		replace num_groups=11 if treatment==1
		label variable num_groups "Number of groups in treatment"



		*******************
		* Period averages *
		*******************

		* ONE-period mean final_x and final_y by treatment
		by treatment period, sort: egen m1all_fin_x = mean(final_x)
		by treatment period, sort: egen m1all_fin_y = mean(final_y)
		label variable m1all_fin_x "Mean x-coordinate of decisions per treatment per period"
		label variable m1all_fin_y "Mean y-coordinate of decisions per treatment per period"

		* Standard distance deviation of final outcomes in treatment per period
		generate dev1_mean = ((m1all_fin_x - final_x)^2 + (m1all_fin_y - final_y)^2)^0.5
		generate square_dev1_mean = dev1_mean^2
		by treatment period type, sort: egen tot_square_dev1_mean = total(square_dev1_mean)
		generate std_m1_final = (tot_square_dev1_mean/(num_groups))^0.5
		label variable std_m1_final "Standard distance deviation of final outcomes in treatment per period"
		drop dev1_mean square_dev1_mean tot_square_dev1_mean

		* Distance of mean final outcome from the core
		generate dist_m1mean_core = ((m1all_fin_x - core_x)^2+(m1all_fin_y - core_y)^2)^0.5
		label variable dist_m1mean_core "Distance of mean final outcome from the core in treatment per period"

		*Standard error of the mean outcome
		generate m1_sem = std_m1_final/(sqrt(num_groups))
		label variable m1_sem "Standard error of mean outcome in treatment per period"

		generate x2_m1_sem = 2*(std_m1_final/(sqrt(num_groups)))
		label variable x2_m1_sem "2 Standard errors of mean outcome in treatment per period"



		**********************
		* 20 period averages *
		**********************

		* TWENTY-period mean final_x and final_y by group
		by groupid, sort: egen m20_fin_x = mean(final_x)
		by groupid, sort: egen m20_fin_y = mean(final_y)
		label variable m20_fin_x "Mean x-coordinate per group of TWENTY-period mean decisions"
		label variable m20_fin_y "Mean y-coordinate per group of TWENTY-period mean decisions"

		* TWENTY-period mean final_x and final_y by treatment
		by treatment, sort: egen m20all_fin_x = mean(final_x)
		by treatment, sort: egen m20all_fin_y = mean(final_y)
		label variable m20all_fin_x "Mean x-coordinate per treatment of TWENTY-period mean decisions"
		label variable m20all_fin_y "Mean y-coordinate per treatnent of TWENTY-period mean decisions"

		* Standard distance deviation of group's decisions in all periods
		generate dev20_group = ((m20_fin_x - m20all_fin_x)^2 + (m20_fin_y - m20all_fin_y)^2)^0.5
		generate square_dev20_group = dev20_group^2
		by treatment period type, sort: egen tot_square_dev20_group = total(square_dev20_group)
		generate std_m20_final = (tot_square_dev20_group/(num_groups))^0.5
		label variable std_m20_final "Standard distance deviation of group's decisions in all periods"
		drop dev20_group tot_square_dev20_group square_dev20_group

		* Distance of 20-period mean final outcome from the core
		generate dist_m20mean_core = ((m20all_fin_x - core_x)^2+(m20all_fin_y - core_y)^2)^0.5
		label variable dist_m20mean_core "Distance of 20-period mean final outcome from the core in treatment"

		*Standard error of 20-period mean final outcome
		generate m20_sem = std_m20_final/(sqrt(num_groups))
		label variable m20_sem "Standard error of 20-period mean outcome in treatment"

		generate x2_m20_sem = 2*(std_m20_final/(sqrt(num_groups)))
		label variable x2_m1_sem "2 Standard errors of 20-period mean outcome in treatment"



		**********************
		* 10 period averages *
		**********************

		gen per10=.
		replace per10=1 if period<=10
		replace per10=2 if period>10

		gen help_per10=""
		replace help_per10="1-10" if period<=10
		replace help_per10="11-20" if period>10

		gen marker10=0
		replace marker10=1 if period==1
		replace marker10=1 if period==11

		label define avg_10 1 "Periods 1-10" 2 "Periods 11-20"
		label values per10 avg_10

		* TEN-period mean final_x and final_y by group
		by groupid per10, sort: egen m10_fin_x = mean(final_x)
		by groupid per10, sort: egen m10_fin_y = mean(final_y)
		label variable m10_fin_x "Mean x-coordinate per group of TEN-period mean decisions"
		label variable m10_fin_y "Mean y-coordinate per group of TEN-period mean decisions"

		* TEN-period mean final_x and final_y by treatment
		by treatment per10, sort: egen m10all_fin_x = mean(final_x)
		by treatment per10, sort: egen m10all_fin_y = mean(final_y)
		label variable m10all_fin_x "Mean x-coordinate per treatment of TEN-period mean decisions"
		label variable m10all_fin_y "Mean y-coordinate per treatnent of TEN-period mean decisions"

		* Standard distance deviation of final outcomes in treatment per period
		generate dev10_mean = ((m10all_fin_x - m10_fin_x)^2 + (m10all_fin_y - m10_fin_y)^2)^0.5
		generate square_dev10_mean = dev10_mean^2
		by treatment period type, sort: egen tot_square_dev10_mean = total(square_dev10_mean)
		generate std_m10_final = (tot_square_dev10_mean/(num_groups))^0.5
		label variable std_m10_final "Standard distance deviation of 10-period mean final outcomes in treatment"
		drop dev10_mean square_dev10_mean tot_square_dev10_mean

		* Distance of 10-period mean final outcome from the core
		generate dist_m10mean_core = ((m10all_fin_x - core_x)^2+(m10all_fin_y - core_y)^2)^0.5
		label variable dist_m10mean_core "Distance of 10-period mean final outcome from the core in treatment"

		*Standard error of 10-period mean final outcome
		generate m10_sem = std_m10_final/(sqrt(num_groups))
		label variable m10_sem "Standard error of 10-period mean outcome in treatment"

		generate x2_m10_sem = 2*(std_m10_final/(sqrt(num_groups)))
		label variable x2_m10_sem "2 Standard errors of 10-period mean outcome in treatment"


		****************************
		* 5 period phases averages *
		****************************

		gen per5=.
		replace per5=1 if period<=5
		replace per5=2 if period>5 & period<=10
		replace per5=3 if period>10 & period<=15
		replace per5=4 if period>15

		gen help_per5=""
		replace help_per5="1-5" if period<=5
		replace help_per5="6-10" if period>5 & period<=10
		replace help_per5="11-15" if period>10 & period<=15
		replace help_per5="16-20" if period>15 

		gen marker5=0
		replace marker5=1 if period==1
		replace marker5=1 if period==6
		replace marker5=1 if period==11
		replace marker5=1 if period==16

		label define avg_5 1 "Periods 1-5" 2 "Periods 6-10" 3 "Periods 11-15" 4 "Periods 15-20"
		label values per5 avg_5

		* FIVE-period mean final_x and final_y by group
		by groupid per5, sort: egen m5_fin_x = mean(final_x)
		by groupid per5, sort: egen m5_fin_y = mean(final_y)
		label variable m5_fin_x "Mean x-coordinate per group of FIVE-period mean decisions"
		label variable m5_fin_y "Mean y-coordinate per group of FIVE-period mean decisions"

		* FIVE-period mean final_x and final_y by treatment
		by treatment per5, sort: egen m5all_fin_x = mean(final_x)
		by treatment per5, sort: egen m5all_fin_y = mean(final_y)
		label variable m5all_fin_x "Mean x-coordinate per treatment of FIVE-period mean decisions"
		label variable m5all_fin_y "Mean y-coordinate per treatnent of FIVE-period mean decisions"

		* Standard distance deviation of final outcomes in treatment per period
		generate dev5_mean = ((m5all_fin_x - m5_fin_x)^2 + (m5all_fin_y - m5_fin_y)^2)^0.5
		generate square_dev5_mean = dev5_mean^2
		by treatment period type, sort: egen tot_square_dev5_mean = total(square_dev5_mean)
		generate std_m5_final = (tot_square_dev5_mean/(num_groups))^0.5
		label variable std_m5_final "Standard distance deviation of 5-period mean final outcomes in treatment"
		drop dev5_mean square_dev5_mean tot_square_dev5_mean

		* Distance of 5-period mean final outcome from the core
		generate dist_m5mean_core = ((m5all_fin_x - core_x)^2+(m5all_fin_y - core_y)^2)^0.5
		label variable dist_m5mean_core "Distance of 5-period mean final outcome from the core in treatment"

		*Standard error of 5-period mean final outcome
		generate m5_sem = std_m5_final/(sqrt(num_groups))
		label variable m5_sem "Standard error of 5-period mean outcome in treatment"

		generate x2_m5_sem = 2*(std_m5_final/(sqrt(num_groups)))
		label variable x2_m5_sem "2 Standard errors of 5-period mean outcome in treatment"




		********************************
		* Does proposal lie in winset? *
		********************************

		gen prop_winset=2
		gen win_a = 0
		replace win_a = 1 if points_prop_a >= points_sq_a
		gen win_b = 0
		replace win_b = 1 if points_prop_b >= points_sq_b
		gen win_c = 0
		replace win_c = 1 if points_prop_c >= points_sq_c
		gen win_d = 0
		replace win_d = 1 if points_prop_d >= points_sq_d
		gen win_e = 0
		replace win_e = 1 if points_prop_e >= points_sq_e
		gen win_all = win_a + win_b + win_c + win_d + win_e

		replace prop_winset = 1 if ag_prop_points >= ag_sq_points & win_all>2
		replace prop_winset = 0 if ag_prop_points < ag_sq_points | win_all<3
		replace prop_winset = -99 if win==2

		drop win_a win_b win_c win_d win_e win_all

		label variable prop_winset "Does proposal lie in winset of status quo?"
		label define winset 1 "yes" 0 "no" -99 "Proposer maintained status quo"
		label values prop_winset winset
