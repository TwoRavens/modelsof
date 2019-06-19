/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/


/****************************************************************************/
/* This program converts geographic units of new (< 12 months) and small 
   (< 10 emp) estab in the first quarter of 2007 from zip-level to tract-level. 

   Zip-level datasets by size category (i.e., only 1 worker, 2 to 4 workers, 
   and 5 to 9 workers) and ownership type (i.e., all private, private female,
   and public) of new (< 12 months) and small (< 10 emp) estab in the first 
   quarter of 2007 are prepared in Program 2s.
*/ 
/****************************************************************************/

#delimit;
clear;
set mem 4000m;
set matsize 800;
set more off;
capture log close;

/****************************************************************************/
/* DEFINE THE PROJECT FOLDER                                                */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************/
/*SEND OUTPUT TO THE LOG FILE                                               */
/****************************************************************************/

log using `path'\Results\DB_Program3b.log, replace;

/****************************************************************************/
/*Loop over the establishment size data files to be read into the program   */
/****************************************************************************/

local j = 1;
  while `j' <= 9 {;

/*1-worker establishments*/
/*************************/
if `j' == 1 {;
  local name  1yearold_1EstSize_allusa_pubandpriv_07Q1;
  local data `path'\Temp\1yearold_1EstSize_allusa_pubandpriv_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
};

if `j' == 2 {;
  local name  1yearold_1EstSize_allusa_priv_women_07Q1;
  local data `path'\Temp\1yearold_1EstSize_allusa_priv_women_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
};

if `j' == 3 {;
  local name  1yearold_1EstSize_allusa_pub_07Q1;
  local data `path'\Temp\1yearold_1EstSize_allusa_pub_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales;                
};

/*2 to 4 worker establishments*/
/******************************/
if `j' == 4 {;
  local name  1yearold_2to4EstSize_allusa_pubandpriv_07Q1;
  local data `path'\Temp\1yearold_2to4EstSize_allusa_pubandpriv_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
};

if `j' == 5 {;
  local name  1yearold_2to4EstSize_allusa_priv_women_07Q1;
  local data `path'\Temp\1yearold_2to4EstSize_allusa_priv_women_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
};

if `j' == 6 {;
  local name  1yearold_2to4EstSize_allusa_pub_07Q1;
  local data `path'\Temp\1yearold_2to4EstSize_allusa_pub_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales;                 
};

/*5 to 9 worker establishments*/
/******************************/
if `j' == 7 {;
  local name  1yearold_5to9EstSize_allusa_pubandpriv_07Q1;
  local data `path'\Temp\1yearold_5to9EstSize_allusa_pubandpriv_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
};

if `j' == 8 {;
  local name  1yearold_5to9EstSize_allusa_priv_women_07Q1;
  local data `path'\Temp\1yearold_5to9EstSize_allusa_priv_women_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales; 
};

if `j' == 9 {;
  local name  1yearold_5to9EstSize_allusa_pub_07Q1;
  local data `path'\Temp\1yearold_5to9EstSize_allusa_pub_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
  local var3  ownnewsales;                 
};

/****************************************************************************/
/*Store the Industry number in a local macro -- ONE Industry AT A TIME

  NOTE: We have to do this ONE INDUSTRY AT A TIME because the zipcode/tract correspondence
  file has records in which a given zipcode contributes to multiple tracts.  The D&B file has
  zipcodes in which multiple sic codes are present.  When merging, we need to merge the two
  files by BOTH zip and sic code.  But since the correspondence program doesn't have the sic
  code variable, we have only two options.  (1) Add sic to the correspondence program and expand the
  the data file.  (2) With a loop, repeatedly merge the D&B for each individual SIC code with the
  correspondence file.*/
/****************************************************************************/

/****************************************************************************/
/* First determine the number of Industries in the INDUSTRIES List File     */
/****************************************************************************/
clear;
insheet using `path'\Data\induslist\induslist_`name'.txt;
gen  rownum  = _N;
local rownum = rownum;
display "Number of Industries" `rownum';
clear;

local i = 1;
while `i' <= `rownum' {;

insheet using `path'\Data\induslist\induslist_`name'.txt, c;

ren v1 sic2code;

sort sic2code;

/****************************************************************************/
/*Write the name of the industry currently being processed to a local macro.*/
/****************************************************************************/

local sic =sic2code[`i'];

display "`sic'";

/****************************************************************************/
/*Read in D&B DATA                                                          */
/****************************************************************************/

use `data', clear;
keep if sic2code==`sic';
sort zip;

/****************************************************************************/
/* Merge D&B DATA WITH ZIPCODE-TRACT CORRESPONDENCE                         */
/****************************************************************************/

sort zip;
merge zip using `path'\Data\correspondences\corr_zip_ctract.dta;      /*correspondence between zip and 2000 tracts*/

keep if _merge == 3;                                                  /*Retain obs only if in both files*/
drop _merge;

/****************************************************************************/
/* Convert Zipcode Level Data to Tract Level Geography Using Correspondences*/
/****************************************************************************/

gen `var1'_t  = `var1'* pctzint;    /*Multiply New Firms in Zip by Percent in Tract*/
gen `var2'_t  = `var2'* pctzint;    /*Multply New Employment in Zip by Perc in Tract*/
gen `var3'_t  = `var3'* pctzint;    /*Multply New Sales in Zip by Perc in Tract*/

drop `var1' `var2' `var3';

ren `var1'_t   `var1';
ren `var2'_t   `var2';
ren `var3'_t   `var3';

/****************************************************************************/
/*Collapse ZIP level data into Tract Level Data                             */
/****************************************************************************/

collapse (sum) `var1' `var2' `var3' (mean) sic2code, by(geo2000);     

if `i' == 1 {;
save `path'\Temp\Tract_level_`name'.dta, replace;
};

if `i' > 1 {;
append using `path'\Temp\Tract_level_`name'.dta;   
save `path'\Temp\Tract_level_`name'.dta, replace;  
};

clear;
local i = `i' + 1;
};

clear;

/****************************************************************************/
/*Fill in missing geo2000 slash sic2code pairs so that every sic2code is    */
/*present in every tract even if the count is 0                             */
/****************************************************************************/

use `path'\Temp\Tract_level_`name'.dta;
fillin geo2000 sic2code;   

recode  `var1'   .=0;
recode  `var2'   .=0;
recode  `var3'   .=0;

sort geo2000;

tab  _fillin;
drop _fillin;

/****************************************************************************/
/*Create the state and county FIPS codes from geo2000                       */
/****************************************************************************/

gen str2 sstate  = substr(geo2000,1,2);
gen str5 scounty = substr(geo2000,1,5);

gen state  = real(sstate);
gen county = real(scounty);

/****************************************************************************/
/*Sort and save the file                                                    */
/****************************************************************************/

sort geo2000 sic2code;
save `path'\Temp\Tract_level_`name'.dta, replace;

/****************************************************************************/
/*Now advance the loop for the different raw data files being processed     */
/****************************************************************************/

local j = `j' + 1;
};

log close;
