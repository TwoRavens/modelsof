


** Code for Dec. 7 2017 version of "Economic Policy, Political Constraints, and Foreign Direct Investment in Developing Countries"
** Appendix Tables with EF Investmnet policy

log using VPFDI18AppEFinvest.log, replace


use VPFDI18.dta, clear

tsset ccode year
drop if outlier_fLNwdi_fdipercap_ldc ==1
drop if fLNwdi_fdipercap_ldc==.



** Appendix  Table 20
set more off
foreach var of varlist EXEC_CONST  CHECKS  POLCON3 {
xtpcse fLNwdi_fdipercap_ldc  `var'  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)

est store m1`var'17

xtpcse fLNwdi_fdipercap_ldc  `var'  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr    log_World_FDI if outlier_fLNwdi_fdipercap_ldc~=1,  pairwise corr(ar1)

est store m15`var'17
}

** Appendix Table 20
esttab m1EXEC_CONST17   m1CHECKS17   m1POLCON317 m15EXEC_CONST17   m15CHECKS17 m15POLCON317 using EFINVESTApp1.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" "(6)") ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  order(  EXEC_CONST  CHECKS  POLCON3 ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr    log_World_FDI) addnotes(Standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



 
** Appendix  Table 21 EF Invest - Percent GDP
set more off


xtpcse fwdi_fdi_ldc   EF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI  if outlier_fwdi_fdi_ldc~=1,  pairwise corr(ar1)
est store m217

foreach var1 of varlist EXEC_CONST CHECKS POLCON3  {
gen `var1'xEF_INVEST = `var1'*EF_INVEST
lab var `var1'xEF_INVEST ```var1' x EF INVEST''
xtpcse fwdi_fdi_ldc   `var1' EF_INVEST `var1'xEF_INVEST GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI  if outlier_fwdi_fdi_ldc~=1,  pairwise corr(ar1)

estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INVEST
}
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17 m2_POLCON317  using EFINVESTApp2.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INVEST POLCON3 POLCON3xEF_INVEST ///
CHECKS CHECKSxEF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) order(EF_INVEST  EXEC_CONST EXEC_CONSTxEF_INVEST ///
CHECKS CHECKSxEF_INVEST  EXEC_CONST EXEC_CONSTxEF_INVEST  POLCON3 POLCON3xEF_INVEST   ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



** Appendix  Table 22 EF Invest W FDI stock

use VPFDI18.dta, clear


 tsset ccode year


xtpcse fwdi_fdi_ldc  EF_INVEST GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI   if outlier_fwdi_fdi_ldc~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEF_INVEST = `var1'*EF_INVEST
lab var `var1'xEF_INVEST ```var1' x EF INVEST''

xtpcse fwdi_fdi_ldc   `var1' EF_INVEST `var1'xEF_INVEST GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI  if outlier_fwdi_fdi_ldc~=1, pairwise corr(ar1)
test `var1' EF_INVEST `var1'xEF_INVEST 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INVEST
}

** Appendix -  with FDI Stock
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17  m2_POLCON317 using EFINVESTApp3.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INVEST POLCON3 POLCON3xEF_INVEST ///
CHECKS CHECKSxEF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI ) order(EF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST  ///
CHECKS CHECKSxEF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST POLCON3 POLCON3xEF_INVEST  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_FDI_Stock log_World_FDI  ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



use VPFDI18.dta, clear


tsset ccode year


 
** Appendix  Table 23 EF INvest - Random Effects
set more off


xtregar fLNwdi_fdipercap_ldc   EF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI  if outlier_fLNwdi_fdipercap_ldc~=1
est store m217

foreach var1 of varlist EXEC_CONST CHECKS POLCON3  {
gen `var1'xEF_INVEST = `var1'*EF_INVEST
lab var `var1'xEF_INVEST ```var1' x EF INVEST''

xtregar fLNwdi_fdipercap_ldc   `var1' EF_INVEST `var1'xEF_INVEST GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI  if outlier_fLNwdi_fdipercap_ldc~=1

estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INVEST
}
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17 m2_POLCON317  using EFINVESTApp4.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) pr2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INVEST POLCON3 POLCON3xEF_INVEST ///
CHECKS CHECKSxEF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) order(EF_INVEST  EXEC_CONST EXEC_CONSTxEF_INVEST ///
CHECKS CHECKSxEF_INVEST  EXEC_CONST EXEC_CONSTxEF_INVEST  POLCON3 POLCON3xEF_INVEST   ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) ///
addnotes(Standard errors in parentheses; random effects. $+ p<0.10, * p<0.05 ** p<0.01$)



 
 
** Appendix  Table 24 EF Invest - Fixed Effects
set more off


xi: xtpcse fLNwdi_fdipercap_ldc   EF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI i.ccode if outlier_fLNwdi_fdipercap_ldc~=1,  pairwise corr(ar1)
est store m217

foreach var1 of varlist EXEC_CONST CHECKS POLCON3  {
gen `var1'xEF_INVEST = `var1'*EF_INVEST
lab var `var1'xEF_INVEST ```var1' x EF INVEST''

xi: xtpcse fLNwdi_fdipercap_ldc   `var1' EF_INVEST `var1'xEF_INVEST GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI i.ccode if outlier_fLNwdi_fdipercap_ldc~=1,  pairwise corr(ar1)

estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INVEST
}
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17 m2_POLCON317  using EFINVESTApp5.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) pr2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INVEST POLCON3 POLCON3xEF_INVEST ///
CHECKS CHECKSxEF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) order(EF_INVEST  EXEC_CONST EXEC_CONSTxEF_INVEST ///
CHECKS CHECKSxEF_INVEST  EXEC_CONST EXEC_CONSTxEF_INVEST  POLCON3 POLCON3xEF_INVEST   ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) ///
addnotes(Panel-corrected standard errors in parentheses; coefficients for country fixed effects not shown. $+ p<0.10, * p<0.05 ** p<0.01$)






