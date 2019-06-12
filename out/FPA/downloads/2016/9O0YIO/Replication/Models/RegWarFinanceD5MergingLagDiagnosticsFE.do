

# delimit ;
clear;
*version 13;
set matsize 400;
set more off;

log using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/MergingLagDiagnosticsFE.log", replace;


************************************************;
*Author: Jeff Carter                                         *;
*Date: Sunday, December 7, 2014                         *;
*Purpose: Identifying Lags                              *;
*************************************************;

***  Distribution ***;

* War *;

cd "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/FE/War/Lags";

use beta11.dta, clear;
merge 1:1 _n using beta12.dta;
drop _merge;
merge 1:1 _n using beta13.dta;
drop _merge;
merge 1:1 _n using beta14.dta;
drop _merge;
merge 1:1 _n using beta15.dta;
drop _merge;
saveold bmat1, replace;

use se11.dta, clear;
merge 1:1 _n using se12.dta;
drop _merge;
merge 1:1 _n using se13.dta;
drop _merge;
merge 1:1 _n using se14.dta;
drop _merge;
merge 1:1 _n using se15.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat1, replace;


use beta21.dta, clear;
merge 1:1 _n using beta22.dta;
drop _merge;
merge 1:1 _n using beta23.dta;
drop _merge;
merge 1:1 _n using beta24.dta;
drop _merge;
merge 1:1 _n using beta25.dta;
drop _merge;
saveold bmat2, replace;

use se21.dta, clear;
merge 1:1 _n using se22.dta;
drop _merge;
merge 1:1 _n using se23.dta;
drop _merge;
merge 1:1 _n using se24.dta;
drop _merge;
merge 1:1 _n using se25.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat2, replace;

use beta31.dta, clear;
merge 1:1 _n using beta32.dta;
drop _merge;
merge 1:1 _n using beta33.dta;
drop _merge;
merge 1:1 _n using beta34.dta;
drop _merge;
merge 1:1 _n using beta35.dta;
drop _merge;
saveold bmat3, replace;

use se31.dta, clear;
merge 1:1 _n using se32.dta;
drop _merge;
merge 1:1 _n using se33.dta;
drop _merge;
merge 1:1 _n using se34.dta;
drop _merge;
merge 1:1 _n using se35.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat3, replace;


***  Debt ***;

* War *;

cd "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Debt/FE/War/Lags";


use beta11.dta, clear;
merge 1:1 _n using beta12.dta;
drop _merge;
merge 1:1 _n using beta13.dta;
drop _merge;
merge 1:1 _n using beta14.dta;
drop _merge;
merge 1:1 _n using beta15.dta;
drop _merge;
saveold bmat1, replace;


use se11.dta, clear;
merge 1:1 _n using se12.dta;
drop _merge;
merge 1:1 _n using se13.dta;
drop _merge;
merge 1:1 _n using se14.dta;
drop _merge;
merge 1:1 _n using se15.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat1, replace;


use beta21.dta, clear;
merge 1:1 _n using beta22.dta;
drop _merge;
merge 1:1 _n using beta23.dta;
drop _merge;
merge 1:1 _n using beta24.dta;
drop _merge;
merge 1:1 _n using beta25.dta;
drop _merge;
saveold bmat2, replace;

use se21.dta, clear;
merge 1:1 _n using se22.dta;
drop _merge;
merge 1:1 _n using se23.dta;
drop _merge;
merge 1:1 _n using se24.dta;
drop _merge;
merge 1:1 _n using se25.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat2, replace;

use beta31.dta, clear;
merge 1:1 _n using beta32.dta;
drop _merge;
merge 1:1 _n using beta33.dta;
drop _merge;
merge 1:1 _n using beta34.dta;
drop _merge;
merge 1:1 _n using beta35.dta;
drop _merge;
saveold bmat3, replace;

use se31.dta, clear;
merge 1:1 _n using se32.dta;
drop _merge;
merge 1:1 _n using se33.dta;
drop _merge;
merge 1:1 _n using se34.dta;
drop _merge;
merge 1:1 _n using se35.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat3, replace;



