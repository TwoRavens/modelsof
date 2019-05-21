set memory 999999
cd "C:\Users\Daniel de Kadt\Dropbox (Personal)\Projects\SA_cohort_effects\replication"

use  "sasas_ddk12.dta", clear

*************************************
********* APPENDIX RESULTS **********
*************************************
***FOR TABLES, RESCALE:
replace vote=vote*100
replace vote_dk = vote_dk*100
replace vote_nr=vote_nr*100
replace trust_gov = trust_gov*100
replace democ_satis = democ_satis*100
replace vote_duty = vote_duty*100
replace vote_pointless = vote_pointless*100
replace sa_identity  = sa_identity*100

***Set seed for exact replication of bootstrap results***
set seed 02141

*DK table
eststo: quietly reg vote_dk treat if force>-2 & force<2 & race==1, vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote_dk treat if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote_dk treat if force>-2 & force<2 & race==1, a(province) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote_dk treat i.province if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))

	esttab using "results\dkeffectstab.tex", se r2 label title(Estimated ITT of Past Participation on ``Don't Know" or ``Refuse to Respond" \label{dk_vote_tb}) addnote("Standard errors clustered by year in parentheses") keep(treat) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear
	
*Replication of effect for 1999 election: 
eststo: quietly reg vote treat_99 if force>-7 & force<-3 & race==1, vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote treat_99 if force>-7 & force<-3 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote treat_99 if force>-7 & force<-3 & race==1, a(province) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote treat_99 i.province if force>-7 & force<-3 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))

	esttab using "99_treatment.tex", se r2 label title(Replication of main result with 1999 Election \label{1999_results}) addnote("Standard errors clustered by year in parentheses") keep(treat_99) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear

*Placebo table:
eststo: quietly areg vote treat if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))
**2 year
eststo: quietly areg vote plac_treat_92  if force>-1 & force<4 & race==1, a(time)  vce(bootstrap, cluster(time) reps(1000))
**5 year
eststo: quietly areg vote plac_treat_5  if plac_force_5>-2 & plac_force_5<2 & race==1, a(time) vce(bootstrap, cluster(time) reps(1000))
**10 year
eststo: quietly areg vote plac_treat_10  if plac_force_10>-2 & plac_force_10<2 & race==1, a(time) vce(bootstrap, cluster(time) reps(1000))
**15 year
eststo: quietly areg vote plac_treat_15  if plac_force_15>-2 & plac_force_15<2 & race==1, a(time) vce(bootstrap, cluster(time) reps(1000))
**20 year
eststo: quietly areg vote plac_treat_20  if plac_force_20>-2 & plac_force_20<2 & race==1, a(time)  vce(bootstrap, cluster(time) reps(1000))
**25 year
eststo: quietly areg vote plac_treat_25  if plac_force_25>-2 & plac_force_25<2 & race==1, a(time)  vce(bootstrap, cluster(time) reps(1000))
	esttab using "placebo_analyses.tex", se r2 label title(Placebo tests using alternative time cut offs \label{placebo_table}) addnote("Standard errors clustered by year in parentheses") keep(treat plac_treat_92 plac_treat_5 plac_treat_10 plac_treat_15 plac_treat_20 plac_treat_25) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear
	

