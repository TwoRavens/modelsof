
clear
set more off

capture cd "/Users/asunka/Dropbox/2014-Academic Products/SAGE Research and Politics"

import excel "foatdata06.xlsx", sheet("Sheet2") firstrow



********Regression analysis using OLS*******************************************
**1. Total perfromance score and electoral volatility

xi: reg totalpm volatile i.Region
outreg2 using tables/table11, bdec(3) ctitle(Model 1) word replace
xi: reg totalpm volatile ethnic_frac pct_ovr_sss  capacity logpopden turnout i.Region
outreg2 using tables/table11, bdec(3) ctitle(Model 2) word append



**2. Procurement perfromance score and electoral volatility ******************************************
xi: reg procure volatile i.Region //, vce(cluster Region)
outreg2 using tables/table11, bdec(3) ctitle(Model 3) word append
xi: reg procure volatile ethnic_frac pct_ovr_sss  capacity logpopden turnout i.Region 
outreg2 using tables/table11, bdec(3) ctitle(Model 4) word append


********Regression analysis using OLS*******************************************
**1. Total perfromance score and split-ticket dummy

xi: reg totalpm split i.Region
outreg2 using tables/table21, bdec(3) ctitle(Model 1) word replace
xi: reg totalpm split ethnic_frac pct_ovr_sss  capacity logpopden turnout i.Region 
outreg2 using tables/table21, bdec(3) ctitle(Model 2) word append



**2. Procurement perfromance score and split-ticket dummy******************************************
xi: reg procure split i.Region 
outreg2 using tables/table21, bdec(3) ctitle(Model 3) word append
xi: reg procure split ethnic_frac pct_ovr_sss  capacity logpopden turnout i.Region 
outreg2 using tables/table21, bdec(3) ctitle(Model 4) word append


********Regression analysis using OLS: Afrobarometer*******************************************
**1. Total perfromance score and percent reporting that they do not feel close to a party

xi: reg totalpm abprop i.Region 
outreg2 using tables/table31, bdec(3) ctitle(Model 1) word replace
xi: reg totalpm abprop ethnic_frac pct_ovr_sss  capacity logpopden turnout i.Region 
outreg2 using tables/table31, bdec(3) ctitle(Model 2) word append



**2. Procurement perfromance score Afrobarometer******************************************
xi: reg procure abprop i.Region 
outreg2 using tables/table31, bdec(3) ctitle(Model 3) word append
xi: reg procure abprop ethnic_frac pct_ovr_sss  capacity logpopden turnout i.Region 
outreg2 using tables/table31, bdec(3) ctitle(Model 4) word append




***Analysis for other performacne measures

**1) Electoral volatility
set more off
***Regressions with country fixed effects ***
foreach var of varlist transparency finmgt orgmgt humanres substruc planning {
xi: reg `var' volatile ethnic_frac pct_ovr_sss  capacity logpopden turnout i.Region
estimates store `var'A
}

coefplot (transparencyA, label(Transparency) msymbol(O)) (finmgtA, label(Financial mgt) msymbol(Oh)) ///
(orgmgtA, label(Organization and mgt) msymbol(D)) (humanresA, label(Human resource mgt) msymbol(Dh)) ///
(substrucA, label(Substructure mgt) msymbol(T)) (planningA, label(Planning)msymbol(Th)), keep(volatile) ///
xline(0) graphr(color(white)) grid(between glcolor(black) glpattern(dash)) ///
coeflabels(volatile="Electoral volatility", wrap(10))
graph export graphs/graph1.pdf, replace  as(pdf)


***2) Split-ticket dummy
set more off
***Regressions with country fixed effects ***
foreach var of varlist transparency finmgt orgmgt humanres substruc planning {
xi: reg `var' split ethnic_frac pct_ovr_sss  capacity logpopden turnout i.Region
estimates store `var'B
}

coefplot (transparencyB, label(Transparency) msymbol(O)) (finmgtB, label(Financial mgt) msymbol(Oh)) ///
(orgmgtB, label(Organization and mgt) msymbol(D)) (humanresB, label(Human resource mgt) msymbol(Dh)) ///
(substrucB, label(Substructure mgt) msymbol(T)) (planningB, label(Planning)msymbol(Th)), keep(split) ///
xline(0) graphr(color(white)) grid(between glcolor(black) glpattern(dash)) ///
coeflabels(split="Split ticket voting", wrap(6))
graph export graphs/graph2.pdf, replace  as(pdf)
