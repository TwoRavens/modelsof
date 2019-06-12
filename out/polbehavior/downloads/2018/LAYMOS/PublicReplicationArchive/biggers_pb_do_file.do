/* "Does Partisan Self-Interest Dictate Support for Election Reform? Experimental 
Evidence on the Willingness of Citizens to Alter the Costs of Voting for Electoral Gain"
 Daniel R. Biggers
 Political Behavior
 
 ******************************************************

 This Stata .do file performs all of the analyses
 and recreates the tables in both the main text and
 supplemental appendix.

******************************************************/

set more off

*set working directory, start log file, and load data for experiment 1.
cd ""
log using logs\run_main_do_file.log, replace
use data\biggers_pb_study1_mturk_data.dta, clear

**********************************************************************
*Table 2 - Democrats (MTurk).
**********************************************************************

*set constant sample across DVs and covariates (no missing data).
qui reg ID_DV EV_DV EDR_DV age female educ nonwhite polint
gen useme=1 if e(sample)

reg ID_DV i.ID_treat if Dem==1 & useme==1, r
outreg2 using tables\Table2_DemMTurk.out, bracket dec(3) addnote("Note: OLS regression coefficients presented with robust standard errors in brackets. Democrats identified based on a seven point party identification scale, with leaners coded as partisans. Dependent variable is extent of support for election reform (1=strongly favor, 2=somewhat favor, 3=somewhat oppose, 4=strongly oppose). *** p<0.01, ** p<0.05, * p<0.1, one-tailed for linear combination of coefficients tests") title("Table 2. Democratic Support for Election Reforms by Treatment Assignment, Experiment 1")  ctitle("Voter Identification") replace
lincom 5.ID_treat - 6.ID_treat

reg ID_DV i.ID_treat age female educ nonwhite polint i.ordering_ID if Dem==1 & useme==1, r
outreg2 using tables\Table2_DemMTurk.out, bracket dec(3) ctitle("Voter Identification") append
lincom 5.ID_treat - 6.ID_treat

reg EV_DV i.EV_treat if Dem==1 & useme==1, r
outreg2 using tables\Table2_DemMTurk.out, bracket dec(3) ctitle("Early Voting") append
lincom 5.EV_treat - 6.EV_treat

reg EV_DV i.EV_treat age female educ nonwhite polint i.ordering_EV if Dem==1 & useme==1, r
outreg2 using tables\Table2_DemMTurk.out, bracket dec(3) ctitle("Early Voting") append
lincom 5.EV_treat - 6.EV_treat

reg EDR_DV i.EDR_treat if Dem==1 & useme==1, r
outreg2 using tables\Table2_DemMTurk.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 5.EDR_treat - 6.EDR_treat

reg EDR_DV i.EDR_treat age female educ nonwhite polint i.ordering_EDR if Dem==1 & useme==1, r
outreg2 using tables\Table2_DemMTurk.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 5.EDR_treat - 6.EDR_treat


**********************************************************************
*Table 3 - Republicans (MTurk).
**********************************************************************

reg ID_DV i.ID_treat if Rep==1 & useme==1, r
outreg2 using tables\Table3_RepMTurk.out, bracket dec(3) addnote("Note: OLS regression coefficients presented with robust standard errors in brackets. Republicans identified based on a seven point party identification scale, with leaners coded as partisans. Dependent variable is extent of support for election reform (1=strongly favor, 2=somewhat favor, 3=somewhat oppose, 4=strongly oppose). *** p<0.01, ** p<0.05, * p<0.1, one-tailed for linear combination of coefficients tests") title("Table 3. Republican Support for Election Reforms by Treatment Assignment, Experiment 1") ctitle("Voter Identification") replace
lincom 5.ID_treat - 6.ID_treat

reg ID_DV i.ID_treat age female educ nonwhite polint i.ordering_ID if Rep==1 & useme==1, r
outreg2 using tables\Table3_RepMTurk.out, bracket dec(3) ctitle("Voter Identification") append
lincom 5.ID_treat - 6.ID_treat

reg EV_DV i.EV_treat if Rep==1 & useme==1, r
outreg2 using tables\Table3_RepMTurk.out, bracket dec(3) ctitle("Early Voting") append
lincom 5.EV_treat - 6.EV_treat

reg EV_DV i.EV_treat age female educ nonwhite polint i.ordering_EV if Rep==1 & useme==1, r
outreg2 using tables\Table3_RepMTurk.out, bracket dec(3) ctitle("Early Voting") append
lincom 5.EV_treat - 6.EV_treat

reg EDR_DV i.EDR_treat if Rep==1 & useme==1, r
outreg2 using tables\Table3_RepMTurk.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 5.EDR_treat - 6.EDR_treat

