/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/

/****************************************************************************/
/* This program creates data for male-owned establishments for LHS variables
   in the sales regressions using datasets created in Program 3s.

   There are 9 datafiles created in Program 3s by three types of ownership
   (i.e., publicly- and privately-owned, private female-owned, and publicly-owned)
   and three types of establishment size (i.e., 1 emp, 2 to 4 emp, and 5 to 9 emp).

   To create variables for male-owned establishments, three data files of 
   different type of ownership are merged into one data file according to 
   the type of establishment size. As a result, three data files by establishment
   size are saved after variables for male-owned establishments being created.
*/
/****************************************************************************/

#delimit; 
clear;
set mem 3000m;
set matsize 800;
set more off;
capture log close;
*set trace on;

/****************************************************************************/
/* DEFINE THE PATH TO ENTREPRENEUR FOLDER                                   */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;
local datapath `path'\Temp;

/****************************************************************************/
/* SEND OUTPUT TO THE LOG FILE                                              */
/****************************************************************************/

log using `path'\Results\DB_Program7b.log, replace; 


/******************************************************************************/
/* Loop through the establishment size data files to be read into the program */
/******************************************************************************/

local j = 1;
  while `j' <= 3 {;

/*1-worker establishments*/
/*************************/
if `j' == 1 {;
   local allname    `path'\Temp\Tract_level_1yearold_1EstSize_allusa_pubandpriv_07Q1;   /*All Private- and Public-Owned Enterprises*/
   local femalename `path'\Temp\Tract_level_1yearold_1EstSize_allusa_priv_women_07Q1;   /*Private Women-Owned Enterprises*/
   local Publicname `path'\Temp\Tract_level_1yearold_1EstSize_allusa_pub_07Q1;          /*Publicly-Owned Enterprises*/
   local savefile   `path'\Temp\1yearold_1EstSize_allusa_07Q1_w-Male.dta;
   local var         ownnew;
};

/*2 to 4 worker establishments*/
/******************************/
if `j' == 2 {;
   local allname    `path'\Temp\Tract_level_1yearold_2to4EstSize_allusa_pubandpriv_07Q1;   /*All Private- and Public-Owned Enterprises*/
   local femalename `path'\Temp\Tract_level_1yearold_2to4EstSize_allusa_priv_women_07Q1;   /*Private Women-Owned Enterprises*/
   local Publicname `path'\Temp\Tract_level_1yearold_2to4EstSize_allusa_pub_07Q1;          /*Publicly-Owned Enterprises*/
   local savefile   `path'\Temp\1yearold_2to4EstSize_allusa_07Q1_w-Male.dta;
   local var         ownnew;
};

/*5 to 9 worker establishments*/
/******************************/
if `j' == 3 {;
   local allname    `path'\Temp\Tract_level_1yearold_5to9EstSize_allusa_pubandpriv_07Q1;   /*All Private- and Public-Owned Enterprises*/
   local femalename `path'\Temp\Tract_level_1yearold_5to9EstSize_allusa_priv_women_07Q1;   /*Private Women-Owned Enterprises*/
   local Publicname `path'\Temp\Tract_level_1yearold_5to9EstSize_allusa_pub_07Q1;          /*Publicly-Owned Enterprises*/
   local savefile   `path'\Temp\1yearold_5to9EstSize_allusa_07Q1_w-Male.dta;
   local var         ownnew;
};

/****************************************************************************/
/* Read in Datasets                                                         */
/****************************************************************************/

use `femalename'.dta, clear;
      
ren `var'firm  `var'firm_f;       
ren `var'emp   `var'emp_f;
ren `var'sales `var'sales_f;

/****************************************************************************/
/* Merge Publicly-Owned Establishments                                      */ 
/****************************************************************************/
sort geo2000 sic2code;                    
merge  geo2000 sic2code using `Publicname'.dta;

tab _merge;
drop _merge;

ren `var'firm  `var'firm_b;
ren `var'emp   `var'emp_b;
ren `var'sales `var'sales_b;

/****************************************************************************/
/* Merge Public and Privately-Owned Establishments                          */  
/****************************************************************************/
sort geo2000 sic2code;             
merge  geo2000 sic2code using `allname'.dta; 

tab _merge;
drop _merge;

/****************************************************************************/
/* Keep Only Those selected 2-digit SIC Industries                          */
/****************************************************************************/

keep if sic2code >= 20 & sic2code <= 39        /*Manufacturing*/
     |  sic2code == 50 | sic2code == 51        /*Wholesale Trade*/
     |  sic2code >= 60 & sic2code <= 67        /*FIRE*/
     |  sic2code == 73 | sic2code == 80        /*Services*/
     |  sic2code == 81 | sic2code == 86
     |  sic2code == 87 | sic2code == 89;

/****************************************************************************/
/* Create a Balanced Panel with an obs for Every Tract and Retained Industry*/
/****************************************************************************/
capture drop _fillin;
capture drop if sic2code == 0;

fillin geo2000 sic2code;
tab _fillin;
drop _fillin;

/****************************************************************************/
/* Convert Missing Values to Zeros and Save                                 */
/****************************************************************************/

replace `var'firm  = 0 if `var'firm  == .;          /*all publicly- and privately-owned establishments*/
replace `var'emp   = 0 if `var'emp   == .;      
replace `var'sales = 0 if `var'sales == .;  

replace `var'firm_f  = 0 if `var'firm_f  == .;      /*private eemale-owned establishments*/
replace `var'emp_f   = 0 if `var'emp_f   == .;      
replace `var'sales_f = 0 if `var'sales_f == .;  

replace `var'firm_b  = 0 if `var'firm_b  == .;      /*publicly-owned establishments*/
replace `var'emp_b   = 0 if `var'emp_b   == .;  
replace `var'sales_b = 0 if `var'sales_b == .;    


/****************************************************************************/
/* Create Private Non-Female (Male) Owned Establishments.

   NOTE: It is important that if the public (b) estab counts are non-zero,
         then the counts of all establishments must include public
         (See Program 2s).  
         Otherwise, we would mistakenly subtract off the public below.*/
/****************************************************************************/

gen `var'firm_m  = `var'firm  - `var'firm_f  - `var'firm_b;    
gen `var'emp_m   = `var'emp   - `var'emp_f   - `var'emp_b;
gen `var'sales_m = `var'sales - `var'sales_f - `var'sales_b;

replace `var'firm_m  = 0 if `var'firm_m  == .;     
replace `var'emp_m   = 0 if `var'emp_m   == .;
replace `var'sales_m = 0 if `var'sales_m == .;

/****************************************************************************/
/* Create counts of Total number of Private Owned Establishments
   and related Variables.*/
/****************************************************************************/

gen `var'firm_pv  = `var'firm  - `var'firm_b;     
gen `var'emp_pv   = `var'emp   - `var'emp_b;
gen `var'sales_pv = `var'sales - `var'sales_b;

replace `var'firm_pv  = 0 if `var'firm_pv  == .;     
replace `var'emp_pv   = 0 if `var'emp_pv   == .;
replace `var'sales_pv = 0 if `var'sales_pv == .;

/****************************************************************************/
/* Save to the Temp folder                                                  */
/****************************************************************************/

save `savefile', replace;

/****************************************************************************/
/* Advance the loop to the next Datafile                                    */
/****************************************************************************/

local j = `j' + 1;
};

log close;
