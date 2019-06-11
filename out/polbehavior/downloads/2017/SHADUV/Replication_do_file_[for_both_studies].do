
* Do-file for all the analyses reported in the article:

* 	"POLICY AND BLAME ATTRIBUTION: CITIZENS' PREFERENCES, POLICY REPUTATIONS,
*    AND POLICY SURPRISES"

* The file begins with the analyses of the Israeli (IL) experiment, followed by the analyses
* of the German (DE) experiment.

*********************
*** IL Experiment ***
*********************

* OPEN DATA FILE: IL_experiment.dta

*****************************************
*** TABLE A1 (IL Randomization check) ***
*****************************************
mlogit condition right q3 male byear relid edu if stat==1
*****************************************

***gender
prtest male == .4933 if stat==1

******************************************
*** FIGURE A3 (IL Manipulation Checks) *** 
******************************************
regress q8 i.O_PM if right_policy==1 & stat==1
margins O_PM
marginsplot

regress q8 i.O_PM if right_policy==0 & stat==1
margins O_PM
marginsplot
******************************************

******************************
*** TABLE A3 (IL analysis) ***
******************************
regress RA c_AD c_PD party_id incog i.O_PM i.right_policy c.right c.q3 if stat==1, beta

***************************
*** FIGURE 2 (IL panel) ***
***************************
coefplot, drop(_cons 1.O_PM 2.O_PM 1.right_policy right q3) xline(0)
***************************

********************************************************************
*** TABLE A4: Estimating Observable Effects – Israeli Experiment ***
********************************************************************
regress RA PD##AD party_id i.O_PM right_policy right q3 if stat==1
********************************************************************

************************************************
*** FIGURE 3: panels (a) & (c) (IL analyses) ***
************************************************
margins PD#AD
marginsplot
*COMPARE CONDITION EFFECTS
margins AD@PD, mcompare(bonferroni)
margins PD@AD, mcompare(bonferroni)

regress RA incog##AD party_id i.O_PM right_policy right q3 if stat==1
margins AD#incog
marginsplot
************************************************

*COMPARE CONDITION EFFECTS
margins incog@AD, mcompare(bonferroni)

*******************************
*** ANALYSES FOR APPENDIX 6 ***
*******************************
*ROBUSTNESS TESTS FOR POLARIZATION LEVELS OF AGENT AND POLICY
regress RA c_AD party_id incog i.O_PM i.right_policy c.right c.q3 if stat==1, level(90)
regress RA AD_01 party_id incog i.O_PM right_policy right q3 if stat==1, level(90)
regress RA AD_02 party_id incog i.O_PM right_policy right q3 if stat==1, level(90)
regress RA AD_03 party_id incog i.O_PM right_policy right q3 if stat==1, level(90)
regress RA AD_04 party_id incog i.O_PM right_policy right q3 if stat==1, level(90)

regress RA c_PD party_id incog i.O_PM i.right_policy c.right c.q3 if stat==1, level(90)
regress RA PD_01 party_id incog i.O_PM right_policy right q3 if stat==1, level(90)
regress RA PD_02 party_id incog i.O_PM right_policy right q3 if stat==1, level(90)
regress RA PD_03 party_id incog i.O_PM right_policy right q3 if stat==1, level(90)
regress RA PD_04 party_id incog i.O_PM right_policy right q3 if stat==1, level(90)


************************************************
************************************************
************************************************
clear
************************************************
************************************************
************************************************


*********************
*** DE Experiment ***
*********************

* OPEN DATA FILE: DE_experiment.dta


******************************
*** RESPONSIBILITY MEASURE ***
******************************
alpha Responsibility Anger Resignation if IMC==1
factor Responsibility Anger Resignation
******************************


*****************************************
*** TABLE A2 (DE Randomization check) ***
*****************************************
mlogit condition male age education right intention_to_vote vote_cdu ///
vote_spd vote_fdp vote_green vote_linke vote_piraten if IMC==1
*****************************************


******************************************
*** FIGURE A4 (DE Manipulation Checks) *** 
******************************************
regress adopt_likelihood i.R_coalition if IMC==1 & R_policy==1
margins R_coalition
marginsplot

regress adopt_likelihood i.R_coalition if IMC==1 & R_policy==0
margins R_coalition
marginsplot
******************************************


******************************
*** TABLE A3 (DE analysis) ***
******************************
regress RA c_AD c_PD party_id incongruent R_coalition R_policy right1 ///
education if IMC==1, beta