** Appendix  Table 25 EF Invest with time trends

gen Year=year-1970
gen Yearsq=Year*Year
gen Yearcub=Year*Year*Year
lab var Yearsq "Year squared"
lab var Yearcub "Year cubed"

xtpcse fLNwdi_fdipercap_ldc  EF_INVEST GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI Year Yearsq Yearcub  if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEF_INVEST = `var1'*EF_INVEST
lab var `var1'xEF_INVEST ```var1' x EF INVEST''

xtpcse fLNwdi_fdipercap_ldc   `var1' EF_INVEST `var1'xEF_INVEST GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI Year Yearsq Yearcub  if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
test `var1' EF_INVEST `var1'xEF_INVEST 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INVEST
}

** Appendix -  with time polynomial
esttab  m217 m2_EXEC_CONST17 m2_CHECKS17  m2_POLCON317  using EFINVESTApp6.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INVEST POLCON3 POLCON3xEF_INVEST ///
CHECKS CHECKSxEF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI Year Yearsq Yearcub) order(EF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST  ///
CHECKS CHECKSxEF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST POLCON3 POLCON3xEF_INVEST  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI Year Yearsq Yearcub ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



** Appendix  Table 25 EF Invest with additional controls (phones, exports)



xtpcse fLNwdi_fdipercap_ldc EF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI wdi_expgsgdp log_phone if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEF_INVEST = `var1'*EF_INVEST
lab var `var1'xEF_INVEST ```var1' x EF INVEST''

xtpcse fLNwdi_fdipercap_ldc   `var1' EF_INVEST `var1'xEF_INVEST GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI wdi_expgsgdp log_phone  if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
test `var1' EF_INVEST `var1'xEF_INVEST 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INVEST
}

** Appendix -  with time polynomial
esttab  m217  m2_EXEC_CONST17  m2_CHECKS17  m2_POLCON317 using EFINVESTApp7.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INVEST POLCON3 POLCON3xEF_INVEST ///
CHECKS CHECKSxEF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI wdi_expgsgdp log_phone ) order(EF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST  ///
CHECKS CHECKSxEF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST POLCON3 POLCON3xEF_INVEST  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI wdi_expgsgdp log_phone  ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



** Appendix  Table 25 EF Invest with investment promotion agency dummy


use VPFDI18.dta, clear


tsset ccode year
set more off


xtpcse fLNwdi_fdipercap_ldc EF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI DIPA  if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
est store m217

set more off
foreach var1 of varlist EXEC_CONST  CHECKS  POLCON3 {
gen `var1'xEF_INVEST = `var1'*EF_INVEST
lab var `var1'xEF_INVEST ```var1' x EF INVEST''

xtpcse fLNwdi_fdipercap_ldc   `var1' EF_INVEST `var1'xEF_INVEST GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI DIPA  if outlier_fLNwdi_fdipercap_ldc~=1, pairwise corr(ar1)
test `var1' EF_INVEST `var1'xEF_INVEST 
*outtex, level
estimates store m2_`var1'17, title(`var')
drop `var1'xEF_INVEST
}

** Appendix -  with time polynomial
esttab  m217  m2_EXEC_CONST17  m2_CHECKS17  m2_POLCON317 using EFINVESTApp8.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EF_INVEST POLCON3 POLCON3xEF_INVEST ///
CHECKS CHECKSxEF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI DIPA) order(EF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST  ///
CHECKS CHECKSxEF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST POLCON3 POLCON3xEF_INVEST  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_World_FDI DIPA ) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



use VPFDI18.dta, clear


tsset ccode year
set more off



** Appendix w oil
 foreach var1 of varlist  POLCON3 CHECKS EXEC_CONST {
gen `var1'xEF_INVEST = `var1'*EF_INVEST

xtpcse fLNwdi_fdipercap_ldc  `var1' EF_INVEST `var1'xEF_INVEST GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_oilgaspc  log_World_FDI   if outlier_fLNwdi_fdipercap_ldc~=1 & wdi_oilrent>1 & wdi_oilrent~=., pairwise corr(ar1)

estimates store m3_`var1'17oil, title(`var')


xtpcse fLNwdi_fdipercap_ldc  `var1' EF_INVEST `var1'xEF_INVEST  GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI   if outlier_fLNwdi_fdipercap_ldc~=1 & wdi_oilrent<=1, pairwise corr(ar1)

estimates store m3_`var1'17nooil, title(`var')

drop `var1'xEF_INVEST
}
esttab m3_EXEC_CONST17oil  m3_CHECKS17oil m3_POLCON317oil m3_EXEC_CONST17nooil m3_CHECKS17nooil m3_POLCON317nooil using EFINVESTApp9.tex, nodepvars nonumbers noconstant mtitles("(Oil rents)" "(Oil rents)" "(Oil rents)" "(Non-oil)" "(Non-oil)" "(Non-oil)") ///
cells(b(star fmt(4)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01) order(EF_INVEST  EXEC_CONST EXEC_CONSTxEF_INVEST  ///
CHECKS CHECKSxEF_INVEST POLCON3 POLCON3xEF_INVEST ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_oilgaspc  log_World_FDI)



log close
