#delimit;
clear;
set more off;
set matsize 800;

global temp /Sastemp;
global path ~/research;
set mem 5000m;

capture log close;
*log using $masterpath/logfiles/marchcps.log, replace;

/*================================================
 Program: merge_data_educ_man7090.do
 Author:  Avi Ebenstein
 Created: March 2007
 Purpose: Merge the wage premium, cew, and trade data - creates merge_educ_man7090.dta
=================================================*/

use $masterpath/datafiles/premium_educ_man7090;
drop if educ==.;

sort man7090 year;
merge man7090 year using $masterpath/datafiles/cew_man7090;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

sort man7090 year;
merge man7090 year using $masterpath/datafiles/trade_man7090;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

***********************************************************************;
* Recode man7090 to eliminate categories not available in the BEA data ;
***********************************************************************;

gen man7090_orig=man7090;
do $masterpath/dofiles/man7090_bea.do;
do $masterpath/dofiles/labels_man7090_orig.do;

sort man7090 year;
merge man7090 year using $masterpath/bea/emp_man7090;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

***************************;
* China & India employment ;
***************************;

sort man7090 year;
merge man7090 year using $masterpath/bea/china_india_man7090;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

label var man7090 "Consistent manufacturing industry code (adapted from Census Industry Class)";
label data "Merged outsourcing data from CPS/CEW/TRADE sources, 1979-2002";
sort man7090_orig year;

save $masterpath/datafiles/merge_educ_man7090, replace;
