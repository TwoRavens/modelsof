***********************
*AnalyzeSSI.do
* Replication file for
* Hill, Seth J. and Gregory A. Huber. 2018. ``On The Meaning of Survey Reports of Roll Call `Votes','' American Journal of Political Science.
***********************

capture log close
log using AnalyzeSSI.log, text replace
 
clear
set more off
insheet using "RawData/PreppedIRTData-Unscreened.csv", clear
rename v1 V1

joinby V1 using "RawData/HillHuberSSI.dta", unmatched(master)
tab _merge
drop _merge

joinby V1 using "RawData/RakedPewWeights.dta", unmatched(master)
tab _merge
drop _merge

keep if passed_screener
local appd "-Screened"

*Save out confidence and importance for plot.
outsheet V1 conf_* impt_* weight using "RawData/ConfByPolicyImportance`appd'.csv", replace nolabel

**************************
* Treatment effects on roll calls via OLS.
**************************
preserve
gen dem = pid3 == -1
label var dem "Democrat"
gen rep = pid3 == 1
label var rep "Republican"
* Treatment indicator.
gen treatment = assignedCondition == "Info"
label var treatment "Party split condition"

* Label votes.
label var billplnprnt "Defund Planned, Parenthood"
label var billgndrdiscrim "Gender, Discrimination"
label var billtrnsprt "Transport Urban, Devel Fund"
label var billbudget15 "Budget, 2015"
label var billkeystone "Keystone, Pipeline"
label var billendshtdn "End Shutdown, Raise Debt Limit"
label var billbkrndchk "Firearm, Background, Checks"
label var billunemp "Extend, Unemployment"
label var billhiwayexim "Highway Funding, Ex-Im Bank"
label var billrplaca "Repeal Obamacare"
label var billmedicschip "Medicare Pay, and SCHIP"
label var billstdnln "Student Loan, Interest Rates"

* In same order as displayed
* in Figure created by PlotSimpleResult.R.
order billbudget15 billplnprnt billendshtdn billunemp billbkrndchk billgndrdiscrim billhiwayexim billkeystone billmedicschip billrplaca billstdnln billtrnsprt

* Regressions by roll call. 
local tabl "Tables/TableA07RollCallTreatmentEffects-SSI.tex"
local repl "replace"
* Break into three tables.
local ctr = 1
foreach var of varlist bill* {
  local templabel : var label `var'
  di "`templabel'"
  * Turn variable to numeric.
  qui encode `var', gen(`var'2)
  qui replace `var'2 = . if `var'2 == 3
  qui replace `var'2 = `var'2 - 1
  * Make sure correct.
  tab `var' `var'2, nol

  * Basic treatment effect.
  qui reg `var'2 treatment dem rep [aweight=weight]
  qui outreg2 using "`tabl'", `repl'  tex(fragment) ctitle("All, `templabel'") sdec(2) 2aster auto(2) rdec(3) label
  local repl "append"
  * Dems.
  qui reg `var'2 treatment if dem == 1 [aweight=weight]
  qui outreg2 using "`tabl'", append tex(fragment) ctitle("Dems") sdec(2) 2aster auto(2) rdec(3) label
  * Reps.
  qui reg `var'2 treatment if rep == 1 [aweight=weight]
  qui outreg2 using "`tabl'", append tex(fragment) ctitle("Reps") sdec(2) 2aster auto(2) rdec(3) label
  qui drop `var'2
  * Increment ctr.
  local ctr = `ctr' + 1
  if (`ctr' == 5) {
    * New table.
    local tabl "Tables/TableA07RollCallTreatmentEffects-SSI-2.tex"
    local repl "replace"
  }
  if (`ctr' == 9) {
    * New table.
    local tabl "Tables/TableA07RollCallTreatmentEffects-SSI-3.tex"
    local repl "replace"
  }
}
restore

