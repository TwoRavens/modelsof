

* This do-file uses the following packages that need to be installed: fsum, outreg2, inteff


use "data.dta", clear

* Generating variables
do "creating variables.do"




*====================================

* RESULTS IN TEXT

*====================================


** Section 4.1

* BEHAVIOR PRINCIPAL
* ==================

* create mbonusij: mean bonus when treatment is i=C,M and principal observes j=L,H (low or high costs)

bys groupid: egen temp1=mean(highbonus) if principal==1 & informed==0   
bys groupid: egen temp2=mean(highbonus) if principal==1 & informed==1   & highcost==0
bys groupid: egen temp3=mean(highbonus) if principal==1 & informed==1   & highcost==1

bys groupid: egen mbonusC=max(temp1)
bys groupid: egen mbonusML=max(temp2)
bys groupid: egen mbonusMH=max(temp3)

lab var mbonusC "Mean bonus control treatment"
lab var mbonusML "Mean bonus main treatment, low costs"
lab var mbonusMH "Mean bonus main treatment, high costs"

drop temp*

* summarize bonus by treatment and costs, mean over group
fsum mbonusC mbonusML mbonusMH if flaggroup==1, uselabel

signrank  mbonusML = mbonusMH  if flaggroup==1

bys highcost: tab wage if principal==1 & maintreatment==1


* BEHAVIOR AGENT
* ==============

* EFFECT OF HIGH BONUS ON effort_joint

bys groupid: egen temp1=mean(effort_joint) if agent==1 &informed==0  & highbonus==1  & goodsignal==1
bys groupid: egen temp2=mean(effort_joint) if agent==1 &informed==0  & highbonus==0  & goodsignal==1
bys groupid: egen temp3=mean(effort_joint) if agent==1 &informed==1  & highbonus==1  & goodsignal==1
bys groupid: egen temp4=mean(effort_joint) if agent==1 &informed==1  & highbonus==0  & goodsignal==1

bys groupid: egen temp5=mean(effort_joint) if agent==1 &informed==0  & highbonus==1  & goodsignal==0
bys groupid: egen temp6=mean(effort_joint) if agent==1 &informed==0 & highbonus==0 & goodsignal==0
bys groupid: egen temp7=mean(effort_joint) if agent==1 &informed==1  & highbonus==1  & goodsignal==0
bys groupid: egen temp8=mean(effort_joint) if agent==1 &informed==1  & highbonus==0  & goodsignal==0

* meffort_jointijk is mean effort joint, i=treatment, j=bonus, k=signal

bys groupid: egen meffort_jointCHG=max(temp1)
bys groupid: egen meffort_jointCLG=max(temp2)
bys groupid: egen meffort_jointMHG=max(temp3)
bys groupid: egen meffort_jointMLG=max(temp4)

bys groupid: egen meffort_jointCHB=max(temp5)
bys groupid: egen meffort_jointCLB=max(temp6)
bys groupid: egen meffort_jointMHB=max(temp7)
bys groupid: egen meffort_jointMLB=max(temp8)
drop temp*

lab var meffort_jointCHG "effort joint, control, bonus, good signal"
lab var meffort_jointCLG "effort joint, control, no bonus, good signal"
lab var meffort_jointMHG "effort joint, main,  bonus, good signal"
lab var meffort_jointMLG "effort joint, main, no bonus, good signal"
lab var meffort_jointCHB "effort joint, control,  bonus, bad signal"
lab var meffort_jointCLB "effort joint, control, no bonus, bad signal"
lab var meffort_jointMHB "effort joint, main, bonus, bad signal"
lab var meffort_jointMLB "effort joint, main, no bonus, bad signal"


* main treatment

* summarize effort joint project, mean over group
fsum  meffort_jointMLB meffort_jointMLG meffort_jointMHB meffort_jointMHG if  flaggroup==1, uselabel
signrank  meffort_jointMHG = meffort_jointMLG if flaggroup==1
signrank  meffort_jointMHB = meffort_jointMLB if flaggroup==1

