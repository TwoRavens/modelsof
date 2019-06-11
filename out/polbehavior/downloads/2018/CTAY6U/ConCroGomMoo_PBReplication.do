*******************************************************************************
* FILENAME: "ConCroGomMoo_PBReplication.do"                                   *
*                                                                             *
* DATE LAST UPDATED: August 26, 2017                                          *
* PROJECT: CONRAD, CROCO, GOMEZ, AND MOORE                                    *
*          "THREAT PERCEPTION AND AMERICAN SUPPORT FOR TORTURE"               *
*          FORTHCOMING IN POLITAL BEHAVIOR                                    *
* FILE AUTHORS: BRAD T. GOMEZ AND WILL H. MOORE                               *
*                                                                             *
* THIS FILE PRESENTS THE DATA AND ANALYSES USED IN "THREAT PERCEPTION AND     *
* AMERICAN SUPPORT FOR TORTURE" BY COURTNEY R. CONRAD, SARAH E. CROCO,        *
* BRAD T. GOMEZ, AND WILL H. MOORE.  THE PAPER IS BEING PUBLISHED IN THE      *
* JOURNAL, POLITICAL BEHAVIOR.                                                *
*                                                                             *
* THE DATA USED HERE ARE FROM A SURVEY EXPERIMENT THAT WAS INCLUDED IN THE    *
* FLORIDA STATE UNIVERSITY (FSU) MODULE OF THE 2012 COOPERATIVE CONGRESSIONAL *
* ELECTION STUDY (CCES), A COLLABORATIVE NATIONAL SURVEY CONDUCTED IN OCTOBER *
* AND NOVEMBER OF 2012 BY YouGov/POLIMETRIX OF PALO ALSO, CALIFORNIA.         *
* RESPONDENTS FOR THE 2012 CCES WERE SELECTED VIA THE INTERNET THROUGH AN     *
* OPT-IN POOL MAINTAINED BY YouGov/POLIMETRIX, WHICH THEN CONSTRUCTED A       *
* MATCHED RANDOM SAMPLE FOR THE STUDY. OUR PARTICIPATIO IN 2012 CCES WAS      *
* FUNDED BY THE CENTER FOR THE STUDY OF DEMOCRATIC PERFORMANCE (CSDP) AND THE *
* DEPARTMENT OF POLITICAL SCIENCE AT FLORIDA STAE UNIVERSITY. NEITHER THE     *
* CSDP, THE FSU DEPARTMENT OF POLITICAL SCIENCE, NOR THE ORGANIZERS OF THE    *
* CCES ARE RESPONSIBLE FOR THE ANAYLSES PRESENTED HERE.                       *
*                                                                             *
* THIS FILE INCLUDES ALL DATA DEFINITIONS, RECODE INFORMATION, AS WELL AS THE *
* PRIMARY AND SECONDARY ANALYSES REPORTED IN THE PAPER AND ITS SUPPLEMENTAL   *
* APPENDIX.                                                                   *
*                                                                             *
* PLEASE DIRECT ANY QUESTIONS TO BRAD T. GOMEZ (bgomez@fsu.edu)               *
*******************************************************************************

version 13

**************************************************************************
* DEFINE THE FILE DIRECTORY WHERE DATA ARE BEING STORED ON YOUR COMPUTER *
**************************************************************************

cd "C:\YOUR DIRECTORY\"


*******************************************************
* DATA: CCES 2012, FSU Module A, Post-Election Survey *
*******************************************************

use "ConCroGomMoo_PBReplication.dta", clear
codebook

******************************************
* EXPERIMENT: IMPACT OF RACE AND OFFENSE *
******************************************

******************************************************
* PRE-TREATMENT BALANCING IN EXPERIMENTAL CONDITIONS *
*                                                    ***************************
* SEE SUPPLEMENTAL APPENDIX, TABLE A1: MULTINOMIAL LOGIT MODEL OF EXPERIMENTAL *
* TREATMENT ASSIGNMENT (SIX CATEGORIES, ASSIGNMENT TO LATINO/NON-TERROR AS     *
* REFERENT CATEGORY)                                                           *
********************************************************************************

* REPORTED IN APPENDIX AS TABLE A1 *
mlogit random1 age female college white votereg pewreligimp

* REPORTED IN APPENDIX AS TABLE B2 *
mlogit Race age female college white votereg pewreligimp Offense, base(1)

* REPORTED IN APPENDIX AS TABLE B4 *
logit Offense age female college white votereg pewreligimp



