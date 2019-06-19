#delimit;
cap n log close; log using /rdcprojects/br1/br00598/data/lbd10/lbd-bcd2-st.log, replace;

* William Kerr;
* Create raw panel files at state level;
* Last Modified: July 2010;

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
tab yr if su==1 & substr(cfn,1,1)!="0";

*** Designate size categories;
gen byte size=0;
replace size=1 if emp>0 & emp<=5;
replace size=6 if emp>5 & emp<=20;
replace size=21 if emp>20 & emp<=100;
replace size=101 if emp>100 & emp!=.;
tab size; drop if size==0;
keep state cou su yr size emp temp2 temp3;

*** Disaggregate LBD;
gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte tot_ct_su=0; replace tot_ct_su=1 if (tot_ct==1 & su==1);
gen byte tot_emp=0; replace tot_emp=emp if tot_ct==1;
gen byte tot_emp_su=0; replace tot_emp_su=emp if tot_ct_su==1;

gen byte bir_ct=0; replace bir_ct=1 if (temp2==yr & emp>0 & emp!=.); 
gen byte bir_ct_su=0; replace bir_ct_su=1 if (bir_ct==1 & su==1);
gen byte bir_emp=0; replace bir_emp=emp if bir_ct==1;
gen byte bir_emp_su=0; replace bir_emp_su=emp if bir_ct_su==1;

gen byte bir1_ct=0; replace bir1_ct=1 if (temp2==yr & emp>0 & emp!=. & size==1); 
gen byte bir1_ct_su=0; replace bir1_ct_su=1 if (bir1_ct==1 & su==1);
gen byte bir1_emp=0; replace bir1_emp=emp if bir1_ct==1;
gen byte bir1_emp_su=0; replace bir1_emp_su=emp if bir1_ct_su==1;

gen byte bir6_ct=0; replace bir6_ct=1 if (temp2==yr & emp>0 & emp!=. & size==6); 
gen byte bir6_ct_su=0; replace bir6_ct_su=1 if (bir6_ct==1 & su==1);
gen byte bir6_emp=0; replace bir6_emp=emp if bir6_ct==1;
gen byte bir6_emp_su=0; replace bir6_emp_su=emp if bir6_ct_su==1;

gen byte bir21_ct=0; replace bir21_ct=1 if (temp2==yr & emp>0 & emp!=. & size==21); 
gen byte bir21_ct_su=0; replace bir21_ct_su=1 if (bir21_ct==1 & su==1);
gen byte bir21_emp=0; replace bir21_emp=emp if bir21_ct==1;
gen byte bir21_emp_su=0; replace bir21_emp_su=emp if bir21_ct_su==1;

gen byte bir101_ct=0; replace bir101_ct=1 if (temp2==yr & emp>0 & emp!=. & size==101); 
gen byte bir101_ct_su=0; replace bir101_ct_su=1 if (bir101_ct==1 & su==1);
gen byte bir101_emp=0; replace bir101_emp=emp if bir101_ct==1;
gen byte bir101_emp_su=0; replace bir101_emp_su=emp if bir101_ct_su==1;

gen byte dth_ct=0; replace dth_ct=1 if (temp3==yr); 
gen byte dth_ct_su=0; replace dth_ct_su=1 if (dth_ct==1 & su==1);
gen byte dth_emp=0; replace dth_emp=emp if dth_ct==1;
gen byte dth_emp_su=0; replace dth_emp_su=emp if dth_ct_su==1;

keep state cou yr tot* bir* dth*; 
collapse (sum) tot* bir* dth*, by(state cou yr) fast;
sort state cou yr;

*** Clean sample end years;
for var bir*: replace X=. if (yr==1976);
for var dth*: replace X=. if (yr==2005);

*** Save output file;
aorder; order state cou yr; sort state cou yr;
compress; memory; des; sum;
save ./st2/lbdc-bcd2-`S1'.dta, replace;
cap n erase ./st2/lbdc-bcd2-`S1'.dta.gz;
!gzip ./st2/lbdc-bcd2-`S1'.dta;
};

*** End of Program;
cap n log close;