set more off


log using "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\regression results\tableAA2.log", replace


****
* LIML REGRESSIONS 1st STAGE -  LOG RAINFALL
****

** Columns 1 to 6: LIML log rainfall




*********** LIML LOG RAINFALL

** CONTRIBUTIONS DIRECTES ET INDIRECTES



*--Baseline specification  * LIML * Column 1

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\lograin.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml  robust cluster(id) savefirst
outreg2 [*] using tableAA2, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel

*--Control variables  * LIML * Column 2

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\lograin.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*  logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid  (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml  robust cluster(id) savefirst
outreg2 [*] using tableAA2, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel









*******




*********** CONTRIBUTIONS DIRECTES




*--Baseline specification  * LIML * Column 3

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 rain deviation monthly.dta", clear
tsset id year
** Sans la Corse
 drop if id==20
label var logper_capita_tax   "Per capita direct taxes"
**************
gen log_roads=log(villageroad)



do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\lograin.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  logper_capita_tax = logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml  robust cluster(id) savefirst
outreg2 [*] using tableAA2, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel



*--Control variables  * LIML * Column 4

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 rain deviation monthly.dta", clear
tsset id year
** Sans la Corse
 drop if id==20
label var logper_capita_tax   "Per capita direct taxes"
**************
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\lograin.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads  log_aid  (  logper_capita_tax = logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml  robust cluster(id) savefirst
outreg2 [*] using tableAA2, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel





clear


**********************************CONTRIBUTIONS INDIRECTES



*--Baseline specification * LIML * Column 5

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear
rename logboisson_revenue_indirect_tax_  logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"
******
gen log_roads=log(villageroad)
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\lograin.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  logboisson_indirect_tax =   logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre  ), liml  robust cluster(id) savefirst
outreg2 [*] using tableAA2, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel


*--Control variables* LIML * Column 6

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear
rename logboisson_revenue_indirect_tax_  logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"
******
gen log_roads=log(villageroad)
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\lograin.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_* logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid   (  logboisson_indirect_tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml  robust cluster(id) savefirst
outreg2 [*] using tableAA2, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel




*
clear
log close







 