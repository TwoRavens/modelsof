****************************************************************************************
* Replication Code: Appendix Table 6
* District or State Unemployment Rate and Staffer Responsiveness to Employee Letter Condition. 
* OLS regression models. Statistical significance * p <0.10, ** p <0.05, *** p <0.01, 
* two-tailed tests. Outcomes measured on 1-4 scale. Unemployment data from 2011-15.
* This code created: 6/13/18
****************************************************************************************

*
* Load analysis file 
*

use "replicationdata.dta", clear

*
* Communications survey experiment results
*

* Outcomes:
* conjoint_1 = "How LIKELY are you to mention these letters to your Member?"
* conjoint_2 = "How SIGNIFICANT would these letters be in your advice to your Member about their position on the bill?"
* conjoint_3 = "How REPRESENTATIVE do you think these letters are of your constituents’ opinions?"

* Treatments:
* cid_1 = "constituents"
* cid_2 = "employees of a large company based in your constituency"
* cid_3 = "members of a non-profit citizens group"

* Regression results (1-4 scale) - comparing employees and citizens group to constituents

reg conjoint_1 cid_2##c.unemprate1115, cluster(office)
estimates store tab6m1
reg conjoint_2 cid_2##c.unemprate1115, cluster(office)
estimates store tab6m2
reg conjoint_3 cid_2##c.unemprate1115, cluster(office)
estimates store tab6m3

estout tab6m1 tab6m2 tab6m3  using appendix_table6.csv, cells(b(star fmt(2)) se(par fmt(2))) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace
