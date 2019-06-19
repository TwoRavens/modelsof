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
areg GRemp8202T lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9s2);

*** Check 2SLS main;
xi: ivregress 2sls GRemp8202T (lALsize8202=IV1 IV2 IV3) lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan i.r9s2, cl(cl);
xi: ivregress 2sls GRemp8202T (lALsize8202=IV1 IV2 IV3) lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan i.r9s2;
     
/* Orthogonalize all variables */;

local olsvar lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan;
local inst IV1 IV2 IV3 IV4;
local lhs GRemp8202T;
local endog lALsize8202;

* Orthogonalize: purge r9s2 dummies from OLS variables, instruments, endogenous variables and Y;
foreach var in `olsvar' `inst' `lhs' `endog' {;
quietly xi:reg `var' i.r9s2;
predict r_`var', resid;
};

*** Check OLS & 2SLS main residualized and de-meaned;
regress r_GRemp8202T r_lALsize8202 r_lALemp8202 r_lALemp8202SQ r_lbaPct1970 r_lhou r_lden r_lpop r_lJul r_lJan, cl(cl);
ivregress 2sls r_GRemp8202T (r_lALsize8202=r_IV1 r_IV2 r_IV3) r_lALemp8202 r_lALemp8202SQ r_lbaPct1970 r_lhou r_lden r_lpop r_lJul r_lJan, cl(cl);

regress r_GRemp8202T r_lALsize8202 r_lALemp8202 r_lALemp8202SQ r_lbaPct1970 r_lhou r_lden r_lpop r_lJul r_lJan;
ivregress 2sls r_GRemp8202T (r_lALsize8202=r_IV1 r_IV2 r_IV3) r_lALemp8202 r_lALemp8202SQ r_lbaPct1970 r_lhou r_lden r_lpop r_lJul r_lJan;

* Generate instruments to check reduced form QR;
foreach endog in r_lALsize8202 {;
regress `endog' r_IV1 r_IV2 r_IV3 r_lALemp8202 r_lALemp8202SQ r_lbaPct1970 r_lhou r_lden r_lpop r_lJul r_lJan;
predict pred_`endog',;
};

foreach endog in lALsize8202 {;
regress `endog' IV1 IV2 IV3 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan i.r9s2;
predict pred_`endog',;
};

* Test second stage;
regress r_GRemp8202T pred_r_lALsize8202 r_lALemp8202 r_lALemp8202SQ r_lbaPct1970 r_lhou r_lden r_lpop r_lJul r_lJan, cl(cl);
regress GRemp8202T pred_lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan i.r9s2, cl(cl);

* QR;
sqreg r_GRemp8202T r_lALsize8202 r_lALemp8202 r_lALemp8202SQ r_lbaPct1970 r_lhou r_lden r_lpop r_lJul r_lJan, quantiles(.15 .25 .50 .75 .85);
set seed 1001;
program bootit;
sqreg r_GRemp8202T pred_r_lALsize8202 r_lALemp8202 r_lALemp8202SQ r_lbaPct1970 r_lhou r_lden r_lpop r_lJul r_lJan, quantile(.15 .25 .50 .75 .85);
end;
bootstrap "bootit" _b, cluster(cl) reps(500) saving(bootit1);
clear programs;

* RFQR not orthogonalized;
sqreg GRemp8202T pred_lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan i.r9s2, quantiles(.15 .25 .50 .75 .85);
set seed 1001;
program bootit;
sqreg GRemp8202T pred_lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan i.r9s2, quantiles(.15 .25 .50 .75 .85);
end;
bootstrap "bootit" _b, cluster(cl) reps(500) saving(bootit3);
 
* RFQR orthogonalized;
sqreg r_GRemp8202T pred_r_lALsize8202 r_lALemp8202 r_lALemp8202SQ r_lbaPct1970 r_lhou r_lden r_lpop r_lJul r_lJan, quantiles(.15 .25 .50 .75 .85);
set seed 1001;
program bootit;
sqreg r_GRemp8202T pred_r_lALsize8202 r_lALemp8202 r_lALemp8202SQ r_lbaPct1970 r_lhou r_lden r_lpop r_lJul r_lJan, quantile(.15 .25 .50 .75 .85);
end;
bootstrap "bootit" _b, cluster(cl) reps(500) saving(bootit2);

capture log close;

keep r_GRemp8202T r_lALsize8202 r_IV1 r_IV2 r_IV3 r_IV4 r_lALemp8202 r_lALemp8202SQ r_lbaPct1970 r_lhou r_lden r_lpop r_lJul r_lJan;
order r_GRemp8202T r_lJul r_lJan r_lbaPct1970 r_lhou r_lden r_lpop r_lALemp8202 r_lALsize8202 r_lALemp8202SQ r_IV1 r_IV2 r_IV3 r_IV4;

cd /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/log/;      
log using mines_ind_summary.log, replace text;
summarize;

capture log close;
cd /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/data/;
outfile using mines_ind.raw, nolabel noquote wide replace;


