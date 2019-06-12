* This is the master do-file for producing tables and figures in The Morale Effects of Pay Inequality (Breza, Kaur & Shamdasani)

use "finaldataset.dta", replace

global neighbor_all neighbor*
global neighbor_post_noT  neighbor_pn_*
global neighbor_post  neighbor_pt_*
xtset uid

******************* Table 2: Summary Statistics **********************

* Overall sample
sum married numkids hasland sharecrops anymissedmeal30 nofindwork30 bl_numdaysworked bl_numdaysworked_invill bl_totwage endlinewage piecerate_exp baselineprod baselineatt if day_centered==0

* Split by wage treatments	
bysort Het: sum married numkids hasland sharecrops anymissedmeal30 nofindwork30 bl_numdaysworked bl_numdaysworked_invill bl_totwage endlinewage piecerate_exp baselineprod baselineatt if day_centered==0

reg married Het if day_centered==0, cluster(team_id)
reg numkids Het if day_centered==0	, cluster(team_id)
reg hasland Het if day_centered==0, cluster(team_id)
reg sharecrops Het if day_centered==0, cluster(team_id)
reg anymissedmeal30 Het if day_centered==0, cluster(team_id)
reg nofindwork30 Het if day_centered==0, cluster(team_id)
reg bl_numdaysworked  Het if day_centered==0, cluster(team_id)
reg bl_numdaysworked_invill  Het if day_centered==0, cluster(team_id)
reg bl_totwage  Het if day_centered==0, cluster(team_id)
reg endlinewage Het if day_centered==0, cluster(team_id)
reg piecerate_exp Het if day_centered==0, cluster(team_id)
reg baselineprod Het if day_centered==0, cluster(team_id)
reg baselineatt Het if day_centered==0, cluster(team_id)

* Limit to relevant only
reg married Het if day_centered==0 & relevant==1, cluster(team_id)
reg numkids Het if day_centered==0 & relevant==1, cluster(team_id)
reg hasland Het if day_centered==0 & relevant==1, cluster(team_id)
reg sharecrops Het if day_centered==0 & relevant==1, cluster(team_id)
reg anymissedmeal30 Het if day_centered==0 & relevant==1, cluster(team_id)
reg nofindwork30 Het if day_centered==0 & relevant==1, cluster(team_id)
reg bl_numdaysworked  Het if day_centered==0 & relevant==1, cluster(team_id)
reg bl_numdaysworked_invill  Het if day_centered==0 & relevant==1, cluster(team_id)
reg bl_totwage  Het if day_centered==0 & relevant==1, cluster(team_id)
reg endlinewage Het if day_centered==0 & relevant==1, cluster(team_id)
reg piecerate_exp Het if day_centered==0 & relevant==1, cluster(team_id)
reg baselineprod Het if day_centered==0	& relevant==1, cluster(team_id)
reg baselineatt Het if day_centered==0 & relevant==1, cluster(team_id)


******************* Table 3: Knowledge of Co-Worker Wages **********************

* Panel A: Knowledge of other wages on own unit
gen not_dk_team_both = 1- dk_team_both		
gen not_dk_team_one = 1- dk_team_one

bysort Het: sum correctwage correctwage_one not_dk_team_one not_dk_team_both if day_centered==0
		
reg correctwage Het if day_centered==0, cluster(team_id)		
reg correctwage_one Het if day_centered==0, cluster(team_id)		
reg not_dk_team_one Het if day_centered==0, cluster(team_id)				
reg not_dk_team_both Het if day_centered==0, cluster(team_id)  		


* Panel B: Cross-unit comparisons
preserve

keep if day_centered==0
keep round C1 C2 C3 Het uid task_id team_id dk_agarbati dk_wick dk_leafmat dk_paperbag dk_all_agarbati dk_all_wick dk_all_leafmat dk_all_paperbag agarbati_correct wick_correct leafmat_correct paperbag_correct treat_agarbati treat_wick treat_leafmat treat_paperbag

gen correct_1 = agarbati_correct        
gen correct_2 = wick_correct    
gen correct_3 = leafmat_correct 
gen correct_4 = paperbag_correct        
gen dk_1 = dk_agarbati 
gen dk_2 = dk_wick 
gen dk_3 = dk_leafmat 
gen dk_4 = dk_paperbag 
gen dk_all_1 = dk_all_agarbati 
gen dk_all_2 = dk_all_wick 
gen dk_all_3 = dk_all_leafmat 
gen dk_all_4 = dk_all_paperbag 
gen treat_1 = treat_agarbati
gen treat_2 = treat_wick        
gen treat_3 = treat_leafmat     
gen treat_4 = treat_paperbag

keep correct_1 correct_2 correct_3 correct_4 treat_1 treat_2 treat_3 treat_4 dk_1 dk_2 dk_3 dk_4 dk_all_1 dk_all_2 dk_all_3 dk_all_4 round uid team_id task_id
reshape long correct_ dk_ dk_all_ treat_, i(uid) j(taskq)
gen teamHet = (treat_==4)

* Drop if taskq is the same task as a person is on
drop if task_id==1 & taskq==1 
drop if task_id==4 & taskq==2 
drop if task_id==6 & taskq==3 
drop if task_id==9 & taskq==4 

replace correct_=. if treat_==.
replace dk_=. if treat_==.
replace dk_all_=. if treat_==.

gen not_dk_ = 1-dk_
gen not_dk_all_ = 1 - dk_all_

bysort teamHet: su correct_ not_dk_ not_dk_all_

reg correct_ teamHet, cl(team_id)
reg not_dk_ teamHet, cl(team_id)
reg not_dk_all_ teamHet, cl(team_id)

restore

******************* Table 4: Effects of Pay Disparity **********************

*** Panel A: Pooled Treatment Effects
* without FE
qui reg prodnorm posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh low_p med_p high_p treatlow treatmed treathigh irrellow irrelmed irrelhigh  i.day_round exper_task_lin* exper_task_sq* i.task_id $neighbor_all, cl(team_id)
eststo reg1

qui reg attendance posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh low_p med_p high_p treatlow treatmed treathigh irrellow irrelmed irrelhigh  i.day_round exper_task_lin* exper_task_sq* i.task_id $neighbor_all, cl(team_id)
est sto reg2

* with FE
qui xtreg prodnorm posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg3

qui xtreg attendance posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg4

* condl on attendance - no FE
qui reg prodnorm posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh low_p med_p high_p treatlow treatmed treathigh irrellow irrelmed irrelhigh  i.day_round exper_task_lin* exper_task_sq* i.task_id $neighbor_all if attendance==1, cl(team_id)
est sto reg5 

esttab reg1 reg3 reg2 reg4 reg5, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat)

*** Panel B: Treatment Effects Separately by Rank
* without FE
qui reg prodnorm treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh low_p med_p high_p treatlow treatmed treathigh irrellow irrelmed irrelhigh  i.day_round exper_task_lin* exper_task_sq* i.task_id $neighbor_all, cl(team_id)
est sto reg6

