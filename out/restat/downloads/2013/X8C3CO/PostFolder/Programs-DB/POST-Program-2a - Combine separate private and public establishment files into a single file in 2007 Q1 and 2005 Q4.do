/*
Should you use any of these programs or data, please provide the complete citation to the paper:

Rosenthal, Stuart S. and William C. Strange, “Female Entrepreneurship, Agglomeration, and a New Spatial Mismatch,”
Review of Economics and Statistics, August 2012, 94(3): 764–788.
*/


/*****************************************************************************/
/* This program takes D&B data on All Private and All Public Establishments
   and merges the two files into a single data file.  That new file includes
   raw D&B data on all public and private establishments.

   First, rename ownfirm (or ownnewfirm) and ownemp (or ownnewemp) 
   from public estab data file by adding suffix, _b, and save the file
   as temp_program1b_combine.dta in the temp folder.
 
   Second, merge private estab data file and the saved public estab data file
   into a single file.   

   Third, replace ownfirm (or ownnewfirm) and ownemp (or ownnewemp) with 
   ownfirm + ownfirm_b (or ownnewfirm + ownnewfirm_b) and 
   ownemp + ownemp_b (or ownnewemp + ownnewemp_b), respectively, so that 
   ownfirm (or ownnewfirm) and ownemp (or ownnewemp) in the new data file 
   can denote both private and public activities. 

   Outsheet data to create maps */
/*****************************************************************************/

#delimit ; 
clear;
set mem 3500m;
set matsize 800;
set more off;
capture log close;

/****************************************************************************/
/* DEFINE THE PATH TO ENTREPRENEUR FOLDER                                   */
/****************************************************************************/

local path D:\research\PROJECT\CURRENT\FemaleEntrepreneur\PostFolder;

/****************************************************************************/
/* SEND OUTPUT TO THE LOG FILE                                              */
/****************************************************************************/

log using `path'\Results\DB_Program2a.log, replace;

/****************************************************************************/
/* Loop through  
      1) all ages and sizes in Q1 of 2007 
      2) new (< 12 months) and small (< 10 emp) in Q1 of 2007
      3) all ages and sizes in Q4 of 2005
      4) all ages and small (< 10 emp) in Q4 of 2005
      5) all ages and large (>= 10 emp) in Q4 of 2005                       */
/****************************************************************************/

local i = 1;
   while `i' <= 5 {;

display "";
display "************** Group `i' ****************";
display "";

if `i' == 1 {;                                                   /*2007 Q1 all ages and sizes*/
    local data `path'\Temp\allyear;
    local year 07Q1;
    local var  own;
    local name allyear_allusa_pubandpriv_`year';
    };

if `i' == 2 {;                                                   /*2007 Q1 new (< 12 months) and small (< 10 emp)*/
    local data `path'\Temp\1yearold_9lessEstSize;           
    local year 07Q1;
    local var  ownnew;
    local name 1yearold_9lessEstSize_allusa_pubandpriv_`year';
    };

if `i' == 3 {;                                                   /*2005 Q4 all ages and sizes*/
    local data `path'\Temp\allyear;
    local year 05Q4;
    local var  own;
    local name allyear_allusa_pubandpriv_`year';
    };

if `i' == 4 {;                                                   /*2005 Q4 all ages and small (< 10 emp)*/
    local data `path'\Temp\allyear_9lessEstSize;
    local year 05Q4;
    local var  own;
    local name allyear_9lessEstSize_allusa_pubandpriv_`year';
    };

if `i' == 5 {;                                                   /*2005 Q4 all ages and large (>= 10 emp)*/
    local data `path'\Temp\allyear_10moreEstSize;
    local year 05Q4;
    local var  own;
    local name allyear_10moreEstSize_allusa_pubandpriv_`year';
    };

/****************************************************************************/
/* Open All Public Establishments Zip-Code Level Data                       */
/****************************************************************************/

use `data'_allusa_pub_`year'.dta, clear;

/****************************************************************************/
/* Rename Establishment and Employment Counts to denote public              */
/****************************************************************************/

rename `var'firm `var'firm_b;
rename `var'emp  `var'emp_b;

/****************************************************************************/
/* Save to Temporary Folder                                                 */
/****************************************************************************/

sort zip sic2code;
save `path'\Temp\temp.dta, replace;

/****************************************************************************/
/* Open All Private Establishment Zip-code Level Data                       */
/****************************************************************************/

use `data'_allusa_priv_`year'.dta, clear;

/****************************************************************************/
/* Merge with Public Establishment Data saved in the Temp folder above      */
/****************************************************************************/

sort zip sic2code;
merge zip sic2code using `path'\Temp\temp.dta;
erase `path'\Temp\temp.dta;

tab _merge;
drop _merge;

/****************************************************************************/
/* Convert missing values to zeros                                          */
/****************************************************************************/

replace `var'firm = 0 if `var'firm == .;
replace `var'emp  = 0 if `var'emp  == .;

replace `var'firm_b = 0 if `var'firm_b == .;
replace `var'emp_b  = 0 if `var'emp_b  == .;

/****************************************************************************/
/* Replace own estab variables to include BOTH private AND public estab
   and drop variables denoting public estab.                                */
/****************************************************************************/

replace `var'firm = `var'firm + `var'firm_b;
replace `var'emp  = `var'emp + `var'emp_b;

drop `var'firm_b `var'emp_b;

/****************************************************************************/
/* Save D&B data to Temp Folder                                             */
/****************************************************************************/

sort zip sic2code;
save `data'_allusa_pubandpriv_`year'.dta, replace;


/****************************************************************************/
/*Create IndusList Specific to file                                         */
/****************************************************************************/

sort sic2code;
by sic2code: gen number = _N; 
collapse (mean) number, by (sic2code);

keep if number > 1;               /*Drop industries with only 1 firm in US*/
list;
gen order = _n;
drop number;

outsheet using `path'\Data\induslist\induslist_`name'.txt, replace comma nonames;

clear;
local i = `i' + 1;
};

log close;

