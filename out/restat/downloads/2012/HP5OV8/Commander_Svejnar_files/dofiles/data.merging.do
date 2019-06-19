# delimit;
capture log close;
clear;
set more 1;
set mem 300m;
set matsize 800;
*set maxvar  1000;
set more on;
/*
*******************************;
1st August  July 2005
Randolph bruno
program from alex muraviev, modified by randolph bruno to merge external file
*******************************;
*/

cd "$dir";

log using logs/data_merging.txt, text replace;

***************************************************;
use data/data_recoded, clear;

* MERGING WITH EXTERNAL DATA *;

* 1 step - loading a main file, then sorting data by country and year *;
sort country year; 
save temp1, replace;

* 2 step - loading a file with external data, then sorting by country and year *;

use "data/data_external.dta";

* This is needed to ensure consistency between the two datasets: financial data in BEEPS 2005 refer to 2004! *; 
replace year=year+1;


sort country year;

keep if year==1999 | year==2002 | year==2005;


* 3 step - merging the two datasets by country and year *;

merge country year using temp1.dta;



drop if _merge==1;

drop _merge;



save data/data_merged.dta, replace;


log close;

 


