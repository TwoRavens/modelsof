/****************************************************************************************/
/* This program extract relevant variables from 2000 IPUMS data                         */
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

log using `path'\Results\Commute_Program1.log, replace;

/****************************************************************************************/
/*SELECT THE VARIABLES	                                                                */
/****************************************************************************************/

local variables1
year
perwt	
datanum
serial
pernum
region
gq
inctot
incwage
incss
ftotinc
incwelfr
incinvst
incretir
incsupp
incother
incearn
poverty
wkswork2
occ1950
yrsusa2
nchild
metro
age
sex
race
metaread
hispand
marst
educrec
metarea
statefip
related
ownershd
school
disabwrk
disabmob
perscare
vetstat
hhwt
puma
migpuma
migplac5
migrat5d			
movedin
classwkd
occ
uhrswork
trantime;

/****************************************************************************************/
/*This section generates data for men and women for each age                            */
/*group from the IPUMS raw data.                                                        */
/****************************************************************************************/;

/****************************************************************************************/
/*This section sets up a loop and creates dummary variables for geographic Divisions    */
/****************************************************************************************/

local y = 1;
while `y' < 10 { ;

if `y' == 1 { ;
local varregion NED;                         /*Variable for New England Division        */
local vardivision 11;   
};

if `y' == 2 { ;
local varregion MAD;                         /*Variable for Middle Atlantic Division    */
local vardivision 12;   
};

if `y' == 3 { ;
local varregion ENCD;                        /*Variable for East North Central Division */
local vardivision 21;   
};

if `y' == 4 { ;
local varregion WNCD;                        /*Variable for West North Central Division */
local vardivision 22;   
};

if `y' == 5 { ;
local varregion WSAD;                        /*Variable for West South Atlantic Division*/
local vardivision 31;   
};

if `y' == 6 { ;
local varregion ESCD;                        /*Variable for East South Central Division */
local vardivision 32;   
};

if `y' == 7 { ;
local varregion WSD;                         /*Variable for West South Central Division */
local vardivision 33;   
};

if `y' == 8 { ;
local varregion MD;                          /*Variable for Mountain Division           */
local vardivision 41;   
};

if `y' == 9 { ;
local varregion PD;                          /*Variable for Pacific Division            */
local vardivision 42;   
};

/****************************************************************************************/
/*This section reads raw IPUMS data by sex and age and saves the data by region         */
/****************************************************************************************/

/*********************************************/
/*Reads men data from IPUMS                  */
/*********************************************/

use `path'\Data\IPUMS2000_5%\men0125.dta, clear;
keep `variables1';
keep if region == `vardivision';
gen male = 1;
save "`path'\Temp\Commute_Program1_`varregion'.dta", replace;

use `path'\Data\IPUMS2000_5%\men2645.dta, clear;
keep `variables1';
keep if region == `vardivision';
gen male = 1;
append using "`path'\Temp\Commute_Program1_`varregion'.dta";
save "`path'\Temp\Commute_Program1_`varregion'.dta", replace;

use `path'\Data\IPUMS2000_5%\men46+.dta, clear;
keep `variables1';
keep if region == `vardivision';
gen male = 1;
append using "`path'\Temp\Commute_Program1_`varregion'.dta";
save "`path'\Temp\Commute_Program1_`varregion'.dta", replace;

/*********************************************/
/*Reads women data from IPUMS                */
/*********************************************/

use "`path'\Data\IPUMS2000_5%\wmn0125.dta", clear;
keep `variables1';
keep if region == `vardivision';
gen male = 0;
append using "`path'\Temp\Commute_Program1_`varregion'.dta";
save "`path'\Temp\Commute_Program1_`varregion'.dta", replace;

use "`path'\Data\IPUMS2000_5%\wmn2645.dta", clear;
keep `variables1';
keep if region == `vardivision';
gen male = 0;
append using "`path'\Temp\Commute_Program1_`varregion'.dta";
save "`path'\Temp\Commute_Program1_`varregion'.dta", replace;

use "`path'\Data\IPUMS2000_5%\wmn46+.dta", clear;
keep `variables1';
keep if region == `vardivision';
gen male = 0;
append using "`path'\Temp\Commute_Program1_`varregion'.dta";
save "`path'\Temp\Commute_Program1_`varregion'.dta", replace;

local y = `y' + 1;
};

/*********************************************/
/*Close log file                             */
/*********************************************/

log close;

