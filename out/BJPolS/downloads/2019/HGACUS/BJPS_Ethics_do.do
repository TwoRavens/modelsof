*--------------------------------------------------------------------------------------------------------------------------------------------*
Replication do-file for article entitled "Ethics in elite experiments. A perspective of officials and voters"

Authors: Elin Naurin and Patrik Öhberg, University of Gothenburg
*--------------------------------------------------------------------------------------------------------------------------------------------*
***  The dataset does not include the variable "MP or not" since that would compromise anonymity. The age variable is recoded into six categories.

use "ReplicationDataNaurinOhbergFigure1.dta", clear

*** Figure 1

twoway (bar meanvar place_bar if group==0, barw(2) color(gs10)) ///
       (bar meanvar place_bar if group==1, barw(2) color(gs2)) ///
	   (scatter meanvar place_bar if(place_bar!=30), msym(none) mlab(meanvar) mlabpos(12) mlabcolor(black) mlabsize(small) mlabangle(hor)) ///   
	   (scatter meanvar place_bar if(place_bar==30), msym(none) mlab(meanvar)  mlabpos(12) mlabcolor(black) mlabsize(small) mlabangle(hor) mlabgap(3)) /// 	  
	   (rcap hiwvar lowvar place_bar, lcolor(gs14)), ///   
	   legend(row(1) order(1 "Politicians" 2 "Citizens")) xtitle("") /// 
 xlabel(2 "Contact with assistant" 6.5 "Experiments" 11 "Too long" 15.5 "Too private" 20 "No analyzes" 24.5 "No reports" 29 "Total",  angle (45)) ///
 ylabel(1(1)7  1 "Problematic" 4 "Neither" 7 "Unproblematic", angle (0) format(%9.0f))  /// 
 yline(4,lcolor(black)) ///
 graphregion(fcolor(white))  
 
****

use "ReplicationDataNaurinOhberg.dta", clear 
*** Figure 2
 
cibar cp_ethic_problem, over1(cpgroup_1_2) ///
barlabel(on) blgap(.4) level(95) ///
barcolor(gs10 gs2) baropts(barwidth(.5)) ///
ciopts(yscale(range(1 7)) ylabel(1(1)7) lcolor(gs14)) ///
graphopts(legend(order(1 "Politicians as subjects" 2 "Citizens as subjects")) ylabel( 1.1 "Problematic" 2 3 4 "Neither" 5 6 7 "Unproblematic",  angle (0)) ytitle("") graphregion(color(white))) 
 

***** Figure 3 
 
cibar pp_ethic_problem, over1(ppgroup_1_2) ///
barlabel(on) blgap(.4) level(95) ///
barcolor(gs10 gs2) baropts(barwidth(.5)) ///
ciopts(yscale(range(1 7)) ylabel(1(1)7) lcolor(gs14)) ///
graphopts(legend(order(1 "Politicians as subjects" 2 "Citizens as subjects")) ylabel( 1.1 "Problematic" 2 3 4 "Neither" 5 6 7 "Unproblematic",  angle (0)) ytitle("") graphregion(color(white))) 
  
 
**** Table 1 

eststo: quietly reg incl_experiment Woman edu age6 i.Party if Citizens_Politicians==1
esttab using table1.rtf, r2 b(2) se mtitles("Politicians' approval of survey experiments (OLS)") nonumbers replace
eststo clear 

****Appendix

***Table A1

sum Woman edu ibn.Party if Citizens_Politicians==0

***Table A2

sum Woman edu ibn.Party if Citizens_Politicians==1

***Table A4

oneway age6 citizens_exp_groups, tabulate

oneway Woman citizens_exp_groups, tabulate

oneway edu citizens_exp_groups, tabulate

oneway  Party citizens_exp_groups, tabulate

***Table A5

oneway age6 politicians_exp_groups, tabulate

oneway Woman politicians_exp_groups, tabulate

oneway edu politicians_exp_groups, tabulate

oneway Party politicians_exp_groups, tabulate

***Table A6

eststo: quietly reg incl_experiment Woman edu age6 i.Party if Citizens_Politicians==0
esttab using table1.rtf, r2 b(2) se mtitles("Citizens' approval of survey experiments (OLS)") nonumbers replace
eststo clear

***Figure A1 

** Citizens 

cibar cp_ethic_problem, over1(cp_study_vs_exp) ///
barlabel(on) blgap(.4) level(95) ///
barcolor(gs10 gs2) baropts(barwidth(.5)) ///
ciopts(yscale(range(1 7)) ylabel(1(1)7) lcolor(gs14)) ///
graphopts(legend(order(1 "Study" 2 "Experiment")) ylabel( 1.1 "Problematic" 2 3 4 "Neither" 5 6 7 "Unproblematic",  angle (0)) ytitle("") graphregion(color(white))) 
 

**Politicians 


cibar pp_ethic_problem, over1(pp_study_vs_exp) ///
barlabel(on) blgap(.4) level(95) ///
barcolor(gs10 gs2) baropts(barwidth(.5)) ///
ciopts(yscale(range(1 7)) ylabel(1(1)7) lcolor(gs14)) ///
graphopts(legend(order(1 "Study" 2 "Experiment")) ylabel( 1.1 "Problematic" 2 3 4 "Neither" 5 6 7 "Unproblematic",  angle (0)) ytitle("") graphregion(color(white))) 
 
***Table A7

eststo: quietly reg assist_contact Woman edu age6 i.Party  if Citizens_Politicians==1
eststo: quietly reg survey_time Woman edu age6 i.Party  if Citizens_Politicians==1
eststo: quietly reg too_private Woman edu age6 i.Party if Citizens_Politicians==1
eststo: quietly reg no_analyses Woman edu age6 i.Party if Citizens_Politicians==1
eststo: quietly reg no_reports Woman edu age6  i.Party if Citizens_Politicians==1
esttab using table1.rtf, r2 b(2) se mtitles("Assistant make contact" "Survey too long" "Too private" "No analyses" "No reports") nonumbers replace
eststo clear