bys groupid: gen increase_jointMG=meffort_jointMHG-meffort_jointMLG
bys groupid: gen increase_jointMB=meffort_jointMHB-meffort_jointMLB

lab var increase_jointMG "increase in effort joint with bonus, main, good signal"
lab var increase_jointMB "increase in effort joint with bonus, main, bad signal"

fsum increase_jointMG increase_jointMB if flaggroup==1, uselabel
ci increase_jointMG increase_jointMB if flaggroup==1

 
* EFFECT OF HIGH BONUS ON effort_own

* create meffort_ownijk is mean effort own, i=treatment, j=bonus, k=signal
bys groupid: egen temp11=mean(effort_own) if agent==1 &informed==0  & highbonus==1  & goodsignal==1
bys groupid: egen temp12=mean(effort_own) if agent==1 &informed==0  & highbonus==0  & goodsignal==1
bys groupid: egen temp13=mean(effort_own) if agent==1 &informed==1  & highbonus==1  & goodsignal==1
bys groupid: egen temp14=mean(effort_own) if agent==1 &informed==1  & highbonus==0  & goodsignal==1

bys groupid: egen temp15=mean(effort_own) if agent==1 &informed==0  & highbonus==1  & goodsignal==0
bys groupid: egen temp16=mean(effort_own) if agent==1 &informed==0  & highbonus==0  & goodsignal==0
bys groupid: egen temp17=mean(effort_own) if agent==1 &informed==1  & highbonus==1  & goodsignal==0
bys groupid: egen temp18=mean(effort_own) if agent==1 &informed==1  & highbonus==0  & goodsignal==0

bys groupid: egen meffort_ownCHG=max(temp11)
bys groupid: egen meffort_ownCLG=max(temp12)
bys groupid: egen meffort_ownMHG=max(temp13)
bys groupid: egen meffort_ownMLG=max(temp14)

bys groupid: egen meffort_ownCHB=max(temp15)
bys groupid: egen meffort_ownCLB=max(temp16)
bys groupid: egen meffort_ownMHB=max(temp17)
bys groupid: egen meffort_ownMLB=max(temp18)
drop temp*

lab var meffort_ownCHG "effort own, control, bonus, good signal"
lab var meffort_ownCLG "effort own, control, no bonus, good signal"
lab var meffort_ownMHG "effort own, main,  bonus, good signal"
lab var meffort_ownMLG "effort own, main, no bonus, good signal"
lab var meffort_ownCHB "effort own, control,  bonus, bad signal"
lab var meffort_ownCLB "effort own, control, no bonus, bad signal"
lab var meffort_ownMHB "effort own, main, bonus, bad signal"
lab var meffort_ownMLB "effort own, main, no bonus, bad signal"

* main treatment
ci meffort_ownMHG meffort_ownMLG meffort_ownMHB meffort_ownMLB if  flaggroup==1

signrank  meffort_ownMHG = meffort_ownMLG if flaggroup==1
signrank  meffort_ownMHB = meffort_ownMLB if flaggroup==1

bys groupid: gen increase_ownMG=meffort_ownMHG-meffort_ownMLG
bys groupid: gen increase_ownMB=meffort_ownMHB-meffort_ownMLB

lab var increase_ownMG "increase in effort own with bonus, main, good signal"
lab var increase_ownMB "increase in effort own with bonus, main, bad signal"

fsum  increase_ownMG increase_ownMB if flaggroup==1, uselabel
ci  increase_ownMG increase_ownMB if flaggroup==1, level(90)


** Section 4.2

* joint project
ci meffort_jointCHG meffort_jointCLG   meffort_jointCHB meffort_jointCLB   if  flaggroup==1

bys groupid: gen increase_jointCG=meffort_jointCHG-meffort_jointCLG
bys groupid: gen increase_jointCB=meffort_jointCHB-meffort_jointCLB

