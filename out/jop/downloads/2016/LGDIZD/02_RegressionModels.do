************************
*RegressionModels.do.
*Create regression models for Learning
*Together Slowly.
************************

set more off
***
*Which weights to use?
*"" - unweighted.
*"-Pew" - weights from rakeToPew.R.
*Limit by IQ?
*"-iq-hi" - Pew weights, subjects in top half of IQ.
*"-iq-lo" - Pew weights, subjects in bottom half of IQ.
***
local ver = "-pew" 
*local ver = "-iq-hi" 
*local ver = "" 

*Data written out from analyzeScreen.R.
use "DataForStata`ver'.dta", clear

*Label some variables and generate interactions.
label var logit_cert_prev "Logit prior ($\delta$)"
label var sig_comb "Signal ($\beta$)"
gen partXprev = (iq_round==0)*logit_cert_prev
label var partXprev "Logit prior*Partisan fact"
gen partXsig = (iq_round==0)*sig_comb
label var partXsig "Signal*Partisan fact"
*Panel unit variable at the respondent-contest.
egen resp_cont = group(resp_id stub)

******************
*Table 2: Learning about political facts with variation
*in learning by first round beliefs.
******************
*Table name.
local tabl = "Table2`ver'"
gen sig_combXfirst = sig_comb*signal_cons_w_first
label var sig_combXfirst "Signal*Signal consistent ($\beta_{2}$)"
gen logit_cert_prevXfirst = logit_cert_prev*signal_cons_w_first
label var logit_cert_prevXfirst "Logit prior*Signal consistent ($\delta_{2}$)"

*Main model.
reg logit_cert logit_cert_prev sig_comb if iq_round == 0 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/`tabl'.tex", replace tex(fragment) ctitle("Pooled") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

*When signal consistent.
reg logit_cert logit_cert_prev sig_comb if signal_cons_w_first == 1 & iq_round == 0 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/`tabl'.tex", append tex(fragment) ctitle("Signal, consistent") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
*Not consistent.
reg logit_cert logit_cert_prev sig_comb if signal_cons_w_first == 0 & iq_round == 0 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/`tabl'.tex", append tex(fragment) ctitle("Not, consistent") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

*Pooled, interaction with consistent, partisan round.
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/`tabl'.tex", append tex(fragment) ctitle("Pooled") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
        
*Pooled, interaction with consistent, partisan round,
*partisan subjects.
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 & (pid_summ == "Democrat" | pid_summ == "Republican") [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/`tabl'.tex", append tex(fragment) ctitle("Dems/Reps, only") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label


******************
*Table 3: Learning about performance on quiz.
******************
*Table name.
local tabl = "Table3`ver'"
gen partXsig_combXfir = (iq_round==0)*sig_comb*signal_cons_w_first
label var partXsig_combXfir "Partisan*Signal*Signal consistent"
gen partXlogit_cert_prevXfir = (iq_round==0)*logit_cert_prev*signal_cons_w_first
label var partXlogit_cert_prevXfir "Partisan*Logit prior*Signal consistent"

*Main model.
reg logit_cert logit_cert_prev sig_comb if iq_round == 1 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/`tabl'.tex", replace tex(fragment) ctitle("Pooled") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

*Pooled, interaction with consistent, iq round.
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 1 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/`tabl'.tex", append tex(fragment) ctitle("Pooled") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
        
*Pooled, interaction with consistent, iq round,
*partisan subjects.
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 1 & (pid_summ == "Democrat" | pid_summ == "Republican") [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/`tabl'.tex", append tex(fragment) ctitle("Dems/Reps, only") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

*Pooled, interaction with consistent, all contests.
reg logit_cert logit_cert_prev sig_comb *Xfirst partX* [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/`tabl'.tex", append tex(fragment) ctitle("All, contests") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label


******************
*Table A5: Round by round in each contest.
******************

qui gen stub2 = .
qui replace stub2 = 1 if stub == "contest1"
qui replace stub2 = 2 if stub == "contest2"
qui replace stub2 = 3 if stub == "selfcon"
label define stub2 1 "Partisan 1" 2 "Partisan 2" 3 "IQ"
label values stub2 stub2

local repl = "replace"
*Loop over contests.
levelsof stub2 , local(levels)
foreach l of local levels {
  local templabel : label (stub2) `l'
  *Loop over rounds.
  forvalues i=2/5 {
    qui reg logit_cert logit_cert_prev sig_comb if stub2 == `l' & round_num == `i' [aweight=weight], nocons cluster(resp_cont)
    qui outreg2 using "tablesAndFigs/PooledSignalModels-ByRound`ver'.tex", `repl' tex(fragment) ctitle("`templabel'-`i'") sdec(2) 2aster auto(2) rdec(3) label
    local repl = "append"
  }
}

******************
*Table A6: By question and subject party.
******************
label var sig_true "Signal TRUE"
label var sig_fals "Signal FALSE"

*IQ fact.
reg logit_cert logit_cert_prev sig_true sig_fals if iq_round == 1 [aweight=weight], nocons cluster(resp_cont)
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/SplitSignalBiasUpdateModels-ByQx`ver'.tex", replace tex(fragment) ctitle("IQ") addstat("Std. error of regression",e(rmse),"N subjects",r(r)) sdec(2) 2aster auto(2) rdec(3) label

*First three facts favor Dems, second three Reps.
foreach fact in "Kerry Share" "Obama Income" "Abortion" "Bush Unemploy" "Reagan Debt"  "Romney Share" {
  *Democrats.
  qui reg logit_cert logit_cert_prev sig_true sig_fals if pid_summ == "Democrat" & fact_short2 == "`fact'" [aweight=weight], nocons cluster(resp_cont)
  **Grab number of unique respondents.
  qui tab resp_id if e(sample)
  outreg2 using "tablesAndFigs/SplitSignalBiasUpdateModels-ByQx`ver'.tex", append tex(fragment) ctitle("`fact',Dems") addstat("Std. error of regression",e(rmse),"N subjects",r(r))  sdec(2) 2aster auto(2) rdec(3) label
  *Republicans.
  qui reg logit_cert logit_cert_prev sig_true sig_fals if pid_summ == "Republican" & fact_short2 == "`fact'" [aweight=weight], nocons cluster(resp_cont)
  **Grab number of unique respondents.
  qui tab resp_id if e(sample)
  outreg2 using "tablesAndFigs/SplitSignalBiasUpdateModels-ByQx`ver'.tex", append tex(fragment) ctitle("`fact',Reps") addstat("Std. error of regression",e(rmse),"N subjects",r(r)) sdec(2) 2aster auto(2) rdec(3) label
}


