/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/

/****************************************************************************/
/* This program creates LHS var (i.e., sales per worker (in log)) to be used
   in the sales regression and merges RHS var (i.e., agglomeration variables).

   It creates sales per worker (in log) by the size of establishments 
   (i.e., 1 emp, 2 to 4 emp, 5 to 9 emp, and 1 to 9 emp), which are new 
   (< 12 months) and small (< 10 emp) in the first quarter of 2007,
   merges MSA-correspondence to drop observations in small MSAs, which has
   less than 25 tracts, and New Orleans, and saves it before mergeing RHS vars.

   Then it reads in a data file, which contains economic activities of all ages
   and sizes in the fourth quarter of 2005, to catch agglomeration variables,
   merges MSA-correspondence to drop observations in the small MSA, which has
   less than 25 tracts, and New Orleans, and merges agglomeration variables 
   and sales per worker into a single data file named as Sales_Regression_r1_07Q1.
     
   Sales data for LHS var are prepared in Program 8s a. RHS var (agglomeration 
   variables) are created in Program 7.*/
/****************************************************************************/

#delimit; 
clear;
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

log using `path'\Results\DB_Program8c.log, replace; 


/****************************************************************************/
/****************************************************************************/
/* Create LHS variables                                                     */
/****************************************************************************/
/****************************************************************************/

/****************************************************************************/
/* Read in dataset created in Program 8s a                                  */
/****************************************************************************/

use `path'\Temp\Sales_new&small_07Q1.dta, clear;

/****************************************************************************/
/* Loop through groups to create log(Sales per Worker)                      */
/****************************************************************************/

local g = 1;
  while `g' <= 5 {;

if `g' == 1 {;            /*publicly- and privately-owned establishments*/
  local sub ;
};

if `g' == 2 {;            /*private female-owned establishments*/
  local sub _f;
};

if `g' == 3 {;            /*private male-owned establishments*/
  local sub _m;
};

if `g' == 4 {;            /*publicly-owned establishments*/
  local sub _b;
};

if `g' == 5 {;            /*all privately-owned establishments*/
  local sub _pv;          
};

/****************************************************************************/
/* Convert missing values to zeros                                          */
/****************************************************************************/

replace ownnewsales`sub'1 = 0  if ownnewsales`sub'1 == .;     
replace ownnewsales`sub'24 = 0 if ownnewsales`sub'24 == .;  
replace ownnewsales`sub'59 = 0 if ownnewsales`sub'59 == .;      
  
replace ownnewemp`sub'1 = 0  if ownnewemp`sub'1 == .;     
replace ownnewemp`sub'24 = 0 if ownnewemp`sub'24 == .;  
replace ownnewemp`sub'59 = 0 if ownnewemp`sub'59 == .; 

replace ownnewfirm`sub'1 = 0  if ownnewfirm`sub'1 == .;     
replace ownnewfirm`sub'24 = 0 if ownnewfirm`sub'24 == .;  
replace ownnewfirm`sub'59 = 0 if ownnewfirm`sub'59 == .; 

/****************************************************************************/
/* Create variables for establishments having 1 to 9 emp                    */
/****************************************************************************/

gen ownnewsales`sub'19 = ownnewsales`sub'1 + ownnewsales`sub'24 + ownnewsales`sub'59;
gen ownnewemp`sub'19   = ownnewemp`sub'1   + ownnewemp`sub'24   + ownnewemp`sub'59;   
gen ownnewfirm`sub'19  = ownnewfirm`sub'1  + ownnewfirm`sub'24  + ownnewfirm`sub'59;

/****************************************************************************/
/* Calculate sales per worker (in log) for different size establishments    */
/****************************************************************************/

gen lSpW`sub'1  = log(ownnewsales`sub'1  / ownnewemp`sub'1);
gen lSpW`sub'24 = log(ownnewsales`sub'24 / ownnewemp`sub'24);
gen lSpW`sub'59 = log(ownnewsales`sub'59 / ownnewemp`sub'59);
gen lSpW`sub'19 = log(ownnewsales`sub'19 / ownnewemp`sub'19);

/****************************************************************************/
/* Advance the loop to the next group                                       */
/****************************************************************************/

local g = `g' + 1;
};

