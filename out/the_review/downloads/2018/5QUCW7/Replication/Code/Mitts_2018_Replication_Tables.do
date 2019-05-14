/*
--------------------------------------------------------------------------
Replication for Mitts, Tamar (2018) "From Isolation to Radicalization: 
Anti-Muslim Hostility and Support for ISIS in the West"
American Political Science Review
--------------------------------------------------------------------------
This code replicates the tables in the article. For replication of figures, 
see R script Mitts_2018_Replication_Figures.R. For replication of estimations 
reported in the online appendix, please refer to scripts Mitts_2018_replication_Online_Appendix.do
and Mitts_2018_replication_Online_Appendix.R.
--------------------------------------------------------------------------
This code uses the "estout" and "parmest" packages, these can be installed
by typing "ssc install estout" and "ssc install parmest"
--------------------------------------------------------------------------
*/


* Set working directory here (change path if needed):
cd "~/Downloads/Replication/"


*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table 1: Far-right support and anti-Muslim attitudes in Europe
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

/* Note: Table 1 uses data from the European Social Survey Round 7 Data (2014), which can be found
in this link: http://www.europeansocialsurvey.org/data/download.html?r=7
*/

	* Run code that fixes missing values:

		do "Code/ESS_miss.do"
		
		* Generate variables:
		
			* Far-right party support:
				gen voted_ukip = 0  
				replace voted_ukip = 1 if  prtvtbgb == 7
				gen voted_fn = 0  
				replace voted_fn = 1 if  prtvtcfr == 2
				gen voted_npd_afd = 0  
				replace voted_npd_afd = 1 if  prtvede1 == 6 | prtvede1 == 8 | prtvede2 == 6 | prtvede2 == 8
				gen voted_vb = 0
				replace voted_vb =1 if prtvtcbe == 6
				gen voted_far_right = 0
				replace voted_far_right = 1 if voted_ukip == 1 | voted_fn == 1 | voted_npd_afd == 1 | voted_vb == 1

			* Placement on left-right scale
				gen far_right = .
				replace far_right = 0 if lrscale <=9
				replace far_right = 1 if lrscale > 9
				
			* Demographic variables
				gen native = .
				replace native = 0 if brncntr ==2
				replace native = 1 if brncntr ==1

			* Attitudes
				gen allow_no_muslims = .
				replace allow_no_muslims = 0 if almuslv < 4
				replace allow_no_muslims = 1 if almuslv == 4
				gen disapprove_imm_diff_race = imdfetn
				gen disapprove_imm_marry_rel = imdetmr
				gen disapprove_imm_boss = imdetbs
				gen imm_crime_worse = 11- imwbcrm
				
			* Weights
				gen newweight = pspwght* pweight
				
		* Analysis
				
			svyset idno [pweight= newweight]
			
			* A. Far-right self placement
			eststo clear
			eststo: svy: reg allow_no_muslims far_right hinctnta gndr edulvlb i.rlgdnm native agea if cntry == "GB" | cntry == "FR" | cntry == "DE" | cntry == "BE"
			eststo: svy: reg disapprove_imm_diff_race far_right hinctnta gndr edulvlb i.rlgdnm native agea if cntry == "GB" | cntry == "FR" | cntry == "DE" | cntry == "BE"
			eststo: svy: reg disapprove_imm_marry_rel far_right hinctnta gndr edulvlb i.rlgdnm native agea if cntry == "GB" | cntry == "FR" | cntry == "DE" | cntry == "BE"
			eststo: svy: reg disapprove_imm_boss far_right hinctnta gndr edulvlb i.rlgdnm native agea if cntry == "GB" | cntry == "FR" | cntry == "DE" | cntry == "BE"
			eststo: svy: reg imm_crime_worse far_right hinctnta gndr edulvlb i.rlgdnm native agea if cntry == "GB" | cntry == "FR" | cntry == "DE" | cntry == "BE"
			esttab using "Tables/Table_1a.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace

			* B. Far-right voting
			eststo clear
			eststo: svy: reg allow_no_muslims voted_far_right hinctnta gndr edulvlb i.rlgdnm native agea if cntry == "GB" | cntry == "FR" | cntry == "DE" | cntry == "BE"
			eststo: svy: reg disapprove_imm_diff_race voted_far_right hinctnta gndr edulvlb i.rlgdnm native agea if cntry == "GB" | cntry == "FR" | cntry == "DE" | cntry == "BE"
			eststo: svy: reg disapprove_imm_marry_rel voted_far_right hinctnta gndr edulvlb i.rlgdnm native agea if cntry == "GB" | cntry == "FR" | cntry == "DE" | cntry == "BE"
			eststo: svy: reg disapprove_imm_boss voted_far_right hinctnta gndr edulvlb i.rlgdnm native agea if cntry == "GB" | cntry == "FR" | cntry == "DE" | cntry == "BE"
			eststo: svy: reg imm_crime_worse voted_far_right hinctnta gndr edulvlb i.rlgdnm native agea if cntry == "GB" | cntry == "FR" | cntry == "DE" | cntry == "BE"
			esttab using "Tables/Table_1b.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace


*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table 3: Summary statistics
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

use "Data/Mitts_2018_dataset.dta", clear

	estpost sum is_sympathy_count is_life_ff syrian_war_count anti_west_count activist suspended num_isis_following right_wing_pct unemployed_pct immigrants_unemployed_pct foreigner_pct population
	esttab using "Tables/Table_3.tex", cell("count mean sd min max") replace
	

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table 5: Far-right vote share and support for ISIS on Twitter
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	eststo clear
	eststo: reg upper_1pc_is_topics_1000 right_wing_pct unemployed_pct foreigner_pct  population population_squared i.country, vce(cluster location_id)
		* Note: percent change is calculated as the coefficient on right_wing_pct divided by the constant
	eststo: reg upper_1pc_is_sympathy_1000 right_wing_pct unemployed_pct foreigner_pct  population population_squared i.country, vce(cluster location_id)
		* Note: pecent change is calculated as the coefficient on right_wing_pct divided by the constant
	eststo: reg activist_1000 right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
		* Note: percent change is calculated as the coefficient on right_wing_pct divided by the unconditional mean of activist_1000
	eststo: reg suspended_1000 right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	eststo: reg num_isis_following right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	esttab using "Tables/Table_5.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace

	
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table 6: Far-right vote share and posting pro-ISIS and anti-West content on Twitter
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	eststo clear
	eststo: reg is_sympathy_count right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	eststo: reg is_life_ff right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	eststo: reg syrian_war_count right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	eststo: reg anti_west_count right_wing_pct unemployed_pct foreigner_pct population population_squared i.country, vce(cluster location_id)
	esttab using "Tables/Table_6.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace

	
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*			
* Table 7: Unemployed immigrants, asylum seekers and support for ISIS on Twitter
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	eststo clear
	eststo: reg upper_1pc_is_topics_1000 right_wing_pct immigrants_unemployed_pct asylum_seekers_std population population_squared i.country, vce(cluster location_id)
	eststo: reg activist_1000 right_wing_pct immigrants_unemployed_pct asylum_seekers_std population population_squared i.country, vce(cluster location_id)
	eststo: reg suspended_1000 right_wing_pct immigrants_unemployed_pct asylum_seekers_std population population_squared i.country, vce(cluster location_id)
	eststo: reg num_isis_following right_wing_pct immigrants_unemployed_pct asylum_seekers_std population population_squared i.country, vce(cluster location_id)
	esttab using "Tables/Table_7.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01)  replace

	
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table 8: Pro-ISIS and Anti-West content in the U.K., additional controls
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	use "Data/Mitts_2018_dataset_UK.dta", clear
	
	eststo clear
	eststo: reg is_sympathy_count right_wing_pct muslim_pct males_pct Pakistani_pct Bangladeshi_pct arab_pct not_born_in_UK_pct unemployed_pct population population_squared, vce(robust)
	eststo: reg is_life_ff right_wing_pct muslim_pct males_pct Pakistani_pct Bangladeshi_pct arab_pct not_born_in_UK_pct unemployed_pct population population_squared, vce(robust)
	eststo: reg syrian_war_count right_wing_pct muslim_pct males_pct Pakistani_pct Bangladeshi_pct arab_pct not_born_in_UK_pct unemployed_pct population population_squared, vce(robust)
	eststo: reg anti_west_count right_wing_pct muslim_pct males_pct Pakistani_pct Bangladeshi_pct arab_pct not_born_in_UK_pct unemployed_pct population population_squared, vce(robust)
	esttab using "Tables/Table_8.tex", b(2) se(2) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace

