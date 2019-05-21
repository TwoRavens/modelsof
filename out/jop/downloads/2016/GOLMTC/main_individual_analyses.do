set memory 999999
cd "C:\Users\Daniel de Kadt\Dropbox (Personal)\Projects\SA_cohort_effects\replication"

use  "sasas_ddk12.dta", clear

*************************************
********** PAPER RESULTS ************
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

*Main Effect Estimates - Table 2
eststo: quietly reg vote treat if force>-2 & force<2 & race==1, vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote treat if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote treat if force>-2 & force<2 & race==1, a(province) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote treat i.province if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))

	esttab using "maineffectstab.tex", se r2 label title(Estimated ITT of Past Participation on Future Participation \label{results_tab}) addnote("Standard errors clustered by year in parentheses") keep(treat) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear

*Black v. White v. Coloured - Table 3
eststo: quietly areg vote treat if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote treat if force>-2 & force<2 & race==2, a(year) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote treat if force>-2 & force<2 & race==4, a(year) vce(bootstrap, cluster(time) reps(1000))
	
	esttab using "heteroeffects.tex", se r2 label title(Heterogeneous Effects by Race Group \label{white_black_results}) addnote("Standard errors clustered by year in parentheses") keep(treat) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear

*Alternative Channels - Table 4
eststo: quietly areg trust_gov treat  if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg democ_satis treat  if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote_duty treat  if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote_pointless treat  if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg sa_identity treat  if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))
eststo: quietly areg vote_anc treat  if force>-2 & force<2 & race==1, a(year) vce(bootstrap, cluster(time) reps(1000))
	esttab using "altmechanisms.tex", se r2 label title(Alternative Channels \label{attitude_results_tab}) addnote("Standard errors clustered by year in parentheses") keep(treat) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace
	eststo clear
	