****
*Recode importance/confidence measures.
****
local ctr=1
foreach var of varlist impt_Q23_1 impt_Q23_2 impt_Q23_3 impt_Q23_5 impt_Q24_1 impt_Q24_2 impt_Q24_3 impt_Q24_4 impt_Q25_1 impt_Q25_2 impt_Q25_3 impt_Q25_5 {
	gen importance_`ctr' = `var'
	local ctr=`ctr'+1
}

local ctr=1
foreach var of varlist conf_Q20_1 conf_Q20_2 conf_Q20_3 conf_Q20_5 conf_Q21_1 conf_Q21_2 conf_Q21_3 conf_Q21_4 conf_Q22_1 conf_Q22_2 conf_Q22_3 conf_Q22_5  {
	gen confidence_`ctr' = `var'
	local ctr=`ctr'+1
}

/*
preserve
collapse (mean) importance_* confidence_*
gen x=1
reshape long importance_ confidence_ , j(issuenum) i(x)
twoway (scatter confidence_ importance_ , mcolor(black) msize(small) msymbol(circle) ) (lpoly confidence_ importance_ , lcolor(black) lpattern(dash)), xlabel(0(1)3) ylabel(0(1)3) ytitle(Confidence) xtitle(Importance) title("All 12 Issues", size(medsmall)) legend(off) scheme(s1mono) name(pooled, replace)
capture graph export Figures\AcrossIssueAveragesConfImpt.pdf, as(pdf) replace
restore
*/

window manage close graph _all

****
*See if treatment assignment influences confidence.
****
qui gen treat = (assignedCondition == "Info")
preserve
keep treat confidence_* V1
reshape long confidence_, i(V1) j(bill)
reg confidence_ treat , cluster(V1)
restore

* Separately for each area.
foreach var of varlist confidence_* {
  di "`var'"
  qui reg `var' treat
  di _b[treat] " (" _se[treat] ")"
}
drop treat

****
*See how treatment effects line up with
*average confidence on issue in control condition.
****

*Create average confidence by pid for control cases.
foreach var of varlist conf_Q20_1 conf_Q20_2 conf_Q20_3 conf_Q20_5 conf_Q21_1 conf_Q21_2 conf_Q21_3 conf_Q21_4 conf_Q22_1 conf_Q22_2 conf_Q22_3 conf_Q22_5  {
  bys pid3_DtoR: egen pid_avg_`var' = mean(`var') if assignedcondition == "Standard"
  local templabel : var label `var'
  label var pid_avg_`var' "Average confidence by pid: `templabel'"
  bys pid3_DtoR: egen temp=mean(pid_avg_`var')
  replace pid_avg_`var'=temp
  drop temp
}

