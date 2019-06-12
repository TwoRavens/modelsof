* Sensitivity Analysis: Other Interactions

* this file creates a table for interaction models that serve as alternative sensitivty checks
* Sensitivity Analysis: Window Analysis
log
log using "(5)_Panel_Data_Alternative_Sensitivity", replace

**set working directory
use panel.dta

xtset gid
eststo: xtreg conf_dum i.cell##c.capdist dum08 dum09,fe cluster(gid)
eststo: xtreg conf_count i.cell##c.capdist dum08 dum09,fe cluster(gid)
eststo: xtreg conf_dum i.cell##c.pop2005 dum08 dum09,fe cluster(gid)
eststo: xtreg conf_count i.cell##c.pop2005 dum08 dum09,fe cluster(gid)
esttab using "int_main.tex",replace se scalars(N) label title(Interactions, FE-OLS) mtitles("Binary" "Count" "Binary" "Count") star(+ 0.10 * 0.05 ** 0.01 *** 0.001)
eststo clear

