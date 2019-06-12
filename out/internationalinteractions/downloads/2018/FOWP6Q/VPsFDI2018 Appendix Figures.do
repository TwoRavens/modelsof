

** Code for Dec. 7 2017 version of "Economic Policy, Political Constraints, and Foreign Direct Investment in Developing Countries"
** Appendix Figures 


use VPFDI18.dta, clear

tsset ccode year



*** APPENDIX Figure 1 - FDI per capita (without transformation) and FDI per GDP


ciplot fwdi_fdipercap_ldc5 if  EFW_INDEX~=. , by(year)  legend(off) scheme(s1mono)
graph export fdipercap_ciplot_17_nov.pdf, replace

ciplot fwdi_fdi_ldc5 if  EFW_INDEX~=. , by(year)  legend(off) scheme(s1mono)
graph export fdi_ciplot_new17.pdf, replace


*** Appendix Figure 2 Left panel: EF components

sort year
foreach var2 of varlist EF_INDEX-EF_TRADE {
by year: egen ma_`var2' = mean(`var2')  
}


lab var ma_EF_BUSINESS "BUSINESS"
lab var ma_EF_CORRUPT "CORRUPT"
lab var ma_EF_FINANCIAL "FINANCIAL"
lab var ma_EF_FISCAL "FISCAL"
lab var ma_EF_GOVSIZE "GOVT"
lab var ma_EF_INVEST "INVEST"
lab var ma_EF_LABOR "LABOR"
lab var ma_EF_MONETARY "MONETARY"
lab var ma_EF_PROP "PROP"
lab var ma_EF_TRADE "TRADE"
lab var ma_EF_INDEX "EF INDEX"

twoway (tsline ma_EF_INDEX, recast(connected) msymbol(point)) ///
 (tsline ma_EF_GOVSIZE, recast(connected) msymbol(circle)) ///
(tsline ma_EF_PROP, recast(connected) msymbol(square)) ///
(tsline ma_EF_MONETARY, recast(connected) msymbol(diamond)) ///
(tsline ma_EF_TRADE, recast(connected) msymbol(plus)) ///
(tsline ma_EF_BUSINESS, recast(connected) msymbol(triangle)) ///
(tsline ma_EF_CORRUPT, recast(connected) msymbol(circle hollow)) ///
(tsline ma_EF_FINANCIAL, recast(connected) msymbol(diamond hollow)) ///
(tsline ma_EF_FISCAL, recast(connected) msymbol(triangle hollow)) ///
(tsline ma_EF_INVEST, recast(connected) msymbol(square hollow)) ///
(tsline ma_EF_LABOR, recast(connected) msymbol(smcircle)) ///
 if year>1994 & year<2014, scheme(s1mono) legend(cols(3))
* title("Average Policy Score by Year") 

graph export policytimeplot_17ef.pdf, replace


*** Appendix Figure 2 Right panel: Capital Account Openness over time

use VPFDI18.dta, clear

sort ccode year
tsset ccode year
sort year
foreach var2 of varlist KA_OPEN {
by year: egen ma`var2' = mean(`var2')  
}
lab var maKA_OPEN "CAPITAL ACCOUNT OPENNESS"


drop if year<1970

twoway  (tsline maKA_OPEN, recast(connected) msymbol(point)) ///
, scheme(s1mono)
* title("Average Capital Account Openness by Year") 

graph export kaopen_timeplot_17.pdf, replace



** Appendix Figure 3: Scatter plots with EF INDEX

use VPFDI18.dta, clear

scatter EF_INDEX POLCON3  
graph export efscatter1.pdf, replace 
scatter EF_INDEX CHECKS 
graph export efscatter2.pdf, replace 
scatter EF_INDEX EXEC_CONST 
graph export efscatter3.pdf, replace 


** Scatter plots with EF INVEST
scatter EF_INVEST POLCON3  
graph export efinvscatter1.pdf, replace 
scatter EF_INVEST CHECKS 
graph export efinvscatter2.pdf, replace 
scatter EF_INVEST EXEC_CONST 
graph export efinvscatter3.pdf, replace 



 
** Appendix Figures 4-8; with EFW components

use VPFDI18.dta, clear

tsset ccode period
drop if outlier_fLNwdi_fdipercap_ldc5 ==1
drop if fLNwdi_fdipercap_ldc5==.
 
 
foreach var of varlist EXEC_CONST CHECKS POLCON3  {
foreach var2 of varlist EFW_GOVSIZE-EFW_REG {
interflex fLNwdi_fdipercap_ldc5  `var' `var2' GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI, cl(ccode) ylab(Outcome) dlab(`var') xlab(`var2') yr(-1 1)
graph export `var'_`var2'_interflex1_nov.pdf, replace
  }
}



** Appendix Figures 9-17; with EF components

use VPFDI18.dta, clear

tsset ccode year 

 
foreach var of varlist EXEC_CONST CHECKS POLCON3  {
foreach var2 of varlist EF_INVEST-EF_TRADE {
 
interflex fLNwdi_fdipercap_ldc5  `var' `var2' GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI, cl(ccode) ylab(Outcome) dlab(`var') xlab(`var2')  yr(-1 1)
graph export `var'_`var2'_interflex1_nov.pdf, replace
  }
}



** Appendix Figure 18 - KA OPEN
use VPFDI18.dta, clear

tsset ccode year 
drop if  outlier_fLNwdi_fdipercap_ldc==1



foreach var of varlist EXEC_CONST CHECKS POLCON3  {
interflex fLNwdi_fdipercap_ldc  `var' KA_OPEN  GATTWTO log_wdi_gdpcon log_wdi_gdppccon wdi_gdpgr   log_World_FDI, cl(ccode) ylab(Outcome) dlab(`var') xlab(KA OPEN) yr(-1 1)
graph export `var'_interflex1_kaopen_nov.pdf, replace
 }