/****************************************************************************/
/* Keep only related variables                                              */
/****************************************************************************/
keep geo2000 sic2code lSpW* ownnewsales* ownnewemp* ownnewfirm*;  

/****************************************************************************/
/* Merge Census Tract to MSA Correspondence from Neighborhood Data Series   */
/****************************************************************************/

sort geo2000;
merge geo2000 using `path'\Data\correspondences\MSA_Correspondence.dta;
tab _merge;
drop if _merge == 2;                  /*NOTE: We are dropping Tracts where No Businesses are Currently Found*/
drop _merge;

/****************************************************************************/
/* Drop MSA either having less than 25 tracts or whose code is missing      */
/****************************************************************************/

keep if tot_tract >= 25;              /*This variable is in the MSA-Correspondence*/
drop if msa == 9999 | msa == .; 

/****************************************************************************/
/* Drop New Orleans                                                         */
/****************************************************************************/
drop if msa == 5560;

/****************************************************************************/
/* Save dataset in the Data folder                                          */
/****************************************************************************/
sort geo2000 sic2code; 
save `path'\data\Sales_new&small_LHS_07Q1.dta, replace;   


/****************************************************************************/
/****************************************************************************/
/* Merge RHS variables: localization (urbanization) measured by own industry
   (all industries) employment in the fourth quarter of 2005 within 1-mile ring
   from the centroid of the tract and its decomposition by gender and ownership.
   
   The data file is created in Program 7*/
/****************************************************************************/
/****************************************************************************/

/****************************************************************************/
/* Loop through different size of ring                                      */
/****************************************************************************/

local r = 1;
 while `r' <= 1 {;

if `r' == 1 {;
  local size 1;
};

if `r' == 2 {;
  local size 5;
};

/****************************************************************************/
/* Read in data file, which is created in Program 7, to catch RHS vars      */
/****************************************************************************/

use `path'\Temp\Rings_allyear_allusa_05Q4_r`size'_w-Male.dta, clear;

/****************************************************************************/
/* Merge Census Tract to MSA Correspondence from Neighborhood Data Series   */
/****************************************************************************/

sort geo2000;
merge geo2000 using `path'\Data\correspondences\MSA_Correspondence.dta;
tab _merge;
drop if _merge == 2;                  /*NOTE: We are dropping Tracts where No Businesses are Currently Found*/
drop _merge;

/****************************************************************************/
/* Drop MSA either having less than 25 tracts or whose code is missing      */
/****************************************************************************/

keep if tot_tract >= 25;              /*This variable is in the MSA-Correspondence*/
drop if msa == 9999 | msa == .; 

/****************************************************************************/
/* Drop New Orleans                                                         */
/****************************************************************************/
drop if msa == 5560;

/****************************************************************************/
/* Keep only the variables of interest                                      */
/****************************************************************************/
keep geo2000 sic2code msa 
     allemp`size' allemp_f`size' allemp_m`size' allemp_b`size' allemp_pv`size' 
     ownemp`size' ownemp_f`size' ownemp_m`size' ownemp_b`size' ownemp_pv`size'; 

/****************************************************************************/
/* Merge LHS vars and RHS vars into one file                                */ 
/****************************************************************************/
sort geo2000 sic2code;   

merge geo2000 sic2code using `path'\data\Sales_new&small_LHS_07Q1.dta;
tab _merge;
*keep if _merge == 3;
drop _merge;

/****************************************************************************/
/* Save the merged data in the data folder                                  */ 
/****************************************************************************/

sort geo2000;                                                /*this sorting is required to merge SES in Sales Program 8c*/
save `path'\data\Sales_Regression_r`size'_07Q1.dta, replace;

/****************************************************************************/
/* Advance the loop to the size of ring                                     */
/****************************************************************************/

local r = `r' + 1;
};

log close;
