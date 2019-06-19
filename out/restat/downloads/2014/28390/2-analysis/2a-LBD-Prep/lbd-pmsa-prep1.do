#delimit;
cap n log close; 
set more off;
chdir /rdcprojects/br1/br00598/programs/coaggl/growth/cmf;
log using lbd-pmsa-prep1.log, replace;

clear; clear matrix; set mem 1g; set matsize 10000;

* William Kerr, TGG;
* Growth Paper LBD Mining File Prep;
* Last Modified: 25 June 2010;

***********************************************************;
*** Prepare LBD Mining Data File by County               **;
***********************************************************;

*** Open mining data file;
chdir /rdcprojects/br1/br00598/programs/coaggl/jue/lbd/files;
!gunzip ../data/lbdc-bcd-cou-mining.dta;
use ../data/lbdc-bcd-cou-mining.dta, clear;
!gzip ../data/lbdc-bcd-cou-mining.dta;
chdir /rdcprojects/br1/br00598/programs/coaggl/growth/cmf;
ren state st; sum; 
keep st cou sic3 yr tot0_emp tot0_emp* tot0_ct tot101_emp;

*** Collapse on SIC3 and county;
drop if (st==3 | st==7 | st==14 | st==43 | st==52 | st>=57);
tab st; drop if (st==. | cou==. | sic3==. | yr==.);
gen fips=st*1000+cou; sum fips; 
collapse (sum) tot* (mean) st, by(fips sic3 yr) fast;
sort fips sic3 yr; 
save lbd_mining1.dta, replace;
table yr sic3, c(sum tot0_emp) row col;
table yr sic3, c(sum tot0_ct) row col;
table yr st, c(sum tot0_emp) row col;
table yr st if int(sic3/10)==10, c(sum tot0_emp) row col;
table yr st if int(sic3/10)==12, c(sum tot0_emp) row col;
drop st;

*** Collapse on single county records;
for var t*:
\ gen IX=X if sic3==101
\ gen MX=X if int(sic3/10)==10
\ gen CX=X if int(sic3/10)==12
\ gen TX=X if int(sic3/10)==10 | int(sic3/10)==12;
for any I M C T: renpfix Xtot X;
keep if (yr>=1976 & yr<=1980);
collapse (sum) I* M* C* T*, by(fips) fast;
drop if fips==.; sort fips; save lbd_mining2, replace; sum;

***********************************************************;
*** Create Centroid County for Each PMSA                 **;
***********************************************************;

use /rdcprojects/br1/br00598/programs/coaggl/jue/lbd/data/scratch-jue-lbd-pmsa-prep0, clear;
drop if (st==. | cou==.); tab st; gen fips=st*1000+cou; sum fips; sort fips; 
merge fips using /rdcprojects/br1/br00598/programs/coaggl/jue/lbd/data/urb742, keep(pmsa cityname);
tab _m; list fips cityname if _m==2; keep if _m==3; drop _m; codebook pmsa;
collapse (sum) tot0_emp, by(pmsa cityname fips) fast;
gsort pmsa -tot0_emp; list; drop if pmsa==pmsa[_n-1];
sort pmsa; save lbd_pmsa_fips_center, replace; list;

***********************************************************;
*** Merge distance grids and collapse mining bands       **;
***********************************************************;

*** Merge datasets;
use lbd_pmsa_fips_center, clear;
ren fips fipsa; sort fipsa; merge fipsa using cou-dist; 
tab _m; drop if _m==2; drop _m; codebook pmsa; drop fipsa;
ren fipsb fips; sort fips; merge fips using lbd_mining2;
tab _m; tab fips if _m==2, s(T0_emp); drop if _m==2; drop _m fips; codebook pmsa;

*** Collapse on bands around city;
drop if dist>1000;
for var I* M* C* T*: 
\ gen X_50=X if dist<=50
\ gen X_100=X if dist<=100
\ gen X_250=X if dist<=250
\ gen X_500=X if dist<=500
\ gen X_750=X if dist<=750
\ gen X_999=X if dist<=1000;
for any I M C T: drop X0_ct X0_emp X0_emp_mu X0_emp_su X101_emp;
collapse (sum) I* M* C* T*, by(pmsa cityname) fast;
sort pmsa; save lbd_mining3, replace; sum;

*** List examples;
for var I* M* C* T*:
\ gsort X \ list cityname X in 1/10
\ gsort -X \ list cityname X in 1/10;

*** End of Program;
cap n log close;

***********************************************************;
***********************************************************;
*** SAVED MATERIALS                                      **;
***********************************************************;
***********************************************************;