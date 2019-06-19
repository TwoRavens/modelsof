/****************************************************************************************/
/* This program runs regressions on the time to commute                                 */
/****************************************************************************************/

#delimit ;

clear;
set mem 3000m; 
set matsize 800;
set more off;
capture log close;
set trace off;

/****************************************************************************************/
/* Set up the path                                                                      */
/****************************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************************/
/*SEND OUTPUT TO THE LOG FILE                                                           */
/****************************************************************************************/

log using `path'\Results\Commute_Program4.log, replace;

/****************************************************************************************/
/*This section reads in the ipums data                                                  */
/****************************************************************************************/

use "`path'\Data\Commute_Program4_US.dta", clear;

/****************************************************************************************/
/*Specify local macro for the RHS variables                                             */
/****************************************************************************************/

local RHSvars ftotinc incinvst age agesq female child FChild married asian black hisp other educ3 educ4 usyrs2-usyrs3;

/****************************************************************************************/
/*Create some additional variables*/
/****************************************************************************************/
gen msaocc = metaread*100000 + occ;                         /*MSA-Occupation fixed effects*/
gen female = 1-male;                                        /*Female dummy var*/
gen single = 1-married;                                     /*Single dummy var*/
gen FChild = female*child;                                  /*Female x Child*/
gen FSChild = female*single*child;                          /*Female x Single x Child*/


/****************************************************************************************/
/*Run commute time regressions                                                          */
/****************************************************************************************/

/*Run regression with MSA-slash-occupation Fixed Effects -- Include those working at home*/
/********************************************************************************************************/
display "";
display "Commute regression for all full-time workers";
xtreg trantime `RHSvars', fe i(msaocc);

display "";
display "Commute regressions for all full-time NON SELF-EMPLOYED workers";
xtreg trantime `RHSvars' if selfemp == 0, fe i(msaocc);

display "";
display "Commute regressions for all full-time SELF-EMPLOYED workers";
xtreg trantime `RHSvars' if selfemp == 1, fe i(msaocc);


/*Run regression with MSA-slash-occupation Fixed Effects -- Restrict Sample to Those NOT Working at Home*/
/********************************************************************************************************/
display "";
display "Commute regression for all full-time workers not working at home";
xtreg trantime `RHSvars' if trantime > 0, fe i(msaocc);

display "";
display "Commute regressions for all full-time NON SELF-EMPLOYED workers not working at home";
xtreg trantime `RHSvars' if trantime > 0 & selfemp == 0, fe i(msaocc);

display "";
display "Commute regressions for all full-time SELF-EMPLOYED workers not working at home";
xtreg trantime `RHSvars' if trantime > 0 & selfemp == 1, fe i(msaocc);


/*********************************************/
/*Close log file                             */
/*********************************************/

log close;
