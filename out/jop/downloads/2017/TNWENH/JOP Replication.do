************************************************************
**Replication files for
**"Do Enclaves Remediate Social Inequality?"
**Christopher F. Karpowitz and Tali Mendelberg
**Accepted at The Journal of Politics
**
**Replication files compiled August 2017
************************************************************


****************************
**Individual-level Analysis
****************************

**Place datasets in a folder and change the directory to that folder

**Ex: cd "/Data/Enclaves/Replication Data"

cd "Place path to data files here"

use "JOP Replication_Enclaves_Individual.dta", clear
set more off

**Tables in main text of the manuscript

**Table 1: Interruptions
reg mean_prop_turns_pos_ee_women i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg mean_prop_turns_pos_ee_women i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg mean_negpos_ee_women i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg mean_negpos_ee_women i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)


reg mean_prop_turns_pos_ee_women i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg mean_prop_turns_pos_ee_women i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg mean_negpos_ee_women i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg mean_negpos_ee_women i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)

**Table 2: Self-efficacy
reg grp_voice_101 i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg grp_voice_101 i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg grp_voice_201 i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg grp_voice_201 i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)

reg grp_voice_101 i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg grp_voice_101 i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg grp_voice_201 i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg grp_voice_201 i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)

**Table 3: Ability to implement preferences
reg rankcert_201 i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg rankcert_201 i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg Maxest_Pro i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg Maxest_Pro i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)

reg rankcert_201 i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg rankcert_201 i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg Maxest_Pro i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg Maxest_Pro i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
**Group-level analysis for Table 3 found below

**Table 4: Issue Agenda
reg femissues i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg femissues i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg mascissues i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg mascissues i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)

reg femissues i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg femissues i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg mascissues i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg mascissues i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)

**Table 5: Talk Time and Influence
reg PercentTime i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg PercentTime i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg g_vote_noself i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg g_vote_noself i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)

reg PercentTime i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg PercentTime i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg g_vote_noself i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg g_vote_noself i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)


**Robustness check: negative binomial regression (referenced in Footnote 4)
nbreg g_vote_noself i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
nbreg g_vote_noself i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)

nbreg g_vote_noself i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
nbreg g_vote_noself i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)


**Table 6: Satisfaction with Group Processes
reg grp_acc_av01 i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg grp_acc_av01 i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg grp_fewdomin_01 i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg grp_fewdomin_01 i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg grp_satis_index i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg grp_satis_index i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg grp_agree_index i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg grp_agree_index i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==0, cluster(group_id)


reg grp_acc_av01 i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg grp_acc_av01 i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg grp_fewdomin_01 i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg grp_fewdomin_01 i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg grp_satis_index i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg grp_satis_index i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg grp_agree_index i.enclave princeton if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)
reg grp_agree_index i.enclave princeton num_egals if female==1&(num_fem==4|num_fem==5) & maj==1, cluster(group_id)

**Table 7: Diff-in-diff interactions
reg mean_prop_turns_pos_ee_women i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg mean_negpos_ee_women i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg grp_voice_201 i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg rankcert_201 i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg Maxest_Pro i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg PercentTime i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg g_vote_noself i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
**Group-level analysis for Table 7 found below

**Figure 1 with ICIs using Tryon's Method
cd "/Users/cfk/Dropbox/Deliberative Justice Project/Enclaves/Analysis/JOP Second RR Analysis/Figures"

*E=0.7189661
*Adjusted confidence level = 0.7189661*0.95 or 0.7189661*0.90
reg Maxest_Pro i.enclave princeton num_egals if female==1 & (num_fem==4|num_fem==5) & maj==0, cluster(group_id)
margins i.enclave, level(68)
marginsplot, recast(bar) name(fem_margbar_Maxest_Pro_ici_unan, replace) ylabel(20(5)40)
**Group-level analysi for Figure 1 found below


**Supporting Information Appendix

**Table A1: Randomization Checks
**Randomization Tests
for var equal_index educ income age: ttest X if female==1&(num_fem==4|num_fem==5), by(enclave)
for var equal_index educ income age: ranksum X if female==1&(num_fem==4|num_fem==5), by(enclave)
for var equal_index educ income age: ksmirnov X if female==1&(num_fem==4|num_fem==5), by(enclave)

**Table A2: Descriptive Statistics (Individual Level)
sutex educ income age equal_index conf_index conf_hi mean_prop_turns_pos_ee_women mean_negpos_ee_women grp_voice_101 grp_voice_201 rankcert_201 Maxest_Pro femissues mascissues PercentTime g_vote_noself grp_acc_av01  grp_fewdomin_01 grp_satis_index grp_agree_index if female==1 & (num_fem==4|num_fem==5)

