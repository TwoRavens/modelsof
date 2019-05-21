/* 
Replication data for "American Employers as Political Machines"
Forthcoming in the Journal of Politics
Alexander Hertel-Fernandez
Columbia University 
School of International and Public Affairs
alexander.hertel@gmail.com
*/

* This replication code replicates the analysis in the paper using the 2014 and 2015 YouGov firm survey analysis

* Load data

use "YouGov data.dta", clear

set more off
cap log close
cap log using "American Employers as Political Machines - YouGov Analysis.smcl", replace

* Summarize any employer mobilization in August 2015
* 0/1

sum anycontact_w2

* Summarize monitoring online activities of employees - any
* 1=None, 2=sometimes, 3=frequently, 4=always

tab monitor

* Summarize customization of employer political contact by workers' past political participation
* 0/1, conditional on reporting mobilization

sum target_voter

* Summarize ranking of mobilization as most effective political strategy
* 0/1, conditional on reporting mobilization

tab effect_mobil_1 if poldonate==1 & buyads==1 & lobby==1 & anyba==1

* Replicate Figure 1

logit anycontact_w2 monitor union revenue_w2 companysize_w2 publiclytraded i.sector, cluster(sector)
margins, over(monitor)
marginsplot

* Replicate Figure 2

logit effect_mobil_1 monitor union revenue_w2 companysize_w2 publiclytraded i.sector if poldonate==1 & buyads==1 & lobby==1 & anyba==1, cluster(sector)
margins, over(monitor)
marginsplot

logit effect_mobil_1 target_vote union revenue_w2 companysize_w2 publiclytraded i.sector if poldonate==1 & buyads==1 & lobby==1 & anyba==1, cluster(sector)
margins, dydx(target_vote)

* Replicate persuasion versus turnout results

/* Effect of firm reporting goal of electing candidate on probability of doing GOTV mobilization */
logit contact_w2_reggotv_only goal_anycand 
margins, dydx(goal_anycand)

/* Effect of firm reporting goal of electing candidate on probability of doing partisan mobilization */
logit w2_contact_endorse_r goal_anycand
margins, dydx(goal_anycand)

* Appendix results

logit anycontact_w2 monitor union revenue_w2 companysize_w2 publiclytraded i.sector, cluster(sector)
estimates store m1

logit effect_mobil_1 monitor union revenue_w2 companysize_w2 publiclytraded i.sector if poldonate==1 & buyads==1 & lobby==1 & anyba==1, cluster(sector)
estimates store m2

logit effect_mobil_1 target_vote union revenue_w2 companysize_w2 publiclytraded i.sector if poldonate==1 & buyads==1 & lobby==1 & anyba==1, cluster(sector)
estimates store m3

estout m1 m2 m3 using appendix6.csv, cells(b(star fmt(2)) se(par fmt(2))) legend drop(_cons) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace

logit contact_w2_reggotv_only goal_anycand 
estimates store m4

logit contact_w2_reggotv_only goal_anycand union revenue_w2 companysize_w2 publiclytraded i.sector, cluster(sector)
estimates store m5

logit w2_contact_endorse_r goal_anycand
estimates store m6

logit w2_contact_endorse_r goal_anycand union revenue_w2 companysize_w2 publiclytraded i.sector, cluster(sector)
estimates store m7

estout m4 m5 m6 m7 using appendix7.csv, cells(b(star fmt(2)) se(par fmt(2))) legend drop(_cons) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace

cap log close
