**********************************************************************************************************************************************************
***Do file for SUPPLEMENTARY INFORMATION for Prorok, Alyssa. 2015. "Leader Incentives and Civil War Outcomes." American Journal of Political Science ***
**********************************************************************************************************************************************************

* The commands in this do file replicate the results in the Supplement to "Leader Incentives and Civil War Outcomes"
* commands appear in the order that tables/figures appear in the Supplement.



***********************************************************
* Figure A: Separate Equations for Rebel and State Leaders
***********************************************************
clear
use "AProrok_AJPS.dta", clear

* Extreme Outcomes, Rebel Ldrs Only
logit waroutcome_extremel culpbdep_dum multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2 & rebldr==1, cluster(dyadid)
esttab using statereb_separate.csv, se wide plain unstack replace
* Extreme Outcomes, State Ldrs Only
logit waroutcome_extremel culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2 & stldr==1, cluster(dyadid)
esttab using statereb_separate.csv, se wide plain unstack append

* Political Concessions, Rebel Ldrs Only
logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2 & rebldr==1, cluster(dyadid)
esttab using statereb_separate.csv, se wide plain unstack append
* Political Concessions, State Ldrs Only
logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2 & stldr==1, cluster(dyadid)
esttab using statereb_separate.csv, se wide plain unstack append

clear
insheet using statereb_separate.csv

rename v1 varname
rename v2 b
rename v3 se
drop if varname==""
drop if varname=="N"
destring b, replace
destring se, replace
drop if varname!="culpbdep_dum"
gen model=_n
gen rebldr=.
replace rebldr=1 if model==1 | model==3
replace rebldr=0 if model==2 | model==4 
gen id=.
replace id=.7 if model==4
replace id=1 if model==3
replace id=1.6 if model==2
replace id=1.9 if model==1
gen min95=b-(1.96*se)
gen max95=b+(1.96*se)

*generate coefficient plot (95% CIs)
#delimit;
twoway (rcap min95 max95 id if id!=., hor)
  (scatter id b if id!=. & rebldr==1, color(red))
  (scatter id b if id!=. & rebldr==0, color(gold) symbol(triangle)),
  xlabel(-4(1)4, labsize(small))
  xtitle(" " "Leader Responsibility Coefficient Estimate" " ", size(small)) 
  title("Figure A: Separate Equations for Rebel and State Leaders", size(med))
  subtitle("Leader Responsibility Coefficient Estimates Reported" " ", size(small))
  ylabel(.7 "Concessions" 1 "Concessions" 
			1.6 "Extreme Outcome" 1.9 "Extreme Outcome", 
			val angle(horizontal) labsize(small)) 
  ytitle("")
  ymtick(.4(.3)2.1)
  legend(rows(1) order(2 3) label(2 "Rebel Leaders") label(3 "State Leaders") size(small)) 
  xline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  note("Note: 95% Confidence Intervals Reported", size(vsmall))
  ;
#delimit cr




************************************************************
* Table A: Bivariate Probit Results
************************************************************
clear
use AProrok_AJPS_dyadicdata.dta

* Extreme Outcomes DV
biprobit (waroutcome_extremel_reb culpbdep_dum_reb stronger_reb multdyadsdum lnalliancedur_lstyr_reb mediation_reb troopsupport_reb incomp_reb lnldrconf_duration_reb rebpolwing2 demdum7) (waroutcome_extremel_st culpbdep_dum_st stronger_st multdyadsdum lnalliancedur_lstyr_st mediation_st troopsupport_st incomp_st lnldrconf_duration_st rebpolwing2 demdum7), cluster(dyadid)
* Political Concessions DV	
biprobit (polconcessions_reb culpbdep_dum_reb strength_extreme_reb multdyadsdum lnalliancedur_lstyr_reb mediation_reb troopsupport_reb incomp_reb lnldrconf_duration_reb rebpolwing2 demdum7) (polconcessions_st culpbdep_dum_st strength_extreme_st multdyadsdum lnalliancedur_lstyr_st mediation_st troopsupport_st incomp_st lnldrconf_duration_st rebpolwing2 demdum7), cluster(dyadid)




***************************************************
* Figure B: Alternative DV Specifications
***************************************************
clear
use AProrok_AJPS.dta

* Extreme Outcomes, Original Outcome DV
logit waroutcome_extremel culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altDVs.csv, se wide plain unstack replace
* Extreme Outcomes, Major & Total Wins/Losses
logit waroutcome_extreme culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altDVs.csv, se wide plain unstack append
* Extreme Outcomes, Total Wins/Losses Only
logit waroutcome_extremeh culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altDVs.csv, se wide plain unstack append

