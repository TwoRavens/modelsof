#delimit;
clear all;
set more off;
cap n log close;
set matsize 10000;

chdir /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/;
use ./data/gr-sic1-5yr-3, clear;
gen const=1;

chdir /rdcprojects/br3/br00598/programs/coaggl/growth/cmf/ivqr/log/;
log using "mines_bstest_alt.log", replace;

* Bootstrap programs;

program iqr, eclass;
version 10.1;
if replay() {;
 syntax [anything] [, Level(real 95) ];
 eret di, level(`level');
 };
else {;
 syntax [varlist] [, Q1(real .15) Level(real 95) *];
 tab i, gen(_d);
 drop _d1;
 gettoken depv v1:varlist;
 tempname b1 beta;
 qreg `depv' `v1' _d*, q(`q1') `options';
 matrix `b1'=e(b);
 tempvar e1;
 g `e1'=e(sample);
 loc N=r(N);
 matrix `beta'=`b1';
 ereturn post `beta', dep(`depv') e(`e1') obs(`N');
 eret local cmd="iqr";
 drop _d*;
  };
end;


program iqrdiff, eclass;
version 10.1;
if replay() {;
 syntax [anything] [, Level(real 95) ];
 eret di, level(`level');
 };
else {;
 qui {;
 syntax [varlist] [, Q1(real .15) Q2(real .85) Level(real 95) *];
 tab i, gen(_d);
 drop _d1;
 gettoken depv v1:varlist;
 tempname b1 b2 beta;
 qreg `depv' `v1' _d*, quantile(`q1') `options';
 matrix `b1'=e(b);
 tempvar e1 e2;
 g `e1'=e(sample);
 qreg `depv' `v1' _d*, quantile(`q2') `options';
 g `e2'=e(sample)&`e1';
 count if `e2';
 loc N=r(N);
 matrix `b2'=e(b);
 matrix `beta'=`b2'-`b1';
 ereturn post `beta', dep(`depv') e(`e2') obs(`N');
 eret local cmd="iqr";
 drop _d*;
 };
 eret di, level(`level');
 };
end;

* Generate instruments to check reduced form QR;
gen lMT250_00b=ln(1+ MT250_00b);
egen temp1=pctile(lMT250_00b), p(98); replace lMT250_00b=temp1 if lMT250_00b>temp1 & lMT250_00b!=.; drop temp1;
egen temp1=pctile(lMT250_00b), p(02); replace lMT250_00b=temp1 if lMT250_00b<temp1 & lMT250_00b!=.; drop temp1;

foreach endog in lALsize8202 lBSHempT8202 {;
regress `endog' lMT250_00b IV2 IV3 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan lWTR_DO coast _I*;
predict pred_`endog',;
};


rename r9 i;

* RFQR;
bs, rep(100) cl(cl) id(i) seed(1001): iqr GRemp8202T pred_lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan;
bs, rep(100) cl(cl) id(i) seed(1001): iqr GRemp8202T pred_lBSHempT8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan;

* Testing for the differences between Q15 and Q85;

* RFQR;
bs, rep(100) cl(cl) id(i) seed(1001): iqrdiff GRemp8202T pred_lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan;
bs, rep(100) cl(cl) id(i) seed(1001): iqrdiff GRemp8202T pred_lBSHempT8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan;

capture log close;

