#delimit;
cap n log close; log using lbdc-bcd-services.log, replace;

* William Kerr;
* LBD County BCD Collapse;
* Last Modified: 5 June 2009;
* Closely follows Banking files;
* Extended to FULL data;

clear; set mem 5g; set matsize 8000; set more off;

*** Use raw LBD services1 panel;
cd /rdcprojects/br1/br00598/nanda/democentry/data;
!gunzip lbdc-raw2-services1-full.dta; 
clear; use lbdc-raw2-services1-full.dta;
!gzip lbdc-raw2-services1-full.dta;
compress; des; sum; ren county cou;
cd /rdcprojects/br1/br00598/programs/coaggl/jue/lbd/data;

*** Identify births and deaths;
* Does not consider closure and reopening;
sort lbdnum yr; cap n drop ct; gen byte ct=1;
gen temp1=yr if (emp>0 & emp!=.); 
egen temp2=min(temp1), by(lbdnum); tab temp2;
egen temp3=max(temp1), by(lbdnum); tab temp3;
count; count if temp2==temp3;

***Divide establishments by whether they survived more than 3 yrs or not;
* Note that since temp3=temp2 implies one year old firm, 3 or more years implies temp4>2;
gen temp4=temp3-temp2; tab temp4;
gen byte survive=0; replace survive=1 if temp4>2 & temp4!=.;

*** Save temp file;
compress;
sort lbdnum yr; 
save temp-rn-services1-dth.dta, replace;

**** Redefine Multiunit;
gen str10 firm=".";
replace firm=cfn if mu==0;
replace firm=substr(cfn,1,6)+"0000" if mu==1;
gen byte su=mu==0;

***Calculate SU & MU survival probabilites for 5 yr birth cohorts in late 70s/early 80s;
tab temp4 if temp2==yr & (yr>1976 & yr<1982) & su==1;
tab temp4 if temp2==yr & (yr>1976 & yr<1982) & mu==1;
tab temp4 if temp2==yr & (yr>1977 & yr<1983) & su==1;
tab temp4 if temp2==yr & (yr>1977 & yr<1983) & mu==1;
tab temp4 if temp2==yr & (yr>1978 & yr<1984) & su==1;
tab temp4 if temp2==yr & (yr>1978 & yr<1984) & mu==1;

*** Save temp file;
gen byte size=0;
replace size=1 if emp>0 & emp<=5;
replace size=6 if emp>5 & emp<=20;
replace size=21 if emp>20 & emp<=100;
replace size=101 if emp>100 & emp!=.;
tab size; drop if size==0;
keep state cou sic3 yr size emp su temp2 temp3 survive;
compress; save temp-rn-services1-dth.dta, replace;

*** Disaggregate LBD into Birth-Death 0;
use temp-rn-services1-dth.dta, clear;

gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte tot_ct_su=0; replace tot_ct_su=1 if (tot_ct==1 & su==1);
gen byte tot_emp=0; replace tot_emp=emp if tot_ct==1;
gen byte tot_emp_su=0; replace tot_emp_su=emp if tot_ct_su==1;

gen byte bir_ct=0; replace bir_ct=1 if (temp2==yr & emp>0 & emp!=.); 
gen byte bir_ct_su=0; replace bir_ct_su=1 if (bir_ct==1 & su==1);
gen byte bir_emp=0; replace bir_emp=emp if bir_ct==1;
gen byte bir_emp_su=0; replace bir_emp_su=emp if bir_ct_su==1;

keep state cou sic3 yr tot* bir*; 
for any tot bir: renpfix X X0; compress;
collapse (sum) tot* bir*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services1-bir0a.dta, replace;

use temp-rn-services1-dth.dta, clear;

gen byte srv_ct=0; replace srv_ct=1 if (temp2==yr & emp>0 & emp!=. & survive==1); 
gen byte srv_ct_su=0; replace srv_ct_su=1 if (srv_ct==1 & su==1);
gen byte srv_emp=0; replace srv_emp=emp if srv_ct==1;
gen byte srv_emp_su=0; replace srv_emp_su=emp if srv_ct_su==1;

