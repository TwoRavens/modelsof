**************************************************************************************
**************************************************************************************
**		Date: July 2017																**
**																					**
**		Replication files for article												**
**		DO INDIVIDUALS VALUE DISTRIBUTIONAL FAIRNESS? 								**
**		HOW INEQUALITY AFFECTS MAJORITY DECISIONS									**
**		in: Political Behavior														**
**																					**
**		Author: JAN SAUERMANN														**
**				Cologne Center for Comparative Politics								**
**				University of Cologne												**
**																					**
**																					**
**		Note: 	Complete analysis can be run from this file. Please copy this 		**
**				file in a common folder with the files "Data_Sauermann_PoBe.dta",	**
**				"data_reading.do", "incentives_policy_space.do", "figure_2.do", 	**
**				"figure_3.do", "figure_4.do", "figure_supp_A.do", 					**
**																					**
**************************************************************************************
**************************************************************************************

clear

********************************************************************************
* Incentives policy space
********************************************************************************
		quietly do "incentives_policy_space.do"


********************************************************************************
** SUPPLEMENATRY MATERIAL A. Incentive structures in experimental treatments
********************************************************************************

		** Individual points in core, total welfare in core, inequality in core
		* LIT
		list t1_points1 t1_points2 t1_points3 t1_points4 t1_points5 t1tot_points t1_sd_points if x==49 & y==68
		* HIT
		list t2_points1 t2_points2 t2_points3 t2_points4 t2_points5 t2tot_points t2_sd_points if x==49 & y==68
		* MT
		list t3_points1 t3_points2 t3_points3 t3_points4 t3_points5 t3tot_points t3_sd_points if x==49 & y==68


********************************************************************************
** Figure Supplementary material A. Average payouts in plicy space
********************************************************************************
		quietly do "figure_supp_A.do"


		** WELFARE MAXIMIZING POINT
		* LIT
		list x y t1tot_points if max_t1tot_points==1
		* Equal to core

		* HIT
		list x y t2tot_points if max_t2tot_points==1
		* Two points maximize total group payouts: (62|84) and (63|85)
		* Total number of tokens: 3187
		* HOWEVER: Total number of tokens in core: 3167
		* PROBABLY NO MEANINGFUL DIFFERENCE!

		* MT
		list x y t3tot_points if max_t3tot_points==1
		* Equal to core


		** FAIR POINT
		* Outcome maximizing lowest payoff

		* LIT
		list x y t1_points1 t1_points2 t1_points3 t1_points4 t1_points5 t1tot_points if max_t1_min==1
		* (67|63) 722 tokens
		* (67|64) 722 tokens

		* HIT
		list x y t2_points1 t2_points2 t2_points3 t2_points4 t2_points5 t2tot_points if max_t2_min==1
		* (86|74) 436 tokens
		* (87|75) 436 tokens
		* (88|76) 436 tokens
		* (90|77) 436 tokens
		* (91|78) 436 tokens
		* (92|79) 436 tokens

		* MT
		list x y t3_points1 t3_points2 t3_points3 t3_points4 t3_points5 t3tot_points if max_t3_min==1
		* (67|63) 264 tokens
		* (67|64) 264 tokens


		
********************************************************************************
** Figure 3. Distribution of payoffs in the experiment
********************************************************************************
		quietly do "figure_3.do"



clear

**********************************************************************
* RUN Do-File 'data_reading' 		                                 *
**********************************************************************
		quietly do "data_reading.do"



********************************************************************************
** Figure 2. Induced incentives
********************************************************************************
		quietly do "figure_2.do"


********************************************************************************
** Table 1. Selection of the core
********************************************************************************

		** Results exactly in core
		by treatment, sort: count if dist_core==0 & type==1

		** Distance from core <= 5 points
		by treatment, sort: count if dist_core<=5 & type==1

		** Distance from core <= 10 points
		by treatment, sort: count if dist_core<=10 & type==1


** Efficiency
		generate total_profit = profit_a + profit_b + profit_c +profit_d + profit_e
		label variable total_profit "Sum of points earned in period"

		generate points_core_a = 1000
		generate points_core_b = 883
		generate points_core_c = 845
		generate points_core_d = 337
		generate points_core_e = 102
		replace points_core_b = 645 if treatment==3
		replace points_core_c = 542 if treatment==3
		replace points_core_d = 760 if treatment==1
		replace points_core_e = 604 if treatment==1
		label variable points_core_a "Profit of Player A in core"
		label variable points_core_b "Profit of Player B in core"
		label variable points_core_c "Profit of Player C in core"
		label variable points_core_d "Profit of Player D in core"
		label variable points_core_e "Profit of Player E in core"

		generate total_profit_core = points_core_a + points_core_b + points_core_c + points_core_d + points_core_e
		label variable total_profit_core "Sum of points in core"

		by treatment, sort: count if total_profit>total_profit_core & type==1
		by treatment, sort: count if total_profit<total_profit_core & type==1
		by treatment, sort: count if total_profit==total_profit_core & type==1