**Table A3: Marginal Effects of Enclaves by Pre-Treatment Confidence and Decision Rule
reg grp_voice_101 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
margins i.conf_hi, dydx(enclave)
reg grp_voice_101 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
margins i.conf_hi, dydx(enclave)

reg grp_voice_201 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
margins i.conf_hi, dydx(enclave)
reg grp_voice_201 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
margins i.conf_hi, dydx(enclave)

reg rankcert_201 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
margins i.conf_hi, dydx(enclave)
reg rankcert_201 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
margins i.conf_hi, dydx(enclave)


**Table A4: Interaction between Confidence and Enclaves, by Decision Rule
reg grp_voice_101 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
reg grp_voice_201 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
reg rankcert_201 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)

reg grp_voice_101 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
reg grp_voice_201 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
reg rankcert_201 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)


**Table A5: Marginal Effects of Enclaves on Group Evalaution by Pre-Treatment Confidence
reg grp_acc_av01 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
margins i.conf_hi, dydx(enclave)
reg grp_fewdomin_01 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
margins i.conf_hi, dydx(enclave)
reg grp_satis_index i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
margins i.conf_hi, dydx(enclave)
reg grp_agree_index i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
margins i.conf_hi, dydx(enclave)

reg grp_acc_av01 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
margins i.conf_hi, dydx(enclave)
reg grp_fewdomin_01 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
margins i.conf_hi, dydx(enclave)
reg grp_satis_index i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
margins i.conf_hi, dydx(enclave)
reg grp_agree_index i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
margins i.conf_hi, dydx(enclave)


**Table A6: Interaction between Donfidence and Enclaves, by Decision Rule
reg grp_acc_av01 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
reg grp_fewdomin_01 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
reg grp_satis_index i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)
reg grp_agree_index i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==0, cluster(group_id)

reg grp_acc_av01 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
reg grp_fewdomin_01 i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
reg grp_satis_index i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)
reg grp_agree_index i.enclave##i.conf_hi princeton num_egals if female==1&(num_fem==4|num_fem==5)&maj==1, cluster(group_id)


**Table A7: Difference-in-Differences across Decision Rules
reg mean_prop_turns_pos_ee_women i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg mean_negpos_ee_women i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg grp_voice_201 i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg rankcert_201 i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg Maxest_Pro i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg PercentTime i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)
reg g_vote_noself i.enclave##i.unan princeton num_egals if female==1&(num_fem==4|num_fem==5), cluster(group_id)


