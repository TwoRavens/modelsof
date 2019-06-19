* William Kerr, TGG; 
* DO Random Counterfactuals;
* Last Updated 10 Feb 2010;

#delimit;
cap n log close; log using ./logdir/p-prep5-ran-do2g.log, replace;
clear; set memory 10g; set matsize 1000; set more off;

*************************************;
** Generate list of industry sizes **;
*************************************;

*** Open working file;
use patent ctryn ayear scat uspc
    if ctryn=="US" & (scat!=. & uspc!=.) & (ayear>=1990 & ayear<=1999)
    using ./svdata/p-work-pat_2009_short.dta, clear;
tab scat; keep patent scat; 
compress; sum; sort patent; drop if patent==patent[_n-1];
gen ct=1; collapse (sum) ct, by(scat) fast;
*replace ct=int(ct/1000)*1000;
sort scat; list; keep if (scat==23 | scat==24 | scat==39 | scat==49 | scat==59);
levelsof scat, local(scatindexg);

*********************************;
** Combine 1000 random draws   **;
*********************************;

foreach KKg of local scatindexg {;
  use patent ctryn ayear scat uspc
    if ctryn=="US" & (scat!=. & uspc!=.) & (ayear>=1990 & ayear<=1999) & scat==`KKg'
    using ./svdata/p-work-pat_2009_short.dta, clear;
  egen temp1=count(patent);
  levelsof temp1, local(ctindexg);
forvalues LLg=1(1)1000 {;
  use zip if [_n]<`ctindexg' using ./svdata-do/random1/do-patent-list-`LLg', clear;
  gen ct1=1; collapse (sum) ct1, by(zip) fast;
  save ./svdata-do/random1/do-temp1g, replace;
  ren zip zip2; ren ct1 ct2;
  cross using ./svdata-do/random1/do-temp1g.dta;
  erase ./svdata-do/random1/do-temp1g.dta;
  ren zip zip1;
  for num 1/2: ren zipX zip \ sort zip 
             \ merge zip using ./lai/SASZip.dta, nok keep(lat lon)
             \ keep if _m==3 \ drop _m
             \ ren lat latX \ ren lon lonX \ ren zip zipX;
  gen dist=3963.0*acos(sin(lat1/57.2958)*sin(lat2/57.2958)
         +cos(lat1/57.2958)*cos(lat2/57.2958)*cos(lon2/57.2958-lon1/57.2958));
  replace dist=0 if zip1==zip2;
  replace dist=int(dist);
  drop if dist==.;
  gen ct=ct1*ct2; keep dist ct; compress;
  collapse (sum) ct, by(dist) fast;
  compress; sort dist; 
  cap n erase ./svdata-do/random2/do-dist-cross-`KKg'-`LLg'.dta.gz;
  save ./svdata-do/random2/do-dist-cross-`KKg'-`LLg', replace;
  !gzip ./svdata-do/random2/do-dist-cross-`KKg'-`LLg'.dta;
};
};

*** End of program;
log close; 