qui reg attendance treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh low_p med_p high_p treatlow treatmed treathigh irrellow irrelmed irrelhigh  i.day_round exper_task_lin* exper_task_sq* i.task_id $neighbor_all, cl(team_id)
est sto reg7

* with FE
qui xtreg prodnorm treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg8

qui xtreg attendance treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg9

* condl on attendance - no FE
qui reg prodnorm treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh low_p med_p high_p treatlow treatmed treathigh irrellow irrelmed irrelhigh  i.day_round exper_task_lin* exper_task_sq* i.task_id $neighbor_all if attendance==1, cl(team_id)
est sto reg10 

sum prodnorm attendance if post==1 & Het==0 & relevant==1
sum prodnorm if post==1 & Het==0 & relevant==1 & attendance==1

esttab reg6 reg8 reg7 reg9 reg10, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(treatlowpost treatmedpost treathighpost)


******************* Table 5: Effects Over Time **********************

*** Panel A: Pooled Treatment Effects
***** Before first payday
qui xtreg prodnorm posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh  $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq* if (day_centered<first_post_pay), fe cl(team_id)	
est sto treg1p

qui xtreg attendance posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh  $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*  if (day_centered<first_post_pay), fe cl(team_id)	
est sto treg2p

***** After first, before second payday
qui xtreg prodnorm posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh  $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*  if (day_centered<0 | (day_centered>=first_post_pay & day_centered<second_post_pay)), fe cl(team_id)	
est sto treg3p

qui xtreg attendance posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh  $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*  if (day_centered<0 | (day_centered>=first_post_pay & day_centered<second_post_pay)), fe cl(team_id)	
est sto	 treg4p

***** After second payday
qui xtreg prodnorm posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh  $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq* if (day_centered<0 | (day_centered>=second_post_pay)), fe cl(team_id)	
est sto  treg5p

qui xtreg attendance posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*  if (day_centered<0 | (day_centered>=second_post_pay)), fe cl(team_id)	
est sto	 reg6p

esttab treg1p treg3p treg5p treg2p treg4p treg6p, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat)

*** Panel B: Treatment Effects Separately by Rank
***** Before first payday
qui xtreg prodnorm treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq* if (day_centered<first_post_pay), fe cl(team_id)	
est sto treg1

qui xtreg attendance treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*  if (day_centered<first_post_pay), fe cl(team_id)	
est sto	 treg2

***** After first, before second payday
qui xtreg prodnorm treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*  if (day_centered<0 | (day_centered>=first_post_pay & day_centered<second_post_pay)), fe cl(team_id)	
est sto treg3

qui xtreg attendance treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*  if (day_centered<0 | (day_centered>=first_post_pay & day_centered<second_post_pay)), fe cl(team_id)	
est sto	 treg4

***** After second payday
qui xtreg prodnorm treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq* if (day_centered<0 | (day_centered>=second_post_pay)), fe cl(team_id)	
est sto treg5

qui xtreg attendance treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*  if (day_centered<0 | (day_centered>=second_post_pay)), fe cl(team_id)	
est sto	 treg6

sum prodnorm if post==1 & Het==0 & relevant==1 & (day_centered<first_post_pay)
sum prodnorm if post==1 & Het==0 & relevant==1 & (day_centered>=first_post_pay & day_centered<second_post_pay)
sum prodnorm if post==1 & Het==0 & relevant==1 & (day_centered>=second_post_pay)

sum attendance if post==1 & Het==0 & relevant==1 & (day_centered<first_post_pay)
sum attendance if post==1 & Het==0 & relevant==1 & (day_centered>=first_post_pay & day_centered<second_post_pay)
sum attendance if post==1 & Het==0 & relevant==1 & (day_centered>=second_post_pay)

esttab treg1 treg3 treg5 treg2 treg4 treg6, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(treatlowpost treatmedpost treathighpost)

******************* Table 6: Mediating Effects of Perceived Jusitifications **********************

*** Panel A: Pooled Treatment Effects
*** PRODUCTIVITY DIFFERENCES
qui xtreg prodnorm posttreat Het_largediff_post largediff_post treathighpost highpost irrelpostlow irrelpostmed irrelposthigh irrelpostlow_largediff irrelpostmed_largediff i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto prod1

qui xtreg attendance posttreat Het_largediff_post largediff_post treathighpost highpost irrelpostlow irrelpostmed irrelposthigh irrelpostlow_largediff irrelpostmed_largediff i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto prod2

*** OBSERVABILITY
qui xtreg prodnorm posttreat Het_obs_post obs_post irrelpostlow irrelpostmed irrelposthigh irrelpostlow_obs irrelpostmed_obs irrelposthigh_obs i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto obs1

qui xtreg attendance posttreat Het_obs_post obs_post irrelpostlow irrelpostmed irrelposthigh irrelpostlow_obs irrelpostmed_obs irrelposthigh_obs i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto obs2

*** COMBO: OBSERVABLE OR LARGE PRODUCTIVITY DIFFERENCE
qui xtreg prodnorm posttreat op_or_Het_post op_or_post lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh op_or_irrelpostlow op_or_irrelpostmed op_or_irrelposthigh i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto obsprod1

qui xtreg attendance posttreat op_or_Het_post op_or_post lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh op_or_irrelpostlow op_or_irrelpostmed op_or_irrelposthigh i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto obsprod2

esttab prod1 prod2 obs1 obs2 obsprod1 obsprod2, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat Het_largediff_post largediff_post Het_obs_post obs_post op_or_Het_post op_or_post)

*** Panel B: Treatment Effects Separately by Rank
*** PRODUCTIVITY DIFFERENCES
qui xtreg prodnorm treatlowpost treatmedpost treathighpost treatlowpost_diffup_large treatmedpost_diffup_large lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_diffup_large medpost_diffup_large irrelpostlow_diffup_large irrelpostmed_diffup_large i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
eststo prod3

qui xtreg attendance treatlowpost treatmedpost treathighpost treatlowpost_diffup_large treatmedpost_diffup_large lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_diffup_large medpost_diffup_large irrelpostlow_diffup_large irrelpostmed_diffup_large i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
eststo prod4

*** OBSERVABILITY
qui xtreg prodnorm treatlowpost treatmedpost treathighpost treatlowpost_obs treatmedpost_obs treathighpost_obs lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_obs medpost_obs highpost_obs irrelpostlow_obs irrelpostmed_obs irrelposthigh_obs i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
eststo obs3

qui xtreg attendance treatlowpost treatmedpost treathighpost treatlowpost_obs treatmedpost_obs treathighpost_obs lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_obs medpost_obs highpost_obs irrelpostlow_obs irrelpostmed_obs irrelposthigh_obs i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
eststo obs4