* Political Concessions, Original Concessions DV
logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altDVs.csv, se wide plain unstack append
* Political Concessions, All Concessions
logit polcon_inclusive culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altDVs.csv, se wide plain unstack append

clear
insheet using altDVs.csv
rename v1 varname
rename v2 b
rename v3 se
drop if varname==""
drop if varname=="N"
destring b, replace
destring se, replace
drop if varname!="culpbdep_dum"
gen equation=_n
gen model=1 if equation<4
replace model=2 if equation>3
gen id=.
replace id=1.1 if equation==1
replace id=.7 if equation==2
replace id=.3 if equation==3
replace id=.7 if equation==4
replace id=.3 if equation==5
gen originalmodel=.
replace originalmodel=1 if equation==1 | equation==4
gen min95=b-(1.96*se)
gen max95=b+(1.96*se)

*generate coefficient plot (95% CIs)
#delimit;
twoway (rcap min95 max95 id if model==1, hor) 
  (scatter id b if originalmodel!=. & model==1, color(red))
  (scatter id b if originalmodel==. & model==1, color(gold) symbol(triangle)),
  xlabel(-2(1)3, labsize(small))
  xtitle(" ", size(small)) 
  title("Extreme Outcomes", size(med))
  subtitle(" ", size(small))
  ylabel(0.3 "Total Wins/Losses Only" .7 "Major & Total Wins/Losses" 1.1 "Original Outcome DV",
			val angle(horizontal) labsize(small)) 
  ytitle("")
  ymtick(0(.5)1)
  xline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  legend(off)
  saving(altDV_extreme, replace)
;
#delimit cr

#delimit;
twoway (rcap min95 max95 id if model==2, hor) 
  (scatter id b if originalmodel!=. & model==2, color(red))
  (scatter id b if originalmodel==. & model==2, color(gold) symbol(triangle)),
  xlabel(-2(1)3, labsize(small))
  xtitle(" " "Leader Responsibility Coefficient Estimates" " ", size(med)) 
  title("Political Concessions", size(med))
  subtitle(" ", size(small))
  ylabel(0.3 "All Concessions" .7 "   Original Concessions DV",
			val angle(horizontal) labsize(small)) 
  ytitle("")
  ymtick(0(.5)1)
  xline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  legend(off)
  saving(altDV_concessions, replace)
;
#delimit cr
  
#delimit;
graph combine altDV_extreme.gph altDV_concessions.gph,
  col(1)
  title("Figure B: Coefficient Estimates for Alternative DV Specifications", size(med) span)
  note("N = 573 (Extreme Outcomes Models), 581 (Concessions Models)" "95% Confidence Intervals Reported", size(vsmall))
  graphregion(color(white))
  scale(1.1)
  ;
#delimit cr





******************************************************************
* Table B: Multinomial Logit Results, Traditional Outcomes Coding
******************************************************************
clear
use AProrok_AJPS_dyadicdata.dta

mlogit outcome culpnum multdyadsdum lnalliancedur_lstyr_reb strength_extreme_reb mediationdyad balancedinterv lnldrconf_duration_reb lnldrconf_duration_st rebpolwing2 demdum7, cluster(dyadid) base(1)





******************************************************************
* Figure C: Alternative Leader Responsibility Codings
******************************************************************
clear
use AProrok_AJPS.dta

* Extreme Outcomes, Original Responsibility IV
logit waroutcome_extremel culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altIVs.csv, se wide plain unstack replace
* Extreme Outcomes, Start Date Adjustment
logit waroutcome_extremel culp_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altIVs.csv, se wide plain unstack append
* Extreme Outcomes, 3 Category IV
logit waroutcome_extremel culpbdep3cat stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altIVs.csv, se wide plain unstack append
* Extreme Outcomes, Post-Personalist Adjustment
logit waroutcome_extremel culp_p_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altIVs.csv, se wide plain unstack append

* Political Concessions, Original Responsibility IV
logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altIVs.csv, se wide plain unstack append
* Political Concessions, Start Date Adjustment
logit polconcessions culp_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altIVs.csv, se wide plain unstack append
* Political Concessions, 3 Category IV
logit polconcessions culpbdep3cat strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altIVs.csv, se wide plain unstack append
* Political Concessions, Post-Personalist Adjustment
logit polconcessions culp_p_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
esttab using altIVs.csv, se wide plain unstack append

