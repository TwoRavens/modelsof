* William Kerr, TGG; 
* Pat Prep File for Agglomeration Work;
* Generates KD for Random Counterfactuals in DO calculations;
* Last Updated 30 April 2010;

#delimit;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/prep5-do/ran3-lci;
cap n log close; log using p-prep5-ran-do4a.log, replace;
clear; clear matrix; set memory 5g; set matsize 1000; set more off;

*************************************;
** Generate list of industries     **;
*************************************;

*** Open working file;
use scat ayear if ayear==1990
    using ./../../../svdata/p-work-pat_2009_short.dta, clear;
gen ct=1; collapse (sum) ct, by(scat) fast; drop ct;
for any 19 59 69: drop if scat==X; drop if scat==.; sort scat; list; count;
levelsof scat, local(scatindexA);

*********************************;
** Calculate kernel densities  **;
*********************************;
log off;

foreach KKA of local scatindexA {;

  !gunzip ./../../../svdata-do/random3/do-ran-density-`KKA'-1.dta;
  use ./../../../svdata-do/random3/do-ran-density-`KKA'-1, clear;
  !gzip ./../../../svdata-do/random3/do-ran-density-`KKA'-1.dta;
  gen int rnd=1;

forvalues LLA=2(1)1000 {;

  !gunzip ./../../../svdata-do/random3/do-ran-density-`KKA'-`LLA'.dta;
  append using ./../../../svdata-do/random3/do-ran-density-`KKA'-`LLA';
  !gzip ./../../../svdata-do/random3/do-ran-density-`KKA'-`LLA'.dta;
  replace rnd=`LLA' if rnd==.;

};

log on;
gen scat=`KKA'; compress; sum;
save ./../../../svdata-do/random3/do-ran-density-`KKA'.dta, replace;
log off;

};

*** End of program;
log close; 