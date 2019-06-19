#delimit;

gl coaggl
gl lbd10
gl census
gl cmf
gl data
gl programs

cap n log close; 
set more off;
chdir $coaggl/growth/cmf;
log using gr-returns-prep1.log, replace;

clear; clear matrix; set mem 3g; set matsize 10000;

* William Kerr;
* Growth Paper CMF File Prep;
* Last Modified: 30 July 2010;

use lbdnum cou st using $lbd10/data/lbd1997a;
drop if (st==. | cou==.); gen fips=st*1000+cou; keep lbdnum fips st;
sort lbdnum; save temp1-cou, replace;

!gunzip $census/census97-rnd2.dta;
use lbdnum tvs emp mu st 
    using $census/census97-rnd2, clear;
!gzip $census/census97-rnd2.dta;
drop if (st==.); sum; ren st zst;

sort lbdnum; merge lbdnum using temp1-cou;
tab _m; keep if _m==3; drop _m; cap n assert st==zst;

sum fips; sort fips; 
merge fips using $coaggl/jue/lbd/data/urb742, keep(pmsa cityname);
tab _m; list fips cityname if _m==2; keep if _m==3; drop _m; codebook pmsa;

gen tvs_su=tvs if mu==0;
gen emp_su=emp if mu==0;
collapse (sum) tvs* emp*, by(pmsa) fast;
gen return_su=tvs_su/emp_su;
gen return=tvs/emp;

keep pmsa return*;
sort pmsa; save pmsa-returns97, replace;

*** End of Program;
cap n log close;
