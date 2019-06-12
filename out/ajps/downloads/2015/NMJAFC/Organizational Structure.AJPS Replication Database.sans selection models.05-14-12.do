* OPEN STATA OUTPUT FILE LOG

   log using "D:\Douglas\Collective Wisdom\Organizational Structure.AJPS Replication Database.sans selection models.05-14-12.smcl" 




 * OPEN "COLLECTIVE WISDOM" DATA SET
  
    use "D:\Douglas\Collective Wisdom\Organizational Structure.AJPS Replication Database.05-14-12.dta", clear
  



*** NOTE: BOTH GROUP SIZE AND ORGANIZATIONAL DIVERSITY MEASURES ARE STANDARDIZED SUCH THAT THERE MINIMUM VALUES CONCUR WITH THE OBSERVED MINIMUM VALUES FROM THE SAMPLE OF CONSENSUS GROUP STATES ***




************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

*** SET TIME SERIES - CROSS SECTION IDENTIFER ***

tsset state__code year__, yearly

*
*
*

xtsum groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balbudscale balgovlegnodeficit bienniel applimitdum pctsalestaxrev spendrevlimit pctendrainyrev lagpctchgrpi egvolatility govelyr unifiedbranch if xtfevd !=. 

*
*
*
*

summarize groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balbudscale balgovlegnodeficit bienniel applimitdum pctsalestaxrev spendrevlimit pctendrainyrev lagpctchgrpi egvolatility govelyr unifiedbranch if xtfevd !=. , detail 






*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************




********* II. TABLE 2: ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS (MODEL 1) **************


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev) ar1

vce 

estat ic 

*
*
*
*
*

***** FIGURE 1B SIMULATIONS OF DEPENDENT VARIABLE (N * T = 464) BASED ON FEVD-AR(1) MODEL SPECIFICATION *****



