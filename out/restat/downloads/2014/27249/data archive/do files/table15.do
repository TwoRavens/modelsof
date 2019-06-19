set more off


log using "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\regression results\table15.log", replace


***
* A COUNTERFACTUAL ANALYSIS (BASED ON THE LIML REGRESSIONS IN TABLES 6 & 7)
**


*******************LIML  ABSOLUTE RAINFALL DEVIATION FROM AVERAGE


** CONTRIBUTIONS DIRECTES ET INDIRECTES


*--Baseline specification  *LIML  * Column 1

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
drop if id==57
drop if id==67
drop if id==68
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first

predict logrepublican_predict, xb
gen elogrepublican_predict=exp(logrepublican_predict)

replace logmars=0 
replace logavril=0
replace logjuin=0
replace logseptembre=0

ivreg2 logrepublican iyear_*   (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml  robust cluster(id) first


predict logrepublican_predict0, xb

gen elogrepublican_predict0=exp(logrepublican_predict0)

save "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\predictsq dataset avec sinistres cont ind2 rain deviation monthly.dta", replace


sum republican elogrepublican_predict0 if year==1876
sum republican elogrepublican_predict0 if year==1877
sum republican elogrepublican_predict0 if year==1881
sum republican elogrepublican_predict0 if year==1885
sum republican elogrepublican_predict0 if year==1889
sum republican elogrepublican_predict0

sort year

by year: tab departement if republican>0.5
by year: tab departement if  elogrepublican_predict0>0.5



************** LIML SQUARED RAINFALL DEVIATION FROM AVERAGE

** CONTRIBUTIONS DIRECTES ET INDIRECTES



*--Baseline specification  *LIML  * Column 7

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
drop if id==57
drop if id==67
drop if id==68
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\sqrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first

predict logrepublican_predict, xb

gen elogrepublican_predict=exp(logrepublican_predict)

replace logmars=0 
replace logavril=0
replace logjuin=0
replace logseptembre=0

ivreg2 logrepublican iyear_*   (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml  robust cluster(id) first

predict logrepublican_predict0, xb
gen elogrepublican_predict0=exp(logrepublican_predict0)

save "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\predictabs dataset avec sinistres cont ind2 rain deviation monthly.dta", replace



sum republican elogrepublican_predict0 if year==1876
sum republican elogrepublican_predict0 if year==1877
sum republican elogrepublican_predict0 if year==1881
sum republican elogrepublican_predict0 if year==1885
sum republican elogrepublican_predict0 if year==1889
sum republican elogrepublican_predict0
sort year

by year: tab departement if republican>0.5
by year: tab departement if  elogrepublican_predict0>0.5

*********** LIML ONE SIDED RAINFALL DEVIATION FROM AVERAGE

** CONTRIBUTIONS DIRECTES ET INDIRECTES



*--Baseline specification  *LIML  * Column 13

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
drop if id==57
drop if id==67
drop if id==68
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\onesidedrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first


predict logrepublican_predict0, xb
gen elogrepublican_predict0=exp(logrepublican_predict0)

save "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\predictabs dataset avec sinistres cont ind2 rain deviation monthly.dta", replace


sum republican elogrepublican_predict0 if year==1876
sum republican elogrepublican_predict0 if year==1877
sum republican elogrepublican_predict0 if year==1881
sum republican elogrepublican_predict0 if year==1885
sum republican elogrepublican_predict0 if year==1889
sum republican elogrepublican_predict0

sort year

by year: tab departement if republican>0.5
by year: tab departement if  elogrepublican_predict0>0.5

clear
log close
