
cd "c:\users\\`c(username)'\dropbox\TingleyCostaRica\ISQ\data\supplement"

use ucrdta.dta, clear
*** APPENDIX 7
graph pie if VoteCafta==1,over( MostInflFactor_collapse) plabel(_all name, size(small)) legend(off) angle(40) title(Yes Voters)
graph save "OpinInfl_YesVotes.gph", replace
graph pie if VoteCafta==0,over( MostInflFactor_collapse) plabel(_all name, size(small)) legend(off) angle(40) title(No Voters)
graph save "OpinInfl_NoVotes.gph", replace
graph combine OpinInfl_YesVotes.gph OpinInfl_NoVotes.gph, title(Most Important Influence of Opinion) 
graph export OpinInflYes_No.eps, logo(off) replace

*** APPENDIX 6
*** TABLE 7 
estimates clear
preserve
local control "Gender Age"
local ptycontrol4 "PLN_PrezVote  Libertario_PrezVote PUSC_PrezVote OtherParty_PrezVote PAC_PrezVote"
foreach var of varlist `ptycontrol4' {
drop if `var'==.
}
label var Sept "SurveyFE"
*foreach var of varlist FavorOpposeCAFTA VoteIntentionCAFTA PositiveNegBalanceCAFTA GoodBadFamily {
local dv1 "VoteIntentionCAFTA"
local dv2 "VoteCafta"
*local restrict "& Sept==1"
oprobit `dv1' `control'  EduPrimCompSecIncomp EduSecCompUnivIncomp EduUnivComp Sept  if PREREF==0 `restrict', robust
pre
estadd scalar pre=real(r(pre))
est store Pre1
oprobit `dv1' `control'  EduPrimCompSecIncomp EduSecCompUnivIncomp EduUnivComp Sept `ptycontrol4' if PREREF==0 `restrict', robust
pre
estadd scalar pre=real(r(pre))
est store Pre2
oprobit `dv1' `control'  HighIncome MiddleIncome LowMiddleIncome  Sept if PREREF==0 `restrict', robust
pre
estadd scalar pre=real(r(pre))
est store Pre3
oprobit `dv1' `control'  HighIncome MiddleIncome LowMiddleIncome  `ptycontrol4' Sept if PREREF==0 `restrict', robust
pre
estadd scalar pre=real(r(pre))
est store Pre4
oprobit `dv2' `control'  EduPrimCompSecIncomp EduSecCompUnivIncomp EduUnivComp if PREREF==1, robust
pre
estadd scalar pre=real(r(pre))
est store Post1
oprobit `dv2' `control'  EduPrimCompSecIncomp EduSecCompUnivIncomp EduUnivComp `ptycontrol4' if PREREF==1, robust
pre
estadd scalar pre=real(r(pre))
est store Post2
oprobit `dv2' `control'  HighIncome MiddleIncome LowMiddleIncome    if PREREF==1, robust
pre
estadd scalar pre=real(r(pre))
est store Post3
oprobit `dv2' `control'  HighIncome MiddleIncome LowMiddleIncome  `ptycontrol4' if PREREF==1, robust
pre
estadd scalar pre=real(r(pre))
est store Post4
local order "order(EduUnivComp EduSecCompUnivIncomp EduPrimCompSecIncomp   HighIncome MiddleIncome LowMiddleIncome PLN_PrezVote PAC_PrezVote Libertario_PrezVote PUSC_PrezVote OtherParty_PrezVote   Gender Age  )"
esttab Pre* Post*  using "table7.doc", `order' title("`var'") starlevels(+ 0.10 * 0.05 ** 0.01)  se(%8.2f)   nom nonum nodep nogaps  b(%8.2f) sca(pre) bic   label brackets  compress replace
restore

preserve
set seed 020309
estimates clear
gen VOTEDV=VoteIntentionCAFTA
replace VOTEDV=VoteCafta if VOTEDV==.
gen SurveyCount=1 if Sept==0
replace SurveyCount=2 if Sept==1
replace SurveyCount=3 if PREREF==1

local control "Gender Age"
local ptycontrol4 "PLN_PrezVote  Libertario_PrezVote PUSC_PrezVote OtherParty_PrezVote PAC_PrezVote"
foreach var of varlist `ptycontrol4' {
drop if `var'==.
}
forval j=1/3 {

capture drop b1-b11
qui estsimp probit VOTEDV `control'   HighIncome MiddleIncome LowMiddleIncome  `ptycontrol4' if SurveyCount==`j', robust
setx median
setx Gender 1  
setx Gender 1  PLN_PrezVote 0 Libertario_PrezVote 0 PUSC_PrezVote 0 OtherParty_Prez 0 PAC_PrezVote 0
simqi, fd(pr ) changex(HighIncome 0 1) 
simqi, fd(pr ) changex(PLN_PrezVote 0 1) 
simqi, fd(pr ) changex(PAC_PrezVote 0 1) 
}
restore


*** FOOTNOTE 15
preserve
estimates clear
local control "Gender Age"
local ptycontrol4 "PLN_PrezVote  Libertario_PrezVote PUSC_PrezVote OtherParty_PrezVote PAC_PrezVote"
local dv1 "VoteIntentionCAFTA"
local dv2 "VoteCafta"
local M "PLN_PrezVote"
local T "EduUnivComp"

foreach var of varlist `dv1' `control' `M' `T' {
drop if `var'==.
}
medeff (probit `M' `T' `control') (probit `dv1' `T' `M' `control') , treat(`T') mediate(`M') sims(1000)

restore

preserve
estimates clear
local control "Gender Age"
local dv1 "VoteIntentionCAFTA"
local dv2 "VoteCafta"
local M "PLN_PrezVote"
local T "Income"

foreach var of varlist `dv1' `control' `M' `T' {
drop if `var'==.
}
local restrict1 "if PREREF==0 & Sept==0"
local restrict2 "& Sept==1"
medeff (probit `M' `T' `control') (probit `dv1' `T' `M' `control')  `restrict1' , treat(`T') mediate(`M') sims(1000)
restore

preserve
estimates clear
local control "Gender Age"
local ptycontrol4 "PLN_PrezVote  Libertario_PrezVote PUSC_PrezVote OtherParty_PrezVote PAC_PrezVote"
local dv1 "VoteIntentionCAFTA"
local dv2 "VoteCafta"
local M "PAC_PrezVote"
local T "HighIncome"

foreach var of varlist `dv2' `control' `M' `T' {
drop if `var'==.
}
local restrict1 "if PREREF==0 & Sept==0"
local restrict2 " if PREREF==1 "
medeff (probit `M' `T' `control') (probit `dv2' `T' `M' `control')  `restrict2' , treat(`T') mediate(`M') sims(1000)
restore

