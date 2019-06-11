
** Code for Dec. 7 2017 version of "Economic Policy, Political Constraints, and Foreign Direct Investment in Developing Countries"
** Appendix Tables using EFW Index 


log using VPFDI18AppEFW.log, replace

use VPFDI18.dta, clear

drop if outlier_fLNwdi_fdipercap_ldc5 ==1
drop if fLNwdi_fdipercap_ldc5==.


tsset ccode period

** Appendix EFW Table 2 - no interactions
set more off
foreach var of varlist EXEC_CONST  CHECKS  POLCON3 {
xtpcse fLNwdi_fdipercap_ldc5  `var'  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   if outlier_fLNwdi_fdipercap_ldc5~=1, pairwise corr(ar1)

est store m1`var'17

xtpcse fLNwdi_fdipercap_ldc5  `var'  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr    log_World_FDI if outlier_fLNwdi_fdipercap_ldc5~=1,  pairwise corr(ar1)

est store m15`var'17
}

** Appendix Table 2
esttab m1EXEC_CONST17   m1CHECKS17   m1POLCON317 m15EXEC_CONST17   m15CHECKS17 m15POLCON317 using EFWApp1.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  order(  EXEC_CONST  CHECKS  POLCON3 ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr    log_World_FDI) addnotes(Standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)







** Appendix Table 3 EFW - Percent GDP
set more off


xtpcse fwdi_fdi_ldc5   EFW_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI  if outlier_fwdi_fdi_ldc5~=1,  pairwise corr(ar1)
est store m217

foreach var1 of varlist EXEC_CONST CHECKS POLCON3  {
gen `var1'xEFW_INDEX = `var1'*EFW_INDEX
lab var `var1'xEFW_INDEX ```var1' x EFW INDEX''
xtpcse fwdi_fdi_ldc5   `var1' EFW_INDEX `var1'xEFW_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI  if outlier_fwdi_fdi_ldc5~=1,  pairwise corr(ar1)

estimates store m2_`var1'17, title(`var')
drop `var1'xEFW_INDEX
}
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17 m2_POLCON317  using EFWApp2.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EFW_INDEX POLCON3 POLCON3xEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) order(EFW_INDEX  EXEC_CONST EXEC_CONSTxEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX  EXEC_CONST EXEC_CONSTxEFW_INDEX  POLCON3 POLCON3xEFW_INDEX   ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



** Appendix Table 4 W FDI stock

use VPFDI18.dta, clear
 
 tsset ccode period

 
xtpcse fwdi_fdi_ldc5  EFW_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI   if outlier_fwdi_fdi_ldc5~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEFW_INDEX = `var1'*EFW_INDEX
lab var `var1'xEFW_INDEX ```var1' x EFW INDEX''

xtpcse fwdi_fdi_ldc5   `var1' EFW_INDEX `var1'xEFW_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI  if outlier_fwdi_fdi_ldc5~=1, pairwise corr(ar1)
test `var1' EFW_INDEX `var1'xEFW_INDEX 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEFW_INDEX
}

** Appendix -  with FDI Stock
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17  m2_POLCON317 using EFWApp3.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EFW_INDEX POLCON3 POLCON3xEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI ) order(EFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX  ///
CHECKS CHECKSxEFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX POLCON3 POLCON3xEFW_INDEX  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI  ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)






** Appendix Table 5  EFW  Random Effects

use VPFDI18.dta, clear
tsset ccode period

set more off


xtregar fLNwdi_fdipercap_ldc5   EFW_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI  if outlier_fLNwdi_fdipercap_ldc5~=1
est store m217

foreach var1 of varlist EXEC_CONST CHECKS POLCON3  {
gen `var1'xEFW_INDEX = `var1'*EFW_INDEX
lab var `var1'xEFW_INDEX ```var1' x EFW INDEX''

xtregar fLNwdi_fdipercap_ldc5   `var1' EFW_INDEX `var1'xEFW_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI  if outlier_fLNwdi_fdipercap_ldc5~=1

estimates store m2_`var1'17, title(`var')
drop `var1'xEFW_INDEX
}
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17 m2_POLCON317  using EFWApp4.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) pr2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EFW_INDEX POLCON3 POLCON3xEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) order(EFW_INDEX  EXEC_CONST EXEC_CONSTxEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX  EXEC_CONST EXEC_CONSTxEFW_INDEX  POLCON3 POLCON3xEFW_INDEX   ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) ///
addnotes(Standard errors in parentheses; random effects. $+ p<0.10, * p<0.05 ** p<0.01$)



 
 
** Appendix Table 6  EFW - with country Fixed Effects
set more off


xi: xtpcse fLNwdi_fdipercap_ldc5   EFW_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI i.ccode if outlier_fLNwdi_fdipercap_ldc5~=1, pairwise corr(ar1)
est store m217

foreach var1 of varlist EXEC_CONST CHECKS POLCON3  {
gen `var1'xEFW_INDEX = `var1'*EFW_INDEX
lab var `var1'xEFW_INDEX ```var1' x EFW INDEX''

xi: xtpcse fLNwdi_fdipercap_ldc5   `var1' EFW_INDEX `var1'xEFW_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI i.ccode if outlier_fLNwdi_fdipercap_ldc5~=1, pairwise corr(ar1)

estimates store m2_`var1'17, title(`var')
drop `var1'xEFW_INDEX
}
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17 m2_POLCON317  using EFWApp5.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EFW_INDEX POLCON3 POLCON3xEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) order(EFW_INDEX  EXEC_CONST EXEC_CONSTxEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX  EXEC_CONST EXEC_CONSTxEFW_INDEX  POLCON3 POLCON3xEFW_INDEX   ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) ///
addnotes(Panel-corrected standard errors in parentheses; country coefficients not shown. $+ p<0.10, * p<0.05 ** p<0.01$)







** Appendix Table 7  EFW - w Time Trend

gen Year=year-1970
gen Yearsq=Year*Year
gen Yearcub=Year*Year*Year
lab var Yearsq "Year squared"
lab var Yearcub "Year cubed"

xtpcse fLNwdi_fdipercap_ldc5 EFW_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI Year Yearsq Yearcub  if outlier_fLNwdi_fdipercap_ldc5~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEFW_INDEX = `var1'*EFW_INDEX
lab var `var1'xEFW_INDEX ```var1' x EFW INDEX''

xtpcse fLNwdi_fdipercap_ldc5   `var1' EFW_INDEX `var1'xEFW_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI Year Yearsq Yearcub  if outlier_fLNwdi_fdipercap_ldc5~=1, pairwise corr(ar1)
test `var1' EFW_INDEX `var1'xEFW_INDEX 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEFW_INDEX
}

