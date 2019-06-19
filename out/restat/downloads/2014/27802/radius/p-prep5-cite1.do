* William Kerr, TGG; 
* Cite Prep File for Agglomeration Work;
* Last Updated 13 Nov 2009;

#delimit;
cap n log close; log using ./logdir/p-prep5-cite1.log, replace;
clear; set memory 5g; set matsize 1000; set more off;

*** Patent working file;
use patent ayear scat uspc ctryn assignee
    if ctryn=="US" 
    using ./svdata/p-work-pat_2009_short.dta, clear;
drop ctryn; compress; sum; sort patent; drop if patent==patent[_n-1];
save ./svdata/p-work-pat_2009_short-temp.dta, replace;

*** Base inventor file - extract lead zip code;
use patent invseq zipcode
    if zipcode!=0 & zipcode!=.
    using ./svdata/inventors_2009_clean.dta, clear;
sum; gen ict=1; 
collapse (sum) ict (min) invseq, by(patent zipcode) fast;
gsort patent -ict invseq; list in 1/50;
count; count if patent==patent[_n-1]; count if patent==patent[_n-1] & zip!=zip[_n-1];
drop if patent==patent[_n-1]; list in 1/50;
keep patent zipcode; sort patent;
save ./svdata/patent-zipcode1, replace;

*** Citations working file;
!gunzip ./rawdata/citations.dta;
use patent citation cit_type using ./rawdata/citations, clear;
sum;

*** Merge in extra data for citing patent;
sort patent; merge patent using ./svdata/patent-zipcode1.dta, nok;
tab _m; keep if _m==3; drop _m; ren zipcode Szip;
sort patent; merge patent using ./svdata/p-work-pat_2009_short-temp.dta, nok;
tab _m; keep if _m==3; drop _m; 
for var ayear scat uspc assignee: ren X SX; ren patent Sciting;

*** Merge in extra data for cited patent;
ren citation patent; sort patent; merge patent using ./svdata/patent-zipcode1.dta, nok;
tab _m; keep if _m==3; drop _m; ren zipcode Dzip; 
sort patent; merge patent using ./svdata/p-work-pat_2009_short-temp.dta, nok;
tab _m; keep if _m==3; drop _m; 
for var ayear scat uspc assignee: ren X DX; ren patent Dcited;

*** Merge in zip code coordinates and calculate distances;
ren Szip zip; sort zip; merge zip using ./lai/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat1; ren lon lon1; ren zip Szip;
ren Dzip zip; sort zip; merge zip using ./lai/SASZip.dta, nok keep(lat lon);
tab _m; drop _m; ren lat lat2; ren lon lon2; ren zip Dzip;
gen dist=3963.0*acos(sin(lat1/57.2958)*sin(lat2/57.2958)
         +cos(lat1/57.2958)*cos(lat2/57.2958)*cos(lon2/57.2958-lon1/57.2958));
sum dist; drop lat* lon*;

*** Save expanded citation file;
gen byte firm=0;
replace firm=1 if Sassignee==Dassignee & Sassignee!=.;
replace firm=2 if Sassignee==Dassignee & Sassignee==.;
drop Sassignee Dassignee;
compress; sum; tab cit_type;
order dist cit_type S* D*; order Sciting Dcited; sort Sciting Dcited;
save ./svdata/citations_zip1_raw, replace;

*** Clean up;
erase ./svdata/p-work-pat_2009_short-temp.dta;
*!gzip ./rawdata/citations.dta;

*** End of program;
log close; 