reg EDR_DV i.EDR_treat age female educ nonwhite polint i.ordering_EDR if Rep==1 & useme==1, r
outreg2 using tables\Table3_RepMTurk.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 5.EDR_treat - 6.EDR_treat


*Democratic support for EV mentioned in text.
tab EV_DV EV_treat if Dem==1 & useme==1, col
*Republican support for voter ID mentioned in text.
tab ID_DV ID_treat if Rep==1 & useme==1, col


**********************************************************************
*Table SA1 - Sample Characteristics
**********************************************************************

tab educ, gen(educ_)
tab polint, gen(polint_)
outsum age female educ_* nonwhite polint_* Dem Rep using tables\TableSA1_SampleCrosstabs.out, bracket addnote("Note; Standard deviations in brackets") title("Table SA1. Sample Characteristics for Experiments 1 & 2") ctitle("MTurk Sample") replace
drop educ_* polint_*


**********************************************************************
*Table SA4 - Balance Tests
**********************************************************************

*SA4-1. Voter ID.
mlogit ID_treat age female educ nonwhite polint, baseoutcome(1)
outsum age female educ nonwhite polint if ID_treat==1 using tables\TableSA4-1_Exp1Balance.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is not significant (χ2(25) = 28.46, p = .29).") title("Table SA4-1. Experiment 1 Tests of Balance for Treatment Assignment, Voter ID Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if ID_treat==2 using tables\TableSA4-1_Exp1Balance.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if ID_treat==3 using tables\TableSA4-1_Exp1Balance.out, bracket ctitle("Democrats Treatment") append
outsum age female educ nonwhite polint if ID_treat==4 using tables\TableSA4-1_Exp1Balance.out, bracket ctitle("Elderly Treatment") append
outsum age female educ nonwhite polint if ID_treat==5 using tables\TableSA4-1_Exp1Balance.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if ID_treat==6 using tables\TableSA4-1_Exp1Balance.out, bracket ctitle("Dem Elderly Treatment") append

*SA4-2. Early Voting.
mlogit EV_treat age female educ nonwhite polint, baseoutcome(1)
outsum age female educ nonwhite polint if EV_treat==1 using tables\TableSA4-2_Exp1Balance.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is not significant (χ2(25) = 21.96, p = .64).") title("Table SA4-2. Experiment 1 Tests of Balance for Treatment Assignment, Early Voting Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if EV_treat==2 using tables\TableSA4-2_Exp1Balance.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if EV_treat==3 using tables\TableSA4-2_Exp1Balance.out, bracket ctitle("Democrats Treatment") append
outsum age female educ nonwhite polint if EV_treat==4 using tables\TableSA4-2_Exp1Balance.out, bracket ctitle("Elderly Treatment") append
outsum age female educ nonwhite polint if EV_treat==5 using tables\TableSA4-2_Exp1Balance.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if EV_treat==6 using tables\TableSA4-2_Exp1Balance.out, bracket ctitle("Dem Elderly Treatment") append

*SA4-3. EDR.
mlogit EDR_treat age female educ nonwhite polint, baseoutcome(1)
outsum age female educ nonwhite polint if EDR_treat==1 using tables\TableSA4-3_Exp1Balance.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is not significant (χ2(25) = 34.50, p = .10).") title("Table SA4-3. Experiment 1 Tests of Balance for Treatment Assignment, Election Day Registration Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if EDR_treat==2 using tables\TableSA4-3_Exp1Balance.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if EDR_treat==3 using tables\TableSA4-3_Exp1Balance.out, bracket ctitle("Democrats Treatment") append
outsum age female educ nonwhite polint if EDR_treat==4 using tables\TableSA4-3_Exp1Balance.out, bracket ctitle("Elderly Treatment") append
outsum age female educ nonwhite polint if EDR_treat==5 using tables\TableSA4-3_Exp1Balance.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if EDR_treat==6 using tables\TableSA4-3_Exp1Balance.out, bracket ctitle("Dem Elderly Treatment") append


**********************************************************************
*Table SA6 - Ordered Logit Models.
**********************************************************************

*SA6-1.
ologit ID_DV i.ID_treat if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-1_Table2Ologit.out, bracket dec(3) addnote("Note: Ordered logistic regression coefficients presented with robust standard errors in brackets. Democrats identified based on a seven point party identification scale, with leaners coded as partisans. Dependent variable is extent of support for election reform (1=strongly favor, 2=somewhat favor, 3=somewhat oppose, 4=strongly oppose). *** p<0.01, ** p<0.05, * p<0.1, one-tailed for linear combination of coefficients tests") title("Table SA6-1. Replication of Table 2 Using Ordered Logistic Regression") ctitle("Voter Identification") replace
lincom 5.ID_treat - 6.ID_treat

ologit ID_DV i.ID_treat age female educ nonwhite polint i.ordering_ID if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-1_Table2Ologit.out, bracket dec(3) ctitle("Voter Identification")  append
lincom 5.ID_treat - 6.ID_treat

