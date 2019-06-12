/* Reanalysis of Kevlihan, DeRouen, and Biglaiser ISQ Data */
/* Matthew S. Winters */
/* 26 June 2014 */

use "Copy of OFDA_11_15_2011_Alliance.dta", clear

* Collapse the Data Down to Two Time Periods
 * Calculating the total value of OFDA flows, disaster variables, and civil war battle deaths
 * and the mean of the Polity, UNGA voting similiary, IMR, and GDP per capita variables.

collapse (sum) OFDA_Constant Louvain_Total_Damage__US_ Louvain_No__Dead Louvain_No__Affected PRIO_Battle_Deaths_Low ///
 (mean) polity4 s2un4608iL Bilateral_Trade imr gdp_per_capita, by(country psept11)

* Provide a more intuitive name for the affinity variable
rename s2un4608iL affinity 

* An indicator for countries that receive any OFDA flows 
gen ofda = 1 if OFDA_Constant > 0 & OFDA_Constant !=.
replace ofda = 0 if OFDA_Constant==0
 
* Taking logs of the relevant variables
gen logofda = log(OFDA_Constant)
gen logdamage = log(1 + Louvain_Total_Damage__US_)
gen logdead = log(1 + Louvain_No__Dead)
gen logaffected = log(1 + Louvain_No__Affected)
gen logbattle = log(1 + PRIO_Battle_Deaths_Low)
gen logtrade = log(1 + Bilateral_Trade)
gen loggdppc = log(gdp_per_capita)
gen logimr = log(imr)

* Creating interaction terms
gen logaffected_logimr = logaffected*logimr
gen logaffected_polity = logaffected*polity
gen logaffected_affinity = logaffected*affinity
gen logaffected_trade = logaffected*logtrade

* Table 1: Two Cross-Sectional Replications of Both the Selection and Level Models

reg ofda logdamage logbattle polity4 affinity logtrade logimr if psept11==1, robust
outreg2 using Table1, replace ctitle(Selection / Damage) excel dec(2) label

reg ofda logdead logbattle polity4 affinity logtrade logimr if psept11==1, robust
outreg2 using Table1, ctitle(Selection / Dead) excel dec(2) label

reg ofda logaffected logbattle polity4 affinity logtrade logimr if psept11==1, robust
outreg2 using Table1, ctitle(Selection / Affected) excel dec(2) label

reg logofda logdamage logbattle polity4 affinity logtrade logimr if psept11==1, robust
outreg2 using Table1, ctitle(Amount / Damage) excel dec(2) label

reg logofda logdead logbattle polity4 affinity logtrade logimr if psept11==1, robust
outreg2 using Table1, ctitle(Amount / Dead) excel dec(2) label

reg logofda logaffected logbattle polity4 affinity logtrade logimr if psept11==1, robust
outreg2 using Table1, ctitle(Amount/ Affected) excel dec(2) label

reg ofda logdamage logbattle polity4 affinity logtrade logimr if psept11==0, robust
outreg2 using Table1, ctitle(Selection / Damage) excel dec(2) label

reg ofda logdead logbattle polity4 affinity logtrade logimr if psept11==0, robust
outreg2 using Table1, ctitle(Selection / Dead) excel dec(2) label

reg ofda logaffected logbattle polity4 affinity logtrade logimr if psept11==0, robust
outreg2 using Table1, ctitle(Selection / Affected) excel dec(2) label

reg logofda logdamage logbattle polity4 affinity logtrade logimr if psept11==0, robust
outreg2 using Table1, ctitle(Amount / Damage) excel dec(2) label

reg logofda logdead logbattle polity4 affinity logtrade logimr if psept11==0, robust
outreg2 using Table1, ctitle(Amount / Dead) excel dec(2) label

reg logofda logaffected logbattle polity4 affinity logtrade logimr if psept11==0, robust
outreg2 using Table1, ctitle(Amount/ Affected) excel dec(2) label


* Table 2: Interaction Effects

reg logofda logaffected logbattle polity4 affinity logaffected_affinity logtrade logimr if psept11==1, robust
outreg2 using Table2, replace ctitle(Interaction with Affinity) excel dec(2) label

reg logofda logaffected logbattle polity4 affinity logtrade logaffected_trade logimr if psept11==1, robust
outreg2 using Table2, ctitle(Interaction with Trade) excel dec(2) label

reg logofda logaffected logbattle polity4 affinity logaffected_affinity logtrade logimr if psept11==0, robust
outreg2 using Table2, ctitle(Interaction with Affinity) excel dec(2) label

reg logofda logaffected logbattle polity4 affinity logaffected_trade logtrade logimr if psept11==0, robust
outreg2 using Table2, ctitle(Interaction with Trade) excel dec(2) label


* Note: The graphs of the interaction effects were produced in R.

  
/* End of File */
