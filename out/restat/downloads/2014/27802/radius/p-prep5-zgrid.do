* William Kerr, TGG; 
* Create Grid of All Pairwise Zip Codes Within 250 Miles;
* Last Updated 12 Nov 2009;

#delimit;
cap n log close; log using ./logdir/p-prep5-zgrid.log, replace;
clear; set memory 5g; set matsize 1000; set more off;

*** Add numbers to base Zip file;
use ./lai/SASZip.dta, clear; gen n=[_n]; drop statecode; sum;
save ./lai/SASZipn.dta, replace;

*** Start counterfactual file with first 1000;
keep if n<=1000; 
for var zip n lat lon: ren X X1;
cross using ./lai/SASZipn.dta;
for var zip n lat lon: ren X X2;
gen dist=3963.0*acos(sin(lat1/57.2958)*sin(lat2/57.2958)
         +cos(lat1/57.2958)*cos(lat2/57.2958)*cos(lon2/57.2958-lon1/57.2958));
keep if dist<=250; 
keep zip1 zip2 dist;
save ./lai/SASZip-grid.dta, replace;

*** Loop over every additional 1000 zip codes;
forvalues N2=2000(1000)42000 {;
  use if n>`N2'-1000 & n<=`N2' using ./lai/SASZipn.dta, clear;
  for var zip n lat lon: ren X X1;
  cross using ./lai/SASZipn.dta;
  for var zip n lat lon: ren X X2;
  gen dist=3963.0*acos(sin(lat1/57.2958)*sin(lat2/57.2958)
         +cos(lat1/57.2958)*cos(lat2/57.2958)*cos(lon2/57.2958-lon1/57.2958));
  keep if dist<=250;
  keep zip1 zip2 dist;
  append using ./lai/SASZip-grid.dta;
  save ./lai/SASZip-grid.dta, replace;
};

*** Finalize dataset;
* Allow for duplicates as citations are directional;
sort zip1 zip2; sum;
save ./lai/SASZip-grid.dta, replace;

*** End of program;
log close;