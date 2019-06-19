/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/

/******************************************************************************/
/* This program merges three datasets of different size categories (i.e., 1 emp,
   2 to 4 emp, and 5 to 9 emp) of new (< 12 months) and small (< 10 emp) establishments
   in the first quarter of 2007 into one single dataset named as Sales_new&small_07Q1.

   Through loop, it reads three data files created in Program 7s. 
*/
/******************************************************************************/

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

/****************************************************************************/
/*SEND OUTPUT TO THE LOG FILE                                               */
/****************************************************************************/

log using `path'\Results\DB_Program8b.log, replace; 

/****************************************************************************/
/* Loop through the establishment size data files to be read into the program.
   The macro below called "file" defines the data to be read later in 
   the program.*/
/****************************************************************************/

local j = 1;
  while `j' <= 3 {;

if `j' == 1 {;
   local file   `path'\Temp\1yearold_1EstSize_allusa_07Q1_w-Male;
   local var     ownnew;
   local size    1;                                               /*to denote establishments having only 1 emp*/  
};

if `j' == 2 {;
   local file   `path'\Temp\1yearold_2to4EstSize_allusa_07Q1_w-Male;
   local var     ownnew;
   local size    24;                                              /*to denote establishments having 2 to 4 emp*/
};

if `j' == 3 {;
   local file   `path'\Temp\1yearold_5to9EstSize_allusa_07Q1_w-Male;
   local var     ownnew;
   local size    59;                                              /*to denote establishments having 5 to 9 emp*/
};

/****************************************************************************/
/* Read in Datasets                                                         */
/****************************************************************************/

use `file'.dta, clear;

/****************************************************************************/
/* Rename variables by adding suffix indicating size of establishment       */
/****************************************************************************/
   
ren `var'firm     `var'firm`size';       
ren `var'emp      `var'emp`size';
ren `var'sales    `var'sales`size';

ren `var'firm_f   `var'firm_f`size';       
ren `var'emp_f    `var'emp_f`size';
ren `var'sales_f  `var'sales_f`size';

ren `var'firm_m   `var'firm_m`size';       
ren `var'emp_m    `var'emp_m`size';
ren `var'sales_m  `var'sales_m`size';

ren `var'firm_b   `var'firm_b`size';       
ren `var'emp_b    `var'emp_b`size';
ren `var'sales_b  `var'sales_b`size';

ren `var'firm_pv  `var'firm_pv`size';       
ren `var'emp_pv   `var'emp_pv`size';
ren `var'sales_pv `var'sales_pv`size';

/****************************************************************************/
/* Keep only a sample of 2-digit SIC industries of interest                 */
/****************************************************************************/

keep if sic2code >= 20 & sic2code <= 39        /*Manufacturing*/
     |  sic2code == 50 | sic2code == 51        /*Wholesale Trade*/
     |  sic2code >= 60 & sic2code <= 67        /*FIRE*/
     |  sic2code == 73 | sic2code == 80        /*Services*/
     |  sic2code == 81 | sic2code == 86
     |  sic2code == 87 | sic2code == 89;

/****************************************************************************/
/* Keep only related variables                                              */ 
/****************************************************************************/

keep geo2000 sic2code `var'*;

/****************************************************************************/
/* Merge three data files, each of which has different size of establishments
   into a single file.
   
   NOTE: only 1 emp establishments if j = 1
         2 to 4 emp establishments if j = 2
         5 to 9 emp establishments if j = 3
*/ 
/****************************************************************************/
sort geo2000 sic2code;   

if `j' == 1 {;
  save `path'\Temp\Sales_new&small_07Q1.dta, replace;
};

if `j' > 1 {;
  merge geo2000 sic2code using `path'\Temp\Sales_new&small_07Q1.dta;
  tab _merge;
  drop _merge;
  sort geo2000 sic2code;
  save `path'\Temp\Sales_new&small_07Q1.dta, replace;
};

/****************************************************************************/
/*Advance the loop to the next Datafile                                     */
/****************************************************************************/

local j = `j' + 1;
};

log close;