*** COMBO: OBSERVABLE OR LARGE PRODUCTIVITY DIFFERENCE
qui xtreg prodnorm treatlowpost treatmedpost treathighpost op_or_treatlowpost op_or_treatmedpost op_or_treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh op_or_lowpost op_or_medpost op_or_highpost op_or_irrelpostlow op_or_irrelpostmed op_or_irrelposthigh i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto obsprod3

qui xtreg attendance treatlowpost treatmedpost treathighpost op_or_treatlowpost op_or_treatmedpost op_or_treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh op_or_lowpost op_or_medpost op_or_highpost op_or_irrelpostlow op_or_irrelpostmed op_or_irrelposthigh i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto obsprod4

esttab prod3 prod4 obs3 obs4 obsprod3 obsprod4, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(treatlowpost treatlowpost_diffup_large treatmedpost treatmedpost_diffup_large  treatlowpost_obs treatmedpost_obs treathighpost treathighpost_obs op_or_treatlowpost op_or_treatmedpost op_or_treathighpost)


******************* Table 7: Effects of Pay Disparity -- Unit-Level Variation **********************
est sto clear

**** Panel A — Comparison with all Compressed Units
* ATE
qui xtreg prodnorm Het_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto r1
qui xtreg attendance Het_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto r2

* Observability
qui xtreg prodnorm Het_post Het_obs_post obs_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto r3
qui xtreg attendance Het_post Het_obs_post obs_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto r4

* Productivity Differences
qui xtreg prodnorm Het_post Het_largediff_min_post largediff_min_post treathighpost highpost i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto r5
qui xtreg attendance Het_post Het_largediff_min_post  largediff_min_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto r6

* Observability OR Productivity
qui xtreg prodnorm Het_post Het_obsprod_team_or_post  obsprod_team_or_post  i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto r7
qui xtreg attendance Het_post Het_obsprod_team_or_post  obsprod_team_or_post  i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto r8

esttab r1 r2 r3 r4 r5 r6 r7 r8, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) label keep(Het_post Het_obs_post obs_post Het_largediff_min_post  largediff_min_post Het_obsprod_team_or_post  obsprod_team_or_post) 

**** Panel B: omparison with Compressed_Low Units Only
* ATE
qui xtreg prodnorm Het_post C2C3_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto s1
qui xtreg attendance Het_post C2C3_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto s2

* Observability
qui xtreg prodnorm Het_post Het_obs_post C2C3_post C2C3_obs_post obs_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto s3
qui xtreg attendance Het_post Het_obs_post C2C3_post C2C3_obs_post obs_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto s4

* Productivity Differences
qui xtreg prodnorm Het_post Het_largediff_min_post C2C3_post C2C3_largediff_min_post largediff_min_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto s5
qui xtreg attendance Het_post Het_largediff_min_post C2C3_post C2C3_largediff_min_post largediff_min_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto s6

* Observability OR Productivity
qui xtreg prodnorm Het_post Het_obsprod_team_or_post C2C3_post C2C3_obsprod_team_or_post obsprod_team_or_post  i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto s7
qui xtreg attendance Het_post Het_obsprod_team_or_post C2C3_post C2C3_obsprod_team_or_post obsprod_team_or_post  i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto s8

esttab s1 s2 s3 s4 s5 s6 s7 s8, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) label keep(Het_post Het_obs_post obs_post Het_largediff_min_post  largediff_min_post Het_obsprod_team_or_post  obsprod_team_or_post) 

******************* Table 8: Effects of Higher Absolute Pay Among Compressed Units **********************

***** First 2 days
qui xtreg prodnorm C2_post C3_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if Het==0 & day_centered<=1, fe cl(team_id)
est sto GE1
qui xtreg attendance C2_post C3_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if Het==0 & day_centered<=1, fe cl(team_id)
est sto GE2

***** First 5 days
qui xtreg prodnorm C2_post C3_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if Het==0 & day_centered<=4, fe cl(team_id)
est sto GE3
qui xtreg attendance C2_post C3_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if Het==0 & day_centered<=4, fe cl(team_id)
est sto GE4

***** Full Sample
qui xtreg prodnorm C2_post C3_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if Het==0, fe cl(team_id)
est sto GE5
qui xtreg attendance C2_post C3_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if Het==0, fe cl(team_id)
est sto GE6

su prodnorm attendance if C1==1 & day_centered<=1 & post==1
su prodnorm attendance if C1==1 & day_centered<=4 & post==1
su prodnorm attendance if C1==1 & post==1

esttab GE1 GE3 GE5 GE2 GE4 GE6, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(C2_post C3_post)

******************* Table 9: Effects on Group Cohesion: Endline Games 1 **********************

use "el_games1.dta", clear 

qui reg height Het i.round if rank==1 , robust
eststo labg1

qui reg height Het Het_obs obs i.round i.task_id if rank==1, robust
eststo labg2 

qui reg height Het Het_largediff largediff i.round i.task_id if rank==1, robust
eststo labg3 

qui reg height Het Het_justified justified i.round i.task_id if rank==1, robust
eststo labg4 

sum height

esttab labg1 labg2 labg3 labg4, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(Het Het_obs Het_largediff Het_justified)


******************* Table 10: Effects on Group Cohesion: Endline Games 2 **********************

use "el_games2.dta", clear 

qui reg num_correct same_team_het same_team oneHet both_primary_sch both_writesent_oriya   pair_any_relteam i.gameorder i.station_no, cluster(gameround) 
eststo labg2_1

qui reg num_correct same_team_het same_team oneHet anyR2 anyR3 both_primary_sch both_writesent_oriya   pair_any_relteam i.gameorder i.station_no, cluster(gameround) 
eststo labg2_2

qui reg num_correct same_team_het same_team oneHet same_team_het_justified oneHet_justified   both_primary_sch both_writesent_oriya pair_any_relteam anyR2 anyR3 i.gameorder i.station_no, cluster(gameround) 
eststo labg2_3

qui reg num_correct same_team_het same_team oneHet same_team_het_justified oneHet_justified   both_primary_sch both_writesent_oriya pair_any_relteam r11 r12 r13 r22 r23 i.gameorder i.station_no, cluster(gameround) 
eststo labg2_4

test same_team_het+same_team=0
sum num_correct 
		
esttab labg2_1 labg2_2 labg2_3 labg2_4, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(same_team_het same_team oneHet anyR2 anyR3 same_team_het_justified oneHet_justified)


******************* Table 11: Social Cohesion Outside Work: Network Formation **********************

use "finaldataset.dta", replace

global neighbor_all neighbor*
global neighbor_post_noT  neighbor_pn_*
global neighbor_post  neighbor_pt_*
xtset uid

qui xi: reg numlink Het hasrel if day_centered==0 & noEL==0, cluster(team_id)
est sto net1
qui xi: reg numlink i.Het*obsprod_team_or hasrel if day_centered==0 & noEL==0, cluster(team_id)
est sto net2

