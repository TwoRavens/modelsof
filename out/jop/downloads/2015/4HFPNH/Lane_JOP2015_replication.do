/*******************************************************
Title:		The Intrastate Contagion of Ethnic Civil War
			Replication Data
			
Author:		Matthew A. Lane

Purpose:	This file provides the data and commands necessary to replicate the results found in
			"The Intrastate Contagion of Ethnic Civil War"
*******************************************************/

****************************
****************************
***Load the Replication Data
****************************
clear mata
clear matrix
set more off

use "Lane_JOP2015_repdata.dta", replace


***************************************
***************************************
***MAIN MANUSCRIPT RESULTS
***************************************
***************************************


******************
******************
***Table 1 Results
******************
***Model 1
**********
xtmelogit onset grp_confcount contagionWS status_excl downgraded2 lsize2 lcapdist2 ///
	lexclpop3 lpopl3 lmtnest3 lgdpcapl3 peaceful_grps pyear pyearsq pyearcu ///
	if relevant==1 & status_monopoly!=1||ccode: ||cowgroup: ,cov(uns)
	
***Model 2
**********
xtmelogit onset grp_confcount contagionWS contagionWS_interact status_excl downgraded2 lsize2 lcapdist2 ///
	lexclpop3 lpopl3 lmtnest3 lgdpcapl3 peaceful_grps pyear pyearsq pyearcu ///
	if relevant==1 & status_monopoly!=1||ccode: ||cowgroup: ,cov(uns)
	
***Model 3
**********
xtmelogit parallel_onset grp_confcount contagionWS status_excl downgraded2 lsize2 lcapdist2 ///
	lexclpop3 lpopl3 lmtnest3 lgdpcapl3 peaceful_grps pyear pyearsq pyearcu ///
	if relevant==1 & status_monopoly!=1 & any_conflict==1||ccode: ||cowgroup: ,cov(uns)
	
***Model 4
**********
xtmelogit parallel_onset grp_confcount contagionWS contagionWS_interact status_excl downgraded2 lsize2 lcapdist2 ///
	lexclpop3 lpopl3 lmtnest3 lgdpcapl3 peaceful_grps pyear pyearsq pyearcu ///
	if relevant==1 & status_monopoly!=1 & any_conflict==1||ccode: ||cowgroup: ,cov(uns)
	
	
******************
******************
***Table 2 Results
******************
***Model 5
**********
xtmelogit onset grp_confcount contagionWS contagionWS_interact neigh_excl inter_contagion status_excl downgraded2 ///
	lsize2 lcapdist2 lexclpop3 lpopl3 lmtnest3 lgdpcapl3 peaceful_grps pyear pyearsq pyearcu ///
	if relevant==1 & status_monopoly!=1||ccode: ||cowgroup: ,cov(uns)
	
***Model 6
**********
xtmelogit parallel_onset grp_confcount contagionWS contagionWS_interact neigh_excl inter_contagion status_excl ///
	downgraded2 lsize2 lcapdist2 lexclpop3 lpopl3 lmtnest3 lgdpcapl3 peaceful_grps pyear pyearsq pyearcu ///
	if relevant==1 & status_monopoly!=1 & any_conflict==1||ccode: ||cowgroup: ,cov(uns)
	
	
******************
******************
***Figure 1A
******************
twoway	(line Fig1ALprob FigureX, lcolor(gray) lpattern(dash) lwidth(thin)) ///
	(line Fig1AUprob FigureX, lcolor(gray) lpattern(dash) lwidth(thin)) /// 
	(line Fig1Aprob FigureX, lcolor(black) lpattern(solid) lwidth(medthick)),  ///
	ylabel(0(.05).25, nogrid) ///
	ytitle(Predicted Pr(Conflict Onset in Ethnic Group)) xtitle(Neighborhood Conflict (Weighted Sum)) legend(off) ///
	graphregion(margin(small)) xlabel(0(1)10) xmtick(0(1)10) title(All Conflict Onset, color(black)) graphregion(fcolor(white) lcolor(white) ///
	lpattern(solid) ifcolor(none) ilcolor(none) ilpattern(solid)) plotregion(fcolor(white) style(none) ///
	lpattern(solid) lcolor(white) lwidth(thin) ifcolor(none) ilcolor(white))
	
******************
******************
***Figure 1B
******************
twoway	(line Fig1BLprob FigureX, lcolor(gray) lpattern(dash) lwidth(thin)) ///
	(line Fig1BUprob FigureX, lcolor(gray) lpattern(dash) lwidth(thin)) /// 
	(line Fig1Bprob FigureX, lcolor(black) lpattern(solid) lwidth(medthick)),  ///
	ylabel(0(.1).6, nogrid) ///
	ytitle(Predicted Pr(Parallel Onset in Ethnic Group)) xtitle(Neighborhood Conflict (Weighted Sum)) legend(off) ///
	graphregion(margin(small)) xlabel(0(1)10) xmtick(0(1)10) title(Parallel Conflict Onset, color(black)) graphregion(fcolor(white) lcolor(white) ///
	lpattern(solid) ifcolor(none) ilcolor(none) ilpattern(solid)) plotregion(fcolor(white) style(none) ///
	lpattern(solid) lcolor(white) lwidth(thin) ifcolor(none) ilcolor(white))
	
	
******************
******************
***Figure 2A
******************
twoway	(line Fig2Aldiff FigureX, lcolor(gray) lpattern(dash) lwidth(thin)) ////
	(line Fig2Audiff FigureX, lcolor(gray) lpattern(dash) lwidth(thin)) /// 
	(line Fig2Apdiff FigureX, lcolor(black) lpattern(solid) lwidth(medthick)),  ///
	ylabel(0(.05).15, nogrid) ///
	ytitle(Marginal Effect of Increase in Groups in Conflict) xtitle(Neighborhood Conflict (Weighted Sum)) legend(off) ///
	graphregion(margin(small)) xlabel(0(1)10) xmtick(0(1)10) graphregion(fcolor(white) lcolor(white) ///
	lpattern(solid) ifcolor(none) ilcolor(none) ilpattern(solid)) plotregion(fcolor(white) style(none) ///
	lpattern(solid) lcolor(white) lwidth(thin) ifcolor(none) ilcolor(white)) title(All Conflict Onset, color(black))
	

******************
******************
***Figure 2B
******************	
twoway	(line Fig2Bldiff FigureX, lcolor(gray) lpattern(dash) lwidth(thin)) ////
	(line Fig2Budiff FigureX, lcolor(gray) lpattern(dash) lwidth(thin)) /// 
	(line Fig2Bpdiff FigureX, lcolor(black) lpattern(solid) lwidth(medthick)), ///
	ylabel(0(.05).20, nogrid) ///
	ytitle(Marginal Effect of Increase in Groups in Conflict) xtitle(Neighborhood Conflict (Weighted Sum)) legend(off) ///
	graphregion(margin(small)) xlabel(0(1)10) xmtick(0(1)10) graphregion(fcolor(white) lcolor(white) ///
	lpattern(solid) ifcolor(none) ilcolor(none) ilpattern(solid)) plotregion(fcolor(white) style(none) ///
	lpattern(solid) lcolor(white) lwidth(thin) ifcolor(none) ilcolor(white)) title(Parallel Conflict Onset, color(black))
