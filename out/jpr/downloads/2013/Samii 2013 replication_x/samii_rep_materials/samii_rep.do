* Replication .do file for Samii (2013).
* Note: Requires installation of esttab.

clear all
set mem 100m
set more off

* Modify file path as needed:
cd "~/Dropbox/tj/data/samii_rep_materials"

use samii_rep_data, clear
svyset adm2name [pweight=pweight], strata(adm1name)

* Demographics

tab1 female ethnicity schoolyrs
svy: tab female
svy: tab ethnicity
svy: tab schoolyrs

* Summary statistics
tabstat female hutu nonsouthern ongoingviol secgain violdet cnddvt vic_fab vic_reb, col(stat) statistics(mean sd n) format(%9.2f)
tabstat female hutu nonsouthern ongoingviol secgain violdet cnddvt vic_fab vic_reb [aweight = pweight], col(stat) statistics(mean) format(%9.2f)

* Current commune/province same as pre-war?
svy: tab adm1change
svy: tab adm2change

* Overall distribution
svy: tab seektruth punish, se

* Experiment
svy: tab argtreat punish2, subpop(punish if punish==1) row se
svy: tab argtreat punish2, subpop(punish if punish==2) row se
svy: tab argtreat punish2, subpop(punish if punish==3) row se

* Balance check for experiment

reg female argtreat if punish==1 
reg ethnicity argtreat if punish==1
reg schoolyrs argtreat if punish==1
reg hutu argtreat if punish==1
reg nonsouthern argtreat if punish==1
reg ongoingviol argtreat if punish==1
reg secgain argtreat if punish==1
reg violdet argtreat if punish==1
reg cnddvt argtreat if punish==1
reg vic_fab argtreat if punish==1
reg vic_reb argtreat if punish==1

* Regressions

* Punishment
eststo clear
eststo: svy: ologit punish female hutu nonsouthern
eststo: svy: ologit punish female hutu nonsouthern ongoingviol secgain violdet vic_fab vic_reb 
eststo: svy: ologit punish female hutu nonsouthern ongoingviol secgain violdet vic_fab vic_reb vic_rebXhutu vic_fabXhutu
eststo: svy: ologit punish female hutu nonsouthern ongoingviol secgain violdet vic_fab vic_reb vic_rebXhutu vic_fabXhutu cnddvt 
esttab using bdi_tj_regs.tex, b(2) se(2) l replace star(* 0.10 ** 0.05 *** 0.01) mtitles("Deep partisanship" "Insecurity" "Insecurity 2" "Proximate partisanship") ti("Ordered logistic regression of preference to pursue punishment"\label{tab:punish}) addnotes("Estimates use post-stratification weights.  Standard errors account for province stratification, commune clustering, and weighting.") page(fullpage)

* Truth seeking
eststo clear
eststo: svy: logit seektruth female hutu nonsouthern  
eststo: svy: logit seektruth female hutu nonsouthern ongoingviol secgain violdet vic_fab vic_reb
eststo: svy: logit seektruth female hutu nonsouthern ongoingviol secgain violdet vic_fab vic_reb vic_rebXhutu vic_fabXhutu
eststo: svy: logit seektruth female hutu nonsouthern ongoingviol secgain violdet vic_fab vic_reb vic_rebXhutu vic_fabXhutu cnddvt
esttab using bdi_tj_regs.tex, b(2) se(2) l replace star(* 0.10 ** 0.05 *** 0.01) mtitles("Deep partisanship" "Insecurity"  "Insecurity 2" "Proximate partisanship") ti("Logistic regression of preference to pursue truth seeking"\label{tab:truth}) addnotes("Estimates use post-stratification weights.  Standard errors account for province stratification, commune clustering, and weighting.") append page

* Punishment, using the second responses

eststo clear
eststo: svy: ologit punish2 female hutu nonsouthern
eststo: svy: ologit punish2 female hutu nonsouthern ongoingviol secgain violdet vic_fab vic_reb
eststo: svy: ologit punish2 female hutu nonsouthern ongoingviol secgain violdet vic_fab vic_reb vic_rebXhutu vic_fabXhutu
eststo: svy: ologit punish2 female hutu nonsouthern ongoingviol secgain violdet vic_fab vic_reb vic_rebXhutu vic_fabXhutu cnddvt
esttab using bdi_tj_regs.tex, b(2) se(2) l replace star(* 0.10 ** 0.05 *** 0.01) mtitles("Deep partisanship" "Insecurity" "Insecurity 2" "Proximate partisanship") ti("Ordered logistic regression of preference to pursue punishment (post-treatment responses)"\label{tab:punish}) addnotes("Estimates use post-stratification weights.  Standard errors account for province stratification, commune clustering, and weighting.") append page