qui xi: reg indbothlink Het hasrel if day_centered==0 & noEL==0, cluster(team_id)
est sto net3
qui xi: reg indbothlink i.Het*obsprod_team_or hasrel if day_centered==0 & noEL==0, cluster(team_id)
est sto net4

esttab net1 net2 net3 net4, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(Het _IHet_1 _IHetXobspr_1 _cons)


******************* Table 12: Endline Survey: Fairness and Happiness **********************

**** Panel A — Believes wage set fairly relative to co-workers
qui xi: reg fair_wage i.Het*obsprod_or  i.round i.task_id if day_centered==0, cl(team_id)
est sto el1
qui xi: reg fair_wage i.Het*obsprod_or  i.round i.task_id if day_centered==0 & rank==1, cl(team_id)
est sto el2
qui xi: reg fair_wage i.Het*obsprod_or  i.round i.task_id if day_centered==0 & rank==2, cl(team_id)
est sto el3
qui xi: reg fair_wage i.Het*obsprod_or  i.round i.task_id if day_centered==0 & rank==3, cl(team_id)
est sto el4

esttab el1 el2 el3 el4, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(_IHet_1 _IHetXobspr_1 )

**** Panel B — Above-median happiness (World Values Survey)
qui xi: reg happy i.Het*obsprod_or i.round i.task_id if day_centered==0, cl(team_id)
est sto hel1
qui xi: reg happy i.Het*obsprod_or  i.round i.task_id if day_centered==0 & rank==1, cl(team_id)
est sto hel2
qui xi: reg happy i.Het*obsprod_or  i.round i.task_id if day_centered==0 & rank==2, cl(team_id)
est sto hel3
qui xi: reg happy i.Het*obsprod_or  i.round i.task_id if day_centered==0 & rank==3, cl(team_id)
est sto hel4

esttab hel1 hel2 hel3 hel4, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(_IHet_1 _IHetXobspr_1 )


***********************************************************************************************************************
***********************************************************************************************************************


***********************************************************************************************************************
************************* Online Appendix Tables and Figures **********************************************************
***********************************************************************************************************************


******************* Online Appendix Table 1: Summary Statistics by Rank  **********************
bysort Het: su married numkids hasland sharecrops anymissedmeal30 nofindwork30 bl_numdaysworked bl_numdaysworked_invill bl_totwage endlinewage piecerate_exp baselineprod baselineatt if day_centered==0 & relevant==1 & rank==3
bysort Het: su married numkids hasland sharecrops anymissedmeal30 nofindwork30 bl_numdaysworked bl_numdaysworked_invill bl_totwage endlinewage piecerate_exp baselineprod baselineatt if day_centered==0 & relevant==1 & rank==2
bysort Het: su married numkids hasland sharecrops anymissedmeal30 nofindwork30 bl_numdaysworked bl_numdaysworked_invill bl_totwage endlinewage piecerate_exp baselineprod baselineatt if day_centered==0 & relevant==1 & rank==1

reg married Het if day_centered==0  & relevant==1 & rank==3, cluster(team_id)
reg numkids Het if day_centered==0	 & relevant==1  & rank==3, cluster(team_id)
reg hasland Het if day_centered==0  & relevant==1  & rank==3, cluster(team_id)
reg sharecrops Het if day_centered==0  & relevant==1  & rank==3, cluster(team_id)
reg anymissedmeal30 Het if day_centered==0  & relevant==1  & rank==3, cluster(team_id)
reg nofindwork30 Het if day_centered==0  & relevant==1  & rank==3, cluster(team_id)
reg bl_numdaysworked  Het if day_centered==0 & relevant==1  & rank==3, cluster(team_id)
reg bl_numdaysworked_invill  Het if day_centered==0  & relevant==1  & rank==3, cluster(team_id)
reg bl_totwage  Het if day_centered==0  & relevant==1  & rank==3, cluster(team_id)
reg endlinewage Het if day_centered==0 & relevant==1	 & rank==3, cluster(team_id)
reg piecerate_exp Het if day_centered==0	 & relevant==1  & rank==3, cluster(team_id)
reg baselineprod  Het if day_centered==0 & relevant==1  & rank==3, cluster(team_id)
reg baselineatt  Het if day_centered==0  & relevant==1  & rank==3, cluster(team_id)

reg married Het if day_centered==0  & relevant==1 & rank==2, cluster(team_id)
reg numkids Het if day_centered==0	 & relevant==1  & rank==2, cluster(team_id)
reg hasland Het if day_centered==0  & relevant==1  & rank==2, cluster(team_id)
reg sharecrops Het if day_centered==0  & relevant==1  & rank==2, cluster(team_id)
reg anymissedmeal30 Het if day_centered==0  & relevant==1  & rank==2, cluster(team_id)
reg nofindwork30 Het if day_centered==0  & relevant==1  & rank==2, cluster(team_id)
reg bl_numdaysworked  Het if day_centered==0 & relevant==1  & rank==2, cluster(team_id)
reg bl_numdaysworked_invill  Het if day_centered==0  & relevant==1  & rank==2, cluster(team_id)
reg bl_totwage  Het if day_centered==0  & relevant==1  & rank==2, cluster(team_id)
reg endlinewage Het if day_centered==0 & relevant==1	 & rank==2, cluster(team_id)
reg piecerate_exp Het if day_centered==0	 & relevant==1  & rank==2, cluster(team_id)
reg baselineprod  Het if day_centered==0 & relevant==1  & rank==2, cluster(team_id)
reg baselineatt  Het if day_centered==0  & relevant==1  & rank==2, cluster(team_id)

reg married Het if day_centered==0  & relevant==1 & rank==1, cluster(team_id)
reg numkids Het if day_centered==0	 & relevant==1  & rank==1, cluster(team_id)
reg hasland Het if day_centered==0  & relevant==1  & rank==1, cluster(team_id)
reg sharecrops Het if day_centered==0  & relevant==1  & rank==1, cluster(team_id)
reg anymissedmeal30 Het if day_centered==0  & relevant==1  & rank==1, cluster(team_id)
reg nofindwork30 Het if day_centered==0  & relevant==1  & rank==1, cluster(team_id)
reg bl_numdaysworked  Het if day_centered==0 & relevant==1  & rank==1, cluster(team_id)
reg bl_numdaysworked_invill  Het if day_centered==0  & relevant==1  & rank==1, cluster(team_id)
reg bl_totwage  Het if day_centered==0  & relevant==1  & rank==1, cluster(team_id)
reg endlinewage Het if day_centered==0 & relevant==1	 & rank==1, cluster(team_id)
reg piecerate_exp Het if day_centered==0	 & relevant==1  & rank==1, cluster(team_id)
reg baselineprod  Het if day_centered==0 & relevant==1  & rank==1, cluster(team_id)
reg baselineatt  Het if day_centered==0  & relevant==1  & rank==1, cluster(team_id)

