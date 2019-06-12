

 
** Code for Dec. 20 2017 version of "Economic Policy, Political Constraints, and Foreign Direct Investment in Developing Countries"

log using VPFDI18.log, replace

use VPFDI18.dta, clear


tsset ccode year


*** FIGURE 1 

ciplot fLNwdi_fdipercap_ldc5 if outlier_fLNwdi_fdipercap_ldc5~=1 & EFW_INDEX~=. , by(year)  legend(off) scheme(s1mono)
graph export fdipercapLN_ciplot_17_nov.pdf, replace



** Figure 2, left side - EFW Policy measures over time
** Standardized to N(0,1)
sort year
foreach var2 of varlist EFW_INDEX-EFW_REG {
by year: egen ma`var2' = mean(`var2') if   fLNwdi_fdipercap_ldc5~=. 
}
lab var maEFW_GOVSIZE "GOVSIZE"
lab var maEFW_PROPRIGHTS "PROP"
lab var maEFW_MONEY "MONEY"
lab var maEFW_TRADE "TRADE"
lab var maEFW_REG "REG"
lab var maEFW_INDEX "EFW INDEX"

drop if year<1970


replace period=9 if year==2010
drop if period==. 

twoway  (tsline maEFW_INDEX, recast(connected) msymbol(point)) ///
(tsline maEFW_GOVSIZE, recast(connected) msymbol(circle)) ///
(tsline maEFW_PROPRIGHTS, recast(connected) msymbol(square)) ///
(tsline maEFW_MONEY, recast(connected) msymbol(diamond)) ///
(tsline maEFW_TRADE, recast(connected) msymbol(plus)) ///
(tsline maEFW_REG, recast(connected) msymbol(triangle)) ///
, scheme(s1mono)

graph export policytimeplot_17_nov.pdf, replace
** NOTE - normalized after OECD and OFC data deleted. 



** Figure 2, right side - Political Constraint measures over time
** Normalized to N(0,1)
sort year
foreach var of varlist POLCON3 CHECKS EXEC_CONST  {
by year: egen ma`var'=mean(`var')
}

lab var maPOLCON3 "POLCON3"
lab var maCHECKS "LOG CHECKS"
lab var maEXEC_CONST "EXEC CONST"

twoway  (tsline maPOLCON3, recast(connected) msymbol(circle)) ///
(tsline maCHECKS, recast(connected) msymbol(diamond)) ///
(tsline maEXEC_CONST, recast(connected) msymbol(plus)) if year>1969 & year<2015 ///
, scheme(s1mono)

graph export polcon_timeplot_17_nov.pdf, replace



** Distribution of poltical constraints measures

hist POLCON3 , name(polcon3, replace)
hist CHECKS , name(checks, replace)
hist EXEC_CONST , name(execconst, replace)

graph combine execconst checks polcon3   , ycommon col(3)  title()
graph export polconhists.pdf, replace



use VPFDI18.dta, clear

** Figure 3
** Scatter plot to show common support
scatter EFW_INDEX POLCON3 if period~=. & outlier_fLNwdi_fdipercap_ldc5~=1
graph export scatter1_nov.pdf, replace 
scatter EFW_INDEX CHECKS if period~=. & outlier_fLNwdi_fdipercap_ldc5~=1
graph export scatter2_nov.pdf, replace 
scatter EFW_INDEX EXEC_CONST if period~=. & outlier_fLNwdi_fdipercap_ldc5~=1
graph export scatter3_nov.pdf, replace 
** NOTE: The high checks observations are India



** Descriptive Statistics 
** APPENDIX


use VPFDI18.dta, clear
set more off
tsset ccode period
drop if EFW_INDEX==.
sutex fLNwdi_fdipercap_ldc5 fwdi_fdipercap_ldc5 POLCON3 CHECKS EXEC_CONST EFW_INDEX   GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI if outlier_fLNwdi_fdipercap_ldc5~=1  & fLNwdi_fdipercap_ldc5~=. & period~=. & EFW_INDEX~=., minmax digits(2)


use VPFDI18.dta, clear
set more off
tsset ccode year
drop if EF_INDEX==.
sutex fLNwdi_fdipercap_ldc fwdi_fdipercap_ldc POLCON3 CHECKS EXEC_CONST EF_INDEX  EF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr    log_World_FDI if  fLNwdi_fdipercap_ldc~=. & outlier_fLNwdi_fdipercap_ldc~=1 , minmax digits(2)