clear
insheet using altIVs.csv
rename v1 varname
rename v2 b
rename v3 se
drop if varname==""
drop if varname=="N"
destring b, replace
destring se, replace
drop if varname!="culpbdep_dum" & varname!="culp_dum" & varname!="culpbdep3cat" & varname!="culp_p_dum"
gen equation=_n
gen model=1 if equation<5
replace model=2 if equation>4
gen id=.
replace id=1.4 if equation==1
replace id=1.1 if equation==2
replace id=.7 if equation==3
replace id=.3 if equation==4
replace id=1.4 if equation==5
replace id=1.1 if equation==6
replace id=.7 if equation==7
replace id=.3 if equation==8
gen originalmodel=.
replace originalmodel=1 if equation==1 | equation==5
gen min95=b-(1.96*se)
gen max95=b+(1.96*se)

#delimit;
twoway (rcap min95 max95 id if model==1, hor) 
  (scatter id b if originalmodel!=. & model==1, color(red))
  (scatter id b if originalmodel==. & model==1, color(gold) symbol(triangle)),
  xlabel(-3(1)4, labsize(small))
  xtitle(" ", size(small)) 
  title("Extreme Outcomes DV" " ", size(med))
  subtitle(" ", size(small))
  ylabel(.3 "Post-Personalist Adjustment" .7 "3 Category IV" 1.1 "Start Date Adjustment" 1.4 "Original Responsibility IV",
			val angle(horizontal) labsize(small)) 
  ytitle("")
  ymtick(0(.5)1.3)
  xline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  legend(off)
  saving(altIV_extreme, replace)
;
#delimit cr

#delimit;
twoway (rcap min95 max95 id if model==2, hor) 
  (scatter id b if originalmodel!=. & model==2, color(red))
  (scatter id b if originalmodel==. & model==2, color(gold) symbol(triangle)),
  xlabel(-3(1)4, labsize(small))
  xtitle(" " "Leader Responsibility Coefficient Estimates", size(med)) 
  title("Political Concessions DV", size(med))
  subtitle(" ", size(small))
  ylabel(.3 "Post-Personalist Adjustment" .7 "3 Category IV" 1.1 "Start Date Adjustment" 1.4 "Original Responsibility IV",
			val angle(horizontal) labsize(small)) 
  ytitle("")
  ymtick(0(.5)1.3)
  xline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  legend(off)
  saving(altIV_concessions, replace)
;
#delimit cr
  
#delimit;
graph combine altIV_extreme.gph altIV_concessions.gph,
  col(1)
  title("Figure C: Alternative Leader Responsibility Codings", size(med) span)
  note("N=573-583 (Models 1-3); N=214-216 (Model 4)" "95% Confidence Intervals Reported", size(vsmall))
  graphregion(color(white))
  ;
#delimit cr






*********************************************************************
* Figure D: Effect of Leader Responsibility over Time
*********************************************************************
clear
use AProrok_AJPS.dta
gen culpxlnldrconfdur=culpbdep_dum*lnldrconf_duration

* Extreme Outcomes (Top Panel)
estsimp logit waroutcome_extremel culpbdep_dum lnldrconf_duration culpxlnldrconfdur stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid) sims(10000) genname(eq3)
setx culpbdep_dum 0 lnldrconf_duration 2.85 culpxlnldrconfdur 0 stronger 0 multdyadsdum 0 lnalliancedur_lstyr mean mediation 0 troopsupport 0 incomp 0 rebpolwing2 0 demdum7 0
simqi
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 0 0 culpxlnldrconfdur 0 0)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration .25 .25 culpxlnldrconfdur 0 .25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration .5 .5 culpxlnldrconfdur 0 .5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration .75 .75 culpxlnldrconfdur 0 .75)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 1 1 culpxlnldrconfdur 0 1)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 1.25 1.25 culpxlnldrconfdur 0 1.25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 1.5 1.5 culpxlnldrconfdur 0 1.5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 1.75 1.75 culpxlnldrconfdur 0 1.75)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 2 2 culpxlnldrconfdur 0 2)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 2.25 2.25 culpxlnldrconfdur 0 2.25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 2.5 2.5 culpxlnldrconfdur 0 2.5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 2.75 2.75 culpxlnldrconfdur 0 2.75)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 3 3 culpxlnldrconfdur 0 3)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 3.25 3.25 culpxlnldrconfdur 0 3.25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 3.5 3.5 culpxlnldrconfdur 0 3.5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 3.75 3.75 culpxlnldrconfdur 0 3.75)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 4 4 culpxlnldrconfdur 0 4)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 4.25 4.25 culpxlnldrconfdur 0 4.25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 4.5 4.5 culpxlnldrconfdur 0 4.5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 4.75 4.75 culpxlnldrconfdur 0 4.75)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 5 5 culpxlnldrconfdur 0 5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 5.25 5.25 culpxlnldrconfdur 0 5.25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 5.5 5.5 culpxlnldrconfdur 0 5.5)