** Equality
		egen sd_decision = rowsd(profit_a profit_b profit_c profit_d profit_e)
		replace sd_decision = (sd_decision^2)*4
		replace sd_decision = (sd_decision/5)^0.5
		label variable sd_decision "Standard deviation of distribution of points of decision"

		egen sd_core = rowsd(points_core_a points_core_b points_core_c points_core_d points_core_e)
		replace sd_core = (sd_core^2)*4
		replace sd_core = (sd_core/5)^0.5
		label variable sd_core "Standard deviation of distribution of points in core"

		by treatment, sort: count if sd_decision>sd_core & type==1
		by treatment, sort: count if sd_decision<sd_core & type==1
		by treatment, sort: count if sd_decision==sd_core & type==1


********************************************************************************
** SUPPLEMENATRY MATERIAL B. – Test of two point predictions
********************************************************************************

	** MAXI-MIN POINT
	* Calculate distance of final outcomes to nearest Maxi-min point
	* Maxi-min point: outcome maximizing lowest payout in group

		generate dist_maxmin1 = .
		generate dist_maxmin2 = .
		generate dist_maxmin3 = .
		generate dist_maxmin4 = .
		generate dist_maxmin5 = .
		generate dist_maxmin6 = .

		replace dist_maxmin1 = ((final_x - 67)^2 + (final_y - 63)^2)^0.5 if treatment==1 | treatment==3
		replace dist_maxmin2 = ((final_x - 67)^2 + (final_y - 64)^2)^0.5 if treatment==1 | treatment==3
		replace dist_maxmin1 = ((final_x - 86)^2 + (final_y - 74)^2)^0.5 if treatment==2
		replace dist_maxmin2 = ((final_x - 87)^2 + (final_y - 75)^2)^0.5 if treatment==2
		replace dist_maxmin3 = ((final_x - 88)^2 + (final_y - 76)^2)^0.5 if treatment==2
		replace dist_maxmin4 = ((final_x - 90)^2 + (final_y - 77)^2)^0.5 if treatment==2
		replace dist_maxmin5 = ((final_x - 91)^2 + (final_y - 78)^2)^0.5 if treatment==2
		replace dist_maxmin6 = ((final_x - 92)^2 + (final_y - 79)^2)^0.5 if treatment==2

		egen dist_maxmin_point = rowmin(dist_maxmin1 dist_maxmin2 dist_maxmin3 dist_maxmin4 dist_maxmin5 dist_maxmin6)
		label variable dist_maxmin_point "Euclidean distance of outcome to nearest Maxi-min point"

		bys treatment: count if dist_core>dist_maxmin_point & type==1
		bys treatment: count if dist_core<dist_maxmin_point & type==1
		bys treatment: count if dist_core==dist_maxmin_point & type==1 
		 
		bys treatment: count if dist_maxmin_point==0 & type==1

		

	** SPLIT THE DISTANCE POINT ('Fair point' in Fiorina & Plott (1978))
	* Point minimizing average Euclidean distance to all committee members ideal points
		
		generate split_dist_x = (opt_x1 + opt_x2 + opt_x3 + opt_x4 + opt_x5)/5
		generate split_dist_y = (opt_y1 + opt_y2 + opt_y3 + opt_y4 + opt_y5)/5
		* x: 58.3 y: 69.4

		generate dist_split = ((final_x - split_dist_x)^2 + (final_y - split_dist_y)^2)^0.5

		bys treatment: count if dist_core>dist_split & type==1
		bys treatment: count if dist_core<dist_split & type==1
		bys treatment: count if dist_core==dist_split & type==1 
		 
		bys treatment: count if dist_split<=1.5 & type==1


		
********************************************************************************
** Table 2. Retention of the core
********************************************************************************

		sort treatment groupid period
		* Committees choosing the core
		list groupid period if type==1 & dist_core==0
		* LIT: 101 102 103 104 108 110
		* HIT: 209 211 212
		* MT: 306 307 309 311

		* Committees leaving the core
		list groupid period dist_sq_core dist_core if type==1 & dist_sq_core==0 & change_dist_core>0
		* LIT: 101 103 104 110
		* HIT: 209 211 212
		* MT: 306 307 309 311


		
		
********************************************************************************
* SPATIAL ANALYSIS OF FINAL OUTCOMES											
********************************************************************************


********************************************************************************
** SUPPLEMENATRY MATERIAL D. Experimental results
********************************************************************************
	by treatment per5, sort: sum m5all_fin_x m5all_fin_y dist_m5mean_core std_m5_final m5_sem x2_m5_sem


********************************************************************************
* Figure 4
********************************************************************************
	quietly do "figure_4.do"


