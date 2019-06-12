
**********************************************************************************
**** PEACEFUL UNCERTAINTY: WHEN POWER SHOCKS DO NOT CREATE COMMITMENT PROBLEMS 
**** BAS AND SCHUB
**** ISQ REPLICATION FILE 
**********************************************************************************

***********************
** CONTENTS OVERVIEW
***********************

* (I) Main results:
  * Manuscript Table 1
  * Manuscript Table 2
  * Supporting Files Tables A1-A10
  * Manuscript Figure 4 Left Panel: Substantive Simulations 
  * Manuscript Figure 5 Left Panel: Substantive Simulations
  * Shocks Measure Descriptives

** Set appropriate working directory and load main data
clear
use "BasSchub_ISQ_Shocks.dta"


** Manuscript Table 1 **
 
logit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
logit war2 Psmallpos relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1 & Pshock==0, cl(seclust) 
logit war2 Pshock powershift Pshiftshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
logit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if powershift< -0.02 & rival==1, cl(seclust) 
logit war2 Pshock Pshiftactual relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
 


** Manuscript Table 2 **
 
logit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3, cl(seclust)
logit war2 Psmallpos relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if Pshock==0, cl(seclust) 
logit war2 Pshock powershift Pshiftshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3, cl(seclust)
logit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if powershift< -0.02, cl(seclust) 
logit war2 Pshock Pshiftactual relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3, cl(seclust)
 


** Supporting Files Table A1 **
logit war2 Pshock relcap contig s_un_glo dem peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
drop basic
gen basic=0
replace basic=1 if e(sample)==1

logit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3, cl(seclust)
gen prdbasic=0
replace prdbasic=1 if e(sample)==1

format war2 Pshock powershift dem relcap contig s_un_glo peaceyrs %9.3fc
summ war2 Pshock powershift dem relcap contig s_un_glo peaceyrs if basic==1, format
summ war2 Pshock powershift dem relcap contig s_un_glo peaceyrs if prdbasic==1, format


** Supporting Files Table A2 **
 
firthlogit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1
firthlogit war2 Psmallpos relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if Pshock==0 & rival==1
firthlogit war2 Pshock powershift Pshiftshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1
firthlogit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if powershift< -0.02 & rival==1 
firthlogit war2 Pshock Pshiftactual relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1
 


** Supporting Files Table A3 **
 
logit war2 Pshock if rival==1, cl(seclust)
logit war2 Psmallpos if Pshock==0 & rival==1, cl(seclust) 
logit war2 Pshock powershift Pshiftshock  if rival==1, cl(seclust)
logit war2 Pshock  if powershift< -0.02 & rival==1, cl(seclust) 
logit war2 Pshock Pshiftactual if rival==1, cl(seclust)
 


** Supporting Files Table A4 **
 
logit war2 Pshock contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
logit war2 Psmallpos contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if Pshock==0 & rival==1, cl(seclust) 
logit war2 Pshock powershift Pshiftshock contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
logit war2 Pshock contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1 & powershift< -0.02, cl(seclust) 
logit war2 Pshock Pshiftactual contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
 


** Supporting Files Table A5 **
gen tri=.
replace tri=1 if powershift<-0.02
replace tri=2 if powershift>-0.02 & powershift <0.02
replace tri=3 if powershift>0.02

 
logit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if tri==1 & rival==1, cl(seclust)
logit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if tri==2 & rival==1, cl(seclust)
logit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if tri==3 & rival==1, cl(seclust)
  


** Supporting Files Table A6: Models 1-2 **

*indicator for attacker stronger than expected
gen Ashock=.
replace Ashock=0 if milcap<estpower_up_A
replace Ashock=1 if milcap>estpower_up_A
replace Ashock=. if estpower_A==.
*indicator for target weaker than expected
gen Bshock=.
replace Bshock=0 if milcap_B>estpower_do_B
replace Bshock=1 if milcap_B<estpower_do_B
replace Bshock=. if estpower_B==.
*indicator for when Ashock occurs but Bshock does not
gen Ashockendog=.
replace Ashockendog=1 if Ashock==1 & Bshock==0
replace Ashockendog=. if (Ashock==.|Bshock==.)

 
logit war2 Bshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1 & Ashockendog!=1, cl(seclust)
logit war2 Bshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if Ashockendog!=1, cl(seclust)
  

