insheet using "datasets/turnout+ep+btw+todif2.csv", clear
drop lid
encode land, gen(lid)

drop if level == "bund"

xtset lid pseudotime

* turnout in percentages
replace turnout = 100 * turnout
replace todif = 100 * todif

* (1) --------------------------------------------------------------------------

* "average difference between CSOE- and no-CSOE states" 
reg todif elocal eother, cluster(lid)
estimates store mc1

* (2) --------------------------------------------------------------------------

* "average turnout increase in states that introduced CSOE"
xtreg todif elocal eother i.year, i(lid) fe cluster(lid)
estimates store mc2

* make table
esttab mc1 mc2 ///
	using "output/table9-appendix.tex", ///
	b(1) se(1) r2 se keep(elocal _cons) obslast nodep nomti ///
	coeflabels(elocal "Local" _cons "Intercept") star(* .05 ** .01) ///
	booktabs replace
	
* Rows "State Fixed Effects" and "Year Fixed Effects" have been added manually to the tex-file			

esttab mc1 mc2, b(1)
