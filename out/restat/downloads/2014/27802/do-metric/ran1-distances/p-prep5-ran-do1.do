* William Kerr, TGG; 
* DO Random Counterfactuals;
* Last Updated 25 Nov 2009;

#delimit;
cap n log close; log using ./logdir/p-prep5-ran-do1.log, replace;
clear; set memory 5g; set matsize 1000; set more off;

*********************************;
** Generate working file       **;
*********************************;

*** Open working file;
use patent ctryn ayear scat uspc
    if ctryn=="US" & (scat!=. & uspc!=.) & (ayear>=1990 & ayear<=1999)
    using ./svdata/p-work-pat_2009_short.dta, clear;
tab scat; keep patent ayear; 
compress; sum; sort patent; drop if patent==patent[_n-1];

*** Merge in zip codes and collapse to scat-zip;
sort patent; merge patent using ./svdata/patent-zipcode1.dta, nok;
tab _m; tab ayear if _m!=3; keep if _m==3; drop _m ayear; ren zipcode zip; 
sort patent; save ./svdata-do/random1/do-patent-list-raw, replace;

*********************************;
** Calculate 1000 random draws **;
*********************************;

forvalue JJ=1(1)1000 {;
  use ./svdata-do/random1/do-patent-list-raw, clear;
  set seed `JJ'; gen temp1=runiform(); 
  sort temp1; keep if [_n]<=66253; keep patent zip; compress;
  sort patent; save ./svdata-do/random1/do-patent-list-`JJ', replace;
};

*** End of program;
log close; 