*** REGRESSION TABLE 1 - EFW Index data

use VPFDI18.dta, clear
set more off

gen EXEC_CONSTxEFW_INDEX=EXEC_CONST*EFW_INDEX
lab var EXEC_CONSTxEFW_INDEX "EXEC CONST x EFW Index"

gen CHECKSxEFW_INDEX=CHECKS*EFW_INDEX
lab var CHECKSxEFW_INDEX "CHECKS x EFW Index"

gen POLCON3xEFW_INDEX=POLCON3*EFW_INDEX
lab var POLCON3xEFW_INDEX "POLCON3 x EFW Index"

tsset ccode period
drop if outlier_fLNwdi_fdipercap_ldc5 ==1
drop if fLNwdi_fdipercap_ldc5==.

set more off
xtpcse fLNwdi_fdipercap_ldc5   EFW_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m1

set more off
xtpcse fLNwdi_fdipercap_ldc5   EFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m1_EXEC_CONST

set more off
xtpcse fLNwdi_fdipercap_ldc5   EFW_INDEX CHECKS  CHECKSxEFW_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m1_CHECKS

set more off
xtpcse fLNwdi_fdipercap_ldc5   EFW_INDEX POLCON3 POLCON3xEFW_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m1_POLCON3



** TABLE 1 in paper
esttab  m1 m1_EXEC_CONST m1_CHECKS  m1_POLCON3 using VPFDI_172_nov.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" "(5)" ) ///
cells(b(star fmt(2)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01)  keep(EFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX POLCON3 POLCON3xEFW_INDEX   ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) order(EFW_INDEX EXEC_CONST EXEC_CONSTxEFW_INDEX ///
CHECKS CHECKSxEFW_INDEX  POLCON3 POLCON3xEFW_INDEX  ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



** Regression Table 2 - EF INDEX
 
use VPFDI18.dta, clear

 set more off

tsset ccode year 
drop if  outlier_fLNwdi_fdipercap_ldc==1
 
 ** Drop cases missing all political constraints and policy measure
drop if POLCON3==. & CHECKS==. & EXEC_CONST==. & EF_INDEX==.

gen EXEC_CONSTxEF_INDEX=EXEC_CONST*EF_INDEX
lab var EXEC_CONSTxEF_INDEX "EXEC CONST x EF Index"

gen CHECKSxEF_INDEX=CHECKS*EF_INDEX
lab var CHECKSxEF_INDEX "CHECKS x EF Index"

gen POLCON3xEF_INDEX=POLCON3*EF_INDEX
lab var POLCON3xEF_INDEX "POLCON3 x EF Index"

set more off
xtpcse fLNwdi_fdipercap_ldc   EF_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m2

set more off
xtpcse fLNwdi_fdipercap_ldc  EF_INDEX EXEC_CONST EXEC_CONSTxEF_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m2_EXEC_CONST

set more off
xtpcse fLNwdi_fdipercap_ldc   EF_INDEX CHECKS  CHECKSxEF_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m2_CHECKS

set more off
xtpcse fLNwdi_fdipercap_ldc   EF_INDEX POLCON3 POLCON3xEF_INDEX GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m2_POLCON3


esttab  m2 m2_EXEC_CONST m2_CHECKS  m2_POLCON3  using VPFDIefindex_nov.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" ) ///
cells(b(star fmt(2)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01) order(EF_INDEX  EXEC_CONST EXEC_CONSTxEF_INDEX  ///
CHECKS CHECKSxEF_INDEX POLCON3 POLCON3xEF_INDEX ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)




** Regression Table 3 - with EF Investment policy
use VPFDI18.dta, clear
set more off

tsset ccode year 
drop if  outlier_fLNwdi_fdipercap_ldc==1

  ** Drop cases missing all political constraints
 drop if POLCON3==. & CHECKS==. & EXEC_CONST==. & EF_INVEST~=.
 
 
 
gen EXEC_CONSTxEF_INVEST=EXEC_CONST*EF_INVEST
lab var EXEC_CONSTxEF_INVEST "EXEC CONST x EF INVEST"

gen CHECKSxEF_INVEST=CHECKS*EF_INVEST
lab var CHECKSxEF_INVEST "CHECKS x EF INVEST"

gen POLCON3xEF_INVEST=POLCON3*EF_INVEST
lab var POLCON3xEF_INVEST "POLCON3 x EF INVEST"

set more off
xtpcse fLNwdi_fdipercap_ldc   EF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m3

set more off
xtpcse fLNwdi_fdipercap_ldc  EF_INVEST EXEC_CONST EXEC_CONSTxEF_INVEST GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m3_EXEC_CONST

set more off
xtpcse fLNwdi_fdipercap_ldc   EF_INVEST CHECKS  CHECKSxEF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m3_CHECKS

set more off
xtpcse fLNwdi_fdipercap_ldc   EF_INVEST POLCON3 POLCON3xEF_INVEST GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_World_FDI   , pairwise corr(ar1)
est store m3_POLCON3


esttab  m3 m3_EXEC_CONST m3_CHECKS  m3_POLCON3  using VPFDIefinvest_nov.tex, nodepvars nonumbers noconstant mtitles("(1)" "(2)" "(3)" "(4)" ) ///
cells(b(star fmt(2)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01) order(EF_INVEST  EXEC_CONST EXEC_CONSTxEF_INVEST  ///
CHECKS CHECKSxEF_INVEST POLCON3 POLCON3xEF_INVEST ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)




** Regression Table 4 - Oil rent economies vs. non-oil rent economies
sum wdi_oilrent if EF_INVEST~=., detail

lab var wdi_oilrent "Oil Rents (percent of GDP)"
set more off



xtpcse fLNwdi_fdipercap_ldc  EXEC_CONST EF_INVEST EXEC_CONSTxEF_INVEST GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_oilgaspc  log_World_FDI   if outlier_fLNwdi_fdipercap_ldc~=1 & wdi_oilrent>1 & wdi_oilrent~=., pairwise corr(ar1)

estimates store m4_EXEC_CONST17oil, title(`var')


xtpcse fLNwdi_fdipercap_ldc  EXEC_CONST EF_INVEST EXEC_CONSTxEF_INVEST GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI   if outlier_fLNwdi_fdipercap_ldc~=1 & wdi_oilrent<=1, pairwise corr(ar1)

estimates store m4_EXEC_CONST17nooil, title(`var')


xtpcse fLNwdi_fdipercap_ldc  CHECKS EF_INVEST CHECKSxEF_INVEST GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_oilgaspc  log_World_FDI   if outlier_fLNwdi_fdipercap_ldc~=1 & wdi_oilrent>1 & wdi_oilrent~=., pairwise corr(ar1)

estimates store m4_CHECKS17oil, title(`var')


xtpcse fLNwdi_fdipercap_ldc  CHECKS EF_INVEST CHECKSxEF_INVEST GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI   if outlier_fLNwdi_fdipercap_ldc~=1 & wdi_oilrent<=1, pairwise corr(ar1)

estimates store m4_CHECKS17nooil

xtpcse fLNwdi_fdipercap_ldc  POLCON3 EF_INVEST POLCON3xEF_INVEST GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_oilgaspc  log_World_FDI   if outlier_fLNwdi_fdipercap_ldc~=1 & wdi_oilrent>1 & wdi_oilrent~=., pairwise corr(ar1)

estimates store m4_POLCON317oil, title(`var')


xtpcse fLNwdi_fdipercap_ldc POLCON3 EF_INVEST POLCON3xEF_INVEST GATTWTO  log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI   if outlier_fLNwdi_fdipercap_ldc~=1 & wdi_oilrent<=1, pairwise corr(ar1)

estimates store m4_POLCON317nooil, title(`var')




esttab m4_EXEC_CONST17oil  m4_CHECKS17oil m4_POLCON317oil m4_EXEC_CONST17nooil m4_CHECKS17nooil m4_POLCON317nooil using VPFDIefinvest_nov_oil.tex, nodepvars nonumbers noconstant mtitles("(Oil rents)" "(Oil rents)" "(Oil rents)" "(Non-oil)" "(Non-oil)" "(Non-oil)") ///
cells(b(star fmt(2)) se(par fmt(2))) r2 replace label starlevels(+ 0.10 * 0.05 ** 0.01) order(EF_INVEST  EXEC_CONST EXEC_CONSTxEF_INVEST  ///
CHECKS CHECKSxEF_INVEST POLCON3 POLCON3xEF_INVEST ///
GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr log_oilgaspc  log_World_FDI) ///
addnotes(Panel corrected standard errors in parentheses. $+ p<0.10, * p<0.05 ** p<0.01$)



** Kernel plots  (take a long time!)


** Figure 4  - EFW Index

use VPFDI18.dta, clear

tsset ccode period
drop if outlier_fLNwdi_fdipercap_ldc5 ==1
drop if fLNwdi_fdipercap_ldc5==.

** (without kernels)
set more off
foreach var of varlist EXEC_CONST CHECKS POLCON3  {
interflex fLNwdi_fdipercap_ldc5  `var' EFW_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI if EFW_INDEX>-3.1 & EFW_INDEX<3.1, cl(ccode) ylab(Outcome) dlab(`var') xlab(EFW INDEX) yr(-1 1)
graph export `var'_interflex1_nov.pdf, replace
 mat list r(margeff)
 }

** With Kernels
set more off
foreach var of varlist EXEC_CONST CHECKS POLCON3  {
interflex fLNwdi_fdipercap_ldc5  `var' EFW_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI if EFW_INDEX>-3.1 & EFW_INDEX<3.1, cl(ccode) ylab(Outcome) dlab(`var') xlab(EFW INDEX) type(kernel) yr(-1 1)
graph export `var'_interflex1_kernel_nov.pdf, replace
 mat list r(margeff)
 }


 
 
** Figure 5 - EF Index

use VPFDI18.dta, clear
set more off

tsset ccode year 
drop if  outlier_fLNwdi_fdipercap_ldc==1

** (without kernels)
foreach var of varlist EXEC_CONST CHECKS POLCON3  {

interflex fLNwdi_fdipercap_ldc  `var' EF_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI, cl(ccode) ylab(Outcome) dlab(`var') xlab(EF Index) yr(-1 1)
graph export `var'_interflex1_efindex_nov.pdf, replace
 mat list r(margeff)
 }

 
 ** With Kernels:
foreach var of varlist EXEC_CONST CHECKS POLCON3  {
interflex fLNwdi_fdipercap_ldc  `var' EF_INDEX  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI if EF_INDEX>-2.99 & EF_INDEX<2.99, cl(ccode) ylab(Outcome) dlab(`var') xlab(EF Index) type(kernel) yr(-1 1) xr(-3 3)
graph export `var'_interflex1_efindex_kernel_nov.pdf, replace
  mat list r(margeff)
 }






** Figure 6 - EF Investment

** (without kernels)
foreach var of varlist EXEC_CONST CHECKS POLCON3  {
interflex fLNwdi_fdipercap_ldc  `var' EF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI, cl(ccode) ylab(Outcome) dlab(`var') xlab(EF_INVEST) yr(-1 1)
graph export `var'_interflex1_efinvest_nov.pdf, replace
   mat list r(margeff)
 }

 

 ** With Kernels:
foreach var of varlist EXEC_CONST CHECKS POLCON3  {
interflex fLNwdi_fdipercap_ldc  `var' EF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI if EF_INVEST>-2.99 & EF_INVEST<2.99, cl(ccode) ylab(Outcome) dlab(`var') xlab(EF Investment) type(kernel) yr(-1 1) xr(-3 3)
graph export `var'_interflex1_efinvest_kernel_nov.pdf, replace
  mat list r(margeff)
 }


** Figures 7 and 8 - Investment policy for oil rent economies and non-oil rent economies


foreach var of varlist EXEC_CONST CHECKS POLCON3  {
interflex fLNwdi_fdipercap_ldc  `var' EF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr  log_oilgaspc log_World_FDI if wdi_oilrent>1 & wdi_oilrent~=., cl(ccode) ylab(Outcome) dlab(`var') xlab(EF_INVEST) yr(-1 1)
graph export `var'_interflex1_efinvest_nov_oil.pdf, replace
 
interflex fLNwdi_fdipercap_ldc  `var' EF_INVEST  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI if wdi_oilrent<=1, cl(ccode) ylab(Outcome) dlab(`var') xlab(EF_INVEST) yr(-1 1)
graph export `var'_interflex1_efinvest_nov_nooil.pdf, replace

 }

log close 
 
 
 
