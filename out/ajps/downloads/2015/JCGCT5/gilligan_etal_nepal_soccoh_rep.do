* Civil War and Social Capital: Behavioral-Game Evidence from Nepal

version 11.1
clear all

set mem 50m
set more off

* Change as necessary:
cd "~/Dropbox/Nepal Survey (1)/Conflict and Social Capital/AJPS accepted/repfiles/"

*************
* Macro-level outcomes, using full survey data
*************

use nep-survey-data

eststo clear
reg turnout [pweight=stratwgt] if fats1000==0
scalar noviol_m = _b[_cons]
eststo: xi: reg turnout fats1000 i.matchstrat [pweight=stratwgt], cluster(vdc_name)
estadd scalar noviol_m_add = noviol_m

reg groupsx [pweight=stratwgt] if fats1000==0
scalar noviol_m = _b[_cons]
eststo: xi: reg groupsx fats1000 i.matchstrat [pweight=stratwgt], cluster(vdc_name)
estadd scalar noviol_m_add = noviol_m

esttab using "tables/grossoutcomes.tex", keep(fats1000) b(3) se(3) replace star(* 0.10 ** 0.05 *** 0.01) scalars("noviol_m_add Baseline (no violence)") r2 l ti("Effects of violence on collective behavior") addnotes("WLS with matched-pair block FE." "Robust standard errors clustered by VDC. (p-values are for two-sided tests.)") 


*************
* Micro-level outcomes, using games data
*************
use nep-games-data, clear

log using "tables/summ_stats.txt", text replace
summ lot_choice dict_sent cooperate s_sent sharereturn Female brahmin chhetri magarrai Literate age_hh
summ lpop2 roaddist if vdctag==1
log close

* - lot_choice : Lottery choice in risk game
* - dict_sent : Amount send in dictator game
* - cooperate : Cooperate in obligation game
* - s_sent : Amount sent in trust game
* - sharereturn : Share returned in trust game

