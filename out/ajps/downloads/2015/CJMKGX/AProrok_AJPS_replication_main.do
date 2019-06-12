**********************************************************************************************************************************************************
***Do file for Prorok, Alyssa. 2015. "Leader Incentives and Civil War Outcomes." American Journal of Political Science ***
**********************************************************************************************************************************************************

clear
use "AProrok_AJPS.dta", clear


*************************************************
* code to create Figure 1:
*************************************************

*Figure 1, Model 1:
logit waroutcome_extremel culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using figure1.csv, se wide plain unstack replace 

*Figure 1, Model 2:
logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using figure1.csv, se wide plain unstack append

clear
insheet using figure1.csv
rename v1 varname
rename v2 b
rename v3 se
drop if varname==""
drop if varname=="N"
destring b, replace
destring se, replace
gen model=1 if _n<12
replace model=2 if _n>11
gen id=11-_n if _n<12
replace id=22-_n if _n>11
gen min95=b-(1.96*se)
gen max95=b+(1.96*se)

#delimit;
twoway (rcap min95 max95 id if model==1, hor) (scatter id b if model==1),
  xlabel(-2(1)3, labsize(small))
  xtitle(" " "Coefficient Estimates", size(medsmall)) 
  title("Model 1: Extreme War Outcomes", size(med))
  subtitle(" ", size(vsmall))
  ylabel(0 "Constant" 1 "Democracy" 2 "Rebel Political Wing" 3 "Leader Conf Duration(ln)" 
			4 "Incompatibility" 5 "External Troops" 6 "Mediation" 
			7 "Rebel Alliance Duration (ln)" 8 "Multiple Dyads" 
			9 "Relative Strength" 10 "Leader Responsibility", 
			val angle(horizontal) labsize(small)) 
  ytitle("")
  legend(off) 
  xline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  xsize(5.5)
  ysize(4)
  aspectratio(0, placement(east))
  saving(figure1dv1.gph, replace)
;
#delimit cr

#delimit;
twoway (rcap min95 max95 id if model==2, hor) (scatter id b if model==2),
  xlabel(-2(1)3, labsize(small))
  xtitle(" " "Coefficient Estimates", size(medsmall)) 
  title("Model 2: Political Concessions", size(med))
  subtitle(" ", size(vsmall))
  ylabel(0 " " 1 " " 2 " " 3 " " 4 " " 5 " " 6 " " 7 " " 8 " " 9 " " 10 " " , 
			val angle(horizontal) labsize(small)) 
  ytitle("")
  legend(off) 
  xline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  xsize(5.5)
  ysize(4)
  aspectratio(1.2, placement(west))
  saving(figure1dv2.gph, replace)
;
#delimit cr

#delimit;
graph combine figure1dv1.gph figure1dv2.gph,
  col(2)
  title("Figure 1: Logit Results for War Outcomes", size(medlarge))
  subtitle("", size(medsmall))
  note("N = 573 (Model 1), 581 (Model 2)" "95% Confidence Intervals Reported", size(vsmall))
  graphregion(color(white))
  xsize(7)
  scale(1.25)
  ;
#delimit cr
****************************************************************


***********************************************
** Code to Generate Results for Figure 2:
***********************************************

** In order to run the following commands, user must install Clarify from http://gking.harvard.edu/clarify

clear
use "AProrok_AJPS.dta", clear

*Figure 2 (Extreme Outcomes):
estsimp logit waroutcome_extremel culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid) genname(eq1) sims(10000)
* predicted probabilities (figure 2a)
setx culpbdep_dum 0 stronger 0 multdyadsdum 1 lnalliancedur_lstyr mean mediation 0 troopsupport 0 incomp 0 lnldrconf_duration mean rebpolwing2 0 demdum7 0
simqi
setx culpbdep_dum 1 stronger 0 multdyadsdum 1 lnalliancedur_lstyr mean mediation 0 troopsupport 0 incomp 0 lnldrconf_duration mean rebpolwing2 0 demdum7 0
simqi
* first differences (figure 2b)
simqi, fd(pr) changex(culpbdep_dum 0 1)  

*Figure 2 (Political Concessions):
estsimp logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid) sims(10000) genname(eq2)
* predicted probabilities (figure 2a)
setx culpbdep_dum 0 strength_extreme 0 multdyadsdum 1 lnalliancedur_lstyr mean mediation 0 troopsupport 0 incomp 0 lnldrconf_duration mean rebpolwing2 0 demdum7 0
simqi
setx culpbdep_dum 1 strength_extreme 0 multdyadsdum 1 lnalliancedur_lstyr mean mediation 0 troopsupport 0 incomp 0 lnldrconf_duration mean rebpolwing2 0 demdum7 0
simqi
* first differences (figure 2b)
simqi, fd(pr) changex(culpbdep_dum 0 1)  


* Code to create Figure 2:

