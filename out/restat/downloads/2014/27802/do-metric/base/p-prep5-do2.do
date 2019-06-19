* William Kerr, TGG; 
* Pat Prep File for Agglomeration Work;
* Generate distance file between zip codes in same SCAT for DO calculations;
* Last Updated 13 Nov 2009;

#delimit;
cap n log close; log using ./logdir/p-prep5-do2.log, replace;
clear; set memory 5g; set matsize 1000; set more off;

*********************************;
** Calculate kernel densities  **;
*********************************;

use ./svdata-do/do-scat-zip-1, clear;
levelsof scat, local(ind2);

foreach Q2 of local ind2 {;

  * Load collapse distance data (true distances with spacers, has both zero and one);
  use ./svdata-do/dist-template, clear;
  sort dist; merge dist using ./svdata-do/do-scat-zip-2-`Q2';
  tab _m; for var ct*: replace X=0 if _m==1; drop if _m==2; drop _m;
  drop scat; gen scat=`Q2';

  * Assign intra-county dist and reflect;
  replace dist=0.01 if dist==0; *drop if dist==9999;
  drop if dist>4000;
  expand 2; sort dist; replace dist=-dist if dist==dist[_n-1];
  for var ct*: replace X=int(X);

  * Calculate density metrics;
  kdensity dist [fw=ct], nogr g(kd_ct) at(dist) k(gau);
  drop if dist<0; replace dist=0 if dist<0.02;
  for var kd_*: replace X=X*2;

  * Save output file;
  sort dist;
  save ./svdata-do/do-scat-zip-3-`Q2', replace;
};

*** End of program;
log close; 