ologit EV_DV i.EV_treat if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-1_Table2Ologit.out, bracket dec(3) ctitle("Early Voting")  append
lincom 5.EV_treat - 6.EV_treat

ologit EV_DV i.EV_treat age female educ nonwhite polint i.ordering_EV if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-1_Table2Ologit.out, bracket dec(3) ctitle("Early Voting") append
lincom 5.EV_treat - 6.EV_treat

ologit EDR_DV i.EDR_treat if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-1_Table2Ologit.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 5.EDR_treat - 6.EDR_treat

ologit EDR_DV i.EDR_treat age female educ nonwhite polint i.ordering_EDR if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-1_Table2Ologit.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 5.EDR_treat - 6.EDR_treat

*SA6-2.
ologit ID_DV i.ID_treat if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-2_Table3Ologit.out, bracket dec(3) addnote("Note: Ordered logistic regression coefficients presented with robust standard errors in brackets. Republicans identified based on a seven point party identification scale, with leaners coded as partisans. Dependent variable is extent of support for election reform (1=strongly favor, 2=somewhat favor, 3=somewhat oppose, 4=strongly oppose). *** p<0.01, ** p<0.05, * p<0.1, one-tailed for linear combination of coefficients tests") title("Table SA6-2. Replication of Table 3 Using Ordered Logistic Regression") ctitle("Voter Identification") replace
lincom 5.ID_treat - 6.ID_treat

ologit ID_DV i.ID_treat age female educ nonwhite polint i.ordering_ID if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-2_Table3Ologit.out, bracket dec(3) ctitle("Voter Identification") append
lincom 5.ID_treat - 6.ID_treat

ologit EV_DV i.EV_treat if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-2_Table3Ologit.out, bracket dec(3) ctitle("Early Voting") append
lincom 5.EV_treat - 6.EV_treat

ologit EV_DV i.EV_treat age female educ nonwhite polint i.ordering_EV if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-2_Table3Ologit.out, bracket dec(3) ctitle("Early Voting") append
lincom 5.EV_treat - 6.EV_treat

ologit EDR_DV i.EDR_treat if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-2_Table3Ologit.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 5.EDR_treat - 6.EDR_treat

ologit EDR_DV i.EDR_treat age female educ nonwhite polint i.ordering_EDR if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-2_Table3Ologit.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 5.EDR_treat - 6.EDR_treat


**********************************************************************
*Table SA8 - Surey Marginals.
**********************************************************************

*SA8-1.
tab ID_DV, gen(ID_DV_)
outsum ID_DV_* if ID_treat==1 & Dem==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket title("Table SA8-1. Survey Marginals for Experiment 1 Voter Identification Question, by Treatment") ctitle("Control") replace
outsum ID_DV_* if ID_treat==2 & Dem==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum ID_DV_* if ID_treat==3 & Dem==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket ctitle("Democrats Treatment") append
outsum ID_DV_* if ID_treat==4 & Dem==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket ctitle("Elderly Treatment") append
outsum ID_DV_* if ID_treat==5 & Dem==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum ID_DV_* if ID_treat==6 & Dem==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket ctitle("Dem Elderly Treatment") append

outsum ID_DV_* if ID_treat==1 & Rep==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket ctitle("Control") append
outsum ID_DV_* if ID_treat==2 & Rep==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum ID_DV_* if ID_treat==3 & Rep==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket ctitle("Democrats Treatment") append
outsum ID_DV_* if ID_treat==4 & Rep==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket ctitle("Elderly Treatment") append
outsum ID_DV_* if ID_treat==5 & Rep==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum ID_DV_* if ID_treat==6 & Rep==1 & useme==1 using Tables\TableSA8-1_Marginals.out, bracket ctitle("Dem Elderly Treatment") append

*SA8-2.
tab EV_DV, gen(EV_DV_)
outsum EV_DV_* if EV_treat==1 & Dem==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket title("Table SA8-2. Survey Marginals for Experiment 1 Early Voting Question, by Treatment") ctitle("Control") replace
outsum EV_DV_* if EV_treat==2 & Dem==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum EV_DV_* if EV_treat==3 & Dem==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket ctitle("Democrats Treatment") append
outsum EV_DV_* if EV_treat==4 & Dem==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket ctitle("Elderly Treatment") append
outsum EV_DV_* if EV_treat==5 & Dem==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum EV_DV_* if EV_treat==6 & Dem==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket ctitle("Dem Elderly Treatment") append

outsum EV_DV_* if EV_treat==1 & Rep==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket ctitle("Control") append
outsum EV_DV_* if EV_treat==2 & Rep==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum EV_DV_* if EV_treat==3 & Rep==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket ctitle("Democrats Treatment") append
outsum EV_DV_* if EV_treat==4 & Rep==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket ctitle("Elderly Treatment") append
outsum EV_DV_* if EV_treat==5 & Rep==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum EV_DV_* if EV_treat==6 & Rep==1 & useme==1 using Tables\TableSA8-2_Marginals.out, bracket ctitle("Dem Elderly Treatment") append