*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
* Table 9: Terrorist attacks, ISIS propaganda, and changes in pro-ISIS rhetoric
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

	* A. Changes in pro-ISIS content (standard deviation units)
		
		eststo clear
		use "Data/Mitts_2018_event_paris.dta", clear
		eststo: reg is_sympathy_std post  i.country, vce(cluster location_id)	
		eststo: reg isis_topics_std post i.country, vce(cluster location_id)
		
		use "Data/Mitts_2018_event_brussels.dta", clear
		eststo: reg is_sympathy_std post  i.country, vce(cluster location_id)	
		eststo: reg isis_topics_std post i.country, vce(cluster location_id)

		use "Data/Mitts_2018_event_isis_caliphate.dta", clear
		eststo: reg is_sympathy_std post i.country, vce(cluster location_id)	
		eststo: reg isis_topics_std post i.country, vce(cluster location_id)
		
		esttab using "Tables/Table_9a.tex", b(3) se(3) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace
		
	* B. Changes in pro-ISIS content (standard deviation units), by far-right support
		
		eststo clear
		use "Data/Mitts_2018_event_paris.dta", clear
		eststo: reg is_sympathy_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)
		eststo: reg isis_topics_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)	
		
		use "Data/Mitts_2018_event_brussels.dta", clear
		eststo: reg is_sympathy_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)
		eststo: reg isis_topics_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)	

		use "Data/Mitts_2018_event_isis_caliphate.dta", clear
		eststo: reg is_sympathy_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)
		eststo: reg isis_topics_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)	
		
		esttab using "Tables/Table_9b.tex", b(3) se(3) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace

		
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*		
* Table 10: PEGIDA marches and changes in pro-ISIS and anti-West rhetoric
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*		
	
	* A. Changes in pro-ISIS content (sd units)
		
		eststo clear
		use "Data/Mitts_2018_event_pegida.dta", clear
		eststo: reg is_sympathy_std post  i.country, vce(cluster location_id)	
		eststo: reg isis_topics_std post i.country, vce(cluster location_id)	
		eststo: reg isis_topics_anti_west_std post i.country, vce(cluster location_id)	

		esttab using "Tables/Table_10a.tex", b(3) se(3) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace

	* B. Changes in pro-ISIS and far-right content (sd units), by far-right support

		eststo clear
		eststo: reg is_sympathy_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)
		eststo: reg isis_topics_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)	
		eststo: reg isis_topics_anti_west_std i.post##c.right_wing_pct unemployed_pct foreigner_pct population population_squared i.country , vce(cluster location_id)	

		esttab using "Tables/Table_10b.tex", b(3) se(3) r2 ar2 obslast label depvars numbers  star(* 0.10 ** 0.05 *** 0.01) replace


*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*		
* Estimate models on subsamples for Figure 7 (See R script Mitts_2018_Replication_Figures.R 
* to replicate the figure)
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*		

	use "Data/Mitts_2018_event_paris.dta", clear
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 0 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_paris_3day_0.dta",replace)
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 5 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_paris_3day_5.dta",replace)
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 10 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_paris_3day_10.dta",replace)
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 15 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_paris_3day_15.dta",replace)	
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 20 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_paris_3day_20.dta",replace)
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 25 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_paris_3day_25.dta",replace)	
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 30 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_paris_3day_30.dta",replace)
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 35 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_paris_3day_35.dta",replace)
		
	use "Data/Mitts_2018_event_brussels.dta", clear
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 0 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_brussels_3day_0.dta",replace)
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 5 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_brussels_3day_5.dta",replace)
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 10 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_brussels_3day_10.dta",replace)
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 15 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_brussels_3day_15.dta",replace)	
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 20 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_brussels_3day_20.dta",replace)
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 25 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_brussels_3day_25.dta",replace)	
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 30 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_brussels_3day_30.dta",replace)
	reg isis_topics_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 35 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_brussels_3day_35.dta",replace)

	use "Data/Mitts_2018_event_isis_caliphate.dta", clear
	reg is_sympathy_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 0 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_caliphate_3day_0.dta",replace)
	reg is_sympathy_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 5 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_caliphate_3day_5.dta",replace)
	reg is_sympathy_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 10 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_caliphate_3day_10.dta",replace)
	reg is_sympathy_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 15 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_caliphate_3day_15.dta",replace)	
	reg is_sympathy_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 20 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_caliphate_3day_20.dta",replace)
	reg is_sympathy_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 25 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_caliphate_3day_25.dta",replace)	
	reg is_sympathy_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 30 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_caliphate_3day_30.dta",replace)
	reg is_sympathy_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 35 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_caliphate_3day_35.dta",replace)

	use "Data/Mitts_2018_event_pegida.dta", clear
	reg isis_topics_anti_west_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 0 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_pegida_3day_0.dta",replace)
	reg isis_topics_anti_west_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 5 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_pegida_3day_5.dta",replace)
	reg isis_topics_anti_west_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 10 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_pegida_3day_10.dta",replace)
	reg isis_topics_anti_west_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 15 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_pegida_3day_15.dta",replace)	
	reg isis_topics_anti_west_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 20 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_pegida_3day_20.dta",replace)
	reg isis_topics_anti_west_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 25 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_pegida_3day_25.dta",replace)	
	reg isis_topics_anti_west_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 30 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_pegida_3day_30.dta",replace)
	reg isis_topics_anti_west_std post unemployed_pct foreigner_pct population population_squared i.country if right_wing_pct > 35 & right_wing_pct < 46.05409, vce(cluster location_id)	
	parmest, format(estimate min95 max95 %9.3f) lab saving("Temp/all_topics_pegida_3day_35.dta",replace)

