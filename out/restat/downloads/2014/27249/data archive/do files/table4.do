
set more off


log using "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\regression results\table4.log", replace

*** SUM OF CONTRIBUTIONS DIRECTES AND INDIRECTES


use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 turnout.dta", clear

*** Don't forget there is no data for Corsica!

tsset id year


drop if id==20

gen tax=logboisson_revenue_indirect_tax_+logper_capita_tax
label var tax "Per capita taxes" 
label var logper_capita_tax   "Per capita direct taxes"

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

xtreg logturnout_pop tax  iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f



**
**

gen log_roads=log(villageroad)
*
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
*
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"

xtreg logturnout_pop tax  logfertility  logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f




*********** CONTRIBUTIONS DIRECTES

use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres2 turnout.dta", clear

tsset id year

drop if id==20

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

label var logper_capita_tax   "Per capita direct taxes"

xtreg logturnout_pop logper_capita_tax  iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f




*
*

gen log_roads=log(villageroad)
*
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
*
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"

xtreg logturnout_pop logper_capita_tax  logfertility  logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f


*** CONTRIBUTIONS INDIRECTES


use "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata dataset\dataset avec sinistres cont ind2 turnout.dta", clear


*** Don't forget there is no data for Corsica!

tsset id year

gen logturnout_pop=log( turnout_pop)
label var logturnout_pop "Turnout Adult Male Population"

label var logboisson_revenue_indirect_tax_ "Per capita indirect taxes"


xtreg logturnout_pop logboisson_revenue_indirect_tax_  iyear* , fe robust cluster(id)

generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f

*
*
gen log_roads=log(villageroad)
*
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\gvt_disaster_relief.do"
*
do "C:\Documents and Settings\user\My Documents\Income, democracy and religion\Income, democracy and religion, 1876-1889\stata do files\labels turnout.do"

xtreg logturnout_pop logboisson_revenue_indirect_tax_  logfertility  logp_illiterate logp_urbanpop logp_industry logp_service log_roads log_aid iyear* , fe robust cluster(id)
generate f=Fden(e(df_m),e(df_r),e(F))
outreg2 using table4,aster se bd(3) br  addstat(Within R2, e(r2), Adjusted R2, e(r2_a), F-stat, e(F), Prob > F, f, Obs., e(N)) adec(3) label excel
drop f


clear 
log close