/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/


/*****************************************************************************/
/* This program takes D&B data on All Private and All Public Establishments
   and merges the two files into a single data file.  That new file includes
   raw D&B data on all public and private establishments.

   First, rename ownnewfirm, ownnewemp, and ownnewsales from public estab data
   file by adding suffix, _b, and save the file as temp_program2s_combine.dta
   in the temp folder.
 
   Second, merge private estab data file and the saved public estab data file
   into a single file.   

   Third, replace ownnewfirm, ownnewemp, and ownnewsales with ownnewfirm + 
   ownnewfirm_b, ownnewemp + ownnewemp_b, and ownnewsales + ownnewsales_b, 
   respectively, so that ownnewfirm, ownnewemp, and ownnewsales in the new data
   file can denote both private and public activities. 

   Outsheet data to create maps */
/*****************************************************************************/

#delimit ; 
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
/* SEND OUTPUT TO THE LOG FILE                                              */
/****************************************************************************/

log using `path'\Results\DB_Program2b.log, replace;

/****************************************************************************/
/*Loop over the establishment size data files to be read into the program   */ 
/****************************************************************************/

local i = 1;
   while `i' <= 3 {;

if `i' == 1 {;
    local data `path'\Temp\1yearold_1EstSize;
    local year 07Q1;
    local var  ownnew;
    local name 1yearold_1EstSize_allusa_pubandpriv_`year';
    };

if `i' == 2 {;
    local data `path'\Temp\1yearold_2to4EstSize;
    local year 07Q1;
    local var  ownnew;
    local name 1yearold_2to4EstSize_allusa_pubandpriv_`year';
    };

if `i' == 3 {;
    local data `path'\Temp\1yearold_5to9EstSize;
    local year 07Q1;
    local var  ownnew;
    local name 1yearold_5to9EstSize_allusa_pubandpriv_`year';
    };

/****************************************************************************/
/* Open All Public Establishments Zip-Code Level Data                       */
/****************************************************************************/

use `data'_allusa_pub_`year'.dta, clear;  /*Data are from Program 1*/

/****************************************************************************/
/* Rename Establishment and Employment Counts to denote public              */
/****************************************************************************/

rename `var'firm   `var'firm_b;
rename `var'emp    `var'emp_b;
rename `var'sales  `var'sales_b;

/****************************************************************************/
/*Save to Temporary Folder*/
/****************************************************************************/

sort zip sic2code;
save `path'\Temp\temp_program2s_combine.dta, replace;

/****************************************************************************/
/*Open All Private Establishment Zip-code Level Data*/
/****************************************************************************/

use `data'_allusa_priv_`year'.dta, clear;

/****************************************************************************/
/* Merge with Public Establishment Data Series                              */
/****************************************************************************/

sort zip sic2code;
merge zip sic2code using `path'\Temp\temp_program2s_combine.dta;

tab _merge;
drop _merge;

/****************************************************************************/
/* Convert Missing Values to Zeros                                          */
/****************************************************************************/

replace `var'firm  = 0 if `var'firm  == .;
replace `var'emp   = 0 if `var'emp   == .;
replace `var'sales = 0 if `var'sales == .;

replace `var'firm_b  = 0 if `var'firm_b  == .;
replace `var'emp_b   = 0 if `var'emp_b   == .;
replace `var'sales_b = 0 if `var'sales_b == .;

/****************************************************************************/
/* Replace Own Establishment Variables to Include Both Private and Public 
   Establishments */
/****************************************************************************/

replace `var'firm  = `var'firm  + `var'firm_b;
replace `var'emp   = `var'emp   + `var'emp_b;
replace `var'sales = `var'sales + `var'sales_b;

drop `var'firm_b `var'emp_b `var'sales_b;

/****************************************************************************/
/* Save to Temp Folder                                                      */
/****************************************************************************/
sort zip sic2code;
save `data'_allusa_pubandpriv_`year'.dta, replace;

/****************************************************************************/
/*Create IndusList Specific to file                                         */
/****************************************************************************/

sort sic2code;
by sic2code: gen number = _N; 
collapse (mean) number, by (sic2code);

keep if number > 1;               /*Drop Industries with only 1 Firm in US*/
list;
gen order = _n;
drop number;

outsheet using `path'\Data\induslist\induslist_`name'.txt, replace comma nonames;

clear;
local i = `i' + 1;
};

log close;