** Appendix -  with time polynomial
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17  m2_POLCON317  using EFWApp6.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EFW_INDEX POLCON3 POLCON3xEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI Year Yearsq Yearcub) order(EFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX  ///
CHECKS CHECKSxEFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX POLCON3 POLCON3xEFW_INDEX  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI Year Yearsq Yearcub ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



** Appendix Table 8  EFW - Extra controls (phones, exports)

use VPFDI18.dta, clear

tsset ccode period

set more off


xtpcse fLNwdi_fdipercap_ldc5 EFW_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI wdi_expgsgdp log_phone if outlier_fLNwdi_fdipercap_ldc5~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEFW_INDEX = `var1'*EFW_INDEX
lab var `var1'xEFW_INDEX ```var1' x EFW INDEX''

xtpcse fLNwdi_fdipercap_ldc5   `var1' EFW_INDEX `var1'xEFW_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI wdi_expgsgdp log_phone  if outlier_fLNwdi_fdipercap_ldc5~=1, pairwise corr(ar1)
test `var1' EFW_INDEX `var1'xEFW_INDEX 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEFW_INDEX
}

** Appendix -  with time polynomial
esttab  m217  m2_EXEC_CONST17  m2_CHECKS17  m2_POLCON317 using EFWApp7.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EFW_INDEX POLCON3 POLCON3xEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI wdi_expgsgdp log_phone ) order(EFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX  ///
CHECKS CHECKSxEFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX POLCON3 POLCON3xEFW_INDEX  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI wdi_expgsgdp log_phone  ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



** Appendix Table 8  EFW - with Investment Promotion Agency dummy

use VPFDI18.dta, clear

tsset ccode period
set more off


xtpcse fLNwdi_fdipercap_ldc5 EFW_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI DIPA  if outlier_fLNwdi_fdipercap_ldc5~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEFW_INDEX = `var1'*EFW_INDEX
lab var `var1'xEFW_INDEX ```var1' x EFW INDEX''

xtpcse fLNwdi_fdipercap_ldc5   `var1' EFW_INDEX `var1'xEFW_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI DIPA  if outlier_fLNwdi_fdipercap_ldc5~=1, pairwise corr(ar1)
test `var1' EFW_INDEX `var1'xEFW_INDEX 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEFW_INDEX
}

** Appendix -  with time polynomial
esttab  m217  m2_EXEC_CONST17  m2_CHECKS17  m2_POLCON317 using EFWApp8.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EFW_INDEX POLCON3 POLCON3xEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI DIPA) order(EFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX  ///
CHECKS CHECKSxEFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX POLCON3 POLCON3xEFW_INDEX  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI DIPA ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)

** NOTE: Around half of observations dropped



** Appendix Table 9  EFW - oil rent economies vs. non-oil rent economies


use VPFDI18.dta, clear

tsset ccode period
set more off



** Appendix w oil
 foreach var1 of varlist  POLCON3 CHECKS EXEC_CONST {
gen `var1'xEFW_INDEX = `var1'*EFW_INDEX

xtpcse fLNwdi_fdipercap_ldc5  `var1' EFW_INDEX `var1'xEFW_INDEX GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_oilgaspc  log_World_FDI   if outlier_fLNwdi_fdipercap_ldc5~=1 & wdi_oilrent>1 & wdi_oilrent~=., pairwise corr(ar1)

estimates store m3_`var1'17oil, title(`var')


xtpcse fLNwdi_fdipercap_ldc5  `var1' EFW_INDEX `var1'xEFW_INDEX  GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI   if outlier_fLNwdi_fdipercap_ldc5~=1 & wdi_oilrent<=1, pairwise corr(ar1)

estimates store m3_`var1'17nooil, title(`var')

drop `var1'xEFW_INDEX
}
esttab m3_EXEC_CONST17oil  m3_CHECKS17oil m3_POLCON317oil m3_EXEC_CONST17nooil m3_CHECKS17nooil m3_POLCON317nooil using EFWApp9.tex, nodepvars nonumbers noconstant mtitles("(Oil rents)" "(Oil rents)" "(Oil rents)" "(Non-oil)" "(Non-oil)" "(Non-oil)") ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01) order(EFW_INDEX  EXEC_CONST EXEC_CONSTxEFW_INDEX  ///
CHECKS CHECKSxEFW_INDEX POLCON3 POLCON3xEFW_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_oilgaspc  log_World_FDI)




log close
