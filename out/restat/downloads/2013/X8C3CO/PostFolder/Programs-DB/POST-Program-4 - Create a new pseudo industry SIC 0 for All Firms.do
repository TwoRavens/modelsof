/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/


/**********************************************************************************/
/*This program utilizes the tract-level data created in earlier programs and creates
the allfirm and allemp variables.  These variables are equal to the sum
of their industry-specific values across all 83 2-digit industries in D&B data.

For each of the data files over which we loop below, this program creates two
variables, allfirm and allemp for each census tract but calls these ownfirm and
ownemp initially. We assign an SIC code of 0 to the "all" data and append to each
individual file.

Note that we do not produce the new SIC-0 (all industries) data for the newly
created estab so there is one less set of files to process relative to program 3.

All data files read into this program were produced from Program 3.               

The output from this program is a new tract-level file for each of the D&B files
over which we loop.  The new file includes an additional block of rows (each row
is a census tract) for SIC 0.
*/
/**********************************************************************************/

#delimit;
clear;
set mem 3000m;
set matsize 800;
set more off;
capture log close;
set trace off;

/****************************************************************************/
/*DEFINE PATH TO FOLDERS                                                    */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************/
/*SEND OUTPUT TO THE LOG FILE                                               */
/****************************************************************************/

log using `path'\Results\DB_Program4.log, replace;

/****************************************************************************/
/*DEFINE DATA TO BE USED (NOTE: There are 14 different D&B datafiles)       */
/****************************************************************************/

local j = 1;
  while `j' <= 14 {;


/*All Public and Private-Owned Enterprises*/

if `j' == 1 {;                                                 /*2007 Q1 all ages and sizes pub and private estab*/
  local name  allyear_allusa_pubandpriv_07Q1;
  local var1  firm;
  local var2  emp;
};

if `j' == 2 {;                                                 /*2005 Q4 all ages and sizes pub and private estab*/
  local name  allyear_allusa_pubandpriv_05Q4;
  local var1  firm;
  local var2  emp;
};

if `j' == 3 {;                                                 /*2005 Q4 all ages small (< 10 workers) pub and private estab*/
  local name  allyear_9lessEstSize_allusa_pubandpriv_05Q4;
  local var1  firm;
  local var2  emp;
};

if `j' == 4 {;                                                 /*2005 Q4 all ages large (>= 10 workers) pub and private estab*/
  local name  allyear_10moreEstSize_allusa_pubandpriv_05Q4;
  local var1  firm;
  local var2  emp;
};


/*All Private-Owned Very Small Enterprises*/

if `j' == 5 {;                                                 /*2007 Q1 all ages & very small (1 emp), both pub and priv*/
  local name  allyear_1EstSize_allusa_priv_07Q1;
  local var1  firm;
  local var2  emp;
};


/*Women-Owned Enterprises*/

if `j' == 6 {;
  local name  allyear_allusa_priv_women_07Q1;
  local var1  firm;
  local var2  emp;
};

if `j' == 7 {;
  local name  allyear_1EstSize_allusa_priv_women_07Q1;
  local var1  firm;
  local var2  emp;
};

if `j' == 8 {;
  local name  allyear_allusa_priv_women_05Q4;
  local var1  firm;
  local var2  emp;
};

if `j' == 9 {;
  local name  allyear_9lessEstSize_allusa_priv_women_05Q4;
  local var1  firm;
  local var2  emp;
};

if `j' == 10 {;
  local name  allyear_10moreEstSize_allusa_priv_women_05Q4;
  local var1  firm;
  local var2  emp;
};


/*Publicly-Owned Enterprises*/

if `j' == 11 {;
  local name  allyear_allusa_pub_07Q1;
  local var1  firm;
  local var2  emp;
};

if `j' == 12 {;
  local name  allyear_allusa_pub_05Q4;
  local var1  firm;
  local var2  emp;
};

if `j' == 13 {;
  local name  allyear_9lessEstSize_allusa_pub_05Q4;
  local var1  firm;
  local var2  emp;
};

if `j' == 14 {;
  local name  allyear_10moreEstSize_allusa_pub_05Q4;
  local var1  firm;
  local var2  emp;
};


/****************************************************************************/
/*Read in Tract-level D&B DATA                                              */
/****************************************************************************/
                     
use `path'\Temp\Tract_level_`name'.dta, clear;
sort geo2000 sic2code;

/****************************************************************************/
/*Create an "all firms" pseudo SIC file with the SIC code set to 0          */
/****************************************************************************/

/*Generate the allfirm/emp variable*/

sort geo2000 sic2code;

egen all`var1'       = sum(own`var1'),  by (geo2000);               /*This sums own-industry firm counts within tracts*/
egen all`var2'       = sum(own`var2'),  by (geo2000);               /*This sums own-industry employment within tracts*/

/*Recode that variable equal to sic2 code 0*/

drop own*;                                                          /*Drop all variables that start with "own"*/ 
rename all`var1'  own`var1';;
rename all`var2'  own`var2';

collapse (mean) own`var1' own`var2', by(geo2000);
gen sic2code = 0;

/*Append to main data with allfirm now coded as sic 0*/

append using "`path'\Temp\Tract_level_`name'.dta";
sort geo2000 sic2code;                                               /*Sort data for the merge with ring-level data in Program 6*/                                  

compress;
save "`path'\Temp\Tract_level_`name'_w-all.dta", replace;       /*Save the cleaned version of the D&B data file*/

/****************************************************************************/
/*Now advance the loop for the different data files being processed         */
/****************************************************************************/

local j = `j' + 1;
};

log close;
