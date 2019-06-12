*** Why So Secretive? Unpacking Public Attitudes Towards Secrecy and Sucess in U.S. Foreign Policy
*** Replication Data for the Journal of Politics
*** Myrick (2019)

**** REPLICATION OF APPENDIX C: Further Replications and Robustness Checks

**** SET WORKING DIRECTORY HERE FIRST ****
*** cd ""

*** Table C.1 Replication Using Condensed Experiment 1 (Non-Sequential) 

clear
import delimited "2_exp4_data.csv", encoding(ISO-8859-1)
xtset caseid

gen covert_military = covert*military
gen covert_success = covert*success

estimates clear
eststo: quietly xtreg approve covert, fe vce(robust) 
eststo: quietly reg approve covert military, cluster(caseid)
eststo: quietly reg approve covert military covert_military, cluster(caseid)
eststo: quietly reg approve covert military success, cluster(caseid)
eststo: quietly reg approve covert success covert_success, cluster(caseid)
esttab using exp4_results.tex, label replace booktabs alignment(D{.}{.}{-1})se(3) title(Experiment 1 - Replication with No Sequential Results) aic bic obslast compress nogaps 

*** Table C.2 Replication of Table 3 (Experiment 1) Using Logistic Regression (Binary DV)

clear
import delimited "2_exp1_data.csv", encoding(ISO-8859-1)
xtset caseid

gen covert_military = covert*military
gen covert_success = covert*success

eststo: quietly xtlogit approve_b_before covert, fe nolog
eststo: quietly xtlogit approve_b_after covert, fe nolog
eststo: quietly logit approve_b_before covert military, cluster(caseid)
eststo: quietly logit approve_b_before covert military covert_military, cluster(caseid)
eststo: quietly logit approve_b_after covert military success, cluster(caseid)
eststo: quietly logit approve_b_after covert success covert_success, cluster(caseid)
esttab using exp1_log.tex, label replace booktabs alignment(D{.}{.}{-1}) title(Experiment 1 Results (Logistic Regression)) se(3) aic bic obslast compress nogaps 

*** Table C.3 Replication of Table 4 (Experiment 2) Using Logistic Regression (Binary DV)

clear
import delimited "2_exp2_data.csv", encoding(ISO-8859-1)
xtset caseid

gen covert_negpub = covert*negpub
gen covert_success = covert*success

eststo: quietly xtlogit approve_b_before covert, fe nolog
eststo: quietly xtlogit approve_b_after covert, fe nolog
eststo: quietly logit approve_b_before covert negpub, cluster(caseid)
eststo: quietly logit approve_b_before covert negpub covert_negpub, cluster(caseid)
eststo: quietly logit approve_b_after covert negpub success, cluster(caseid)
eststo: quietly logit approve_b_after covert success covert_success, cluster(caseid)
esttab using exp2_log.tex, label replace booktabs alignment(D{.}{.}{-1}) title(Experiment 2 Results (Logistic Regression)) se(3) aic bic obslast compress nogaps 

*** Table C.4 Replication of Table 5 (Experiment 3) Using Logistic Regression (Binary DV)

clear
import delimited "2_exp3_data.csv", encoding(ISO-8859-1)
xtset caseid

gen covert_military = covert_deceit*military
gen covert_success = covert_deceit*success

eststo: quietly xtlogit approve_b_before covert_deceit, fe nolog
eststo: quietly xtlogit approve_b_after covert_deceit, fe nolog
eststo: quietly logit approve_b_before covert_deceit military, cluster(caseid)
eststo: quietly logit approve_b_before covert_deceit military covert_military, cluster(caseid)
eststo: quietly logit approve_b_after covert_deceit military success, cluster(caseid)
eststo: quietly logit approve_b_after covert_deceit success covert_success, cluster(caseid)
esttab using exp3_log.tex, label replace booktabs alignment(D{.}{.}{-1}) title(Experiment 3 Results (Logistic Regression)) se(3) aic bic obslast compress nogaps 

*** Table C.5 Replication of Table 3 (Experiment 1) Using Ordinal Logistic Regression (Ordinal DV)

