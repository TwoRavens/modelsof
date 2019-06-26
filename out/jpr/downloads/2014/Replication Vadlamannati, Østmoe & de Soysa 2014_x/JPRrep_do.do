
set more off 

*********** provide labels ***************

label var ethpeace "Ethnic Peace (0-6)"
label var ep "Ethnic Peace (0-6): Ordinal scale"
label var gdppc "Per capita GDP"
label var lngdppc "Per capita GDP (log)"
label var pop "Population"
label var lnpop "Population (log)"
label var debt "External Debt/GDP"
label var currency "Currency crisis dummy"
label var debtcrisis "Debt crisis dummy"
label var democ "Democracy Dummy"
label var autokr "Autocracy Dummy"
label var pir "Physical Integrity Rights Index"
label var civilwar "Civil war dummy"
label var nrrents "Oil Rents/GDP"
label var total5 "IMF programs > 5 months in a year"
label var totalsigned "IMF programs signed in a year"
label var ethfrac "Ethnic Fractionalization"
label var second "Polarization"
label var maxexclpop "Excluded Population Share"
label var unsc "UN Security Council dummy"
label var ungae1 "UNGA Voting Alignment Index"
label var yearendingimf "Number of Years under an IMF program"
label var trade "Trade/GDP"
label var fdigdp "FDI/GDP"
label var ief "Economic Freedom Index"
label var dacgdp "DAC Aid/GDP"



******************************************************* Descriptive Statistics **********************************************************


sum(ethpeace lngdppc lnpop debt democ pir civilwar nrrents total5 ethfrac second maxexclpop unsc ungae1 yearendingimf)


****************************************************** Correlation Matrix ****************************************************************


corr(ethpeace lngdppc lnpop debt democ pir civilwar nrrents total5 ethfrac second maxexclpop unsc ungae1 yearendingimf)


********************************************************************************************************************************************************************
******************************************************************* TABLE 1: NEWEY WEST MODELS *********************************************************************
********************************************************************************************************************************************************************

* Column 1 (OLS with LDV)
xi: reg ethpeace l.ethpeace lngdppc lnpop debt democ pir nrrents total5 i.year, robust
tab id if e(sample)==1
estimates store kc
outreg2 using "T1", excel

* Column 2 (Newey West)
newey ethpeace lngdppc lnpop debt democ pir nrrents total5 i.year, force lag(1)
tab id if e(sample)==1
outreg2 using "T1", excel

* Column 3 (Newey West)
newey ethpeace lngdppc lnpop debt democ pir nrrents total5 ethfrac i.year, force lag(1)
tab id if e(sample)==1
outreg2 using "T1", excel

* Column 4 (Newey West)
newey ethpeace lngdppc lnpop debt democ pir nrrents total5 second i.year, force lag(1)
tab id if e(sample)==1
outreg2 using "T1", excel

* Column 5 (Newey West)
newey ethpeace lngdppc lnpop debt democ pir nrrents total5 maxexclpop i.year, force lag(1)
tab id if e(sample)==1
outreg2 using "T1", excel

* Column 6 (Newey West with FE)
newey ethpeace lngdppc lnpop debt democ pir nrrents total5 i.year i.id, force lag(1)
tab id if e(sample)==1
outreg2 using "T1", excel

* Column 7 (2SLS-IF FE)
xi: ivreg2 ethpeace lngdppc lnpop debt democ pir nrrents (total5 = unsc ungae1) i.id i.year, robust first
tab id if e(sample)==1
outreg2 using "T1", excel

* IV exclusion restriction test: 
xi: reg ethpeace lngdppc lnpop debt democ pir nrrents unsc ungae1 i.id i.year

* Column 8 (SGMM)
xi: xtabond2 ethpeace l.ethpeace l2.ethpeace lngdppc lnpop debt democ pir nrrents total5 i.year, gmm( l2.ethpeace unsc ungae1, lag(3 2) collapse) iv(lngdppc lnpop debt democ pir nrrents i.year) two robust
tab id if e(sample)==1
outreg2 using "T1", excel