*****************************
* DIFFERENCE-OF-MEANS TESTS *
*                           ****************************************************
* SEE TEXT AND SUPPLEMENTAL APPENDIX, TABLE B1: DIFFERENCE-OF-MEANS TESTS OF   *
* THE EFFECT OF RACE/THNICITY OF THE ACCUSED ON SUPPORT FOR TORTURE, POOLED    *
* AND STRATIFIED SAMPLES.                                                      *
********************************************************************************

* POOLED SAMPLE *
ttest AllApprov if Race==1 | Race==2, by(Race) 
ttest AllApprov if Race==1 | Race==3, by(Race) 
ttest AllApprov if Race==2 | Race==3, by(Race) 

* NON-TERROR GROUP *
ttest AllApprov if (Race==1 | Race==2) & Offense==0, by(Race) 
ttest AllApprov if (Race==1 | Race==3) & Offense==0, by(Race) 
ttest AllApprov if (Race==2 | Race==3) & Offense==0, by(Race) 

* TERROR GROUP *
ttest AllApprov if (Race==1 | Race==2) & Offense==1, by(Race) 
ttest AllApprov if (Race==1 | Race==3) & Offense==1, by(Race) 
ttest AllApprov if (Race==2 | Race==3) & Offense==1, by(Race) 

* DIFFERENCE IN SUPPORT BY RACE AND OFFENSE TYPE (SEE TEXT) *
ttest AllApprov if Race==1, by(Offense)
ttest AllApprov if Race==2, by(Offense)
ttest AllApprov if Race==3, by(Offense)


*********************************************
* 3x2 FACTORIAL DESIGN: RACE & OFFENSE TYPE *
*********************************************

* ANOVA *
anova AllApprov Race##Offense

* REGRESSION WITH INTERACTION TERMS - REPORTED IN PAPER AS TABLE 1*
gen LatinoTerror=Latino*Offense
gen ArabTerror=Arab*Offense
reg AllApprov Latino Arab Offense LatinoTerror ArabTerror

* SUPPLEMENTAL ESTIMATIONS - REPORTED IN APPENDIX AS MODELS 1-4 IN TABLE B3 *
reg AllApprov Offense Latino Arab
reg AllApprov Offense Latino Arab age female college white pewreligimp 
reg AllApprov Offense Latino Arab age female college white pewreligimp pid7 /*
*/ ideo5
gen OffenseAge=Offense*age
gen OffenseCol=Offense*college
gen OffensePID=Offense*pid7
reg AllApprov Offense Latino Arab age female college white pewreligimp pid7 /*
*/ ideo5 OffenseAge OffenseCol OffensePID


*****************************
* CODE TO CONSTRUCT FIGURES * 
*                           ***************************************************
* BELOW WE PROVIDE THE BASIC CODE NEEDED TO RECONSTRUCT THE FIGURES USED IN   *
* "THREAT PERCEPTION AND AMERICAN SUPPORT FOR TORTURE" BY COURTNEY R. CONRAD, *
* SARAH E. CROCO, BRAD T. GOMEZ, AND WILL H. MOORE.  THESE FIGURES ARE BASIC  *
* IN FORM AND WERE EDITED FOR AESTHETIC REASONS IN THE STATA GRAPHICS EDITOR. *
*                                                                             *
* WE GENERATE FIGURE 3 FIRST BECAUSE IT USES THE MAIN DATASET ALREADY IN USE. *
*******************************************************************************


************
* FIGURE 3 *
*          ********************************************************************
* NOTE: USE THE GRAPHICS EDITOR TO REMOVE THE TEXT BOX AT THE BOTTOM THAT     *
* READS "Graphs by Offense Type: 0=Unspecified; 1=Terror"                     *
*******************************************************************************

label define off 0 "Non-Terror" 1 "Terror"
label values Offense off

histogram AllApprov, discrete fraction fcolor(gs9) lcolor(white) normal /*
*/ normopts(lcolor(black)) ytitle(Proportion) ytitle(, margin(medium)) /*
*/ xtitle(Approval of Abuse by Alleged Offense) xtitle(, margin(medium)) /*
*/ xlabel(1 2 3 4 5 6 7) by(, legend(off)) by(, graphregion(fcolor(white) /*
*/ lcolor(white) ifcolor(white) ilcolor(white))) by(Offense) /*
*/ subtitle(, color(black) fcolor(white) lcolor(white))