***************************
*** FIGURE 2 (DE panel) ***
***************************
coefplot, drop(_cons R_coalition R_policy right1 education) xline(0)
***************************


*******************************************************************
*** TABLE A5: Estimating Observable Effects – German Experiment ***
*******************************************************************
regress RA i.CPD##i.AD party_id R_coalition R_policy right1 education if IMC==1

************************************************
*** FIGURE 3: panels (b) & (d) (DE analyses) ***
************************************************
margins CPD#AD
marginsplot

regress RA i.incongruent##i.AD party_id R_coalition R_policy right1 education if IMC==1
margins AD#incongruent
marginsplot

*COMPARE CONDITION EFFECTS
margins r.CPD@AD, mcompare(bonferroni)
margins r.AD@CPD, mcompare(bonferroni)
margins r.incongruent@AD, mcompare(bonferroni)
************************************************

******************************************
*** TABLE 5: Causal Mediation Analyses ***
******************************************
* 'incongruent' as treatment (incongruence->motivation->RA)
medeff(logit ideol_policy party_id R_coalition R_policy right1 education ///
age male incongruent) (regress RA ideol_policy party_id R_coalition R_policy ///
right1 education age male incongruent) if IMC==1, mediate(ideol_policy) ///
treat(incongruent) sims(700)

* 'AD' as treatment (AD->motivation->RA)
medeff(logit ideol_policy party_id R_coalition R_policy right1 education ///
age male AD) (regress RA ideol_policy party_id R_coalition R_policy right1 ///
education age male incongruent AD) if IMC==1, mediate(ideol_policy) treat(AD) sims(700)

* 'AD' as treatment - separately under CPD=0 and CPD=1
medeff(logit ideol_policy party_id R_coalition R_policy right1 education ///
age male AD) (regress RA ideol_policy party_id R_coalition R_policy right1 ///
education age male AD) if IMC==1 & CPD==0, mediate(ideol_policy) treat(AD) sims(350)

medeff(logit ideol_policy party_id R_coalition R_policy right1 education ///
age male AD) (regress RA ideol_policy party_id R_coalition R_policy right1 ///
education age male AD) if IMC==1 & CPD==1, mediate(ideol_policy) treat(AD) sims(350)

* 'CPD' as treatment
medeff(logit ideol_policy party_id R_coalition R_policy right1 education ///
age male CPD) (regress RA ideol_policy party_id R_coalition R_policy right1 ///
education age male CPD) if IMC==1, mediate(ideol_policy) treat(CPD) sims(700)

* 'CPD' as treatment - separately under AD=1 and AD=0
medeff(logit ideol_policy party_id R_coalition R_policy right1 education ///
age male CPD) (regress RA ideol_policy party_id R_coalition R_policy right1 ///
education age male CPD) if IMC==1 & AD==0, mediate(ideol_policy) treat(CPD) sims(350)

medeff(logit ideol_policy party_id R_coalition R_policy right1 education ///
age male CPD) (regress RA ideol_policy party_id R_coalition R_policy right1 ///
education age male CPD) if IMC==1 & AD==1, mediate(ideol_policy) treat(CPD) sims(350)
******************************************


*******************************
*** ANALYSES FOR APPENDIX 6 ***
*******************************
*ROBUSTNESS TESTS FOR POLARIZATION LEVELS OF AGENT AND POLICY
regress RA c_AD party_id incongruent R_coalition R_policy right1 ///
education if IMC==1, level(90)
regress RA AD_01 party_id incongruent R_coalition R_policy right1 ///
education if IMC==1, level(90)
regress RA AD_02 party_id incongruent R_coalition R_policy right1 ///
education if IMC==1, level(90)
regress RA AD_03 party_id incongruent R_coalition R_policy right1 ///
education if IMC==1, level(90)
regress RA AD_04 party_id incongruent R_coalition R_policy right1 ///
education if IMC==1, level(90)

regress RA c_PD party_id incongruent R_coalition R_policy right1 ///
education if IMC==1, level(90)
regress RA PD_01 party_id incongruent R_coalition R_policy right1 ///
education if IMC==1, level(90)
regress RA PD_02 party_id incongruent R_coalition R_policy right1 ///
education if IMC==1, level(90)
regress RA PD_03 party_id incongruent R_coalition R_policy right1 ///
education if IMC==1, level(90)
regress RA PD_04 party_id incongruent R_coalition R_policy right1 ///
education if IMC==1, level(90)
*******************************