* Political Concessions (Bottom Panel)
estsimp logit polconcessions culpbdep_dum lnldrconf_duration culpxlnldrconfdur strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid) sims(10000) genname(eq4)
setx culpbdep_dum 0 lnldrconf_duration 2.85 culpxlnldrconfdur 0 strength_extreme 0 multdyadsdum 0 lnalliancedur_lstyr mean mediation 0 troopsupport 0 incomp 0 rebpolwing2 0 demdum7 0
simqi
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 0 0 culpxlnldrconfdur 0 0)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration .25 .25 culpxlnldrconfdur 0 .25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration .5 .5 culpxlnldrconfdur 0 .5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration .75 .75 culpxlnldrconfdur 0 .75)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 1 1 culpxlnldrconfdur 0 1)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 1.25 1.25 culpxlnldrconfdur 0 1.25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 1.5 1.5 culpxlnldrconfdur 0 1.5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 1.75 1.75 culpxlnldrconfdur 0 1.75)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 2 2 culpxlnldrconfdur 0 2)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 2.25 2.25 culpxlnldrconfdur 0 2.25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 2.5 2.5 culpxlnldrconfdur 0 2.5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 2.75 2.75 culpxlnldrconfdur 0 2.75)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 3 3 culpxlnldrconfdur 0 3)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 3.25 3.25 culpxlnldrconfdur 0 3.25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 3.5 3.5 culpxlnldrconfdur 0 3.5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 3.75 3.75 culpxlnldrconfdur 0 3.75)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 4 4 culpxlnldrconfdur 0 4)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 4.25 4.25 culpxlnldrconfdur 0 4.25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 4.5 4.5 culpxlnldrconfdur 0 4.5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 4.75 4.75 culpxlnldrconfdur 0 4.75)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 5 5 culpxlnldrconfdur 0 5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 5.25 5.25 culpxlnldrconfdur 0 5.25)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnldrconf_duration 5.5 5.5 culpxlnldrconfdur 0 5.5)
clear

* first differences and confidence intervals from above copied into figures_def.csv file 
** values may differ slightly due to variations when simulating parameters via Clarify **

insheet using figures_def.csv
gen fd100=fd*100
gen min95fd100=min95fd*100
gen max95fd100=max95fd*100

*graph first differences for CULPABLE INTERACTED WITH TIME for both DVs
#delimit;
twoway rarea min95fd100 max95fd100 lnldrconf_duration if equation==1, color(gs14)  
  || line fd100 lnldrconf_duration if equation==1, lc(navy) lw(med)
  || function y=0, range(lnldrconf_duration) lpattern(dash) clcolor(red) 
  ||,
  xlabel(0(.5)5.5)
  xmtick(0(.5)5.5)
  xtitle("Leader Tenure (ln)")
  title("Extreme War Outcomes", size(med))
  ytitle("Change in Predicted Probability", size(small))
  ylabel(0(20)60, val angle(horizontal))
  graphregion(color(white))
  legend(off)
  saving(timeinteract_extreme, replace)
;
#delimit cr

#delimit;
twoway rarea min95fd100 max95fd100 lnldrconf_duration if equation==2, color(gs14)  
  || line fd100 lnldrconf_duration if equation==2, lc(navy) lw(med)
  || function y=0, range(lnldrconf_duration) lpattern(dash) clcolor(red) 
  ||,
  xlabel(0(.5)5.5)
  xmtick(0(.5)5.5)
  xtitle("Leader Tenure (ln)")
  title("Political Concessions", size(med))
  ytitle("Change in Predicted Probability", size(small))
  ylabel(-60(20)10, val angle(horizontal))
  graphregion(color(white))
  legend(off)
  saving(timeinteract_concessions, replace)
;
#delimit cr

#delimit;
graph combine timeinteract_extreme.gph timeinteract_concessions.gph,
  col(1)
  title("Figure D: Effect of Leader Responsibility over Time", size(med))
  note("Baseline: Non-Responsible Leaders" "95% Confidence Intervals Reported", size(small))
  graphregion(color(white))
  ;
#delimit cr




