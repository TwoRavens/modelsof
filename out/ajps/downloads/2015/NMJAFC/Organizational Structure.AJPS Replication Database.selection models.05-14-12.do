* OPEN STATA OUTPUT FILE LOG

   log using "D:\Douglas\Collective Wisdom\Organizational Structure.AJPS Replication Database.selection models.05-14-12.smcl" 




 * OPEN "COLLECTIVE WISDOM" DATA SET
  
    use "D:\Douglas\Collective Wisdom\Organizational Structure.AJPS Replication Database.05-14-12.dta", clear
  



*** NOTE: BOTH GROUP SIZE AND ORGANIZATIONAL DIVERSITY MEASURES ARE STANDARDIZED SUCH THAT THERE MINIMUM VALUES CONCUR WITH THE OBSERVED MINIMUM VALUES FROM THE SAMPLE OF CONSENSUS GROUP STATES ***


 


************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

*** SET TIME SERIES - CROSS SECTION IDENTIFER ***

tsset state__code year__, yearly

*
*
*

************************************************************************************************************************************************************************************************************************************************************************************************************************************************************


******** TABLE SA-4: ESTIMATE A "SELECTION MODEL" PREDICTING WHETHER OR NOT A STATE-YEAR OBSERVATION IS A CONSENSUS GROUP (WITH TIMEWISE FIXED EFFECTS: T-1 ANNUAL DUMMIES) ********


** NOTE: AVGRLEGSALARY, LEGTERMLIMITS, GOVTERMLIMITS, GOVTERMLENGTH, & NONDELEGATE COVARIATES ONLY APPEAR IN THE "SELECTION" EQUATION ["EXCLUSIONARY RESTRICTIONS"] *** 


probit cgdum avgrlegsalary legtermlimits govtermlimits govtermlength nondelegate bindleg balgovlegnodeficit bienniel spendrevlimit pctsalestaxrev  dum88 dum89 dum90 dum91 dum92 dum93 dum94 dum95 dum96 dum97 dum98 dum99 dum00 dum01 dum02 dum03 dum04 dum05 dum06 dum07 dum08

* 

estat class

*

mfx


*** COMPUTE INVERSE MILLS RATIO FROM "SELECTION" EQUATION ABOVE *** 

predict double cgdumpred, xb
*
gen double imrcg = normalden(cgdumpred) / normal(cgdumpred)
*
xtsum imrcg if cgdum==1



*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************




********** TABLE SA-5: ROBUSTNESS CHECKS FOR AGGREGATE ORGANIZATIONAL DIVERSITY MODELS ACCOUNTING FOR POTENTIAL SAMPLE SELECTION BIAS **********






********* TABLE SA-5 [MODEL 1]: ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS (MODEL 1) **************


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) ar1


estat ic 

*
*
*
*
*




*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg1 = e(rss) / e(N)

scalar imrcg1coef = _b[imrcg]

xtfevd abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) ar1 
gen double deltahatcg1 = imrcg * (imrcg + cgdumpred)

sum deltahatcg1 if cgdum==1, meanonly

scalar deltabarcg1 = r(mean)

scalar sigmacg1 = sqrt(ebarcg1 + deltabarcg1 * imrcg1coef^2)

di "sigma1 = " sigmacg1

di "rho1 = "imrcg1coef / sigmacg1


*
*
*
*
*
*
*
*



*************  TABLE SA-5 [MODEL 2]: BOX-COX ZERO SKEWNESS TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE  **************





********* III. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]) NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS (MODEL 1) **************


*** GENERATE BOX-COX TRANSFORMED DEPENDENT VARIABLE (ABSPCTFCASTERROR) WITH ZERO SKEWNESS ALREADY COMPUTED ***



*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) ar1

estat ic 

*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg2 = e(rss) / e(N)

scalar imrcg2coef = _b[imrcg]

xtfevd bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) ar1
gen double deltahatcg2 = imrcg * (imrcg + cgdumpred)

sum deltahatcg2 if cgdum==1, meanonly

scalar deltabarcg2 = r(mean)

scalar sigmacg2 = sqrt(ebarcg2 + deltabarcg2 * imrcg2coef^2)

di "sigma2 = " sigmacg2

di "rho2 = "imrcg2coef / sigmacg2

*
*
*
*
*
*
*
*
*
*
*
*


*************  TABLE SA-5 [MODEL 3]: XTFEVD MODEL WITHOUT AR(1) CORRECTION   **************


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) 


*
*
*
*
 

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg3 = e(rss) / e(N)

scalar imrcg3coef = _b[imrcg]

xtfevd abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) 

gen double deltahatcg3 = imrcg * (imrcg + cgdumpred)

