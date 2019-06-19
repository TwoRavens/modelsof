/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/


/****************************************************************************/
/* This program convert zip-level data into tract-level data 
   by utilizing geographic unit correspondences. */
/****************************************************************************/

#delimit;
clear;
set mem 4000m;
set matsize 800;
set more off;
capture log close;

/****************************************************************************/
/* DEFINE THE PATH TO DATA                                                  */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************/
/* SEND OUTPUT TO THE LOG FILE                                              */
/****************************************************************************/

log using `path'\Results\DB_Program3a.log, replace;

/****************************************************************************/
/* Define data to be used
     - public and privately-owned (created in Program 2)
         1) 2007 Q1 new (< 12 months) & small (< 10 emp)
         2) 2007 Q1 all ages & sizes
         3) 2005 Q4 all ages & sizes 
         4) 2005 Q4 all ages & small (< 10 emp)
         5) 2005 Q4 all ages & large (>= 10 emp)

     - all private very small (cleaned in Program 1)
         6) 2007 Q1 all ages & very small (1 emp)

     - women-owned (cleaned in Program 1)
         7) 2007 Q1 new (< 12 months) & small (< 10 emp)
         8) 2007 Q1 all ages & sizes
         9) 2007 Q1 all ages & very small (1 emp)
        10) 2005 Q4 all ages & sizes 
        11) 2005 Q4 all ages & small (< 10 emp)
        12) 2005 Q4 all ages & large (>= 10 emp)

     - public-owned (cleaned in Program 1)
        13) 2007 Q1 new (< 12 months) & small (< 10 emp)
        14) 2007 Q1 all ages & sizes
        15) 2005 Q4 all ages & sizes 
        16) 2005 Q4 all ages & small (< 10 emp)
        17) 2005 Q4 all ages & large (>= 10 emp)                            */
/****************************************************************************/

local j = 1;
  while `j' <= 17 {;

display "";
display "************************ Group `j' *********************";
display "";

/*All Public and Private-Owned Enterprises created in Program 2*/
if `j' == 1 {;                                                       /*2007 Q1 new (< 12 months) & small (< 10 emp), both pub and priv*/
  local name  1yearold_9lessEstSize_allusa_pubandpriv_07Q1;
  local data `path'\Temp\1yearold_9lessEstSize_allusa_pubandpriv_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
};