*SA8-3.
tab EDR_DV, gen(EDR_DV_)
outsum EDR_DV_* if EDR_treat==1 & Dem==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket title("Table SA8-3. Survey Marginals for Experiment 1 Election Day Registration Question, by Treatment") ctitle("Control") replace
outsum EDR_DV_* if EDR_treat==2 & Dem==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum EDR_DV_* if EDR_treat==3 & Dem==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket ctitle("Democrats Treatment") append
outsum EDR_DV_* if EDR_treat==4 & Dem==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket ctitle("Elderly Treatment") append
outsum EDR_DV_* if EDR_treat==5 & Dem==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum EDR_DV_* if EDR_treat==6 & Dem==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket ctitle("Dem Elderly Treatment") append

outsum EDR_DV_* if EDR_treat==1 & Rep==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket ctitle("Control") append
outsum EDR_DV_* if EDR_treat==2 & Rep==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum EDR_DV_* if EDR_treat==3 & Rep==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket ctitle("Democrats Treatment") append
outsum EDR_DV_* if EDR_treat==4 & Rep==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket ctitle("Elderly Treatment") append
outsum EDR_DV_* if EDR_treat==5 & Rep==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum EDR_DV_* if EDR_treat==6 & Rep==1 & useme==1 using Tables\TableSA8-3_Marginals.out, bracket ctitle("Dem Elderly Treatment") append


***************************

*load data for experiment 2.
use data\biggers_pb_study2_cces_data.dta, clear

**********************************************************************
*Table 4 - Dem CCES.
**********************************************************************

*set constant sample across DVs and covariates (no missing data).
qui reg ID_DV EV_DV EDR_DV age female educ nonwhite polint
gen useme=1 if e(sample)

reg ID_DV i.ID_treat if Dem==1 & useme==1, r
outreg2 using tables\Table4_DemCCES.out, bracket dec(3) addnote("Note: OLS regression coefficients presented with robust standard errors in brackets. Democrats identified based on a seven point party identification scale, with leaners coded as partisans. Dependent variable is extent of support for election reform (1=strongly favor, 2=somewhat favor, 3=somewhat oppose, 4=strongly oppose). *** p<0.01, ** p<0.05, * p<0.1, one-tailed for linear combination of coefficients tests") title("Table 4. Democratic Support for Election Reforms by Treatment Assignment, Experiment 2") ctitle("Voter Identification") replace
lincom 3.ID_treat-4.ID_treat

reg ID_DV i.ID_treat age female educ nonwhite polint i.ordering_ID if Dem==1 & useme==1, r
outreg2 using tables\Table4_DemCCES.out, bracket dec(3) ctitle("Voter Identification") append
lincom 3.ID_treat-4.ID_treat

reg EV_DV i.EV_treat if Dem==1 & useme==1, r
outreg2 using tables\Table4_DemCCES.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

reg EV_DV i.EV_treat age female educ nonwhite polint i.ordering_EV if Dem==1 & useme==1, r
outreg2 using tables\Table4_DemCCES.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

reg EDR_DV i.EDR_treat if Dem==1 & useme==1, r
outreg2 using tables\Table4_DemCCES.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat

reg EDR_DV i.EDR_treat age female educ nonwhite polint i.ordering_EDR if Dem==1 & useme==1, r
outreg2 using tables\Table4_DemCCES.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat


**********************************************************************
*Table 5 - Rep CCES.
**********************************************************************

reg ID_DV i.ID_treat if Rep==1 & useme==1, r
outreg2 using tables\Table5_RepCCES.out, bracket dec(3) addnote("Note: OLS regression coefficients presented with robust standard errors in brackets. Republicans identified based on a seven point party identification scale, with leaners coded as partisans. Dependent variable is extent of support for election reform (1=strongly favor, 2=somewhat favor, 3=somewhat oppose, 4=strongly oppose). *** p<0.01, ** p<0.05, * p<0.1, one-tailed for linear combination of coefficients tests") title("Table 5. Republican Support for Election Reforms by Treatment Assignment, Experiment 2") ctitle("Voter Identification") replace
lincom 3.ID_treat-4.ID_treat

reg ID_DV i.ID_treat age female educ nonwhite polint i.ordering_ID if Rep==1 & useme==1, r
outreg2 using tables\Table5_RepCCES.out, bracket dec(3) ctitle("Voter Identification") append
lincom 3.ID_treat-4.ID_treat

reg EV_DV i.EV_treat if Rep==1 & useme==1, r
outreg2 using tables\Table5_RepCCES.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

