* The Distributional Consequences of Technological Change: Worker-Level Evidence
* Thomas Kurer and Aina Gallego

* Figure 4

*###############################################################################

clear
set more off
set scheme lean2

graph drop _all


* set working directory
global wd "INSERTYOURPATH"   

use "$wd/workerLevelEvidence.dta"


*** reduce sample to labor force (in line with definition of retirement in river plot)
drop if age <18 | age > 64 | age ==.


* define panel structure

* generate a person x industry identifier
recode euklems_num .=0
egen indxind=group(id euklems_num)
recode euklems_num 0=.

xtset indxind year
sort id year


* DV = income
xtreg incomem c.ICT_hours##i.task3 c.age##c.age i.year, fe r
margins, dydx(ICT_hours) at(task3=(1(1)3))

marginsplot, plotopts(connect(none)) xline(0, lpat(dash)) horizontal ///
xscale(r(-10 80)) xlab(-10(10)80) ylab(0 " " 1 "Non-Routine Cognitive" 2 "Routine" 3 "Non-Routine Manual" 4 " ", notick nogrid) yscale(r(1.5 2.5))	///
title("Monthly Income") ytitle("") xtitle("") ///
name(fig4inc) 


* DV = satisfaction with job
xtreg satjob c.ICT_hours##i.task3 c.age##c.age i.year, fe r
margins, dydx(ICT_hours) at(task3=(1(1)3))

marginsplot, plotopts(connect(none)) xline(0, lpat(dash)) horizontal ///
xscale(r(-0.03 0.07)) xlab(-0.02(0.01)0.06) ylab(0 "    " 1 "    " 2 "    " 3 "                     " 4 "      ", notick nogrid) yscale(r(1.5 2.5)) ///
title("Job Satisfaction") ytitle("") xtitle("") ///
name(fig4sat) 

* Figure 4

graph combine fig4inc fig4sat, col(2) imargin(-10 -10 0 0)
graph export RAP_Fig4.eps

* Export Tables for Appendix 
eststo: xtreg incomem c.ICT_hours##i.task3 c.age##c.age i.year, fe r
eststo: xtreg satjob c.ICT_hours##i.task3 c.age##c.age i.year, fe r

esttab est1 est2 using RaP_table_revision.tex, cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) ///
style(fixed) starlevels(* 0.05 ** 0.01 *** 0.001) stats(bic0 N ,fmt(0 0) labels("BIC" "N"))