*****************************************************************
* Figure E: Effect of Leader Responsibility by Battle Deaths
*****************************************************************
clear
use AProrok_AJPS.dta
gen culpxlnbdbest=culpbdep_dum*lnbdbest

* Extreme Outcomes (Top Panel)
estsimp logit waroutcome_extremel culpbdep_dum lnbdbest culpxlnbdbest stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid) sims(10000) genname(eqbd1)
setx culpbdep_dum 0 lnbdbest mean culpxlnbdbest 0 stronger 0 multdyadsdum 0 lnalliancedur_lstyr mean mediation 0 troopsupport 0 incomp 0 lnldrconf_duration mean rebpolwing2 0 demdum7 0
simqi
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 0 0 culpxlnbdbest 0 0)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 1 1 culpxlnbdbest 0 1)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 2 2 culpxlnbdbest 0 2)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 3 3 culpxlnbdbest 0 3)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 4 4 culpxlnbdbest 0 4)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 5 5 culpxlnbdbest 0 5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 6 6 culpxlnbdbest 0 6)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 7 7 culpxlnbdbest 0 7)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 8 8 culpxlnbdbest 0 8)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 9 9 culpxlnbdbest 0 9)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 10 10 culpxlnbdbest 0 10)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 11 11 culpxlnbdbest 0 11)

* Political Concessions (Bottom Panel)
estsimp logit polconcessions culpbdep_dum lnbdbest culpxlnbdbest strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid) sims(10000) genname(eqbd2)
setx culpbdep_dum 0 lnbdbest mean culpxlnbdbest 0 strength_extreme 0 multdyadsdum 0 lnalliancedur_lstyr mean mediation 0 troopsupport 0 incomp 0 lnldrconf_duration mean rebpolwing2 0 demdum7 0
simqi
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 0 0 culpxlnbdbest 0 0)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 1 1 culpxlnbdbest 0 1)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 2 2 culpxlnbdbest 0 2)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 3 3 culpxlnbdbest 0 3)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 4 4 culpxlnbdbest 0 4)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 5 5 culpxlnbdbest 0 5)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 6 6 culpxlnbdbest 0 6)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 7 7 culpxlnbdbest 0 7)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 8 8 culpxlnbdbest 0 8)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 9 9 culpxlnbdbest 0 9)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 10 10 culpxlnbdbest 0 10)
simqi, fd(pr) changex(culpbdep_dum 0 1 lnbdbest 11 11 culpxlnbdbest 0 11)
clear

* first differences and confidence intervals from above copied into figures_def.csv file 
** values may differ slightly due to variations when simulating parameters via Clarify **

insheet using figures_def.csv
gen fd100=fd*100
gen min95fd100=min95fd*100
gen max95fd100=max95fd*100

#delimit;
twoway rarea min95fd100 max95fd100 lnbdbest if equation==3, color(gs14)  
  || line fd100 lnbdbest if equation==3, lc(navy) lw(med)
  || function y=0, range(lnbdbest) lpattern(dash) clcolor(red) 
  ||,
  xlabel(0(1)11)
  xmtick(0(1)11)
  xtitle("Battle Deaths (ln)")
  title("Extreme War Outcomes", size(med))
  ytitle("Change in Predicted Probability", size(small))
  ylabel(0(20)80, val angle(horizontal))
  graphregion(color(white))
  legend(off)
  saving(bdbestinteract_extreme, replace)
;
#delimit cr

#delimit;
twoway rarea min95fd100 max95fd100 lnbdbest if equation==4, color(gs14)  
  || line fd100 lnbdbest if equation==4, lc(navy) lw(med)
  || function y=0, range(lnbdbest) lpattern(dash) clcolor(red) 
  ||,
  xlabel(0(1)11)
  xmtick(0(1)11)
  xtitle("Battle Deaths (ln)")
  title("Political Concessions", size(med))
  ytitle("Change in Predicted Probability", size(small))
  ylabel(-60(20)10, val angle(horizontal))
  graphregion(color(white))
  legend(off)
  saving(bdbestinteract_concessions, replace)
;
#delimit cr

#delimit;
graph combine bdbestinteract_extreme.gph bdbestinteract_concessions.gph,
  col(1)
  title("Figure E: Effect of Leader Responsibility by Battle Deaths", size(med))
  note("Baseline: Non-Responsible Leaders" "95% Confidence Intervals Reported", size(small))
  graphregion(color(white))
  ;
#delimit cr





***************************************************
* Table C: Results for Replacement Leaders Only
***************************************************
clear
use Aprorok_AJPS.dta