reg EV_DV i.EV_treat age female educ nonwhite polint i.ordering_EV if Rep==1 & useme==1, r
outreg2 using tables\Table5_RepCCES.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

reg EDR_DV i.EDR_treat if Rep==1 & useme==1, r
outreg2 using tables\Table5_RepCCES.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat

reg EDR_DV i.EDR_treat age female educ nonwhite polint i.ordering_EDR if Rep==1 & useme==1, r
outreg2 using tables\Table5_RepCCES.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat


**********************************************************************
*Table SA1 - Sample Characteristics
**********************************************************************

tab educ, gen(educ_)
tab polint, gen(polint_)
outsum age female educ_* nonwhite polint_* Dem Rep using Tables\TableSA1_SampleCrosstabs.out, bracket ctitle("CCES Sample") append
drop educ_* polint_*


**********************************************************************
*Table SA6 - Ordered Logit Models.
**********************************************************************

*SA6-3.
ologit ID_DV i.ID_treat if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-3_Table4Ologit.out, bracket dec(3) addnote("Note: Ordered logistic regression coefficients presented with robust standard errors in brackets. Democrats identified based on a seven point party identification scale, with leaners coded as partisans. Dependent variable is extent of support for election reform (1=strongly favor, 2=somewhat favor, 3=somewhat oppose, 4=strongly oppose). *** p<0.01, ** p<0.05, * p<0.1, one-tailed for linear combination of coefficients tests") title("Table SA6-3. Replication of Table 4 Using Ordered Logistic Regression") ctitle("Voter Identification") replace
lincom 3.ID_treat-4.ID_treat

ologit ID_DV i.ID_treat age female educ nonwhite polint i.ordering_ID if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-3_Table4Ologit.out, bracket dec(3) ctitle("Voter Identification") append
lincom 3.ID_treat-4.ID_treat

ologit EV_DV i.EV_treat if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-3_Table4Ologit.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

ologit EV_DV i.EV_treat age female educ nonwhite polint i.ordering_EV if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-3_Table4Ologit.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

ologit EDR_DV i.EDR_treat if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-3_Table4Ologit.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat

ologit EDR_DV i.EDR_treat age female educ nonwhite polint i.ordering_EDR if Dem==1 & useme==1, r
outreg2 using tables\TableSA6-3_Table4Ologit.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat

*SA6-4.
ologit ID_DV i.ID_treat if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-4_Table5Ologit.out, bracket dec(3) addnote("Note: Ordered logistic regression coefficients presented with robust standard errors in brackets. Republicans identified based on a seven point party identification scale, with leaners coded as partisans. Dependent variable is extent of support for election reform (1=strongly favor, 2=somewhat favor, 3=somewhat oppose, 4=strongly oppose). *** p<0.01, ** p<0.05, * p<0.1, one-tailed for linear combination of coefficients tests") title("Table SA6-4. Replication of Table 5 Using Ordered Logistic Regression") ctitle("Voter Identification") replace
lincom 3.ID_treat-4.ID_treat

ologit ID_DV i.ID_treat age female educ nonwhite polint i.ordering_ID if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-4_Table5Ologit.out, bracket dec(3) ctitle("Voter Identification")  append
lincom 3.ID_treat-4.ID_treat

ologit EV_DV i.EV_treat if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-4_Table5Ologit.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

ologit EV_DV i.EV_treat age female educ nonwhite polint i.ordering_EV if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-4_Table5Ologit.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

ologit EDR_DV i.EDR_treat if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-4_Table5Ologit.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat

ologit EDR_DV i.EDR_treat age female educ nonwhite polint i.ordering_EDR if Rep==1 & useme==1, r
outreg2 using tables\TableSA6-4_Table5Ologit.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat


**********************************************************************
*Table SA8 - Surey Marginals.
**********************************************************************

*SA8-4.
tab ID_DV, gen(ID_DV_)
outsum ID_DV_* if ID_treat==1 & Dem==1 & useme==1 using tables\TableSA8-4_Marginals.out, bracket title("Table SA8-4. Survey Marginals for Experiment 2 Voter Identification Question, by Treatment") ctitle("Control") replace
outsum ID_DV_* if ID_treat==2 & Dem==1 & useme==1 using tables\TableSA8-4_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum ID_DV_* if ID_treat==3 & Dem==1 & useme==1 using tables\TableSA8-4_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum ID_DV_* if ID_treat==4 & Dem==1 & useme==1 using tables\TableSA8-4_Marginals.out, bracket ctitle("Dem Elderly Treatment") append

