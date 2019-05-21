/* ************************************************************ */
/* File Name: HKS_AJPS_2013_Table1_Replication.do */
/* Date: April, 2013 */
/* Article Title: United Nations Peacekeeping and Civilian Protection in Civil War */
/* Authors: Lisa Hultman, Jacob Kathman, Megan Shannon */
/* Replication of Analyses */
/* Input File: HKS_AJPS_2013.dta */
/* *************************************************************/


use "HKS_AJPS_2013.dta"

*TABLE 1

*MODEL 1: Model for All Killings (To generate Figures 2 and 3 by generating simulated values from this model, these command lines are listed immediately after Model 5 below)
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop, cluster(conflict_id)
*MODEL 2: Model for Rebel Killings
nbreg osvreb1 troopLag policeLag militaryobserversLag brv_bLag brv_aLag osvreb1LagDum osvgovLag incomp epduration lntpop, cluster (conflict_id)
*MODEL 3: Models for Govt Killings
nbreg osvgov troopLag policeLag militaryobserversLag brv_bLag brv_aLag osvreb1Lag osvgovLagDum incomp epduration lntpop, cluster (conflict_id)
*MODEL 4: PKOs ONLY FOR ALL OSV
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop if PKOdum == 1, cluster(conflict_id)
*MODEL 5: RESOLUTION MODEL FOR ALL OSV
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop unscres_prearrivalLag , cluster(conflict_id)

*GENERATING FIGURE 1 FROM MODEL 1
estsimp nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop, cluster(conflict_id)
setx mean
setx incomp 2
setx osvAllLagDum 1
setx troopLag 0
simqi
setx troopLag 1
simqi
setx troopLag 2
simqi
setx troopLag 3
simqi
setx troopLag 4
simqi
setx troopLag 5
simqi
setx troopLag 6
simqi
setx troopLag 7
simqi
setx troopLag 8
simqi
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10

*GENERATING FIGURE 2 FROM MODEL 2
estsimp nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop, cluster(conflict_id)
setx mean
setx incomp 2
setx osvAllLagDum 1
setx policeLag 0
simqi
setx policeLag .1
simqi
setx policeLag .2
simqi
setx policeLag .3
simqi
setx policeLag .4
simqi
setx policeLag .5
simqi
setx policeLag .6
simqi
setx policeLag .7
simqi
setx policeLag .8
simqi
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10


*ROBUSTNESS CHECKS IN THE ARTICLE:
*Footnote 7:
*MODEL 2: Rebel Killings; PKOs Only
nbreg osvreb1 troopLag policeLag militaryobserversLag brv_bLag brv_aLag osvreb1LagDum osvgovLag incomp epduration lntpop if PKOdum == 1, cluster (conflict_id)
*MODEL 3: Govt Killings; PKOs Only
nbreg osvgov troopLag policeLag militaryobserversLag brv_bLag brv_aLag osvreb1Lag osvgovLagDum incomp epduration lntpop if PKOdum == 1, cluster (conflict_id)

*Footnote 9:
*Additional Resolution Passed Specification
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop unscresLag, cluster(conflict_id)




*MODELS REPORTED IN THE SUPPORTING INFORMATION (SI) DOCUMENT

*TABLE SI-1; Matching Analyses
*MODEL 1
use "PKOdumOSVAllM1.dta"
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop, cluster(conflict_id)
*MODEL 2
use "troopOSVAllM1.dta"
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop, cluster(conflict_id) difficult
*MODEL 3
use "policeOSVAllM1.dta"
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop, cluster(conflict_id)
*MODEL 4
use "milobsOSVAllM1.dta"
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop, cluster(conflict_id)


*TABLE SI-4; Conflicts that Received a PKO at Some Point
*MODEL 1
use "HKS_AJPS_2013.dta"
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop if PKOatsomept_con == 1, cluster(conflict_id)


*TABLE SI-5; Fixed Effects for Conflicts w/ a PKO
*MODEL 1
use "HKS_AJPS_2013.dta"
xtnbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop if PKOdum==1, fe i(conflict_id)


*GENERATING FIGURE SI-4
use "HKS_AJPS_2013.dta"
gen troopLagSq = troopLag^2
gen troopLagCu = troopLag^3
estsimp nbreg osvAll troopLag troopLagSq troopLagCu policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop, cluster(conflict_id)
setx mean
setx incomp 2
setx osvAllLagDum 1
setx troopLag 0
setx troopLagSq 0
setx troopLagCu 0
simqi
setx troopLag 1
setx troopLagSq 1
setx troopLagCu 1
simqi
setx troopLag 2
setx troopLagSq 4
setx troopLagCu 8
simqi
setx troopLag 3
setx troopLagSq 9
setx troopLagCu 27
simqi
setx troopLag 4
setx troopLagSq 16
setx troopLagCu 64
simqi
setx troopLag 5
setx troopLagSq 25
setx troopLagCu 125
simqi
setx troopLag 6
setx troopLagSq 36
setx troopLagCu 216
simqi
setx troopLag 7
setx troopLagSq 49
setx troopLagCu 343
simqi
setx troopLag 8
setx troopLagSq 64
setx troopLagCu 512
simqi
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12


*GENERATING FIGURE SI-5
use "HKS_AJPS_2013.dta"
gen policeLagSq = policeLag^2
gen policeLagCu = policeLag^3
estsimp nbreg osvAll troopLag policeLag policeLagSq policeLagCu militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop, cluster(conflict_id)
setx mean
setx incomp 2
setx osvAllLagDum 1
setx policeLag 0
setx policeLagSq 0
setx policeLagCu 0
simqi
setx policeLag .1
setx policeLagSq .01
setx policeLagCu .001
simqi
setx policeLag .2
setx policeLagSq .04
setx policeLagCu .008
simqi
setx policeLag .3
setx policeLagSq .09
setx policeLagCu .027
simqi
setx policeLag .4
setx policeLagSq .16
setx policeLagCu .064
simqi
setx policeLag .5
setx policeLagSq .25
setx policeLagCu .125
simqi
setx policeLag .6
setx policeLagSq .36
setx policeLagCu .216
simqi
setx policeLag .7
setx policeLagSq .49
setx policeLagCu .343
simqi
setx policeLag .8
setx policeLagSq .64
setx policeLagCu .512
simqi
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12



*RESULTS FROM THE "ADDITIONAL ROBUSTNESS TESTS" SECTION OF THE SI
use "HKS_AJPS_2013.dta"
*Including Active Years variable
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop active_year, cluster(conflict_id)

*Including Ceasefires variable
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop ceasefire, cluster(conflict_id)

*Including Robust Mandate variable
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop robustmandate, cluster(conflict_id)

*Including Protection of Civilians Mandate variable
nbreg osvAll troopLag policeLag militaryobserversLag brv_AllLag osvAllLagDum incomp epduration lntpop pocmandate, cluster(conflict_id)