********************************************************************************************************************************************************************
******************************************************************* TABLE 2: ORDERED PROBIT MODELS *****************************************************************
********************************************************************************************************************************************************************

* Column 1

xi: oprobit ep lngdppc lnpop debt democ pir nrrents total5 i.year, robust
tab id if e(sample)==1
estimates store vkc
outreg2 using "t2", excel

* Computing Marginal Effects
xi: oprobit ep lngdppc lnpop debt democ pir nrrents total5 i.year, robust
meoprobit, nodiscrete stats(p) exp

* Column 2

xi: oprobit ep lngdppc lnpop debt democ pir nrrents total5 ethfrac i.year, robust
tab id if e(sample)==1
outreg2 using "t2", excel

* Column 3

xi: oprobit ep lngdppc lnpop debt democ pir nrrents total5 second i.year, robust
tab id if e(sample)==1
outreg2 using "t2", excel

* Column 4

xi: oprobit ep lngdppc lnpop debt democ pir nrrents total5 maxexclpop i.year, robust
tab id if e(sample)==1
outreg2 using "t2", excel


********************************************************************************************************************************************************************
******************************************************************* TABLE 3: INTERACTION MODELS ********************************************************************
********************************************************************************************************************************************************************

* Column 1
newey ethpeace lngdppc lnpop debt democ pir nrrents c.total5##c.ethfrac i.year, force lag(1)
tab id if e(sample)==1
estimates store vc
outreg2 using "T3", excel

* Column 2
newey ethpeace lngdppc lnpop debt democ pir nrrents c.total5##c.second i.year, force lag(1)
tab id if e(sample)==1
outreg2 using "T3", excel

* Column 3
newey ethpeace lngdppc lnpop debt democ pir nrrents c.total5##c.maxexclpop i.year, force lag(1)
tab id if e(sample)==1
outreg2 using "T3", excel

* Column 4

newey ethpeace lngdppc lnpop debt democ pir nrrents c.total5##c.ethfrac c.total5##c.second c.total5##c.maxexclpop i.year, force lag(1)
tab id if e(sample)==1
outreg2 using "T3", excel


************* Margins Plots:

* Column 1 (Margins Plot)
newey ethpeace lngdppc lnpop debt democ pir nrrents c.total5##c.ethfrac i.year, force lag(1)
margins, dydx(total5) at(ethfrac=(0 (0.1) 1)(mean)_all) post
marginsplot, level(90) recast(line) recastci(rarea) 

* Column 2 (Margins Plot)
newey ethpeace lngdppc lnpop debt democ pir nrrents c.total5##c.second i.year, force lag(1)
margins, dydx(total5) at(second=(0 (0.05) 0.5)(mean)_all) post
marginsplot, level(90) recast(line) recastci(rarea) 

* Column 3 (Margins Plot)
newey ethpeace lngdppc lnpop debt democ pir nrrents c.total5##c.maxexclpop i.year, force lag(1)
margins, dydx(total5) at(maxexclpop=(0.1 (0.1) 0.9)(mean)_all) post
marginsplot, level(90) recast(line) recastci(rarea)


********************************************************************************************************************************************************************
*********************************************************************** ROBUSTNESS CHECKS **************************************************************************
********************************************************************************************************************************************************************


*** Robustness Check 1: Lagged Dependent Variable

xi: reg ethpeace l.ethpeace lngdppc lnpop debt democ pir nrrents total5 i.year, robust
estimates store kc
outreg2 using "R1", excel

xi: reg ethpeace l.ethpeace lngdppc lnpop debt democ pir nrrents total5 i.id i.year, robust
outreg2 using "R1", excel

xi: reg ethpeace l.ethpeace lngdppc lnpop debt democ pir nrrents total5 ethfrac i.year, robust
outreg2 using "R1", excel

xi: reg ethpeace l.ethpeace lngdppc lnpop debt democ pir nrrents total5 second i.year, robust
outreg2 using "R1", excel