outsum ID_DV_* if ID_treat==1 & Rep==1 & useme==1 using tables\TableSA8-4_Marginals.out, bracket ctitle("Control") append
outsum ID_DV_* if ID_treat==2 & Rep==1 & useme==1 using tables\TableSA8-4_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum ID_DV_* if ID_treat==3 & Rep==1 & useme==1 using tables\TableSA8-4_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum ID_DV_* if ID_treat==4 & Rep==1 & useme==1 using tables\TableSA8-4_Marginals.out, bracket ctitle("Dem Elderly Treatment") append

*SA8-5.
tab EV_DV, gen(EV_DV_)
outsum EV_DV_* if EV_treat==1 & Dem==1 & useme==1 using tables\TableSA8-5_Marginals.out, bracket title("Table SA8-5. Survey Marginals for Experiment 2 Early Voting Question, by Treatment") ctitle("Control") replace
outsum EV_DV_* if EV_treat==2 & Dem==1 & useme==1 using tables\TableSA8-5_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum EV_DV_* if EV_treat==3 & Dem==1 & useme==1 using tables\TableSA8-5_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum EV_DV_* if EV_treat==4 & Dem==1 & useme==1 using tables\TableSA8-5_Marginals.out, bracket ctitle("Dem Elderly Treatment") append

outsum EV_DV_* if EV_treat==1 & Rep==1 & useme==1 using tables\TableSA8-5_Marginals.out, bracket ctitle("Control") append
outsum EV_DV_* if EV_treat==2 & Rep==1 & useme==1 using tables\TableSA8-5_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum EV_DV_* if EV_treat==3 & Rep==1 & useme==1 using tables\TableSA8-5_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum EV_DV_* if EV_treat==4 & Rep==1 & useme==1 using tables\TableSA8-5_Marginals.out, bracket ctitle("Dem Elderly Treatment") append

*SA8-6.
tab EDR_DV, gen(EDR_DV_)
outsum EDR_DV_* if EDR_treat==1 & Dem==1 & useme==1 using tables\TableSA8-6_Marginals.out, bracket title("Table SA8-6. Survey Marginals for Experiment 2 Election Day Registration Question, by Treatment") ctitle("Control") replace
outsum EDR_DV_* if EDR_treat==2 & Dem==1 & useme==1 using tables\TableSA8-6_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum EDR_DV_* if EDR_treat==3 & Dem==1 & useme==1 using tables\TableSA8-6_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum EDR_DV_* if EDR_treat==4 & Dem==1 & useme==1 using tables\TableSA8-6_Marginals.out, bracket ctitle("Dem Elderly Treatment") append

outsum EDR_DV_* if EDR_treat==1 & Rep==1 & useme==1 using tables\TableSA8-6_Marginals.out, bracket ctitle("Control") append
outsum EDR_DV_* if EDR_treat==2 & Rep==1 & useme==1 using tables\TableSA8-6_Marginals.out, bracket ctitle("Minorities Treatment") append
outsum EDR_DV_* if EDR_treat==3 & Rep==1 & useme==1 using tables\TableSA8-6_Marginals.out, bracket ctitle("Rep Elderly Treatment") append
outsum EDR_DV_* if EDR_treat==4 & Rep==1 & useme==1 using tables\TableSA8-6_Marginals.out, bracket ctitle("Dem Elderly Treatment") append


**********************************************************************
*Table SA9 - Balance Tests
**********************************************************************

*SA9-1.
mlogit ID_treat age female educ nonwhite polint, baseoutcome(1)
outsum age female educ nonwhite polint if ID_treat==1 using tables\TableSA9-1_Exp2Balance_UnMatched.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is not significant (χ2(15) = 16.60, p = .34).") title("Table SA9-1. Experiment 2 Tests of Balance for Treatment Assignment, Voter ID Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if ID_treat==2 using tables\TableSA9-1_Exp2Balance_UnMatched.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if ID_treat==3 using tables\TableSA9-1_Exp2Balance_UnMatched.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if ID_treat==4 using tables\TableSA9-1_Exp2Balance_UnMatched.out, bracket ctitle("Dem Elderly Treatment") append

*SA9-2.
mlogit EV_treat age female educ nonwhite polint, baseoutcome(1)
outsum age female educ nonwhite polint if EV_treat==1 using tables\TableSA9-2_Exp2Balance_UnMatched.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is not significant (χ2(15) = 8.90, p = .88).") title("Table SA9-2. Experiment 2 Tests of Balance for Treatment Assignment, Early Voting Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if EV_treat==2 using tables\TableSA9-2_Exp2Balance_UnMatched.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if EV_treat==3 using tables\TableSA9-2_Exp2Balance_UnMatched.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if EV_treat==4 using tables\TableSA9-2_Exp2Balance_UnMatched.out, bracket ctitle("Dem Elderly Treatment") append

