/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/


/****************************************************************************/
/* This program merges ring-level data created in Program 5 with 
   tract-level data created in Program 4. 

   And it converts SIC 0 (created in Program 4) 
   to urbanization variables, allfirm and allemp. */
/****************************************************************************/

#delimit ; 
clear;
set mem 3000m;
set matsize 800;
set more off;
capture log close;
set trace off;

/****************************************************************************/
/* DEFINE THE PATH TO ENTREPRENEUR FOLDER                                   */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************/
/*SEND OUTPUT TO THE LOG FILE                                               */
/****************************************************************************/

log using `path'\Results\DB_Program6.log, replace; 

/****************************************************************************/
/*Define Data Files                                                         */
/****************************************************************************/

/*******************************************************************************/
/*  KEY of MACRO COMMANDS

  TYPE = f    -> Female Privately Owned Establishments
         b    -> Publicly Owned (Doesn't distinguish by Gender of Owner)
         Omit -> Public and-or all Privately Owned Establishments
*/

/*******************************************************************************/

local j = 1;
   while `j' <= 14 {;

/*Create macros for different RHS data files by gender and size of establishments, and also year and quarter.

  NOTE: Each data file contains a block of rows for each SIC industry, where each row of a block corresponds
        to a single census tract centroid around which the circle is drawn.
*/

/*PUBLIC AND PRIVATE-owned estab, using blank macro for type*/
if `j' == 1 {;                                        /*all ages and sizes in 05Q4*/
    local name  allyear_allusa_pubandpriv_05Q4;
    local type ;                                      /*Blank Macro means both Public and Private Estab*/
};

if `j' == 2 {;                                        /*all ages and sizes in 07Q1*/
    local name  allyear_allusa_pubandpriv_07Q1;
    local type ;
};

if `j' == 3 {;                                        /*all ages and very small (1 emp) in 07Q1*/
    local name  allyear_1EstSize_allusa_priv_07Q1;
    local type ;
};

if `j' == 4 {;                                        /*all ages and small (< 10 emp) in 05Q4*/
    local name  allyear_9lessEstSize_allusa_pubandpriv_05Q4;
    local type ;
};

if `j' == 5 {;                                        /*all ages and large (>= 10 emp) in 05Q4*/
    local name  allyear_10moreEstSize_allusa_pubandpriv_05Q4;
    local type ;
};


/*WOMEN-owned estab, using a macro (_f) for type of estab*/
if `j' == 6 {;                                        /*all ages and sizes in 05Q4*/
    local name  allyear_allusa_priv_women_05Q4;
    local type _f;
};

if `j' == 7 {;                                        /*all ages and sizes in 07Q1*/
    local name  allyear_allusa_priv_women_07Q1;
    local type _f;
};

if `j' == 8 {;                                        /*all ages and very small (1 emp) in 07Q1*/
    local name  allyear_1EstSize_allusa_priv_women_07Q1;
    local type _f;
};

if `j' == 9 {;                                        /*all ages and small (< 10 emp) in 05Q4*/
    local name  allyear_9lessEstSize_allusa_priv_women_05Q4;
    local type _f;
};

if `j' == 10 {;                                       /*all ages and large (>= 10 emp) in 05Q4*/
    local name  allyear_10moreEstSize_allusa_priv_women_05Q4;
    local type _f;
};


/*PUBLIC-owned estab, using a macro (_b) for type of estab*/
if `j' == 11 {;                                       /*all ages and sizes in 05Q4*/
    local name  allyear_allusa_pub_05Q4;
    local type _b;
};

if `j' == 12 {;                                       /*all ages and sizes in 07Q1*/
    local name  allyear_allusa_pub_07Q1;
    local type _b;
};

if `j' == 13 {;                                       /*all ages and small (< 10 emp) in 05Q4*/
    local name  allyear_9lessEstSize_allusa_pub_05Q4;
    local type _b;
};

if `j' == 14 {;                                       /*all ages and large (>= 10 emp) in 05Q4*/
    local name  allyear_10moreEstSize_allusa_pub_05Q4;
    local type _b;
};

