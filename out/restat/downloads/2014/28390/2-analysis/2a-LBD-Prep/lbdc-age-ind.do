#delimit;
cap n log close; log using lbdc-age-ind.log, replace;

* William Kerr;
* LBD Age Collapse;
* Last Modified: 5 June 2009;

clear; set mem 2g; set matsize 8000; set more off;

local sector ="retail-full services1-full services2-full whsale mining trans construc mfg fire";
foreach v of local sector {;

*** Use raw LBD panel;
cd /rdcprojects/br1/br00598/nanda/democentry/data;
!gunzip lbdc-raw2-`v'.dta; 
use if (yr>=1976 & yr<=1992) using lbdc-raw2-`v'.dta, clear;
!gzip lbdc-raw2-`v'.dta;
compress; des; sum; ren state st;
cd /rdcprojects/br1/br00598/programs/coaggl/jue/lbd/data;

*** Identify births and deaths;
* Does not consider closure and reopening;
sort lbdnum yr; gen temp1=yr if (emp>0 & emp!=.); 
egen born=min(temp1), by(lbdnum); tab born;
gen age=1992-born; keep if yr==1992; tab age;
gen age0=0; replace age0=1 if (age>=0 & age<=5);
gen age6=0; replace age6=1 if (age>=6 & age<=10);
gen age11=0; replace age11=1 if (age>=11);
sum age*;

*** Merge with R9 identifiers;
log off; gen r9=.;
for any 9 23 25 33 44 50: replace r9=1 if st==X;
for any 34 36 42: replace r9=2 if st==X;
for any 17 18 26 39 55: replace r9=3 if st==X;
for any 19 20 27 29 31 38 46: replace r9=4 if st==X;
for any 10 11 12 13 24 37 45 51 54: replace r9=5 if st==X;
for any 1 21 28 47: replace r9=6 if st==X;
for any 5 22 40 48: replace r9=7 if st==X;
for any 4 8 16 30 32 35 49 56: replace r9=8 if st==X;
for any 2 6 15 41 53: replace r9=9 if st==X; log on;
tab st if r9==.; drop if r9==.;

*** Save output file;
collapse (mean) age*, by(r9 sic3) fast;
aorder; order r9 sic3 age*; sort r9 sic3;
compress; memory; des; sum;
cap n erase lbdc-ind-age-`v'.dta.gz;
save lbdc-ind-age-`v'.dta, replace;
!gzip lbdc-ind-age-`v'.dta;
cd ../files;
};

*** End of Program;
cap n log close;