* predicted probabilities, first differences, and confidence intervals from above copied into figures23.csv file 
** values may differ slightly due to variations when simulating parameters via Clarify **
clear
insheet using figures23.csv
gen fd100=fd*100
gen min95fd100=min95fd*100
gen max95fd100=max95fd*100
gen baselineprob100=baselineprob*100
gen min95baseline100=min95baseline*100
gen max95baseline100=max95baseline*100
gen postchangeprob100=postchangeprob*100
gen pcmin95_100=min95postchange*100
gen pcmax95_100=max95postchange*100
gen equation3=equation+.3 if postchangeprob!=.

* predicted probabilities graph
#delimit;
twoway (bar baselineprob100 equation if equation<3, barw(.3) color(navy)) ||
  (rcap min95baseline100 max95baseline100 equation if equation<3, lw(medthick) color(red)) ||
  (bar postchangeprob100 equation3 if equation<3, barw(.3) color(gs10)) ||
  (rcap pcmin95_100 pcmax95_100 equation3 if equation<3, lw(medthick) color(red)),
  title("A. Predicted Probabilities")
  subtitle("By Leader Responsibility for the War", size(medsmall))
  xlabel(1.15 "Extreme Outcomes" 2.15 "Political Concessions",
			labsize(small))
  xmtick(.65(.5)2.75)
  ylabel(0(20)60, val angle(horizontal))
  ymtick(-5(5)65)
  ytitle("Predicted Probability", size(small))
  yline(0, lstyle(foreground) lpattern(dash) lw(thin) lc(red))
  legend(order(1 3) label(1 "Non-Responsible Leaders") label(3 "Responsible Leaders") size(vsmall))
  graphregion(color(white))
  text(-2 1 "13%", place(s) color(navy) size(small))
  text(-2 1.3 "54%", place(s) color(navy) size(small))
  text(-2 2 "39%", place(s) color(navy) size(small))
  text(-2 2.3 "12%", place(s) color(navy) size(small))
  saving(figure2a.gph, replace)
  ;
#delimit cr

* first difference graph
#delimit;
twoway (bar fd100 equation if equation<3, color(navy) barw(.4)) ||
  (rcap min95fd100 max95fd100 equation if equation<3, lwidth(medthick) color(red)),
  title("B. First Differences")
  subtitle("Baseline: Non-Responsible Leaders", size(medsmall))
  xmtick(.5(1)2.5)
  xlabel(1 "Extreme Outcomes" 2 "Political Concessions",
			labsize(small))
  xtitle("")
  ytitle("Change in Probability from Baseline", size(small))			
  ylabel(-40(20)50, labsize(small) val angle(horizontal))
  legend(off)
  yline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  text(2 1 "41", place(n) color(white) size(small))
  text(-1 2 "-27", place(s) color(white) size(small))
  saving(figure2b.gph, replace)
  ;
#delimit cr

#delimit;
graph combine figure2a.gph figure2b.gph,
  col(2)
  title("Figure 2: Substantive Impact of Leader Responsibility" " ", size(med) span)
  note("Note: 95% Confidence Intervals Reported", size(vsmall))
  graphregion(color(white))
  ;
#delimit cr
******************************************************************************


**********************************************
** Code to Generate Results for Figure 3:
**********************************************
clear
use "AProrok_AJPS.dta", clear

*Figure 3 (Punishment post-estimation):
estsimp logit punish_all culpbdep_dum battlesit_atendwr3 culp3xbatsit lnbdbest lnldrconf_duration locationdum constlimit transitional_ldr, cluster(actorid) genname(eqp1) sims(10000) 
setx culpbdep_dum 0 battlesit_atendwr3 -1 culp3xbatsit 0 lnbdbest 5.308 lnldrconf_duration 3.321 locationdum 0 constlimit 0 transitional_ldr 0     
simqi
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 -1 -1 culp3xbatsit 0 -1)
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 0 0 culp3xbatsit 0 0)
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 1 1 culp3xbatsit 0 1)


* Code to create Figure 3:

* first differences and confidence intervals from above copied into figures23.csv file 
** values may differ slightly due to variations when simulating parameters via Clarify **
clear
insheet using figures23.csv
gen fd100=fd*100
gen min95fd100=min95fd*100
gen max95fd100=max95fd*100
gen baselineprob100=baselineprob*100
gen min95b100=min95b*100
gen max95b100=max95b*100
gen batsit_value3=batsit_value+.3 if equation==3

#delimit;
twoway (bar fd100 batsit_value if equation==3, color(gs10) barw(.4)) 
  (rcap min95fd100 max95fd100 batsit_value if equation==3),
  title("Figure 3: Change in Predicted Probability of Leader Punishment", size(med))
  subtitle("Impact of Leader Responsibility, Conditional on War Performance", size(small))
  xmtick(-1.5(1)1.5)
  xlabel(-1 "Poor Performance" 0 "Status Quo" 1 "Favorable Performance",
			labsize(small))
  xtitle(" ")
  ytitle("Change in Probability from Baseline", size(small))			
  ylabel(-10(10)50, labsize(small) val angle(horizontal))
  legend(off)
  yline(0, lpattern(dash) lw(thin) lc(red))
  note("Note: First Differences with 95% Confidence Intervals Reported" "Baseline: Non-Responsible Leaders", size(vsmall))
  graphregion(color(white))
;
#delimit cr









