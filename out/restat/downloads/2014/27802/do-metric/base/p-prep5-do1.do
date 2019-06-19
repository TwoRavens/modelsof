* William Kerr, TGG; 
* Pat Prep File for Agglomeration Work;
* Generate distance file between zip codes in same SCAT for DO calculations;
* Last Updated 12 Nov 2009;

#delimit;
cap n log close; log using ./logdir/p-prep5-do1.log, replace;
clear; set memory 10g; set matsize 1000; set more off;

*********************************;
** Generate scat-zip collapse  **;
*********************************;

*** Open working file;
use patent ayear scat uspc ctryn assignee
    if ctryn=="US" & (scat!=. & uspc!=.) & (ayear>=1990 & ayear<=1999)
    using ./svdata/p-work-pat_2009_short.dta, clear;
drop ctryn; compress; sum; sort patent; drop if patent==patent[_n-1];

*** Merge in zip codes and collapse to scat-zip;
sort patent; merge patent using ./svdata/patent-zipcode1.dta, nok;
tab _m; tab ayear if _m!=3; keep if _m==3; drop _m; ren zipcode zip; 
gen ct=1; collapse (sum) ct, by(scat zip) fast;

*** Merge in zip code coordinates and save working file;
sort zip; merge zip using ./lai/SASZip.dta, nok keep(lat lon);
tab _m; tab zip if _m==1, s(ct); keep if _m==3; drop _m;
sort scat zip; save ./svdata-do/do-scat-zip-1, replace; tab scat;

*********************************;
** Calculate raw distances     **;
*********************************;

use ./svdata-do/do-scat-zip-1, clear;
*keep if scat>=19;

levelsof scat, local(ind);
foreach X of local ind {;
  use if scat==`X' using ./svdata-do/do-scat-zip-1, clear;
  save ./svdata-do/scat-temp1, replace;
  for var scat zip ct lat lon: ren X X1;
  cross using ./svdata-do/scat-temp1;
  for var zip ct lat lon: ren X X2; drop scat;
  erase ./svdata-do/scat-temp1.dta;
  gen dist=3963.0*acos(sin(lat1/57.2958)*sin(lat2/57.2958)
         +cos(lat1/57.2958)*cos(lat2/57.2958)*cos(lon2/57.2958-lon1/57.2958));
  replace dist=0 if zip1==zip2;
  replace dist=int(dist);
  gen ct=ct1*ct2;
  keep dist ct;
  collapse (sum) ct, by(dist) fast;
  gen scat=`X'; sort dist; sum;
  save ./svdata-do/do-scat-zip-2-`X', replace;
};

*** End of program;
log close; 