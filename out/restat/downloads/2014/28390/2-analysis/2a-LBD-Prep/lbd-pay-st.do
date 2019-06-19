#delimit;
cap n log close; log using /rdcprojects/br1/br00598/data/lbd10/lbd-pay-st.log, replace;

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

*** Screen pay variable for outliers;
* Billion dollars for establishment (GS hit $9bn as a company);
* Wages greater than $1m per employee (GS about $500k);
gen wage=pay/emp; sum wage, d; format pay emp wage %8.0f;
egen tempx=mean(pay), by(lbdnum);
egen tempz=mean(wage), by(lbdnum);
egen ctx=count(pay), by(lbdnum);
gen outlier1=1 if pay>1e6;
replace outlier1=1 if pay>1e5 & tempx<1e3; 
replace outlier1=1 if pay>1e5 & ctx<=2;
replace outlier1=1 if wage>1000 & wage!=.;
replace outlier1=1 if wage>1000 & ctx<=2;
replace outlier1=1 if wage>500 & tempz<10;
drop tempx tempz ctx;
egen outlier2=max(outlier1), by(lbdnum);
sort lbdnum yr;
cap n list lbdnum yr pay emp wage outlier1 if outlier2==1 & st==1;
drop wage;
replace pay=. if outlier1==1;
egen tempx=mean(pay), by(lbdnum);
replace pay=tempx if outlier1==1; replace pay=int(pay); 
gen wage=pay/emp; sum wage, d; format pay emp wage %8.0f;
sort lbdnum yr;
cap n list lbdnum yr pay emp wage outlier1 if outlier2==1 & st==1;
drop outlier* tempx;

*** Generate trimmed pay;
gen pay_tr=pay;
egen ttemp1=min(pay), by(lbdnum);
egen ttemp2=max(pay), by(lbdnum);
gen ttemp3=ttemp2/ttemp1;
egen ttemp4=pctile(ttemp3),p(98);
replace pay_tr=. if ttemp3>ttemp4 & ttemp3!=.;
gen emp_tr=emp if pay_tr!=.;
 
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
keep state cou su yr size emp wage pay pay_tr emp_tr temp2 temp3;

*** Disaggregate LBD;
gen tot_pay=0; replace tot_pay=pay;
gen tot_pay_su=0; replace tot_pay_su=pay if su==1;
gen tot_pay_tr=0; replace tot_pay_tr=pay_tr;
gen tot_pay_su_tr=0; replace tot_pay_su_tr=pay_tr if su==1;
gen tot_emp_tr=0; replace tot_emp_tr=emp_tr;
gen tot_emp_su_tr=0; replace tot_emp_su_tr=emp_tr if su==1;
gen bir_pay=0; replace bir_pay=pay if temp2==yr;
gen bir_pay_su=0; replace bir_pay_su=pay if (temp2==yr & su==1);
gen dth_pay=0; replace dth_pay=pay if (temp3==yr); 
gen dth_pay_su=0; replace dth_pay_su=pay if (temp3==yr & su==1);
gen tot1_pay=0; replace tot1_pay=pay if size==1; 
gen tot1_pay_su=0; replace tot1_pay_su=pay if (size==1 & su==1);
gen tot6_pay=0; replace tot6_pay=pay if size==6; 
gen tot6_pay_su=0; replace tot6_pay_su=pay if (size==6 & su==1);
gen tot21_pay=0; replace tot21_pay=pay if size==21; 
gen tot21_pay_su=0; replace tot21_pay_su=pay if (size==21 & su==1);
gen tot101_pay=0; replace tot101_pay=pay if size==101; 
gen tot101_pay_su=0; replace tot101_pay_su=pay if (size==101 & su==1);
gen wage_su=wage if su==1;
for var wage wage_su: gen X_p50=X;

keep state cou yr tot* bir* dth* wage* emp; 
collapse (rawsum) tot* bir* dth* emp
         (mean) wage wage_su
         (median) wage_p50 wage_su_p50 [aw=emp], by(state cou yr) fast;
sort state cou yr;

*** Clean sample end years;
for var bir*: replace X=. if (yr==1976);
for var dth*: replace X=. if (yr==2005);

*** Save output file;
aorder; order state cou yr; sort state cou yr;
compress; memory; des; sum;
save ./st2/lbdc-pay-`S1'.dta, replace;
cap n erase ./st2/lbdc-pay-`S1'.dta.gz;
!gzip ./st2/lbdc-pay-`S1'.dta;
};

*** End of Program;
cap n log close;