gen byte dth_ct=0; replace dth_ct=1 if (temp3==yr); 
gen byte dth_ct_su=0; replace dth_ct_su=1 if (dth_ct==1 & su==1);
gen byte dth_emp=0; replace dth_emp=emp if dth_ct==1;
gen byte dth_emp_su=0; replace dth_emp_su=emp if dth_ct_su==1;

keep state cou sic3 yr srv* dth*; 
for any srv dth: renpfix X X0;
collapse (sum) srv* dth*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services1-bir0b.dta, replace;

*** Disaggregate LBD into Birth-Death 1;
use temp-rn-services1-dth.dta, clear;
keep if size==1;

gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte tot_ct_su=0; replace tot_ct_su=1 if (tot_ct==1 & su==1);
gen byte tot_emp=0; replace tot_emp=emp if tot_ct==1;
gen byte tot_emp_su=0; replace tot_emp_su=emp if tot_ct_su==1;

gen byte bir_ct=0; replace bir_ct=1 if (temp2==yr & emp>0 & emp!=.); 
gen byte bir_ct_su=0; replace bir_ct_su=1 if (bir_ct==1 & su==1);
gen byte bir_emp=0; replace bir_emp=emp if bir_ct==1;
gen byte bir_emp_su=0; replace bir_emp_su=emp if bir_ct_su==1;

keep state cou sic3 yr tot* bir*; 
for any tot bir: renpfix X X1;
collapse (sum) tot* bir*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services1-bir1a.dta, replace;

use temp-rn-services1-dth.dta, clear;
keep if size==1;

gen byte srv_ct=0; replace srv_ct=1 if (temp2==yr & emp>0 & emp!=. & survive==1); 
gen byte srv_ct_su=0; replace srv_ct_su=1 if (srv_ct==1 & su==1);
gen byte srv_emp=0; replace srv_emp=emp if srv_ct==1;
gen byte srv_emp_su=0; replace srv_emp_su=emp if srv_ct_su==1;

gen byte dth_ct=0; replace dth_ct=1 if (temp3==yr); 
gen byte dth_ct_su=0; replace dth_ct_su=1 if (dth_ct==1 & su==1);
gen byte dth_emp=0; replace dth_emp=emp if dth_ct==1;
gen byte dth_emp_su=0; replace dth_emp_su=emp if dth_ct_su==1;

keep state cou sic3 yr srv* dth*; 
for any srv dth: renpfix X X1;
collapse (sum) srv* dth*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services1-bir1b.dta, replace;

*** Disaggregate LBD into Birth-Death 6;
use temp-rn-services1-dth.dta, clear;
keep if size==6;

gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte tot_ct_su=0; replace tot_ct_su=1 if (tot_ct==1 & su==1);
gen byte tot_emp=0; replace tot_emp=emp if tot_ct==1;
gen byte tot_emp_su=0; replace tot_emp_su=emp if tot_ct_su==1;

gen byte bir_ct=0; replace bir_ct=1 if (temp2==yr & emp>0 & emp!=.); 
gen byte bir_ct_su=0; replace bir_ct_su=1 if (bir_ct==1 & su==1);
gen byte bir_emp=0; replace bir_emp=emp if bir_ct==1;
gen byte bir_emp_su=0; replace bir_emp_su=emp if bir_ct_su==1;

keep state cou sic3 yr tot* bir*; 
for any tot bir: renpfix X X6;
collapse (sum) tot* bir*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services1-bir6a.dta, replace;

use temp-rn-services1-dth.dta, clear;
keep if size==6;

gen byte srv_ct=0; replace srv_ct=1 if (temp2==yr & emp>0 & emp!=. & survive==1); 
gen byte srv_ct_su=0; replace srv_ct_su=1 if (srv_ct==1 & su==1);
gen byte srv_emp=0; replace srv_emp=emp if srv_ct==1;
gen byte srv_emp_su=0; replace srv_emp_su=emp if srv_ct_su==1;