* Extreme Outcomes
logit waroutcome_extremel culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2 & ldrnum>1, cluster(dyadid)
* Political Concessions
logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2 & ldrnum>1, cluster(dyadid)





***************************************************************************
* Table D: Rare Events Logit Results for Leader Change to Non-Responsible
***************************************************************************

** In order to run the following commands, user must install relogit from http://gking.harvard.edu/relogit

clear
use AProrok_AJPS_monthlybattles.dta

* Model 1 (Deaths IV)
relogit ldrchange_nonculp lnivb_lag milsupport demrebpol lstldrtransitional_nm lstldrpunish_nm count count2 count3, cluster(dyadid)
* Model 2 (Deaths per Battle IV)
relogit ldrchange_nonculp lniva_lag milsupport demrebpol lstldrtransitional_nm lstldrpunish_nm count count2 count3, cluster(dyadid)





**************************************************************************
* Table E: Logit Results for Replacement Leader Responsibility
**************************************************************************
clear
use AProrok_AJPS.dta

logit culp_dum lstldr_endbatsit lstldr_punish lstldr_constlimit lstldr_transitional lstldr_democ, cluster(dyadid)





*********************************************************************
* Table F: Logit Results for Leader Punishment
*********************************************************************
clear
use AProrok_AJPS.dta

* Main Punishment Equation
logit punish_all culpbdep_dum battlesit_atendwr3 culp3xbatsit lnbdbest lnldrconf_duration locationdum constlimit transitional_ldr, cluster(actorid)
* Severe Only (exile, imprisonment, or death):
logit punish_all_cat2 culpbdep_dum battlesit_atendwr3 culp3xbatsit lnbdbest lnldrconf_duration locationdum constlimit transitional_ldr, cluster(actorid) 
* State Leaders Only:
logit punish_all culpbdep_dum battlesit_atendwr3 culp3xbatsit lnbdbest lnldrconf_duration constlimit transitional_ldr if stldr==1, cluster(actorid)
* Rebel Leaders Only:
logit punish_all culpbdep_dum battlesit_atendwr3 culp3xbatsit lnbdbest lnldrconf_duration locationdum if rebldr==1, cluster(actorid) 





*****************************************************
* Figure F: First Differences for Leader Punishment
*****************************************************
* First differences produced using the code below can be used to generate Figure F
clear
use AProrok_AJPS.dta

* Main Punishment Equation
estsimp logit punish_all culpbdep_dum battlesit_atendwr3 culp3xbatsit lnbdbest lnldrconf_duration locationdum constlimit transitional_ldr, cluster(actorid) genname(eqp1) sims(10000) 
setx culpbdep_dum 0 battlesit_atendwr3 -1 culp3xbatsit 0 lnbdbest 5.308 lnldrconf_duration 3.321 locationdum 0 constlimit 0 transitional_ldr 0     
simqi
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 -1 -1 culp3xbatsit 0 -1)
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 0 0 culp3xbatsit 0 0)
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 1 1 culp3xbatsit 0 1)

* Severe Punishment Only 
estsimp logit punish_all_cat2 culpbdep_dum battlesit_atendwr3 culp3xbatsit lnbdbest lnldrconf_duration locationdum constlimit transitional_ldr, cluster(actorid) genname(eqp4) sims(10000) 
setx culpbdep_dum 0 battlesit_atendwr3 -1 culp3xbatsit 0 lnbdbest 5.308 lnldrconf_duration 3.321 locationdum 0 constlimit 0 transitional_ldr 0     
simqi
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 -1 -1 culp3xbatsit 0 -1)
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 0 0 culp3xbatsit 0 0)
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 1 1 culp3xbatsit 0 1)

* Rebel Leaders Only:
estsimp logit punish_all culpbdep_dum battlesit_atendwr3 culp3xbatsit lnbdbest lnldrconf_duration locationdum if rebldr==1, cluster(actorid) genname(eqp7) sims(10000) 
setx culpbdep_dum 0 battlesit_atendwr3 -1 culp3xbatsit 0 lnbdbest 5.308 lnldrconf_duration 3.321 locationdum 0     
simqi
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 -1 -1 culp3xbatsit 0 -1)
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 0 0 culp3xbatsit 0 0)
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 1 1 culp3xbatsit 0 1)

