/*****************************
* TreatmentEffects.do
* Replication file for
* Hill, Seth J. and Gregory A. Huber. 2018. ``On The Meaning of Survey Reports of Roll Call `Votes','' American Journal of Political Science.
******************************/

set more off
* Created outside of replication archive
use RawData/HillHuberCCES2014.dta, clear

* Regression model to get diff-in-diff t-stat.
preserve
gen gop = pid3_DtoR == 1
qui gen gopXtreatment = gop*treatment
* Make sure worked: should be 1, control=0, else=.
tab treatment treat, miss
* Variable to hold did t-stat.
qui gen did_t = .
* Loop over each roll call then each condition and extract diff-in-diff t-stat.
levelsof bill, local(bills)
foreach val of local bills {
  di _n "Calculating t-stat on diff-in-diff for bill `val'."
  foreach trt of varlist treatment {
    count if `trt' == 1 & bill == `val' & pid3_DtoR != 0
    if r(N) == 0 continue
    reg vote_yea `trt' gopX`trt' gop if bill == `val' & pid3_DtoR != 0 [aweight=weight], robust
    * Extract t-stat on diff-in-diff coefficient and place in variable did_t.
    replace did_t = abs(_b[gopX`trt']/_se[gopX`trt']) if bill == `val' & `trt' == 1
  }
}

*Display the treatment and result for each bill-treatment-respondent pid.

collapse (mean) dvotesfor rvotesfor vote_yea did_t (count) n=vote_yea [aweight=weight], by(pid3_DtoR bill treat)
cl if dvotesfor != .
*Check on margins for standard roll call from common
*versus standard roll call from module. Currently
*for bills 2 and 3, US Korea Free Trade and Simpson
*Bowles.
cl bill pid3_DtoR treat vote_yea n if dvotesfor != . & (treat == 1 | treat == 7 | treat == 8) & (bill == 2 | bill == 3)
*Save out for R graphics.
outsheet using "Tables\SupportByBillTreatPid.csv", comma replace
restore

* Same thing, unweighted
* Regression model to get diff-in-diff t-stat.
preserve
replace weight=1
gen gop = pid3_DtoR == 1
qui gen gopXtreatment = gop*treatment
* Make sure worked: should be 1, control=0, else=.
tab treatment treat, miss
* Variable to hold did t-stat.
qui gen did_t = .
* Loop over each roll call then each condition and extract diff-in-diff t-stat.
levelsof bill, local(bills)
foreach val of local bills {
  di _n "Calculating t-stat on diff-in-diff for bill `val'."
  foreach trt of varlist treatment {
    count if `trt' == 1 & bill == `val' & pid3_DtoR != 0
    if r(N) == 0 continue
    reg vote_yea `trt' gopX`trt' gop if bill == `val' & pid3_DtoR != 0 [aweight=weight], robust
    * Extract t-stat on diff-in-diff coefficient and place in variable did_t.
    replace did_t = abs(_b[gopX`trt']/_se[gopX`trt']) if bill == `val' & `trt' == 1
  }
}

*Display the treatment and result for each bill-treatment-respondent pid.

collapse (mean) dvotesfor rvotesfor vote_yea did_t (count) n=vote_yea [aweight=weight], by(pid3_DtoR bill treat)
cl if dvotesfor != .
*Check on margins for standard roll call from common
*versus standard roll call from module. Currently
*for bills 2 and 3, US Korea Free Trade and Simpson
*Bowles.
cl bill pid3_DtoR treat vote_yea n if dvotesfor != . & (treat == 1 | treat == 7 | treat == 8) & (bill == 2 | bill == 3)
*Save out for R graphics.
outsheet using "Tables\SupportByBillTreatPid-Unweighted.csv", comma replace
restore

*Cross pid-by-ideo.
preserve
collapse (mean) dvotesfor rvotesfor vote_yea (count) n=vote_yea [aweight=weight], by(pid3_DtoR ideo3 bill treat)
cl if dvotesfor != .
*Save out for R graphics.
outsheet using "Tables\SupportByBillTreatPid-Cross-Ideo.csv", comma replace
restore

/*
***************
*Display the treatment and result for each bill-treatment-respondent ideo.
***************
preserve
collapse (mean) dvotesfor rvotesfor vote_yea did_t (count) n=vote_yea [aweight=weight], by(ideo3 bill treat)
cl if dvotesfor != .
*Save out for R graphics.
outsheet using "Tables\SupportByBillTreatIdeo.csv", comma replace
restore
*/

**************************
* Treatment effects on roll calls via OLS.
**************************
summ
preserve
gen dem = pid3_DtoR == -1
label var dem "Democrat"
gen rep = pid3_DtoR == 1
label var rep "Republican"

* Regressions by roll call. In same order as displayed
* in Figure 1 created by 02_MakeFigures.R.
local tabl "Tables/TableA06RollCallTreatmentEffects-CCES.tex"
local repl "replace"
* Sort by alphabetical order.
decode bill, gen(bill2)
* Add some commas for line breaks.
replace bill2 = "Bipartisan Budget, Bill of 2013" if bill2 == "Bipartisan Budget Bill of 2013"
replace bill2 = "End Government Shutdown, and Raise Debt Ceiling 2013" if bill2 == "End Government Shutdown and Raise Debt Ceiling, 2013"
replace bill2 = "Lowering Gasoline Prices, to Fuel an America That, Works Act of 2014" if bill2 == "Lowering Gasoline Prices to Fuel an America That Works Act of 2014"
replace bill2 = "Repeal of Affordable, Care Act/Obamacare" if bill2 == "Repeal of Affordable Care Act/Obamacare"
replace bill2 = "Violence Against, Women Reauthorization, Act of 2013" if bill2 == "Violence Against Women Reauthorization Act of 2013"
replace bill2 = "Simpson-Bowles, Budget" if bill2 == "Simpson-Bowles Budget"
replace bill2 = "US-Korea, Free Trade" if bill2 == "US-Korea Free Trade"
replace bill2 = "Keystone, Pipeline" if bill2 == "Keystone Pipeline"
* Break into two tables.
local ctr = 1
levelsof bill2, local(levels)
foreach l of local levels {
  di "`l'"
  * Basic treatment effect.
  qui reg vote_yea treatment dem rep if bill2 == "`l'" [aweight=weight]
  qui outreg2 using "`tabl'", `repl'  tex(fragment) ctitle("All, `l'") sdec(2) 2aster auto(2) rdec(3) label
  local repl "append"
  * Dems.
  qui reg vote_yea treatment if dem == 1 & bill2 == "`l'" [aweight=weight]
  qui outreg2 using "`tabl'", append tex(fragment) ctitle("Dems") sdec(2) 2aster auto(2) rdec(3) label
  * Reps.
  qui reg vote_yea treatment if rep == 1 & bill2 == "`l'" [aweight=weight]
  qui outreg2 using "`tabl'", append tex(fragment) ctitle("Reps") sdec(2) 2aster auto(2) rdec(3) label
  * Increment ctr.
  local ctr = `ctr' + 1
  if (`ctr' == 5) {
    * New table.
    local tabl "Tables/TableA06RollCallTreatmentEffects-CCES-2.tex"
    local repl "replace"
  }
}
restore

* Repeat, unweighted
preserve
replace weight=1
gen dem = pid3_DtoR == -1
label var dem "Democrat"
gen rep = pid3_DtoR == 1
label var rep "Republican"

* Regressions by roll call. In same order as displayed
* in Figure 1 created by 02_MakeFigures.R.
local tabl "Tables/TableA12RollCallTreatmentEffects-CCES.tex"
local repl "replace"
* Sort by alphabetical order.
decode bill, gen(bill2)
* Add some commas for line breaks.
replace bill2 = "Bipartisan Budget, Bill of 2013" if bill2 == "Bipartisan Budget Bill of 2013"
replace bill2 = "End Government Shutdown, and Raise Debt Ceiling 2013" if bill2 == "End Government Shutdown and Raise Debt Ceiling, 2013"
replace bill2 = "Lowering Gasoline Prices, to Fuel an America That, Works Act of 2014" if bill2 == "Lowering Gasoline Prices to Fuel an America That Works Act of 2014"
replace bill2 = "Repeal of Affordable, Care Act/Obamacare" if bill2 == "Repeal of Affordable Care Act/Obamacare"
replace bill2 = "Violence Against, Women Reauthorization, Act of 2013" if bill2 == "Violence Against Women Reauthorization Act of 2013"
replace bill2 = "Simpson-Bowles, Budget" if bill2 == "Simpson-Bowles Budget"
replace bill2 = "US-Korea, Free Trade" if bill2 == "US-Korea Free Trade"
replace bill2 = "Keystone, Pipeline" if bill2 == "Keystone Pipeline"
* Break into two tables.
local ctr = 1
levelsof bill2, local(levels)
foreach l of local levels {
  di "`l'"
  * Basic treatment effect.
  qui reg vote_yea treatment dem rep if bill2 == "`l'" [aweight=weight]
  qui outreg2 using "`tabl'", `repl'  tex(fragment) ctitle("All, `l'") sdec(2) 2aster auto(2) rdec(3) label
  local repl "append"
  * Dems.
  qui reg vote_yea treatment if dem == 1 & bill2 == "`l'" [aweight=weight]
  qui outreg2 using "`tabl'", append tex(fragment) ctitle("Dems") sdec(2) 2aster auto(2) rdec(3) label
  * Reps.
  qui reg vote_yea treatment if rep == 1 & bill2 == "`l'" [aweight=weight]
  qui outreg2 using "`tabl'", append tex(fragment) ctitle("Reps") sdec(2) 2aster auto(2) rdec(3) label
  * Increment ctr.
  local ctr = `ctr' + 1
  if (`ctr' == 5) {
    * New table.
    local tabl "Tables/TableA12RollCallTreatmentEffects-CCES-2.tex"
    local repl "replace"
  }
}
restore

**************************
* Balance tables on treatment assignment.
**************************
summ
preserve

* Unweighted.
* Use svy command to make comparable.
svyset V101
qui xi: svy: logit treatment d_*
local tabl "Tables/TableA10BalanceTable-CCES.tex"
test
outreg2 using "`tabl'", replace  tex(fragment) ctitle("Unweighted") sdec(2) 2aster auto(2) rdec(3) label  adds(F-test, `r(F)', F p-value, `r(p)') adec(3) sideway
 
* Weighted.
svyset, clear
svyset V101 [pweight=weight]
qui xi: svy: logit treatment d_*
test
outreg2 using "`tabl'", append  tex(fragment) ctitle("Weighted") sdec(2) 2aster auto(2) rdec(3) label  adds(F-test, `r(F)', F p-value, `r(p)') adec(3) sideway
svyset, clear

restore