sum deltahatcg3 if cgdum==1, meanonly

scalar deltabarcg3 = r(mean)

scalar sigmacg3 = sqrt(ebarcg3 + deltabarcg3 * imrcg3coef^2)

di "sigma3 = " sigmacg3

di "rho3 = "imrcg3coef / sigmacg3

*
*
*
*
*
*
*
*
*
*

*************  TABLE SA-5 [MODEL 4]--- BOX-COX TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE: XTFEVD MODEL WITHOUT AR(1) CORRECTION  **************



 ********* V. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtfevd bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) 

*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg4 = e(rss) / e(N)

scalar imrcg4coef = _b[imrcg]

xtfevd bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) 

gen double deltahatcg4 = imrcg * (imrcg + cgdumpred)

sum deltahatcg4 if cgdum==1, meanonly

scalar deltabarcg4 = r(mean)

scalar sigmacg4 = sqrt(ebarcg4 + deltabarcg4 * imrcg4coef^2)

di "sigma4 = " sigmacg4

di "rho4 = "imrcg4coef / sigmacg4

*
*
*
*
*
*
*
*
*
*
*
*
*
*

*************  TABLE SA-5 [MODEL 5] --- CROSS-SECTIONAL RANDOM EFFECTS (CSRE)  **************

 

********* IV. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re


*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg5 = e(rss) / e(N)

scalar imrcg5coef = _b[imrcg]

xtreg abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re

gen double deltahatcg5 = imrcg * (imrcg + cgdumpred)

sum deltahatcg5 if cgdum==1, meanonly

scalar deltabarcg5 = r(mean)

scalar sigmacg5 = sqrt(ebarcg5 + deltabarcg5 * imrcg5coef^2)

di "sigma5 = " sigmacg5

di "rho5 = "imrcg5coef / sigmacg5

*
*
*
*
*
*
*
*
*
*

*************  TABLE SA-5 [MODEL 6] --- BOX-COX ZERO SKEWNESS TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE [CROSS-SECTIONAL RANDOM EFFECTS MODELS] **************



 ********* V. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re


*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg6 = e(rss) / e(N)

scalar imrcg6coef = _b[imrcg]

xtreg bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re

gen double deltahatcg6 = imrcg * (imrcg + cgdumpred)

sum deltahatcg6 if cgdum==1, meanonly

scalar deltabarcg6 = r(mean)

scalar sigmacg6 = sqrt(ebarcg6 + deltabarcg6 * imrcg6coef^2)

di "sigma6 = " sigmacg6

di "rho6 = "imrcg6coef / sigmacg6

*
*
*
*
*
*
*
*
*
*
*
*
*
*

*************  TABLE SA-5 [MODEL 7] --- CROSS-SECTIONAL RANDOM EFFECTS - AR(1) (CSRE-AR(1))  **************

 

********* VI. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtregar abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re


*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg7 = e(rss) / e(N)

scalar imrcg7coef = _b[imrcg]

xtregar abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re

gen double deltahatcg7 = imrcg * (imrcg + cgdumpred)

sum deltahatcg7 if cgdum==1, meanonly

scalar deltabarcg7 = r(mean)

scalar sigmacg7 = sqrt(ebarcg7 + deltabarcg7 * imrcg7coef^2)

di "sigma7 = " sigmacg7

di "rho7 = "imrcg7coef / sigmacg7

*
*
*
*
*
*
*
*
*
*

*************  TABLE SA-5 [MODEL 8] --- BOX-COX ZERO SKEWNESS TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE [CROSS-SECTIONAL -- AR(1) RANDOM EFFECTS MODELS] **************



 ********* VII. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtregar bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re


*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg8 = e(rss) / e(N)

scalar imrcg8coef = _b[imrcg]

xtregar bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re

gen double deltahatcg8 = imrcg * (imrcg + cgdumpred)

sum deltahatcg8 if cgdum==1, meanonly

scalar deltabarcg8 = r(mean)

scalar sigmacg8 = sqrt(ebarcg8 + deltabarcg8 * imrcg8coef^2)

di "sigma8 = " sigmacg8

di "rho8 = "imrcg8coef / sigmacg8

*
*
*
*
*
*
*
*
*
*
*
*
*


*************  TABLE SA-5 [MODEL 9] --- TIME-WISE FIXED EFFECTS (TWFE)  **************

 

********* X. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES IDENTIFER ***
 
iis year__



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, fe

estat ic 

*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg9 = e(rss) / e(N)

scalar imrcg9coef = _b[imrcg]

xtreg abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, fe

gen double deltahatcg9 = imrcg * (imrcg + cgdumpred)

sum deltahatcg9 if cgdum==1, meanonly

