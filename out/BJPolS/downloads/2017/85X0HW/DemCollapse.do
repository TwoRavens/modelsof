capture log close
clear
clear mata
clear matrix
set mem 500m
set more off
graph drop _all
cd "c:\users\james\desktop\dropbox\transparency_and_democracy\transparencydemization\demstability\bjpspublishedversion\replicationfiles"


#delimit ;

*	************************************************************************ *;
* 	File-Name: TransDemCollapseRevised.do									 *;
*	Date:  04/07/2017														 *;
*	Author: 	James Hollyer                                                *;
*	Purpose:   Replication file examining the relationship between           *;
*	transparency and auocratic reversions.									 *;
*	************************************************************************ *;

use "FinalSurvivalData.dta";


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

*	************************************************************************ *;
*	The following generates Table 2 in the paper.                            *;
*	************************************************************************ *;

*estout Democracy1 Democracy2  Democracy3 Democracy4 Democracy5 Democracy6 Democracy7 Democracy8 Democracy9
using "demcollapse_revised.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;


*Estimate models without the transparency-growth interaction to;
*test for potential over-fitting.;

stcox lag_transparency lag_growth  lag_GDP lag_open lag_parl 
lag_mixed, nohr strata(prior_transition) cluster(DemocID);

estimates store NoInteract1;

estat phtest, rank detail;

*The model passes the proportional hazards test.;

stcox lag_transparency lag_growth, nohr strata(prior_transition) 
cluster(DemocID);

estimates store NoInteract2;

stcox lag_transparency lag_growth lag_GDP lag_open lag_parl 
lag_mixed, nohr strata(num_transitions) cluster(DemocID);

estimates store NoInteract3;

stcox lag_transparency lag_growth, nohr strata(num_transitions) 
 cluster(DemocID);

 estimates store NoInteract4;
 
stcox lag_transparency lag_growth  lag_GDP lag_open lag_parl 
lag_mixed prior_transition, nohr cluster(DemocID);

estimates store NoInteract5;

stcox lag_transparency lag_growth  prior_transition, 
nohr cluster(DemocID);

estimates store NoInteract6;

*	************************************************************************ *;
*	The following generates Table 2 in the Appendix.  						 *;
*	************************************************************************ *;

*estout NoInteract1 NoInteract2  NoInteract3 NoInteract4 NoInteract5 NoInteract6 
using "demcollapse_nointeract.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;


*Check for non-linearity;

gen lag_transparency2=lag_transparency^2;

stcox lag_transparency lag_transparency2 lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed, nohr strata(prior_transition) cluster(DemocID);

estimates store QuadTerm1;

estat phtest, rank detail;

*The model passes the proportional hazards test.;

stcox lag_transparency lag_transparency2 lag_growth lag_trans_growth, nohr strata(prior_transition) 
cluster(DemocID);

estimates store QuadTerm2;

stcox lag_transparency lag_transparency2 lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed, nohr strata(num_transitions) cluster(DemocID);

estimates store QuadTerm3;

stcox lag_transparency lag_transparency2 lag_growth lag_trans_growth, nohr strata(num_transitions) 
 cluster(DemocID);

 estimates store QuadTerm4;

stcox lag_transparency lag_transparency2 lag_growth lag_trans_growth lag_GDP lag_open lag_parl 
lag_mixed prior_transition, nohr cluster(DemocID);

estimates store QuadTerm5;

stcox lag_transparency lag_transparency2 lag_growth lag_trans_growth prior_transition, 
nohr cluster(DemocID);

estimates store QuadTerm6;


*	************************************************************************ *;
*	The following generates Table 3 in the appendix.						 *;
*	************************************************************************ *;

*estout QuadTerm1 QuadTerm2  QuadTerm3 QuadTerm4 QuadTerm5 QuadTerm6 
using "demcollapse_QuadTerm.tex",
cells(b(star fmt(3)) ci(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) 
stats(N_clust N_fail, labels("\# of Subjects" "\# of Failures")) style(tex) replace;

*Not much evidence of non-linearities.;


*	************************************************************************ *;
*	To get graphical results with the TVC, I need to stsplit the data.  Note *;
*	that the hazard rates won't reflect the changing nature of the effect of *;
*	parl over time, so I just set this variable to 0, as it is not of        *;
*	central interest.														 *;
*	************************************************************************ *;

*	************************************************************************ *;
*	This generates Figure 1 in the text. 									 *;
*	************************************************************************ *;

stcox lag_transparency lag_growth lag_trans_growth prior_transition, nohr cluster(DemocID);

estat phtest, rank detail;

sum transparencyindex, detail;

local translow=r(mean) - r(sd);

local transhigh=r(mean) + r(sd);

sum grgdpch, detail;

local growthlow=r(mean) - r(sd);
local growthhigh=r(mean) + r(sd);

local lowlowint=`translow'*`growthlow';
local lowhighint=`translow'*`growthhigh';

stcurve, hazard at1(lag_transparency=`translow' lag_growth=`growthlow' lag_trans_growth=`lowlowint'
prior_transition=0)
at2(lag_transparency=`translow' lag_growth=`growthhigh' lag_trans_growth=`lowhighint' prior_transition=0)
graphregion(fcolor(white)) ytitle(Hazard Rate) xtitle(Spell Length - Years)
scheme(s2mono) legend(label(1 Low Growth) label(2 High Growth)) title(Low Transparency)
name(lowtrans, replace) nob;

local highlowint=`transhigh'*`growthlow';
local highhighint=`transhigh'*`growthhigh';

di `transhigh';
di `translow';
di `growthhigh';
di `growthlow';
di `highhighint';
di `highlowint';

stcurve, hazard at1(lag_transparency=`transhigh' lag_growth=`growthlow' lag_trans_growth=`highlowint'
prior_transition=0)
at2(lag_transparency=`transhigh' lag_growth=`growthhigh' lag_trans_growth=`highhighint'
prior_transition=0)
graphregion(fcolor(white)) ytitle(Hazard Rate) xtitle(Spell Length - Years)
scheme(s2mono) legend(label(1 Low Growth) label(2 High Growth)) title(High Transparency)
name(hightrans, replace) nob;

graph combine lowtrans hightrans, ycommon graphregion(fcolor(white))
title(Cox Hazard Estimates);

graph export "demcollapse_revised.png",
width(1000) replace;

drop _est*;



