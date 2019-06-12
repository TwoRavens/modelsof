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
* 	File-Name: BJPSRobustnessChecks.do										 *;
*	Date:  04/07/17															 *;
*	Author: 	James Hollyer                                                *;
*	************************************************************************ *;

use "BJPSRevisionRobustness.dta";

*The following will just rerun the baseline models.;

stset, clear;

stset year, id(DemocID) fail(fail==1) origin(start_dem);


stcox lag_transparency lag_GDP lag_growth lag_open  lag_parl lag_mixed prior_transition, nohr
cluster(DemocID);

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open  prior_transition lag_parl
lag_mixed, nohr cluster(DemocID);

estat phtest, rank detail;

*Conditional Gap Time Model;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed, nohr strata(prior_transition) cluster(DemocID);

estat phtest, rank detail;

*The model passes the proportional hazards test.;

estimates store Democracy1;

stcox lag_transparency lag_growth lag_trans_growth, nohr strata(prior_transition) 
cluster(DemocID);

estimates store Democracy2;

stcox lag_transparency, nohr strata(prior_transition) 
cluster(DemocID);

estimates store Democracy3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed, nohr strata(num_transitions) cluster(DemocID);

estimates store Democracy4;

stcox lag_transparency lag_growth lag_trans_growth, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store Democracy5;

stcox lag_transparency, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store Democracy6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed prior_transition, nohr cluster(DemocID);

estimates store Democracy7;

stcox lag_transparency lag_growth lag_trans_growth prior_transition, 
nohr cluster(DemocID);

estimates store Democracy8;

stcox lag_transparency prior_transition, 
nohr cluster(DemocID);

estimates store Democracy9;

*Now estimate the same models, controlling for whether a given observation was the "location";
*in the UNCP/PRIO sense, of a war.  Run one for wars and one for both wars and conflicts.;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_war, nohr strata(prior_transition) cluster(DemocID);

estat phtest, rank detail;
*Passes the PH test;

estimates store War1;

stcox lag_transparency lag_growth lag_trans_growth lag_war, nohr strata(prior_transition) 
cluster(DemocID);

estimates store War2;

stcox lag_transparency lag_war, nohr strata(prior_transition) 
cluster(DemocID);

estimates store War3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_war, nohr strata(num_transitions) cluster(DemocID);

estimates store War4;

stcox lag_transparency lag_growth lag_trans_growth lag_war, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store War5;

stcox lag_transparency lag_war, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store War6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_war prior_transition, nohr cluster(DemocID);

estimates store War7;

stcox lag_transparency lag_growth lag_trans_growth lag_war prior_transition, 
nohr cluster(DemocID);

estimates store War8;

stcox lag_transparency lag_war prior_transition, 
nohr cluster(DemocID);

estimates store War9;

*	************************************************************************ *;
*	The following will generate Table 5 in the Appendix.					 *;
*	************************************************************************ *;

*estout War1 War2  War3 War4 War5 War6 War7 War8 War9
using "War_demcollapse.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Now conflict;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_conflict, nohr strata(prior_transition) cluster(DemocID);

estat phtest, rank detail;
*Passes the PH test;

estimates store Confict1;

stcox lag_transparency lag_growth lag_trans_growth lag_conflict, nohr strata(prior_transition) 
cluster(DemocID);

estimates store Confict2;

stcox lag_transparency lag_conflict, nohr strata(prior_transition) 
cluster(DemocID);

estimates store Confict3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_conflict, nohr strata(num_transitions) cluster(DemocID);

estimates store Confict4;

stcox lag_transparency lag_growth lag_trans_growth lag_conflict, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store Confict5;

stcox lag_transparency lag_conflict, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store Confict6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_conflict prior_transition, nohr cluster(DemocID);

estimates store Confict7;

stcox lag_transparency lag_growth lag_trans_growth lag_conflict prior_transition, 
nohr cluster(DemocID);

estimates store Confict8;

stcox lag_transparency lag_conflict prior_transition, 
nohr cluster(DemocID);

estimates store Confict9;

*	************************************************************************ *;
*	The following will generate Table 6 in the Appendix.					 *;
*	************************************************************************ *;

*estout Confict1 Confict2  Confict3 Confict4 Confict5 Confict6 Confict7 Confict8 Confict9
using "Conflict_demcollapse.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Now we can look at lagged natural disasters and totals killed in natural disasters.;

sort DemocID year;