if `j' == 2 {;                                                       /*2007 Q1 all ages & sizes, both pub and priv*/
  local name  allyear_allusa_pubandpriv_07Q1;
  local data `path'\Temp\allyear_allusa_pubandpriv_07Q1.dta;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 3 {;                                                       /*2005 Q4 all ages & sizes, both pub and priv*/
  local name  allyear_allusa_pubandpriv_05Q4;
  local data `path'\Temp\allyear_allusa_pubandpriv_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 4 {;                                                       /*2005 Q4 all ages & small (< 10 emp), both pub and priv*/
  local name  allyear_9lessEstSize_allusa_pubandpriv_05Q4;
  local data `path'\Temp\allyear_9lessEstSize_allusa_pubandpriv_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 5 {;                                                       /*2005 Q4 all ages & large (>= 10 emp), both pub and priv*/
  local name  allyear_10moreEstSize_allusa_pubandpriv_05Q4;
  local data `path'\Temp\allyear_10moreEstSize_allusa_pubandpriv_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
};


/*All Private-Owned Enterprises created in Program 1 and Not in Other Categories*/
if `j' == 6 {;                                                       /*2007 Q1 all ages & very small (1 emp), ONLY priv*/
  local name  allyear_1EstSize_allusa_priv_07Q1;
  local data `path'\Temp\allyear_1EstSize_allusa_priv_07Q1.dta;
  local var1  ownfirm;
  local var2  ownemp;
};


/*Women-Owned Enterprises cleaned in Program 1*/
if `j' == 7 {;                                                       /*2007 Q1 new (< 12 months) & small (< 10 emp), women*/
  local name  1yearold_9lessEstSize_allusa_priv_women_07Q1;
  local data `path'\Temp\1yearold_9lessEstSize_allusa_priv_women_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
};

if `j' == 8 {;                                                       /*2007 Q1 all ages & sizes, women*/
  local name  allyear_allusa_priv_women_07Q1;
  local data `path'\Temp\allyear_allusa_priv_women_07Q1.dta;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 9 {;                                                       /*2007 Q1 all ages & very small (1 emp), women*/
  local name  allyear_1EstSize_allusa_priv_women_07Q1;
  local data `path'\Temp\allyear_1EstSize_allusa_priv_women_07Q1.dta;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 10 {;                                                      /*2005 Q4 all ages & sizes, women*/
  local name  allyear_allusa_priv_women_05Q4;
  local data `path'\Temp\allyear_allusa_priv_women_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 11 {;                                                      /*2005 Q4 all ages & small (< 10 emp), women*/
  local name  allyear_9lessEstSize_allusa_priv_women_05Q4;
  local data `path'\Temp\allyear_9lessEstSize_allusa_priv_women_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 12 {;                                                      /*2005 Q4 all ages & large (>= 10 emp), women*/
  local name  allyear_10moreEstSize_allusa_priv_women_05Q4;
  local data `path'\Temp\allyear_10moreEstSize_allusa_priv_women_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
};


/*Public-Owned Enterprises cleaned in Program 1*/
if `j' == 13 {;                                                      /*2007 Q1 new (< 12 months) & small (< 10 emp), public*/
  local name  1yearold_9lessEstSize_allusa_pub_07Q1;
  local data `path'\Temp\1yearold_9lessEstSize_allusa_pub_07Q1.dta;
  local var1  ownnewfirm;
  local var2  ownnewemp;
};

if `j' == 14 {;                                                      /*2007 Q1 all ages & sizes, public*/
  local name  allyear_allusa_pub_07Q1;
  local data `path'\Temp\allyear_allusa_pub_07Q1.dta;
  local var1  ownfirm;
  local var2  ownemp;
};
   
if `j' == 15 {;                                                      /*2005 Q4 all ages & sizes, public*/
  local name  allyear_allusa_pub_05Q4;
  local data `path'\Temp\allyear_allusa_pub_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 16 {;                                                      /*2005 Q4 all ages & small (< 10 emp), public*/
  local name  allyear_9lessEstSize_allusa_pub_05Q4;
  local data `path'\Temp\allyear_9lessEstSize_allusa_pub_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 17 {;                                                      /*2005 Q4 all ages & large (>= 10 emp), public*/
  local name  allyear_10moreEstSize_allusa_pub_05Q4;
  local data `path'\Temp\allyear_10moreEstSize_allusa_pub_05Q4.dta;
  local var1  ownfirm;
  local var2  ownemp;
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

display "";
display "************ Number of Industries Equals `rownum' ************";
display "";
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

display "";
display "************** Industry `sic' *****************";
display "";

/****************************************************************************/
/*Read in D&B DATA                                                          */
/****************************************************************************/

display "";
display "************ Read in `data' *************";
display "";
use `data', clear;
keep if sic2code==`sic';
sort zip;

/****************************************************************************/
/* Merge D&B DATA WITH ZIPCODE-TRACT CORRESPONDENCE                         */
/****************************************************************************/

sort zip;
merge zip using `path'\Data\correspondences\corr_zip_ctract.dta;             /*Correspondence between 2000 census tracts and 2000 zipcodes*/

keep if _merge == 3;                                                         /*Retain obs only if in both files*/
drop _merge;

/****************************************************************************/
/* Convert Zipcode Level Data to Tract Level Geography Using Correspondences*/
/****************************************************************************/

gen `var1'_t  = `var1'* pctzint;                                             /*Multiply New Firms in Zip by Percent in Tract*/;
gen `var2'_t  = `var2'* pctzint;                                             /*Multply New Employment in Zip by Perc in Tract*/;

drop `var1' `var2';

ren `var1'_t   `var1';
ren `var2'_t   `var2';

/****************************************************************************/
/*Collapse ZIP level data into Tract Level Data                             */
/****************************************************************************/;

collapse (sum) `var1' `var2' (mean) sic2code, by(geo2000);     

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
/****************************************************************************/;

use `path'\Temp\Tract_level_`name'.dta;
fillin geo2000 sic2code;   

recode  `var1'   .=0;
recode  `var2'   .=0;

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
