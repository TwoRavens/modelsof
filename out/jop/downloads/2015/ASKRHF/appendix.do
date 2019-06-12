************************************************************************
* Replication Materials for JOP paper: Appendix Materials              *
* "Spoilers, Terrorism, and the Resolution of Civil Wars"              *
* Date: 5/18/15														   *
* Authors: Michael G. Findley and Joseph K. Young                      * 
************************************************************************
clear
set more off


*****************
*   SECTION A   *
*****************

*******************************
* Summary Stats for Table A1  *
*******************************
*Duration data
use duration_main_est.dta


*Re-estimate Model 1
streg lagLogTotalWarRelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, dist(lognormal) 

*Get descriptive stats for estimation sample
sum lagLogTotalWarRelated logpop elf lngdp uppsalaMaxed logbattledeaths mountains guarantee if e(sample)

*******************************
* Summary Stats for Table A2  *
*******************************
*Recurrence data
use recurrence_main_est.dta, clear

*Survival model set up
stset pdur, id(warnumb) f(pcens)

*Re-estimate Model 3
streg lagLogTotalWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent, dist(lognormal) nolog

*Get descriptive stats for estimation sample
sum lagLogTotalWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent if e(sample)

***************
*  SECTION B  *
***************

*******************************************************************************
* Graphing the baseline hazard with covariates for Civil War Duration  		  *
* based on Carter and Signorino (2010)										  *
*******************************************************************************

use duration_main_est.dta, clear
*drop _spline*

