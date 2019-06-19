/************************************************************
                        MANOJ MOHANAN
* Causal Effects of Health Shocks on Consumption and Debt:  *
*  Quasi-Experimental Evidence from Bus Accident Injuries   *

*   Review of Economics and Statistics 2013 95:2, 673-681   *
                   
*************************************************************
NOTES: THIS PROGRAM ALSO OPENS THE CODING .DO FILE AND THEN RUNS THE ANALYSES
************************************************************/


clear
set more off
set mem 20m
set linesize 255
set matsize 450
set logtype text

* SPECIFY DIRECTORY PATH HERE
cd INSERT-DIRECTORY-PATH-HERE
log using LOGNAME.txt, replace


***************************************
* THIS STEP WILL RUN THE .DO FILE FOR *
* RECODING AND CLEANING THE DATA      *
* IT WILL SAVE A NEW DATASET          *
*      “echos-analysis-RESTAT.dta”    * 
***************************************

do "Coding.do"

******************
* ANALYSIS STEPS *
******************


************************************
* Table 1 -- verifying the match:
*************************************

*PANEL A

tab sex trans, col chi
ttest age_1, by(trans)
tab urbrur trans, col chi2

*PANEL B
tab hindu trans, col chi2
reg hindu trans, cluster(acc)

tab caste trans, col chi2
reg caste trans, cluster(acc)

tab newoccup trans, col chi2
gen farmpoul = 1 if newoccu ==1
replace farmpoul = 0 if newoccu != 1 & trans != .
tab farmpoul trans, col chi2
reg farmpoul trans, cluster(acc)

gen daylab = 1 if newocc == 2
replace daylab = 0 if newoccu != 2 & trans != .
tab daylab trans, col chi2
reg daylab trans, cluster(acc)

tab illit trans, col chi2
reg illit trans, cluster(acc)

tab educ_1 trans, col chi2
ttest mem, by (trans) unequal
reg mem trans, cluster(id)

ttest totinc, by (trans) unequal
reg totinc trans, cluster(acc)

ttest assetscore, by (trans) unequal
reg assetscore trans, cluster(acc)

ttest totexp_exp, by(tran) unequal
bysort trans: sum totexp_exp
sum totexp_exp if tran == 1 & totexp_exp!= 0 & exp ==1 
sum ratio if tran == 1 & totexp_exp!= 0 & exp ==1  


ttest comp, by(trans) unequal

bysort trans: sum spend30 spendcalc spendnh spendmth food 
bysort trans: sum educ_yr if educ_yr !=. & educ_yr > 0
bysort trans: sum hlth_yr if hlth_yr !=. & hlth_yr > 0
bysort trans: sum fest_yr if fest_yr !=. & fest_yr > 0
ttest spend30, by (trans) unequal
ttest spendcalc, by (trans) unequal
ttest spendnh, by (trans) unequal
ttest spendmth, by (trans) unequal
ttest spendhouse, by (trans)
ttest food, by (trans) unequal
ttest spendfest12, by (trans) unequal
ttest educ_yr if schoolkid > 0 , by (trans) unequal
ttest hlth_yr if hlth_yr !=. & hlth_yr > 0, by (trans) unequal
tab nztoth trans, col exact
tab nzed trans, col chi
ttest fest_yr if fest_yr !=. & fest_yr > 0, by (trans) unequal

ttest annint, by(trans)

*****************************************************************************
***********************
* Table 2
***********************
tab head
tab self exp, col chi
tab das_phy exp, col chi
tab anyhosp exp, col chi
tab anymill exp, col chi
tab anychr exp, col chi

*************************************
* RESULTS TABLES *
*************************************

*************************************
* TABLE 3 *
*************************************

reg spendhouse trans, cluster(acc)
reg spendfood trans, cluster(acc)
reg spendfest12 trans, cluster(acc)
reg tothealth trans, cluster(acc)
reg nztoth trans, cluster(acc)
reg hlth_yr trans, cluster(acc)
reg educ_yr trans if educ_yr != 0, cluster(acc)
reg nzed trans, cluster(acc)
reg assetpurch trans, cluster(acc)
reg assetsell trans, cluster(acc)
reg assetpled trans, cluster(acc)
reg debt trans, cluster(acc)
reg totdebt trans, cluster(acc)
reg borrow trans, cluster(acc)
reg amtborr trans, cluster(acc)
reg annint trans, cluster(acc)


*************************************
* TABLE 4 *
/*NOTES:
for health expenditures, only households with nonzero health expenditures are included (hence lnhlth)
if the 16 records w 0 hlth expenditures are to be included, use lnlth1 */
*************************************

eststo clear
eststo: quietly xi: reg lnhouse trans comp age_1 sex i.school caste mem , robust cluster(acc)
eststo: quietly xi: reg lnfood  trans comp age_1 sex i.school caste mem , robust cluster(acc)
eststo: quietly xi: reg lnfest  trans comp age_1 sex i.school caste mem , robust cluster(acc)
eststo: quietly xi: reg lnhlth  trans comp age_1 sex i.school caste mem , robust cluster(acc)
eststo: quietly xi: reg lneduc  trans comp age_1 sex i.school caste mem , robust cluster(acc)
estout , cells(b(star fmt(%9.2f)) se(par)) starlevels(* 0.05 ** 0.01 *** 0.001) stats(N chi2 bic, star(chi2) fmt(%9.0g %9.3f)) mlabel("Model") label collabels("") varlabels(_cons Constant) varwidth(15) modelwidth(10) prefoot("") postfoot("") legend style(fixed) 

eststo clear
eststo: quietly xi: logit debt trans comp age_1 sex caste i.school mem, robust cluster(acc) or
eststo: quietly xi: logit debt trans comp age_1 sex caste i.school mem i.assetind i.newocc, robust cluster(acc) or
eststo: quietly xi: logit borrow trans comp age_1 sex caste i.school mem, robust cluster(acc) or
eststo: quietly xi: logit borrow trans comp age_1 sex caste i.school mem i.assetind i.newocc, robust cluster(acc) or
estout , cells(b(star fmt(%9.2f)) se(par)) starlevels(* 0.05 ** 0.01 *** 0.001) stats(N chi2 bic, star(chi2) fmt(%9.0g %9.3f)) mlabel("Model") label collabels("") varlabels(_cons Constant) varwidth(25) modelwidth(10) prefoot("") postfoot("") legend style(fixed) eform append

xi: oddsrisk debt trans comp age_1 sex caste i.school mem
xi: oddsrisk borrow trans comp age_1 sex caste i.school mem

*************************************


log close
save, replace
clear
exit


