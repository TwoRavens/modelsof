*********************************************************
*Replication material for 
*Arndt Leininger, Lukas Rudolph, Steffen Zittlau (2016): 
*"How to increase turnout in low-salience elections? Quasi-experimental evidence on the effect of concurrent second-order elections on political participation."
*Forthcoming in Political Science Research and Methods
*********************************************************

*********
**The following code reproduces Appendix Table 10 
*********


/* install estout-package by Ben Jann in Version st0085_2 (Stata Journal 14-2) via "findit st0085_2".
		st0085_2 from http://www.stata-journal.com/software/sj14-2
		SJ14-2 st0085_2. Update: Making regression... / Update: Making regression
		tables from stored / estimates / by Ben Jann, University of Bern */

	
use "datasets/federal_placebo.dta", clear

eststo clear 

***Appendix Table 10 Model 1

eststo clear

xtset land year_order

eststo model1: reg S2.to placebo_EE_csoe if level_name=="bund", r // placebo with first difference specification replacing EE turnout with turnout of closest General Election


***Appendix Table 10 Model 2

gen to_diff_ge = to-to[_n-1] if level_name=="europa"

keep if level=="europa"
keep if year_ew>=6

xtset land year_ew
gen placebo_EE_csoe2 = F.elocal

eststo model2: reg D.to_diff_ge D.placebo_EE_csoe2 if  year_ew ==7, r // placebo shifting 2014 first-time CSOEs to 2009 

esttab model1 model2 using "output/table10-appendix.tex", se replace star(* 0.1 ** 0.05 *** 0.01) label stats(N) ///
mtitles( "DiD: 1980-2013 closest FedE" "DiDiD: (EE2009-GE2009)-(EE2004-GE2005)") ///
rename(D.placebo_EE_csoe2 placebo_EE_csoe) ///
postfoot("\hline\hline" "\end{tabular}" "}"  /// 
) 