reg Het hasland married numkids sharecrops anymissedmeal30 nofindwork30 bl_numdaysworked bl_numdaysworked_invill bl_totwage endlinewage piecerate_exp baselineprod baselineatt  if day_centered==0 & relevant==1 & rank==3, cluster(team_id)
reg Het hasland married numkids sharecrops anymissedmeal30 nofindwork30 bl_numdaysworked bl_numdaysworked_invill bl_totwage endlinewage piecerate_exp baselineprod baselineatt  if day_centered==0 & relevant==1 & rank==2, cluster(team_id)
reg Het hasland married numkids sharecrops anymissedmeal30 nofindwork30 bl_numdaysworked bl_numdaysworked_invill bl_totwage endlinewage piecerate_exp baselineprod baselineatt  if day_centered==0 & relevant==1 & rank==1, cluster(team_id)


******************* Online Appendix Table 2: Effects of Pay Disparity: Robustness to Alternate Specifications **********************

**** Panel A — Pooled Treatment Effects
** No irrelevant people, no neighbor controls
qui xtreg prodnorm posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh i.day_round exper_task_lin* exper_task_sq* if relevant==1, fe cl(team_id)
est sto rreg1p
qui xtreg attendance posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh i.day_round exper_task_lin* exper_task_sq* if relevant==1, fe cl(team_id)
est sto rreg2p

** No irrelevant people, add in neighbor controls
qui xtreg prodnorm posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq* if relevant==1, fe cl(team_id)
est sto rreg3p
qui xtreg attendance posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq* if relevant==1, fe cl(team_id)
est sto rreg4p

** Main specification
qui xtreg prodnorm posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto rreg5p
qui xtreg attendance posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto rreg6p

** Post period only: Add baseline controls for production and attendance
qui reg prodnorm posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_pre_noT $neighbor_pre i.day_round exper_task_lin* exper_task_sq* baselineprod i.task_id if day_centered>=0, cl(team_id)
est sto rreg7p
qui reg attendance posttreat lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_pre_noT $neighbor_pre i.day_round exper_task_lin* exper_task_sq* baselineatt i.task_id if day_centered>=0, cl(team_id)
est sto rreg8p

esttab rreg1p rreg2p rreg3p rreg4p rreg5p rreg6p rreg7p rreg8p, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat)


**** Panel B — Treatment Effects Separately by Rank
** No irrelevant people, no neighbor controls
qui xtreg prodnorm treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh i.day_round exper_task_lin* exper_task_sq* if relevant==1, fe cl(team_id)
est sto rreg1
qui xtreg attendance treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh i.day_round exper_task_lin* exper_task_sq* if relevant==1, fe cl(team_id)
est sto rreg2

** No irrelevant people, add in neighbor controls
qui xtreg prodnorm treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq* if relevant==1, fe cl(team_id)
est sto rreg3
qui xtreg attendance treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq* if relevant==1, fe cl(team_id)
est sto rreg4

** Main specification
qui xtreg prodnorm treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto rreg5
qui xtreg attendance treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto rreg6

** Post period only: Add basleine controls for production and attendance
qui reg prodnorm treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_pre_noT $neighbor_pre i.day_round exper_task_lin* exper_task_sq* baselineprod i.task_id if day_centered>=0, cl(team_id)
est sto rreg7
qui reg attendance treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_pre_noT $neighbor_pre i.day_round exper_task_lin* exper_task_sq* baselineatt i.task_id if day_centered>=0, cl(team_id)
est sto rreg8

sum prodnorm attendance if post==1 & Het==0 & relevant==1

esttab rreg1 rreg2 rreg3 rreg4 rreg5 rreg6 rreg7 rreg8, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(treatlowpost treatmedpost treathighpost)

*esttab rreg1p rreg2p rreg3p rreg4p rreg5p rreg6p rreg7p rreg8p rreg1 rreg2 rreg3 rreg4 rreg5 rreg6 rreg7 rreg8 using "$dir/Results/$date/OATable2.csv", stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat treatlowpost treatmedpost treathighpost)


******************* Online Appendix Table 3: Effects on Output Quality **********************
**** Panel A - Pooled
qui xtreg quality_pct Het_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if attendance==1, fe cl(team_id)
est sto q1
qui xtreg hiquality Het_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if attendance==1, fe cl(team_id)
est sto q2
qui xtreg reject_prop Het_post i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if attendance==1, fe cl(team_id)
est sto q3

esttab q1 q2 q3, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) label keep(Het_post) 

**** Panel B - Separately By Rank
qui xtreg quality_pct treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq* if attendance==1, fe cl(team_id)
est sto q4
qui  xtreg hiquality treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq* if attendance==1, fe cl(team_id)
est sto q5
qui xtreg reject_prop treatlowpost treatmedpost treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq* if attendance==1, fe cl(team_id)
est sto q6

sum quality_pct hiquality reject_prop if post==1 & Het==0

esttab q4 q5 q6, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) label keep(treatlowpost treatmedpost treathighpost) 

*esttab q1 q2 q3 q4 q5 q6 using "$dir/Results/$date/OATable3.csv", stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) label keep(Het_post treatlowpost treatmedpost treathighpost) 


******************* Online Appendix Table 4: Perceived Justifications: Robustness of Relative Productivity Results **********************
** Allow for different trends for low medium and high by baseline productivity
** Continuous
qui xtreg prodnorm posttreat Het_largediff_post largediff_post treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh  lowpost_diffup_large medpost_diffup_large irrelpostlow_largediff irrelpostmed_largediff lowpost_ownpre medpost_ownpre highpost_ownpre i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto pdiffr1

qui xtreg attendance posttreat Het_largediff_post largediff_post treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh  lowpost_diffup_large medpost_diffup_large irrelpostlow_largediff irrelpostmed_largediff lowpost_ownpre medpost_ownpre highpost_ownpre i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto pdiffr2

** Flexibly control for the low guy being in the bottom 10% of the overall baseline dn
qui xtreg prodnorm posttreat Het_largediff_post largediff_post treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh  lowpost_diffup_large medpost_diffup_large irrelpostlow_largediff irrelpostmed_largediff *_ownb10_low_p6 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto pdiffr3

qui xtreg attendance posttreat Het_largediff_post largediff_post treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh  lowpost_diffup_large medpost_diffup_large irrelpostlow_largediff irrelpostmed_largediff *_ownb10_low_p6 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto pdiffr4

* Own preprod 
qui xtreg prodnorm posttreat Het_largediff_post largediff_post treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh  lowpost_diffup_large medpost_diffup_large irrelpostlow_largediff irrelpostmed_largediff *_ownpre_p6 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto pdiffr5

qui xtreg attendance posttreat Het_largediff_post largediff_post treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh  lowpost_diffup_large medpost_diffup_large irrelpostlow_largediff irrelpostmed_largediff *_ownpre_p6 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto pdiffr6

