/*
------------------------------------------------------------------------------------------
Replication of Online Appendix for Mitts, Tamar (2018) "From Isolation to Radicalization:  
Anti-Muslim Hostility and Support for ISIS in the West." American Political Science Review
------------------------------------------------------------------------------------------
This code replicates most of the tables in the online appendix. For tables not replicated 
in this script, please refer to R script: Mitts_2018_replication_Online_Appendix.R
------------------------------------------------------------------------------------------
This code uses the "estout" and "psmatch2" packages, these can be installed by typing 
"ssc install estout" and "ssc install psmatch2"
------------------------------------------------------------------------------------------

*/

* Set working directory here (change path if needed):
cd "~/Downloads/Replication/"

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table S6: Location prediction errors and far-right vote share
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	use "Data/pred_errors_test.dta", clear

	eststo clear
	eststo: reg mean_error_km right_wing_pct  i.country, vce(cluster location_id)
	eststo: reg median_error_km right_wing_pct  i.country, vce(cluster location_id)
	esttab using "Tables/Table_S6.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table S7: Predicted locations and far-right vote share
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	use "Data/Mitts_2018_dataset.dta", clear

	collapse (count) num=user_id (mean) right_wing_pct (mean) population (mean) country, by(location_id)

	eststo clear
	eststo: reg num pop i.country
	eststo: reg num right_wing_pct i.country
	eststo: reg num right_wing_pct pop i.country
	esttab using "Tables/Table_S7.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace


*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table S20: Balance test
*-*-*-*-*-*-*-*-*-*-*-*-*-*

	use "Data/Mitts_2018_dataset.dta", clear

	collapse (mean) is_sympathy_count (count) area_count=is_sympathy_count (mean) unemployed_pct (mean) right_wing_pct (mean) foreigner_pct (mean) population (mean) country (mean) upper_1pc_is_topics_100 (mean) upper_1pc_is_sympathy_100 (mean) activist_100 (mean) suspended_100 (mean) num_isis_following, by(location_id)
	gen high_far_right = 0
	replace high_far_right = 1 if right_wing_pct >=   12.17186    
  
	psmatch2 high_far_right unemployed_pct foreigner_pct population i.country, logit neighbor(1)
	rename _weight weight1

	eststo clear
	eststo: reg high_far_right unemployed_pct, vce(robust)
	eststo: reg high_far_right unemployed_pct  [aw=weight1], vce(robust)

	eststo: reg high_far_right unemployed_pct foreigner_pct, vce(robust)
	eststo: reg high_far_right unemployed_pct foreigner_pct [aw=weight1], vce(robust)

	eststo: reg high_far_right unemployed_pct foreigner_pct population , vce(robust)
	eststo: reg high_far_right unemployed_pct foreigner_pct population  [aw=weight1], vce(robust)

	eststo: reg high_far_right unemployed_pct foreigner_pct population i.country, vce(robust)
	eststo: reg high_far_right unemployed_pct foreigner_pct population  i.country [aw=weight1], vce(robust)

	esttab using "Tables/Table_S20.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01)  replace

	keep location_id weight1 
	save "Data/match_weights_all.dta", replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table S21: Far-right vote share and support for ISIS on Twitter (Matched design)
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	use "Data/Mitts_2018_dataset.dta", clear

	gen high_far_right = 0
	replace high_far_right = 1 if right_wing_pct >=   12.17186    

	merge m:1 location_id using  "Data/match_weights_all.dta"


	eststo clear
	eststo: reg upper_1pc_is_topics_1000 high_far_right [aw=weight1], vce(cluster location_id)
	eststo: reg upper_1pc_is_sympathy_1000 high_far_right [aw=weight1], vce(cluster location_id)
	eststo: reg activist_1000 high_far_right [aw=weight1], vce(cluster location_id)
	eststo: reg suspended_1000 high_far_right [aw=weight1], vce(cluster location_id)
	eststo: reg num_isis_following high_far_right [aw=weight1], vce(cluster location_id)
	esttab using "Tables/Table_S21.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01)  replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table S22: Events and changes in pro-ISIS rhetoric
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	eststo clear
	use "Data/Mitts_2018_event_paris.dta", clear
	merge m:1 location_id using  "Data/match_weights_all.dta"
	eststo: reg isis_topics_std post i.country [aw=weight1], vce(cluster location_id)	
	eststo: reg is_sympathy_std post  i.country [aw=weight1], vce(cluster location_id)	

	use "Data/Mitts_2018_event_brussels.dta", clear
	merge m:1 location_id using  "Data/match_weights_all.dta"
	eststo: reg isis_topics_std post i.country [aw=weight1], vce(cluster location_id)
	eststo: reg is_sympathy_std post  i.country [aw=weight1], vce(cluster location_id)	

	use "Data/Mitts_2018_event_isis_caliphate.dta", clear
	merge m:1 location_id using  "Data/match_weights_all.dta"
	eststo: reg isis_topics_std post i.country [aw=weight1], vce(cluster location_id)
	eststo: reg is_sympathy_std post  i.country [aw=weight1], vce(cluster location_id)	

	use "Data/Mitts_2018_event_pegida.dta", clear
	merge m:1 location_id using  "Data/match_weights_all.dta"
	eststo: reg is_sympathy_std post i.country [aw=weight1], vce(cluster location_id)	
	eststo: reg isis_topics_std post i.country [aw=weight1], vce(cluster location_id)	
	eststo: reg isis_topics_anti_west_std post i.country [aw=weight1], vce(cluster location_id)	

	esttab using "Tables/Table_S22a.tex", b(3) se(3) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01)  replace

	eststo clear
	use "Data/Mitts_2018_event_paris.dta", clear
	merge m:1 location_id using  "Data/match_weights_all.dta"
	eststo: reg is_sympathy_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country [aw=weight1], vce(cluster location_id)
	eststo: reg isis_topics_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country [aw=weight1], vce(cluster location_id)	

	use "Data/Mitts_2018_event_brussels.dta", clear
	merge m:1 location_id using  "Data/match_weights_all.dta"
	eststo: reg is_sympathy_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country [aw=weight1], vce(cluster location_id)
	eststo: reg isis_topics_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country [aw=weight1], vce(cluster location_id)	

	use "Data/Mitts_2018_event_isis_caliphate.dta", clear
	merge m:1 location_id using  "Data/match_weights_all.dta"
	eststo: reg is_sympathy_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country [aw=weight1], vce(cluster location_id)
	eststo: reg isis_topics_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country [aw=weight1], vce(cluster location_id)	

	use "Data/Mitts_2018_event_pegida.dta", clear
	merge m:1 location_id using  "Data/match_weights_all.dta"
	eststo: reg is_sympathy_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country [aw=weight1], vce(cluster location_id)
	eststo: reg isis_topics_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country [aw=weight1], vce(cluster location_id)	
	eststo: reg isis_topics_anti_west_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country [aw=weight1], vce(cluster location_id)	

	esttab using "Tables/Table_S22b.tex", b(3) se(3) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01)  replace