********************************************************************************
** Table 3. Non-egoistic individual behavior
********************************************************************************

		generate avg_prop = (points_prop_a + points_prop_b + points_prop_c + points_prop_d + points_prop_e)/5
		generate avg_sq = (points_sq_a + points_sq_b + points_sq_c + points_sq_d + points_sq_e)/5

		generate sd_prop = (((points_prop_a - avg_prop)^2 + (points_prop_b - avg_prop)^2 + (points_prop_c - avg_prop)^2 + (points_prop_d - avg_prop)^2 + (points_prop_e - avg_prop)^2) /5 )^0.5
		generate sd_sq = (((points_sq_a - avg_sq)^2 + (points_sq_b - avg_sq)^2 + (points_sq_c - avg_sq)^2 + (points_sq_d - avg_sq)^2 + (points_sq_e - avg_sq)^2) /5 )^0.5

		drop avg_prop avg_sq

	** VOTING BEHAVIOR: Who voted against her material self-interest in favor of a more equally distributed alternative?
		* Player A
		by treatment, sort: count if altru_vote_a==1 & ((vote_a_sq==1 & sd_sq<sd_prop) | (vote_a_alt==1 & sd_sq>sd_prop)) & type==1

		* Player B
		by treatment, sort: count if altru_vote_b==1 & ((vote_b_sq==1 & sd_sq<sd_prop) | (vote_b_alt==1 & sd_sq>sd_prop)) & type==1

		* Player C
		by treatment, sort: count if altru_vote_c==1 & ((vote_c_sq==1 & sd_sq<sd_prop) | (vote_c_alt==1 & sd_sq>sd_prop)) & type==1

		* Player D
		by treatment, sort: count if altru_vote_d==1 & ((vote_d_sq==1 & sd_sq<sd_prop) | (vote_d_alt==1 & sd_sq>sd_prop)) & type==1

		* Player E
		by treatment, sort: count if altru_vote_e==1 & ((vote_e_sq==1 & sd_sq<sd_prop) | (vote_e_alt==1 & sd_sq>sd_prop)) & type==1


	* At least one player voted agaist her interest
		by treatment, sort: count if ( (altru_vote_a==1 & ((vote_a_sq==1 & sd_sq<sd_prop) | (vote_a_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_b==1 & ((vote_b_sq==1 & sd_sq<sd_prop) | (vote_b_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_c==1 & ((vote_c_sq==1 & sd_sq<sd_prop) | (vote_c_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_d==1 & ((vote_d_sq==1 & sd_sq<sd_prop) | (vote_d_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_e==1 & ((vote_e_sq==1 & sd_sq<sd_prop) | (vote_e_alt==1 & sd_sq>sd_prop)))) & type==1 

	* Number of decisions in which committees voted (Proposer made a new proposal)
		by treatment, sort: count if win<2 & type==1



	** AGENDA SETTER

	** Did proposer propose a point offering her less points than the current status quo, but a more equal distribution of tokens?
		by treatment, sort: count if ag_altru1==1 & sd_prop<sd_sq & type==1


	** ANY BEHAVIOR IN DECISION THAT IS NOT IN LINE WITH TRADITIONAL RCT?

		by treatment, sort: count if ( ((altru_vote_a==1 & ((vote_a_sq==1 & sd_sq<sd_prop) | (vote_a_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_b==1 & ((vote_b_sq==1 & sd_sq<sd_prop) | (vote_b_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_c==1 & ((vote_c_sq==1 & sd_sq<sd_prop) | (vote_c_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_d==1 & ((vote_d_sq==1 & sd_sq<sd_prop) | (vote_d_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_e==1 & ((vote_e_sq==1 & sd_sq<sd_prop) | (vote_e_alt==1 & sd_sq>sd_prop)))) | (ag_altru1==1 & sd_prop<sd_sq ))& type==1 

		generate non_ego_beh = 0
		replace non_ego_beh = 1 if ( ((altru_vote_a==1 & ((vote_a_sq==1 & sd_sq<sd_prop) | (vote_a_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_b==1 & ((vote_b_sq==1 & sd_sq<sd_prop) | (vote_b_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_c==1 & ((vote_c_sq==1 & sd_sq<sd_prop) | (vote_c_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_d==1 & ((vote_d_sq==1 & sd_sq<sd_prop) | (vote_d_alt==1 & sd_sq>sd_prop))) ///
								| (altru_vote_e==1 & ((vote_e_sq==1 & sd_sq<sd_prop) | (vote_e_alt==1 & sd_sq>sd_prop)))) | (ag_altru1==1 & sd_prop<sd_sq ))& type==1 


		by groupid, sort: egen m20_non_ego_beh = mean(non_ego_beh)
		replace m20_non_ego_beh = 20*m20_non_ego_beh

		by treatment, sort: sum m20_non_ego_beh if type==1 & period==1

		ranksum m20_non_ego_beh if type==1 & period==1  & (treatment==1 | treatment==2), by(treatment)
		ranksum m20_non_ego_beh if type==1 & period==1  & (treatment==1 | treatment==3), by(treatment)
		ranksum m20_non_ego_beh if type==1 & period==1  & (treatment==2 | treatment==3), by(treatment)