esttab pdiffr1 pdiffr2 pdiffr3 pdiffr4 pdiffr5 pdiffr6, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat Het_largediff_post)

*esttab pdiffr1 pdiffr2 pdiffr3 pdiffr4 pdiffr5 pdiffr6 using "$dir/Results/$date/OATable4.csv", stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat Het_largediff_post)



******************* Online Appendix Table 5: Perceived Justifications: Robustness to Alternative Cutoffs for Relative Productivity Thresholds **********************
* 10%	
qui xtreg prodnorm treatlowmedpost treatLM_distfrac10 treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_distfrac10 medpost_distfrac10 irrelpostlow_distfrac10 irrelpostmed_distfrac10 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto frac1
qui xtreg attendance treatlowmedpost treatLM_distfrac10 treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_distfrac10 medpost_distfrac10 irrelpostlow_distfrac10 irrelpostmed_distfrac10 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto frac2
* 15%	
qui xtreg prodnorm treatlowmedpost treatLM_distfrac15 treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_distfrac15 medpost_distfrac15 irrelpostlow_distfrac15 irrelpostmed_distfrac15 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto frac3
qui xtreg attendance treatlowmedpost treatLM_distfrac15 treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_distfrac15 medpost_distfrac15 irrelpostlow_distfrac15 irrelpostmed_distfrac15 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto frac4
* 20%	
qui xtreg prodnorm treatlowmedpost treatLM_distfrac20 treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_distfrac20 medpost_distfrac20 irrelpostlow_distfrac20 irrelpostmed_distfrac20 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto frac5
qui xtreg attendance treatlowmedpost treatLM_distfrac20 treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_distfrac20 medpost_distfrac20 irrelpostlow_distfrac20 irrelpostmed_distfrac20 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto frac6
* 25%	
qui xtreg prodnorm treatlowmedpost treatLM_distfrac25 treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_distfrac25 medpost_distfrac25 irrelpostlow_distfrac25 irrelpostmed_distfrac25 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto frac7
qui xtreg attendance treatlowmedpost treatLM_distfrac25 treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_distfrac25 medpost_distfrac25 irrelpostlow_distfrac25 irrelpostmed_distfrac25 i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto frac8
* Continuous
qui xtreg prodnorm treatlowmedpost treatLM_dfup6_tc treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_dfup6_tc medpost_dfup6_tc irrelpostlow_dfup6_tc irrelpostmed_dfup6_tc i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto frac9
qui xtreg attendance treatlowmedpost treatLM_dfup6_tc treathighpost lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_dfup6_tc medpost_dfup6_tc irrelpostlow_dfup6_tc irrelpostmed_dfup6_tc i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post, fe cl(team_id)
est sto frac10

esttab frac1 frac2 frac3 frac4 frac5 frac6 frac7 frac8 frac9 frac10, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(treatlowmedpost treatLM_distfrac10 treatLM_distfrac15 treatLM_distfrac20 treatLM_distfrac25 treatLM_dfup6_tc)

*esttab frac1 frac2 frac3 frac4 frac5 frac6 frac7 frac8 frac9 frac10 using "$dir/Results/$date/OATable5.csv", stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(treatlowmedpost treatLM_distfrac10 treatLM_distfrac15 treatLM_distfrac20 treatLM_distfrac25 treatLM_dfup6_tc)


******************* Online Appendix Table 6: Perceived Justifications: Task Observability Robustness **********************

foreach x of numlist 1 3/6 8/12 {
	qui xtreg prodnorm posttreat Het_obs_post lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_obs medpost_obs highpost_obs irrelpostlow_obs irrelpostmed_obs irrelposthigh_obs i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if task_id~=`x', fe cl(team_id)
	est sto obsrobr_p_`x'
	qui xtreg attendance posttreat Het_obs_post lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_obs medpost_obs highpost_obs irrelpostlow_obs irrelpostmed_obs irrelposthigh_obs i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if task_id~=`x', fe cl(team_id)
	est sto obsrobr_a_`x'
}

* Panel A 
esttab obsrobr_p_1 obsrobr_p_3 obsrobr_p_4 obsrobr_p_5 obsrobr_p_6 obsrobr_p_8 obsrobr_p_9 obsrobr_p_10 obsrobr_p_11 obsrobr_p_12, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat Het_obs_post)

* Panel B 
esttab obsrobr_a_1 obsrobr_a_3 obsrobr_a_4 obsrobr_a_5 obsrobr_a_6 obsrobr_a_8 obsrobr_a_9 obsrobr_a_10 obsrobr_a_11 obsrobr_a_12, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat Het_obs_post)

* esttab obsrobr_p_1 obsrobr_p_3 obsrobr_p_4 obsrobr_p_5 obsrobr_p_6 obsrobr_p_8 obsrobr_p_9 obsrobr_p_10 obsrobr_p_11 obsrobr_p_12  using "$dir/Results/$date/OATable6_1.csv", stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat Het_obs_post)
* esttab obsrobr_a_1 obsrobr_a_3 obsrobr_a_4 obsrobr_a_5 obsrobr_a_6 obsrobr_a_8 obsrobr_a_9 obsrobr_a_10 obsrobr_a_11 obsrobr_a_12  using "$dir/Results/$date/OATable6_2.csv", stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat Het_obs_post)


******************* Online Appendix Table 7: Absence of Correlation Between Task Observability Measure and Training Outcomes **********************

qui reg attendance obs i.round if day_centered<0, cl(team_id)
est sto AORreg1

qui reg earlydiff obs i.round if day_centered==0, cl(team_id)
est sto AORreg2

su attendance if day_centered<0 & obs==0
su earlydiff if day_centered==0 & obs==0

esttab AORreg1 AORreg2, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(obs)


******************* Online Appendix Table 8: Sample Overlap Between Perceived Justification Measures **********************
ta diffup_large obs if rank~=1 & day_centered==0, cell


******************* Online Appendix Table 9: Effects of Higher Absolute Pay by Rank **********************
qui xtreg prodnorm Cwage_post_low medpost Cwage_post_med highpost Cwage_post_high i.rank i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if Het==0, fe cl(team_id)
est sto GER1

qui xtreg attendance Cwage_post_low medpost Cwage_post_med highpost Cwage_post_high i.rank i.day_round exper_task_lin* exper_task_sq* $neighbor_post_noT $neighbor_post if Het==0, fe cl(team_id)
est sto GER2

su prodnorm if rank==1 & C1==1 & post==1
su attendance if rank==1 & C1==1 & post==1

esttab GER1 GER2, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(Cwage_post_low medpost Cwage_post_med highpost Cwage_post_high)

*esttab GER1 GER2 using "$dir/Results/$date/OATable9.csv", stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(Cwage_post_low medpost Cwage_post_med highpost Cwage_post_high)


