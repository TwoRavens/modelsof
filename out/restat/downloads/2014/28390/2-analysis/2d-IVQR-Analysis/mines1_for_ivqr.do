#delimit;
clear all;
set more off;
cap n log close;
*log using "mines1.log", replace;

chdir /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/;
use ./data/gr-sic1-5yr-3, clear;
des; sum; gen const=1;

*** Check IV Main;
for any lALsize8202 lBSHempT8202:
\ * Basics 
\ ivregress 2sls GRemp8202T (X=IV1 IV2 IV3 IV4) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan lWTR_DO coast _I*, first vce(cl cl); 

* Create data for Matlab;

*local olsvar lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan lWTR_DO coast _I*;

/* demean all OLS RHS variables */;

*quietly foreach v in `olsvar' {;
*  egen m_`v'=mean(`v') if emp==0;
*  egen mm_`v'=mean(m_`v');
*  replace `v'=`v'-mm_`v';
*  drop m_`v' mm_`v';
*  };

drop pmsal;

capture log close;
log using /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/mines_summary.log, replace text;
summarize;

capture log close;

outfile using /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/mines.raw, nolabel noquote wide replace;

