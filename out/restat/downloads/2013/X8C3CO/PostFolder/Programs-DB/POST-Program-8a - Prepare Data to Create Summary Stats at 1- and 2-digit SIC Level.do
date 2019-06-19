/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/

/****************************************************************************/
/* This program prepares data to create summary stats at 1- or 2-digit SIC level
   for establishments of all ages and sizes in the first quarter of 2007.

   It first reads a data file, which includes establishments of all ages and sizes 
   in the first quarter of 2007 and is created in Program 7, and keeps only  
   establishments in manufacturing, wholesale trade, FIRE, or services
   to keep the files sizes manageable.
 
   Then, it merges an MSA correspondence, drops New Orleans and tracts either 
   not in MSA or in small MSA having less than 25 tracts, and saves the datasets
   in the data folder at 2-digit SIC and at 1-digit SIC after collapse.

   Key to Where Summary Stats are Created:
      1. total employment and female share (in Program 9d) 
      2. establishments counts and female share (in Program 9d)
      3. segregation indexes (in Programs 9a, 9b and 9c)  
      4. dummy variable regressions (in Programs 10a and 10b)
*/
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

log using `path'\Results\DB_Program8a.log, replace; 

/****************************************************************************/
/* Select Size of Establishments to Consider                                */
/****************************************************************************/

local z = 1;
 while `z' <= 2 {;

if `z' == 1 {;                   /*all size establishments*/
  local size _;
};
if `z' == 2 {;                   /*1-worker establishments*/
  local size _1EstSize_;
};

/****************************************************************************/
/* Set Ring Radius                                                          */
/****************************************************************************/

local r = 1;
 while `r' <= 1 {;

if `r' == 1 {;
  local ring 1;
};
if `r' == 2 {;
  local ring 5;
};
if `r' == 3 {;
  local ring 10;
};

/****************************************************************************/
/* Read in a datafile, which includes establishments of all ages and sizes 
   in the first quarter of 2007 and is created in Program 7*/
/****************************************************************************/
    
use `path'\Temp\Rings_allyear`size'allusa_07Q1_r`ring'_w-Male.dta, clear;

/****************************************************************************/
/* Define 1-digit SIC code                                                  */
/****************************************************************************/

gen sic1code     = 1 if sic2code >= 20 & sic2code <= 39;              /*manufacturing*/            
replace sic1code = 2 if sic2code == 50 | sic2code == 51;              /*wholesale trade*/
replace sic1code = 3 if sic2code >= 60 & sic2code <= 67;              /*FIRE*/
replace sic1code = 4 if sic2code == 73 | sic2code == 80 |             
                        sic2code == 81 | sic2code == 86 | 
                        sic2code == 87 | sic2code == 89;              /*services*/
/*
replace sic1code = 5 if sic2code >= 91 & sic2code <= 97;              /*public administration*/
*/

/****************************************************************************/
/* Keep the establishments in either manufacturing, wholesale trade, FIRE, 
   or services industries.*/
/****************************************************************************/

keep if sic1code >= 1 & sic1code <= 4;

local vars1 ownfirm       ownfirm_f       ownfirm_m       ownfirm_b       ownfirm_pv
            ownfirm`ring' ownfirm_f`ring' ownfirm_m`ring' ownfirm_b`ring' ownfirm_pv`ring' 
            ownemp        ownemp_f        ownemp_m        ownemp_b        ownemp_pv
            ownemp`ring'  ownemp_f`ring'  ownemp_m`ring'  ownemp_b`ring'  ownemp_pv`ring';
local vars2 allemp`ring'  allemp_f`ring'  allemp_m`ring'  allemp_b`ring'  allemp_pv`ring';

/****************************************************************************/
/* Keep only variables of interest                                          */
/****************************************************************************/

keep geo2000 sic2code sic1code `vars1' `vars2';

/****************************************************************************/
/* Merge Census Tract to MSA Correspondence from Neighborhood Data Series   */
/****************************************************************************/

sort geo2000;
merge geo2000 using `path'\Data\correspondences\MSA_Correspondence.dta;
tab _merge;
drop if _merge == 2;                                      /*NOTE: We are dropping Tracts where No Businesses are Currently Found*/
drop _merge;

/****************************************************************************/
/* Drop New Orleans                                                         */
/****************************************************************************/

drop if msa == 5560;

/****************************************************************************/
/* Drop Tracts not in an MSA or in one with less than 25 Tracts             */
/****************************************************************************/

keep if tot_tract >= 25; 
drop if msa == 9999 | msa == .; 

/****************************************************************************/
/* Save the dataset of establishments at the 2-digit SIC Level of interest.

   NOTE: Currently the level of observation is either 2-digit SIC and tract 
         or 2-digit SIC and ring.*/
/****************************************************************************/
                                                          
save `path'\data\SummaryData_2digit`size'r`ring'_07Q1.dta, replace;

/****************************************************************************/
/* Collapse into 1-digit SIC categories for each tract or ring               */
/****************************************************************************/

sort geo2000 sic1code;
collapse (sum) `vars1' (mean) `vars2' msa tot_tract msa_totpop, by(geo2000 sic1code);

/****************************************************************************/
/* Save the dataset of establishments at the 1-digit SIC Level. 
   
   NOTE: The level of observation is either 1-digit SIC and tract 
         or 1-digit SIC and ring.*/
/****************************************************************************/
             
save `path'\data\SummaryData_1digit`size'r`ring'_07Q1.dta, replace;

/****************************************************************************/
/* Advance loops                                                            */
/****************************************************************************/
local r = `r' + 1;                    /*Next size ring*/
};

local z = `z' + 1;                    /*Nex size category of establishments*/
};

log close;