******************* Online Appendix Table 10: Robustness: Effects on Group Cohesion - Conditional on Attendance **********************

	use "el_games1.dta", clear 
	
	qui reg attendance Het i.round , cl(team_id)
	eststo labg3_1 

	qui reg attendance Het C2 C3 i.round , cl(team_id)
	eststo labg3_2 

	qui reg height Het i.round if rank==1 & all_present==1 , robust
	eststo labg3_3

	qui reg height Het C2 C3 i.round if rank==1 & all_present==1 , robust
	eststo labg3_4

	sum attendance 
	sum height if rank==1 & all_present==1 

	use "el_games2.dta", clear 
	qui reg num_correct same_team_het same_team oneHet anyR2 anyR3  both_primary_sch both_writesent_oriya pair_any_relteam i.gameorder i.station_no if absent==0, cluster(gameround) 
	eststo labg3_5

	qui reg num_correct anyR2 anyR3  i.gameorder i.station_no if absent==0, cluster(gameround) 
	eststo labg3_6


	sum num_correct if absent==0
	esttab labg3_1 labg3_2 labg3_3 labg3_4 labg3_5 labg3_6, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(Het C2 C3 same_team_het same_team oneHet anyR2 anyR3)


******************* Online Appendix Table 11: Effects of Pay Disparity by Village Ties **********************
** Panel A — Pooled Treatment Effects

use "finaldataset.dta", replace

global neighbor_all neighbor*
global neighbor_post_noT  neighbor_pn_*
global neighbor_post  neighbor_pt_*
xtset uid

qui xtreg prodnorm posttreat posttreat_allvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_allvill medpost_allvill highpost_allvill irrelpostlow_allvill irrelpostmed_allvill irrelposthigh_allvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg1

qui xtreg attendance posttreat posttreat_allvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_allvill medpost_allvill highpost_allvill irrelpostlow_allvill irrelpostmed_allvill irrelposthigh_allvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg2

qui xtreg prodnorm posttreat posttreat_anyvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_anyvill medpost_anyvill highpost_anyvill irrelpostlow_anyvill irrelpostmed_anyvill irrelposthigh_anyvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg3

qui xtreg attendance posttreat posttreat_anyvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_anyvill medpost_anyvill highpost_anyvill irrelpostlow_anyvill irrelpostmed_anyvill irrelposthigh_anyvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg4

qui xtreg prodnorm posttreat posttreat_numvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_numvill medpost_numvill highpost_numvill irrelpostlow_numvill irrelpostmed_numvill irrelposthigh_numvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg5

qui xtreg attendance posttreat posttreat_numvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_numvill medpost_numvill highpost_numvill irrelpostlow_numvill irrelpostmed_numvill irrelposthigh_numvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg6

esttab reg1 reg2 reg3 reg4 reg5 reg6, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat*)

*esttab reg1 reg2 reg3 reg4 reg5 reg6 using "$dir/Results/$date/OATable11_1.csv", stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(posttreat*)
	
** Panel B — Treatment Effects Separately by Rank
qui xtreg prodnorm treatlowpost treatmedpost treathighpost treatlowpost_allvill treatmedpost_allvill treathighpost_allvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_allvill medpost_allvill highpost_allvill irrelpostlow_allvill irrelpostmed_allvill irrelposthigh_allvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg7

qui xtreg attendance treatlowpost treatmedpost treathighpost treatlowpost_allvill treatmedpost_allvill treathighpost_allvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_allvill medpost_allvill highpost_allvill irrelpostlow_allvill irrelpostmed_allvill irrelposthigh_allvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg8

qui xtreg prodnorm treatlowpost treatmedpost treathighpost treatlowpost_anyvill treatmedpost_anyvill treathighpost_anyvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_anyvill medpost_anyvill highpost_anyvill irrelpostlow_anyvill irrelpostmed_anyvill irrelposthigh_anyvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg9

qui xtreg attendance treatlowpost treatmedpost treathighpost treatlowpost_anyvill treatmedpost_anyvill treathighpost_anyvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_anyvill medpost_anyvill highpost_anyvill irrelpostlow_anyvill irrelpostmed_anyvill irrelposthigh_anyvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg10

xtset uid
qui xtreg prodnorm treatlowpost treatmedpost treathighpost treatlowpost_numvill treatmedpost_numvill treathighpost_numvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_numvill medpost_numvill highpost_numvill irrelpostlow_numvill irrelpostmed_numvill irrelposthigh_numvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg11

qui xtreg attendance treatlowpost treatmedpost treathighpost treatlowpost_numvill treatmedpost_numvill treathighpost_numvill lowpost medpost highpost irrelpostlow irrelpostmed irrelposthigh lowpost_numvill medpost_numvill highpost_numvill irrelpostlow_numvill irrelpostmed_numvill irrelposthigh_numvill $neighbor_post_noT $neighbor_post i.day_round exper_task_lin* exper_task_sq*, fe cl(team_id)
est sto reg12

esttab reg7 reg8 reg9 reg10 reg11 reg12, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(treat*post*)

*esttab reg7 reg8 reg9 reg10 reg11 reg12 using "$dir/Results/$date/OATable11_2.csv", stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(treat*post*)


******************* Online Appendix Table 12: Lack of Evidence of Attendance Peer Effects **********************

** Jack-knife out the entire team
gen VE_jack=.
xtset vill_id

