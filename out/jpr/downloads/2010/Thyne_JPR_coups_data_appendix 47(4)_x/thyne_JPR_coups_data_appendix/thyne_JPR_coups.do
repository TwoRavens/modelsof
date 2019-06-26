version 9
#delimit;
clear;
set more off;
set mem 200m; 

/*	****************************************************************	*/
/*	File Name: thyne_JPR_coups.do							*/
/*	Date:	March 17, 2009								*/
/*	Author: Clayton L. Thyne							*/
/*	Purpose: This file replicates the regression results for 		*/
/*	Thyne, Clayton L. (forthcoming). 'Supporter of Stability or 	*/
/*	Agent of Agitation? The Effect of US Foreign Policy on Coups	*/
/*	in Latin America, 1960-1999.' Journal of Peace Research.		*/
/*	Input File: thyne_JPR_coups.dta						*/
/*	Version: Stata 9 or above.							*/
/*	****************************************************************	*/

use thyne_JPR_coups.dta; 

/* Table II. Logistic Regression of Coup Attempts in Latin America, 1960-1999 */

logit coup US_signals US_aid US_mids democracy military_reg instability civil_war gdppc chgdp peace _spline1 _spline2 _spline3, cluster(ccode) nolog;
logit coup pos_signals US_aid  US_mids democracy military_reg instability civil_war gdppc chgdp peace _spline1 _spline2 _spline3, cluster(ccode) nolog;
logit coup neg_signals US_aid US_mids democracy military_reg instability civil_war gdppc chgdp peace _spline1 _spline2 _spline3, cluster(ccode) nolog;

/* Appendix Table 3. Logistic Regression of Coup Attempts in Latin America: Secondary Analyses */

gen inter1=US_signals*US_aid;
label var inter1 "Signals*US aid";
gen inter2=US_signals*US_election_proximity;
label var inter2 "Signals*US elections";
label var US_election_proximity "US elections";
gen inter3=US_signals*LA_election_prox;
label var inter3 "Signals*LA elections";
label var LA_election_prox "LA elections";
gen inter4=US_signals*Consistency;
label var inter4 "Signals*Consistency";

logit coup US_signals inter1 US_aid US_mids democracy military_reg instability civil_war gdppc chgdp peace _spline1 _spline2 _spline3, cluster(ccode) nolog;
	grinter US_signals, inter(inter1) const02(US_aid) yline(0) kden clevel(90) scheme(s1mono) nonote nomean xtitle(3a. US aid/capita (logged));
logit coup US_signals inter2 US_election_proximity US_aid US_mids democracy military_reg instability civil_war gdppc chgdp peace _spline1 _spline2 _spline3, cluster(ccode) nolog;
	grinter US_signals, inter(inter2) const02(US_election_proximity) yline(0) clevel(90) scheme(s1mono) nonote nomean xlabel(0(12)48) xtitle(3b. Time since most recent US election (months));
logit coup inter3 US_signals LA_election_prox US_aid instability gdppc chgdp peace _spline1 _spline2 _spline3, cluster(ccode) nolog;
	grinter US_signals, inter(inter3) const02(LA_election_prox) yline(0) clevel(90) scheme(s1mono) nonote nomean kden xtitle(3c. Time since most recent Latin American election (months));
logit coup inter4 US_signals Consistency US_aid US_mids democracy military_reg instability civil_war gdppc chgdp peace _spline1 _spline2 _spline3, cluster(ccode) nolog;
	grinter US_signals, inter(inter4) const02(Consistency) yline(0) clevel(90) scheme(s1mono) nonote nomean kden xtitle(3d. Duration of Consistent Negative or Positive Signal (months));
logit coup military_signal US_aid US_mids democracy military_reg instability civil_war gdppc chgdp peace _spline1 _spline2 _spline3, cluster(ccode) nolog;
logit coup non_military_signal US_aid US_mids democracy military_reg instability civil_war gdppc chgdp peace _spline1 _spline2 _spline3, cluster(ccode) nolog;