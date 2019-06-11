*********************************************************
*Replication material for 
*Arndt Leininger, Lukas Rudolph, Steffen Zittlau (2016): 
*"How to increase turnout in low-salience elections? Quasi-experimental evidence on the effect of concurrent second-order elections on political participation."
*Forthcoming in Political Science Research and Methods
*********************************************************

*********
**The following code reproduces Appendix Table 03 
*********


/* requires estout-package by Ben Jann in Version st0085_2 (Stata Journal 14-2) via "findit st0085_2".
		st0085_2 from http://www.stata-journal.com/software/sj14-2
		SJ14-2 st0085_2. Update: Making regression... / Update: Making regression
		tables from stored / estimates / by Ben Jann, University of Bern */


***Appendix Table 10 rows 'cdu' until 'mayor in consecutive term'
		
use "datasets/nds_balance_2014.dta", clear

eststo clear
eststo: estpost ttest cdu spd independent female region* community joint city runoff reelected , by(csoe)
esttab using "output/table03-appendix.tex", replace compress star(* 0.10 ** 0.05 *** 0.01) ///
cells("mu_1(fmt(%12.2f) label(Control)) mu_2(fmt(%12.2f) label(Treated)) b(fmt(%12.2f) star label(Diff-In-2014-Means)) N_1(fmt(%12.0f) label(N Controls)) N_2(fmt(%12.0f) label(N Treated))" "mean mean se(par fmt(2))" ". . .")


***Appendix Table 10 rows 'eligibles' until 'pop>30000'

use "datasets/nds_ee_ge_1998-2014.dta", clear

eststo clear
eststo: estpost ttest eligibles small medium large verylarge if year == 2014, by(csoe2014)

esttab using "output/table03-appendix.tex", append  compress star(* 0.10 ** 0.05 *** 0.01) ///
cells("mu_1(fmt(%12.2f) label(Control)) mu_2(fmt(%12.2f) label(Treated)) b(fmt(%12.2f) star label(Diff-In-2014-Means)) N_1(fmt(%12.0f) label(N Controls)) N_2(fmt(%12.0f) label(N Treated))" "mean mean se(par fmt(2))" ". . .")




