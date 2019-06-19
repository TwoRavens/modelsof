#delimit;

gl coaggl
gl lbd10
gl census
gl cmf
gl data
gl programs

cap n log close; log using $cmf/cmf-prep1.log, replace;

* William Kerr;
* To God's Glory;
* CMF Description & Reform;
* Last Modified: 7 Feb 2008;

clear; set mem 1500m; set matsize 8000; set more off;
chdir $cmf;

*** Base CMF;
* sas-to-stata transfer for 2002 failed...;
for any 63 67 72 77 82 87 92 97:
\ cap n !gunzip cmf00X.dta.gz 
\ use cmf00X.dta, clear 
\ compress \ cap n sort ppn \ des \ sum
\ cap n erase cmf00X.dta.gz 
\ save cmf00X.dta, replace
\ !gzip cmf00X.dta;

*** Mat CMF;
for any 63 67 72 77 82 87 92 97 02:
\ cap n !gunzip cmf00Xmat.dta.gz 
\ use cmf00Xmat.dta, clear 
\ compress \ cap n sort ppn \ des \ sum
\ cap n erase cmf00Xmat.dta.gz 
\ save cmf00Xmat.dta, replace
\ !gzip cmf00Xmat.dta;

*** Prod CMF;
for any 63 67 72 77 82 87 92 97 02:
\ cap n !gunzip cmf00Xprod.dta.gz 
\ use cmf00Xprod.dta, clear 
\ compress \ cap n sort ppn \ des \ sum
\ cap n erase cmf00Xprod.dta.gz 
\ save cmf00Xprod.dta, replace
\ !gzip cmf00Xprod.dta;

*** TFP CMF;
for any 72 77 82 87 92 97:
\ cap n !gunzip cmf00Xtfp.dta.gz 
\ use cmf00Xtfp.dta, clear 
\ compress \ cap n sort ppn \ des \ sum
\ cap n erase cmf00Xtfp.dta.gz 
\ save cmf00Xtfp.dta, replace
\ !gzip cmf00Xtfp.dta;

*** Misc CMF;
for any 87:
\ cap n !gunzip fcmX.dta.gz 
\ use fcmX.dta, clear 
\ compress \ cap n sort ppn \ des \ sum
\ cap n erase fcmX.dta.gz 
\ save fcmX.dta, replace
\ !gzip fcmX.dta;

chdir $cmf;
*** End of Program;
cap n log close;