*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table S23: Events and changes in pro-ISIS rhetoric, by far-right vote share and unemployment
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	eststo clear
	use "Data/Mitts_2018_event_paris.dta", clear
	eststo: reg is_sympathy_std i.post##c.unemployed_pct i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)
	eststo: reg isis_topics_std i.post##c.unemployed_pct i.post##c.right_wing_pct  foreigner_pct population population_squared i.country , vce(cluster location_id)	

	use "Data/Mitts_2018_event_brussels.dta", clear
	eststo: reg is_sympathy_std i.post##c.unemployed_pct i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)
	eststo: reg isis_topics_std i.post##c.unemployed_pct i.post##c.right_wing_pct  foreigner_pct population population_squared i.country , vce(cluster location_id)	

	use "Data/Mitts_2018_event_isis_caliphate.dta", clear
	eststo: reg is_sympathy_std i.post##c.unemployed_pct i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)
	eststo: reg isis_topics_std i.post##c.unemployed_pct i.post##c.right_wing_pct  foreigner_pct population population_squared i.country , vce(cluster location_id)	

	use "Data/Mitts_2018_event_pegida.dta", clear
	eststo: reg is_sympathy_std i.post##c.unemployed_pct i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)
	eststo: reg isis_topics_std i.post##c.unemployed_pct i.post##c.right_wing_pct  foreigner_pct population population_squared i.country , vce(cluster location_id)	
	eststo: reg isis_topics_anti_west_std i.post##c.unemployed_pct i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)

	esttab using "Tables/Table_S23.tex", b(3) se(3) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01)  replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	
* Table S25: Different cutoffs for classifying top posters of radical content
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*	

	use "Data/Mitts_2018_dataset.dta", clear
	
	eststo clear
	eststo: reg upper_5pc_is_topics_1000 right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	eststo: reg upper_10pc_is_topics_1000 right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	eststo: reg upper_15pc_is_topics_1000 right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	eststo: reg upper_20pc_is_topics_1000 right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	eststo: reg upper_25pc_is_topics_1000 right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	esttab using "Tables/Table_S25.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table S26: Correlates of activists
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	use "Data/Mitts_2018_dataset.dta", clear

	eststo clear
	eststo: reg upper_1pc_is_topics activist right_wing_pct unemployed_pct foreigner_pct  population population_squared i.country, vce(cluster location_id)
	eststo: reg upper_1pc_is_sympathy activist right_wing_pct unemployed_pct foreigner_pct  population population_squared i.country, vce(cluster location_id)
	eststo: reg suspended activist right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	eststo: reg num_isis_following activist right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	esttab using "Tables/Table_S26.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table S27: Far-right vote share and support for ISIS on Twitter
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	use "Data/Mitts_2018_dataset.dta", clear
	
	eststo clear
	eststo: reg upper_1pc_is_topics_1000 right_wing_pct unemployed_pct foreigner_pct  population population_squared i.country, vce(robust)
	eststo: reg upper_1pc_is_sympathy_1000 right_wing_pct unemployed_pct foreigner_pct  population population_squared i.country, vce(robust)
	eststo: reg activist_1000 right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(robust)
	eststo: reg suspended_1000 right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(robust)
	eststo: reg num_isis_following right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(robust)
	esttab using "Tables/Table_S27.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table S28: Far-right vote share and posting pro-ISIS content on Twitter
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
	
	use "Data/Mitts_2018_dataset.dta", clear

	eststo clear
	eststo: reg is_sympathy_count right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(robust)
	eststo: reg is_life_ff right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(robust)
	eststo: reg syrian_war_count right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(robust)
	eststo: reg anti_west_count right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(robust)
	esttab using "Tables/Table_S28.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table S29: Unemployed immigrants, asylum seekers and support for ISIS on Twitter
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	use "Data/Mitts_2018_dataset.dta", clear

	eststo clear
	eststo: reg upper_1pc_is_topics_1000 right_wing_pct immigrants_unemployed_pct  asylum_seekers_std     population population_squared i.country, vce(robust)
	eststo: reg activist_1000 right_wing_pct immigrants_unemployed_pct  asylum_seekers_std   population population_squared i.country, vce(robust)
	eststo: reg suspended_1000 right_wing_pct immigrants_unemployed_pct  asylum_seekers_std    population population_squared i.country, vce(robust)
	eststo: reg num_isis_following right_wing_pct immigrants_unemployed_pct  asylum_seekers_std   population population_squared i.country, vce(robust)
	esttab using "Tables/Table_S29.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01)  replace
