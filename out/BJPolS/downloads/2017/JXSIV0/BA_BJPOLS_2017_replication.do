*****************************************************
*****************************************************

******* Title: "Does Government Support Respond to Governments’ Social Welfare Rhetoric or their Spending? An Analysis of Government Support in Britain, Spain, and the United States"
******* Authors: Luca Bernardi and James Adams
******* Journal: British Journal of Political Science

*****************************************************
*****************************************************


clear
use "/replace your directory here/BA_BJPOLS_2017_replication.dta"


***** Tell Stata these are time-series cross-sectional data
xtset cc date


***** Replication of Table 1

*** All governments
sum d_gov l_gov d_speech_welfare l_speech_welfare d_exp_welfare l_exp_welfare
*** Left-wing governments
sum d_gov l_gov d_speech_welfare l_speech_welfare d_exp_welfare l_exp_welfare if left==1
*** Right-wing governments
sum d_gov l_gov d_speech_welfare l_speech_welfare d_exp_welfare l_exp_welfare if left==0


***** Replication of Table 2

*** All governments
xtpcse d_gov l_gov d_speech_welfare l_speech_welfare d_exp_welfare l_exp_welfare, pairwise
*** Left-wing governments
xtpcse d_gov l_gov d_speech_welfare l_speech_welfare d_exp_welfare l_exp_welfare if left==1, pairwise
*** Right-wing governments
xtpcse d_gov l_gov d_speech_welfare l_speech_welfare d_exp_welfare l_exp_welfare if left==0, pairwise


***** Replication of Table 3

*** Economic effects
xtpcse d_gov l_gov d_speech_welfare l_speech_welfare d_exp_welfare l_exp_welfare d_misery l_misery, pairwise
*** Generosity index
xtpcse d_gov l_gov d_speech_welfare l_speech_welfare d_generosity l_generosity d_misery l_misery, pairwise


***** Replication of Figure 1
xtline gov


***** Replication of Figure 2

*** Top panel
xtline speech_welfare
*** Bottom panel
xtline exp_welfare


***** Replication of Figure 3
xtpcse d_gov l_gov d_speech_welfare l_speech_welfare d_exp_welfare l_exp_welfare, pairwise
sum l_exp_welfare
margins, at(l_exp_welfare==(12.7(1)23))
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash))


***** How to cite *****
* Bernardi, Luca and James Adams. Forthcoming. Does Government Support Respond to Governments’ Social Welfare Rhetoric or their Spending? An Analysis of Government Support in Britain, Spain, and the United States. British Journal of Political Science


