* William Kerr, TGG; 
* Pat Prep File for Agglomeration Work;
* Generates KD for Random Counterfactuals in DO calculations;
* Last Updated 30 April 2010;

#delimit;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/prep5-do/ran3-lci;
cap n log close; log using p-prep5-ran-do4b.log, replace;
clear; clear matrix; set memory 5g; set matsize 1000; set more off;

*********************************;
** Combine LCI densities       **;
*********************************;

*** Generate industry list;
use scat ayear if ayear==1990
    using ./../../../svdata/p-work-pat_2009_short.dta, clear;
gen ct=1; collapse (sum) ct, by(scat) fast; drop ct;
for any 11 19 59 69: drop if scat==X; drop if scat==.; sort scat; list; count;
levelsof scat, local(scatindexA);

*** Combine LCI files;
use ./../../../svdata-do/random3/do-ran-density-11.dta, replace;
foreach KKA of local scatindexA {;
append using ./../../../svdata-do/random3/do-ran-density-`KKA'.dta;
};
egen scatrnd=group(scat rnd);
compress; sum;

*********************************;
** Combine Metrics and Compare **;
*********************************;
* Based upon p-prep5-do3.do;

*** Summarize base kernel distances;
sort scatrnd dist;
gen kdt_ct=kd_ct;
replace kdt_ct=kdt_ct[_n-1]+kd_ct if scatrnd==scatrnd[_n-1] & dist==dist[_n-1]+1;
list in 1/20;
tab dist if dist<250, s(kd_ct);
tab dist if dist<250, s(kdt_ct);

*** Generate distance bins;
*keep if dist<=250; keep if dist<=1000;
gen zD=01 if (dist<1);
replace zD=05 if (dist>=1 & dist<=5);
forvalues AA=10(5)1000 {;
replace zD=`AA' if (dist>`AA'-5 & dist<=`AA');
};
tab zD; tab dist if zD==.;

*** Collapse local and cumulative densities by bins;
collapse (mean) kd_ct (max) kdt_ct, by(scat rnd zD) fast;
reshape wide kd_ct kdt_ct, i(scat rnd) j(zD);
compress; aorder; order scat rnd; sort scat rnd; sum;
save ./../../../svdata-do/random4/do-ran-density-raw.dta, replace;

*** End of program;
log close; 