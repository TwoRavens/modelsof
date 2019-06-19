* William Kerr, TGG; 
* Cite Bilateral Analysis;
* Last Updated Nov 2012;

#delimit;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/clusters1;
cap n log close; log using p-clusters1-ring5Ze3c.log, replace;
clear all; set matsize 1000; set more off;
* do /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/clusters1/p-clusters1-ring5Ze3c.do;

************************;
** Param Test         **;
************************;

use if dist<=150 & Szip!=Rzip using ./svdata/citations_cluster1_ring5Z3, clear;
levelsof Sscat, local(scatI);

*** Count regressions with zip FE - Core;
foreach Q4 of local scatI {;
use if dist<=150 & Sscat==`Q4' & Szip!=Rzip using ./svdata/citations_cluster1_ring5Z3, clear;
ren ct_scat1 ct1; gen ct23=ct_scat2+ct_scat3; ren Sscat scat;
for num 1 23: gen lctX=ln(1+ctX); drop ct_* Dscat;
gen lSDpat=ln(Spat*Dpat); gen wt=Spat*Dpat; for var dist: gen lX=ln(X); 
for num 1: areg lctX ldist lSDpat [aw=wt] if scat==`Q4', a(Szip) r;
};

*** End of program;
log close;