* State Leaders Only:
estsimp logit punish_all culpbdep_dum battlesit_atendwr3 culp3xbatsit lnbdbest lnldrconf_duration constlimit transitional_ldr if stldr==1, cluster(actorid) genname(eqp5) sims(10000) 
setx culpbdep_dum 0 battlesit_atendwr3 -1 culp3xbatsit 0 lnbdbest 5.308 lnldrconf_duration 3.321 constlimit 0 transitional_ldr 0     
simqi
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 -1 -1 culp3xbatsit 0 -1)
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 0 0 culp3xbatsit 0 0)
simqi, fd(pr) changex(culpbdep_dum 0 1 battlesit_atendwr3 1 1 culp3xbatsit 0 1)
clear

insheet using figures_def.csv
gen fd100=fd*100
gen min95fd100=min95fd*100
gen max95fd100=max95fd*100

#delimit;
twoway (bar fd100 batsit_value if equation==5, color(gs10) barw(.4)) 
  (rcap min95fd100 max95fd100 batsit_value if equation==5),
  title("A. Main Punishment Equation", size(med))
  xmtick(-1.5(1)1.5)
  xlabel(-1 "Poor Performance" 0 "Status Quo" 1 "Favorable",
			labsize(small))
  xtitle(" ")
  ytitle("Change in Probability", size(small))			
  ylabel(-10(10)50, labsize(small) val angle(horizontal))
  legend(off)
  yline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  saving(punishmain, replace)
;
#delimit cr
 
#delimit;
twoway (bar fd100 batsit_value if equation==6, color(gs10) barw(.4)) 
  (rcap min95fd100 max95fd100 batsit_value if equation==6),
  title("B. Severe Punishment Only", size(med))
  xmtick(-1.5(1)1.5)
  xlabel(-1 "Poor Performance" 0 "Status Quo" 1 "Favorable",
			labsize(small))
  xtitle(" ")
  ytitle("Change in Probability", size(small))			
  ylabel(-10(10)50, labsize(small) val angle(horizontal))
  legend(off)
  yline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  saving(punishsevere, replace)
;
#delimit cr

#delimit;
twoway (bar fd100 batsit_value if equation==8, color(gs10) barw(.4)) 
  (rcap min95fd100 max95fd100 batsit_value if equation==8),
  title("C. Rebel Leaders Only", size(med))
  xmtick(-1.5(1)1.5)
  xlabel(-1 "Poor Performance" 0 "Status Quo" 1 "Favorable",
			labsize(small))
  xtitle(" ")
  ytitle("Change in Probability", size(small))			
  ylabel(-10(10)50, labsize(small) val angle(horizontal))
  legend(off)
  yline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  saving(punishrebel, replace)
;
#delimit cr

#delimit;
twoway (bar fd100 batsit_value if equation==7, color(gs10) barw(.4)) 
  (rcap min95fd100 max95fd100 batsit_value if equation==7),
  title("D. State Leaders Only", size(med))
  xmtick(-1.5(1)1.5)
  xlabel(-1 "Poor Performance" 0 "Status Quo" 1 "Favorable",
			labsize(small))
  xtitle(" ")
  ytitle("Change in Probability", size(small))			
  ylabel(-20(10)50, labsize(small) val angle(horizontal))
  legend(off)
  yline(0, lpattern(dash) lw(thin) lc(red))
  graphregion(color(white))
  saving(punishstate, replace)
;
#delimit cr

#delimit;
graph combine punishmain.gph punishsevere.gph punishrebel.gph punishstate.gph,
  col(2)
  title("Figure F: First Differences for Leader Punishment", size(medlarge))
  subtitle("Impact of Leader Responsibility, Conditional on War Performance", size(medsmall))
  note("Note: 95% Confidence Intervals Reported" "Baseline: Non-Responsible Leaders", size(vsmall))
  graphregion(color(white))
  ;
#delimit cr





********************************************************
* Table G: Descriptive Statistics for Control Variables
********************************************************
clear
use AProrok_AJPS.dta

logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
sum stronger if e(sample)
tab stronger if e(sample)
sum strength_extreme if e(sample)
tab strength_extreme if e(sample)
sum multdyadsdum if e(sample)
tab multdyadsdum if e(sample)
sum lnalliancedur_lstyr if e(sample)
sum mediation if e(sample)
tab mediation if e(sample)
sum troopsupport if e(sample)
tab troopsupport if e(sample)
sum incomp if e(sample)
tab incomp if e(sample)
sum lnldrconf_duration if e(sample)
sum rebpolwing2 if e(sample)
tab rebpolwing2 if e(sample)
sum demdum7 if e(sample)
tab demdum7 if e(sample)

