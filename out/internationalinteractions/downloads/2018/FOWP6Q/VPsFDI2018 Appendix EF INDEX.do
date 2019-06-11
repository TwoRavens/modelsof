

** Code for Dec. 7 2017 version of "Economic Policy, Political Constraints, and Foreign Direct Investment in Developing Countries"
** Appendix Tables using EF Index 


log using VPFDI18AppEF.log, replace

use VPFDI18.dta, clear

tsset ccode year
drop if outlier_fLNwdi_fdipercap_ldc ==1
drop if fLNwdi_fdipercap_ldc==.



** Appendix Table 11
set more off
foreach var of varlist EXEC_CONST  CHECKS  POLCON3 {
xtpcse fLNwdi_fdipercap_ldc  `var'  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)

est store m1`var'17

xtpcse fLNwdi_fdipercap_ldc  `var'  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr    log_World_FDI if outlier_fLNwdi_fdipercap_ldc~=1,  pairwise corr(ar1)

est store m15`var'17
}

** Appendix Table 11
esttab m1EXEC_CONST17   m1CHECKS17   m1POLCON317 m15EXEC_CONST17   m15CHECKS17 m15POLCON317 using EFApp1.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  order(  EXEC_CONST  CHECKS  POLCON3 ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr    log_World_FDI) addnotes(Standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



 
** Appendix Table 12 EF - Percent GDP
set more off


xtpcse fwdi_fdi_ldc   EF_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI  if outlier_fwdi_fdi_ldc~=1,  pairwise corr(ar1)
est store m217

foreach var1 of varlist EXEC_CONST CHECKS POLCON3  {
gen `var1'xEF_INDEX = `var1'*EF_INDEX
lab var `var1'xEF_INDEX ```var1' x EF INDEX''
xtpcse fwdi_fdi_ldc   `var1' EF_INDEX `var1'xEF_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI  if outlier_fwdi_fdi_ldc~=1,  pairwise corr(ar1)

estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INDEX
}
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17 m2_POLCON317  using EFApp2.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INDEX POLCON3 POLCON3xEF_INDEX ///
CHECKS CHECKSxEF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) order(EF_INDEX  EXEC_CONST EXEC_CONSTxEF_INDEX ///
CHECKS CHECKSxEF_INDEX  EXEC_CONST EXEC_CONSTxEF_INDEX  POLCON3 POLCON3xEF_INDEX   ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



** Appendix Table 13 EF  W FDI stock

use VPFDI18.dta, clear

 tsset ccode year

 
xtpcse fwdi_fdi_ldc  EF_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI   if outlier_fwdi_fdi_ldc~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEF_INDEX = `var1'*EF_INDEX
lab var `var1'xEF_INDEX ```var1' x EF INDEX''

xtpcse fwdi_fdi_ldc   `var1' EF_INDEX `var1'xEF_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI  if outlier_fwdi_fdi_ldc~=1, pairwise corr(ar1)
test `var1' EF_INDEX `var1'xEF_INDEX 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INDEX
}

** Appendix -  with FDI Stock
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17  m2_POLCON317 using EFApp3.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INDEX POLCON3 POLCON3xEF_INDEX ///
CHECKS CHECKSxEF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI ) order(EF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX  ///
CHECKS CHECKSxEF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX POLCON3 POLCON3xEF_INDEX  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI  ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



 
** Appendix Table 14 EF - Random Effects

use VPFDI18.dta, clear
tsset ccode year

set more off


xtregar fLNwdi_fdipercap_ldc   EF_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI  if outlier_fLNwdi_fdipercap_ldc~=1
est store m217

foreach var1 of varlist EXEC_CONST CHECKS POLCON3  {
gen `var1'xEF_INDEX = `var1'*EF_INDEX
lab var `var1'xEF_INDEX ```var1' x EF INDEX''

xtregar fLNwdi_fdipercap_ldc   `var1' EF_INDEX `var1'xEF_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI  if outlier_fLNwdi_fdipercap_ldc~=1

estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INDEX
}
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17 m2_POLCON317  using EFApp4.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) pr2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INDEX POLCON3 POLCON3xEF_INDEX ///
CHECKS CHECKSxEF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) order(EF_INDEX  EXEC_CONST EXEC_CONSTxEF_INDEX ///
CHECKS CHECKSxEF_INDEX  EXEC_CONST EXEC_CONSTxEF_INDEX  POLCON3 POLCON3xEF_INDEX   ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) ///
addnotes(Standard errors in parentheses; random effects. $+ p<0.10, * p<0.05 ** p<0.01$)



 
 
** Appendix Table 15 EF - with country Fixed Effects
set more off


xi: xtpcse fLNwdi_fdipercap_ldc   EF_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI i.ccode if outlier_fLNwdi_fdipercap_ldc~=1,  pairwise corr(ar1)
est store m217