/****************************************************************************/
/*Set Ring Radius                                                           */
/****************************************************************************/

local r = 1;
while `r' <= 1 {;

if `r' == 1 {;
  local size  1;
  local ring  r1;
};

if `r' == 2 {;
  local size  5;
  local ring  r5;
};

if `r' == 3 {;
  local size  10;
  local ring  r10;
};

/****************************************************************************/
/* Open Ring-level Data Set created in Program 5                            */
/****************************************************************************/

use `path'\Temp\Ring_level_dist_`ring'_`name'.dta, clear;

/****************************************************************************/
/* Keep Only a Sample of 2 Digit SIC Industries and Save to conserve Space. 
     NOTE: sic2code == 0 indicates total activity in the geographic unit. */
/****************************************************************************/

keep if sic2code >= 20 & sic2code <= 39 |  sic2code == 50 | sic2code == 51 |
        sic2code >= 60 & sic2code <= 67 |  sic2code == 73 | sic2code == 80 | 
        sic2code == 81 | sic2code == 86 |  sic2code == 87 | sic2code == 89 |
        sic2code == 0;

/****************************************************************************/
/*Append as a Suffix to Each Variables the
    Current Ring Radius (size)
    Type of Owners (Omit = Public and-or all Private, f = Female-Private, b= Public
    Employment Size Category of Establishment (Omit = all sizes, l9, g10)*/
/****************************************************************************/

rename ownfirm ownfirm`type'`size';
rename ownemp  ownemp`type'`size';

/****************************************************************************/
/* Save each ring dataset                                                   */
/****************************************************************************/

sort geo2000 sic2code;
save `path'\Temp\Rings_`name'_`ring'.dta, replace;

/****************************************************************************/
/* Merge the ring-level data in memory with tract-level data which include 
   SIC 0 created in Program 4.

   Note that the file names from Program 4 and the use statement above are 
   identical*/ 
/****************************************************************************/

sort geo2000 sic2code;
merge geo2000 sic2code using `path'\Temp\Tract_level_`name'_w-all.dta;   /*Tract-level data created in Program 4*/

keep if _merge == 3;               /*This retains only those industries present in both data files*/
tab _merge;
drop _merge;

if `j' >= 6 {;                     /*This step has to be skipped for PUBLIC AND PRIVATE-owned estab (i.e., j <= 5)*/
rename ownfirm ownfirm`type';      /*Since the macro for that type is blank, renaming ownfirm as ownfirm causes error*/  
rename ownemp  ownemp`type';
};

sort geo2000 sic2code;
save `path'\Temp\RingsandTract_`name'_`ring'.dta, replace;

/**********************************************************************************/
/* Remame ownemp ownfirm for SIC 0 to allemp and allfirm and store these variables
   as columns for each industry rather than as rows for SIC 0.*/
/**********************************************************************************/

/****************************************************************************/
/* Rename Allemp Variables                                                   */
/****************************************************************************/

keep if sic2code == 0;
capture drop allemp*;

/*Tract-Level Variables*/

rename ownfirm`type'  allfirm`type';
rename ownemp`type'   allemp`type';

/*Ring-Level Variables*/

rename ownfirm`type'`size'  allfirm`type'`size';
rename ownemp`type'`size'   allemp`type'`size';

/****************************************************************************/
/*Merge the allfirm and allemp vairables back into Ring data file*/
/****************************************************************************/

keep geo2000 all*;

sort geo2000;
merge geo2000 using `path'\Temp\RingsandTract_`name'_`ring'.dta;       /*merge back into ring data file*/
drop _merge;
drop if sic2code == 0;

/****************************************************************************/
/* Save a File that Includes the allfirm and allemp variables for each
   industry-tract block of rows*/
/****************************************************************************/

compress;
sort geo2000 sic2code;
save `path'\Temp\Rings_`name'_`ring'_All-Indus.dta, replace;

/****************************************************************************/
/* Advance Ring Radius Loop                                                 */
/****************************************************************************/

local r = `r' + 1;
};

/****************************************************************************/
/* Advance the loop to the next Data Series                                 */
/****************************************************************************/

local j = `j' + 1;
};

log close;
