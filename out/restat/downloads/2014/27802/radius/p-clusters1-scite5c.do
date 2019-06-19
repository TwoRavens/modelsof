* William Kerr, TGG; 
* Secondary Cite Prep File for Agglomeration Work - Removes own firm;
* Last Updated Oct 2012;

#delimit;
cd /export/projects/wkerr_h1b_project/kerr/mainwork-2009/programs/cite/clusters1;
cap n log close; log using p-clusters1-scite5c.log, replace;
clear; set matsize 1000; set more off;

************************;
** Zip to zip only    **;
************************;

use if dist<=150 using ./svdata/citations_zip1_raw_noinvcites, clear;
ren dist Ddist;
gen ct_nof=1 if firm!=1;
gen ct_agey=1 if abs(Sayear-Dayear)<=5;
gen ct_scat=1 if Sscat==Dscat;
gen ct_uspc=1 if Suspc==Duspc;
collapse (sum) ct_* (mean) Ddist, by(Szip Dzip Sscat) fast;
sort Szip Sscat Dzip; compress;
save ./svdata/citations_zip5_Ddist2, replace;
sum;

for any E F G H I:
\ use if Xdist<=150 using ./svdata/citations_zip5_rawX, clear
\ gen ct_nof=1 
\ gen ct_agey=1 if abs(Sayear-Xayear)<=5
\ gen ct_scat=1 if Sscat==Xscat
\ gen ct_uspc=1 if Suspc==Xuspc
\ collapse (sum) ct_* (mean) Xdist, by(Szip Xzip Sscat) fast
\ sort Szip Sscat Xzip \ compress
\ save ./svdata/citations_zip5_Xdist2, replace
\ sum;

*** End of program;
log close;