capture log close
clear
clear mata
clear matrix
set mem 500m
set more off
graph drop _all
cd "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencydemization\demstability\bjpspublishedversion\replicationfiles\"


#delimit ;

*	************************************************************************ *;
* 	File-Name: LeadRemovalBJPSRobustness.do									 *;
*	Date:  04/07/17															 *;
*	Author: 	James Hollyer                                                *;
*	************************************************************************ *;

use "LeadSurvivalBJPSRobustness.dta";

stset, clear;

stset endobs, id(leadid) fail(irreg_fail==1) origin(eindate) scale(365.25);

*Start w. robustness to controlling for war.;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed
lag_war, nohr strata(prior_transition) cluster(leadid);

estat phtest, rank detail;

*Passes PH test.;
estimates store War1;

stcox lag_transparency lag_growth lag_trans_growth lag_war, nohr strata(prior_transition) 
cluster(leadid);

estimates store War2;

stcox lag_transparency lag_war, nohr strata(prior_transition) 
cluster(leadid);

estimates store War3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed lag_war, nohr strata(num_transitions) cluster(leadid);

estimates store War4;

stcox lag_transparency lag_growth lag_trans_growth lag_war, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store War5;

stcox lag_transparency lag_war, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store War6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed prior_transition lag_war, nohr cluster(leadid);

estimates store War7;

stcox lag_transparency lag_growth lag_trans_growth prior_transition lag_war, 
nohr cluster(leadid);

estimates store War8;

stcox lag_transparency prior_transition lag_war, 
nohr cluster(leadid);

estimates store War9;

*	************************************************************************ *;
*	The following produces Table 10 in the Appendix. 						 *;
*	************************************************************************ *;

*estout War1 War2  War3 War4 War5 War6 War7 War8 War9
using "War_Irreg.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;


*Now substitute conflict variable for war;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed
lag_conflict, nohr strata(prior_transition) cluster(leadid);

estat phtest, rank detail;

*Passes PH test.;
estimates store Conflict1;

stcox lag_transparency lag_growth lag_trans_growth lag_conflict, nohr strata(prior_transition) 
cluster(leadid);

estimates store Conflict2;

stcox lag_transparency lag_conflict, nohr strata(prior_transition) 
cluster(leadid);

estimates store Conflict3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed lag_conflict, nohr strata(num_transitions) cluster(leadid);

estimates store Conflict4;

stcox lag_transparency lag_growth lag_trans_growth lag_conflict, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store Conflict5;

stcox lag_transparency lag_conflict, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store Conflict6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed prior_transition lag_conflict, nohr cluster(leadid);

estimates store Conflict7;

stcox lag_transparency lag_growth lag_trans_growth prior_transition lag_conflict, 
nohr cluster(leadid);

estimates store Conflict8;

stcox lag_transparency prior_transition lag_conflict, 
nohr cluster(leadid);

estimates store Conflict9;

*	************************************************************************ *;
*	The following produces Table 11 in the Appendix.                         *;
*	************************************************************************ *;

*estout Conflict1 Conflict2  Conflict3 Conflict4 Conflict5 Conflict6 Conflict7 Conflict8 Conflict9
using "Conflict_Irreg.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Now look at natural disasters.;

sort leadid year;

gen lag_disaster=total_disasters[_n-1] if leadid==leadid[_n-1];
gen lag_deaths=ln_total_dead[_n-1] if leadid==leadid[_n-1];

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed
lag_disaster, nohr strata(prior_transition) cluster(leadid);

estat phtest, rank detail;

*Passes PH test.;
estimates store Disaster1;

stcox lag_transparency lag_growth lag_trans_growth lag_disaster, nohr strata(prior_transition) 
cluster(leadid);

estimates store Disaster2;

stcox lag_transparency lag_disaster, nohr strata(prior_transition) 
cluster(leadid);

estimates store Disaster3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed lag_disaster, nohr strata(num_transitions) cluster(leadid);

estimates store Disaster4;

stcox lag_transparency lag_growth lag_trans_growth lag_disaster, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store Disaster5;

stcox lag_transparency lag_disaster, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store Disaster6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed prior_transition lag_disaster, nohr cluster(leadid);

estimates store Disaster7;

stcox lag_transparency lag_growth lag_trans_growth prior_transition lag_disaster, 
nohr cluster(leadid);

estimates store Disaster8;

stcox lag_transparency prior_transition lag_disaster, 
nohr cluster(leadid);

estimates store Disaster9;

*	************************************************************************ *;
*	The following produces Table 12 in the Appendix.						 *;
*	************************************************************************ *;

*estout Disaster1 Disaster2  Disaster3 Disaster4 Disaster5 Disaster6 Disaster7 Disaster8 Disaster9
using "Disaster_Irreg.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Deaths from natural disasters.;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed
lag_deaths, nohr strata(prior_transition) cluster(leadid);

estat phtest, rank detail;

