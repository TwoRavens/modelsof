
* =================================
* Paper title: It's All About Political Incentives: Democracy and the Renewable Feed-In Tariff
* Authors: Patrick Bayer (Glasgow) and Johannes Urpelainen (Columbia) 
* Journal of Politics

* Last modified: November 7, 2015

* Data files used: FIT_design.dta
* System: Stata 13.1 on WIN 10

* Purpose: This do file replicates the results on FIT design (Appendix A8)
* =================================

*NB: Place all files in the same folder for paths to work properly

* Load data
use "FIT_design.dta"

* =================================
* 1. Appendix A8: Determinants of off-grid incentives (Table A7)
* =================================

eststo clear
eststo: probit offgrid urbanpop
estat class
estadd r(P_corr)

eststo: probit offgrid urbanpop year
estat class
estadd r(P_corr)

eststo: probit offgrid urbanpop year OECD
estat class
estadd r(P_corr)

eststo: probit offgrid urbanpop year OECD gdppc
estat class
estadd r(P_corr)

eststo: probit offgrid urbanpop year OECD gdppc L1polity
estat class
estadd r(P_corr)

/* esttab using "FIT_design_offgrid.tex", replace b(%9.2f) booktabs ///
stats(N r2_p P_corr, labels("Observations" "Pseudo $ R^2$" "Correct Predictions in \%") fmt(0 3 2)) /// 
eqlabels(none) drop(_cons) noconstant se label star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: Offgrid dummy.")
*/
