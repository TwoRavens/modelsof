****MATANOCK AND GARCIA-SANCHEZ****
****DOES COUNTERINSURGENT SUCCESS MATCH SOCIAL SUPPORT?...****


***DESCRIPTIVE STATS & BALANCE TABLE***

***TABLE SI.0A. SUMMARY STATISTICS. IN SUPPORTING INFORMATION***
sum S_MIL
sum listmil if treatmil == 1 
sum listmil if treatmil == 0

sum state
sum guerrilla
sum paramilitary
sum hiopsmil
sum coca

***TABLE SI.0B. BALANCE FOR THE EXPERIMENT. IN SUPPORTING INFORMATION***
**CONTROL V. TREATMENT**
**AGE**
ttest F1R, by (treatmil)
**EDUCATION**
ttest P1R, by (treatmil)
**GENDER (FEMALE)**
ttest L1R, by (treatmil)
**INCOME**
ttest P14R, by (treatmil)
**WEALTH**
ttest P15, by (treatmil)
**URBAN**
ttest urban, by (treatmil)
**RIGHT WING / URIBE**
ttest P29UP, by (treatmil)
**DISPLACED**
ttest P19R, by (treatmil)
**VICTIM OF VIOLENCE**
ttest P34R, by (treatmil)
**STATE**
ttest state, by (treatmil)
**GUERRILLA**
ttest guerrilla, by (treatmil)
**PARAMILITARY**
ttest paramilitary, by (treatmil)
**MILITARY OPS**
ttest hiopsmil, by (treatmil)
**COCA** 
ttest coca, by (treatmil)

**DIRECT V. TREATMENT**
**AGE**
ttest F1R, by(dir_v_treat)
**EDUCATION**
ttest P1R, by(dir_v_treat)
**GENDER (FEMALE)**
ttest L1R, by(dir_v_treat)
**INCOME**
ttest P14R, by(dir_v_treat)
**WEALTH**
ttest P15, by(dir_v_treat)
**URBAN**
ttest urban, by(dir_v_treat)
**RIGHT WING / URIBE**
ttest P29UP, by(dir_v_treat)
**DISPLACED**
ttest P19R, by(dir_v_treat)
**VICTIM OF VIOLENCE**
ttest P34R, by(dir_v_treat)
**STATE**
ttest state, by(dir_v_treat)
**GUERRILLA**
ttest guerrilla, by(dir_v_treat)
**PARAMILITARY**
ttest paras, by(dir_v_treat)
**MILITARY OPS**
ttest hiopsmil , by(dir_v_treat)
**COCA** 
ttest coca, by(dir_v_treat)


***WEIGHTED VARIABLES***

gen w_listmilt=listmil * ponderador
gen W_S_MIL = S_MIL * ponderador
gen w_listviol =listviol *ponderador
gen W_S_VIO = S_VIO * ponderador

gen w_F1R = F1R*ponderador
gen w_P1R = P1R*ponderador
gen w_L1R = L1R*ponderador
gen w_P15 = P15*ponderador
gen w_urban = urban*ponderador
gen w_P29UP = P29UP*ponderador
gen w_P19R = P19R*ponderador
gen w_P34R = P34R*ponderador
sum w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P19R w_P34R 
sum S_MIL F1R P1R L1R P15 urban P29UP P19R P34R

****RESULTS REPORTED IN THE MAIN TEXT****

***FIGURE 2: ESTIMATED PROPORTION OF SUPPORT FOR THE MILITARY. DIRECT VS INDIRECT***
***BASIC COMPARISON**
ttest w_listmilt, by (treatmil) 
ci  W_S_MIL

***USE OF VIOLENCE***
ttest w_listviol, by(treatviol)
ci W_S_VIO

***TABLE 1: ESTIMATED PROPORTION OF SUPPORT FOR THE MILITARY. DIRECT VS INDIRECT***
***FIGURE SI.2.***
***COMPARISON BY SCENARIOS***
**ttest N_direct mean_direct St_dev_direct N_list mean_list St_dev_list**

**BASIC COMPARISON***
sum W_S_MIL
display .0465967 *sqrt(1423)
ttesti  474 .5187178 .474569  1423 .3132709 1.757752

***CONTROL***
by control, sort: ttest w_listmilt, by (treatmil) 
by control, sort: ci W_S_MIL
by control, sort: sum W_S_MIL
*State*
display .0622048 *sqrt(813)
ttesti  266 .534212 .4775033 813 .3608568 1.7736551
*paramilitaries*
display .0805486 *sqrt(470)
ttesti 153 .4819815 .4716088 470 .2961641 1.746252
*Guerrilla*
display .1345881 *sqrt(140) 
ttesti 55 .5459761 .4711347 140 .0413751 1.5924679

***COCA***
by coca, sort: ttest w_listmilt, by (treatmil)
by coca, sort: ci W_S_MIL
by coca, sort: sum W_S_MIL
*No Coca*
display .0537055  *sqrt(1088)
ttesti 355 .5214904 .0254149 1088 .3526866 1.7714676 
*Coca*
display .0929443   *sqrt(335)
ttesti 119 .5104467 .0424836 335 .1713223  1.70116

