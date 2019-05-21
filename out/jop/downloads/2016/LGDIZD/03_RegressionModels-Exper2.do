************************
*RegressionModels-Exper2.do.
*Create regression models for Learning
*Together Slowly analysis of the second
*experiment comparing political learning
*to learning about abstract non-political
*facts.
************************

set more off
local ver = "" 

*Data.
use "indata/Exper2-DataForStata.dta", clear


******************
*Table 4: Learning political versus abstract facts.
******************
*Table name.
local tabl = "tablesAndFigs/Table4`ver'"

******************
*Learning about political facts with variation
*in learning by first round beliefs.
******************
reg logitcert logitcertprev sigcomb if partcont == 1 [aweight=weight], nocons cluster(respcont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logitcertprev=1) (sigcomb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab respid if e(sample)
outreg2 using "`tabl'.tex", replace tex(fragment) ctitle("Partisan, fact") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

*When signal consistent.
reg logitcert logitcertprev sigcomb if signalconswfirst == 1 & partcont == 1 [aweight=weight], nocons cluster(respcont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logitcertprev=1) (sigcomb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab respid if e(sample)
outreg2 using "`tabl'.tex", append tex(fragment) ctitle("Partisan fact, Signal, consistent") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
*Not consistent.
reg logitcert logitcertprev sigcomb if signalconswfirst == 0 & partcont == 1 [aweight=weight], nocons cluster(respcont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logitcertprev=1) (sigcomb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab respid if e(sample)
outreg2 using "`tabl'.tex", append tex(fragment) ctitle("Partisan fact, Not, consistent") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

*Pooled, interaction with consistent, partisan round.
reg logitcert logitcertprev sigcomb *Xfirst if partcont == 1 [aweight=weight], nocons cluster(respcont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logitcertprev=1) (sigcomb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab respid if e(sample)
outreg2 using "`tabl'.tex", append tex(fragment) ctitle("Partisan, fact") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
        
*Pooled, interaction with consistent, partisan round,
*partisan subjects.
reg logitcert logitcertprev sigcomb *Xfirst if partcont == 1 & (pidsumm == "Democrat" | pidsumm == "Republican") [aweight=weight], nocons cluster(respcont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logitcertprev=1) (sigcomb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab respid if e(sample)
outreg2 using "`tabl'.tex", append tex(fragment) ctitle("Partisan fact, Dems/Reps, only") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

******************
*Learning about abstract facts with variation
*in learning by first round beliefs.
******************
*Main model, learning about abstract fact.
reg logitcert logitcertprev sigcomb if abstrcont == 1 [aweight=weight], nocons cluster(respcont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logitcertprev=1) (sigcomb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab respid if e(sample)
outreg2 using "`tabl'.tex", append tex(fragment) ctitle("Abstract, fact") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label

*Pooled, interaction with consistent, abstract round.
reg logitcert logitcertprev sigcomb *Xfirst if abstrcont == 1 [aweight=weight], nocons cluster(respcont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logitcertprev=1) (sigcomb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab respid if e(sample)
outreg2 using "`tabl'.tex", append tex(fragment) ctitle("Abstract, fact") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
        
*Pooled, interaction with consistent, all contests.
reg logitcert logitcertprev sigcomb *Xfirst partX* if partcont == 1 | abstrcont == 1 [aweight=weight], nocons cluster(respcont)
**Tests on beta=1 and delta=1 with Bonferroni correction.
test (logitcertprev=1) (sigcomb=1), mtest(b)
matrix b = r(mtest)
local pdelta = b[1,4]
local pbeta = b[2,4]
**Grab number of unique respondents.
qui tab respid if e(sample)
outreg2 using "`tabl'.tex", append tex(fragment) ctitle("All, facts") addstat("Std. error of regression",e(rmse),"N subjects",r(r),"Wald test on null $\delta =1$",`pdelta',"Wald test on null $\beta =1$",`pbeta') sdec(2) 2aster auto(2) rdec(3) label
