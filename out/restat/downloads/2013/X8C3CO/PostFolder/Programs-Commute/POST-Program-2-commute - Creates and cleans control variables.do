/****************************************************************************************/
/* This program runs regressions on the time to commute                                 */
/****************************************************************************************/

#delimit ;

clear;
set mem 800m; 
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

log using `path'\Results\Commute_Program2.log, replace;

/****************************************************************************************/
/*This section sets up a loop and makes parameters for divisions                        */
/****************************************************************************************/

local y = 1;
while `y' < 10 { ;

if `y' == 1 { ;
local varregion NED;                         /*Variable for New England Division        */
};

if `y' == 2 { ;
local varregion MAD;                         /*Variable for Middle Atlantic Division    */
};

if `y' == 3 { ;
local varregion ENCD;                        /*Variable for East North Central Division */
};

if `y' == 4 { ;
local varregion WNCD;                        /*Variable for West North Central Division */
};

if `y' == 5 { ;
local varregion WSAD;                        /*Variable for West South Atlantic Division*/
};

if `y' == 6 { ;
local varregion ESCD;                        /*Variable for East South Central Division */ 
};

if `y' == 7 { ;
local varregion WSD;                         /*Variable for West South Central Division */ 
};

if `y' == 8 { ;
local varregion MD;                          /*Variable for Mountain Division           */
};

if `y' == 9 { ;
local varregion PD;                          /*Variable for Pacific Division            */
};

/****************************************************************************************/
/*This section reads in appended ipums data by region                                   */
/****************************************************************************************/

use `path'\Temp\Commute_Program1_`varregion'.dta, clear;

/****************************************************************************************/
/*This section recodes wage and income variables to get rid of 999999 value.            */
/****************************************************************************************/

recode ftotinc    999999 = .;
recode inctot     999999 = .;
recode incwage    999999 = .;
recode incss      99999  = .;
recode incwelfr   99999  = .;
recode incinvst   999999 = .;
recode incretir   999999 = .;
recode incsupp    99999  = .;
recode incother   99999  = .;
recode incearn    999999 = .;
recode poverty    0      = .;

/****************************************************************************************/
/*This section creates a self employment variable                                       */
/****************************************************************************************/

gen selfemp = classwkd == 13 | classwkd == 14;

/****************************************************************************************/
/*This section generates dummy variables for different races.                           */
/****************************************************************************************/

gen white = (race == 100 & hispand == 0) | (race == 100 & hispand == 900);  /*Dummy for white not hispanic       */
gen hisp  = race == 100 & hispand > 0 & hispand < 900;                      /*Dummy for any type of hispanic     */ 
gen black = race == 200;                                                    /*Dummy for African American         */
gen other = race >= 300 & race < 400 | race > 699;                          /*Dummy for other race               */
gen asian = race >= 400 & race <= 699;                                      /*Dummy for Asian not incl. pac. isl.*/

la var asian "Dummy for being asian";
la var black "Dummy for being black";
la var white "Dummy for being white";
la var other "Dummy for being other";
la var hisp  "Dummy for being hispanic";

/****************************************************************************************/
/*This section generates dummy variables for whether owned or rented home.              */
/****************************************************************************************/

gen owned  = ownershd >= 10 & ownershd < 14;       /*Dummy for owned home               */
gen rented = ownershd > 19;                        /*Dummy for rented home              */

la var owned    "Dummy for whether own home";
la var rented   "Dummy for whether rent home";

compress;

/****************************************************************************************/
/*Creating dummies for the number of years in the us                                    */
/****************************************************************************************/

/*Years in the US 0 to 10*/
gen usyrs1 = yrsusa2 ==1 | yrsusa2 ==2;

/*Years in the US 11 to 20*/
gen usyrs2 = yrsusa2 ==3 | yrsusa2 ==4;

/*Years in the US 20+ or Not Applicable*/
gen usyrs3 = yrsusa2 ==5 | yrsusa2 ==0;

la var usyrs1 "Dummy for 0~10   years in the US";
la var usyrs2 "Dummy for 11~20  years in the US";
la var usyrs3 "Dummy for 20+ years in the US or not applicable";

/****************************************************************************************/
/*CREATE DUMMY VARIABLES FOR HAVING CHILDREN IN THE HOUSEHOLD                           */
/****************************************************************************************/

gen child = nchild > 0 & nchild ~= .;
la var child "Dummy for having child in household";

/****************************************************************************************/
/*This section generates the Age squared variable                                       */
/****************************************************************************************/

gen agesq = age*age; 

/****************************************************************************************/
/*This section creates dummy variables for education                                    */     
/****************************************************************************************/

gen educ0 = educrec ==0;                /*Dummy variable = 1 if educrec is NA*/
gen educ1 = educrec >0 & educrec <7;    /*This is a dummy for less than highschool*/
gen educ2 = educrec == 7;               /*This is a dummy for high school education */
gen educ3 = educrec == 8;               /* Some years of college but no BA */
gen educ4 = educrec == 9;               /* BA or more */

la var educ1 "Dummy for less than highschool education";
la var educ2 "Dummy for highschool graduate";
la var educ3 "Dummy for some years of college but not college graduate";
la var educ4 "Dummy for college graduate or more";

/****************************************************************************************/
/*This section creates dummy variables for whether the individual is married            */     
/****************************************************************************************/

gen married = 0;
replace married = 1 if marst >= 1 & marst <= 2;

/****************************************************************************************/
/*This section compresses, and saves the data for each Division                         */     
/****************************************************************************************/

compress;

if `y' == 1 { ;
save "`path'\Data\Commute_Program2_NED.dta", replace;        /*save New England Division Data        */
};

if `y' == 2 { ;
save "`path'\Data\Commute_Program2_MAD.dta", replace;        /*save Middle Atlantic Division Data    */ 
};

if `y' == 3 { ;
save "`path'\Data\Commute_Program2_ENCD.dta", replace;       /*save East North Central Division Data */  
};

if `y' == 4 { ;
save "`path'\Data\Commute_Program2_WNCD.dta", replace;       /*save West North Central Division Data*/  
};

if `y' == 5 { ;
save "`path'\Data\Commute_Program2_WSAD.dta", replace;       /*save West South Atlantic Division Data*/   
};

if `y' == 6 { ;
save "`path'\Data\Commute_Program2_ESCD.dta", replace;       /*save East South Central Division Data */   
};

if `y' == 7 { ;
save "`path'\Data\Commute_Program2_WSD.dta", replace;        /*save West South Central Division Data */
};

if `y' == 8 { ;
save "`path'\Data\Commute_Program2_MD.dta", replace;         /*save Mountain Division Data           */
};

if `y' == 9 { ;  
save "`path'\Data\Commute_Program2_PD.dta", replace;         /*save Pacific Division Data            */
};


/*********************************************/
/*Advances the Counter by 1 for the loop     */
/*********************************************/

local y = `y' + 1;
};

/*********************************************/
/*Close log file                             */
/*********************************************/

log close;