*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 0 (N = 3), RELATIVE ORGANIZATIONAL DIVERSITY = 0 [MINIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 0*groupsizerel + 0*groupsizerelsq + 0*orgdiversityrel + 0*0*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 1 (N = 4), RELATIVE ORGANIZATIONAL DIVERSITY = 0 [MINIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 1*groupsizerel + 1*groupsizerelsq + 0*orgdiversityrel + 1*0*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch   + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 2 (N = 5), RELATIVE ORGANIZATIONAL DIVERSITY = 0 [MINIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 2*groupsizerel + 4*groupsizerelsq + 0*orgdiversityrel + 2*0*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 3 (N = 6), RELATIVE ORGANIZATIONAL DIVERSITY = 0 [MINIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 3*groupsizerel + 9*groupsizerelsq + 0*orgdiversityrel + 3*0*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 4 (N = 7), RELATIVE ORGANIZATIONAL DIVERSITY = 0 [MINIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 4*groupsizerel + 16*groupsizerelsq + 0*orgdiversityrel + 4*0*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 5 (N = 8), RELATIVE ORGANIZATIONAL DIVERSITY = 0 [MINIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 5*groupsizerel + 25*groupsizerelsq + 0*orgdiversityrel + 5*0*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 6 (N = 9), RELATIVE ORGANIZATIONAL DIVERSITY = 0 [MINIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 6*groupsizerel + 36*groupsizerelsq + 0*orgdiversityrel + 6*0*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*
*
*

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 0 (N = 3), RELATIVE ORGANIZATIONAL DIVERSITY = 5.5 [5th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 0*groupsizerel + 0*groupsizerelsq + 5.50*orgdiversityrel + 0*5.50*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 1 (N = 4), RELATIVE ORGANIZATIONAL DIVERSITY = 5.5 [5th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 1*groupsizerel + 1*groupsizerelsq + 5.50*orgdiversityrel + 1*5.50*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 2 (N = 5), RELATIVE ORGANIZATIONAL DIVERSITY = 5.5 [5th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 2*groupsizerel + 4*groupsizerelsq + 5.50*orgdiversityrel + 2*5.50*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 3 (N = 6), RELATIVE ORGANIZATIONAL DIVERSITY = 5.5 [5th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 3*groupsizerel + 9*groupsizerelsq + 5.50*orgdiversityrel + 3*5.50*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 4 (N = 7), RELATIVE ORGANIZATIONAL DIVERSITY = 5.5 [5th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 4*groupsizerel + 16*groupsizerelsq + 5.50*orgdiversityrel + 4*5.50*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 5 (N = 8), RELATIVE ORGANIZATIONAL DIVERSITY = 5.5 [5th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 5*groupsizerel + 25*groupsizerelsq + 5.50*orgdiversityrel + 5*5.50*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 6 (N = 9), RELATIVE ORGANIZATIONAL DIVERSITY = 5.5 [5th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 6*groupsizerel + 36*groupsizerelsq + 5.50*orgdiversityrel + 6*5.50*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*
*
*

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 0 (N = 3), RELATIVE ORGANIZATIONAL DIVERSITY = 8.82 [13th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 0*groupsizerel + 0*groupsizerelsq + 8.82*orgdiversityrel + 0*8.82*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 1 (N = 4), RELATIVE ORGANIZATIONAL DIVERSITY = 8.82 [13th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 1*groupsizerel + 1*groupsizerelsq + 8.82*orgdiversityrel + 1*8.82*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 2 (N = 5), RELATIVE ORGANIZATIONAL DIVERSITY = 8.82 [13th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 2*groupsizerel + 4*groupsizerelsq + 8.82*orgdiversityrel + 2*8.82*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 3 (N = 6), RELATIVE ORGANIZATIONAL DIVERSITY = 8.82 [13th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 3*groupsizerel + 9*groupsizerelsq + 8.82*orgdiversityrel + 3*8.82*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 4 (N = 7), RELATIVE ORGANIZATIONAL DIVERSITY = 8.82 [13th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 4*groupsizerel + 16*groupsizerelsq + 8.82*orgdiversityrel + 4*8.82*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 5 (N = 8), RELATIVE ORGANIZATIONAL DIVERSITY = 8.82 [13th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 5*groupsizerel + 25*groupsizerelsq + 8.82*orgdiversityrel + 5*8.82*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 6 (N = 9), RELATIVE ORGANIZATIONAL DIVERSITY = 8.82 [13th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 6*groupsizerel + 36*groupsizerelsq + 8.82*orgdiversityrel + 6*8.82*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*
*
*

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 0 (N = 3), RELATIVE ORGANIZATIONAL DIVERSITY = 12.44 [26th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 0*groupsizerel + 0*groupsizerelsq + 12.44*orgdiversityrel + 0*12.44*gsrelorgdivrel + 0.625*unanimity +  0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 1 (N = 4), RELATIVE ORGANIZATIONAL DIVERSITY = 12.44 [26th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 1*groupsizerel + 1*groupsizerelsq + 12.44*orgdiversityrel + 1*12.44*gsrelorgdivrel + 0.625*unanimity +  0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 2 (N = 5), RELATIVE ORGANIZATIONAL DIVERSITY = 12.44 [26th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 2*groupsizerel + 4*groupsizerelsq + 12.44*orgdiversityrel + 2*12.44*gsrelorgdivrel + 0.625*unanimity +  0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 3 (N = 6), RELATIVE ORGANIZATIONAL DIVERSITY = 12.44 [26th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 3*groupsizerel + 9*groupsizerelsq + 12.44*orgdiversityrel + 3*12.44*gsrelorgdivrel + 0.625*unanimity +  0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 4 (N = 7), RELATIVE ORGANIZATIONAL DIVERSITY = 12.44 [26th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 4*groupsizerel + 16*groupsizerelsq + 12.44*orgdiversityrel + 4*12.44*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 5 (N = 8), RELATIVE ORGANIZATIONAL DIVERSITY = 12.44 [26th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 5*groupsizerel + 25*groupsizerelsq + 12.44*orgdiversityrel + 5*12.44*gsrelorgdivrel + 0.625*unanimity  + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 6 (N = 9), RELATIVE ORGANIZATIONAL DIVERSITY = 12.44 [26th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 6*groupsizerel + 36*groupsizerelsq + 12.44*orgdiversityrel + 6*12.44*gsrelorgdivrel + 0.625*unanimity  + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta


*
*
*
*


*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 0 (N = 3), RELATIVE ORGANIZATIONAL DIVERSITY = 16.98 [31st PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 0*groupsizerel + 0*groupsizerelsq + 16.98*orgdiversityrel + 0*16.98*gsrelorgdivrel + 0.625*unanimity  + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch   + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 1 (N = 4), RELATIVE ORGANIZATIONAL DIVERSITY = 16.98 [31st PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 1*groupsizerel + 1*groupsizerelsq + 16.98*orgdiversityrel + 1*16.98*gsrelorgdivrel + 0.625*unanimity  + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 2 (N = 5), RELATIVE ORGANIZATIONAL DIVERSITY = 16.98 [31st PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 2*groupsizerel + 4*groupsizerelsq + 16.98*orgdiversityrel + 2*16.98*gsrelorgdivrel + 0.625*unanimity  + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 3 (N = 6), RELATIVE ORGANIZATIONAL DIVERSITY = 16.98 [31st PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 3*groupsizerel + 9*groupsizerelsq + 16.98*orgdiversityrel + 3*16.98*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 4 (N = 7), RELATIVE ORGANIZATIONAL DIVERSITY = 16.98 [31st PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 4*groupsizerel + 16*groupsizerelsq + 16.98*orgdiversityrel + 4*16.98*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 5 (N = 8), RELATIVE ORGANIZATIONAL DIVERSITY = 16.98 [31st PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 5*groupsizerel + 25*groupsizerelsq + 16.98*orgdiversityrel + 5*16.98*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 6 (N = 9), RELATIVE ORGANIZATIONAL DIVERSITY = 16.98 [31st PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 6*groupsizerel + 36*groupsizerelsq + 16.98*orgdiversityrel + 6*16.98*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*
*
*

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 0 (N = 3), RELATIVE ORGANIZATIONAL DIVERSITY = 22 [39th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 0*groupsizerel + 0*groupsizerelsq + 22*orgdiversityrel + 0*22*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 1 (N = 4), RELATIVE ORGANIZATIONAL DIVERSITY = 22 [39th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 1*groupsizerel + 1*groupsizerelsq + 22*orgdiversityrel + 1*22*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr+  0.351*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 2 (N = 5), RELATIVE ORGANIZATIONAL DIVERSITY = 22 [39th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 2*groupsizerel + 4*groupsizerelsq + 22*orgdiversityrel + 2*22*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 3 (N = 6), RELATIVE ORGANIZATIONAL DIVERSITY = 22 [39th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 3*groupsizerel + 9*groupsizerelsq + 22*orgdiversityrel + 3*22*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 4 (N = 7), RELATIVE ORGANIZATIONAL DIVERSITY = 22 [39th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 4*groupsizerel + 16*groupsizerelsq + 22*orgdiversityrel + 4*22*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 5 (N = 8), RELATIVE ORGANIZATIONAL DIVERSITY = 22 [39th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 5*groupsizerel + 25*groupsizerelsq + 22*orgdiversityrel + 5*22*gsrelorgdivrel + 0.618*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 6 (N = 9), RELATIVE ORGANIZATIONAL DIVERSITY = 22 [39th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 6*groupsizerel + 36*groupsizerelsq + 22*orgdiversityrel + 6*22*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*
*
*



*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 0 (N = 3), RELATIVE ORGANIZATIONAL DIVERSITY = 29.11 [50th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 0*groupsizerel + 0*groupsizerelsq + 29.11*orgdiversityrel + 0*29.11*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 1 (N = 4), RELATIVE ORGANIZATIONAL DIVERSITY = 29.11 [50th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 1*groupsizerel + 1*groupsizerelsq + 29.11*orgdiversityrel + 1*29.11*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 2 (N = 5), RELATIVE ORGANIZATIONAL DIVERSITY = 29.11 [50th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 2*groupsizerel + 4*groupsizerelsq + 29.11*orgdiversityrel + 2*29.11*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 3 (N = 6), RELATIVE ORGANIZATIONAL DIVERSITY = 29.11 [50th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 3*groupsizerel + 9*groupsizerelsq + 29.11*orgdiversityrel + 3*29.11*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 4 (N = 7), RELATIVE ORGANIZATIONAL DIVERSITY = 29.11 [50th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 4*groupsizerel + 16*groupsizerelsq + 29.11*orgdiversityrel + 4*29.11*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 5 (N = 8), RELATIVE ORGANIZATIONAL DIVERSITY = 29.11 [50th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 5*groupsizerel + 25*groupsizerelsq + 29.11*orgdiversityrel + 5*29.11*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 6 (N = 9), RELATIVE ORGANIZATIONAL DIVERSITY = 29.11 [50th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 6*groupsizerel + 36*groupsizerelsq + 29.11*orgdiversityrel + 6*29.11*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*
*
*
*
*
*
*

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 0 (N = 3), RELATIVE ORGANIZATIONAL DIVERSITY = 34.67 [86th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 0*groupsizerel + 0*groupsizerelsq + 34.67*orgdiversityrel + 0*34.67*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr+ 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 1 (N = 4), RELATIVE ORGANIZATIONAL DIVERSITY = 34.67 [86th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 1*groupsizerel + 1*groupsizerelsq + 34.67*orgdiversityrel + 1*34.67*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr+ 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 2 (N = 5), RELATIVE ORGANIZATIONAL DIVERSITY = 34.67 [86th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 2*groupsizerel + 4*groupsizerelsq + 34.67*orgdiversityrel + 2*34.67*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr+ 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 3 (N = 6), RELATIVE ORGANIZATIONAL DIVERSITY = 34.67 [86th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 3*groupsizerel + 9*groupsizerelsq + 34.67*orgdiversityrel + 3*34.67*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr+ 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 4 (N = 7), RELATIVE ORGANIZATIONAL DIVERSITY = 34.67 [86th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 4*groupsizerel + 16*groupsizerelsq + 34.67*orgdiversityrel + 4*34.67*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr+ 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 5 (N = 8), RELATIVE ORGANIZATIONAL DIVERSITY = 34.67 [86th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 5*groupsizerel + 25*groupsizerelsq + 34.67*orgdiversityrel + 5*34.67*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr+ 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 6 (N = 9), RELATIVE ORGANIZATIONAL DIVERSITY = 34.67 [86th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 6*groupsizerel + 36*groupsizerelsq + 34.67*orgdiversityrel + 6*34.67*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr+ 0.356*unifiedbranch  + eta

*
*
*


*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 0 (N = 3), RELATIVE ORGANIZATIONAL DIVERSITY = 40.22 [95th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 0*groupsizerel + 0*groupsizerelsq + 40.22*orgdiversityrel + 0*40.22*gsrelorgdivrel + 0.625*unanimity +  0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 1 (N = 4), RELATIVE ORGANIZATIONAL DIVERSITY = 40.22 [95th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 1*groupsizerel + 1*groupsizerelsq + 40.22*orgdiversityrel + 1*40.22*gsrelorgdivrel + 0.625*unanimity +  0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 2 (N = 5), RELATIVE ORGANIZATIONAL DIVERSITY = 40.22 [95th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 2*groupsizerel + 4*groupsizerelsq + 40.22*orgdiversityrel + 2*40.22*gsrelorgdivrel + 0.625*unanimity +  0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 3 (N = 6), RELATIVE ORGANIZATIONAL DIVERSITY = 40.22 [95th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 3*groupsizerel + 9*groupsizerelsq + 40.22*orgdiversityrel + 3*40.22*gsrelorgdivrel + 0.625*unanimity +  0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 4 (N = 7), RELATIVE ORGANIZATIONAL DIVERSITY = 40.22 [95th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 4*groupsizerel + 16*groupsizerelsq + 40.22*orgdiversityrel + 4*40.22*gsrelorgdivrel + 0.625*unanimity +  0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 5 (N = 8), RELATIVE ORGANIZATIONAL DIVERSITY = 40.22 [95th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 5*groupsizerel + 25*groupsizerelsq + 40.22*orgdiversityrel + 5*40.22*gsrelorgdivrel + 0.625*unanimity +  0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

*** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 6 (N = 9), RELATIVE ORGANIZATIONAL DIVERSITY = 40.22 [95th PERCENTILE]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) *** 

lincom _cons + 6*groupsizerel + 36*groupsizerelsq + 40.22*orgdiversityrel + 6*40.22*gsrelorgdivrel + 0.625*unanimity +  0.276*cgmemberstaff  + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta



*
*
*
*
*
*

** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 0 (N = 3), RELATIVE ORGANIZATIONAL DIVERSITY = 45.778 [MAXIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) ***

lincom _cons + 0*groupsizerel + 0*groupsizerelsq + 45.778*orgdiversityrel + 0*45.778*gsrelorgdivrel + 0.625*unanimity  + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta


** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 1 (N = 4), RELATIVE ORGANIZATIONAL DIVERSITY = 45.778 [MAXIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) ***

lincom _cons + 1*groupsizerel + 1*groupsizerelsq + 45.778*orgdiversityrel + 1*45.778*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta


** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 2 (N = 5), RELATIVE ORGANIZATIONAL DIVERSITY = 45.778 [MAXIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) ***

lincom _cons + 2*groupsizerel + 4*groupsizerelsq + 45.778*orgdiversityrel + 2*45.778*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta


** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 3 (N = 6), RELATIVE ORGANIZATIONAL DIVERSITY = 45.778 [MAXIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) ***

lincom _cons + 3*groupsizerel + 9*groupsizerelsq + 45.778*orgdiversityrel + 3*45.778*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta


** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 4 (N = 7), RELATIVE ORGANIZATIONAL DIVERSITY = 45.778 [MAXIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) ***

lincom _cons + 4*groupsizerel + 16*groupsizerelsq + 45.778*orgdiversityrel + 4*45.778*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta


** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 5 (N = 8), RELATIVE ORGANIZATIONAL DIVERSITY = 45.778 [MAXIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) ***

lincom _cons + 5*groupsizerel + 25*groupsizerelsq + 45.778*orgdiversityrel + 5*45.778*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta


** COMPUTE SIMULATED VALUES OF THE DEPENDENT VARIABLE GIVEN RELATIVE GROUPSIZE = 6 (N = 9), RELATIVE ORGANIZATIONAL DIVERSITY = 45.778 [MAXIMUM]; ALL OTHER VARIABLES EVALUATED AT THEIR MEAN) ***

lincom _cons + 6*groupsizerel + 36*groupsizerelsq + 45.778*orgdiversityrel + 6*45.778*gsrelorgdivrel + 0.625*unanimity + 0.276*cgmemberstaff + 0.608*bindleg + 0.595*balgovlegnodeficit + 0.313*bienniel + 0.149*applimitdum + 0.257*pctsalestaxrev + 0.496*spendrevlimit + 8.648*pctendrainyrev + 3.038*lagpctchgrpi + 1.839*egvolatility + 0.254*govelyr + 0.356*unifiedbranch  + eta

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


********* III. TABLE 2: ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON DISAGGREGATED ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL SEPARATELY]): NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS (MODEL 2) **************


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev) ar1

vce 

estat ic 

*
*
*
*
*






***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************






********** TABLE SA-2: ROBUSTNESS CHECKS FOR AGGREGATE ORGANIZATIONAL DIVERSITY MODELS **********





*************  TABLE SA-2 [MODEL 2]: BOX-COX ZERO SKEWNESS TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE  **************



 

********* IV. ANALYSIS OF CONSENSUS GROUP MEMBERSHIP SIZE (CONDITIONAL ON ORGANIZATIONAL DIVERSITY [APPOINTEE-PARTISAN-INSTITUTIONAL]) NONLINEAR, QUADRATIC IMPACT ON THE COMPETENCE/ACCURACY OF CONSENSUS GROUP FORECASTS (MODEL 1) **************


*** GENERATE BOX-COX TRANSFORMED DEPENDENT VARIABLE (ABSPCTFCASTERROR) WITH ZERO SKEWNESS ***

*** ALREADY COMPUTED AND STORED IN DATABASE ***




*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev) ar1


vce


estat ic



***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************





********* SUPPLEMENTARY APPENDIX: TABLE SA-2 [MODEL 3] --- FIXED EFFECTS VARIANCE DECOMPOSITION WITHOUT AR(1) (XTFEVD)


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev) 

vce 

 



******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************


********* SUPPLEMENTARY APPENDIX: TABLE SA-2 [MODEL 4] --- FIXED EFFECTS VARIANCE DECOMPOSITION WITHOUT AR(1) (XTFEVD) WITH BOX-COX TRANSFORMED DEPENDENT VARIABLE (ABSPCTFCASTERROR) WITH ZERO SKEWNESS *********


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, invariant (groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev)

vce 







***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************




*************  SUPPLEMENTARY APPENDIX: TABLE SA-2 [MODEL 5] --- CROSS-SECTIONAL RANDOM EFFECTS (CSRE)  **************
 


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, re



*
*
*
*
*


*************  SUPPLEMENTARY APPENDIX: TABLE SA-2 [MODEL 6]--- CROSS-SECTIONAL RANDOM EFFECTS (CSRE) WITH BOX-COX TRANSFORMED DEPENDENT VARIABLE (ABSPCTFCASTERROR) WITH ZERO SKEWNESS  **************

 

*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, re




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


*************  SUPPLEMENTARY APPENDIX: TABLE SA-2 [MODEL 7] --- CROSS-SECTIONAL RANDOM EFFECTS - AR(1) (CSRE-AR(1))  **************

 

*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtregar abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, re




*
*
*
*
*
*

*************  SUPPLEMENTARY APPENDIX: TABLE SA-2 [MODEL 8] --- CROSS-SECTIONAL RANDOM EFFECTS - AR(1) (CSRE-AR(1)) WITH BOX-COX TRANSFORMED DEPENDENT VARIABLE (ABSPCTFCASTERROR) WITH ZERO SKEWNESS  **************

 

*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtregar bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, re



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

*************  SUPPLEMENTARY APPENDIX: TABLE SA-2 [MODEL 9] --- TIME-WISE FIXED EFFECTS (TWFE)  **************

 

*** SET TIME SERIES IDENTIFER ***
 
iis year__



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg abspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, fe

estat ic 


*
*
*
*
*
*
*
*
*

*************  SUPPLEMENTARY APPENDIX: TABLE SA-2 [MODEL 10] --- TIME-WISE FIXED EFFECTS (TWFE) WITH BOX-COX TRANSFORMED DEPENDENT VARIABLE (ABSPCTFCASTERROR) WITH ZERO SKEWNESS  **************

 
*** SET TIME SERIES IDENTIFER ***
 
iis year__



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg bcabspctfcasterror groupsizerel groupsizerelsq orgdiversityrel gsrelorgdivrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, fe

estat ic 


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


***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************


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


********** TABLE SA-3: ROBUSTNESS CHECKS FOR DISAGGREGATE ORGANIZATIONAL DIVERSITY MODELS **********






*************  TABLE SA-3 [MODEL 2]: BOX-COX ZERO SKEWNESS TRANSFORMATION OF FORECAST ACCURACY DEPENDENT VARIABLE  **************



*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev) ar1


vce


estat ic



***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************





********* SUPPLEMENTARY APPENDIX: TABLE SA-3 [MODEL 3] --- FIXED EFFECTS VARIANCE DECOMPOSITION WITHOUT AR(1) (XTFEVD)


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev) 

vce 

 



******************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************


********* SUPPLEMENTARY APPENDIX: TABLE SA-3 [MODEL 4] --- FIXED EFFECTS VARIANCE DECOMPOSITION WITHOUT AR(1) (XTFEVD) WITH BOX-COX TRANSFORMED DEPENDENT VARIABLE (ABSPCTFCASTERROR) WITH ZERO SKEWNESS *********


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


*** PLEASE NOTE: ONLY TREAT THOSE INDEPENDENT VARIABLES IN FEVD MODELS AS BEING "TIME-INVARIANT" WHEN VARIABLE VARIES LITTLE (OR NOT AT ALL) THROUGH TIME: REFLECTED BY THE BETWEEN TO WITHIN STANDARD DEVIATION (SIC VARIANCE) RATIO ***


xtfevd bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, invariant (groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev)

vce 







***************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************




*************  SUPPLEMENTARY APPENDIX: TABLE SA-3 [MODEL 5] --- CROSS-SECTIONAL RANDOM EFFECTS (CSRE)  **************
 


*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, re



*
*
*
*
*


*************  SUPPLEMENTARY APPENDIX: TABLE SA-3 [MODEL 6]--- CROSS-SECTIONAL RANDOM EFFECTS (CSRE) WITH BOX-COX TRANSFORMED DEPENDENT VARIABLE (ABSPCTFCASTERROR) WITH ZERO SKEWNESS  **************

 

*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, re




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


*************  SUPPLEMENTARY APPENDIX: TABLE SA-3 [MODEL 7] --- CROSS-SECTIONAL RANDOM EFFECTS - AR(1) (CSRE-AR(1))  **************

 

*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtregar abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, re




*
*
*
*
*
*

*************  SUPPLEMENTARY APPENDIX: TABLE SA-3 [MODEL 8] --- CROSS-SECTIONAL RANDOM EFFECTS - AR(1) (CSRE-AR(1)) WITH BOX-COX TRANSFORMED DEPENDENT VARIABLE (ABSPCTFCASTERROR) WITH ZERO SKEWNESS  **************

 

*** SET TIME SERIES - CROSS SECTION IDENTIFER ***
 
tsset state__code year__, yearly



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtregar bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, re



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

*************  SUPPLEMENTARY APPENDIX: TABLE SA-3 [MODEL 9] --- TIME-WISE FIXED EFFECTS (TWFE)  **************

 

*** SET TIME SERIES IDENTIFER ***
 
iis year__



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg abspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, fe

estat ic 


*
*
*
*
*
*
*
*
*

*************  SUPPLEMENTARY APPENDIX: TABLE SA-3 [MODEL 10] --- TIME-WISE FIXED EFFECTS (TWFE) WITH BOX-COX TRANSFORMED DEPENDENT VARIABLE (ABSPCTFCASTERROR) WITH ZERO SKEWNESS  **************

 
*** SET TIME SERIES IDENTIFER ***
 
iis year__



*** ESTIMATE "OUTCOME" EQUATION PREDICTING FORECAST ACCURACY FOR ONLY CONSENSUS GROUP STATE-YEAR OBSERVATIONS ***


xtreg bcabspctfcasterror groupsizerel groupsizerelsq apptdiversityrel gsrelapptdiversityrel partisandiversityrel gsrelpartisandiversityrel instdiversityrel gsrelinstdiversityrel unanimity cgmemberstaff bindleg balgovlegnodeficit bienniel applimitdum spendrevlimit pctsalestaxrev pctendrainyrev govelyr unifiedbranch lagpctchgrpi egvolatility if cgdum==1, fe

estat ic 




***** CLOSE STATA OUTPUT LOG *****

log close





  