**Table A8: Robustness Check: Main Effects of Enclaves Compared to Groups of 3 or 4 Women
**These test only the results that were statistically significant in previous tables
reg mean_prop_turns_pos_ee_women i.enclave princeton num_egals if female==1&(num_fem==3|num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg grp_voice_201 i.enclave princeton num_egals if female==1&(num_fem==3|num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg rankcert_201 i.enclave princeton num_egals if female==1&(num_fem==3|num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg Maxest_Pro i.enclave princeton num_egals if female==1&(num_fem==3|num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg PercentTime i.enclave princeton num_egals if female==1&(num_fem==3|num_fem==4|num_fem==5) & maj==0, cluster(group_id)
reg g_vote_noself i.enclave princeton num_egals if female==1&(num_fem==3|num_fem==4|num_fem==5) & maj==0, cluster(group_id)


**Table A9: Main Effects of Enclaves on Men (Unanimous Groups Only), Individual-level analysis
**Unanimous Rule
reg mean_prop_turns_pos_ee_men i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg mean_negpos_ee_men i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg grp_voice_101 i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg grp_voice_201 i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg rankcert_201 i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg Maxest_Pro i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
**Group-level analysis below
reg femissues i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg mascissues i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg PercentTime i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg g_vote_noself i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg grp_acc_av01 i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg grp_fewdomin_01 i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg grp_satis_index i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)
reg grp_agree_index i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==0, cluster(group_id)

**Table A10: Main Effects of Enclaves on Men (Unanimous Groups Only), Individual-level analysis
reg mean_prop_turns_pos_ee_men i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg mean_negpos_ee_men i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg grp_voice_101 i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg grp_voice_201 i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg rankcert_201 i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg Maxest_Pro i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
**Group-level analysis below
reg femissues i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg mascissues i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg PercentTime i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg g_vote_noself i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg grp_acc_av01 i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg grp_fewdomin_01 i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg grp_satis_index i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)
reg grp_agree_index i.enclave princeton num_egals if female==0&(num_fem==0|num_fem==1) & maj==1, cluster(group_id)


**Table A11: Difference-in-Differences Tests of Effect of Enclaves across Decision Rule among Men
reg mean_prop_turns_pos_ee_men i.enclave##i.unan princeton num_egals if female==0&(num_fem==0|num_fem==1), cluster(group_id)
reg mean_negpos_ee_men i.enclave##i.unan princeton num_egals if female==0&(num_fem==0|num_fem==1), cluster(group_id)
reg grp_voice_101 i.enclave##i.unan princeton num_egals if female==0&(num_fem==0|num_fem==1), cluster(group_id)
reg grp_voice_201 i.enclave##i.unan princeton num_egals if female==0&(num_fem==0|num_fem==1), cluster(group_id)
reg rankcert_201 i.enclave##i.unan princeton num_egals if female==0&(num_fem==0|num_fem==1), cluster(group_id)
reg Maxest_Pro i.enclave##i.unan princeton num_egals if female==0&(num_fem==0|num_fem==1), cluster(group_id)
**Group-level analysis below
reg femissues i.enclave##i.unan princeton num_egals if female==0&(num_fem==0|num_fem==1), cluster(group_id)
reg mascissues i.enclave##i.unan princeton num_egals if female==0&(num_fem==0|num_fem==1), cluster(group_id)
reg PercentTime i.enclave##i.unan princeton num_egals if female==0&(num_fem==0|num_fem==1), cluster(group_id)
reg g_vote_noself i.enclave##i.unan princeton num_egals if female==0&(num_fem==0|num_fem==1), cluster(group_id)


***********************
**Group-level analysis
***********************


use "JOP Replication_Enclaves_Group.dta", clear

**Table 3: Ability to Implement Preferences, Group-Level Analysis (Models 9-12)
reg floor4 i.enclave princeton if (num_fem==4|num_fem==5) & maj==0, cluster(group_id) level(90)
reg floor4 i.enclave princeton num_egals if (num_fem==4|num_fem==5) & maj==0, cluster(group_id) level(90)

reg floor4 i.enclave princeton if (num_fem==4|num_fem==5) & maj==1, cluster(group_id) level(90)
reg floor4 i.enclave princeton num_egals if (num_fem==4|num_fem==5) & maj==1, cluster(group_id) level(90)

**Table 7: Difference-in-Differences Tests of Effect of Enclaves across Decision Rule
reg floor4 i.enclave##i.unan princeton num_egals if (num_fem==4|num_fem==5), cluster(group_id) level(90)

**Figure 1
**Recalculating level for ICI adjustment
*E=0.7095943
*Adjusted confidence level=0.7095943*.95 or 0.7095943*.90
reg floor4 i.enclave princeton num_egals if (num_fem==4|num_fem==5) & maj==0, cluster(group_id)
margins i.enclave, level(67)
marginsplot, recast(bar) name(fem_margbar_floor4_ici_unan, replace) ylabel(20(5)40)



**Supporting Information Appendix
**Table A2: Summary Statistics, Groups with 4-5 Women -- Group Level
sutex enclave floor4  num_egals if num_fem==4|num_fem==5

**Table A7: Difference-in-Differences across Decision Rules (Model 6)
reg floor4 i.enclave##i.unan princeton num_egals if (num_fem==4|num_fem==5), cluster(group_id) level(90)

**Table A8: Robustness Check: Main Effects of Enclaves Compared to Groups of 3 or 4 Women (Model 5)
reg floor4 i.enclave princeton num_egals if (num_fem==3|num_fem==4|num_fem==5) & maj==0, cluster(group_id) level(90)

**Table A9: Main Effects of Enclaves on Men (Unanimous Groups Only, Model 7)
reg floor4 i.enclave princeton num_egals if (num_fem==0|num_fem==1) & maj==0, cluster(group_id)

**Table A10: Main Effects of Enclaves on Men (Majority Groups Only, Model 7)
reg floor4 i.enclave princeton num_egals if (num_fem==0|num_fem==1) & maj==1, cluster(group_id)

**Table A11: Difference-in-Differences Test of Effect of Enclaves across Decision Rule among Men
reg floor4 i.enclave##i.unan princeton num_egals if (num_fem==0|num_fem==1), cluster(group_id)



*******************************
**False Discovery Rate Analysis
*******************************

**Figure A1: False Discovery Rate (Unanimous Groups Only)
use "JOP Replication_Enclaves_Individual.dta", clear

**If desired, change directory to a folder for files associated with this analysis
**Ex.: cd "/Data/Enclaves/Replication Data/FDR Adjustments"

local i=1

foreach var of varlist mean_prop_turns_pos_ee_women mean_negpos_ee_women grp_voice_101 grp_voice_201 rankcert_201 Maxest_Pro femissues mascissues PercentTime g_vote_noself grp_acc_av01 grp_fewdomin_01 grp_satis_index grp_agree_index { 

reg `var' i.enclave princeton num_egals if female==1 & (num_fem==4|num_fem==5) & maj==0, cluster(group_id)
parmest, saving(pval_temp`i', replace) 
local i=`i'+1

}

foreach var of varlist mean_prop_turns_pos_ee_women mean_negpos_ee_women grp_voice_101 grp_voice_201 rankcert_201 Maxest_Pro femissues mascissues PercentTime g_vote_noself grp_acc_av01 grp_fewdomin_01 grp_satis_index grp_agree_index { 
*reg `var' i.enclave princeton if female==1 & (num_fem==4|num_fem==5) & maj==0, cluster(group_id)
*parmest, saving(pval_temp`i', replace) 
*local i=`i'+1
reg `var' i.enclave princeton num_egals if female==1 & (num_fem==3|num_fem==4|num_fem==5) & maj==0, cluster(group_id)
parmest, saving(pval_temp`i', replace) 
local i=`i'+1
}

**Group-level FDR analysis
use "JOP Replication_Enclaves_Group.dta", clear
local i=29

reg floor4 i.enclave princeton num_egals if (num_fem==4|num_fem==5) & maj==0, cluster(group_id)
parmest, saving(pval_temp`i', replace) 
local i=`i'+1


reg floor4 i.enclave princeton num_egals if (num_fem==3|num_fem==4|num_fem==5) & maj==0, cluster(group_id)
parmest, saving(pval_temp`i', replace) 
local i=`i'+1


use "/Data/Enclaves/Replication Data/FDR Adjustments/pval_temp1.dta", clear
save "/Data/Enclaves/Replication Data/FDR Adjustments/pval_all.dta", replace
drop in 1/5
save "/Data/Enclaves/Replication Data/FDR Adjustments/pval_all.dta", replace


local i=1
use pval_all, clear
while `i'<=30 {
append using pval_temp`i', gen(reg_num`i')
local i=`i'+1
save pval_all, replace
}

use "/Data/Enclaves/Replication Data/FDR Adjustments/pval_all.dta", clear

**Label values
gen label=""
replace label="PosInt" if reg_num1==1
replace label="NegInt" if reg_num2==1
replace label="OpInfl" if reg_num3==1
replace label="VoiceHeard" if reg_num4==1
replace label="Certainty" if reg_num5==1
replace label="SafetyPrefs" if reg_num6==1
replace label="Care" if reg_num7==1
replace label="Finance" if reg_num8==1
replace label="PropTalk" if reg_num9==1
replace label="InflVote" if reg_num10==1
replace label="Accomplish" if reg_num11==1
replace label="FewDomin" if reg_num12==1
replace label="Satisfaction" if reg_num13==1
replace label="FullDelib" if reg_num14==1
replace label="PosInt34" if reg_num15==1
replace label="NegInt34" if reg_num16==1
replace label="OpInfl34" if reg_num17==1
replace label="VoiceHeard34" if reg_num18==1
replace label="Certainty34" if reg_num19==1
replace label="SafetyPrefs34" if reg_num20==1
replace label="Care34" if reg_num21==1
replace label="Finance34" if reg_num22==1
replace label="PropTalk34" if reg_num23==1
replace label="InflVote34" if reg_num24==1
replace label="Accomplish34" if reg_num25==1
replace label="FewDomin34" if reg_num26==1
replace label="Satisfaction34" if reg_num27==1
replace label="FullDelib34" if reg_num28==1
replace label="GroupDec" if reg_num29==1
replace label="GroupDec34" if reg_num30==1


drop if parm~="1.enclave"
gen p_10=p/2
smileplot , pv(p_10) method(simes) ptlabel(label)


drop if label=="Accomplish"|label=="FewDomin"|label=="Satisfaction"|label=="FullDelib"|label=="Accomplish34"|label=="FewDomin34"|label=="Satisfaction34"|label=="FullDelib34"
qqvalue p_10, method(simes) qvalue(qval)

smileplot , pv(p_10) method(simes) ptlabel(label)





