* William Kerr, TGG; 
* Pat Prep File for Agglomeration Work;
* Generates KD for Random Counterfactuals in DO calculations;
* Last Updated 15 March 2010;

#delimit;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/prep5-do/ran2-density;
cap n log close; log using p-prep5-ran-do3c.log, replace;
clear; clear matrix; set memory 5g; set matsize 1000; set more off;

*************************************;
** Generate list of industry sizes **;
*************************************;

*** Open working file;
use patent ctryn ayear scat uspc
    if ctryn=="US" & (scat!=. & uspc!=.) & (ayear>=1990 & ayear<=1999)
    using ./../../../svdata/p-work-pat_2009_short.dta, clear;
keep patent scat; compress; sum; sort patent; drop if patent==patent[_n-1];
gen ct=1; collapse (sum) ct, by(scat) fast;
sort scat; list; keep if (scat==39 | scat==49);
levelsof scat, local(scatindexc);

*********************************;
** Calculate kernel densities  **;
*********************************;

foreach KKc of local scatindexc {;
forvalues LLc=1(1)1000 {;

  * Load collapse distance data (true distances with spacers, has both zero and one);
  use ./../../../svdata-do/dist-template, clear;
  !gunzip ./../../../svdata-do/random2/do-dist-cross-`KKc'-`LLc'.dta;
  sort dist; merge dist using ./../../../svdata-do/random2/do-dist-cross-`KKc'-`LLc', nok;
  !gzip ./../../../svdata-do/random2/do-dist-cross-`KKc'-`LLc'.dta;
  replace ct=0 if _m==1; drop _m;

  * Assign intra-county dist and reflect;
  replace dist=0.01 if dist==0; drop if dist>4000;
  expand 2; sort dist; replace dist=-dist if dist==dist[_n-1];
  replace ct=int(ct);

  * Calculate density metrics;
  kdensity dist [fw=ct], nogr g(kd_ct) at(dist) k(gau);
  drop if dist<0; replace dist=0 if dist<0.02;
  replace kd_ct=kd_ct*2;

  * Save output file;
  sort dist; save ./../../../svdata-do/random3/do-ran-density-`KKc'-`LLc', replace;
  *cap n erase ./../../../svdata-do/random3/do-ran-density-`KKc'-`LLc'.dta.gz;;
  !gzip ./../../../svdata-do/random3/do-ran-density-`KKc'-`LLc'.dta;

};
};

*** End of program;
log close; 