lab var increase_jointCG "increase in effort joint with bonus, control, good signal"
lab var increase_jointCB "increase in effort joint with bonus, control, bad signal"

fsum increase_jointCG increase_jointCB if flaggroup==1, uselabel
ci increase_jointCG increase_jointCB if flaggroup==1, level(90)

signrank  meffort_jointCHG = meffort_jointCLG if flaggroup==1
signrank  meffort_jointCHB = meffort_jointCLB if flaggroup==1


* own project
ci  meffort_ownCHG meffort_ownCLG  meffort_ownCHB meffort_ownCLB if  flaggroup==1

bys groupid: gen increase_ownCG=meffort_ownCHG-meffort_ownCLG
bys groupid: gen increase_ownCB=meffort_ownCHB-meffort_ownCLB

lab var increase_ownCG "increase in effort own with bonus, control, good signal"
lab var increase_ownCB "increase in effort own with bonus, control, bad signal"

fsum  increase_ownCG increase_ownCB if flaggroup==1, uselabel
ci  increase_ownCG increase_ownCB if flaggroup==1, level(90)

signrank  meffort_ownCHG = meffort_ownCLG if flaggroup==1
signrank  meffort_ownCHB = meffort_ownCLB if flaggroup==1


** Section 4.3

* consistency with equilibrium: see other do file

* mean effort by Fair after good signal
bys Fair maintreatment: sum effort_joint if highbonus==1 & goodsignal==1 & agent==1
bys Fair maintreatment: sum effort_joint if highbonus==0 & goodsignal==1 & agent==1

* test difference behavior by Fair
bys subjectid: egen temp90=mean(effort_joint) if agent==1 & maintreatment==1 & highbonus==0 & goodsignal==1
bys subjectid: egen temp91=mean(effort_joint) if agent==1 & maintreatment==0 & highbonus==0 & goodsignal==1

bys subjectid: egen temp92=mean(effort_joint) if agent==1 & maintreatment==1 & highbonus==1 & goodsignal==1
bys subjectid: egen temp93=mean(effort_joint) if agent==1 & maintreatment==0 & highbonus==1 & goodsignal==1

bys subjectid: egen angry_agent_main=max(temp90)
bys subjectid: egen angry_agent_control=max(temp91)
bys subjectid: egen happy_agent_main=max(temp92)
bys subjectid: egen happy_agent_control=max(temp93)

ranksum angry_agent_main if flagsubjectgroup==1, by(Fair)
ranksum angry_agent_control if flagsubjectgroup==1, by(Fair)


** Section 4.4

* for claim in section 4.4 about percentage participants for whom all decisions are correct, see do file consistency equilibrium

* test bad news effect at subject level by starting role, aggregated over signals (see also analysis supplementary content)

bys subjectid: egen z70=mean(effort_own) if agent==1 & informed==1 & highbonus==0 & goodsignal==0
bys subjectid: egen z71=mean(effort_own) if agent==1 & informed==1 & highbonus==1 & goodsignal==0  
bys subjectid: egen z72=mean(effort_own) if agent==1 & informed==1 & highbonus==0 & goodsignal==1 
bys subjectid: egen z73=mean(effort_own) if agent==1 & informed==1 & highbonus==1 & goodsignal==1 

bys subjectid: egen z80=max(z70)
bys subjectid: egen z81=max(z71)
bys subjectid: egen z82=max(z72)
bys subjectid: egen z83=max(z73)

gen z90=z81-z80
gen z91=z83-z82

egen z92=rmean(z91 z90)

ranksum z92 if flagsubjecttreatment==1 & maintreatment==1, by(startagent)