gen byte dth_ct=0; replace dth_ct=1 if (temp3==yr); 
gen byte dth_ct_su=0; replace dth_ct_su=1 if (dth_ct==1 & su==1);
gen byte dth_emp=0; replace dth_emp=emp if dth_ct==1;
gen byte dth_emp_su=0; replace dth_emp_su=emp if dth_ct_su==1;

keep state cou sic3 yr srv* dth*; 
for any srv dth: renpfix X X6;
collapse (sum) srv* dth*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services1-bir6b.dta, replace;

*** Disaggregate LBD into Birth-Death 21;
use temp-rn-services1-dth.dta, clear;
keep if size==21;

gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte tot_ct_su=0; replace tot_ct_su=1 if (tot_ct==1 & su==1);
gen byte tot_emp=0; replace tot_emp=emp if tot_ct==1;
gen byte tot_emp_su=0; replace tot_emp_su=emp if tot_ct_su==1;

gen byte bir_ct=0; replace bir_ct=1 if (temp2==yr & emp>0 & emp!=.); 
gen byte bir_ct_su=0; replace bir_ct_su=1 if (bir_ct==1 & su==1);
gen byte bir_emp=0; replace bir_emp=emp if bir_ct==1;
gen byte bir_emp_su=0; replace bir_emp_su=emp if bir_ct_su==1;

gen byte srv_ct=0; replace srv_ct=1 if (bir_ct==1 & survive==1); 
gen byte srv_ct_su=0; replace srv_ct_su=1 if (srv_ct==1 & su==1);
gen byte srv_emp=0; replace srv_emp=emp if srv_ct==1;
gen byte srv_emp_su=0; replace srv_emp_su=emp if srv_ct_su==1;

gen byte dth_ct=0; replace dth_ct=1 if (temp3==yr); 
gen byte dth_ct_su=0; replace dth_ct_su=1 if (dth_ct==1 & su==1);
gen byte dth_emp=0; replace dth_emp=emp if dth_ct==1;
gen byte dth_emp_su=0; replace dth_emp_su=emp if dth_ct_su==1;

keep state cou sic3 yr tot* bir* srv* dth*; 
for any tot bir srv dth: renpfix X X21;
collapse (sum) tot* bir* srv* dth*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services1-bir21.dta, replace;

*** Disaggregate LBD into Birth-Death 101;
use temp-rn-services1-dth.dta, clear;
keep if size==101;

gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte tot_ct_su=0; replace tot_ct_su=1 if (tot_ct==1 & su==1);
gen byte tot_emp=0; replace tot_emp=emp if tot_ct==1;
gen byte tot_emp_su=0; replace tot_emp_su=emp if tot_ct_su==1;

gen byte bir_ct=0; replace bir_ct=1 if (temp2==yr & emp>0 & emp!=.); 
gen byte bir_ct_su=0; replace bir_ct_su=1 if (bir_ct==1 & su==1);
gen byte bir_emp=0; replace bir_emp=emp if bir_ct==1;
gen byte bir_emp_su=0; replace bir_emp_su=emp if bir_ct_su==1;

gen byte srv_ct=0; replace srv_ct=1 if (bir_ct==1 & survive==1); 
gen byte srv_ct_su=0; replace srv_ct_su=1 if (srv_ct==1 & su==1);
gen byte srv_emp=0; replace srv_emp=emp if srv_ct==1;
gen byte srv_emp_su=0; replace srv_emp_su=emp if srv_ct_su==1;

gen byte dth_ct=0; replace dth_ct=1 if (temp3==yr); 
gen byte dth_ct_su=0; replace dth_ct_su=1 if (dth_ct==1 & su==1);
gen byte dth_emp=0; replace dth_emp=emp if dth_ct==1;
gen byte dth_emp_su=0; replace dth_emp_su=emp if dth_ct_su==1;

keep state cou sic3 yr tot* bir* srv* dth*; 
for any tot bir srv dth: renpfix X X101;
collapse (sum) tot* bir* srv* dth*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services1-bir101.dta, replace;