******************
*Table AX: Heterogeneity by interest in compromise,
*primary turnout, ideology, and activity.
*Note: also create presentation version, which is
*split across two tables, Present-HeterogeneityInUpdating1
*and Present-HeterogeneityInUpdating2.
******************
gen partisan = pid_summ == "Democrat" | pid_summ == "Republican"
  
*Basic model from table 3.
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 & partisan == 1 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/HeterogeneityInUpdating`ver'.tex", replace tex(fragment) ctitle("Base") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/Present-HeterogeneityInUpdating1`ver'.tex", replace tex(fragment) ctitle("Base") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/Present-HeterogeneityInUpdating2`ver'.tex", replace tex(fragment) ctitle("Base") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

*Primary turnout.
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 & partisan == 1 & voted_14p == 1 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/HeterogeneityInUpdating`ver'.tex", append tex(fragment) ctitle("Primary, voter") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/Present-HeterogeneityInUpdating1`ver'.tex", append tex(fragment) ctitle("Primary, voter") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 & partisan == 1 & voted_14p == 0 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/HeterogeneityInUpdating`ver'.tex", append tex(fragment) ctitle("Not, primary") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/Present-HeterogeneityInUpdating1`ver'.tex", append tex(fragment) ctitle("Not, primary") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

*By ideology.
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 & partisan == 1 & ideo2 == "Lib" [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/HeterogeneityInUpdating`ver'.tex", append tex(fragment) ctitle("Liberal") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/Present-HeterogeneityInUpdating1`ver'.tex", append tex(fragment) ctitle("Liberal") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 & partisan == 1 & ideo2 == "Mod" [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/HeterogeneityInUpdating`ver'.tex", append tex(fragment) ctitle("Moderate") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/Present-HeterogeneityInUpdating1`ver'.tex", append tex(fragment) ctitle("Moderate") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 & partisan == 1 & ideo2 == "Con" [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/HeterogeneityInUpdating`ver'.tex", append tex(fragment) ctitle("Conservative") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/Present-HeterogeneityInUpdating1`ver'.tex", append tex(fragment) ctitle("Conservative") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

*By interest in politicans who compromise.
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 & partisan == 1 & like_compromise == 1 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/HeterogeneityInUpdating`ver'.tex", append tex(fragment) ctitle("Likes, compromise") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/Present-HeterogeneityInUpdating2`ver'.tex", append tex(fragment) ctitle("Likes, compromise") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 & partisan == 1 & like_compromise == 0 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/HeterogeneityInUpdating`ver'.tex", append tex(fragment) ctitle("Dislikes, compromise") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/Present-HeterogeneityInUpdating2`ver'.tex", append tex(fragment) ctitle("Dislikes, compromise") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

*By political contact/donation.
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 & partisan == 1 & poli_contact_or_donate == 1 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/HeterogeneityInUpdating`ver'.tex", append tex(fragment) ctitle("Active") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/Present-HeterogeneityInUpdating2`ver'.tex", append tex(fragment) ctitle("Active") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
reg logit_cert logit_cert_prev sig_comb *Xfirst if iq_round == 0 & partisan == 1 & poli_contact_or_donate == 0 [aweight=weight], nocons cluster(resp_cont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logit_cert_prev=1) (sig_comb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/HeterogeneityInUpdating`ver'.tex", append tex(fragment) ctitle("Not active") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
qui tab resp_id if e(sample)
outreg2 using "tablesAndFigs/Present-HeterogeneityInUpdating2`ver'.tex", append tex(fragment) ctitle("Not active") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
  
  
******************
*Table AX: Check for post-treatment bias by predicting covariate responses
*with treatment assignments.
******************

*Reshape to single observation per individual for partisan contests.
drop if stub == "selfcon"
qui gen contest = 1 if stub == "contest1"
qui replace contest = 2 if stub == "contest2"
*Drop round specific variables.
keep resp_id fact_short2 sig_comb pid_summ-weight contest
*Collapse to contest level obs.
collapse (sum) sig_comb, by(resp_id fact_short2 pid_summ-weight contest)
*Reshape to wide -- single obs per individual.
reshape wide sig_comb fact_short2, i(resp_id) j(contest)

*Create indicators for each covariate category used.
tab pid_summ if pid_summ != "NA", gen(ipid_)
tab ideo2 if ideo2 != "NA", gen(iideo_)

*Regressions predicting each outcome by treatment assignment.
*Dem pid.
xi: reg ipid_1 i.fact_short21*i.sig_comb1 i.fact_short22*i.sig_comb2
local fp = Ftail(e(df_m),e(df_r),e(F))
di `fp'
outreg2 using "tablesAndFigs/PostTreatmentBias`ver'.tex", replace tex(fragment) ctitle("PID:, Democrat") addstat("F-test p-value",`fp') sdec(2) 2aster auto(2) rdec(3) label
*Neither pid.
xi: reg ipid_2 i.fact_short21*i.sig_comb1 i.fact_short22*i.sig_comb2
local fp = Ftail(e(df_m),e(df_r),e(F))
di `fp'
outreg2 using "tablesAndFigs/PostTreatmentBias`ver'.tex", append tex(fragment) ctitle("PID:, Pure Ind") addstat("F-test p-value",`fp') sdec(2) 2aster auto(2) rdec(3) label
*Rep pid.
xi: reg ipid_3 i.fact_short21*i.sig_comb1 i.fact_short22*i.sig_comb2
local fp = Ftail(e(df_m),e(df_r),e(F))
di `fp'
outreg2 using "tablesAndFigs/PostTreatmentBias`ver'.tex", append tex(fragment) ctitle("PID:, Republican") addstat("F-test p-value",`fp') sdec(2) 2aster auto(2) rdec(3) label

