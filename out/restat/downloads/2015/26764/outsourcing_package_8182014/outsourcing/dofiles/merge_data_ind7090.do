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
 Program: merge_data.do
 Author:  Avi Ebenstein
 Created: March 2007
 Purpose: Merge the wage premium, cew, and trade data
=================================================*/

*******************************************************************;
* Merge the individual workers with the CEW/Trade/Outsourcing data ;
*******************************************************************;

use $masterpath/datafiles/micro_ind7090.dta;
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

label var man7090 "Consistent manufacturing industry code (adapted from Census Industry Class), adjusted for BEA";
label var man7090_orig "Consistent manufacturing industry code (adapted from Census Industry Class), 68 categories";
label data "Merged outsourcing data from CPS/CEW/TRADE/BEA sources, 1979-2002";
sort man7090_orig year;

*************************************************************************;
* Restrict the sample to years and observations with offshoring measures ;
*************************************************************************;

*drop if year<=1981;

save $masterpath/datafiles/merge_micro_ind7090, replace;

use $masterpath/datafiles/merge_micro_ind7090, replace;
do $masterpath/dofiles/keepvars;
save $masterpath/datafiles/merge_micro_ind7090_small, replace;
