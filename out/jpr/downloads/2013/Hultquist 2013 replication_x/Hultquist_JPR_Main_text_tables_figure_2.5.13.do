*do file for Philip Hultquist's Journal of Peace Research submission (ID: JPR-11-0192.R1)- Power Parity and Peace? The Role of Relative Pwer on Civil War Settlement.
*note that replicators will have to change the file destination in the command lines below

use "/Users/p_hultquist/Dropbox/Documents/UNM/Parity JPR/Parity JPR Dataset submitted.dta"

set more off
* Table 2 - Model 1: Mlogit 
mlogit k rclag1 rc2lag1 battledeaths identity territory pg_troops pr_troops lngdpper polity2 polity_sq age age2 age3,  nolog cluster(dyadid)
outreg2 using paritymlogit1.doc, nolabel replace



* Table 1 - Descriptive stats
estat sum
bysort dyadid (year): egen rclag1_sd =sd(rclag1) if e(sample)
bysort dyadid (year): egen rc2lag1_sd =sd(rc2lag1) if e(sample)
bysort dyadid (year): egen battledeaths_sd =sd(battledeaths) if e(sample)
bysort dyadid (year): egen identity_sd =sd(identity) if e(sample)
bysort dyadid (year): egen territory_sd =sd(territory) if e(sample)
bysort dyadid (year): egen lngdpper_sd =sd(lngdpper) if e(sample)
bysort dyadid (year): egen polity2_sd =sd(polity2) if e(sample)
bysort dyadid (year): egen polity_sq_sd =sd(polity_sq) if e(sample)
bysort dyadid (year): egen pg_troops_sd =sd(pg_troops) if e(sample)
bysort dyadid (year): egen pr_troops_sd =sd(pr_troops) if e(sample)
bysort dyadid (year): egen age_sd =sd(age) if e(sample)
bysort dyadid (year): egen age2_sd =sd(age2) if e(sample)
bysort dyadid (year): egen age3_sd =sd(age3) if e(sample)

sum rclag1_sd rc2lag1_sd battledeaths_sd identity_sd territory_sd lngdpper_sd polity2_sd polity_sq_sd pg_troops_sd pr_troops_sd age_sd age2_sd age3_sd


* Figure 1 - Predicted Probability of Settlement/Ceasefire

gen cbattledeaths = battledeaths
gen cidentity = identity
gen cterritory = territory
gen cpg_troops = pg_troops
gen cpr_troops =pr_troops
gen clngdpper = lngdpper
gen cpolity2 =polity2
gen cpolity_sq = polity_sq
gen cage=age
gen cage2=age2
gen cage3=age3

mlogit k rclag1 rc2lag1 cbattledeaths cidentity cterritory cpg_troops cpr_troops clngdpper cpolity2 cpolity_sq cage cage2 cage3,  nolog cluster(dyadid)

quietly sum cbattledeaths, det
replace cbattledeaths = r(mean) 

quietly sum clngdpper, det
replace clngdpper = r(mean) if clngdpper~=.

quietly sum cpolity2, det
replace cpolity2 = r(mean) 

quietly sum cpolity_sq, det
replace cpolity_sq = r(mean) 

quietly sum cage, det
replace cage = r(mean) 

quietly sum cage2, det
replace cage2 = r(mean) 

quietly sum cage3, det
replace cage3 = r(mean) 

replace cidentity = 1
replace cterritory = 1 
replace cpg_troops = 0
replace cpr_troops = 0


/*generate predicted values*/
    sort rclag1
    predict pongoing psettle pgv prv if e(sample)
    histogram rclag1 if e(sample), frequency addplot((qfitci psettle rclag1, stdf yaxis(2))) scheme(s1mono) 
