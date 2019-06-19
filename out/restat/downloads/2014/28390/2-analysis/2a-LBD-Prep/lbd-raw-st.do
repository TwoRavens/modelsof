#delimit;
cap n log close; log using /rdcprojects/br1/br00598/data/lbd10/lbd-raw-st.log, replace;

* William Kerr;
* Create raw panel files at state level;
* Last Modified: July 2010;

clear; clear matrix; set mem 5g; set matsize 8000; set more off;
chdir /rdcprojects/br1/br00598/data/lbd10/;

*** Unzip base data;
for num 1976/2005: !gunzip ./data/lbdXa.dta;

*** Generate index values;
use stlbl, clear;
levelsof st, local(Ist);

*** Collapse county distributions;
foreach S1 of local Ist {;
use lbdnum yr state county emp cfn pay mu if st==`S1' using ./data/lbd1976a.dta, clear;
compress; save temp1-st, replace;
forvalues YR1=1977(1)2005 {;
use lbdnum yr state county emp cfn pay mu if st==`S1' using ./data/lbd`YR1'a.dta, clear;
compress; append using temp1-st;
save temp1-st, replace;
};

*** Display raw yearly employment sum and clean outliers;
sum;
egen temp1=sum(emp), by(yr);
tab yr, s(temp1);
drop temp1;
gen xx=emp>=50000 & emp!=.;
replace xx=1 if emp<0;
compress;
egen byte xxx=max(xx), by(lbdnum);
tab yr xx;
tab emp if xx==1;
sort lbdnum yr;
list lbdnum yr emp if xxx==1, noobs clean;
replace emp=. if xx==1;
drop xx xxx;
egen temp1=sum(emp), by(yr);
tab yr, s(temp1);
drop temp1;

compress; sort lbdnum yr; sum;
cap n erase ./st1/lbdc-raw-`S1'.dta.gz;
save ./st1/lbdc-raw-`S1'.dta, replace;
!gzip ./st1/lbdc-raw-`S1'.dta;
erase temp1-st.dta;
};

*** Zip base data;
*for num 1976/2005: !gzip ./data/lbdXa.dta;

***End Program;
cap n log close;