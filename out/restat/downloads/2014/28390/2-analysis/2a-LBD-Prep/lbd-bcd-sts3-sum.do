#delimit;
cap n log close; log using /rdcprojects/br1/br00598/data/lbd10/lbd-bcd-sts3-sum.log, replace;

* William Kerr;
* Aggregates raw panel files at state level;
* Last Modified: July 2010;

clear; clear matrix; set mem 5g; set matsize 8000; set more off;
chdir /rdcprojects/br1/br00598/data/lbd10/;

*** Generate index values;
use stlbl, clear; drop if st==1;
levelsof st, local(Ist);

*** Combine files;
!gunzip ./st2s3/lbdc-bcd-s3-1.dta;
use ./st2s3/lbdc-bcd-s3-1.dta, clear;
!gzip ./st2s3/lbdc-bcd-s3-1'.dta;
foreach S1 of local Ist {;
!gunzip ./st2s3/lbdc-bcd-s3-`S1'.dta;
append using ./st2s3/lbdc-bcd-s3-`S1'.dta;
!gzip ./st2s3/lbdc-bcd-s3-`S1'.dta;
};

*** Describe and save combine files;
order state cou yr; sort state cou yr;
compress; memory;
save lbdc-bcd-s3-2010.dta, replace;
format tot* bir* dth* %8.0f; des; sum;
for var _all: tab yr, s(X);
for var tot_ct tot_emp bir_ct bir_emp: table yr state, c(sum X) f(%8.0f); 

*** End of Program;
cap n log close;