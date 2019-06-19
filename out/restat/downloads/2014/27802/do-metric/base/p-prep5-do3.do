* William Kerr, TGG; 
* Pat Prep File for Agglomeration Work;
* Combine DO Calculations;
* Last Updated 13 Nov 2009;

#delimit;
cap n log close; log using ./logdir/p-prep5-do3.log, replace;
clear; set memory 5g; set matsize 1000; set more off;

*********************************;
** Combine Metrics and Compare **;
*********************************;

*** Combine Base Files;
use ./svdata-do/do-scat-zip-1, clear;
drop if scat==11;
levelsof scat, local(ind3);
use ./svdata-do/do-scat-zip-3-11, replace;
foreach Q3 of local ind3 {;
append using ./svdata-do/do-scat-zip-3-`Q3';
};

*** Summarize base kernel distances;
sort scat dist;
gen kdt_ct=kd_ct;
replace kdt_ct=kdt_ct[_n-1]+kd_ct if scat==scat[_n-1] & dist==dist[_n-1]+1;
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
collapse (mean) kd_ct (max) kdt_ct, by(scat zD) fast;
reshape wide kd_ct kdt_ct, i(scat) j(zD);
aorder; order scat; sort scat; 
save ./svdata-do/do-scat-kd, replace; sum;

*** End of program;
log close; 