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
log using gr-aggl-prep1.log, replace;

clear; clear matrix; set mem 3g; set matsize 10000;

* William Kerr;
* Growth Paper CMF File Prep;
* Based on do-lbdcf-cou-prep4d3a;
* Last Modified: 29 July 2010;

use $programs/aggl/working/lbdcf-bcd-sic3-7601-kd-final/do-lloc-3.dta, clear;
keep sic3 dist yr GC_*;
des; sum; for var GC_*: tab dist, s(X) \ tab sic3, s(X);
keep if yr==1977; keep if dist==500;
keep sic3 GC_emp; 
for num 33 66: egen tempX=pctile(GC), p(X);
gen aggl=1;
replace aggl=2 if GC>temp33 & GC<=temp66;
replace aggl=3 if GC>temp66 & GC!=.; tab aggl;
sort sic3; save sic3-aggl, replace; drop aggl;
gen sic2=int(sic3/10);
collapse (mean) GC_emp, by(sic2) fast;
for num 33 66: egen tempX=pctile(GC), p(X);
gen aggl=1;
replace aggl=2 if GC>temp33 & GC<=temp66;
replace aggl=3 if GC>temp66 & GC!=.;
sort sic2; save sic2-aggl, replace;

*** End of Program;
cap n log close;
