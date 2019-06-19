set more off

log using "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\regression results\tableA4.log", replace

************************
*turnout_pop
************************



*** SUM OF CONTRIBUTIONS DIRECTES AND INDIRECTES


* Column 1

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 turnout.dta", clear

*** Don't forget there is no data for Corsica!

tsset id year
drop if id==20

gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax   "Per capita taxes"

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

gen log_rainelectionday=log(rainelectionday)
replace log_rainelectionday=0 if log_rainelectionday==.
label var log_rainelectionday "Rainfall on Election Day"

gen log_roads=log(villageroad)
*
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"

xtreg logturnout_pop tax  log_rainelectionday  iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f

* Column 2

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 turnout.dta", clear

*** Don't forget there is no data for Corsica!

tsset id year
drop if id==20

gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax   "Per capita taxes"

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

gen log_rainelectionday=log(rainelectionday)
replace log_rainelectionday=0 if log_rainelectionday==.
label var log_rainelectionday "Rainfall on Election Day"

gen log_roads=log(villageroad)
*
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"

xtreg logturnout_pop tax  log_rainelectionday logfertility  logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f



* Column 3

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"


xtreg logturnout_pop tax  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre  iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f

* Column 4

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20
gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"
******
gen log_roads=log(villageroad)

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"


xtreg logturnout_pop tax  logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre logfertility  logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f


*********** CONTRIBUTIONS DIRECTES


* Column 5


use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 turnout.dta", clear

tsset id year
drop if id==20

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

label var logper_capita_tax   "Per capita direct taxes"

gen log_roads=log(villageroad)

gen log_rainelectionday=log(rainelectionday)
replace log_rainelectionday=0 if log_rainelectionday==.
label var log_rainelectionday "Rainfall on Election Day"

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"

xtreg logturnout_pop logper_capita_tax log_rainelectionday  iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f

* Column 6

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 turnout.dta", clear

tsset id year
drop if id==20

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

label var logper_capita_tax   "Per capita direct taxes"

gen log_roads=log(villageroad)

gen log_rainelectionday=log(rainelectionday)
replace log_rainelectionday=0 if log_rainelectionday==.
label var log_rainelectionday "Rainfall on Election Day"

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"

xtreg logturnout_pop logper_capita_tax log_rainelectionday logfertility  logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f

* Column 7

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 rain deviation monthly.dta", clear
tsset id year
** Sans la Corse
 drop if id==20
label var logper_capita_tax   "Per capita direct taxes"
**************
gen log_roads=log(villageroad)

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

xtreg logturnout_pop  logper_capita_tax logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f

* Column 8

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 rain deviation monthly.dta", clear
tsset id year
** Sans la Corse
 drop if id==20
label var logper_capita_tax   "Per capita direct taxes"
**************
gen log_roads=log(villageroad)

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

xtreg logturnout_pop  logper_capita_tax logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre logfertility  logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f


*** CONTRIBUTIONS INDIRECTES

* Column 9

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 turnout.dta", clear


*** Don't forget there is no data for Corsica!

tsset id year

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

rename logboisson_revenue_indirect_tax_ logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"

gen log_roads=log(villageroad)

gen log_rainelectionday=log(rainelectionday)
replace log_rainelectionday=0 if log_rainelectionday==.
label var log_rainelectionday "Rainfall on Election Day"


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"

xtreg logturnout_pop logboisson_indirect_tax log_rainelectionday iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f

* Column 10

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 turnout.dta", clear


*** Don't forget there is no data for Corsica!

tsset id year

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

rename logboisson_revenue_indirect_tax_ logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"

gen log_roads=log(villageroad)

gen log_rainelectionday=log(rainelectionday)
replace log_rainelectionday=0 if log_rainelectionday==.
label var log_rainelectionday "Rainfall on Election Day"


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"

xtreg logturnout_pop logboisson_indirect_tax log_rainelectionday logfertility  logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f


* Column 11


use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear

rename logboisson_revenue_indirect_tax_ logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"

******
gen log_roads=log(villageroad)
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

xtreg logturnout_pop logboisson_indirect_tax logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre  iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f

* Column 12

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 rain deviation monthly.dta", clear

rename logboisson_revenue_indirect_tax_ logboisson_indirect_tax
label var logboisson_indirect_tax "Per capita indirect taxes"

******
gen log_roads=log(villageroad)
*** Don't forget there is no data for Corsica!
tsset id year
drop if id==20

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\absrain.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels.do"

xtreg logturnout_pop logboisson_indirect_tax logjanvier logfevrier logmars logavril logjuin logjuillet logaout logseptembre logfertility  logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid  iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using tableA4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f


clear
log close
