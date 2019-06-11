*********************************************************
*Replication material for 
*Arndt Leininger, Lukas Rudolph, Steffen Zittlau (2016): 
*"How to increase turnout in low-salience elections? Quasi-experimental evidence on the effect of concurrent second-order elections on political participation."
*Forthcoming in Political Science Research and Methods
*********************************************************

*********
**The following code reproduces Appendix Table 02, Appendix Table 05, Appendix Figure 01 
*********

/* requires estout-package by Ben Jann in Version st0085_2 (Stata Journal 14-2) via "findit st0085_2".
		st0085_2 from http://www.stata-journal.com/software/sj14-2
		SJ14-2 st0085_2. Update: Making regression... / Update: Making regression
		tables from stored / estimates / by Ben Jann, University of Bern */


****************************************
***Appendix Table 02 
****************************************	
use "datasets/nds_ee_ge_1998-2014.dta", clear

keep if level == "ep" // analysis only of results for European Elections

xtset id year 

eststo clear 

xtreg to i.csoe2014##i.year, fe cluster(id)

esttab using "output/table02-appendix.tex", se(a2) b(a2) replace star(* 0.1 ** 0.05 *** 0.01) label stats(N r2_a, fmt(%8.2f)) ///
interaction("$\times$") /// 
drop(0.csoe2014* 1.csoe2014 *1999.year*) /// 
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
) 


****************************************
***Appendix Table 05 
****************************************
use "datasets/nds_ee_ge_1998-2014.dta", clear

keep if year == 2009 // analysis only of EE 2009 and GE 2009 (pre-treatment period)

gen municipality_effect = 1
replace municipality_effect = 2 if level=="ep" // setup for fixed-effects regression in EE2009 and GE2009

gen csoe = 1 if level == "ep" & csoe2014 == 1 // variable indicates for 2009 EEs only whether municipality had CSOE in 2014, 0 otherwise
recode csoe (.=0) 

replace race = 1 if level == "btw" // variable indicates for 2009 EEs only whether municipality had uncontested/contested/close CSOE in 2014, category "no CSOE" otherwise

xtset id municipality_effect

eststo clear

eststo: reg D.(to csoe)  , r 
eststo: reg D.to i.race , r 
eststo: reg D.to i.csoe##i.population , r

esttab using "output/table05-appendix.tex", replace se(a2) b(a2) star(* 0.1 ** 0.05 *** 0.01) stats(N r2_a, fmt(%8.2f)) ///
drop(1.race 0.csoe* 0.population 1.csoe#0.population ) order(CSOE *race* *population ) ///
rename(1.csoe CSOE 2.year2 "EuropElec" D.csoe CSOE 1.csoe#7500.population "lcsoe$\times$7500population" ///
	1.csoe#15000.population "1csoe$\times$15000population" ///
	1.csoe#30000.population "1csoe$\times$30000population") ///
interaction("\$\times\$") /// 
mgroups("DiD (EP2009-FE2009)", pattern(1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
postfoot("\hline\hline" "\end{tabular}" "}") noisily




****************************************
***Appendix Figure 01 
****************************************	

use "datasets/nds_ee_ge_1998-2014.dta", clear

keep if level == "ep" // analysis only of results for European Elections

xtset id year 

xtreg to i.csoe2014##i.year##i.year##i.reelected, fe cluster(id)
margins, over(i.year i.csoe2014 i.reelected) noestimcheck
marginsplot, x(year) scheme(s1mono) xlabel(1999 2004 2009 2014)

graph export "output/figure01-appendix.eps", replace
