set more off


log using "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\regression results\table14.log", replace

*********************************
*FALSIFICATION YEAR+2 OF RESULTS IN TABLE 8 (REDUCED FORM) 
*********************************

** Columns 1 to 6:   liml absolute rainfall deviation from average
** Columns 7 to 12:  liml squared rainfall deviation from average
** Columns 13 to 18: liml one-sided rainfall deviation from average




*******************LIML ABSOLUTE RAINFALL DEVIATION FROM AVERAGE


** CONTRIBUTIONS DIRECTES ET INDIRECTES


*--Baseline specification  *LIML  * Column 1
use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel

*--Control variables  *LIML  * Column 2

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*  logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid  (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel




*******




*********** CONTRIBUTIONS DIRECTES



*--Baseline specification  *LIML  * Column 3

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 rain deviation monthly revision falsification2.dta", clear
tsset id year
** Sans la Corse
 drop if id==20
label var logper_capita_tax   "Per capita direct taxes"
**************
gen log_roads=log(villageroad)



do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  logper_capita_tax = logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel


*--Control variables  *LIML  * Column 4

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 rain deviation monthly revision falsification2.dta", clear
tsset id year
** Sans la Corse
 drop if id==20
label var logper_capita_tax   "Per capita direct taxes"
**************
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads  log_aid (  logper_capita_tax = logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel


clear


**********************************CONTRIBUTIONS INDIRECTES


*--Baseline specification *LIML  * Column 5

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
rename logboisson_revenue_indirect_tax_ logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"
******
gen log_roads=log(villageroad)
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  logboisson_indirect_tax =   logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre  ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel


*--Control variables*LIML  * Column 6

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
rename logboisson_revenue_indirect_tax_ logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"
******
gen log_roads=log(villageroad)
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_* logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid   (  logboisson_indirect_tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel




*
clear

*********** LIML SQUARED RAINFALL DEVIATION FROM AVERAGE

** CONTRIBUTIONS DIRECTES ET INDIRECTES



*--Baseline specification  *LIML  * Column 7

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\sqrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel



*--Control variables  *LIML  * Column 8

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\sqrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*  logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid  (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf 
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel









*******




*********** CONTRIBUTIONS DIRECTES




*--Baseline specification  *LIML  * Column 9

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 rain deviation monthly revision falsification2.dta", clear
tsset id year
** Sans la Corse
 drop if id==20
label var logper_capita_tax   "Per capita direct taxes"
**************
gen log_roads=log(villageroad)



do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\sqrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  logper_capita_tax = logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel



*--Control variables  *LIML  * Column 10

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 rain deviation monthly revision falsification2.dta", clear
tsset id year
** Sans la Corse
 drop if id==20
label var logper_capita_tax   "Per capita direct taxes"
**************
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\sqrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads  log_aid  (  logper_capita_tax = logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf 
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel





clear


**********************************CONTRIBUTIONS INDIRECTES



*--Baseline specification *LIML  * Column 11

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
rename logboisson_revenue_indirect_tax_ logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"
******
gen log_roads=log(villageroad)
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\sqrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  logboisson_indirect_tax =   logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre  ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel


*--Control variables*LIML  * Column 12

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
rename logboisson_revenue_indirect_tax_ logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"
******
gen log_roads=log(villageroad)
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\sqrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_* logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid   (  logboisson_indirect_tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel



*********** LIML ONE SIDED RAINFALL DEVIATION FROM AVERAGE

** CONTRIBUTIONS DIRECTES ET INDIRECTES



*--Baseline specification  *LIML  * Column 13

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\onesidedrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel



*--Control variables  *LIML  * Column 14

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\onesidedrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*  logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid   (  tax =  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel









*******




*********** CONTRIBUTIONS DIRECTES




*--Baseline specification  *LIML  * Column 15

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 rain deviation monthly revision falsification2.dta", clear
tsset id year
** Sans la Corse
 drop if id==20
label var logper_capita_tax   "Per capita direct taxes"
**************
gen log_roads=log(villageroad)



do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\onesidedrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  logper_capita_tax = logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel



*--Control variables  *LIML  * Column 16

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 rain deviation monthly revision falsification2.dta", clear
tsset id year
** Sans la Corse
 drop if id==20
label var logper_capita_tax   "Per capita direct taxes"
**************
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\onesidedrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads  log_aid  (  logper_capita_tax = logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel





clear


**********************************CONTRIBUTIONS INDIRECTES



*--Baseline specification *LIML  * Column 17

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
rename logboisson_revenue_indirect_tax_  logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"
******
gen log_roads=log(villageroad)
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\onesidedrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_*   (  logboisson_indirect_tax =   logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre  ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel


*--Control variables*LIML  * Column 18

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly revision falsification2.dta", clear
rename logboisson_revenue_indirect_tax_  logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"
******
gen log_roads=log(villageroad)
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\onesidedrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

ivreg2 logrepublican iyear_* logfertility logp_illiterate logp_urbanpop logp_industry logp_service  log_roads log_aid   (  logboisson_indirect_tax=  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre ), liml    robust cluster(id) first saverf
outreg2 [*] using table14, aster se bd(3) br  addstat(Centered R2, e(r2), Uncentered R2, e(r2_a), F-stat, e(F), Prob > F, e(Fp), Obs., e(N)) adec(3) label excel




*
clear
log close







