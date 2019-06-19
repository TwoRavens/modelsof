/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/

/****************************************************************************/
/* This program calculates segregation indexes at 1-digit SIC and MSA Level       
   for establishments of all ages and sizes in the first quarter of 2007. 
   And it runs regressions of segregation indexes on MSA size.

   It reads in a dataset, which is 1-digit SIC and tract-level and created 
   in Program 8.*/
/****************************************************************************/

#delimit; 
clear;
clear matrix;
set mem 3000m;
set matsize 800;
set more off;
capture log close;

/****************************************************************************/
/* DEFINE THE PATH TO ENTREPRENEUR FOLDER                                   */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************/
/*SEND OUTPUT TO THE LOG FILE                                               */
/****************************************************************************/

log using "`path'\Results\DB_Program9a.log", replace; 

/****************************************************************************/
/* Create macro variable to be used in calculating seg. indexes             */
/****************************************************************************/

local var ownfirm;
*local var ownemp;

/****************************************************************************/
/* Select Size of Establishments to Consider                                */
/****************************************************************************/

local z = 1;
 while `z' <= 2 {;

if `z' == 1 {;                            /*all size establishments*/
  local Estsize _;
};
if `z' == 2 {;                            /*1-worker establishments*/
  local Estsize _1EstSize_;
};

/****************************************************************************/
/* Read in data at 1-digit SIC and tract-level created in Program 8         */
/****************************************************************************/

use `path'\Data\SummaryData_1digit`Estsize'r1_07Q1.dta, clear;

/****************************************************************************/
/* Calculate Indexes at 1-digit SIC and MSA level                           */
/****************************************************************************/

local sort msa sic1code;
local type _1d_MSA;

sort `sort';
by `sort': egen tot`var'    = sum(`var');                               /*Total level of activity in MSA*/
by `sort': egen tot`var'_f  = sum(`var'_f);                             /*Total level of female-owned activity in MSA*/
by `sort': egen tot`var'_m  = sum(`var'_m);                             /*Total level of non-female owned activity in MSA*/
by `sort': egen tot`var'_b  = sum(`var'_b);                             /*Total level of public owned activity in MSA*/
by `sort': egen tot`var'_pv = sum(`var'_pv);                            /*Total level of private owned activity in MSA*/
                                                                        
gen share_DSMLT = abs( (`var'_f/tot`var'_f) - (`var'_m/tot`var'_m) );   /*Disimilarity Index - component*/
gen share_ISLTN = (`var'_f/`var'_pv)*(`var'_f/tot`var'_f);              /*Isolation Index - component*/

/****************************************************************************/
/* Collapse into 1-digit SIC and MSA level                                  */
/****************************************************************************/

collapse (sum) share_DSMLT share_ISLTN 
          (mean) tot`var' tot`var'_pv tot`var'_f tot`var'_m 
                 tot_tract msa_totpop, by(`sort');

gen DIS`type' = 0.5 * share_DSMLT;                                      /*Dissimilarity Index*/
gen ISO`type' = share_ISLTN;                                            /*Isolation Index*/

drop share_DSMLT share_ISLTN tot`var'_f;

/****************************************************************************/
/* Save the file                       */
/****************************************************************************/

save `path'\Data\SummaryData_Index_1d_MSA_07Q1.dta, replace;

/*******************************************************************************************/
/* Summary stats on the segregation indexes                                                */
/*******************************************************************************************/

display "**********************************************************";
display "List Segregation Index for Establishment Size Category `z'";
display "**********************************************************";
sort sic1code;
by sic1code: sum DIS_1d_MSA;


/****************************************************************************/
/* Advance loops                                                            */
/****************************************************************************/
local z = `z' + 1;                    /*Next size category of establishments*/
};

log close;

