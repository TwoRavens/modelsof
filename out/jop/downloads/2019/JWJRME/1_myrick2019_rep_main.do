*** Why So Secretive? Unpacking Public Attitudes Towards Secrecy and Sucess in U.S. Foreign Policy
*** Replication Data for the Journal of Politics
*** Myrick (2019)

**** REPLICATION OF MAIN ANALYSES IN ARTICLE

***SET WORKING DIRECTORY
cd ""

** Table 3: Treatment Effects from Experiment 1 (Secrecy + Use of Force)

clear
import delimited "2_exp1_data.csv", encoding(ISO-8859-1)
xtset caseid

gen covert_military = covert*military
gen covert_success = covert*success

estimates clear
eststo: quietly xtreg approve_before covert, fe 
eststo: quietly xtreg approve_after covert, fe 
eststo: quietly reg approve_before covert military, cluster(caseid)
eststo: quietly reg approve_before covert military covert_military, cluster(caseid)
eststo: quietly reg approve_after covert military success, cluster(caseid)
eststo: quietly reg approve_after covert success covert_success, cluster(caseid)
esttab using exp1_results.tex, label replace booktabs alignment(D{.}{.}{-1})se(3) title(Experiment 1) aic bic obslast compress nogaps 

** Table 4: Treatment Effects from Experiment 2 (Secrecy + Public Disapproval)

clear
import delimited "2_exp2_data.csv", encoding(ISO-8859-1)
xtset caseid

gen covert_negpub = covert*negpub
gen covert_success = covert*success

estimates clear
eststo: quietly xtreg approve_before covert, fe 
eststo: quietly xtreg approve_after covert, fe 
eststo: quietly reg approve_before covert negpub, cluster(caseid)
eststo: quietly reg approve_before covert negpub covert_negpub, cluster(caseid)
eststo: quietly reg approve_after covert negpub success, cluster(caseid)
eststo: quietly reg approve_after covert success covert_success, cluster(caseid)
esttab using exp2_results.tex, label replace booktabs alignment(D{.}{.}{-1})se(3) title(Experiment 2) aic bic obslast compress nogaps 

** Table 5: Treatment Effects from Experiment 3 (Secrecy + No Operational Advantage)

clear
import delimited "2_exp3_data.csv", encoding(ISO-8859-1)
xtset caseid

gen covert_military = covert_deceit*military
gen covert_success = covert_deceit*success

estimates clear
eststo: quietly xtreg approve_before covert_deceit, fe 
eststo: quietly xtreg approve_after covert_deceit, fe 
eststo: quietly reg approve_before covert_deceit military, cluster(caseid)
eststo: quietly reg approve_before covert_deceit military covert_military, cluster(caseid)
eststo: quietly reg approve_after covert_deceit military success, cluster(caseid)
eststo: quietly reg approve_after covert_deceit success covert_success, cluster(caseid)
esttab using exp3_results.tex, label replace booktabs alignment(D{.}{.}{-1})se(3) title(Experiment 3) aic bic obslast compress nogaps 

**** REPLICATION OF FIGURE 3: MAIN EFFECTS FROM EXPERIMENTS

***SET WORKING DIRECTORY
cd ""

*** Figure 3a: Main Treatment Effects from Experiment 1
clear
import delimited "2_exp1_data.csv", encoding(ISO-8859-1)
xtset caseid

reg approve_before covert military, cluster(caseid)
estimates store Before
reg approve_after covert military success, cluster(caseid)
estimates store After
coefplot Before After, drop(_cons) xline(0) xlabel(-1.5(0.5)1.5) ylabel(`covert' "Covert" `military' "Military" `success' "Success") scheme(s1mono) 

*** Figure 3b: Main Treatment Effects from Experiment 2
clear
import delimited "2_exp2_data.csv", encoding(ISO-8859-1)
xtset caseid

reg approve_before covert negpub, cluster(caseid)
estimates store Before
reg approve_after covert negpub success, cluster(caseid)
estimates store After
coefplot Before After, drop(_cons) xline(0) xlabel(-1.5(0.5)1.5) scheme(s1mono)

** Figure 3c: Main Treatment Effects from Experiment 2
clear
import delimited "2_exp3_data.csv", encoding(ISO-8859-1)
xtset caseid

reg approve_before covert military, cluster(caseid)
estimates store Before
reg approve_after covert military success, cluster(caseid)
estimates store After
coefplot Before After, drop(_cons) xline(0) xlabel(-1.5(0.5)1.5) scheme(s1mono) 

