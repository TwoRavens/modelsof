* Replication code for "Political Context, Government Redistribution, 
* and the Public's Response to Growing Economic Inequality"
* Journal of Politics
* Author: William W. Franko
* Email: william.w.franko@gmail.com
* Date: 12/27/15



* Replace "DIRECTORYNAME" with the location of the Stata 
* data file "IneqRedist_JOP_Replication.dta".
cd "DIRECTORYNAME"

use "IneqRedist_JOP_Replication.dta", clear

version 14.1

* TSCS unit root checks.
xtunitroot fisher citi6010, pperron lags(3)
xtunitroot hadri citi6010, robust
xtunitroot fisher D.citi6010, pperron lags(3)
xtunitroot hadri D.citi6010, robust

xtunitroot fisher educfinalpct, pperron lags(3)
xtunitroot fisher D.educfinalpct, pperron lags(3)

xtunitroot fisher welfinalpct, pperron lags(3)
xtunitroot fisher D.welfinalpct, pperron lags(3)



*************************
*** Main text models. ***
*************************



xtset fips year

* Ind. variable list.
local indvars "D.inst6010_nom_wi L.inst6010_nom_wi D.government_cont_wi L.government_cont_wi D.gub_election_wi L.gub_election_wi D.unemp_wi L.unemp_wi D.unionmem_tot_wi L.unionmem_tot_wi D.income_pc1k_wi L.income_pc1k_wi D.pct_wht_wi L.pct_wht_wi D.pct_age60p_wi L.pct_age60p_wi"


* Ideology model.
* Top 1% income share.
xtpcse D.citi6010_wi L.citi6010_wi D.top1_wi L.top1_wi D.tot_spend_pc_wi L.tot_spend_pc_wi `indvars' time-time4
  estimates store m_ideo_top1


* Education spending models (Pacheco data).
* Top 1% income share.
xtpcse D.educfinalpct_wi L(1/2).educfinalpct_wi D.top1_wi L.top1_wi D.educ_spend_pc_wi L.educ_spend_pc_wi `indvars' time-time3
  estimates store m_edu_top1


* Welfare spending models (Pacheco data).
* Top 1% income share.
xtpcse D.welfinalpct_wi L(1/2).welfinalpct_wi D.top1_wi L.top1_wi D.welf_spend_pc_wi L.welf_spend_pc_wi `indvars' time*
  estimates store m_welf_top1


*
* Subsample models of rich and poor states.
*

_pctile income_pc1k_bw, p(50)
local inc50 = r(r1)

* Ideology, top 1% income share.
* Rich states.
xtpcse D.citi6010_wi L.citi6010_wi D.top1_wi L.top1_wi D.tot_spend_pc_wi L.tot_spend_pc_wi `indvars' time-time4 if income_pc1k_bw >= `inc50'
  estimates store m_ideo_rich

* Poor states.
xtpcse D.citi6010_wi L.citi6010_wi D.top1_wi L.top1_wi D.tot_spend_pc_wi L.tot_spend_pc_wi `indvars' time-time2 if income_pc1k_bw < `inc50'
  estimates store m_ideo_poor


* Education, top 1% income share.
* Rich states.
xtpcse D.educfinalpct_wi L(1/2).educfinalpct_wi D.top1_wi L.top1_wi D.educ_spend_pc_wi L.educ_spend_pc_wi `indvars' time-time4 if income_pc1k_bw >= `inc50'
  estimates store m_edu_rich

* Poor states.
xtpcse D.educfinalpct_wi L(1).educfinalpct_wi D.top1_wi L.top1_wi D.educ_spend_pc_wi L.educ_spend_pc_wi `indvars' time-time3 if income_pc1k_bw < `inc50'
  estimates store m_edu_poor


* Welfare, top 1% income share.
* Rich states.
xtpcse D.welfinalpct_wi L(1/2).welfinalpct_wi D.top1_wi L.top1_wi D.welf_spend_pc_wi L.welf_spend_pc_wi `indvars' time* if income_pc1k_bw >= `inc50'
  estimates store m_welf_rich

* Poor states.
xtpcse D.welfinalpct_wi L(1/2).welfinalpct_wi D.top1_wi L.top1_wi D.welf_spend_pc_wi L.welf_spend_pc_wi `indvars' time-time2 if income_pc1k_bw < `inc50'
  estimates store m_welf_poor


*
* Results tables.
* The following commands use the -estout- package to combine the saved
* estimation results from above into formatted tables. 
* The package is user-written and can be installed by typing:
* 	-ssc install estout-
*

* Table 1.
estout m_ideo_top1 m_edu_top1 m_welf_top1, cells("b(star fmt(3)) se(par fmt(3))") starlevels(* 0.05 ** 0.01 *** 0.001) stats(N chi2) style(fixed) order(*citi6010* *educfinalpct* *welfinalpct* *top1* *tot_spend_pc* *educ_spend_pc* *welf_spend_pc*) drop(time*) refcat(D.top1_wi "" _cons "", nolabel) 

* Table 2, models 1 and 2 (liberal policy mood).
estout m_ideo_rich m_ideo_poor, cells("b(star fmt(3)) se(par fmt(3))") starlevels(* 0.05 ** 0.01 *** 0.001) stats(N chi2) style(fixed) order(*citi6010* *top1* *tot_spend_pc*) drop(time*) refcat(D.top1_wi "" _cons "", nolabel) 

* Table 2, models 3 and 4 (education spending support).
estout m_edu_rich m_edu_poor, cells("b(star fmt(3)) se(par fmt(3))") starlevels(* 0.05 ** 0.01 *** 0.001) stats(N chi2) style(fixed) order(*educfinalpct_wi *top1* *educ_spend_pc*) drop(time*) refcat(D.top1_wi "" _cons "", nolabel) 

* Table 2, models 5 and 6 (welfare spending support).
estout m_welf_rich m_welf_poor, cells("b(star fmt(3)) se(par fmt(3))") starlevels(* 0.05 ** 0.01 *** 0.001) stats(N chi2) style(fixed) order(*welfinalpct* *top1* *welf_spend_pc*) drop(time*) refcat(D.top1_wi "" _cons "", nolabel) 


***