foreach var1 of varlist EXEC_CONST CHECKS POLCON3  {
gen `var1'xEF_INDEX = `var1'*EF_INDEX
lab var `var1'xEF_INDEX ```var1' x EF INDEX''

xi: xtpcse fLNwdi_fdipercap_ldc   `var1' EF_INDEX `var1'xEF_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI i.ccode if outlier_fLNwdi_fdipercap_ldc~=1,  pairwise corr(ar1)

estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INDEX
}
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17 m2_POLCON317  using EFApp5.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) pr2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INDEX POLCON3 POLCON3xEF_INDEX ///
CHECKS CHECKSxEF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) order(EF_INDEX  EXEC_CONST EXEC_CONSTxEF_INDEX ///
CHECKS CHECKSxEF_INDEX  EXEC_CONST EXEC_CONSTxEF_INDEX  POLCON3 POLCON3xEF_INDEX   ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) ///
addnotes(Panel-corrected standard errors in parentheses; coefficients for country fixed effects not shown. $+ p<0.10, * p<0.05 ** p<0.01$)






** Appendix Table 16 EF - with time trend

gen Year=year-1970
gen Yearsq=Year*Year
gen Yearcub=Year*Year*Year
lab var Yearsq "Year squared"
lab var Yearcub "Year cubed"

xtpcse fLNwdi_fdipercap_ldc EF_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI Year Yearsq Yearcub  if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEF_INDEX = `var1'*EF_INDEX
lab var `var1'xEF_INDEX ```var1' x EF INDEX''

xtpcse fLNwdi_fdipercap_ldc   `var1' EF_INDEX `var1'xEF_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI Year Yearsq Yearcub  if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
test `var1' EF_INDEX `var1'xEF_INDEX 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INDEX
}

** Appendix -  with time polynomial
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17  m2_POLCON317  using EFApp6.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INDEX POLCON3 POLCON3xEF_INDEX ///
CHECKS CHECKSxEF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI Year Yearsq Yearcub) order(EF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX  ///
CHECKS CHECKSxEF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX POLCON3 POLCON3xEF_INDEX  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI Year Yearsq Yearcub ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)




** Appendix Table 17 EF - with additional controls - exports and phones 


xtpcse fLNwdi_fdipercap_ldc EF_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI wdi_expgsgdp log_phone if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEF_INDEX = `var1'*EF_INDEX
lab var `var1'xEF_INDEX ```var1' x EF INDEX''

xtpcse fLNwdi_fdipercap_ldc   `var1' EF_INDEX `var1'xEF_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI wdi_expgsgdp log_phone  if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
test `var1' EF_INDEX `var1'xEF_INDEX 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INDEX
}

** Appendix -  with time polynomial
esttab  m217  m2_EXEC_CONST17  m2_CHECKS17  m2_POLCON317 using EFApp7.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INDEX POLCON3 POLCON3xEF_INDEX ///
CHECKS CHECKSxEF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI wdi_expgsgdp log_phone ) order(EF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX  ///
CHECKS CHECKSxEF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX POLCON3 POLCON3xEF_INDEX  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI wdi_expgsgdp log_phone  ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)





** Appendix Table 18 EF - with investment promotion agency dummy


use VPFDI18.dta, clear

tsset ccode year
set more off


xtpcse fLNwdi_fdipercap_ldc EF_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI DIPA  if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEF_INDEX = `var1'*EF_INDEX
lab var `var1'xEF_INDEX ```var1' x EF INDEX''

xtpcse fLNwdi_fdipercap_ldc   `var1' EF_INDEX `var1'xEF_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI DIPA  if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
test `var1' EF_INDEX `var1'xEF_INDEX 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INDEX
}

** Appendix -  with time polynomial
esttab  m217  m2_EXEC_CONST17  m2_CHECKS17  m2_POLCON317 using EFApp8.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INDEX POLCON3 POLCON3xEF_INDEX ///
CHECKS CHECKSxEF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI DIPA) order(EF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX  ///
CHECKS CHECKSxEF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX POLCON3 POLCON3xEF_INDEX  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI DIPA ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)


use VPFDI18.dta, clear

tsset ccode year
set more off



** Appendix Table 19 EF w oil
 foreach var1 of varlist  POLCON3 CHECKS EXEC_CONST {
gen `var1'xEF_INDEX = `var1'*EF_INDEX

xtpcse fLNwdi_fdipercap_ldc  `var1' EF_INDEX `var1'xEF_INDEX GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_oilgaspc  log_World_FDI   if outlier_fLNwdi_fdipercap_ldc~=1 & wdi_oilrent>1 & wdi_oilrent~=., pairwise corr(ar1)

estimates store m3_`var1'17oil, title(`var')


xtpcse fLNwdi_fdipercap_ldc  `var1' EF_INDEX `var1'xEF_INDEX  GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI   if outlier_fLNwdi_fdipercap_ldc~=1 & wdi_oilrent<=1, pairwise corr(ar1)

estimates store m3_`var1'17nooil, title(`var')

drop `var1'xEF_INDEX
}
esttab m3_EXEC_CONST17oil  m3_CHECKS17oil m3_POLCON317oil m3_EXEC_CONST17nooil m3_CHECKS17nooil m3_POLCON317nooil using EFApp9.tex, nodepvars nonumbers noconstant mtitles("(Oil rents)" "(Oil rents)" "(Oil rents)" "(Non-oil)" "(Non-oil)" "(Non-oil)") ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01) order(EF_INDEX  EXEC_CONST EXEC_CONSTxEF_INDEX  ///
CHECKS CHECKSxEF_INDEX POLCON3 POLCON3xEF_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_oilgaspc  log_World_FDI)


log close