*Need to get BTSCS ado file (we obtained from https://www.prio.org/Data/Stata-Tools/)
btscs warend month warnumber, g(lifeyrs) nspline(3)

*Carter and Signorino approach 
gen lifeyrs2= lifeyrs*lifeyrs
gen lifeyrs3= lifeyrs* lifeyrs* lifeyrs


*Estimate logit model with cubic polynomial
logit warend lagLogTotalWarRelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee lifeyrs lifeyrs2 lifeyrs3, cluster(cowcode)

*Generate means of x1 and x2
 foreach var of varlist lagLogTotalWarRelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee{        
	egen mean`var'=mean(`var')	 
}		 
*Drop rows not needed for prediction
duplicates drop lifeyrs, force

*Only keep variables needed for prediction
keep meanlagLogTotalWarRelated meanlogpop meanelf  meanlngdp meanuppsalaMaxed meanlogbattledeaths meanmountains meanguarantee lifeyrs lifeyrs2 lifeyrs3

*rename variables
rename meanlagLogTotalWarRelated lagLogTotalWarRelated
rename meanlogpop logpop
rename meanelf elf
rename meanlngdp lngdp
rename meanuppsalaMaxed uppsalaMaxed 
rename meanlogbattledeaths logbattledeaths
rename meanmountains mountains
rename meanguarantee guarantee

*Predict Pr(Y=1)
predict p1

*Relabel X and Y axis for more readable graph.
label var p1 "Probability Civil War Ends"
label var lifeyrs "Time"

*Plot estimated Pr(Y=1|t)
twoway line p1 lifeyrs

clear

*******************************************************************************
* Graphing the baseline hazard with covariates for Civil War Recurrence       *
* based on Carter and Signorino (2010)										  *
*******************************************************************************
*Recurrence data
use recurrence_main_est.dta

*Need to get BTSCS ado file 
btscs pcens year cowcode, g(lifeyrs) nspline(3)

*Carter and Signorino 
gen lifeyrs2= lifeyrs*lifeyrs
gen lifeyrs3=	lifeyrs* lifeyrs* lifeyrs

*Estimate logit model with cubic polynomial
logit pcens lagLogTotalWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent lifeyrs lifeyrs2 lifeyrs3, cluster(cowcode)

*Generate means of x1 and x2
egen meanlagLogTotalWarRelated=mean(lagLogTotalWarRelated)
egen meanlpopns=mean(lpopns)
egen meanethfrac=mean(ethfrac)
egen meanln_gdpen=mean(ln_gdpen)
egen meaninst2=mean(inst2)
egen meanregd4=mean(regd4)
egen meanabsent=mean(absent)

*Drop rows not needed for prediction
duplicates drop lifeyrs, force

*Only keep variables needed for prediction
keep lifeyrs lifeyrs2 lifeyrs3 meanlagLogTotalWarRelated meanlpopns meanethfrac meanln_gdpen meaninst2 meanregd4 meanabsent

*rename variables
rename meanlagLogTotalWarRelated lagLogTotalWarRelated   
rename meanlpopns lpopns 
rename meanethfrac ethfrac
rename meanln_gdpen ln_gdpen 
rename meaninst2 inst2
rename meanregd4 regd4
rename meanabsent absent

*Predict Pr(Y=1)
predict p1

*Relabel X and Y axis for more readable graph.
label var p1 "Probability Y=1"
label var lifeyrs "Time"

*Plot estimated Pr(Y=1|t)
twoway line p1 lifeyrs

clear

******************
*   SECTION C    *
******************

****************************************************
* DURATION  Models with lagged repression measures *
**************************************************** 
*Duration data
use duration_main_est.dta

*lagged Repression (PTS) Table C.1 
* Model 5 pts_a, lagged/logged terrorism
streg lagLogTotalWarRelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee lag_pts_a, dist(lognormal) nolog

* Model 6 pts_a, smoothed terrorism
streg smterrorwarrelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee lag_pts_a, dist(lognormal) nolog

*lagged Repression (CIRI) Table C.2 
* Model 7 physint, lagged/logged terrorism
streg lagLogTotalWarRelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee lag_physint, dist(lognormal) nolog

* Model 8 physint, smoothed terrorism
streg smterrorwarrelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee lag_physint, dist(lognormal) nolog

clear

*****************************************************
* Recurrence Models with lagged repression measures *
***************************************************** 
*Recurrence data
use recurrence_main_est.dta

*lagged Repression (PTS) Table C.3 
* Model 9 pts_a, lagged/logged terrorism
streg lagLogTotalWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent lag_pts_a, dist(lognormal) nolog

* Model 10 pts_a, smoothed terrorism
streg smterrorWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent lag_pts_a, dist(lognormal) nolog 

*lagged Repression (CIRI) Table C.4 
* Model 11 physint, lagged/logged terrorism
streg lagLogTotalWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent lag_physint, dist(lognormal) nolog

* Model 10 physint, smoothed terrorism
streg smterrorWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent lag_physint, dist(lognormal) nolog 

clear

****************************
*        SECTION D         *
****************************
*Duration data
use duration_main_est.dta

****************************
* Matching                 *
****************************
*PSMATCH 2 Propensity Score Matching

*create the dichotomous treatment variable, logged/lagged terrorism
gen terrormatch=lagLogTotalWarRelated 
replace terrormatch=1 if lagLogTotalWarRelated > 1
replace terrormatch=0 if lagLogTotalWarRelated < 1

*match on it, first set the seed
set seed 20850

*Nearest Neighbor Matching 
#delimit ;
psmatch2 terrormatch logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, 
outcome(warmonths) neighbor(1) ate common trim(2) ;
#delimit cr

*Gives results of matching, reduction in bias discussed on page 10
pstest logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, sum

*Model discussed in section D. Only need to look at terrorism coefficient
streg lagLogTotalWarRelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee  if _support==1, dist(lognormal)

//NOTE: Most of the psmatch commands suggest weighting, but the stset in STATA won't allow weighting

****************************************************

*create the dichotomous treatment variable, smoothed terrorism
gen terrormatch2=smterrorwarrelated
replace terrormatch2=1 if smterrorwarrelated > 1
replace terrormatch2=0 if smterrorwarrelated < 1

*match on it, first set the seed
set seed 20850

*Nearest Neighbor Matching *
#delimit ;
psmatch2 terrormatch2 logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, 
outcome(warmonths) neighbor(1) ate common trim(2) ;
#delimit cr

*Gives results of matching *
pstest logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, sum


*Model discussed in section D. Only need to look at terrorism coefficient
streg  smterrorwarrelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee  if _support==1, dist(lognormal)

//NOTE: Most of the psmatch commands suggest weighting, but the stset in STATA won't allow weighting


**********************************
* Generalized Propensity Score   *
**********************************

* Propensity score models, logged/lagged terrorism
xtreg logTotalWarRelated logpop elf lngdp uppsalaMaxed logbattledeaths mountains guarantee, re

* Make propensity score
predict pscore1

*Create categories for subclassification 
xtile quintile3=pscore1, n(3)

*Figure D.1:This provides a separate graph for each subgroup
histogram warmonths, kdensity by(quintile3)

*Estimate the models within each subgroup
streg lagLogTotalWarRelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee if quintile3==1, dist(lognormal)
streg lagLogTotalWarRelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee if quintile3==2, dist(lognormal)
streg lagLogTotalWarRelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee if quintile3==3, dist(lognormal)

*************************************

* Propensity score models, smoothed terrorism 
xtreg smterrorwarrelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, re

* Make propensity score
predict pscore2

*Create categories for subclassification 
xtile quin3=pscore2, n(3)

*Estimate the models within each subgroup
streg smterrorwarrelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee if quin3==1, dist(lognormal)
streg smterrorwarrelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee if quin3==2, dist(lognormal)
streg smterrorwarrelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee if quin3==3, dist(lognormal)

clear

*******************************************************************************************************************************



*********************
* Recurrence        *
*                   *
*********************
use recurrence_main_est.dta

*survival model set up
*stset pdur, id(warnumb) f(pcens)

****************************
* Matching                 *
****************************
*PSMATCH 2 Propensity Score Matching

*create the dichotomous treatment variable, logged/lagged terrorism
gen terrormatch=lagLogTotalWarRelated 
replace terrormatch=1 if lagLogTotalWarRelated > 1
replace terrormatch=0 if lagLogTotalWarRelated < 1

*match on it, first set the seed
set seed 20850

* Nearest Neighbor Matching 
#delimit ;
psmatch2 terrormatch lpopns ethfrac ln_gdpen inst2 regd4 absent, 
outcome(pdur) neighbor(1) ate common trim(2) ;
#delimit cr

* Gives results of matching 
pstest lpopns ethfrac ln_gdpen inst2 regd4 absent, sum

*Model discussed in section D. Only need to look at terrorism coefficient
streg lagLogTotalWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent  if _support==1, dist(lognormal)

//NOTE: Most of the psmatch commands suggest weighting, but the stset in STATA won't allow weighting


****************************************************

**create the dichotomous treatment variable, smoothed terrorism
gen terrormatch2=smterrorWarRelated
replace terrormatch2=1 if smterrorWarRelated > 1
replace terrormatch2=0 if smterrorWarRelated < 1

*match on it, first set the seed
set seed 20850

* Nearest Neighbor Matching
#delimit ;
psmatch2 terrormatch2 lpopns ethfrac ln_gdpen inst2 regd4 absent, 
outcome(pdur) neighbor(1) ate common trim(2) ;
#delimit cr

* Gives results of matching 
pstest lpopns ethfrac ln_gdpen inst2 regd4 absent, sum

*Model discussed in section D. Only need to look at terrorism coefficient
streg  smterrorWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent  if  _support==1, dist(lognormal)

//NOTE: Most of the psmatch commands suggest weighting, but the stset in STATA won't allow weighting

**********************************
* Generalized Propensity Score   *
**********************************
* Propensity score models, logged/lagged terrorism 
xtreg logTotalWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent, re

* Make propensity score
predict pscore

*Create categories for subclassification 
xtile quintile3=pscore, n(3)

**Figure D.2:This provides a separate graph for each subgroup
histogram pdur, kdensity by(quintile3)

*Estimate the models within each subgroup
streg lagLogTotalWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent  if quintile3==1, dist(lognormal) nolog 
streg lagLogTotalWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent  if quintile3==2, dist(lognormal) nolog
streg lagLogTotalWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent  if quintile3==3, dist(lognormal) nolog

***********************************

* Propensity score models, smoothed terrorism 
xtreg smterrorWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent, re

* Make propensity score
predict pscore1

*Create categories for subclassification 
xtile quintile3a=pscore1, n(3)

**Figure D.2:This provides a separate graph for each subgroup
histogram pdur, kdensity by(quintile3)

*Estimate the models within each subgroup
streg smterrorWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent  if quintile3a==1, dist(lognormal) nolog 
streg smterrorWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent  if quintile3a==2, dist(lognormal) nolog
streg smterrorWarRelated lpopns ethfrac ln_gdpen inst2 regd4 absent  if quintile3a==3, dist(lognormal) nolog

clear

***************************
* Selection Model         *
***************************
use duration_main_est.dta

*Need to create a selection variable 
gen useterrorism = .
replace useterrorism = 0 if totalAttacksNo93 == 0
replace useterrorism = 1 if totalAttacksNo93 == 1

*need to get the dursel STATA program
*findit dursel
*Table D.1: Model 13 logged/lagged terrorism
dursel warmonths logTotalWarRelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, sel(useterrorism=logpop mountains elf ) dist(exp) 

*Table D.1: Model 14 logged/lagged terrorism
*smoothed
dursel warmonths smterrorwarrelated logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, sel(useterrorism=logpop mountains elf ) dist(exp) 

clear

***************************
* Selection Model         *
***************************
use recurrence_main_est.dta

*Need to create a selection variable 
gen useterrorism = .
replace useterrorism = 0 if totalAttacksNo93 == 0
replace useterrorism = 1 if totalAttacksNo93 == 1

*Table D.2: Model 15 logged/lagged terrorism
dursel pdur logTotalWarRelated lpopns ln_gdpen inst2  regd4, sel(useterrorism=lpopns absent) dist(lognormal) 

//NOTE: Can't use absent or ethfrac in the outcome equation won't estimate

*Table D.2: Model 16 smoothed terrorism
dursel pdur smterrorWarRelated lpopns ln_gdpen inst2  regd4, sel(useterrorism=lpopns absent) dist(lognormal) 


***********************************************
* Alternative Ways to Operationalize the DV   *
***********************************************
use duration_main_est.dta, clear

*Table D.3: Model 17 logged/lagged terrorism
streg lagLogTotalAttacks logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, dist(lognormal) 

*Table D.3: Model 18 smoothed terrorism
streg smterror  logpop elf  lngdp uppsalaMaxed logbattledeaths mountains guarantee, dist(lognormal) 

clear

***********************************************
* Alternative Ways to Operationalize the DV   *
***********************************************
use recurrence_main_est.dta

*Table D.3: Model 19 logged/lagged terrorism
streg lagLogTotalAttacks lpopns ethfrac ln_gdpen inst2 regd4 absent, dist(lognormal) nolog

*Table D.3: Model 20 smoothed terrorism
streg smterror lpopns ethfrac ln_gdpen inst2 regd4 absent, dist(lognormal) nolog 