** Supporting Files Table A6: Model 3 **
 
logit war2 killed000000 relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)



** Supporting Files Table A7 **
 
logit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if year<1945 & rival==1, cl(seclust)
logit war2 Pshock powershift Pshiftshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if year<1945 & rival==1, cl(seclust)
logit war2 Pshock relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if powershift< -0.02 & year<1945 & rival==1, cl(seclust) 
 

** Supporting Files Table A8 **
 
logit war2 Pshock99 relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
logit war2 Pshock99 powershift Pshiftshock99 relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
logit war2 Pshock99 relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if powershift< -0.02 & rival==1, cl(seclust) 
 


** Supporting Files Table A9 **
 
logit war2 Pshockx relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
logit war2 Pshockx powershift Pshiftshockx relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
 


** Supporting Files Table A10 **
 
logit war2 Pshock posshockrate relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
logit war2 Psmallpos posshockrate relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if Pshock==0 & rival==1, cl(seclust) 
logit war2 Pshock powershift Pshiftshock posshockrate relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
logit war2 Pshock posshockrate relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if powershift< -0.02 & rival==1, cl(seclust) 
logit war2 Pshock Pshiftactual posshockrate relcap contig dem s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
 


** Manuscript Figure 4 Left Panel: Substantive Simulations Iraq-Iran 1977 & Iraq-Iran 1980 **
sort initiator target year
estsimp logit war2 Pshock relcap contig s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1, cl(seclust)
setx [133592]
simqi, listx prval(1)
setx [133595]
setx peaceyrs 1 peaceyrs2 1 peaceyrs3 1
simqi, listx prval(1)


** Manuscript Figure 5 Left Panel: Substantive Simulations **
drop b1 b2 b3 b4 b5 b6 b7 b8
estsimp logit war2 Pshock powershift Pshiftshock relcap contig s_un_glo peaceyrs peaceyrs2 peaceyrs3 if rival==1 & dem!=. & dem!=1, cl(seclust)
setx median 
setx peaceyrs 1 peaceyrs2 1 peaceyrs3 1
setx powershift -0.04 Pshiftshock 0 Pshock 0
simqi, listx fd(prval(1)) level(90) changex(Pshock 0 1 Pshiftshock 0 -0.04)
setx powershift -0.03 Pshiftshock 0 Pshock 0
simqi, listx fd(prval(1)) level(90) changex(Pshock 0 1 Pshiftshock 0 -0.03)
setx powershift -0.02 Pshiftshock 0 Pshock 0
simqi, listx fd(prval(1)) level(90) changex(Pshock 0 1 Pshiftshock 0 -0.02)
setx powershift -0.01 Pshiftshock 0 Pshock 0
simqi, listx fd(prval(1)) level(90) changex(Pshock 0 1 Pshiftshock 0 -0.01)
setx powershift -0.00 Pshiftshock 0 Pshock 0
simqi, listx fd(prval(1)) level(90) changex(Pshock 0 1 Pshiftshock 0 -0.00)
setx powershift 0.01 Pshiftshock 0 Pshock 0
simqi, listx fd(prval(1)) level(90) changex(Pshock 0 1 Pshiftshock 0 0.01)
setx powershift 0.02 Pshiftshock 0 Pshock 0
simqi, listx fd(prval(1)) level(90) changex(Pshock 0 1 Pshiftshock 0 0.02)
setx powershift 0.03 Pshiftshock 0 Pshock 0
simqi, listx fd(prval(1)) level(90) changex(Pshock 0 1 Pshiftshock 0 0.03)
setx powershift 0.04 Pshiftshock 0 Pshock 0
simqi, listx fd(prval(1)) level(90) changex(Pshock 0 1 Pshiftshock 0 0.04)


** Shocks Measure Descriptives: Predictive Accuracy **
gen shockAccStandardize=abs(Prealizeddiff/Pmean)
replace shockAccStandardize=. if Pshock==.
summ shockAccStandardize, detail