forv i = 1/136 {
	quietly xtreg attendance if team_id != `i', fe 
	predict VE if team_id != `i', u 
	bysort vill_id day_centered: egen overallVE_temp = max(VE)
	bysort vill_id: egen overallVE = max(overallVE_temp)
	replace VE_jack = overallVE if team_id==`i'
	drop overallVE overallVE_temp VE
	}

capture drop temp
bysort team_id day_centered: egen temp = sum(VE_jack)
replace temp=. if day_centered~=0
bysort team_id: egen team_VEjack = max(temp)
capture drop temp

gen peer_VEjack = (team_VEjack - VE_jack)/2 if VE_jack~=.

bysort team_id day_centered: egen team_attend_temp = sum(attendance)
gen peer_attend = (team_attend_temp - attendance)

** First stage
xi: reg peer_attend peer_VEjack VE_jack i.numsame i.month i.day_centered if Het==0, cl(team_id) first
est store FS_PE

** Reduced form
xi: reg attendance peer_VEjack VE_jack i.numsame i.month i.day_centered if Het==0, cl(team_id) first
est store RF_PE

** 2SLS
xi: ivregress 2sls attendance VE_jack i.numsame i.month i.day_centered (peer_attend = peer_VEjack) if Het==0, cl(team_id) first
est store IV_PE

* First stage f-stat
estat firststage

******************* Online Appendix Table 13: Response to Disclosure of Productivity Ranks in Training Period **********************
xtset uid
qui xi: xtreg prodnorm ranking_post2_med ranking_post2_low ranking2_med ranking2_low i.rank_pre i.day_centered_ranking if day_centered<0, fe cluster(team_id)
	test ranking_post2_low = ranking_post2_med
est sto rt1
	
qui xi: xtreg prodnorm ranking_post2_med ranking_post2_low ranking2_med ranking2_low i.rank_pre exper_task_lin* exper_task_sq* i.day_centered_ranking if day_centered<0, fe cluster(team_id)
	test ranking_post2_low = ranking_post2_med
est sto rt2

qui xi: xtreg prodnorm ranking_post2_med ranking_post2_low ranking2_med ranking2_low i.rank_pre i.exper_task_lin1 i.exper_task_lin3 i.exper_task_lin4 i.exper_task_lin5 i.exper_task_lin6 i.exper_task_lin8 i.exper_task_lin9 i.exper_task_lin10 i.exper_task_lin11 i.exper_task_lin12 i.day_centered_ranking if day_centered<0, fe cluster(team_id)
	test ranking_post2_low = ranking_post2_med
est sto rt3
	
qui xi: xtreg attendance ranking_post2_med ranking_post2_low ranking2_med ranking2_low i.rank_pre i.exper_task_lin1 i.exper_task_lin3 i.exper_task_lin4 i.exper_task_lin5 i.exper_task_lin6 i.exper_task_lin8 i.exper_task_lin9 i.exper_task_lin10 i.exper_task_lin11 i.exper_task_lin12 i.day_centered_ranking if day_centered<0, fe cluster(team_id)
	test ranking_post2_low = ranking_post2_med
est sto rt4	
	
sum prodnorm attendance if ranking_sample2==1 & ranking_post2==0 & day_centered<0

esttab rt1 rt2 rt3 rt4, stats(r2 N, labels("R-squared" "N")) se(3) replace starlevels(* 0.10 ** 0.05 *** .01) keep(ranking_post2_med ranking_post2_low)

************************************************************************************************************************************
************************************************************************************************************************************

*************************************************** FIGURES ************************************************************************

******************************** Figure IV: Effects of Pay Disparity on Worker Output **********************************************

**** Commputation of residuals for treatment effects graphs
	* Generate residuals - with Individual FE
	** Compute individual FE for days -1 to -6 + FEST9 FE 
	reg prodnorm i.uid if day_centered<0 & day_centered>-7 & flag_prod_initial==0 & no_neighbors==1
	predict temp, residuals
	reg temp i.festival if flag_prod_initial==0 & no_neighbors==1
	predict prodg if e(sample), residuals
	drop temp

	* Compute means by day_centered
	*egen day_prod_nocontrols = mean(prodnormpre3a) if insample_1==1, by(day_centered rank team_treat)
	egen day_prodg = mean(prodg) if no_neighbors==1, by(day_centered rank treatment)

	* Add in level shifters for each rank (since individual FE removed)
	* reg prodnorm i.rank if sample==1 & day_centered<0 & day_centered>-7
	* low rank reduction relative to medium: di -.5402408 + .3083227 = -.2319181
	* high rank increase relative to media: .3083227
	gen day_prod = day_prodg
	replace day_prod = day_prodg - 0.2319181 if rank==3 
	replace day_prod = day_prodg + 0.3083227 if rank==1

	* Bottom code outliers in training period
	replace day_prod = -1 if rank==1 & Het==1 & day_prod<-1
	replace day_prod = -1 if day_prod<-1

set scheme s2mono
sort day_centered_cal

twoway line day_prod day_centered_cal if rank==3 & C1==1 & day_centered>=-10 & day_centered<=12, xtitle("Day") ytitle("Standardized production residual")  || line day_prod day_centered_cal if rank==3 & Het==1 & day_centered>=-10 & day_centered<=12, xtitle("Day") ytitle("Standardized production residual")
twoway line day_prod day_centered_cal if rank==2 & C2==1 & day_centered>=-10 & day_centered<=12, xtitle("Day") ytitle("Standardized production residual")  || line day_prod day_centered_cal if rank==2 & Het==1 & day_centered>=-10 & day_centered<=12, xtitle("Day") ytitle("Standardized production residual") 
twoway line day_prod day_centered_cal if rank==1 & C3==1 & day_centered>=-10 & day_centered<=12, xtitle("Day") ytitle("Standardized production residual")  || line day_prod day_centered_cal if rank==1 & Het==1 & day_centered>=-10 & day_centered<=12, xtitle("Day") ytitle("Standardized production residual")  

************************** ONLINE APPENDIX FIGURES **********************************************************************

******************* Online Appendix Figure 1: Stability of Relative Productivity Ranks Across Time **********************
** Generate residuals, taking out festival days 
reg prodnorm i.festival  if flag_prod_initial==0 & no_neighbors==1
predict temp  if e(sample), residuals

** Compute means by day_centered
* all compressed together
egen day_prod2 = mean(temp) if Het==0 & flag_prod_initial==0 & no_neighbors==1, by(day_centered rank)
drop temp

sort day_centered_cal
twoway line day_prod2 day_centered_cal if rank==3 & day_centered>=-10 & day_centered<=12, xtitle("Day") ytitle("Standardized production residual") lcolor(blue) || line day_prod2 day_centered_cal if rank==2 & day_centered>=-10 & day_centered<=12, xtitle("Day") ytitle("Standardized production residual") lpattern(dash) lcolor(red)|| line day_prod2 day_centered_cal if rank==1 & day_centered>=-10 & day_centered<=12, xtitle("Day") ytitle("Standardized production residual") lpattern(dot) legend( label(3 High rank workers) label(2 Medium rank workers) label(1 Low rank workers))

******************* Online Appendix Figure 2: Total Attendance for Pay Disparity and Compressed Units ********************
twoway (kdensity fracpresentpost_bc if Het==1 & relevant==1 & day_centered==0, lpattern(dash))(kdensity fracpresentpost_bc if Het==0 & relevant==1 & day_centered==0), legend(order(1 "Pay Disparity" 2 "Compressed" )) xtitle("Fraction of days present in post-wage change period") ytitle("Density")
graph export "$dir/Results/$date/AOFigure2.png", replace

******************* Online Appendix Figure 3: Density of Raw Production by Task, Scaled by Mean *************************
forvalues i=1/10 {
twoway kdensity prod_meanscale if taskid_rank==`i' & attendance==1 & day_centered>-7 & day_centered<0, ytitle("Kernel Density", size(large)) xlabel(0(0.5)3, labsize(medlarge)) ylabel(0(0.2)1, labsize(medlarge)) ysc(r(0 1.1)) xsc(r(0 3)) xtitle("Raw Production Scaled by Task Mean", size(large)) 
* saving("$dir/Results/$date/plot`i'.png", replace)
graph export "$dir/Results/$date/AOFigure3_plot`i'.png", replace
}	

******** Online Appendix Figure 5: Distribution of Village Prevailing Wages: Endline Survey Responses **********************
label var endlinewage_norm "Village wage - Training wage"
twoway (histogram endlinewage_norm if day_centered==0 & endlinewage~=., frac width(10) start(-150))
graph export "$dir/Results/$date/AOFigure5.png", replace






	
	