foreach var of varlist impt_Q23_1 impt_Q23_2 impt_Q23_3 impt_Q23_5 impt_Q24_1 impt_Q24_2 impt_Q24_3 impt_Q24_4 impt_Q25_1 impt_Q25_2 impt_Q25_3 impt_Q25_5  {
  bys pid3_DtoR: egen pid_avg_`var' = mean(`var') if assignedcondition == "Standard"
  local templabel : var label `var'
  label var pid_avg_`var' "Average importance by pid: `templabel'"
  bys pid3_DtoR: egen temp=mean(pid_avg_`var')
  replace pid_avg_`var'=temp
  drop temp
}

*Rename pid_avg vars to match bill var names.
desc pid_avg_conf* bill*
rename pid_avg_conf_Q20_1 pid_avg_c_bkrndchk
rename pid_avg_conf_Q20_2 pid_avg_c_stdnln
rename pid_avg_conf_Q20_3 pid_avg_c_trnsprt
rename pid_avg_conf_Q20_5 pid_avg_c_budget15
rename pid_avg_conf_Q21_1 pid_avg_c_unemp
rename pid_avg_conf_Q21_2 pid_avg_c_gndrdiscrim
rename pid_avg_conf_Q21_3 pid_avg_c_keystone
* It does not appear that there is anything to go with this item. This is a question about housing, which is not one of our policy areas.
drop pid_avg_conf_Q21_4
rename pid_avg_conf_Q22_1 pid_avg_c_rplaca
rename pid_avg_conf_Q22_2 pid_avg_c_medicschip
rename pid_avg_conf_Q22_3 pid_avg_c_hiwayexim
rename pid_avg_conf_Q22_5 pid_avg_c_plnprnt

desc pid_avg_impt* bill*
rename pid_avg_impt_Q23_1 pid_avg_i_bkrndchk
rename pid_avg_impt_Q23_2 pid_avg_i_stdnln
rename pid_avg_impt_Q23_3 pid_avg_i_trnsprt
rename pid_avg_impt_Q23_5 pid_avg_i_budget15
rename pid_avg_impt_Q24_1 pid_avg_i_unemp
rename pid_avg_impt_Q24_2 pid_avg_i_gndrdiscrim
rename pid_avg_impt_Q24_3  pid_avg_i_keystone
* It does not appear that there is anything to go with this item. This is a question about housing, which is not one of our policy areas.
drop pid_avg_impt_Q24_4 
rename pid_avg_impt_Q25_1 pid_avg_i_rplaca
rename pid_avg_impt_Q25_2 pid_avg_i_medicschip
rename pid_avg_impt_Q25_3 pid_avg_i_hiwayexim
rename pid_avg_impt_Q25_5 pid_avg_i_plnprnt

*Reshape to long and save out pid averages.
preserve
collapse (mean) pid_avg*  [aweight=weight], by(pid3_DtoR)
reshape long pid_avg_c_ pid_avg_i_, i(pid3_DtoR) j(billname) string
rename pid_avg_c_ pid_avg_conf
rename pid_avg_i_ pid_avg_impt
label var pid_avg_conf "Average confidence in control condition by party"
label var pid_avg_impt "Average importance in control condition by party"
gen pid3 = "Dem" if pid3_DtoR == -1
replace pid3 = "Oth/Ind" if pid3_DtoR == 0
replace pid3 = "Rep" if pid3_DtoR == 1
sort pid3 billname
save "Tables\AvgConfByPidBill`appd'.dta", replace
restore

*Load in avg treatment effects created in AnalyzeDemogsAndCreateRecodes.do.
insheet using "Tables\TreatmentEffectsByBillPid3`appd'.csv", clear
joinby pid3 billname using "Tables\AvgConfByPidBill`appd'.dta",unmatched(both)
tab _merge

gen demrep=.
replace demrep=0 if pid3=="Dem"
replace demrep=1 if pid3=="Rep"
label var demrep "Republican respondent"

****************
* Create policy confidence attenuates treatment effect 
* of information table for paper.
****************
local tabl "tables/Table01TreatmentEffectsOnConfidence.tex"
* All respondents.
regress abs_ate pid_avg_conf demrep
outreg2 using "`tabl'", replace  tex(fragment) ctitle("All") sdec(2) 2aster auto(2) rdec(3) label
summ abs_ate  if demrep~=.
summ pid_avg_conf  if demrep ~=.
disp _b[pid_avg_conf ]*r(sd)
disp (_b[pid_avg_conf ]*r(sd))/.0839046

*Dems.
regress abs_ate pid_avg_conf if demrep==0
outreg2 using "`tabl'", append  tex(fragment) ctitle("Dems") sdec(2) 2aster auto(2) rdec(3) label
*Reps.
regress abs_ate pid_avg_conf if demrep==1
outreg2 using "`tabl'", append  tex(fragment) ctitle("Reps") sdec(2) 2aster auto(2) rdec(3) label

* Control for importance.
pwcorr pid_avg_conf  pid_avg_impt if demrep ~=., sig
regress abs_ate pid_avg_conf pid_avg_impt demrep
outreg2 using "`tabl'", append  tex(fragment) ctitle("All") sdec(2) 2aster auto(2) rdec(3) label
regress abs_ate pid_avg_conf pid_avg_impt  if demrep==0
outreg2 using "`tabl'", append  tex(fragment) ctitle("Dems") sdec(2) 2aster auto(2) rdec(3) label
regress abs_ate pid_avg_conf pid_avg_impt  if demrep==1
outreg2 using "`tabl'", append  tex(fragment) ctitle("Reps") sdec(2) 2aster auto(2) rdec(3) label

*Outsheet for R graphic.
outsheet using "RawData/ATEsAndAvgConfByPidBill`appd'.csv", comma replace

* REPEATS ABOVE but without weights

clear
set more off
insheet using "RawData/PreppedIRTData-Unscreened.csv", clear
rename v1 V1

joinby V1 using "RawData/HillHuberSSI.dta", unmatched(master)
tab _merge
drop _merge

joinby V1 using "RawData/RakedPewWeights.dta", unmatched(master)
tab _merge
drop _merge

keep if passed_screener
replace weight=1
local appd "-Screened-Unweighted"


**************************
* Treatment effects on roll calls via OLS.
**************************
preserve
gen dem = pid3 == -1
label var dem "Democrat"
gen rep = pid3 == 1
label var rep "Republican"
* Treatment indicator.
gen treatment = assignedCondition == "Info"
label var treatment "Party split condition"

* Label votes.
label var billplnprnt "Defund Planned, Parenthood"
label var billgndrdiscrim "Gender, Discrimination"
label var billtrnsprt "Transport Urban, Devel Fund"
label var billbudget15 "Budget, 2015"
label var billkeystone "Keystone, Pipeline"
label var billendshtdn "End Shutdown, Raise Debt Limit"
label var billbkrndchk "Firearm, Background, Checks"
label var billunemp "Extend, Unemployment"
label var billhiwayexim "Highway Funding, Ex-Im Bank"
label var billrplaca "Repeal Obamacare"
label var billmedicschip "Medicare Pay, and SCHIP"
label var billstdnln "Student Loan, Interest Rates"

* In same order as displayed
* in Figure created by PlotSimpleResult.R.
order billbudget15 billplnprnt billendshtdn billunemp billbkrndchk billgndrdiscrim billhiwayexim billkeystone billmedicschip billrplaca billstdnln billtrnsprt

* Regressions by roll call. 
local tabl "Tables/TableA13RollCallTreatmentEffects-SSI.tex"
local repl "replace"
* Break into three tables.
local ctr = 1
foreach var of varlist bill* {
  local templabel : var label `var'
  di "`templabel'"
  * Turn variable to numeric.
  qui encode `var', gen(`var'2)
  qui replace `var'2 = . if `var'2 == 3
  qui replace `var'2 = `var'2 - 1
  * Make sure correct.
  tab `var' `var'2, nol

  * Basic treatment effect.
  qui reg `var'2 treatment dem rep [aweight=weight]
  qui outreg2 using "`tabl'", `repl'  tex(fragment) ctitle("All, `templabel'") sdec(2) 2aster auto(2) rdec(3) label
  local repl "append"
  * Dems.
  qui reg `var'2 treatment if dem == 1 [aweight=weight]
  qui outreg2 using "`tabl'", append tex(fragment) ctitle("Dems") sdec(2) 2aster auto(2) rdec(3) label
  * Reps.
  qui reg `var'2 treatment if rep == 1 [aweight=weight]
  qui outreg2 using "`tabl'", append tex(fragment) ctitle("Reps") sdec(2) 2aster auto(2) rdec(3) label
  qui drop `var'2
  * Increment ctr.
  local ctr = `ctr' + 1
  if (`ctr' == 5) {
    * New table.
    local tabl "Tables/TableA13RollCallTreatmentEffects-SSI-2.tex"
    local repl "replace"
  }
  if (`ctr' == 9) {
    * New table.
    local tabl "Tables/TableA13RollCallTreatmentEffects-SSI-3.tex"
    local repl "replace"
  }
}
restore

****
*Recode importance/confidence measures.
****
local ctr=1
foreach var of varlist impt_Q23_1 impt_Q23_2 impt_Q23_3 impt_Q23_5 impt_Q24_1 impt_Q24_2 impt_Q24_3 impt_Q24_4 impt_Q25_1 impt_Q25_2 impt_Q25_3 impt_Q25_5 {
	gen importance_`ctr' = `var'
	local ctr=`ctr'+1
}

local ctr=1
foreach var of varlist conf_Q20_1 conf_Q20_2 conf_Q20_3 conf_Q20_5 conf_Q21_1 conf_Q21_2 conf_Q21_3 conf_Q21_4 conf_Q22_1 conf_Q22_2 conf_Q22_3 conf_Q22_5  {
	gen confidence_`ctr' = `var'
	local ctr=`ctr'+1
}

/*
preserve
collapse (mean) importance_* confidence_*
gen x=1
reshape long importance_ confidence_ , j(issuenum) i(x)
twoway (scatter confidence_ importance_ , mcolor(black) msize(small) msymbol(circle) ) (lpoly confidence_ importance_ , lcolor(black) lpattern(dash)), xlabel(0(1)3) ylabel(0(1)3) ytitle(Confidence) xtitle(Importance) title("All 12 Issues", size(medsmall)) legend(off) scheme(s1mono) name(pooled, replace)
capture graph export Figures\AcrossIssueAveragesConfImpt.pdf, as(pdf) replace
restore
*/

window manage close graph _all

****
*See if treatment assignment influences confidence.
****
qui gen treat = (assignedCondition == "Info")
preserve
keep treat confidence_* V1
reshape long confidence_, i(V1) j(bill)
reg confidence_ treat , cluster(V1)
restore

* Separately for each area.
foreach var of varlist confidence_* {
  di "`var'"
  qui reg `var' treat
  di _b[treat] " (" _se[treat] ")"
}
drop treat

****
*See how treatment effects line up with
*average confidence on issue in control condition.
****

*Create average confidence by pid for control cases.
foreach var of varlist conf_Q20_1 conf_Q20_2 conf_Q20_3 conf_Q20_5 conf_Q21_1 conf_Q21_2 conf_Q21_3 conf_Q21_4 conf_Q22_1 conf_Q22_2 conf_Q22_3 conf_Q22_5  {
  bys pid3_DtoR: egen pid_avg_`var' = mean(`var') if assignedcondition == "Standard"
  local templabel : var label `var'
  label var pid_avg_`var' "Average confidence by pid: `templabel'"
  bys pid3_DtoR: egen temp=mean(pid_avg_`var')
  replace pid_avg_`var'=temp
  drop temp
}

foreach var of varlist impt_Q23_1 impt_Q23_2 impt_Q23_3 impt_Q23_5 impt_Q24_1 impt_Q24_2 impt_Q24_3 impt_Q24_4 impt_Q25_1 impt_Q25_2 impt_Q25_3 impt_Q25_5  {
  bys pid3_DtoR: egen pid_avg_`var' = mean(`var') if assignedcondition == "Standard"
  local templabel : var label `var'
  label var pid_avg_`var' "Average importance by pid: `templabel'"
  bys pid3_DtoR: egen temp=mean(pid_avg_`var')
  replace pid_avg_`var'=temp
  drop temp
}

*Rename pid_avg vars to match bill var names.
desc pid_avg_conf* bill*
rename pid_avg_conf_Q20_1 pid_avg_c_bkrndchk
rename pid_avg_conf_Q20_2 pid_avg_c_stdnln
rename pid_avg_conf_Q20_3 pid_avg_c_trnsprt
rename pid_avg_conf_Q20_5 pid_avg_c_budget15
rename pid_avg_conf_Q21_1 pid_avg_c_unemp
rename pid_avg_conf_Q21_2 pid_avg_c_gndrdiscrim
rename pid_avg_conf_Q21_3 pid_avg_c_keystone
* It does not appear that there is anything to go with this item. This is a question about housing, which is not one of our policy areas.
drop pid_avg_conf_Q21_4
rename pid_avg_conf_Q22_1 pid_avg_c_rplaca
rename pid_avg_conf_Q22_2 pid_avg_c_medicschip
rename pid_avg_conf_Q22_3 pid_avg_c_hiwayexim
rename pid_avg_conf_Q22_5 pid_avg_c_plnprnt

desc pid_avg_impt* bill*
rename pid_avg_impt_Q23_1 pid_avg_i_bkrndchk
rename pid_avg_impt_Q23_2 pid_avg_i_stdnln
rename pid_avg_impt_Q23_3 pid_avg_i_trnsprt
rename pid_avg_impt_Q23_5 pid_avg_i_budget15
rename pid_avg_impt_Q24_1 pid_avg_i_unemp
rename pid_avg_impt_Q24_2 pid_avg_i_gndrdiscrim
rename pid_avg_impt_Q24_3  pid_avg_i_keystone
* It does not appear that there is anything to go with this item. This is a question about housing, which is not one of our policy areas.
drop pid_avg_impt_Q24_4 
rename pid_avg_impt_Q25_1 pid_avg_i_rplaca
rename pid_avg_impt_Q25_2 pid_avg_i_medicschip
rename pid_avg_impt_Q25_3 pid_avg_i_hiwayexim
rename pid_avg_impt_Q25_5 pid_avg_i_plnprnt

*Reshape to long and save out pid averages.
preserve
collapse (mean) pid_avg*  [aweight=weight], by(pid3_DtoR)
reshape long pid_avg_c_ pid_avg_i_, i(pid3_DtoR) j(billname) string
rename pid_avg_c_ pid_avg_conf
rename pid_avg_i_ pid_avg_impt
label var pid_avg_conf "Average confidence in control condition by party"
label var pid_avg_impt "Average importance in control condition by party"
gen pid3 = "Dem" if pid3_DtoR == -1
replace pid3 = "Oth/Ind" if pid3_DtoR == 0
replace pid3 = "Rep" if pid3_DtoR == 1
sort pid3 billname
save "Tables\AvgConfByPidBill`appd'.dta", replace
restore

*Load in avg treatment effects created in AnalyzeDemogsAndCreateRecodes.do.
insheet using "Tables\TreatmentEffectsByBillPid3`appd'.csv", clear
joinby pid3 billname using "Tables\AvgConfByPidBill`appd'.dta",unmatched(both)
tab _merge

gen demrep=.
replace demrep=0 if pid3=="Dem"
replace demrep=1 if pid3=="Rep"
label var demrep "Republican respondent"

****************
* Create policy confidence attenuates treatment effect 
* of information table for paper.
****************
local tabl "tables/TableA11TreatmentEffectsOnConfidence.tex"
* All respondents.
regress abs_ate pid_avg_conf demrep
outreg2 using "`tabl'", replace  tex(fragment) ctitle("All") sdec(2) 2aster auto(2) rdec(3) label
summ abs_ate  if demrep~=.
summ pid_avg_conf  if demrep ~=.
disp _b[pid_avg_conf ]*r(sd)
disp (_b[pid_avg_conf ]*r(sd))/.0839046

*Dems.
regress abs_ate pid_avg_conf if demrep==0
outreg2 using "`tabl'", append  tex(fragment) ctitle("Dems") sdec(2) 2aster auto(2) rdec(3) label
*Reps.
regress abs_ate pid_avg_conf if demrep==1
outreg2 using "`tabl'", append  tex(fragment) ctitle("Reps") sdec(2) 2aster auto(2) rdec(3) label

* Control for importance.
pwcorr pid_avg_conf  pid_avg_impt if demrep ~=., sig
regress abs_ate pid_avg_conf pid_avg_impt demrep
outreg2 using "`tabl'", append  tex(fragment) ctitle("All") sdec(2) 2aster auto(2) rdec(3) label
regress abs_ate pid_avg_conf pid_avg_impt  if demrep==0
outreg2 using "`tabl'", append  tex(fragment) ctitle("Dems") sdec(2) 2aster auto(2) rdec(3) label
regress abs_ate pid_avg_conf pid_avg_impt  if demrep==1
outreg2 using "`tabl'", append  tex(fragment) ctitle("Reps") sdec(2) 2aster auto(2) rdec(3) label

*Outsheet for R graphic.
outsheet using "RawData/ATEsAndAvgConfByPidBill`appd'.csv", comma replace

capture log close