*Con ideo.
xi: reg iideo_1 i.fact_short21*i.sig_comb1 i.fact_short22*i.sig_comb2
local fp = Ftail(e(df_m),e(df_r),e(F))
di `fp'
outreg2 using "tablesAndFigs/PostTreatmentBias`ver'.tex", append tex(fragment) ctitle("Ideo:, Conservative") addstat("F-test p-value",`fp') sdec(2) 2aster auto(2) rdec(3) label
*Mod ideo.
xi: reg iideo_3 i.fact_short21*i.sig_comb1 i.fact_short22*i.sig_comb2
local fp = Ftail(e(df_m),e(df_r),e(F))
di `fp'
outreg2 using "tablesAndFigs/PostTreatmentBias`ver'.tex", append tex(fragment) ctitle("Ideo:, Moderate") addstat("F-test p-value",`fp') sdec(2) 2aster auto(2) rdec(3) label
*Lib ideo.
xi: reg iideo_2 i.fact_short21*i.sig_comb1 i.fact_short22*i.sig_comb2
local fp = Ftail(e(df_m),e(df_r),e(F))
di `fp'
outreg2 using "tablesAndFigs/PostTreatmentBias`ver'.tex", append tex(fragment) ctitle("Ideo:, Liberal") addstat("F-test p-value",`fp') sdec(2) 2aster auto(2) rdec(3) label

*Likes politicians who compromise
xi: reg like_compromise i.fact_short21*i.sig_comb1 i.fact_short22*i.sig_comb2
local fp = Ftail(e(df_m),e(df_r),e(F))
di `fp'
outreg2 using "tablesAndFigs/PostTreatmentBias`ver'.tex", append tex(fragment) ctitle("Likes, Compromise") addstat("F-test p-value",`fp') sdec(2) 2aster auto(2) rdec(3) label
*Active in politics
xi: reg poli_contact_or_donate i.fact_short21*i.sig_comb1 i.fact_short22*i.sig_comb2
local fp = Ftail(e(df_m),e(df_r),e(F))
di `fp'
outreg2 using "tablesAndFigs/PostTreatmentBias`ver'.tex", append tex(fragment) ctitle("Active, in Politics") addstat("F-test p-value",`fp') sdec(2) 2aster auto(2) rdec(3) label