scalar deltabarcg9 = r(mean)

scalar sigmacg9 = sqrt(ebarcg9 + deltabarcg9 * imrcg9coef^2)

di "sigma9 = " sigmacg9

di "rho9 = "imrcg9coef / sigmacg9

*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*


*************  TABLE SA-5 [MODEL 10] --- BOX-COX ZERO SKEWNESS TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE [TIMEWISE FIXED EFFECTS MODELS] **************




********* XI. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES IDENTIFER ***
 
iis year__



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, fe

estat ic 

*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg10 = e(rss) / e(N)

scalar imrcg10coef = _b[imrcg]

xtreg bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, fe

gen double deltahatcg10 = imrcg * (imrcg + cgdumpred)

sum deltahatcg10 if cgdum==1, meanonly

scalar deltabarcg10 = r(mean)

scalar sigmacg10 = sqrt(ebarcg10 + deltabarcg10 * imrcg10coef^2)

di "sigma10 = " sigmacg10

di "rho10 = "imrcg10coef / sigmacg10

*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*


*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************


*
*
*
*

********** TABLE SA-6: ROBUSTNESS CHECKS FOR DISAGGREGATE ORGANIZATIONAL DIVERSITY MODELS ACCOUNTING FOR POTENTIAL SAMPLE SELECTION BIAS **********







********* TABLE SA-6 [MODEL 1]: ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS (MODEL 1) **************


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) ar1


estat ic 

*
*
*
*
*




*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg11 = e(rss) / e(N)

scalar imrcg11coef = _b[imrcg]

xtfevd abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) ar1

gen double deltahatcg11 = imrcg * (imrcg + cgdumpred)

sum deltahatcg11 if cgdum==1, meanonly

scalar deltabarcg11 = r(mean)

scalar sigmacg11 = sqrt(ebarcg11 + deltabarcg11 * imrcg11coef^2)

di "sigma11 = " sigmacg11

di "rho11 = "imrcg11coef / sigmacg11


*
*
*
*
*
*
*
*



*************  TABLE SA-6 [MODEL 2]: BOX-COX ZERO SKEWNESS TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE  **************





********* III. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]) NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS (MODEL 1) **************



*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) ar1


estat ic 

*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg12 = e(rss) / e(N)

scalar imrcg12coef = _b[imrcg]

xtfevd bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) ar1

gen double deltahatcg12 = imrcg * (imrcg + cgdumpred)

sum deltahatcg12 if cgdum==1, meanonly

scalar deltabarcg12 = r(mean)

scalar sigmacg12 = sqrt(ebarcg12 + deltabarcg12 * imrcg12coef^2)

di "sigma12 = " sigmacg12

di "rho12 = "imrcg12coef / sigmacg12

*
*
*
*
*
*
*
*
*
*
*
*


*************  TABLE SA-6 [MODEL 3]: XTFEVD MODEL WITHOUT AR(1) CORRECTION   **************


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) 



*
*
*
*
 

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg13 = e(rss) / e(N)

scalar imrcg13coef = _b[imrcg]

xtfevd abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) 

gen double deltahatcg13 = imrcg * (imrcg + cgdumpred)

sum deltahatcg13 if cgdum==1, meanonly

scalar deltabarcg13 = r(mean)

scalar sigmacg13 = sqrt(ebarcg13 + deltabarcg13 * imrcg13coef^2)

di "sigma13 = " sigmacg13

di "rho13 = "imrcg13coef / sigmacg13

*
*
*
*
*
*
*
*
*
*

*************  TABLE SA-6 [MODEL 4]--- BOX-COX TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE: XTFEVD MODEL WITHOUT AR(1) CORRECTION  **************



 ********* V. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtfevd bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg) 

*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg14 = e(rss) / e(N)

scalar imrcg14coef = _b[imrcg]

xtfevd bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev imrcg)

gen double deltahatcg14 = imrcg * (imrcg + cgdumpred)

sum deltahatcg14 if cgdum==1, meanonly

scalar deltabarcg14 = r(mean)

scalar sigmacg14 = sqrt(ebarcg14 + deltabarcg14 * imrcg14coef^2)

di "sigma14 = " sigmacg14

di "rho14 = "imrcg14coef / sigmacg14

*
*
*
*
*
*
*
*
*
*
*
*
*
*

*************  TABLE SA-6 [MODEL 5] --- CROSS-SECTIONAL RANDOM EFFECTS (CSRE)  **************

 

********* IV. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re


*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg15 = e(rss) / e(N)

scalar imrcg15coef = _b[imrcg]

xtreg abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re

gen double deltahatcg15 = imrcg * (imrcg + cgdumpred)

sum deltahatcg15 if cgdum==1, meanonly

