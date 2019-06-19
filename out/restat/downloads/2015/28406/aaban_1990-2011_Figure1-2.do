************************************
*** aaban_1990-2011_Figure1-2.do ***
************************************

*****************************************************************
*** This program produces the output used in figures 1 and 2  ***
*** that appear in Incentives to Identify: Racial Identity in ***
*** the Age of Affirmative Action, by Francisca Antman and    ***
*** Brian Duncan.                                             ***
*****************************************************************

capture log close
log using aaban_1990-2011_Figure1-2.log, replace

#delimit ;
set more off;

clear;
use aaban_1990-2011d1.dta;

*********************************************************************;
*** This data was created by the program aaban_1900-2001d1.do     ***;
*** Source: 1990 Census, 2000 Census, 2001-2011 ACS.              ***;
*** Sample: U.S.-born, aged 0-59, without an allocated race or    ***;
***         Hispanic origin.                                      ***;
*********************************************************************;

*************************************************************;
*** Limit Sample to States with an Affirmative Action Ban ***;
*************************************************************;

   keep if statefip==6  | statefip==53 | statefip==12 | 
           statefip==31 | statefip==26 ;

*********************************;
*** Collapse Data by Ban Year ***;
*********************************;
   
* Black;
   preserve;
   collapse (mean) black_any, 
             by(banyear noneblack_anc blackother_anc onlyblack_anc);
   sort  noneblack_anc blackother_anc onlyblack_anc banyear;
   outsheet using aaban_1990-2011_Figure1-2_black.csv, comma replace;
   restore, preserve;

* Asian;
   collapse (mean) asian_any, 
             by(banyear noneasian_anc asianother_anc onlyasian_anc);
   sort  noneasian_anc asianother_anc onlyasian_anc banyear;
   outsheet using aaban_1990-2011_Figure1-2_asian.csv, comma replace;
   restore, preserve;

set more on;
log close;
exit, clear STATA;
