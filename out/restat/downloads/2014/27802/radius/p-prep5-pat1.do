* William Kerr, TGG; 
* Pat Prep File for Agglomeration Work;
* Last Updated 11 June 2010;

#delimit;
cap n log close; log using p-prep5-pat1.log, replace;
clear; clear matrix; set memory 5g; set matsize 1000; set more off;

cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009;

***************************;
** PAT-ZIP Distribution  **;
***************************;

*** Open patent working file;
use patent ayear scat uspc ctryn assignee
    if ctryn=="US" 
    using ./svdata/p-work-pat_2009_short.dta, clear;
drop ctryn; compress; sum; sort patent; drop if patent==patent[_n-1];

*** Merge in zip codes, collapse, and add coordinates;
sort patent; merge patent using ./svdata/patent-zipcode1.dta, nok;
tab _m; tab ayear if _m!=3; keep if _m==3; drop _m; ren zipcode zip; 
gen ct=1; collapse (sum) ct, by(zip) fast;
sort zip; merge zip using ./lai/SASZip.dta, nok keep(lat lon);
tab _m; tab zip if _m==1, s(ct); keep if _m==3; drop _m;

*** Save output file;
sort zip; save ./svdata/citations_zip1_pat1, replace;

***************************;
** SCAT-ZIP Distribution **;
***************************;

*** Open patent working file;
use patent ayear scat uspc ctryn assignee
    if ctryn=="US" & scat!=.
    using ./svdata/p-work-pat_2009_short.dta, clear;
drop ctryn; compress; sum; sort patent; drop if patent==patent[_n-1];

*** Merge in zip codes, collapse, and add coordinates;
sort patent; merge patent using ./svdata/patent-zipcode1.dta, nok;
tab _m; tab ayear if _m!=3; keep if _m==3; drop _m; ren zipcode zip; 
gen ct=1; collapse (sum) ct, by(scat zip) fast;

*** Save output file;
sort scat zip; save ./svdata/citations_zip1_pat2, replace;

***************************;
** USPC-ZIP Distribution **;
***************************;

*** Open patent working file;
use patent ayear scat uspc ctryn assignee
    if ctryn=="US" & uspc!=.
    using ./svdata/p-work-pat_2009_short.dta, clear;
drop ctryn; compress; sum; sort patent; drop if patent==patent[_n-1];

*** Merge in zip codes, collapse, and add coordinates;
sort patent; merge patent using ./svdata/patent-zipcode1.dta, nok;
tab _m; tab ayear if _m!=3; keep if _m==3; drop _m; ren zipcode zip; 
gen ct=1; collapse (sum) ct, by(uspc zip) fast;

*** Save output file;
sort uspc zip; save ./svdata/citations_zip1_pat3, replace;

cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/cite-cite1/;

*** End of program;
log close; 