*Passes PH test.;
estimates store Deaths1;

stcox lag_transparency lag_growth lag_trans_growth lag_deaths, nohr strata(prior_transition) 
cluster(leadid);

estimates store Deaths2;

stcox lag_transparency lag_deaths, nohr strata(prior_transition) 
cluster(leadid);

estimates store Deaths3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed lag_deaths, nohr strata(num_transitions) cluster(leadid);

estimates store Deaths4;

stcox lag_transparency lag_growth lag_trans_growth lag_deaths, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store Deaths5;

stcox lag_transparency lag_deaths, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store Deaths6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed prior_transition lag_deaths, nohr cluster(leadid);

estimates store Deaths7;

stcox lag_transparency lag_growth lag_trans_growth prior_transition lag_deaths, 
nohr cluster(leadid);

estimates store Deaths8;

stcox lag_transparency prior_transition lag_deaths, 
nohr cluster(leadid);

estimates store Deaths9;

*	************************************************************************ *;
*	The following produces Table 13 in the Appendix.						 *;
*	************************************************************************ *;


*estout Deaths1 Deaths2  Deaths3 Deaths4 Deaths5 Deaths6 Deaths7 Deaths8 Deaths9
using "Deaths_Irreg.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Military leadership.;

gen lag_open2=lag_open^2;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_open2 lag_parl lag_mixed
nmil, nohr strata(prior_transition) cluster(leadid);

estat phtest, rank detail;

*Openness doesn't pass initial PH test.  Try square?
*Passes PH test.;

estimates store Military1;

stcox lag_transparency lag_growth lag_trans_growth nmil, nohr strata(prior_transition) 
cluster(leadid);

estimates store Military2;

stcox lag_transparency nmil, nohr strata(prior_transition) 
cluster(leadid);

estimates store Military3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_open2 lag_parl lag_mixed nmil, nohr strata(num_transitions) cluster(leadid);

estimates store Military4;

stcox lag_transparency lag_growth lag_trans_growth nmil, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store Military5;

stcox lag_transparency nmil, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store Military6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_open2 lag_parl lag_mixed prior_transition nmil, nohr cluster(leadid);

estimates store Military7;

stcox lag_transparency lag_growth lag_trans_growth prior_transition nmil, 
nohr cluster(leadid);

estimates store Military8;

stcox lag_transparency prior_transition nmil, 
nohr cluster(leadid);

estimates store Military9;

*	************************************************************************ *;
*	The following produces Table 9 in the Appendix.							 *;
*	************************************************************************ *;

*estout Military1 Military2  Military3 Military4 Military5 Military6 Military7 Military8 Military9
using "Military_Irreg.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Now we need to look at regular removal of democratic leaders.  Data is basically the same.;

stset, clear;

stset endobs, id(leadid) fail(reg_fail==1) origin(eindate) scale(365.25);

*Start w. robustness to controlling for war.;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed
lag_war, nohr strata(prior_transition) cluster(leadid);

*Passes PH test.;
estimates store RegWar1;

stcox lag_transparency lag_growth lag_trans_growth lag_war, nohr strata(prior_transition) 
cluster(leadid);

estimates store RegWar2;

stcox lag_transparency lag_war, nohr strata(prior_transition) 
cluster(leadid);

estimates store RegWar3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed lag_war, nohr strata(num_transitions) cluster(leadid);

estimates store RegWar4;

stcox lag_transparency lag_growth lag_trans_growth lag_war, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store RegWar5;

stcox lag_transparency lag_war, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store RegWar6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed prior_transition lag_war, nohr cluster(leadid);

estimates store RegWar7;

stcox lag_transparency lag_growth lag_trans_growth prior_transition lag_war, 
nohr cluster(leadid);

estimates store RegWar8;

stcox lag_transparency prior_transition lag_war, 
nohr cluster(leadid);

estimates store RegWar9;

*	************************************************************************ *;
*	The following produces Table 15 in the Appendix.						 *;
*	************************************************************************ *;

*estout RegWar1 RegWar2  RegWar3 RegWar4 RegWar5 War6 RegWar7 RegWar8 RegWar9
using "War_Reg.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;


*Now substitute conflict variable for war;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed
lag_conflict, nohr strata(prior_transition) cluster(leadid);

estimates store RegConflict1;

stcox lag_transparency lag_growth lag_trans_growth lag_conflict, nohr strata(prior_transition) 
cluster(leadid);

estimates store RegConflict2;

stcox lag_transparency lag_conflict, nohr strata(prior_transition) 
cluster(leadid);

estimates store RegConflict3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed lag_conflict, nohr strata(num_transitions) cluster(leadid);

estimates store RegConflict4;

stcox lag_transparency lag_growth lag_trans_growth lag_conflict, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store RegConflict5;

stcox lag_transparency lag_conflict, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store RegConflict6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed prior_transition lag_conflict, nohr cluster(leadid);

estimates store RegConflict7;

