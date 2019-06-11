*********************************************************
*Replication material for 
*Arndt Leininger, Lukas Rudolph, Steffen Zittlau (2016): 
*"How to increase turnout in low-salience elections? Quasi-experimental evidence on the effect of concurrent second-order elections on political participation."
*Forthcoming in Political Science Research and Methods
*********************************************************

*********
**The following code reproduces Appendix Table 04
*********


/* install estout-package by Ben Jann in Version st0085_2 (Stata Journal 14-2) via "findit st0085_2".
		st0085_2 from http://www.stata-journal.com/software/sj14-2
		SJ14-2 st0085_2. Update: Making regression... / Update: Making regression
		tables from stored / estimates / by Ben Jann, University of Bern */

		
use "datasets/nds_balance_2006.dta", clear

***Appendix Table 04 rows 'turnout_2006' until 'SPD win'

eststo clear
eststo: estpost ttest turnout_2006 number_candidates runoff_election eligible_voters age stadt samtgemeinde gemeinde ???_win max_dw06, by(csoe)
esttab using "output/table04-appendix.tex", replace compress star(* 0.10 ** 0.05 *** 0.01) ///
cells("mu_1(fmt(%12.2f) label(Control)) mu_2(fmt(%12.2f) label(Treated)) b(fmt(%12.2f) star label(Diff-In-2006-Means)) N_1(fmt(%12.0f) label(N Controls)) N_2(fmt(%12.0f) label(N Treated))" "mean mean se(par fmt(2))" ". . .")


***Appendix Table 04 rows 'margin to runner-up' until 'share of municipalities...'

eststo clear
eststo two: estpost ttest margin_dw06 margin_dum_dw06 if margin_dw06!=. , by(csoe) // only for municipalities where more than one candidate competed
esttab using "output/table04-appendix.tex", append compress star(* 0.10 ** 0.05 *** 0.01) ///
cells("mu_1(fmt(%12.2f) label(Control)) mu_2(fmt(%12.2f) label(Treated)) b(fmt(%12.2f) star label(Diff-In-2006-Means)) N_1(fmt(%12.0f) label(N Controls)) N_2(fmt(%12.0f) label(N Treated))" "mean mean se(par fmt(2))" ". . .")




