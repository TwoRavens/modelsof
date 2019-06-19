#delimit;
clear;
set more off;
set matsize 800;

global temp /Sastemp;
global path ~/research;
set mem 5000m;

capture log close;
*log using $masterpath/logfiles/cew_data.log, replace;

/*================================================
 Program: cew_data.do
 Author:  Avi Ebenstein
 Created: April 2007
 Purpose: Take in the raw CEW data and
          merge with the industry information
          provided by David Autor providing a CPS MORG
          consistent industry definition (man7090).
=================================================*/

******************************************************************;
* Take data from 1975-2000, and convert from SIC 72/87 -> man7090 ;
******************************************************************;

use $masterpath/cew/cew_75_00.dta;

*********************************************;
* Only keep private enterprises who disclose ;
*********************************************;

keep if own==5;
drop if nd==9;
preserve;

*****************;
* Pre-88 Switch  ;
*****************;

keep if year<=1987;
rename sic sic72_3;
sort sic72_3;
merge sic72_3 using $masterpath/autor/sic72_3-man7090;
tab _merge;
keep if _merge==3;
save $masterpath/cew/cew_75_87, replace;
restore;

*****************;
* Post-88 Switch ;
*****************;

keep if year>=1988;
rename sic sic87;
sort sic87;
merge sic87 using $masterpath/autor/sic87_3-man7090;
tab _merge;
keep if _merge==3;
save $masterpath/cew/cew_88_00, replace;

*****************;
* Pool the data  ;
*****************;

use $masterpath/cew/cew_75_87;
append using $masterpath/cew/cew_88_00;
collapse (sum) emp_cew=emp (sum) wages_cew=wages, by(man7090 year);

label data "Census of Employment and Wages at man7090 level (68 categories)";
label var emp_cew "CEW employment";
label var wages_cew "CEW total wages";

do $masterpath/dofiles/labels_man7090.do;
save $masterpath/datafiles/cew_man7090, replace;
