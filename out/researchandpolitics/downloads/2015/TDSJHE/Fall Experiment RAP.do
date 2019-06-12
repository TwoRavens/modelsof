clear all
set more off, perm
set seed 0210 
set scheme s2mono 
use "N:\Personal Research - Desirability of pork\Fall 2011 Earmark Experiment\Fall Data\c1-c15_FINAL_v2.dta"
*
qui {
drop ryan* pers* ran* rubio* hyp* fav* comp* econ*
*my variables
sum nat_debt miller_pork2 miller_pork1d  fed_waste ///
miller_pork1c miller_pork1b miller_pork1a military
**Controls**
recode pid (99=.)
label variable pid `"1=rep, 2=dem, 3= ind, 4=other"'
label variable pid1_dem `"1=str dem, 2=not very str dem"'
label variable pid1_rep `"1=str rep, 2=not very str rep"'
label variable pid2_ind `"1=lean rep, 2=lean dem, 3=neither"'
*
rename gender male
recode male (99=.) (2=0)
label variable male `"1=male, 0=fem"'
*
gen Dem = .
recode Dem (.=5) if pid1_dem==1
recode Dem (.=4) if pid1_dem==2
recode Dem (.=1) if pid1_rep==1
recode Dem (.=2) if pid1_rep==2
recode Dem (.=3) if (pid==3 | pid==4)
label variable Dem `"5=str dem, 3=ind/other, 1=str rep"'
*
gen Dem2 = .
recode Dem2 (.=6) if pid1_dem==1
recode Dem2 (.=5) if pid1_dem==2
recode Dem2 (.=1) if pid1_rep==1
recode Dem2 (.=2) if pid1_rep==2
recode Dem2 (.=3) if pid2_ind==1
recode Dem2 (.=4) if pid2_ind==2
label variable Dem2 `"6=str dem, 4=lean dem, 3=lean rep, 1=str rep"'
*note, this ^^ omits the other category from pid; n=29 "others"
*
*gen pid with a 5 point scale, already done
gen PID = Dem
label variable PID `"1=str rep, 3=ind, 5=str dem"'
*
*pol sophis vars
label variable unempl `"unemp at 5%, 10% or 20%?: 1, 2, 3"'
replace unempl = . if unempl==99
*
recode race (99=.)
label variable race `"1= white, 2, black, 3 latino, 4 asian, 5 native, 6 other"'
gen white = race
recode white (2/6=0) 
label variable white `"white =1, other 0"'
*
recode obama (1=5) (2=4) (4=2) (5=1)
label variable obama `"5=strong approve, 1=strongly disapprove"'
*
rename surve1 NumSurvey
recode NumSurvey (99=.) (1=0) (2=1) (3=2) (4=3)
label variable NumSurvey `"how many survey in lab before? 0=0; 3=3 or more"'
*
label variable military `"1=yes, 0=no"'
recode military (2=0) (99=.)
*keep only those i care about
/* keep  miller*  fed_waste NumSurvey military Dem Dem2 unempl ///
obama nat_debt white race PID* pid* */

**Pork**
label variable fed_waste `"1=not wasteful, 5= extremely wasteful"'
label variable nat_debt `"1=not concerned, 5=extreme concern"'
*
recode miller_pork1a (99=.) (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
label variable miller_pork1a `"FL pork: Feel towards? 1=very unfav->7=very fav"'
recode miller_pork1b (99=.) (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
label variable miller_pork1b `"FL pork+educ pork: Feel towards? 1=very unfav->7=very fav"'
recode miller_pork1c (99=.) (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
label variable miller_pork1c `"FL pork+military Feel towards? 1=very unfav->7=very fav"'
recode miller_pork1d (99=.) (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
label variable miller_pork1d `"Control feelings towards miller"'
*
rename miller_pork2 millerapprov
recode millerapprov (99=.) (7=1) (6=2) (5=3) (3=5) (2=6) (1=7)
label variable millerapprov `"approve Miller job doing? 7=str approve, 1=str disapprove"'
egen millerAll = rowfirst(miller_pork1a miller_pork1b miller_pork1c miller_pork1d) /*merge into one var */
label variable millerAll `"feeligns towards miller 7= very fav, 1= very disfav"'
gen millerInd = (millerAll + millerapprov)/2 /*AVR of the two  measures */
*
gen porka = 0 /*place holders */
gen porkb = 0
gen porkc = 0
gen porkControl = 0
recode porka (0=1) if miller_pork1a~=. /*recode 0->1 if it is NOT = missing */
recode porkb (0=1) if miller_pork1b~=. /* for diff in diff*/
recode porkc (0=1) if miller_pork1c~=.
recode porkControl (0=1) if miller_pork1d~=.
label variable porka `"FL pork, then feelings towards miller"'
label variable porkb `"FL pork+educ, then feelings towards miller"'
label variable porkc `"FL pork+military, then feelings towards miller"'
/*note that the above coding would mean that a lot of missing variables are coding
as 0's (observations), but this isn't a problem since they will be listwise
deleted down to 450 (actual population) because of the Dep. var. and the controls
*/
}



*cronbach's alpha to know if i can combine
alpha millerAll  millerapprov
pwcorr millerAll  millerapprov, sig
*
global pork porka porkb porkc //porkd is the control group
gen MilXpork_mil = military*porkc
*
**********   THE MODEL ********************
reg millerInd $pork military MilXpork_mil //the model
est sto model
* for appendix, run as ordered probit*
estout model, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) delimiter(;) 
*
*********** MGFX *************************
*what is the actual total effect of military for those in the mil?
estsimp reg millerInd $pork military MilXpork_mil, sims(2000)
setx (porka porkb) 0 porkc 1 military 1 MilXpork_mil 1
simqi, fd(ev) changex(porkc 0 1 military 0 1 MilXpork_mil 0 1)
*figure treat and mil: 0.8849593 se=.2454285
*treat mil NOT in mil .0866102 se = .1255171
*educ treat ~ mil = .85369 se .1193839
*gen ~ mil = .159697 se .1256232
**** THE MODEL *************** ^^^^
estadd beta
/* now to perform some tests to confirm the educ and mil conditions are 
satistically different from the general */
test porka = porkb 
test porka = porkc
test porka = MilXpork_mil
test porkb = porkc
test porka=porkb=porkc //good they are different
test porka = MilXpork_mil + porkc + military //gen vs military

*************   ExTRA TESTS *******************
*mann whitney
gen millerInd2 = millerInd
gen millerInd3=millerInd
gen millerInd4 = millerInd
replace millerInd2=. if porkControl==1
replace millerInd2=. if porkc==1 //to test if general (a)=educ (b)
*
replace millerInd3=. if porkControl==1
replace millerInd3=. if porkb==1 //to test if general(a)=mil(c)
*
*Wilcoxon rank-sum (Mann-Whitney)test
ranksum millerInd2, by(porkb) //yes, educ is diff from general
ranksum millerInd3, by(MilXpork_mil) //yes mil treat is diff from gen, barely
est sto A

*
*************
********************** APPENDIX *****************************
********************
*Randomization Checks
reg millerInd $pork military MilXpork_mil
probit porka Dem male NumSurvey race unempl military 
est sto G
probit porkb Dem male NumSurvey race unempl military 
est sto E
probit porkc Dem male NumSurvey race unempl military 
est sto M
probit porkControl Dem male NumSurvey race unempl military 
est sto C
estout G E M C, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(* 0.05 ** 0.01 *** 0.001) delimiter(;)

*treatment * PID effects
reg millerInd $pork Dem military MilXpork_mil //THE MODEL
gen interA = porka*Dem
gen interB = porkb*Dem
gen interC = porkc*Dem
gen interMil = military*Dem
gen mil_interC = military*interC //threeway interaction
reg millerInd $pork Dem military MilXpork_mil interA interB interC interMil mil_interC //not significant
est sto millerI
estout millerI, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) delimiter(;)

*disaggregate the miller approval measure
*millerind = millerAll millerapprov
reg millerInd $pork military MilXpork_mil //THE MODEL originally
reg millerAll $pork military MilXpork_mil 
est sto miller_fav_reg
reg millerapprov $pork military MilXpork_mil 
est sto miller_approv_reg

estout miller_fav_reg miller_approv_reg, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) delimiter(;)


* order probit instead, and with disaggregated dep var
reg millerInd $pork Dem military MilXpork_mil //the original
oprobit millerInd $pork military MilXpork_mil //the model ordered
est sto ordered
oprobit millerAll $pork military MilXpork_mil
est sto orderedfav
oprobit millerapprov $pork military MilXpork_mil
est sto orderedapprov

estout model ordered orderedfav orderedapprov, style(tab) cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(r2  N) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) delimiter(;)
*