***OPERATIONS***
by hiopsmil, sort: ttest w_listmilt, by (treatmil)
by hiopsmil, sort: ci W_S_MIL
by hiopsmil, sort: sum W_S_MIL
*No operations*
display .0542567   *sqrt(1020)
ttesti 339 .5182703 .4663734 1020 .2483771 1.73282
*Operations*
display .090287   *sqrt(403)
ttesti 135 .5198416 .4963329  403 .4819969  1.8124989


***TABLE 2. MODELS OF SUPPORT FOR THE MILITARY DEMOSTRATE DIFFERENT PREDICTORS***

***DIRECT MEASURE (DV), COLUMN 1***
regress  W_S_MIL paras guerrilla hiopsmil coca , cluster(codigo)
***TABLE SI.1. MODEL OF SUPPORT FOR THE MILITARY WITH CONTEXTUAL PREDICTORS INDIRECT MEASURE AS DV***
regress w_listmilt paras guerrilla hiopsmil coca treatmil parasi guerrillai hiopsmili cocai, cluster(codigo)

***INDIRECT MEASURE (DV) - COEFFICIENTS FROM INTERACTIONS, COLUMN 2*** 
***marginal effects. with respect to each interacted variable when treatmil = 1***
lincom paras+parasi
lincom guerrilla+guerrillai
lincom hiopsmil+hiopsmili
lincom coca+cocai


****SUPPORTING INFORMATION****

***TABLE SI.1a. REGRESSION MODELS ON SUPPORT FOR THE MILITARY WITH INDIVIDUAL LEVEL CONTROLS - DV EXPERIMENTAL MEASURE***
**MODEL 1. ALL OBSERVATIONS**
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P19R w_P34R treatmil, cluster(codigo)
**MODEL 2. TREATMENT X CONTROL**
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P19R w_P34R treatmil i.control controli, cluster(codigo)
**MODEL 3. TREATMENT X COCA**
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P19R w_P34R treatmil coca cocai, cluster(codigo)
**MODEL 4. TREATMENT X OPERATIONS**
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P19R w_P34R treatmil hiopsmil hiopsmili, cluster(codigo)

***TABLE SI.2. MODELS ON SUPPORT FOR THE MILITARY DIRECT MEASURE - WITH INDIVIDUAL LEVEL CONTROLS***
**MODEL 1. ALL OBSERVATIONS**
regress W_S_MIL w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P19R w_P34R, cluster(codigo) 
**MODEL 2. CONTROL**
regress W_S_MIL w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P19R w_P34R guerrilla paras, cluster(codigo)
**MODEL 3. COCA**
regress W_S_MIL w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P19R w_P34R coca, cluster(codigo)
**MODEL 4. OPERATIONS**
regress W_S_MIL w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P19R w_P34R hiopsmil, cluster(codigo)