clear
import delimited "2_exp1_data.csv", encoding(ISO-8859-1)
xtset caseid

gen covert_military = covert*military
gen covert_success = covert*success

** Note: Thiis is an FE OLOGIT using the BUC estimator

program bucologit
version 11.2
syntax varlist [if] [in], Id(varname)
preserve
marksample touse
markout `touse' `id'
gettoken yraw x : varlist
tempvar y
qui egen int `y' = group(`yraw')
qui keep `y' `x' `id' `touse'
qui keep if `touse'
qui sum `y'
local ymax = r(max)
forvalues i = 2(1)`ymax' {
qui gen byte `yraw'`i' = `y' >= `i'
}
drop `y'
tempvar n cut newid
qui gen long `n' = _n
qui reshape long `yraw', i(`n') j(`cut')
qui egen long `newid' = group(`id' `cut')
sort `newid'
clogit `yraw' `x', group(`newid') cluster(`id')
restore
end

eststo: quietly bucologit approve_before covert, i(caseid)
eststo: quietly bucologit approve_after covert, i(caseid)
eststo: quietly ologit approve_before covert military, vce(cluster caseid)
eststo: quietly ologit approve_before covert military covert_military, vce(cluster caseid)
eststo: quietly ologit approve_after covert military success, vce(cluster caseid)
eststo: quietly ologit approve_after covert success covert_success, vce(cluster caseid) 
esttab using exp1_olog.tex, label replace booktabs alignment(D{.}{.}{-1}) title(Experiment 1 Results (Ordered Logistic Regressions)) se(3) aic bic obslast compress nogaps 

*** Table C.6 Replication of Table 4 (Experiment 2) Using Ordinal Logistic Regression (Ordinal DV)

clear
import delimited "2_exp2_data.csv", encoding(ISO-8859-1)
xtset caseid

gen covert_negpub = covert*negpub
gen covert_success = covert*success


eststo: quietly bucologit approve_before covert, i(caseid)
eststo: quietly bucologit approve_after covert, i(caseid)
eststo: quietly ologit approve_before covert negpub, vce(cluster caseid)
eststo: quietly ologit approve_before covert negpub covert_negpub, vce(cluster caseid)
eststo: quietly ologit approve_after covert negpub success, vce(cluster caseid)
eststo: quietly ologit approve_after covert success covert_success, vce(cluster caseid) 
esttab using exp2_olog.tex, label replace booktabs alignment(D{.}{.}{-1}) title(Experiment 2 Results (Ordered Logistic Regressions)) se(3) aic bic obslast compress nogaps 

*** Table C.7 Replication of Table 5 (Experiment 3) Using Ordinal Logistic Regression (Ordinal DV)

clear
import delimited "2_exp3_data.csv", encoding(ISO-8859-1)
xtset caseid

gen covert_military = covert_deceit*military
gen covert_success = covert_deceit*success

eststo: quietly bucologit approve_before covert_deceit, i(caseid)
eststo: quietly bucologit approve_after covert_deceit, i(caseid)
eststo: quietly ologit approve_before covert_deceit military, vce(cluster caseid)
eststo: quietly ologit approve_before covert_deceit military covert_military, vce(cluster caseid)
eststo: quietly ologit approve_after covert_deceit military success, vce(cluster caseid)
eststo: quietly ologit approve_after covert_deceit success covert_success, vce(cluster caseid) 
esttab using exp3_olog.tex, label replace booktabs alignment(D{.}{.}{-1}) title(Experiment 3 Results (Ordered Logistic Regressions)) se(3) aic bic obslast compress nogaps 

*** Table C.8 Replication of Table 4 (Experiment 2), Conditional on Passing Manipulation Check

clear
import delimited "2_exp2_data_mcheck.csv", encoding(ISO-8859-1)
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
esttab using exp2_mcheck_results.tex, label replace booktabs alignment(D{.}{.}{-1})se(3) title(Experiment 2 (Passed Manipulation Check)) aic bic obslast compress nogaps 