* Main results: Ward level clustering, block FE
eststo clear
reg lot_choice [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg lot_choice violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg dict_sent [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg dict_sent  violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg cooperate [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg cooperate  violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg s_sent [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg s_sent    violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg sharereturn [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg sharereturn violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg Index [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg Index violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

esttab using "tables/community_exposure.tex", keep(violence) b(2) se(2) replace star(* 0.10 ** 0.05 *** 0.01) scalars("noviol_m_add Baseline (no violence)") r2 l ti("Main results") addnotes("WLS with matched-pair block FE." "Robust standard errors clustered by ward. (p-values are for two-sided tests.)" "Soc. Index is inverse covariance weighted average of outcomes 2-5.") 

* Reduced form predictions in terms of purging:

prog drop _all 
prog myqreg25
  xi: qreg age_hh violence i.dist_block [aweight=vdc_weight], quantile(.25)
end
prog myqreg50
  xi: qreg age_hh violence i.dist_block [aweight=vdc_weight], quantile(.5)
end
prog myqreg75
  xi: qreg age_hh violence i.dist_block [aweight=vdc_weight], quantile(.75)
end

eststo clear

reg age_hh [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
quietly: eststo: xi: reg age_hh violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

qreg age_hh [aweight=vdc_weight] if violence == 0, quantile(.25)
scalar noviol_m = _b[_cons]
quietly: eststo: bs, cluster(wardunique) strata(dist_block) reps(1000): myqreg25
estadd scalar noviol_m_add = noviol_m

qreg age_hh [aweight=vdc_weight] if violence == 0, quantile(.5)
scalar noviol_m = _b[_cons]
quietly: eststo: bs, cluster(wardunique) strata(dist_block) reps(1000): myqreg50
estadd scalar noviol_m_add = noviol_m

qreg age_hh [aweight=vdc_weight] if violence == 0, quantile(.75)
scalar noviol_m = _b[_cons]
quietly: eststo: bs, cluster(wardunique) strata(dist_block) reps(1000): myqreg75
estadd scalar noviol_m_add = noviol_m

reg Literate [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
quietly: eststo: xi: reg Literate violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

esttab using "tables/community_exposure.tex", keep(violence) b(2) se(2) replace star(* 0.10 ** 0.05 *** 0.01) scalars("noviol_m_add Baseline (no violence)") r2 l ti("Effects on profile of remaining household decision-makers") addnotes("WLS with matched-pair block FE." "OLS with Block FE." "Robust (for 1 and 5) and bootstrapped (for 2-4) standard errors clustered by ward." " (p-values are for two-sided tests.)") mtitles("Avg. Age" "Age 25th Pc." "Age Median" "Age 75th Pc." "Literate") append page

* Liquid capital should predict sociality in violent places but not non-violent places.
* Thus, for soc = a + b*liquid + c*violence + d*violence*liquid + e, we expect d to be positive.
* Now, age as a proxy for liquid capital is reverse coded, so d should be negative in that case.

sum age_hh
scalar mean_age = r(mean)
g age_hhc = age_hh - mean_age
label var age_hhc "Age"

g ViolenceXAge = violence*age_hhc
g ViolenceXLiterate = violence*Literate

g AgeXRoad = age_hhc*roaddist
g LitXRoad = Literate*roaddist
g ViolXAgeXRoad = violence*age_hhc*roaddist
g ViolXLitXRoad = violence*Literate*roaddist

eststo clear

reg Index [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg Index violence age_hhc ViolenceXAge i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m
scalar noviol_m = _b[_cons]
eststo: xi: reg Index violence Literate ViolenceXLiterate i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m
eststo: xi: reg Index violence age_hhc ViolenceXAge Literate ViolenceXLiterate i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m
eststo: xi: reg Index violence age_hhc ViolenceXAge Literate ViolenceXLiterate i.sex_hh i.cast_hh i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m
eststo: xi: reg Index violence age_hhc ViolenceXAge Literate ViolenceXLiterate roaddist i.sex_hh i.cast_hh i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m
eststo: xi: reg Index violence age_hhc ViolenceXAge Literate ViolenceXLiterate roaddist violXroaddist i.sex_hh i.cast_hh i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

esttab using "tables/community_exposure.tex", keep(violence age_hhc ViolenceXAge Literate ViolenceXLiterate roaddist violXroaddist) b(2) se(2) replace star(* 0.10 ** 0.05 *** 0.01) scalars("noviol_m_add Baseline (no violence)") r2 l ti("Effects of violence on the human capital and sociality relationship") addnotes("WLS with matched-pair block FE." "Robust standard errors clustered by ward. (p-values are for two-sided tests.)" "Soc. Index is inverse covariance weighted average of outcomes 2-5.""Age is centered on its mean (52). Models 4-6 control for caste and gender fixed effects.") append page

* Relocation mechanism (distance to road)

label var roaddist "Dist. to road (km)"
label var violXroaddist "Viol. X Dist. to road" 

g lroaddist = ln(roaddist)
g violXlroaddist = violence*lroaddist

eststo clear
reg lot_choice [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg lot_choice violence roaddist violXroaddist i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg dict_sent [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg dict_sent  violence roaddist violXroaddist i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg cooperate [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg cooperate  violence roaddist violXroaddist i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg s_sent [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg s_sent    violence roaddist violXroaddist i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg sharereturn [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg sharereturn violence roaddist violXroaddist i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg Index [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg Index violence roaddist violXroaddist i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

esttab using "tables/community_exposure.tex", keep(violence roaddist violXroaddist) b(2) se(2) replace star(* 0.10 ** 0.05 *** 0.01) scalars("noviol_m_add Baseline (no violence)") r2 l ti("Interaction with distance to road") addnotes("WLS with matched-pair block FE." "Robust standard errors clustered by ward. (p-values are for two-sided tests.)" "Soc. Index is inverse covariance weighted average of outcomes 2-5.") append page

* Alternative mechanism: Post-traumatic growth
* Does violence counterintuitively lead to more optimism?

eststo clear

reg trauma_exp [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg trauma_exp violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg ptsd [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg ptsd violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg Hopefulness [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg Hopefulness violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

reg polconf [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg polconf violence i.dist_block [pweight=vdc_weight], cluster(wardunique)
estadd scalar noviol_m_add = noviol_m

esttab using "tables/community_exposure.tex", keep(violence) b(2) se(2) replace star(* 0.10 ** 0.05 *** 0.01) scalars("noviol_m_add Baseline (no violence)") r2 l ti("Effects on post-traumatic growth outcomes") addnotes("WLS with matched-pair block FE." "Robust standard errors clustered by ward. (p-values are for two-sided tests.)") append page


************************************************
* Robustness checks for the mainresults:
* Supplement: VDC level clustering, block FE
************************************************

local covariates "elevmean_s elevsd_s lpop unemp illit noschool"

eststo clear
reg lot_choice [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg lot_choice violence i.dist_block [pweight=vdc_weight], cluster(vdc)
estadd scalar noviol_m_add = noviol_m

reg dict_sent [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg dict_sent  violence i.dist_block [pweight=vdc_weight], cluster(vdc)
estadd scalar noviol_m_add = noviol_m

reg cooperate [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg cooperate  violence i.dist_block [pweight=vdc_weight], cluster(vdc)
estadd scalar noviol_m_add = noviol_m

reg s_sent [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg s_sent    violence i.dist_block [pweight=vdc_weight], cluster(vdc)
estadd scalar noviol_m_add = noviol_m

reg sharereturn [pweight=vdc_weight] if violence==0
scalar noviol_m = _b[_cons]
eststo: xi: reg sharereturn violence i.dist_block [pweight=vdc_weight], cluster(vdc)
estadd scalar noviol_m_add = noviol_m
esttab using "tables/supplement.tex", keep(violence) b(2) se(2) replace star(* 0.10 ** 0.05 *** 0.01) scalars("noviol_m_add Baseline (no violence)") r2 l ti("Main results with VDC clustered standard errors") addnotes("WLS with matched-pair block FE.") 

* Supplement: Ward level clustering, covariates

local covariates "elevmean_s elevsd_s lpop unemp illit noschool"

eststo clear
eststo: xi: reg lot_choice violence `covariates' [pweight=vdc_weight], cluster(wardunique)
eststo: xi: reg dict_sent  violence `covariates' [pweight=vdc_weight], cluster(wardunique)
eststo: xi: reg cooperate  violence `covariates' [pweight=vdc_weight], cluster(wardunique)
eststo: xi: reg s_sent    violence `covariates' [pweight=vdc_weight], cluster(wardunique)
eststo: xi: reg sharereturn  violence `covariates' [pweight=vdc_weight], cluster(wardunique)
esttab using "tables/supplement.tex", b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) r2 l ti("Main results with covariates") addnotes("Covariance adjustment and ward-level clustering") append page

* Supplement: VDC level clustering, covariates

eststo clear
eststo: xi: reg lot_choice violence `covariates' [pweight=vdc_weight], cluster(vdc)
eststo: xi: reg dict_sent  violence `covariates' [pweight=vdc_weight], cluster(vdc)
eststo: xi: reg cooperate  violence `covariates' [pweight=vdc_weight], cluster(vdc)
eststo: xi: reg s_sent    violence `covariates' [pweight=vdc_weight], cluster(vdc)
eststo: xi: reg sharereturn  violence `covariates' [pweight=vdc_weight], cluster(vdc)
esttab using "tables/supplement.tex", b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) r2 l ti("Main results with covariates and VDC clustering") addnotes("Covariance adjustment and VDC-level clustering") append page

* Robustness: all of the above excluding Udayapur

eststo clear
eststo: xi: reg lot_choice violence i.dist_block [pweight=vdc_weight] if district!="Udayapur", cluster(wardunique)
eststo: xi: reg dict_sent  violence i.dist_block [pweight=vdc_weight] if district!="Udayapur", cluster(wardunique)
eststo: xi: reg cooperate  violence i.dist_block [pweight=vdc_weight] if district!="Udayapur", cluster(wardunique)
eststo: xi: reg s_sent    violence i.dist_block [pweight=vdc_weight] if district!="Udayapur", cluster(wardunique)
eststo: xi: reg sharereturn violence i.dist_block [pweight=vdc_weight] if district!="Udayapur", cluster(wardunique)
esttab using "tables/supplement.tex", keep(violence) b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) r2 l ti("Main results excluding Udayapur") addnotes("Block FE and ward-level clustering, excluding Udayapur") append page

eststo clear
eststo: xi: reg lot_choice violence `covariates' [pweight=vdc_weight] if district!="Udayapur", cluster(wardunique)
eststo: xi: reg dict_sent  violence `covariates' [pweight=vdc_weight] if district!="Udayapur", cluster(wardunique)
eststo: xi: reg cooperate  violence `covariates' [pweight=vdc_weight] if district!="Udayapur", cluster(wardunique)
eststo: xi: reg s_sent    violence `covariates' [pweight=vdc_weight] if district!="Udayapur", cluster(wardunique)
eststo: xi: reg sharereturn  violence `covariates' [pweight=vdc_weight] if district!="Udayapur", cluster(wardunique)
esttab using "tables/supplement.tex", b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) r2 l ti("Main results excluding Udayapur, with covariates") addnotes("Covariance adjustment and ward-level clustering, excluding Udayapur") append page