** Section 4.5
xi: dprobit  i.highbonus highcosts i.stage  if    maintreatment==1 & principal==1 & Fair==0, robust cl(groupid) 
xi: dprobit  i.highbonus highcosts i.stage  if    maintreatment==1 & principal==1 & Fair==1, robust cl(groupid) 
xi: dprobit  i.highbonus highcosts i.stage  if    maintreatment==1 & principal==1 & Altruist==0, robust cl(groupid) 
xi: dprobit  i.highbonus highcosts i.stage  if    maintreatment==1 & principal==1 & Altruist==1, robust cl(groupid) 
xi: dprobit  i.highbonus highcosts i.stage  if    maintreatment==1 & principal==1 & Trusting==0, robust cl(groupid) 
xi: dprobit  i.highbonus highcosts i.stage  if    maintreatment==1 & principal==1 & Trusting==1, robust cl(groupid) 
xi: dprobit  i.highbonus highcosts i.stage  if    maintreatment==1 & principal==1 & Reciprocal==0, robust cl(groupid) 
xi: dprobit  i.highbonus highcosts i.stage  if    maintreatment==1 & principal==1 & Reciprocal==1, robust cl(groupid) 




*====================================

* FIGURES

*====================================


*** FIGURE 1
sum mbonusML mbonusMH if flaggroup==1

*** FIGURE 2
bys highcost highbonus: tab wage if principal==1 & maintreatment==1

*** FIGURE 3
ci  decrease_jointMB decrease_jointMG  decrease_jointCB  decrease_jointCG if flaggroup==1

*** FIGURE 4
ci  decrease_ownMB  decrease_ownMG decrease_ownCB decrease_ownCG if flaggroup==1

*** FIGURE 5
* created in excel (file "time trend"), based on extract data below

bys round_treatment: egen temp5=mean(effort_own) if  informed==1 & agent==1 & goodsignal==0 & highbonus==0
bys round_treatment: egen temp6=mean(effort_own) if  informed==1 & agent==1 & goodsignal==1 & highbonus==0
bys round_treatment: egen temp7=mean(effort_own) if  informed==1 & agent==1 & goodsignal==0 & highbonus==1
bys round_treatment: egen temp8=mean(effort_own) if  informed==1 & agent==1 & goodsignal==1 & highbonus==1

bys round_treatment: egen temp15=max(temp5)	
bys round_treatment: egen temp16=max(temp6)
bys round_treatment: egen temp17=max(temp7)
bys round_treatment: egen temp18=max(temp8)

bys round_treatment: gen d3=temp17-temp15
bys round_treatment: gen d4=temp18-temp16
bys round_treatment: egen d13=max(d3)
bys round_treatment: egen d14=max(d4)

drop temp* d3 d4 

*** FIGURE 6
* see file "consistency with equilibrium"

*** FIGURE 7

bys wage highbonus: sum effort_joint if maint==1 & agent==1 
bys wage highbonus: sum effort_joint if maint==0 & agent==1 

bys wage highbonus: sum effort_joint if maint==1 & agent==1 & Reciprocal==1
bys wage highbonus: sum effort_joint if maint==0 & agent==1 & Reciprocal==1




*====================================

* REGRESSION TABLES

*====================================

