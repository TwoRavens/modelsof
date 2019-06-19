#delimit;
clear all;
set more off;
set matsize 2000;
cap n log close;

chdir /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/;
log using /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/log/mines_ind.log, replace;

use ./data/gr-sic2-5yr-3, clear; 
sort pmsa;
merge pmsa using /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/instruments.dta;
tab _merge;
keep if _merge==3;
drop _merge;

*** Check OLS main;
areg GRemp8202T lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9s2) cl(cl);

*** Check 2SLS main;
xi: ivregress 2sls GRemp8202T (lALsize8202=IV1 IV2 IV3) lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan i.r9s2, cl(cl);
     
/* residualize and demean all continuous OLS RHS variables */;
* lALsize8202;
local olsvar lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan;
foreach var in `olsvar' IV1 IV2 IV3 {;
quietly areg `var', absorb(r9s2);
predict r_`var', dresid;
egen mean_`var'=mean(r_`var'), by(r9s2);
replace `var'=`var'-mean_`var';
};


*** Check OLS & 2SLS main residualized and de-meaned;
regress GRemp8202T lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, cl(cl);
ivregress 2sls GRemp8202T (lALsize8202=IV1 IV2 IV3) lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, cl(cl);

* Generate instruments to check reduced form QR;

foreach endog in lALsize8202 {;
regress `endog' IV1 IV2 IV3 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan;
predict pred_`endog',;
};

* Test second stage;
regress GRemp8202T pred_lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan;

* QR;
sqreg GRemp8202T lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, quantiles(.15 .25 .50 .75 .85);

* RFQR;
sqreg GRemp8202T pred_lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, quantiles(.15 .25 .50 .75 .85);

capture log close;

keep GRemp8202T lALsize8202 IV1 IV2 IV3 IV4 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan;

cd /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/log/;      
log using mines_ind_summary.log, replace text;
summarize;

capture log close;
cd /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/data/;
outfile using mines_ind.raw, nolabel noquote wide replace;


