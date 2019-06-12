/* 
Replication data for "American Employers as Political Machines"
Forthcoming in the Journal of Politics
Alexander Hertel-Fernandez
Columbia University 
School of International and Public Affairs
alexander.hertel@gmail.com
*/

* This code replicates the analysis in the paper using the 2015 CCES 

* Load data

use "CCES data.dta", clear

set more off
cap log close
cap log using "American Employers as Political Machines - CCES Analysis.smcl", replace

* Summarize extent of employer, union, and party mobilization among workers (that is, those in labor force)

sum emp_mobil union_mobil partycand_mobil if inlf==1 [aw=weight]

* Summarize political participation index (0-5)

sum participationindex if inlf==1 [aw=weight],d

* Summarize perceptions of employer monitoring

/* includes DK respondents */
sum emp_track_bin2 [aw=we] 

/* does not include not sure respondents */
sum emp_track_bin2 if emp_track!=3  [aw=we] 

* Summarize receipt of threats conditional on mobilization

sum warning_jobplantloss if emp_mobil==1 [aw=we]

* Replicate Table 1

reg participationindex emp_mobil union_mobil partycand_mobil [awe=we]
estimates store m1
reg participationindex emp_mobil union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age male famincr ideo_cons votedin2012 [awe=we]
estimates store m2
reg participationindex emp_mobil union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age male famincr ideo_cons pvid votedin2012 [awe=we], cluster(cd)
estimates store m3
reg participationindex emp_mobil union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age male famincr ideo_cons pvid votedin2012 i.statefip [awe=we], cluster(statefip)
estimates store m4

estout m1 m2 m3 m4 using tab1.csv, cells(b(star fmt(2)) se(par fmt(2))) legend drop(_cons) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace

* Compare coefficient sizes between employer and union mobilization

reg participationindex emp_mobil union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age male famincr ideo_cons pvid votedin2012 i.statefip [awe=we], cluster(statefip)
lincom emp_mobil-union_mobil

teffects psmatch (participationindex) (emp_mobil  current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012) 
teffects psmatch (participationindex) (union_mobil  current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012)
teffects psmatch (participationindex) (partycand_mobil  current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012) 

* Replicate Table 2

reg participationindex emp_mobil##emp_track_bin2 union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [awe=we]
estimates store m5

estout m5  using tab2.csv, cells(b(star fmt(2)) se(par fmt(2))) legend drop(_cons) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace

* Post-estimation for Table 2

reg participationindex emp_mobil##emp_track_bin2 union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [awe=we]
margins, dydx(emp_mobil) over(emp_track_bin2)
margins, dydx(emp_mobil) over(emp_track_bin2) coefleg post
lincom _b[1.emp_mobil:1.emp_track_bin2]- _b[1.emp_mobil:0bn.emp_track_bin2]

* Replicate Appendix results

/* Effect of employer mobilization on individual political acts */

logit vote2014 emp_mobil union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons pvid votedin2012 i.statefip [pwe=we], cluster(statefip)
estimates store a1
logit attendedpoliticalmeeting emp_mobil union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons pvid votedin2012 i.statefip [pwe=we], cluster(statefip)
estimates store a2
logit contactedlawmaker emp_mobil union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons pvid votedin2012 i.statefip [pwe=we], cluster(statefip)
estimates store a3
logit madedona emp_mobil union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons pvid votedin2012 i.statefip [pwe=we], cluster(statefip)
estimates store a4
logit volunteeredcamp emp_mobil union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons pvid votedin2012 i.statefip [pwe=we], cluster(statefip)
estimates store a5

estout a1 a2 a3 a4 a5 using appendix1.csv, cells(b(star fmt(2)) se(par fmt(2))) legend drop(_cons) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace

/* Exclude not sure respondents from perceptions of employer monitoring */

reg participationindex emp_mobil##emp_track_bin ideo_cons union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [awe=we] if emp_track!=3
estimates store a1

estout a1 using appendix2.csv, cells(b(star fmt(2)) se(par fmt(2))) legend drop(_cons) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace

/* Effect of unemployment on employer mobilization */

logit vote2014 emp_mobil##c.unempratec union_mobil##c.unempratec partycand_mobil##c.unempratec current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [pwe=we], cluster(countyfip)
estimates store a1
logit attendedpoliticalmeeting emp_mobil##c.unempratec union_mobil##c.unempratec partycand_mobil##c.unempratec current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [pwe=we], cluster(countyfip)
estimates store a2
logit contactedlawmaker emp_mobil##c.unempratec union_mobil##c.unempratec partycand_mobil##c.unempratec current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [pwe=we], cluster(countyfip)
estimates store a3
logit madedona emp_mobil##c.unempratec union_mobil##c.unempratec partycand_mobil##c.unempratec current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [pwe=we], cluster(countyfip)
estimates store a4
logit volunteeredcamp emp_mobil##c.unempratec union_mobil##c.unempratec partycand_mobil##c.unempratec current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012  [pwe=we], cluster(countyfip)
estimates store a5

estout a1 a2 a3 a4 a5 using appendix3.csv, cells(b(star fmt(2)) se(par fmt(2))) legend drop(_cons) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace

/* Effect of monitoring on individual political acts */

reg vote2014 emp_mobil##emp_track_bin2 union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [awe=we]
estimates store a1
reg attendedpoliticalmeeting emp_mobil##emp_track_bin2 union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [awe=we]
estimates store a2
reg contactedlawmaker emp_mobil##emp_track_bin2 union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [awe=we]
estimates store a3
reg madedona emp_mobil##emp_track_bin2 union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [awe=we]
estimates store a4
reg volunteeredcamp emp_mobil##emp_track_bin2 union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [awe=we]
estimates store a5

estout a1 a2 a3 a4 a5 using appendix4.csv, cells(b(star fmt(2)) se(par fmt(2))) legend drop(_cons) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace

/* Effect of economic threats */

reg participationindex warning_jobplant union_mobil partycand_mobil current i.educ3 white black hispanicr polinterest c.age famincr male ideo_cons votedin2012 [awe=we]
estimates store a1

estout a1 using appendix5.csv, cells(b(star fmt(2)) se(par fmt(2))) legend drop(_cons) stats(r2 N) starlevels(* 0.10 ** 0.05 *** 0.01) replace

cap log close