*SA9-3.
mlogit EDR_treat age female educ nonwhite polint, baseoutcome(1)
outsum age female educ nonwhite polint if EDR_treat==1 using tables\TableSA9-3_Exp2Balance_UnMatched.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is not significant (χ2(15) = 14.30, p = .50).") title("Table SA9-3. Experiment 2 Tests of Balance for Treatment Assignment, Election Day Registration Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if EDR_treat==2 using tables\TableSA9-3_Exp2Balance_UnMatched.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if EDR_treat==3 using tables\TableSA9-3_Exp2Balance_UnMatched.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if EDR_treat==4 using tables\TableSA9-3_Exp2Balance_UnMatched.out, bracket ctitle("Dem Elderly Treatment") append


***************************

*load matched CCES data for SA9 balance tests and SA10 replicaiton of experiment 2 results.
use data\biggers_pb_study2_cces_data_matched.dta, clear


**********************************************************************
*Table SA9 - Balance Tests (Continued)
**********************************************************************

*SA9-4.
mlogit ID_treat age female educ nonwhite polint, baseoutcome(1)
outsum age female educ nonwhite polint if ID_treat==1 using tables\TableSA9-4_Exp2Balance_MatchedUW.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is significant (χ2(15) = 23.32, p = .08).") title("Table SA9-4. Experiment 2 Tests of Balance for Treatment Assignment Using Unweighted Matched Data, Voter ID Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if ID_treat==2 using tables\TableSA9-4_Exp2Balance_MatchedUW.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if ID_treat==3 using tables\TableSA9-4_Exp2Balance_MatchedUW.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if ID_treat==4 using tables\TableSA9-4_Exp2Balance_MatchedUW.out, bracket ctitle("Dem Elderly Treatment") append

*SA9-5.
mlogit EV_treat age female educ nonwhite polint, baseoutcome(1)
outsum age female educ nonwhite polint if EV_treat==1 using tables\TableSA9-5_Exp2Balance_MatchedUW.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is not significant (χ2(15) = 14.48, p = .49).") title("Table SA9-5. Experiment 2 Tests of Balance for Treatment Assignment Using Unweighted Matched Data, Early Voting Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if EV_treat==2 using tables\TableSA9-5_Exp2Balance_MatchedUW.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if EV_treat==3 using tables\TableSA9-5_Exp2Balance_MatchedUW.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if EV_treat==4 using tables\TableSA9-5_Exp2Balance_MatchedUW.out, bracket ctitle("Dem Elderly Treatment") append

*SA9-6.
mlogit EDR_treat age female educ nonwhite polint, baseoutcome(1)
outsum age female educ nonwhite polint if EDR_treat==1 using tables\TableSA9-6_Exp2Balance_MatchedUW.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is significant (χ2(15) = 23.52, p = .07).") title("Table SA9-6. Experiment 2 Tests of Balance for Treatment Assignment Using Unweighted Matched Data, Election Day Registration Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if EDR_treat==2 using tables\TableSA9-6_Exp2Balance_MatchedUW.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if EDR_treat==3 using tables\TableSA9-6_Exp2Balance_MatchedUW.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if EDR_treat==4 using tables\TableSA9-6_Exp2Balance_MatchedUW.out, bracket ctitle("Dem Elderly Treatment") append

*SA9-7.
mlogit ID_treat age female educ nonwhite polint [pweight= weight], baseoutcome(1)
outsum age female educ nonwhite polint if ID_treat==1 using tables\TableSA9-7_Exp2Balance_MatchedW.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is significant (χ2(15) = 24.39, p = .06).") title("Table SA9-7. Experiment 2 Tests of Balance for Treatment Assignment Using Weighted Matched Data, Voter ID Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if ID_treat==2 using tables\TableSA9-7_Exp2Balance_MatchedW.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if ID_treat==3 using tables\TableSA9-7_Exp2Balance_MatchedW.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if ID_treat==4 using tables\TableSA9-7_Exp2Balance_MatchedW.out, bracket ctitle("Dem Elderly Treatment") append

*SA9-8.
mlogit EV_treat age female educ nonwhite polint [pweight= weight], baseoutcome(1)
outsum age female educ nonwhite polint if EV_treat==1 using tables\TableSA9-8_Exp2Balance_MatchedW.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is not significant (χ2(15) = 12.99, p = .60).") title("Table SA9-8. Experiment 2 Tests of Balance for Treatment Assignment Using Weighted Matched Data, Early Voting Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if EV_treat==2 using tables\TableSA9-8_Exp2Balance_MatchedW.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if EV_treat==3 using tables\TableSA9-8_Exp2Balance_MatchedW.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if EV_treat==4 using tables\TableSA9-8_Exp2Balance_MatchedW.out, bracket ctitle("Dem Elderly Treatment") append

