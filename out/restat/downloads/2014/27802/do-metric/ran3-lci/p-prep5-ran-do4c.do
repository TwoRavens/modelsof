* William Kerr, TGG; 
* Pat Prep File for Agglomeration Work;
* Generates KD for Random Counterfactuals in DO calculations;
* Last Updated 30 April 2010;

#delimit;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/prep5-do/ran3-lci;
cap n log close; log using p-prep5-ran-do4c.log, replace;
clear; clear matrix; set memory 5g; set matsize 1000; set more off;

*********************************;
** Collapse metrics to 95%-99%  *;
*********************************;

*** Collapse local and cumulative densities;
use ./../../../svdata-do/random4/do-ran-density-raw.dta, clear;
drop kdt_ct*;
log off;
for var kd*:
\ egen p01_X=pctile(X), p(1) by(scat)
\ egen p05_X=pctile(X), p(5) by(scat)
\ egen p95_X=pctile(X), p(95) by(scat)
\ egen p99_X=pctile(X), p(99) by(scat);
log on;
aorder; order scat rnd; sort scat rnd; 
list scat rnd kd_ct1 p01_kd_ct1 p05_kd_ct1 p95_kd_ct1 p99_kd_ct1 in 1/10;
list scat rnd kd_ct10 p01_kd_ct10 p05_kd_ct10 p95_kd_ct10 p99_kd_ct10 in 1/10;
list scat rnd kd_ct100 p01_kd_ct100 p05_kd_ct100 p95_kd_ct100 p99_kd_ct100 in 1/10;
keep if rnd==1; keep scat p*;
aorder; order scat; sort scat;

*** Fill out scat distribution;
expand 3 if scat==22;
sort scat; replace scat=69 if scat==22 & scat[_n-2]==22;
sort scat; replace scat=19 if scat==22 & scat[_n-1]==22;
expand 2 if scat==31;
sort scat; replace scat=59 if scat==31 & scat[_n-1]==31;
sort scat; tab scat;

*** Reshape long and save file;
reshape long p01_kd_ct p05_kd_ct p95_kd_ct p99_kd_ct, i(scat) j(dist);
sort scat dist; compress; sum;
save ./../../../svdata-do/random4/do-ran-density-lci.dta, replace;

*** End of program;
log close; 