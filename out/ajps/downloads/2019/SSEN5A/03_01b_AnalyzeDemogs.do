***********************
*AnalyzeDemogs.do
* Replication file for
* Hill, Seth J. and Gregory A. Huber. 2018. ``On The Meaning of Survey Reports of Roll Call `Votes','' American Journal of Political Science.
***********************

set more off
use "RawData/HillHuberSSI.dta", clear

*Join in post-stratification weights, created by
*RakeToPew.R.
joinby V1 using "RawData/RakedPewWeights.dta", unmatched(master)
tab _merge
drop _merge

**************
*Balance table.
**************

* Balance tests.
gen treatment = assignedCondition == "Info"
label var treatment "Party split condition"
* Unweighted.
* Use svy command to make comparablew.
svyset V1
qui xi: svy: logit treatment age_cat male educ i.region faminc marrital_status poli_donor registered
local tabl "Tables/TableA10BalanceTable-SSI.tex"
test
outreg2 using "`tabl'", replace  tex(fragment) ctitle("Unweighted") sdec(2) 2aster auto(2) rdec(3) label  adds(F-test, `r(F)', F p-value, `r(p)') adec(3) sideway
 
* Weighted.
svyset, clear
svyset V1 [pweight=weight]
xi: svy: logit treatment age_cat male educ i.region faminc marrital_status poli_donor registered
test
outreg2 using "`tabl'", append  tex(fragment) ctitle("Weighted") sdec(2) 2aster auto(2) rdec(3) label  adds(F-test, `r(F)', F p-value, `r(p)') adec(3) sideway
svyset, clear
drop treatment

**************
*Tabs on roll call support by condition
*and party.
**************
insheet using "RawData/PreppedIRTData-Unscreened.csv", clear
rename v1 V1
*Join recodes.
joinby V1 using "RawData/Huber_and_Hill_Roll_Call_Experiment-recodes.dta", unmatched(master)
tab _merge issen
drop if issen == 1
drop _merge

*Join in post-stratification weights.
joinby V1 using "RawData/RakedPewWeights.dta", unmatched(master)
tab _merge
drop _merge

di "Using pid3 including leaners for tabulations."
drop pid3
rename pid3_DtoR pid3

* Weighted, Screened
preserve

keep if passed_screener==1
local appd "-Screened"

	*Tabulate support each bill by pid and condition.
	reshape long bill, i(V1 pid3 assignedcondition weight) j(billname) string
	rename bill vote
	cl billname vote V1 pid3 assignedcondition in 1/10
	encode vote, gen(vote2)
	replace vote2 = . if vote2 == 3
	replace vote2 = vote2 - 1
	tab vote vote2, nol
	drop vote
	rename vote2 vote
	* Regression model to get diff-in-diff t-stat.
	gen gop = pid3 == 1
	* Treatment indicators and interactions.
	foreach cond in "Info" {
	  qui gen treat_`cond' = assignedcondition == "`cond'"
	  qui replace treat_`cond' = . if (treat_`cond' != 1 & assignedcondition != "Standard")
	  qui gen gopXtreat_`cond' = gop*treat_`cond'
	}
	* Make sure worked: should be 1, control=0, else=.
	tab treat_Info assignedcondition, miss
	* Variable to hold did t-stat.
	qui gen did_t = .
	* Loop over each roll call then each condition and extract diff-in-diff t-stat.
	levelsof billname, local(bills)
	foreach val of local bills {
	  di _n "Calculating t-stat on diff-in-diff for bill `val'."
	  foreach trt of varlist treat_* {
		qui count if `trt' == 1 & billname == "`val'" & pid3 != 0
		if r(N) == 0 continue
		reg vote `trt' gopX`trt' gop if billname == "`val'" & pid3 != 0 [aweight=weight], robust
		* Extract t-stat on diff-in-diff coefficient and place in variable did_t.
		replace did_t = abs(_b[gopX`trt']/_se[gopX`trt']) if billname == "`val'" & `trt' == 1
	  }
	}
	* Collapse to unique bill-condition-pid observation and reshape to wide.
	collapse (mean) vote did_t [aweight=weight], by(billname pid3 assignedcondition)
	reshape wide vote did_t, i(billname pid3) j(assignedcondition) string
	gen ate = voteInfo - voteStandard
	qui gen abs_ate = abs(ate)
	gsort - abs_ate
	outsheet using "Tables\TreatmentEffectsByBillPid3`appd'.csv", comma replace
	cl

restore


preserve

local appd "-Unscreened"

	*Tabulate support each bill by pid and condition.
	reshape long bill, i(V1 pid3 assignedcondition weight) j(billname) string
	rename bill vote
	cl billname vote V1 pid3 assignedcondition in 1/10
	encode vote, gen(vote2)
	replace vote2 = . if vote2 == 3
	replace vote2 = vote2 - 1
	tab vote vote2, nol
	drop vote
	rename vote2 vote
	* Regression model to get diff-in-diff t-stat.
	gen gop = pid3 == 1
	* Treatment indicators and interactions.
	foreach cond in "Info" {
	  qui gen treat_`cond' = assignedcondition == "`cond'"
	  qui replace treat_`cond' = . if (treat_`cond' != 1 & assignedcondition != "Standard")
	  qui gen gopXtreat_`cond' = gop*treat_`cond'
	}
	* Make sure worked: should be 1, control=0, else=.
	tab treat_Info assignedcondition, miss
	* Variable to hold did t-stat.
	qui gen did_t = .
	* Loop over each roll call then each condition and extract diff-in-diff t-stat.
	levelsof billname, local(bills)
	foreach val of local bills {
	  di _n "Calculating t-stat on diff-in-diff for bill `val'."
	  foreach trt of varlist treat_* {
		qui count if `trt' == 1 & billname == "`val'" & pid3 != 0
		if r(N) == 0 continue
		reg vote `trt' gopX`trt' gop if billname == "`val'" & pid3 != 0 [aweight=weight], robust
		* Extract t-stat on diff-in-diff coefficient and place in variable did_t.
		replace did_t = abs(_b[gopX`trt']/_se[gopX`trt']) if billname == "`val'" & `trt' == 1
	  }
	}
	* Collapse to unique bill-condition-pid observation and reshape to wide.
	collapse (mean) vote did_t [aweight=weight], by(billname pid3 assignedcondition)
	reshape wide vote did_t, i(billname pid3) j(assignedcondition) string
	gen ate = voteInfo - voteStandard
	qui gen abs_ate = abs(ate)
	gsort - abs_ate
	outsheet using "Tables\TreatmentEffectsByBillPid3`appd'.csv", comma replace
	cl

restore

preserve

keep if passed_screener==1
replace weight=1
local appd "-Screened-Unweighted"

	*Tabulate support each bill by pid and condition.
	reshape long bill, i(V1 pid3 assignedcondition weight) j(billname) string
	rename bill vote
	cl billname vote V1 pid3 assignedcondition in 1/10
	encode vote, gen(vote2)
	replace vote2 = . if vote2 == 3
	replace vote2 = vote2 - 1
	tab vote vote2, nol
	drop vote
	rename vote2 vote
	* Regression model to get diff-in-diff t-stat.
	gen gop = pid3 == 1
	* Treatment indicators and interactions.
	foreach cond in "Info" {
	  qui gen treat_`cond' = assignedcondition == "`cond'"
	  qui replace treat_`cond' = . if (treat_`cond' != 1 & assignedcondition != "Standard")
	  qui gen gopXtreat_`cond' = gop*treat_`cond'
	}
	* Make sure worked: should be 1, control=0, else=.
	tab treat_Info assignedcondition, miss
	* Variable to hold did t-stat.
	qui gen did_t = .
	* Loop over each roll call then each condition and extract diff-in-diff t-stat.
	levelsof billname, local(bills)
	foreach val of local bills {
	  di _n "Calculating t-stat on diff-in-diff for bill `val'."
	  foreach trt of varlist treat_* {
		qui count if `trt' == 1 & billname == "`val'" & pid3 != 0
		if r(N) == 0 continue
		reg vote `trt' gopX`trt' gop if billname == "`val'" & pid3 != 0 [aweight=weight], robust
		* Extract t-stat on diff-in-diff coefficient and place in variable did_t.
		replace did_t = abs(_b[gopX`trt']/_se[gopX`trt']) if billname == "`val'" & `trt' == 1
	  }
	}
	* Collapse to unique bill-condition-pid observation and reshape to wide.
	collapse (mean) vote did_t [aweight=weight], by(billname pid3 assignedcondition)
	reshape wide vote did_t, i(billname pid3) j(assignedcondition) string
	gen ate = voteInfo - voteStandard
	qui gen abs_ate = abs(ate)
	gsort - abs_ate
	outsheet using "Tables\TreatmentEffectsByBillPid3`appd'.csv", comma replace
	cl

restore



