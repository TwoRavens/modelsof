set more off


log using "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\regression results\table5.log", replace



** CONTRIBUTIONS DIRECTES ET INDIRETES For the sum of taxes collected only.



use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2.dta", clear


*** Don't forget there is no data for Corsica!

tsset id year

gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax 
label var tax "Per capita taxes"

*
*
gen log_roads=log(villageroad)


do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"


*--Baseline specification  * OLS * Column 1

xtreg logrepublican tax  iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table5,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f


*--Control variables  * OLS * Column 2

xtreg logrepublican        tax logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid  iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table5 ,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f



*******




*********** CONTRIBUTIONS DIRECTES

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2.dta", clear

tsset id year

** Sans la Corse
 drop if id==20

label var logper_capita_tax   "Per capita direct taxes"
*
*

gen log_roads=log(villageroad)
*

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
*
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"

*---Baseline specification - * OLS * Column 3

xtreg logrepublican logper_capita_tax  iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table5,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f


*--Control variables  * OLS * Column 4


xtreg logrepublican logper_capita_tax  logfertility  logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table5,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f


clear


**********************************CONTRIBUTIONS INDIRECTES


use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2.dta", clear


*** Don't forget there is no data for Corsica!

tsset id year
rename logboisson_revenue_indirect_tax_ logboisson_indirect_tax 
label var logboisson_indirect_tax "Per capita indirect taxes"


*
*
*
gen log_roads=log(villageroad)
*

do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
*
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"



*--Baseline specification  * OLS * Column 5

xtreg logrepublican    logboisson_indirect_tax  iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table5,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f

*--Control variables* OLS * Column 6

xtreg logrepublican logboisson_indirect_tax logfertility logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table5 ,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f


*
clear
log close


