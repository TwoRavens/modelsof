/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/


/****************************************************************************/
/* This program converts tract-level data created in Program 4 
   into ring-level data by using the tract-ring correspondence file.  
   We do not create ring variables 
   for new (< 12 months) & small (< 10 emp) estab as of Q1 in 2007.         */
/****************************************************************************/

#delimit;
clear;
set mem 3000m;
set matsize 800;
set more off;
capture log close;
set trace off;

/****************************************************************************/
/* DEFINE PATH TO FOLDERS                                                   */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************/
/* SEND OUTPUT TO THE LOG FILE                                              */
/****************************************************************************/

log using `path'\Results\DB_Program5.log, replace;

/****************************************************************************/
/* DEFINE RING SIZE TO MERGE EMPLOYMENT DATA TO                             */
/****************************************************************************/

local k = 1;
while `k' <= 1 {;

if `k' == 1 {;
  local size  1;
  local ring  r1;
};

if `k' == 2 {;
  local size  5;
  local ring  r5;
};

if `k' == 3 {;
  local size  10;
  local ring  r10;
};

if `k' == 4 {;
  local size  25;
  local ring  r25;
};

if `k' == 5 {;
  local size  50;
  local ring  r50;
};

/****************************************************************************/
/* Define data to be used
     - public and privately-owned (created in Program 4)
         1) 2007 Q1 all ages & sizes
         2) 2005 Q4 all ages & sizes 
         3) 2005 Q4 all ages & small (< 10 emp)
         4) 2005 Q4 all ages & large (>= 10 emp)

     - privately-owned very small (created in Program 4)
         5) 2007 Q1 all ages & very small (1 emp)

     - women-owned (cleaned in Program 4)
         6) 2007 Q1 all ages & sizes
         7) 2007 Q1 all ages & very small (1 emp)
         8) 2005 Q4 all ages & sizes 
         9) 2005 Q4 all ages & small (< 10 emp)
        10) 2005 Q4 all ages & large (>= 10 emp)

     - public-owned (cleaned in Program 4)
        11) 2007 Q1 all ages & sizes
        12) 2005 Q4 all ages & sizes 
        13) 2005 Q4 all ages & small (< 10 emp)
        14) 2005 Q4 all ages & large (>= 10 emp)

   NOTE: ring variables are not created 
         for 2007 Q1 new (< 12 months) & small (< 10 emp) estab. */
/****************************************************************************/

local j = 1;
  while `j' <= 14 {;

display "";
display "********************* Group `j' *************************";
display "";

/*all public and private-owned enterprises*/

if `j' == 1 {;
  local name  allyear_allusa_pubandpriv_07Q1;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 2 {;
  local name  allyear_allusa_pubandpriv_05Q4;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 3 {;
  local name  allyear_9lessEstSize_allusa_pubandpriv_05Q4;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 4 {;
  local name  allyear_10moreEstSize_allusa_pubandpriv_05Q4;
  local var1  ownfirm;
  local var2  ownemp;
};


/*all private-owned very small enterprises*/

if `j' == 5 {;
  local name  allyear_1EstSize_allusa_priv_07Q1;
  local var1  ownfirm;
  local var2  ownemp;
};

/*women-owned enterprises*/