scalar deltabarcg15 = r(mean)

scalar sigmacg15 = sqrt(ebarcg15 + deltabarcg15 * imrcg15coef^2)

di "sigma15 = " sigmacg15

di "rho15 = "imrcg15coef / sigmacg15

*
*
*
*
*
*
*
*
*
*

*************  TABLE SA-6 [MODEL 6] --- BOX-COX ZERO SKEWNESS TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE [CROSS-SECTIONAL RANDOM EFFECTS MODELS] **************



 ********* V. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re


*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg16 = e(rss) / e(N)

scalar imrcg16coef = _b[imrcg]

xtreg bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re

gen double deltahatcg16 = imrcg * (imrcg + cgdumpred)

sum deltahatcg16 if cgdum==1, meanonly

scalar deltabarcg16 = r(mean)

scalar sigmacg16 = sqrt(ebarcg16 + deltabarcg16 * imrcg16coef^2)

di "sigma16 = " sigmacg16

di "rho16 = "imrcg16coef / sigmacg16

*
*
*
*
*
*
*
*
*
*
*
*
*
*

*************  TABLE SA-6 [MODEL 7] --- CROSS-SECTIONAL RANDOM EFFECTS - AR(1) (CSRE-AR(1))  **************

 

********* VI. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtregar abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re


*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg17 = e(rss) / e(N)

scalar imrcg17coef = _b[imrcg]

xtregar abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re

gen double deltahatcg17 = imrcg * (imrcg + cgdumpred)

sum deltahatcg17 if cgdum==1, meanonly

scalar deltabarcg17 = r(mean)

scalar sigmacg17 = sqrt(ebarcg17 + deltabarcg17 * imrcg17coef^2)

di "sigma17 = " sigmacg17

di "rho17 = "imrcg17coef / sigmacg17

*
*
*
*
*
*
*
*
*
*

*************  TABLE SA-6 [MODEL 8] --- BOX-COX ZERO SKEWNESS TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE [CROSS-SECTIONAL -- AR(1) RANDOM EFFECTS MODELS] **************



 ********* VII. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtregar bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re


*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg18 = e(rss) / e(N)

scalar imrcg18coef = _b[imrcg]

xtregar bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, re

gen double deltahatcg18 = imrcg * (imrcg + cgdumpred)

sum deltahatcg18 if cgdum==1, meanonly

scalar deltabarcg18 = r(mean)

scalar sigmacg18 = sqrt(ebarcg18 + deltabarcg18 * imrcg18coef^2)

di "sigma18 = " sigmacg18

di "rho18 = "imrcg18coef / sigmacg18

*
*
*
*
*
*
*
*
*
*
*
*
*


*************  TABLE SA-6 [MODEL 9] --- TIME-WISE FIXED EFFECTS (TWFE)  **************

 

********* X. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES IDENTIFER ***
 
iis year__



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, fe

estat ic 

*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg19 = e(rss) / e(N)

scalar imrcg19coef = _b[imrcg]

xtreg abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, fe

gen double deltahatcg19 = imrcg * (imrcg + cgdumpred)

sum deltahatcg19 if cgdum==1, meanonly

scalar deltabarcg19 = r(mean)

scalar sigmacg19 = sqrt(ebarcg19 + deltabarcg19 * imrcg19coef^2)

di "sigma19 = " sigmacg19

di "rho19 = "imrcg19coef / sigmacg19

*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*
*


*************  TABLE SA-6 [MODEL 10] --- BOX-COX ZERO SKEWNESS TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE [TIMEWISE FIXED EFFECTS MODELS] **************




********* XI. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS **************




*** SET TIME SERIES IDENTIFER ***
 
iis year__



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, fe

estat ic 

*
*
*
*
*

*** COMPUTE SIGMA & RHO LINKING THE "SELECTION" AND "OUTCOME" EQUATIONS ***

scalar ebarcg20 = e(rss) / e(N)

scalar imrcg20coef = _b[imrcg]

xtreg bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff pctendrainyrev unifiedbranch govelyr lagpctchgrpi egvolatility applimitdum bindleg balgovlegnodeficit bienniel pctsalestaxrev spendrevlimit imrcg if cgdum==1, fe

gen double deltahatcg20 = imrcg * (imrcg + cgdumpred)

sum deltahatcg20 if cgdum==1, meanonly

scalar deltabarcg20 = r(mean)

scalar sigmacg20 = sqrt(ebarcg20 + deltabarcg20 * imrcg20coef^2)

di "sigma20 = " sigmacg20

di "rho20 = "imrcg20coef / sigmacg20

*



***** CLOSE STATA OUTPUT LOG *****

log close





  

