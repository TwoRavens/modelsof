***************************************************************************
*** Replication file for "Political elites’ media responsiveness and their individual political goals. A study of national politicians in Belgium"
*** Authors: Julie Sevenans, Stefaan Walgrave and Debby Vos (University of Antwerp)
*** Research and Politics
*** Last updated: March 13, 2015
***************************************************************************


*** Open Dataset *** 

use Data, clear
set more off

*** Descriptive statistics (Table 1) and t-tests ***

sum media_responsiveness policy_making party_political female age_ordinal opposition
ttest party_political, by(opposition)
ttest policy_making, by(opposition)


*** Regression analysis (Table 2) and predicted probabilities (Figure 1) ***
reg media_responsiveness female age_ordinal opposition
reg media_responsiveness female age_ordinal opposition party_political policy_making
margins, at(party_political=(0(2)10)) atmeans
marginsplot, xlabel(1(2)10) ylabel(15(3)33) scheme(s2mono) title("Predicted probabilities") ytitle("Media responsiveness") xtitle("Party political goals", height(5))


*** Extra check: Model following the procedure for proportional DV ***
gen media_responsiveness_prop = media_responsiveness/100
glm media_responsiveness_prop female age_ordinal opposition party_political policy_making, family(binomial) link(logit) rob
margins, at(party_political=(0(1)10)) atmeans
