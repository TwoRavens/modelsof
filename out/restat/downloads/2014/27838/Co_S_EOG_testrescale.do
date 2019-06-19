* Co_S_EOG_testrescale.do is the file that reads in tab data 
* containing score conversions for math and reading EOG scores
* It generates a single data file that contains all the conversions 
* from new to old and old to new for both math and reading

#delimit;
clear;
pause off;
set more off;
set mem 800m;
capture log close;


local outfile S_EOG_testrescale;

***********************************************************************************;
insheet using EOGReadRescale.txt, tab;
sort grade readscal;
compress;
label variable oldreadscal "readscal converted to pre-2003";
label variable newreadscal "readscal converted to post-2002";
save Co_`outfile'_read, replace;
clear;
insheet using EOGMathRescale.txt, tab;
sort grade mathscal;
compress;
label variable oldmathscal "mathscal converted to pre-2001";
label variable newmathscal "mathscal converted to post-2000";
save Co_`outfile'_math, replace;

log close;