*** Combine Files;
use temp-rn-services1-bir0a.dta;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services1-bir0b; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services1-bir1a; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services1-bir1b; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services1-bir6a; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services1-bir6b; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services1-bir21; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services1-bir101; tab _m; drop _m;
sort state cou sic3 yr; compress;

*** Clean sample end years;
for var bir* srv*: replace X=. if (yr==1976);
for var srv*: replace X=. if (yr>=1999);
for var dth*: replace X=. if (yr>=2001);

*** gen MU variables;
for any tot0 tot1 tot6 tot21 tot101
        bir0 bir1 bir6 bir21 bir101
        srv0 srv1 srv6 srv21 srv101
        dth0 dth1 dth6 dth21 dth101:
\ gen X_ct_mu=X_ct-X_ct_su
\ gen X_emp_mu=X_emp-X_emp_su;

*** Generate churning variables;
for any 0 1 6 21 101: 
\ gen chnX_ct=birX_ct-srvX_ct
\ gen chnX_emp=birX_emp-srvX_emp
\ gen chnX_ct_su=birX_ct_su-srvX_ct_su
\ gen chnX_emp_su=birX_emp_su-srvX_emp_su
\ gen chnX_ct_mu=birX_ct_mu-srvX_ct_mu
\ gen chnX_emp_mu=birX_emp_mu-srvX_emp_mu;

aorder; order state cou sic3 yr; sort state cou sic3 yr;
save lbdc-bcd-services1.dta, replace;

** Use raw LBD services2 panel;
cd /rdcprojects/br1/br00598/nanda/democentry/data;
!gunzip lbdc-raw2-services2-full.dta; 
clear; use lbdc-raw2-services2-full.dta;
!gzip lbdc-raw2-services2-full.dta;
compress; des; sum; ren county cou;
cd /rdcprojects/br1/br00598/programs/coaggl/jue/lbd/data;
 
*** Identify births and deaths;
* Does not consider closure and reopening;
sort lbdnum yr; cap n drop ct; gen byte ct=1;
gen temp1=yr if (emp>0 & emp!=.); 
egen temp2=min(temp1), by(lbdnum); tab temp2;
egen temp3=max(temp1), by(lbdnum); tab temp3;
count; count if temp2==temp3;

***Divide establishments by whether they survived more than 3 yrs or not;
* Note that since temp3=temp2 implies one year old firm, 3 or more years implies temp4>2;
gen temp4=temp3-temp2; tab temp4;
gen byte survive=0; replace survive=1 if temp4>2 & temp4!=.;

*** Save temp file;
compress;
sort lbdnum yr; 
save temp-rn-services2-dth.dta, replace;

**** Redefine Multiunit;
gen str10 firm=".";
replace firm=cfn if mu==0;
replace firm=substr(cfn,1,6)+"0000" if mu==1;
gen byte su=mu==0;

***Calculate SU & MU survival probabilites for 5 yr birth cohorts in late 70s/early 80s;
tab temp4 if temp2==yr & (yr>1976 & yr<1982) & su==1;
tab temp4 if temp2==yr & (yr>1976 & yr<1982) & mu==1;
tab temp4 if temp2==yr & (yr>1977 & yr<1983) & su==1;
tab temp4 if temp2==yr & (yr>1977 & yr<1983) & mu==1;
tab temp4 if temp2==yr & (yr>1978 & yr<1984) & su==1;
tab temp4 if temp2==yr & (yr>1978 & yr<1984) & mu==1;

*** Save temp file;
gen byte size=0;
replace size=1 if emp>0 & emp<=5;
replace size=6 if emp>5 & emp<=20;
replace size=21 if emp>20 & emp<=100;
replace size=101 if emp>100 & emp!=.;
tab size;
keep state cou sic3 yr size emp su temp2 temp3 survive;
compress; save temp-rn-services2-dth.dta, replace;

*** Disaggregate LBD into Birth-Death 0;
use temp-rn-services2-dth.dta, clear;

gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte tot_ct_su=0; replace tot_ct_su=1 if (tot_ct==1 & su==1);
gen byte tot_emp=0; replace tot_emp=emp if tot_ct==1;
gen byte tot_emp_su=0; replace tot_emp_su=emp if tot_ct_su==1;

gen byte bir_ct=0; replace bir_ct=1 if (temp2==yr & emp>0 & emp!=.); 
gen byte bir_ct_su=0; replace bir_ct_su=1 if (bir_ct==1 & su==1);
gen byte bir_emp=0; replace bir_emp=emp if bir_ct==1;
gen byte bir_emp_su=0; replace bir_emp_su=emp if bir_ct_su==1;

keep state cou sic3 yr tot* bir*; 
for any tot bir: renpfix X X0; compress;
collapse (sum) tot* bir*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services2-bir0a.dta, replace;

use temp-rn-services2-dth.dta, clear;

gen byte srv_ct=0; replace srv_ct=1 if (temp2==yr & emp>0 & emp!=. & survive==1); 
gen byte srv_ct_su=0; replace srv_ct_su=1 if (srv_ct==1 & su==1);
gen byte srv_emp=0; replace srv_emp=emp if srv_ct==1;
gen byte srv_emp_su=0; replace srv_emp_su=emp if srv_ct_su==1;

gen byte dth_ct=0; replace dth_ct=1 if (temp3==yr); 
gen byte dth_ct_su=0; replace dth_ct_su=1 if (dth_ct==1 & su==1);
gen byte dth_emp=0; replace dth_emp=emp if dth_ct==1;
gen byte dth_emp_su=0; replace dth_emp_su=emp if dth_ct_su==1;

keep state cou sic3 yr srv* dth*; 
for any srv dth: renpfix X X0;
collapse (sum) srv* dth*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services2-bir0b.dta, replace;

*** Disaggregate LBD into Birth-Death 1;
use temp-rn-services2-dth.dta, clear;
keep if size==1;

gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte tot_ct_su=0; replace tot_ct_su=1 if (tot_ct==1 & su==1);
gen byte tot_emp=0; replace tot_emp=emp if tot_ct==1;
gen byte tot_emp_su=0; replace tot_emp_su=emp if tot_ct_su==1;

gen byte bir_ct=0; replace bir_ct=1 if (temp2==yr & emp>0 & emp!=.); 
gen byte bir_ct_su=0; replace bir_ct_su=1 if (bir_ct==1 & su==1);
gen byte bir_emp=0; replace bir_emp=emp if bir_ct==1;
gen byte bir_emp_su=0; replace bir_emp_su=emp if bir_ct_su==1;

keep state cou sic3 yr tot* bir*; 
for any tot bir: renpfix X X1;
collapse (sum) tot* bir*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services2-bir1a.dta, replace;

use temp-rn-services2-dth.dta, clear;
keep if size==1;

gen byte srv_ct=0; replace srv_ct=1 if (temp2==yr & emp>0 & emp!=. & survive==1); 
gen byte srv_ct_su=0; replace srv_ct_su=1 if (srv_ct==1 & su==1);
gen byte srv_emp=0; replace srv_emp=emp if srv_ct==1;
gen byte srv_emp_su=0; replace srv_emp_su=emp if srv_ct_su==1;

gen byte dth_ct=0; replace dth_ct=1 if (temp3==yr); 
gen byte dth_ct_su=0; replace dth_ct_su=1 if (dth_ct==1 & su==1);
gen byte dth_emp=0; replace dth_emp=emp if dth_ct==1;
gen byte dth_emp_su=0; replace dth_emp_su=emp if dth_ct_su==1;

keep state cou sic3 yr srv* dth*; 
for any srv dth: renpfix X X1;
collapse (sum) srv* dth*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services2-bir1b.dta, replace;

*** Disaggregate LBD into Birth-Death 6;
use temp-rn-services2-dth.dta, clear;
keep if size==6;

gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte tot_ct_su=0; replace tot_ct_su=1 if (tot_ct==1 & su==1);
gen byte tot_emp=0; replace tot_emp=emp if tot_ct==1;
gen byte tot_emp_su=0; replace tot_emp_su=emp if tot_ct_su==1;

gen byte bir_ct=0; replace bir_ct=1 if (temp2==yr & emp>0 & emp!=.); 
gen byte bir_ct_su=0; replace bir_ct_su=1 if (bir_ct==1 & su==1);
gen byte bir_emp=0; replace bir_emp=emp if bir_ct==1;
gen byte bir_emp_su=0; replace bir_emp_su=emp if bir_ct_su==1;

keep state cou sic3 yr tot* bir*; 
for any tot bir: renpfix X X6;
collapse (sum) tot* bir*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services2-bir6a.dta, replace;

use temp-rn-services2-dth.dta, clear;
keep if size==6;

gen byte srv_ct=0; replace srv_ct=1 if (temp2==yr & emp>0 & emp!=. & survive==1); 
gen byte srv_ct_su=0; replace srv_ct_su=1 if (srv_ct==1 & su==1);
gen byte srv_emp=0; replace srv_emp=emp if srv_ct==1;
gen byte srv_emp_su=0; replace srv_emp_su=emp if srv_ct_su==1;

gen byte dth_ct=0; replace dth_ct=1 if (temp3==yr); 
gen byte dth_ct_su=0; replace dth_ct_su=1 if (dth_ct==1 & su==1);
gen byte dth_emp=0; replace dth_emp=emp if dth_ct==1;
gen byte dth_emp_su=0; replace dth_emp_su=emp if dth_ct_su==1;

keep state cou sic3 yr srv* dth*; 
for any srv dth: renpfix X X6;
collapse (sum) srv* dth*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services2-bir6b.dta, replace;

*** Disaggregate LBD into Birth-Death 21;
use temp-rn-services2-dth.dta, clear;
keep if size==21;

gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte tot_ct_su=0; replace tot_ct_su=1 if (tot_ct==1 & su==1);
gen byte tot_emp=0; replace tot_emp=emp if tot_ct==1;
gen byte tot_emp_su=0; replace tot_emp_su=emp if tot_ct_su==1;

gen byte bir_ct=0; replace bir_ct=1 if (temp2==yr & emp>0 & emp!=.); 
gen byte bir_ct_su=0; replace bir_ct_su=1 if (bir_ct==1 & su==1);
gen byte bir_emp=0; replace bir_emp=emp if bir_ct==1;
gen byte bir_emp_su=0; replace bir_emp_su=emp if bir_ct_su==1;

gen byte srv_ct=0; replace srv_ct=1 if (bir_ct==1 & survive==1); 
gen byte srv_ct_su=0; replace srv_ct_su=1 if (srv_ct==1 & su==1);
gen byte srv_emp=0; replace srv_emp=emp if srv_ct==1;
gen byte srv_emp_su=0; replace srv_emp_su=emp if srv_ct_su==1;

gen byte dth_ct=0; replace dth_ct=1 if (temp3==yr); 
gen byte dth_ct_su=0; replace dth_ct_su=1 if (dth_ct==1 & su==1);
gen byte dth_emp=0; replace dth_emp=emp if dth_ct==1;
gen byte dth_emp_su=0; replace dth_emp_su=emp if dth_ct_su==1;

keep state cou sic3 yr tot* bir* srv* dth*; 
for any tot bir srv dth: renpfix X X21;
collapse (sum) tot* bir* srv* dth*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services2-bir21.dta, replace;

*** Disaggregate LBD into Birth-Death 101;
use temp-rn-services2-dth.dta, clear;
keep if size==101;

gen byte tot_ct=0; replace tot_ct=1 if (emp>0 & emp!=.); 
gen byte tot_ct_su=0; replace tot_ct_su=1 if (tot_ct==1 & su==1);
gen byte tot_emp=0; replace tot_emp=emp if tot_ct==1;
gen byte tot_emp_su=0; replace tot_emp_su=emp if tot_ct_su==1;