logit punish_all culpbdep_dum battlesit_atendwr3 culp3xbatsit lnbdbest lnldrconf_duration locationdum constlimit transitional_ldr, cluster(actorid) 
sum lnbdbest if e(sample)
sum lnldrconf_duration if e(sample)
sum locationdum if e(sample)
tab locationdum if e(sample)
sum constlimit if e(sample)
tab constlimit if e(sample)
sum transitional_ldr if e(sample)
tab transitional_ldr if e(sample)





******************************************************
* Table H: Substantive Results for Control Variables
******************************************************
clear
use AProrok_AJPS.dta
* Predicted Probabilities and First Differences may vary slightly from those presented in ///
** Table H due to variations in simulated values.

* Political Concessions Model
estsimp logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid) sims(10000) genname(eq2)
setx culpbdep_dum 1 strength_extreme 0 multdyadsdum 1 lnalliancedur_lstyr mean mediation 0 troopsupport 0 incomp 0 lnldrconf_duration mean rebpolwing2 0 demdum7 0
simqi
simqi, fd(pr) changex(strength_extreme 0 1)
simqi, fd(pr) changex(mediation 0 1)
simqi, fd(pr) changex(troopsupport 0 1) 
simqi, fd(pr) changex(rebpolwing2 0 1) 
simqi, fd(pr) changex(demdum7 0 1)
simqi, fd(pr) changex(incomp 0 1)
setx culpbdep_dum 1 strength_extreme 0 multdyadsdum 0 lnalliancedur_lstyr 0 mediation 0 troopsupport 0 incomp 0 lnldrconf_duration mean rebpolwing2 0 demdum7 0
simqi
simqi, fd(pr) changex(multdyadsdum 0 1)
setx culpbdep_dum 1 strength_extreme 0 multdyadsdum 0 lnalliancedur_lstyr 0 mediation 0 troopsupport 0 incomp 0 lnldrconf_duration mean rebpolwing2 0 demdum7 0
simqi
simqi, fd(pr) changex(lnalliancedur_lstyr 0 1.792)
setx culpbdep_dum 1 strength_extreme 0 multdyadsdum 1 lnalliancedur_lstyr mean mediation 0 troopsupport 0 incomp 0 lnldrconf_duration 0 rebpolwing2 0 demdum7 0
simqi
simqi, fd(pr) changex(lnldrconf_duration 0 4.394)

* Punishment Model
estsimp logit punish_all culpbdep_dum battlesit_atendwr3 culp3xbatsit lnbdbest lnldrconf_duration locationdum constlimit transitional_ldr, cluster(actorid) genname(eqp1) sims(10000) 
setx culpbdep_dum 0 battlesit_atendwr3 0 culp3xbatsit 0 lnbdbest 2.985 lnldrconf_duration 3.321 locationdum 0 constlimit 0 transitional_ldr 0     
simqi
simqi, fd(pr) changex(lnbdbest 2.985 8.35)
setx culpbdep_dum 0 battlesit_atendwr3 0 culp3xbatsit 0 lnbdbest 5.308 lnldrconf_duration 1.099 locationdum 0 constlimit 0 transitional_ldr 0     
simqi
simqi, fd(pr) changex(lnldrconf_duration 1.099 5.153)
setx culpbdep_dum 0 battlesit_atendwr3 -1 culp3xbatsit 0 lnbdbest 5.308 lnldrconf_duration 3.321 locationdum 0 constlimit 0 transitional_ldr 0     
simqi
simqi, fd(pr) changex(locationdum 0 1)
simqi, fd(pr) changex(constlimit 0 1)
simqi, fd(pr) changex(transitional_ldr 0 1)

** percentage change (column 4) in Table H was calculated by hand.
**  This is done by dividing the first difference (column 3) by the 
**  baseline probability (column 1) and multiplying by 100. 





******************************************************
* Table I: Logit Results, Additional Controls
******************************************************
clear
use AProrok_AJPS.dta

* EO 1
logit waroutcome_extremel culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
* EO 2
logit waroutcome_extremel culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp rebpolwing2 demdum7 lnconf_duration if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
* EO 3
logit waroutcome_extremel culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 lnbdbest if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
* EO 4
logit waroutcome_extremel culpbdep_dum stronger multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 sdiap_c hydrop_c if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)

* PC 1
logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
* PC 2
logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp rebpolwing2 demdum7 lnconf_duration if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
* PC 3
logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 lnbdbest if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)
* PC 4
logit polconcessions culpbdep_dum strength_extreme multdyadsdum lnalliancedur_lstyr mediation troopsupport incomp lnldrconf_duration rebpolwing2 demdum7 sdiap_c hydrop_c if unknownleader!=1 & terminate==1 & joint_term<2, cluster(dyadid)