***  Taxes ***;

* War *;

cd "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Taxes/FE/War/Lags";


use beta11.dta, clear;
merge 1:1 _n using beta12.dta;
drop _merge;
merge 1:1 _n using beta13.dta;
drop _merge;
merge 1:1 _n using beta14.dta;
drop _merge;
merge 1:1 _n using beta15.dta;
drop _merge;
saveold bmat1, replace;


use se11.dta, clear;
merge 1:1 _n using se12.dta;
drop _merge;
merge 1:1 _n using se13.dta;
drop _merge;
merge 1:1 _n using se14.dta;
drop _merge;
merge 1:1 _n using se15.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat1, replace;


use beta21.dta, clear;
merge 1:1 _n using beta22.dta;
drop _merge;
merge 1:1 _n using beta23.dta;
drop _merge;
merge 1:1 _n using beta24.dta;
drop _merge;
merge 1:1 _n using beta25.dta;
drop _merge;
saveold bmat2, replace;

use se21.dta, clear;
merge 1:1 _n using se22.dta;
drop _merge;
merge 1:1 _n using se23.dta;
drop _merge;
merge 1:1 _n using se24.dta;
drop _merge;
merge 1:1 _n using se25.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat2, replace;

use beta31.dta, clear;
merge 1:1 _n using beta32.dta;
drop _merge;
merge 1:1 _n using beta33.dta;
drop _merge;
merge 1:1 _n using beta34.dta;
drop _merge;
merge 1:1 _n using beta35.dta;
drop _merge;
saveold bmat3, replace;

use se31.dta, clear;
merge 1:1 _n using se32.dta;
drop _merge;
merge 1:1 _n using se33.dta;
drop _merge;
merge 1:1 _n using se34.dta;
drop _merge;
merge 1:1 _n using se35.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat3, replace;



***  Inflation ***;

* War *;

cd "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Inflation/FE/War/Lags";


use beta11.dta, clear;
merge 1:1 _n using beta12.dta;
drop _merge;
merge 1:1 _n using beta13.dta;
drop _merge;
merge 1:1 _n using beta14.dta;
drop _merge;
merge 1:1 _n using beta15.dta;
drop _merge;
saveold bmat1, replace;


use se11.dta, clear;
merge 1:1 _n using se12.dta;
drop _merge;
merge 1:1 _n using se13.dta;
drop _merge;
merge 1:1 _n using se14.dta;
drop _merge;
merge 1:1 _n using se15.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat1, replace;



use beta21.dta, clear;
merge 1:1 _n using beta22.dta;
drop _merge;
merge 1:1 _n using beta23.dta;
drop _merge;
merge 1:1 _n using beta24.dta;
drop _merge;
merge 1:1 _n using beta25.dta;
drop _merge;
saveold bmat2, replace;

use se21.dta, clear;
merge 1:1 _n using se22.dta;
drop _merge;
merge 1:1 _n using se23.dta;
drop _merge;
merge 1:1 _n using se24.dta;
drop _merge;
merge 1:1 _n using se25.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat2, replace;

use beta31.dta, clear;
merge 1:1 _n using beta32.dta;
drop _merge;
merge 1:1 _n using beta33.dta;
drop _merge;
merge 1:1 _n using beta34.dta;
drop _merge;
merge 1:1 _n using beta35.dta;
drop _merge;
saveold bmat3, replace;

use se31.dta, clear;
merge 1:1 _n using se32.dta;
drop _merge;
merge 1:1 _n using se33.dta;
drop _merge;
merge 1:1 _n using se34.dta;
drop _merge;
merge 1:1 _n using se35.dta;
drop _merge;
replace se11=sqrt(se11);
replace se21=sqrt(se21);
replace se31=sqrt(se31);
replace se41=sqrt(se41);
replace se51=sqrt(se51);
saveold semat3, replace;

