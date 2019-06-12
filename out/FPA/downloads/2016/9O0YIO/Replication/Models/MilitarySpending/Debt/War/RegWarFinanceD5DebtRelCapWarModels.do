# delimit ;
clear;
*version 12;
set matsize 400;
set more off;

log using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/Models.log", replace;


************************************************;
*Author: Jeff Carter                                         *;
*Date: Monday, December 8, 2014  09:26                       *;
*Purpose: Estimating Models                             *;
*************************************************;


* Data Set 1 *;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp1.dta", clear;

xtset ccode year;


xtreg debt l.debt l2.debt    war polity relcap polity_war_relcap  cap gdppc number rpe_gdp, fe  ;


matrix beta1=e(b)';
matrix list beta1 ;

matrix v1 =e(V) ;
matrix se1=cholesky(v1);
matrix se1=vecdiag(v1)';
matrix list se1 ;

xsvmat beta1, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/beta1.dta", replace) ;
xsvmat se1, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/se1.dta", replace) ;

matrix n1=e(N);
matrix r21=e(r2_o);
matrix f1=e(F);
matrix sum1 = (n1,r21,f1);
xsvmat sum1,saving("/Users/Jeff//Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/sum1.dta", replace) ;

preserve;

drawnorm MG_b1-MG_b11, n(1000) means(e(b)) cov(e(V)) clear;

saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/PostEstimation/SimData1.dta", replace;

restore;




* Data Set 2 *;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp2.dta", clear;

xtset ccode year;


xtreg debt l.debt l2.debt    war polity relcap polity_war_relcap  cap gdppc number rpe_gdp, fe  ;


matrix beta2=e(b)';
matrix list beta2 ;

matrix v2 =e(V) ;
matrix se2=cholesky(v2);
matrix se2=vecdiag(v2)';
matrix list se2 ;

xsvmat beta2, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/beta2.dta", replace) ;
xsvmat se2, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/se2.dta", replace) ;

matrix n2=e(N);
matrix r22=e(r2_o);
matrix f2=e(F);
matrix sum2 = (n2,r22,f2);
xsvmat sum2,saving("/Users/Jeff//Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/sum2.dta", replace) ;

preserve;

drawnorm MG_b1-MG_b11, n(1000) means(e(b)) cov(e(V)) clear;

saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/PostEstimation/SimData2.dta", replace;

restore;




* Data Set 3 *;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp3.dta", clear;

xtset ccode year;


xtreg debt l.debt l2.debt    war polity relcap polity_war_relcap  cap gdppc number rpe_gdp, fe  ;


matrix beta3=e(b)';
matrix list beta3 ;

matrix v3 =e(V) ;
matrix se3=cholesky(v3);
matrix se3=vecdiag(v3)';
matrix list se3 ;

xsvmat beta3, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/beta3.dta", replace) ;
xsvmat se3, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/se3.dta", replace) ;

matrix n3=e(N);
matrix r23=e(r2_o);
matrix f3=e(F);
matrix sum3 = (n3,r23,f3);
xsvmat sum3,saving("/Users/Jeff//Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/sum3.dta", replace) ;

preserve;

drawnorm MG_b1-MG_b11, n(1000) means(e(b)) cov(e(V)) clear;

saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/PostEstimation/SimData3.dta", replace;

restore;



* Data Set 4 *;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp4.dta", clear;

xtset ccode year;


xtreg debt l.debt l2.debt    war polity relcap polity_war_relcap  cap gdppc number rpe_gdp, fe  ;


matrix beta4=e(b)';
matrix list beta4 ;

matrix v4 =e(V) ;
matrix se4=cholesky(v4);
matrix se4=vecdiag(v4)';
matrix list se4 ;

xsvmat beta4, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/beta4.dta", replace) ;
xsvmat se4, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/se4.dta", replace) ;

matrix n4=e(N);
matrix r24=e(r2_o);
matrix f4=e(F);
matrix sum4 = (n4,r24,f4);
xsvmat sum4,saving("/Users/Jeff//Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/sum4.dta", replace) ;

preserve;

drawnorm MG_b1-MG_b11, n(1000) means(e(b)) cov(e(V)) clear;

saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/PostEstimation/SimData4.dta", replace;

restore;




* Data Set 5 *;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp5.dta", clear;

xtset ccode year;


xtreg debt l.debt l2.debt    war polity relcap polity_war_relcap  cap gdppc number rpe_gdp, fe  ;


matrix beta5=e(b)';
matrix list beta5 ;

matrix v5 =e(V) ;
matrix se5=cholesky(v5);
matrix se5=vecdiag(v5)';
matrix list se5 ;

xsvmat beta5, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/beta5.dta", replace) ;
xsvmat se5, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/se5.dta", replace) ;

matrix n5=e(N);
matrix r25=e(r2_o);
matrix f5=e(F);
matrix sum5 = (n5,r25,f5);
xsvmat sum5,saving("/Users/Jeff//Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/sum5.dta", replace) ;

preserve;

drawnorm MG_b1-MG_b11, n(1000) means(e(b)) cov(e(V)) clear;

saveold "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/PostEstimation/SimData5.dta", replace;

restore;




use beta1.dta, clear;
merge 1:1 _n using beta2.dta;
drop _merge;
merge 1:1 _n using beta3.dta;
drop _merge;
merge 1:1 _n using beta4.dta;
drop _merge;
merge 1:1 _n using beta5.dta;
drop _merge;
# delimit;
saveold bmat, replace;



use se1.dta, clear;
merge 1:1 _n using se2.dta;
drop _merge;
merge 1:1 _n using se3.dta;
drop _merge;
merge 1:1 _n using se4.dta;
drop _merge;
merge 1:1 _n using se5.dta;
drop _merge;

saveold semat, replace;

use sum1.dta, clear;
saveold sum1.dta, replace;
use sum2.dta, clear;
saveold sum2.dta, replace;
use sum3.dta, clear;
saveold sum3.dta, replace;
use sum4.dta, clear;
saveold sum4.dta, replace;
use sum5.dta, clear;
saveold sum5.dta, replace;

cd "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/RelCap/Debt/War/PostEstimation/";


use SimData1.dta, clear;
append using SimData2.dta;
append using SimData3.dta;
append using SimData4.dta;
append using SimData5;
# delimit;
saveold SimData, replace;



