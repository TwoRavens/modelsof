#delimit;
cap n log close; log using /rdcprojects/br1/br00598/data/lbd10/lbd-bcd2-st-sum.log, replace;

* William Kerr;
* Aggregates raw panel files at state level;
* Last Modified: July 2010;

clear; clear matrix; set mem 5g; set matsize 8000; set more off;
chdir /rdcprojects/br1/br00598/data/lbd10/;

*** Generate index values;
use stlbl, clear; drop if st==1;
levelsof st, local(Ist);

*** Combine files;
!gunzip ./st2/lbdc-bcd2-1.dta;
use ./st2/lbdc-bcd2-1.dta, clear;
!gzip ./st2/lbdc-bcd2-1.dta;
foreach S1 of local Ist {;
!gunzip ./st2/lbdc-bcd2-`S1'.dta;
append using ./st2/lbdc-bcd2-`S1'.dta;
!gzip ./st2/lbdc-bcd2-`S1'.dta;
};

*** Describe and save combine files;
order state cou yr; sort state cou yr;
compress; memory;
format tot* bir* dth* %8.0f; des; sum;
save lbdc-bcd-2010-2.dta, replace;
for var _all: tab yr, s(X);
for var tot_ct tot_emp bir_ct bir_emp: table yr state, c(sum X) f(%8.0f) row col; 

*** End of Program;
cap n log close;