/* graphs and statistics for pro counterfactual */
/* be sure rowsort package, version pr0046 is installed */
/* be sure mixlogit package is installed */

#delimit;
set mem 500m;
set more off; 

log using procf.log, t replace;

use formation_new;

generate gnum = _n;

generate pro2 = 0;
generate pro3 = pro;

/* MXL */

keep gnum realg minwin mginvest anmax2 pro anti prevpm gdiv1 numpar dompar 
sq minor median mgodiv1 case pro2 pro3;

mixlogit realg anmax2 pro anti minwin mginvest prevpm gdiv1, 
rand(minor numpar dompar sq median mgodiv1) ln(2) nrep(200) group(case); 

matrix coeffs = e(b);
matrix covmat = e(V);

/* random draws of coefficients */

drawnorm b1-b19, means(coeffs) cov(covmat) double; 

/* loop for probabilities */

generate mixprobm1 = 0;
generate mixprobm2 = 0;

nois _dots 0, title() reps(1000);
forvalues j = 1/1000 {;

  mkmat b1-b19 if _n==`j', matrix(bdraw);
  mixlpred2 mixprob; 

  qui replace pro = pro2;

  mixlpred2 mixprob2;

  qui replace pro = pro3;

  qui replace mixprobm1 = mixprobm1 + mixprob;
  qui replace mixprobm2 = mixprobm2 + mixprob2;
  qui generate mixdiff`j' = mixprob2 - mixprob;

drop mixprob mixprob2;
  
nois _dots `j' 0;
  
};

replace mixprobm1 = mixprobm1/1000;
replace mixprobm2 = mixprobm2/1000;

egen mixdiff = rowmean(mixdiff1 - mixdiff1000);

keep gnum case mixprobm1 mixprobm2 mixdiff mixdiff1 - mixdiff1000;

rowsort mixdiff1 - mixdiff1000, generate(mixdsort1 - mixdsort1000);

generate sigchange = 0;
replace sigchange = 1 if mixdsort25>0 & mixdsort975>0;
replace sigchange = 1 if mixdsort25<0 & mixdsort975<0;

keep gnum case mixprobm1 mixprobm2 mixdiff sigchange;

save Figure3b, replace;