* TABLE 2: BONUS, Main treatment
xi: dprobit  i.highbonus highcosts i.stage  if    maintreatment==1 & principal==1 , robust cl(groupid)
outreg2 using bonus, addstat(Pseudo R-squared, `e(r2_p)') title(Table 2: Bonus)  ctitle(main, all rounds) bdec(3) tdec(3) rdec(3)   tex      replace

xi: dprobit  highbonus highcosts   female Altruist Trusting Fair Reciprocal i.stage if  maintreatment==1 & principal==1, robust cl(groupid)
outreg2 using bonus, addstat(Pseudo R-squared, `e(r2_p)') ctitle(main, all rounds) bdec(3) tdec(3) rdec(3)   tex      append

xi: dprobit  highbonus highcosts   female Altruist Trusting Fair Reciprocal i.stage if  maintreatment==1 & principal==1 &   Rounds11_20==0, robust cl(groupid)
outreg2 using bonus, addstat(Pseudo R-squared, `e(r2_p)') ctitle(main, rounds 1-10) bdec(3) tdec(3) rdec(3)   tex      append

xi: dprobit  highbonus highcosts   female Altruist Trusting Fair Reciprocal i.stage if  maintreatment==1 & principal==1 &   Rounds11_20==1, robust cl(groupid)
outreg2 using bonus, addstat(Pseudo R-squared, `e(r2_p)') ctitle(main, rounds 11-20) bdec(3) tdec(3) rdec(3)   tex      append


* TABLE 3: Effort, Main treatment
xi: dprobit  effort_joint   i.highbonus*goodsignal wage5 wage10  i.stage if    maintreatment==1 & agent==1 , robust cl(groupid)
outreg2 using main, addstat(Pseudo R-squared, `e(r2_p)') title(Table 3: Effort in Main Treatment) ctitle(joint project, all rounds) bdec(3) tdec(3) rdec(3)    tex      replace

xi: dprobit  effort_joint   i.highbonus*goodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1  , robust cl(groupid)
outreg2 using main, addstat(Pseudo R-squared, `e(r2_p)') ctitle(joint project, all rounds) bdec(3) tdec(3) rdec(3)    tex      append

xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10  i.stage if    maintreatment==1 & agent==1  , robust cl(groupid)
outreg2 using main,  addstat(Pseudo R-squared, `e(r2_p)') ctitle(own project, all rounds) bdec(3) tdec(3) rdec(3)    tex      append

xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1  , robust cl(groupid)
outreg2 using main, addstat(Pseudo R-squared, `e(r2_p)') ctitle(own project, all rounds) bdec(3) tdec(3) rdec(3)    tex      append

xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1   & Rounds11_20 ==0, robust cl(groupid)
outreg2 using main, addstat(Pseudo R-squared, `e(r2_p)') ctitle(own project, rounds 1-10) bdec(3) tdec(3) rdec(3)    tex      append

xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1   & Rounds11_20 ==1, robust cl(groupid)
outreg2 using main, addstat(Pseudo R-squared, `e(r2_p)') ctitle(own project, rounds 11-20) bdec(3) tdec(3) rdec(3)    tex      append


* TABLE 4: Effort, Control treatment

xi: dprobit  effort_joint   i.highbonus*goodsignal wage5 wage10  i.stage if    controltreatment==1 & agent==1  , robust cl(groupid)
outreg2 using control, addstat(Pseudo R-squared, `e(r2_p)') title(Table 4: Effort in Control Treatment) ctitle(joint project) bdec(3) tdec(3) rdec(3)    tex      replace

xi: dprobit  effort_joint   i.highbonus*goodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal i.stage if    controltreatment==1 & agent==1  , robust cl(groupid)
outreg2 using control,  addstat(Pseudo R-squared, `e(r2_p)')ctitle(joint project) bdec(3) tdec(3) rdec(3)    tex      append

xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10  i.stage if    controltreatment==1 & agent==1  , robust cl(groupid)
outreg2 using control,  addstat(Pseudo R-squared, `e(r2_p)') ctitle(own project) bdec(3) tdec(3) rdec(3)    tex      append

xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal  i.stage if    controltreatment==1 & agent==1  , robust cl(groupid)
outreg2 using control, addstat(Pseudo R-squared, `e(r2_p)') ctitle(own project) bdec(3) tdec(3) rdec(3)    tex      append

* TABLE 5: Consistent choices
* See do file "consistency with equilibrium.do"




*==================================================

*TESTING SUM (BONUS + BONUS*GOODSIGNAL) IS POSITIVE

*==================================================


* TABLE MAIN
quietly xi: dprobit  effort_joint   i.highbonus*goodsignal wage5 wage10  i.stage if    maintreatment==1 & agent==1 , robust cl(groupid)
lincom  _Ihighbonus_1 + _IhigXgoods_1


quietly xi: dprobit  effort_joint   i.highbonus*goodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1  , robust cl(groupid)
lincom  _Ihighbonus_1 + _IhigXgoods_1

quietly xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10  i.stage if    maintreatment==1 & agent==1  , robust cl(groupid)
lincom  _Ihighbonus_1 + _IhigXgoods_1

quietly xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1  , robust cl(groupid)
lincom  _Ihighbonus_1 + _IhigXgoods_1

quietly xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1   & Rounds11_20 ==0, robust cl(groupid)
lincom  _Ihighbonus_1 + _IhigXgoods_1

quietly xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal i.stage if    maintreatment==1 & agent==1   & Rounds11_20 ==1, robust cl(groupid)
lincom  _Ihighbonus_1 + _IhigXgoods_1



* TABLE Control

*uninformed
quietly xi: dprobit  effort_joint   i.highbonus*goodsignal wage5 wage10  i.stage if    controltreatment==1 & agent==1  , robust cl(groupid)
lincom  _Ihighbonus_1 + _IhigXgoods_1

quietly xi: dprobit  effort_joint   i.highbonus*goodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal i.stage if    controltreatment==1 & agent==1  , robust cl(groupid)
lincom  _Ihighbonus_1 + _IhigXgoods_1

* Uninformed
quietly xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10  i.stage if    controltreatment==1 & agent==1  , robust cl(groupid)
lincom  _Ihighbonus_1 + _IhigXgoods_1

quietly xi: dprobit  effort_own  i.highbonus*goodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal  i.stage if    controltreatment==1 & agent==1  , robust cl(groupid)
lincom  _Ihighbonus_1 + _IhigXgoods_1


*==================================================

* CORRECTING INTERACTION EFFECTS

*==================================================

* TABLE 3
probit  effort_joint   highbonus goodsignal  highbonusgoodsignal wage5 wage10  stage if    informed==1 & agent==1 , robust cl(groupid)
inteff  effort_joint   highbonus goodsignal  highbonusgoodsignal wage5 wage10  stage if    informed==1 & agent==1 

probit  effort_joint   highbonus goodsignal  highbonusgoodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal stage if    informed==1 & agent==1  , robust cl(groupid)
inteff  effort_joint   highbonus goodsignal  highbonusgoodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal stage if    informed==1 & agent==1  

probit  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10  stage if    informed==1 & agent==1  , robust cl(groupid)
inteff  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10  stage if    informed==1 & agent==1  

probit  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal stage if    informed==1 & agent==1  , robust cl(groupid)
inteff  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal stage if    informed==1 & agent==1  

probit  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal stage if    informed==1 & agent==1   & Rounds11_20 ==0, robust cl(groupid)
inteff  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal stage if    informed==1 & agent==1   & Rounds11_20 ==0

probit  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal stage if    informed==1 & agent==1   & Rounds11_20 ==1, robust cl(groupid)
inteff  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10   female Altruist Trusting Fair Reciprocal stage if    informed==1 & agent==1   & Rounds11_20 ==1


* TABLE 4
probit  effort_joint   highbonus goodsignal  highbonusgoodsignal wage5 wage10  stage if    informed==0 & agent==1  , robust cl(groupid)
inteff  effort_joint   highbonus goodsignal  highbonusgoodsignal wage5 wage10  stage if    informed==0 & agent==1  

probit  effort_joint   highbonus goodsignal  highbonusgoodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal stage if    informed==0 & agent==1  , robust cl(groupid)
inteff  effort_joint   highbonus goodsignal  highbonusgoodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal stage if    informed==0 & agent==1 

probit  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10  stage effort_joint if    informed==0 & agent==1  , robust cl(groupid)
inteff  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10  stage effort_joint if    informed==0 & agent==1  

probit  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal  stage if    informed==0 & agent==1  , robust cl(groupid)
inteff  effort_own  highbonus goodsignal  highbonusgoodsignal wage5 wage10  female Altruist Trusting Fair Reciprocal  stage if    informed==0 & agent==1  