if `j' == 6 {;
  local name  allyear_allusa_priv_women_07Q1;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 7 {;
  local name  allyear_1EstSize_allusa_priv_women_07Q1;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 8 {;
  local name  allyear_allusa_priv_women_05Q4;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 9 {;
  local name  allyear_9lessEstSize_allusa_priv_women_05Q4;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 10 {;
  local name  allyear_10moreEstSize_allusa_priv_women_05Q4;
  local var1  ownfirm;
  local var2  ownemp;
};


/*publicly-owned enterprises*/

if `j' == 11 {;
  local name  allyear_allusa_pub_07Q1;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 12 {;
  local name  allyear_allusa_pub_05Q4;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 13 {;
  local name  allyear_9lessEstSize_allusa_pub_05Q4;
  local var1  ownfirm;
  local var2  ownemp;
};

if `j' == 14 {;
  local name  allyear_10moreEstSize_allusa_pub_05Q4;
  local var1  ownfirm;
  local var2  ownemp;
};

/****************************************************************************/
/* First determine the number of Industries in the INDUSTRIES List File     */
/****************************************************************************/

clear;
insheet using `path'\Data\induslist\induslist_`name'.txt;
gen  rownum  = _N;
local rownum = rownum;
display "Number of Industries" `rownum';

ren v1 sic2code;
sort sic2code;
clear;

local i = 0;
while `i' <= `rownum' {;

insheet using `path'\Data\induslist\induslist_`name'.txt, c;

ren v1 sic2code;
sort sic2code;

/****************************************************************************/
/*Write the name of the industry currently being processed to a local macro.*/
/****************************************************************************/

if `i' == 0 {;
local sic = 0;
};

if `i' > 0 {;
local sic = sic2code[`i'];
};

display "*****";
display "`sic'";
display "*****";
clear;

/****************************************************************************/
/* Read in D&B DATA files created in Program 4                              */
/****************************************************************************/

use `path'\Temp\Tract_level_`name'_w-all.dta, clear;

keep if sic2code==`sic';

capture drop county scounty state sstate;

/****************************************************************************/
/* Create County Level Employment Data for rings 50 and over                */
/****************************************************************************/

if `k' >= 4 {;

gen str5 countycd  = substr(geo2000,1,5);

sort countycd;
collapse (sum) `var1' `var2' (mean) sic2code, by(countycd);     
};

/****************************************************************************/
/* Merge D&B DATA with tract-ring 
   (or county-ring for rings with at least 50 miles radius) correspondence  */
/****************************************************************************/

if `k' < 4 {;

sort geo2000;
merge geo2000 using `path'\Data\correspondences\corr-pctTinR`size'.dta;
};

if `k' >= 4 {;
sort countycd;
merge countycd using `path'\Data\correspondences\corr-pctCinR`size'.dta;
};

keep if _merge == 3;                      /*Retain obs only if in both files*/
drop _merge;

/****************************************************************************/
/* Convert tract-level data to ring-level Geography using correspondences   */
/****************************************************************************/

if `k' < 4 {;
gen `var1'_t  = `var1'* pcttinr`size';    /*Multiply New Firms in geo200 by Percent in ring*/;
gen `var2'_t  = `var2'* pcttinr`size';    /*Multply New Employment in geo200 by Percent in ring*/;
};

if `k' >= 4 {;
gen `var1'_t  = `var1'* pctcinr`size';    /*Multiply New Firms in geo200 by Percent in ring*/;
gen `var2'_t  = `var2'* pctcinr`size';    /*Multply New Employment in geo200 by Percent in ring*/;
};

drop `var1' `var2';

ren `var1'_t   `var1';
ren `var2'_t   `var2';

/****************************************************************************/
/* Collapse tract-level data into ring-level data                           */
/****************************************************************************/

sort ring00;
collapse (sum) `var1' `var2' (mean) sic2code, by(ring00);     

rename ring00 geo2000;

if `i' == 0 {;
save `path'\Temp\Ring_level_dist_`ring'_`name'.dta, replace;
};

if `i' > 0 {;
append using `path'\Temp\Ring_level_dist_`ring'_`name'.dta;
sort geo2000 sic2code;
save `path'\Temp\Ring_level_dist_`ring'_`name'.dta, replace;
};

clear;
local i = `i' + 1;
};

clear;

/****************************************************************************/
/*Now advance the loop for the different raw data files being processed     */
/****************************************************************************/

local j = `j' + 1;
};

/****************************************************************************/
/*Now advance the loop for the different ring sizes being processed         */
/****************************************************************************/

local k = `k' + 1;
};

log close;
