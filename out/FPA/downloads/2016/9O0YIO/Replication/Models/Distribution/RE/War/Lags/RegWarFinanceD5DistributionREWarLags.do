# delimit ;
clear;
*version 12;
set matsize 400;
set more off;

log using "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/IdentifyingLags.log", replace;


************************************************;
*Author: Jeff Carter                                         *;
*Date: Sunday, June 29, 2014                         *;
*Purpose: Identifying Lags                              *;
*************************************************;


* Data Set 1 *;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp1.dta", clear;

xtset ccode year;

xtreg distribution l.distribution  war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;

matrix beta1=e(b)';
matrix list beta1 ;

matrix v1 =e(V) ;
matrix se1=vecdiag(v1)' ;
matrix list se1 ;

xsvmat beta1, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta11.dta", replace) ;
xsvmat se1, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se11.dta", replace) ;

drop e;



xtreg distribution l.distribution l2.distribution war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;

matrix beta1=e(b)';
matrix list beta1 ;

matrix v1 =e(V) ;
matrix se1=vecdiag(v1)' ;
matrix list se1 ;

xsvmat beta1, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta21.dta", replace) ;
xsvmat se1, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se21.dta", replace) ;

drop e;



xtreg distribution l.distribution l2.distribution l3.distribution war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;

matrix beta1=e(b)';
matrix list beta1 ;

matrix v1 =e(V) ;
matrix se1=vecdiag(v1)' ;
matrix list se1 ;

xsvmat beta1, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta31.dta", replace) ;
xsvmat se1, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se31.dta", replace) ;

drop e;




* Data Set 2 *;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp2.dta", clear;

xtset ccode year;

xtreg distribution l.distribution  war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;


matrix beta2=e(b)' ;
matrix list beta2 ;

matrix v2 =e(V) ;
matrix se2=vecdiag(v2)' ;
matrix list se2 ;


xsvmat beta2, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta12.dta", replace) ;
xsvmat se2, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se12.dta", replace) ;

drop e;


xtreg distribution l.distribution l2.distribution war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;


matrix beta2=e(b)' ;
matrix list beta2 ;

matrix v2 =e(V) ;
matrix se2=vecdiag(v2)' ;
matrix list se2 ;


xsvmat beta2, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta22.dta", replace) ;
xsvmat se2, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se22.dta", replace) ;

drop e;



xtreg distribution l.distribution l2.distribution l3.distribution war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;


matrix beta2=e(b)' ;
matrix list beta2 ;

matrix v2 =e(V) ;
matrix se2=vecdiag(v2)' ;
matrix list se2 ;


xsvmat beta2, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta32.dta", replace) ;
xsvmat se2, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se32.dta", replace) ;


drop e;




* Data Set 3 *;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp3.dta", clear;

xtset ccode year;

xtreg distribution l.distribution  war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;


matrix beta3=e(b)' ;
matrix list beta3 ;

matrix v3 =e(V) ;
matrix se3=vecdiag(v3)' ;
matrix list se3 ;


xsvmat beta3, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta13.dta", replace) ;
xsvmat se3, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se13.dta", replace) ;

drop e;


xtreg distribution l.distribution l2.distribution war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;


matrix beta3=e(b)' ;
matrix list beta3 ;

matrix v3 =e(V) ;
matrix se3=vecdiag(v3)' ;
matrix list se3 ;

xsvmat beta3, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta23.dta", replace) ;
xsvmat se3, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se23.dta", replace) ;

drop e;



xtreg distribution l.distribution l2.distribution l3.distribution war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;


matrix beta3=e(b)' ;
matrix list beta3 ;

matrix v3 =e(V) ;
matrix se3=vecdiag(v3)' ;
matrix list se3 ;


xsvmat beta3, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta33.dta", replace) ;
xsvmat se3, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se33.dta", replace) ;

drop e;



* Data Set 4 *;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp4.dta", clear;

xtset ccode year;

xtreg distribution l.distribution  war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;


matrix beta4=e(b)' ;
matrix list beta4 ;

matrix v4 =e(V) ;
matrix se4=vecdiag(v4)' ;
matrix list se4 ;


xsvmat beta4, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta14.dta", replace) ;
xsvmat se4, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se14.dta", replace) ;

drop e;


xtreg distribution l.distribution l2.distribution war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;


matrix beta4=e(b)' ;
matrix list beta4 ;

matrix v4 =e(V);
matrix se4=vecdiag(v4)' ;
matrix list se4 ;


xsvmat beta4, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta24.dta", replace) ;
xsvmat se4, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se24.dta", replace) ;

drop e;



xtreg distribution l.distribution l2.distribution l3.distribution war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;

matrix beta4=e(b)' ;
matrix list beta4 ;

matrix v4 =e(V) ;
matrix se4=vecdiag(v4)' ;
matrix list se4 ;


xsvmat beta4, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta34.dta", replace) ;
xsvmat se4, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se34.dta", replace) ;


drop e;



* Data Set 5 *;

use "/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Data/RegWarFinanceD5-imp5.dta", clear;

xtset ccode year;

xtreg distribution l.distribution  war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;

matrix beta5=e(b)';
matrix list beta5 ;

matrix v5 =e(V) ;
matrix se5=vecdiag(v5)' ;
matrix list se5 ;

xsvmat beta5, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta15.dta", replace) ;
xsvmat se5, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se15.dta", replace) ;

drop e;


xtreg distribution l.distribution l2.distribution war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;

matrix beta5=e(b)';
matrix list beta5 ;

matrix v5 =e(V) ;
matrix se5=vecdiag(v5)' ;
matrix list se5 ;

xsvmat beta5, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta25.dta", replace) ;
xsvmat se5, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se25.dta", replace) ;

drop e;



xtreg distribution l.distribution l2.distribution l3.distribution war polity polity_war   cap gdppc number rpe_gdp, mle  ;

predict e, e;

regress e l.e;

matrix beta5=e(b)';
matrix list beta5 ;

matrix v5 =e(V) ;
matrix se5=vecdiag(v5)' ;
matrix list se5 ;

xsvmat beta5, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/beta35.dta", replace) ;
xsvmat se5, saving("/Users/Jeff/Dropbox/RegimeWarFinance/D5/Analysis/Models/Distribution/RE/War/Lags/se35.dta", replace) ;

drop e;