gen byte bir_ct=0; replace bir_ct=1 if (temp2==yr & emp>0 & emp!=.); 
gen byte bir_ct_su=0; replace bir_ct_su=1 if (bir_ct==1 & su==1);
gen byte bir_emp=0; replace bir_emp=emp if bir_ct==1;
gen byte bir_emp_su=0; replace bir_emp_su=emp if bir_ct_su==1;

gen byte srv_ct=0; replace srv_ct=1 if (bir_ct==1 & survive==1); 
gen byte srv_ct_su=0; replace srv_ct_su=1 if (srv_ct==1 & su==1);
gen byte srv_emp=0; replace srv_emp=emp if srv_ct==1;
gen byte srv_emp_su=0; replace srv_emp_su=emp if srv_ct_su==1;

gen byte dth_ct=0; replace dth_ct=1 if (temp3==yr); 
gen byte dth_ct_su=0; replace dth_ct_su=1 if (dth_ct==1 & su==1);
gen byte dth_emp=0; replace dth_emp=emp if dth_ct==1;
gen byte dth_emp_su=0; replace dth_emp_su=emp if dth_ct_su==1;

keep state cou sic3 yr tot* bir* srv* dth*; 
for any tot bir srv dth: renpfix X X101;
collapse (sum) tot* bir* srv* dth*, by(state cou sic3 yr) fast;
sort state cou sic3 yr; save temp-rn-services2-bir101.dta, replace;

*** Combine Files;
use temp-rn-services2-bir0a.dta;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services2-bir0b; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services2-bir1a; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services2-bir1b; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services2-bir6a; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services2-bir6b; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services2-bir21; tab _m; drop _m;
sort state cou sic3 yr; merge state cou sic3 yr using temp-rn-services2-bir101; tab _m; drop _m;
sort state cou sic3 yr; compress;

*** Clean sample end years;
for var bir* srv*: replace X=. if (yr==1976);
for var srv*: replace X=. if (yr>=1999);
for var dth*: replace X=. if (yr>=2001);

*** gen MU variables;
for any tot0 tot1 tot6 tot21 tot101
        bir0 bir1 bir6 bir21 bir101
        srv0 srv1 srv6 srv21 srv101
        dth0 dth1 dth6 dth21 dth101:
\ gen X_ct_mu=X_ct-X_ct_su
\ gen X_emp_mu=X_emp-X_emp_su;

*** Generate churning variables;
for any 0 1 6 21 101: 
\ gen chnX_ct=birX_ct-srvX_ct
\ gen chnX_emp=birX_emp-srvX_emp
\ gen chnX_ct_su=birX_ct_su-srvX_ct_su
\ gen chnX_emp_su=birX_emp_su-srvX_emp_su
\ gen chnX_ct_mu=birX_ct_mu-srvX_ct_mu
\ gen chnX_emp_mu=birX_emp_mu-srvX_emp_mu;

aorder; order state cou sic3 yr; sort state cou sic3 yr;
save lbdc-bcd-services2.dta, replace;
append using lbdc-bcd-services1.dta; 

*** Save output file;
aorder; order state cou sic3 yr; sort state cou sic3 yr;
compress; memory; des; 
sum; sum if (yr>1976 & yr<2001);
cap n erase lbdc-bcd-cou-services.dta.gz;
save lbdc-bcd-cou-services.dta, replace;
!gzip lbdc-bcd-cou-services.dta;
for var _all: cap n tab yr, s(X);

*** Erase temp files;
cap n erase temp-rn-services1-dth.dta;
cap n erase temp-rn-services2-dth.dta;
cap n erase lbdc-bcd-services1.dta;
cap n erase lbdc-bcd-services2.dta;

for any 0a 0b 1a 1b 6a 6b 21 101: 
\ cap n erase temp-rn-services1-birX.dta
\ cap n erase temp-rn-services2-birX.dta;
cd ../files;

*** End of Program;
cap n log close;