stcox lag_transparency lag_growth lag_trans_growth prior_transition lag_conflict, 
nohr cluster(leadid);

estimates store RegConflict8;

stcox lag_transparency prior_transition lag_conflict, 
nohr cluster(leadid);

estimates store RegConflict9;

*	************************************************************************ *;
*	The following produces Table 16 in the Appendix.						 *;
*	************************************************************************ *;


*estout RegConflict1 RegConflict2  RegConflict3 RegConflict4 RegConflict5 RegConflict6 RegConflict7 RegConflict8 RegConflict9
using "Conflict_Reg.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Now look at natural disasters.;

sort leadid year;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed
lag_disaster, nohr strata(prior_transition) cluster(leadid);

estimates store RegDisaster1;

stcox lag_transparency lag_growth lag_trans_growth lag_disaster, nohr strata(prior_transition) 
cluster(leadid);

estimates store RegDisaster2;

stcox lag_transparency lag_disaster, nohr strata(prior_transition) 
cluster(leadid);

estimates store RegDisaster3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed lag_disaster, nohr strata(num_transitions) cluster(leadid);

estimates store RegDisaster4;

stcox lag_transparency lag_growth lag_trans_growth lag_disaster, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store RegDisaster5;

stcox lag_transparency lag_disaster, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store RegDisaster6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed prior_transition lag_disaster, nohr cluster(leadid);

estimates store RegDisaster7;

stcox lag_transparency lag_growth lag_trans_growth prior_transition lag_disaster, 
nohr cluster(leadid);

estimates store RegDisaster8;

stcox lag_transparency prior_transition lag_disaster, 
nohr cluster(leadid);

estimates store RegDisaster9;

*	************************************************************************ *;
*	The following producces Table 17 in the Appendix. 						 *;
*	************************************************************************ *;

*estout RegDisaster1 RegDisaster2  RegDisaster3 RegDisaster4 RegDisaster5 RegDisaster6 RegDisaster7 RegDisaster8 RegDisaster9
using "Disaster_Reg.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Deaths from natural disasters.;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed
lag_deaths, nohr strata(prior_transition) cluster(leadid);

estimates store RegDeaths1;

stcox lag_transparency lag_growth lag_trans_growth lag_deaths, nohr strata(prior_transition) 
cluster(leadid);

estimates store RegDeaths2;

stcox lag_transparency lag_deaths, nohr strata(prior_transition) 
cluster(leadid);

estimates store RegDeaths3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed lag_deaths, nohr strata(num_transitions) cluster(leadid);

estimates store RegDeaths4;

stcox lag_transparency lag_growth lag_trans_growth lag_deaths, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store RegDeaths5;

stcox lag_transparency lag_deaths, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store RegDeaths6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed prior_transition lag_deaths, nohr cluster(leadid);

estimates store RegDeaths7;

stcox lag_transparency lag_growth lag_trans_growth prior_transition lag_deaths, 
nohr cluster(leadid);

estimates store RegDeaths8;

stcox lag_transparency prior_transition lag_deaths, 
nohr cluster(leadid);

estimates store RegDeaths9;

*	************************************************************************ *;
*	The following produces Table 18 in the Appenix.							 *;
*	************************************************************************ *;

*estout RegDeaths1 RegDeaths2  RegDeaths3 RegDeaths4 RegDeaths5 RegDeaths6 RegDeaths7 RegDeaths8 RegDeaths9
using "Deaths_Reg.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Military leadership.;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl lag_mixed
nmil, nohr strata(prior_transition) cluster(leadid);

estimates store RegMilitary1;

stcox lag_transparency lag_growth lag_trans_growth nmil, nohr strata(prior_transition) 
cluster(leadid);

estimates store RegMilitary2;

stcox lag_transparency nmil, nohr strata(prior_transition) 
cluster(leadid);

estimates store RegMilitary3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open  lag_parl lag_mixed nmil, nohr strata(num_transitions) cluster(leadid);

estimates store RegMilitary4;

stcox lag_transparency lag_growth lag_trans_growth nmil, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store RegMilitary5;

stcox lag_transparency nmil, nohr strata(num_transitions) 
 cluster(leadid);
 
estimates store RegMilitary6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open  lag_parl lag_mixed prior_transition nmil, nohr cluster(leadid);

estimates store RegMilitary7;

stcox lag_transparency lag_growth lag_trans_growth prior_transition nmil, 
nohr cluster(leadid);

estimates store RegMilitary8;

stcox lag_transparency prior_transition nmil, 
nohr cluster(leadid);

estimates store RegMilitary9;

*	************************************************************************ *;
*	The following produces Table 14 in the Appendix.						 *;
*	************************************************************************ *;

*estout RegMilitary1 RegMilitary2  RegMilitary3 RegMilitary4 RegMilitary5 RegMilitary6 RegMilitary7 RegMilitary8 RegMilitary9
using "Military_Reg.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;