***TABLE SI.3. MODELS ON SUPPORT FOR THE MILITARY - DV EXPERIMENTAL MEASURE WITH INTERACTIONS. AND***
***TABLE SI.4. INTERACTION COEFFICIENTS WHEN TREATMENT IS EQUAL TO 1 - DV EXPERIMENTAL MEASURE***
**MODEL 1. ALL OBSERVATIONS** 
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P34R w_P19R treatmil w_F1Ri w_P1Ri w_L1Ri w_P15i w_urbani w_P29UPi w_P34Ri w_P19Ri, cluster(codigo) 
***marginal effects. with respect to each interacted variable when treatmil = 1***
lincom w_F1R+w_F1Ri
lincom w_P1R+w_P1Ri
lincom w_L1R+w_L1Ri
lincom w_P15+w_P15i
lincom w_urban+w_urbani
lincom w_P29UP+w_P29UPi
lincom w_P34R+w_P34Ri
lincom w_P19R+w_P19Ri
**MODEL 2. STATE CONTROL**
preserve 
keep if control==0
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P34R w_P19R treatmil w_F1Ri w_P1Ri w_L1Ri w_P15i w_urbani w_P29UPi w_P34Ri w_P19Ri, cluster(codigo) 
restore
***marginal effects. with respect to each interacted variable when treatmil = 1***
lincom w_F1R+w_F1Ri
lincom w_P1R+w_P1Ri
lincom w_L1R+w_L1Ri
lincom w_P15+w_P15i
lincom w_urban+w_urbani
lincom w_P29UP+w_P29UPi
lincom w_P34R+w_P34Ri
lincom w_P19R+w_P19Ri
**MODEL 3. PARAMILITARY CONTROL**
preserve 
keep if control==1
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P34R w_P19R treatmil w_F1Ri w_P1Ri w_L1Ri w_P15i w_urbani w_P29UPi w_P34Ri w_P19Ri, cluster(codigo) 
restore
***marginal effects. with respect to each interacted variable when treatmil = 1***
lincom w_F1R+w_F1Ri
lincom w_P1R+w_P1Ri
lincom w_L1R+w_L1Ri
lincom w_P15+w_P15i
lincom w_urban+w_urbani
lincom w_P29UP+w_P29UPi
lincom w_P34R+w_P34Ri
lincom w_P19R+w_P19Ri
**MODEL 4. GUERRILLA CONTROL**
preserve 
keep if control==2
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P34R w_P19R treatmil w_F1Ri w_P1Ri w_L1Ri w_P15i w_urbani w_P29UPi w_P34Ri w_P19Ri, cluster(codigo) 
restore
***marginal effects. with respect to each interacted variable when treatmil = 1***
lincom w_F1R+w_F1Ri
lincom w_P1R+w_P1Ri
lincom w_L1R+w_L1Ri
lincom w_P15+w_P15i
lincom w_urban+w_urbani
lincom w_P29UP+w_P29UPi
lincom w_P34R+w_P34Ri
lincom w_P19R+w_P19Ri
**MODEL 5. NO MILITARY OPERATIONS**
preserve 
keep if hiopsmil==0
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P34R w_P19R treatmil w_F1Ri w_P1Ri w_L1Ri w_P15i w_urbani w_P29UPi w_P34Ri w_P19Ri, cluster(codigo) 
restore
***marginal effects. with respect to each interacted variable when treatmil = 1***
lincom w_F1R+w_F1Ri
lincom w_P1R+w_P1Ri
lincom w_L1R+w_L1Ri
lincom w_P15+w_P15i
lincom w_urban+w_urbani
lincom w_P29UP+w_P29UPi
lincom w_P34R+w_P34Ri
lincom w_P19R+w_P19Ri
**MODEL 6. MILITARY OPERATIONS**
preserve 
keep if hiopsmil==1
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P34R w_P19R treatmil w_F1Ri w_P1Ri w_L1Ri w_P15i w_urbani w_P29UPi w_P34Ri w_P19Ri, cluster(codigo) 
restore
***marginal effects. with respect to each interacted variable when treatmil = 1***
lincom w_F1R+w_F1Ri
lincom w_P1R+w_P1Ri
lincom w_L1R+w_L1Ri
lincom w_P15+w_P15i
lincom w_urban+w_urbani
lincom w_P29UP+w_P29UPi
lincom w_P34R+w_P34Ri
lincom w_P19R+w_P19Ri 
**MODEL 7. NO COCA**
preserve 
keep if coca==0
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P34R w_P19R treatmil w_F1Ri w_P1Ri w_L1Ri w_P15i w_urbani w_P29UPi w_P34Ri w_P19Ri, cluster(codigo) 
restore
***marginal effects. with respect to each interacted variable when treatmil = 1***
lincom w_F1R+w_F1Ri
lincom w_P1R+w_P1Ri
lincom w_L1R+w_L1Ri
lincom w_P15+w_P15i
lincom w_urban+w_urbani
lincom w_P29UP+w_P29UPi
lincom w_P34R+w_P34Ri
lincom w_P19R+w_P19Ri
**MODEL 8. COCA**
preserve 
keep if coca==1
regress w_listmilt w_F1R w_P1R w_L1R w_P15 w_urban w_P29UP w_P34R w_P19R treatmil w_F1Ri w_P1Ri w_L1Ri w_P15i w_urbani w_P29UPi w_P34Ri w_P19Ri, cluster(codigo) 
restore
***marginal effects. with respect to each interacted variable when treatmil = 1***
lincom w_F1R+w_F1Ri
lincom w_P1R+w_P1Ri
lincom w_L1R+w_L1Ri
lincom w_P15+w_P15i
lincom w_urban+w_urbani
lincom w_P29UP+w_P29UPi
lincom w_P34R+w_P34Ri
lincom w_P19R+w_P19Ri

***ROBUSTNESS CHECKS***

**FIGURE SI.4. DATA FROM 1988-2003**
**Estimated Proportion of Support for the Military across Territorial Control by Different Armed Actors Ð Direct versus Experimental Measures**
by control8802, sort: ttest w_listmilt, by (treatmil)
by control8802, sort: ci W_S_MIL

**FIGURE SI.5. SOME CHANGES IN CONTROL MEASURE**
**municipalities in which ops = 1 were coded as 3 (dispute) no matter which actor controls*** 
**Estimated Proportion of Support for the Military across Territorial Control by Different Armed Actors Ð Direct versus Experimental Measures** 
**(Includes municipalities with military operations as disputed areas, no matter which actor controls)**
by control_ops, sort: ttest w_listmilt, by (treatmil)
by control_ops, sort: ci W_S_MIL

**FIGURE SI.6**
**Largest cities included in state control, but the bottom right cell was recoded as guerrilla controlled**
**Estimated Proportion of Support for the Military across Territorial Control by Different Armed Actors Ð Direct versus Experimental Measures (Bottom right cell coded as guerrilla control)**
by control4, sort: ttest w_listmilt, by (treatmil)
by control4, sort: ci W_S_MIL

***********************************************************************