*SA9-9.
mlogit EDR_treat age female educ nonwhite polint [pweight= weight], baseoutcome(1)
outsum age female educ nonwhite polint if EDR_treat==1 using tables\TableSA9-9_Exp2Balance_MatchedW.out, bracket addnote("Note: Cell entries are means with standard deviations in brackets. Multinomial logit was used to predict treatment assignment with all variables in the table used as predictors. The chi-squared test for all covariates predicting assignment is significant (χ2(15) = 24.98, p = .05).") title("Table SA9-9. Experiment 2 Tests of Balance for Treatment Assignment Using Weighted Matched Data, Election Day Registration Question") ctitle("Control Group") replace
outsum age female educ nonwhite polint if EDR_treat==2 using tables\TableSA9-9_Exp2Balance_MatchedW.out, bracket ctitle("Minorities Treatment") append
outsum age female educ nonwhite polint if EDR_treat==3 using tables\TableSA9-9_Exp2Balance_MatchedW.out, bracket ctitle("Rep Elderly Treatment") append
outsum age female educ nonwhite polint if EDR_treat==4 using tables\TableSA9-9_Exp2Balance_MatchedW.out, bracket ctitle("Dem Elderly Treatment") append


**********************************************************************
*Table SA10 - Replicate Tables 4-5 using unweighted, matched data.
**********************************************************************

*set constant sample across DVs and covariates (no missing data).
qui reg ID_DV EV_DV EDR_DV age female educ nonwhite polint
gen useme=1 if e(sample)

reg ID_DV i.ID_treat if Dem==1 & useme==1, r
outreg2 using tables\TableSA10-1_DemCCES.out, bracket dec(3) addnote("Note: OLS regression coefficients presented with robust standard errors in brackets. Democrats identified based on a seven point party identification scale, with leaners coded as partisans. Dependent variable is extent of support for election reform (1=strongly favor, 2=somewhat favor, 3=somewhat oppose, 4=strongly oppose). *** p<0.01, ** p<0.05, * p<0.1, one-tailed for linear combination of coefficients tests") title("Table SA10-1. Democratic Support for Election Reforms by Treatment Assignment, Experiment 2 Using Matched Unweighted Data") ctitle("Voter Identification") replace
lincom 3.ID_treat-4.ID_treat

reg ID_DV i.ID_treat age female educ nonwhite polint i.ordering_ID if Dem==1 & useme==1, r
outreg2 using tables\TableSA10-1_DemCCES.out, bracket dec(3) ctitle("Voter Identification")  append
lincom 3.ID_treat-4.ID_treat

reg EV_DV i.EV_treat if Dem==1 & useme==1, r
outreg2 using tables\TableSA10-1_DemCCES.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

reg EV_DV i.EV_treat age female educ nonwhite polint i.ordering_EV if Dem==1 & useme==1, r
outreg2 using tables\TableSA10-1_DemCCES.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

reg EDR_DV i.EDR_treat if Dem==1 & useme==1, r
outreg2 using tables\TableSA10-1_DemCCES.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat

reg EDR_DV i.EDR_treat age female educ nonwhite polint i.ordering_EDR if Dem==1 & useme==1, r
outreg2 using tables\TableSA10-1_DemCCES.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat


reg ID_DV i.ID_treat if Rep==1 & useme==1, r
outreg2 using tables\TableSA10-2_RepCCES.out, bracket dec(3) addnote("Note: OLS regression coefficients presented with robust standard errors in brackets. Republicans identified based on a seven point party identification scale, with leaners coded as partisans. Dependent variable is extent of support for election reform (1=strongly favor, 2=somewhat favor, 3=somewhat oppose, 4=strongly oppose). *** p<0.01, ** p<0.05, * p<0.1, one-tailed for linear combination of coefficients tests") title("Table SA10-2. Republican Support for Election Reforms by Treatment Assignment, Experiment 2 Using Matched Unweighted Data") ctitle("Voter Identification") replace
lincom 3.ID_treat-4.ID_treat

reg ID_DV i.ID_treat age female educ nonwhite polint i.ordering_ID if Rep==1 & useme==1, r
outreg2 using tables\TableSA10-2_RepCCES.out, bracket dec(3) ctitle("Voter Identification") append
lincom 3.ID_treat-4.ID_treat

reg EV_DV i.EV_treat if Rep==1 & useme==1, r
outreg2 using tables\TableSA10-2_RepCCES.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

reg EV_DV i.EV_treat age female educ nonwhite polint i.ordering_EV if Rep==1 & useme==1, r
outreg2 using tables\TableSA10-2_RepCCES.out, bracket dec(3) ctitle("Early Voting") append
lincom 3.EV_treat-4.EV_treat

reg EDR_DV i.EDR_treat if Rep==1 & useme==1, r
outreg2 using tables\TableSA10-2_RepCCES.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat

reg EDR_DV i.EDR_treat age female educ nonwhite polint i.ordering_EDR if Rep==1 & useme==1, r
outreg2 using tables\TableSA10-2_RepCCES.out, bracket dec(3) ctitle("Election Day Registration") append
lincom 3.EDR_treat-4.EDR_treat

log close
