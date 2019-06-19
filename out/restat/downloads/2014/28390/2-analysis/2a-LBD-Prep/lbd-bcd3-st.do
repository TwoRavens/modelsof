#delimit;
cap n log close; log using /rdcprojects/br1/br00598/data/lbd10/lbd-bcd3-st.log, replace;

* William Kerr;
* Create raw panel files at state level;
* Last Modified: April 2011;

clear; clear matrix; set mem 5g; set matsize 8000; set more off;
chdir /rdcprojects/br1/br00598/data/lbd10/;

*** Generate index values;
use stlbl, clear;
levelsof st, local(Ist);

*** Collapse county distributions;
foreach S1 of local Ist {;
!gunzip ./st1/lbdc-raw-`S1'.dta;
use ./st1/lbdc-raw-`S1'.dta, clear;
!gzip ./st1/lbdc-raw-`S1'.dta;
 
*** Identify births and deaths;
gen temp1=yr if (emp>0 & emp!=.); 
egen temp2=min(temp1), by(lbdnum); tab temp2;
egen temp3=max(temp1), by(lbdnum); tab temp3;
count; count if temp2==temp3;

**** Define Su;
gen su=(mu==0); tab su;
keep state cou su yr emp temp2 temp3;

*** Disaggregate LBD;
gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte yng_ct=0; replace yng_ct=1 if (yr-temp2<=4 & emp>0 & emp!=.); 
gen byte yng_ct_su=0; replace yng_ct_su=1 if (yng_ct==1 & su==1);
gen byte yng_emp=0; replace yng_emp=emp if yng_ct==1;
gen byte yng_emp_su=0; replace yng_emp_su=emp if yng_ct_su==1;

keep state cou yr tot* yng*; 
collapse (sum) tot* yng*, by(state cou yr) fast;
sort state cou yr;

*** Clean sample end years;
*for var bir*: replace X=. if (yr==1976);
*for var dth*: replace X=. if (yr==2005);

*** Save output file;
aorder; order state cou yr; sort state cou yr;
compress; memory; des; sum;
save ./st3/lbdc-bcd3-`S1'.dta, replace;
cap n erase ./st3/lbdc-bcd3-`S1'.dta.gz;
!gzip ./st3/lbdc-bcd3-`S1'.dta;
};

*** End of Program;
cap n log close;