#delimit;

gl coaggl
gl lbd10
gl census
gl cmf
gl data
gl programs

cap n log close; log using cmf-prep1-ext.log, replace;

* William Kerr;
* To God's Glory;
* CMF Description & Reform;
* Last Modified: Nov 2010;

* Note 2002 and 2007 are newer data than the original set;
* Note 2007 is pre file - manually renamed to just 2007 - no access at present!;

clear; set mem 1500m; set matsize 8000; set more off;
chdir $cmf;

*** Base CMF;
for any 2002:
\ cap n !gunzip cmfX.dta.gz 
\ use cmfX.dta, clear 
\ compress \ cap n sort ppn \ des \ sum
\ cap n erase cmfX.dta.gz 
\ save cmfX.dta, replace
\ !gzip cmfX.dta;

*** End of Program;
cap n log close;