* SAVE GRAPHIC HERE *


************
* FIGURE 1 *
*          ********************************************************************
* NOTE: USE THE GRAPHICS EDITOR TO LABEL THE PAIRINGS "CAUCASIAN," "LATINO,"  *
* AND "ARAB," RESPECTIVELY.  GENERATE HORIZONTAL LINES ABOVE PAIRING LABELS.  *
* REMOVE GRIDLINE AT MAXIMUM, AND REMOVE TICK MARKS AT 1.7 AND 4.25 ON Y-AXIS.*
*******************************************************************************

clear

set obs 3
gen CauCrime=.
lab variable CauCrime "Caucasian Crime"
replace CauCrime = 2.41593 in 1
replace CauCrime = 2.093984 in 2
replace CauCrime = 2.737476 in 3

gen CauTerror=.
lab variable CauTerror "Caucasian Terror"
replace CauTerror = 2.747126 in 1
replace CauTerror = 2.405635 in 2
replace CauTerror = 3.088617 in 3

gen LatCrime=.
lab variable LatCrime "Latino Crime"
replace LatCrime = 2.536364 in 1
replace LatCrime = 2.235396 in 2
replace LatCrime = 2.837332 in 3

gen LatTerror=.
lab variable LatTerror "Latino Terror"
replace LatTerror = 3.165049 in 1
replace LatTerror = 2.8456 in 2
replace LatTerror = 3.484498 in 3

gen ArabCrime=.
lab variable ArabCrime "Arab Crime"
replace ArabCrime = 3.028571 in 1
replace ArabCrime = 2.704843 in 2
replace ArabCrime = 3.352299 in 3

gen ArabTerror=.
lab variable ArabTerror "Arab Terror"
replace ArabTerror = 3.735294 in 1
replace ArabTerror = 3.387746 in 2
replace ArabTerror = 4.082842 in 3

graph box CauCrime CauTerror LatCrime LatTerror ArabCrime ArabTerror, /*
*/ box(1, fcolor(gs10) lcolor(black)) box(2, fcolor(gs5) lcolor(black)) /*
*/ box(3, fcolor(gs10) lcolor(black)) box(4, fcolor(gs5) lcolor(black)) /*
*/ box(5, fcolor(gs10) lcolor(black)) box(6, fcolor(gs5) lcolor(black)) /*
*/ ytitle(Average Support for Torture) ytitle(, margin(medium)) /*
*/ ylabel(1.7 " " 2 "2" 2.5 "2.5" 3 "3"  3.5 "3.5" 4 "4" 4.25 " ", grid) /*
*/ legend(order(1 "Crime Frame" 2 "Terror Frame") bmargin(medium)) /*
*/ graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

* SAVE GRAPHIC HERE *


************
* FIGURE 2 *
*          ***********************************************************
* NOTE: USE THE GRAPHICS EDITOR TO LABEL THE BOX PLOTS, "CAUCASIAN," *
* "LATINO," AND "ARAB," RESPECTIVELY                                 *
**********************************************************************

clear 

set obs 3
gen Caucasian=.
lab variable Caucasian "Caucasian"
replace Caucasian = 2.579545 in 1
replace Caucasian = 2.34486025 in 2
replace Caucasian = 2.8142297 in 3

gen Latino=.
lab variable Latino "Latino"
replace Latino = 2.840376 in 1
replace Latino = 2.61889485 in 2
replace Latino = 3.0618572 in 3

gen Arab=.
lab variable Arab "Arab"
replace Arab = 3.376812 in 1
replace Arab = 3.13668806 in 2
replace Arab = 3.6169359 in 3

graph box Caucasian Latino Arab, box(1, fcolor(gs10)  /*
*/ fintensity(inten100) lcolor(white) lwidth(medium) lpattern(solid))  /*
*/ box(2, fcolor(gs10) fintensity(inten100) lcolor(white)  /*
*/ lwidth(medium) lpattern(solid)) box(3, fcolor(gs10) /*
*/ fintensity(inten100) lcolor(white) lwidth(medium) lpattern(solid)) /*
*/ medtype(cline) medline(lcolor(black) lwidth(medium) lpattern(solid)) /*
*/ ytitle(Average Support for Torture) ytitle(, size(medium) /*
*/ margin(medium)) title(Invisible to View, color(white) position(6) /*
*/ margin(medium)) legend(off) graphregion(fcolor(white) lcolor(white))

* SAVE GRAPHIC HERE *




