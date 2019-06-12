insheet using "datasets/turnout+ep+btw+todif2.csv", clear
drop lid
encode land, gen(lid)

xtset lid pseudotime

* turnout in percentages
replace turnout = 100 * turnout
replace todif2 = 100 * todif2


* (1) --------------------------------------------------------------------------

* "average difference between CSOE- and no-CSOE states" 
reg todif2 elocal eother, vce(bootstrap, reps(1000))
estimates store mb1

* (2) --------------------------------------------------------------------------

* "average turnout increase in states that introduced CSOE"
xtreg todif2 elocal eother i.year, i(lid) fe vce(bootstrap, reps(1000))
estimates store mb2

* (3) --------------------------------------------------------------------------

* Trend in European Elections
xtreg turnout elocal eother i.year if level == "europa", fe vce(bootstrap, reps(1000))
estimates store mb3

* make table
esttab mb1 mb2 mb3 ///
	using "output/table8-appendix.tex", ///
	b(1) se(1) r2 se keep(elocal _cons) obslast nodep nomti ///
	coeflabels(elocal "Local" _cons "Intercept") star(* .05 ** .01) ///
	booktabs replace

* Rows "State Fixed Effects" and "Year Fixed Effects" have been added manually to the tex-file		