gen lag_disaster=total_disasters[_n-1] if DemocID==DemocID[_n-1];
gen lag_deaths=ln_total_dead[_n-1] if DemocID==DemocID[_n-1];

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_disaster, nohr strata(prior_transition) cluster(DemocID);

estat phtest, rank detail;
*Passes the PH test;
*And, given Alex and Alstair's results, disasters themselves unsurprisingly don't matter.;
estimates store Disaster1;

stcox lag_transparency lag_growth lag_trans_growth lag_disaster, nohr strata(prior_transition) 
cluster(DemocID);

estimates store Disaster2;

stcox lag_transparency lag_disaster, nohr strata(prior_transition) 
cluster(DemocID);

estimates store Disaster3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_disaster, nohr strata(num_transitions) cluster(DemocID);

estimates store Disaster4;

stcox lag_transparency lag_growth lag_trans_growth lag_disaster, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store Disaster5;

stcox lag_transparency lag_disaster, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store Disaster6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_disaster prior_transition, nohr cluster(DemocID);

estimates store Disaster7;

stcox lag_transparency lag_growth lag_trans_growth lag_disaster prior_transition, 
nohr cluster(DemocID);

estimates store Disaster8;

stcox lag_transparency lag_disaster prior_transition, 
nohr cluster(DemocID);

estimates store Disaster9;

*	************************************************************************ *;
*	The following will generate Table 7 in the Appendix.				     *;
*	************************************************************************ *;

*estout Disaster1 Disaster2  Disaster3 Disaster4 Disaster5 Disaster6 Disaster7 Disaster8 Disaster9
using "Disaster_demcollapse.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Okay, now disaster deaths.;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_deaths, nohr strata(prior_transition) cluster(DemocID);

estat phtest, rank detail;
*Passes the PH test;

estimates store Deaths1;

stcox lag_transparency lag_growth lag_trans_growth lag_deaths, nohr strata(prior_transition) 
cluster(DemocID);

estimates store Deaths2;

stcox lag_transparency lag_deaths, nohr strata(prior_transition) 
cluster(DemocID);

estimates store Deaths3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_deaths, nohr strata(num_transitions) cluster(DemocID);

estimates store Deaths4;

stcox lag_transparency lag_growth lag_trans_growth lag_deaths, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store Deaths5;

stcox lag_transparency lag_deaths, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store Deaths6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed lag_deaths prior_transition, nohr cluster(DemocID);

estimates store Deaths7;

stcox lag_transparency lag_growth lag_trans_growth lag_deaths prior_transition, 
nohr cluster(DemocID);

estimates store Deaths8;

stcox lag_transparency lag_deaths prior_transition, 
nohr cluster(DemocID);

estimates store Deaths9;

*	************************************************************************ *;
*	The following will generate Table 8 in the Appendix.					 *;
*	************************************************************************ *;

*estout Deaths1 Deaths2  Deaths3 Deaths4 Deaths5 Deaths6 Deaths7 Deaths8 Deaths9
using "DisDeath_demcollapse.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Finally, we lack any real measure of civil-military relations.  These are all developed for autocracies.;
*We could use the nmil measure from DD...;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed nmil, nohr strata(prior_transition) cluster(DemocID);

estat phtest, rank detail;
*Passes the PH test;

estimates store Mil1;

stcox lag_transparency lag_growth lag_trans_growth nmil, nohr strata(prior_transition) 
cluster(DemocID);

estimates store Mil2;

stcox lag_transparency nmil, nohr strata(prior_transition) 
cluster(DemocID);

estimates store Mil3;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed nmil, nohr strata(num_transitions) cluster(DemocID);

estimates store Mil4;

stcox lag_transparency lag_growth lag_trans_growth nmil, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store Mil5;

stcox lag_transparency nmil, nohr strata(num_transitions) 
 cluster(DemocID);

estimates store Mil6;

stcox lag_transparency lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed nmil prior_transition, nohr cluster(DemocID);

estimates store Mil7;

stcox lag_transparency lag_growth lag_trans_growth nmil prior_transition, 
nohr cluster(DemocID);

estimates store Mil8;

stcox lag_transparency nmil prior_transition, 
nohr cluster(DemocID);

estimates store Mil9;

*	************************************************************************ *;
*	The following will generate Table 4 from the Appendix.					 *;
*	************************************************************************ *;

*estout Mil1 Mil2  Mil3 Mil4 Mil5 Mil6 Mil7 Mil8 Mil9
using "Mil_demcollapse.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;