xi: reg ethpeace l.ethpeace lngdppc lnpop debt democ pir nrrents total5 maxexclpop i.year, robust
outreg2 using "R1", excel


*** Robustness Check 2: Years under IMF (OLS)

xi: newey ethpeace lngdppc lnpop debt democ pir nrrents imfnumberyearsunder4608 i.year, force lag(1)
estimates store kcv
outreg2 using "R2", excel

xi: newey ethpeace lngdppc lnpop debt democ pir nrrents imfnumberyearsunder4608 ethfrac i.year, force lag(1)
outreg2 using "R2", excel

xi: newey ethpeace lngdppc lnpop debt democ pir nrrents imfnumberyearsunder4608 second i.year, force lag(1)
outreg2 using "R2", excel

xi: newey ethpeace lngdppc lnpop debt democ pir nrrents imfnumberyearsunder4608 maxexclpop i.year, force lag(1)
outreg2 using "R2", excel


*** Robustness Check 3: Years under IMF (Ordered Probit) 

xi: oprobit ethpeace lngdppc lnpop debt democ pir nrrents imfnumberyearsunder4608 i.year, robust
estimates store cv
outreg2 using "R3", excel

xi: oprobit ethpeace lngdppc lnpop debt democ pir nrrents imfnumberyearsunder4608 ethfrac i.year, robust
outreg2 using "R3", excel

xi: oprobit ethpeace lngdppc lnpop debt democ pir nrrents imfnumberyearsunder4608 second i.year, robust
outreg2 using "R3", excel

xi: oprobit ethpeace lngdppc lnpop debt democ pir nrrents imfnumberyearsunder4608 maxexclpop i.year, robust
outreg2 using "R3", excel


*** Robustness Check 4a: Sample Selection Model (Heckman selection estimations) 

heckman ethpeace l.ethpeace lngdppc lnpop debt democ pir nrrents total5 i.id i.year, select(totalsigned = l.lngdppc l.trade l.fdigdp l.debt l.currency l.debtcrisis l.democ l.autokr civilwar l.nrrents  l.unsc l.ungae1 l.dacgdp yearendingimf l.ief i.year) twostep
estimates store vk
outreg2 using "R4", excel



*** Robustness Check 5: System-GMM estimations

xi: xtabond2 ethpeace l.ethpeace lngdppc lnpop debt democ pir nrrents total5 i.year, gmm(l.ethpeace unsc ungae1, collapse lag(3 2)) iv(lngdppc lnpop debt democ pir civilwar nrrents i.year) two robust
estimates store cbv
outreg2 using "R5", excel

*** Robustness Check 6: Inclusion of Civil War Variable

xi: reg ethpeace l.ethpeace lngdppc lnpop debt democ pir civilwar nrrents total5 i.year, robust
estimates store ckv
outreg2 using "Rewzxz6", excel

xi: reg ethpeace l.ethpeace lngdppc lnpop debt democ pir civilwar nrrents total5 i.id i.year, robust
outreg2 using "Rewzxz6", excel

xi: reg ethpeace l.ethpeace lngdppc lnpop debt democ pir civilwar nrrents total5 ethfrac i.year, robust
outreg2 using "Rewzxz6", excel

xi: reg ethpeace l.ethpeace lngdppc lnpop debt democ pir civilwar nrrents total5 second i.year, robust
outreg2 using "Rewzxz6", excel

xi: reg ethpeace l.ethpeace lngdppc lnpop debt democ pir civilwar nrrents total5 maxexclpop i.year, robust
outreg2 using "Rewzxz6", excel

xi: reg ethpeace lngdppc lnpop debt democ pir civilwar nrrents total5 i.id i.year, robust
outreg2 using "Rewzxz6", excel

xi: ivreg2 ethpeace lngdppc lnpop debt democ pir civilwar nrrents (total5 = unsc ungae1) i.id i.year, robust first
outreg2 using "Rewzxz6", excel

* IV exclusion restriction test: 
xi: reg ethpeace lngdppc lnpop debt democ pir civilwar nrrents unsc ungae1 i.id i.year
