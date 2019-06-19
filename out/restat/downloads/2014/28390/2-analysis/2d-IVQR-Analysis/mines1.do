#delimit;
clear all;
set more off;
cap n log close;
set matsize 10000;

sysdir set PERSONAL /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/;

chdir /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/;

use ./data/gr-sic1-5yr-3, clear;
gen const=1;

chdir /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/log/;
log using "mines.log", replace;

*** Check OLS and IV main - IV Set 1;

for any lALsize8202 lBSHempT8202:
 ivregress 2sls GRemp8202T (X=IV1 IV2 IV3 IV4) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, cl(cl); 
for any lALsize8202 lBSHempT8202:
 ivregress 2sls GRemp8202T (X=IV1 IV2 IV3 IV4) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*; 

for any lALsize8202 lBSHempT8202:
 regress GRemp8202T X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, cl(cl); 
for any lALsize8202 lBSHempT8202:
 regress GRemp8202T X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*; 

*** Check OLS and IV main - IV Set 2;
gen lMT250_00b=ln(1+ MT250_00b);
egen temp1=pctile(lMT250_00b), p(98); replace lMT250_00b=temp1 if lMT250_00b>temp1 & lMT250_00b!=.; drop temp1;
egen temp1=pctile(lMT250_00b), p(02); replace lMT250_00b=temp1 if lMT250_00b<temp1 & lMT250_00b!=.; drop temp1;

for any lALsize8202 lBSHempT8202:
 ivregress 2sls GRemp8202T (X=lMT250_00b IV2 IV3) lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, cl(cl);
for any lALsize8202 lBSHempT8202:
 ivregress 2sls GRemp8202T (X=lMT250_00b IV2 IV3) lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*;
             
*** Check OLS and IV main - IV Set Both;

for any lALsize8202 lBSHempT8202:
 ivregress 2sls GRemp8202T (X= IV1 lMT250_00b IV2 IV3) lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, cl(cl);
for any lALsize8202 lBSHempT8202:
 ivregress 2sls GRemp8202T (X=IV1 lMT250_00b IV2 IV3) lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*;


* Create data for Matlab;

local olsvar lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan;


* Generate instruments to check reduced form QR;

foreach endog in lALsize8202 lBSHempT8202 {;
regress `endog' IV1 IV2 IV3 IV4 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir*;
predict pred_`endog',;
};

* Test second stage;
regress GRemp8202T pred_lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir*;
regress GRemp8202T pred_lBSHempT8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir*;

regress GRemp8202T pred_lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir*, cl(cl);
regress GRemp8202T pred_lBSHempT8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir*, cl(cl);

* Stata IVQREG;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lALsize8202=IV1), q(0.15) robust;
*bootstrap, reps(2): ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan (lALsize8202=IV1 IV2 IV3), q(0.15);
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lALsize8202=IV1 IV2 IV3), q(0.25) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I* (lALsize8202=IV1 IV2 IV3), q(0.50) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I* (lALsize8202=IV1 IV2 IV3), q(0.75) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I* (lALsize8202=IV1 IV2 IV3), q(0.85) robust;

ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lALsize8202=lMT250_00b IV2 IV3), q(0.15) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lALsize8202=lMT250_00b IV2 IV3), q(0.25) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lALsize8202=lMT250_00b IV2 IV3), q(0.50) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lALsize8202=lMT250_00b IV2 IV3), q(0.75) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lALsize8202=lMT250_00b IV2 IV3), q(0.85) robust;

ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lBSHempT8202=IV1 IV2 IV3), q(0.15) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lBSHempT8202=IV1 IV2 IV3), q(0.25) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lBSHempT8202=IV1 IV2 IV3), q(0.50) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lBSHempT8202=IV1 IV2 IV3), q(0.75) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lBSHempT8202=IV1 IV2 IV3), q(0.85) robust;

ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lBSHempT8202=lMT250_00b IV2 IV3), q(0.15) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lBSHempT8202=lMT250_00b IV2 IV3), q(0.25) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lBSHempT8202=lMT250_00b IV2 IV3), q(0.50) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lBSHempT8202=lMT250_00b IV2 IV3), q(0.75) robust;
ivqreg GRemp8202T lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _Ir* (lBSHempT8202=lMT250_00b IV2 IV3), q(0.85) robust;

* QR;
sqreg GRemp8202T lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, quantiles(.15 .25 .50 .75 .85) robust;
sqreg GRemp8202T lBSHempT8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, quantiles(.15 .25 .50 .75 .85) robust;

* RFQR;
sqreg GRemp8202T pred_lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*,  quantiles(.15 .25 .50 .75 .85) robust;
sqreg GRemp8202T pred_lBSHempT8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, quantiles(.15 .25 .50 .75 .85) robust;

capture log close;

keep GRemp8202T lALsize8202 lBSHempT8202 IV1 IV2 IV3 IV4 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan lWTR_DO coast 
      _Ir9_2 _Ir9_3 _Ir9_4 _Ir9_5 _Ir9_6 _Ir9_7 _Ir9_8 _Ir9_9 lMT250_00b;

chdir /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/log/;      

log using mines_summary.log, replace text;
summarize;

capture log close;

chdir /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/data/;
outfile using mines.raw, nolabel noquote wide replace;

