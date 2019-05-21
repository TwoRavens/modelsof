clear
dropbox
cd "TingleyAnalysisGeneral"

use AJPSReplication.dta, clear

set scheme s2mono
preserve
duplicates drop type, force
hist IdeoTarget, freq discrete    xlabel(1(1)7) title("Target Ideology") xtitle("Liberal : Conservative")
graph save IdeoTargetHist.gph, replace
hist MaleTarget, freq  xlabel(0(1)1,valuelabel)    title("Target Sex") xtitle("") 
graph save GenderTargetHist.gph, replace
restore
preserve
duplicates drop ideval, force
hist politicalIdeo, freq discrete    xlabel(1(1)7) title("Evaluator Ideology") xtitle("Liberal : Conservative")
graph save IdeoEvalHist.gph, replace
hist Male , freq  xlabel(0(1)1,valuelabel)    title("Evaluator Sex") xtitle("") 
graph save GenderEvalHist.gph, replace
restore
graph combine IdeoTargetHist.gph IdeoEvalHist.gph GenderTargetHist.gph GenderEvalHist.gph


estimates clear

************
*Models reported in paper
************

*first create some new necessary variables.
*mn_attractive is the mean attractiveness measure for the targets.
*so need to create mean attraction of the evaluators, to be called mn_eval_attractive
foreach k of varlist  attractive {
sort ideval
by ideval: egen mn_eval_`k'=mean(`k')
}

*Model 1
*binary versions of IdeoTarget and politicalIdeo
recode IdeoTarget 4/7=1 1/3=0, gen(IdeoTargetBinary)
recode politicalIdeo 4/7=1 1/3=0, gen(IdeoEvalBinary)
*same ideology
capture drop SameIdeology
gen SameIdeology=(IdeoTargetBinary==IdeoEvalBinary)
*same gender
gen SameGender=(Male==MaleTarget)
label var SameIdeology "Same Ideology"
label var IdeoTargetBinary "Conservative Target"
label var IdeoEvalBinary "Conservative Eval."
label var SameGender "Same Sex"
label var Male "Male Evaluator"
label var MaleTarget "Male Target"
label var mn_attractive "Avg. Target Attract"
label var  mn_eval_attractive "Avg. Eval. Attract"

*Unadjusted attractiveness of target = (evaluator is conservative) + (target is conservative) + (evaluator and target are the same ideology) + (evaluator is female) + (target is female) + (evaluator and target are same sex) + (mean attractiveness of target) + (mean evaluation of evaluator)
reg attractive IdeoEvalBinary  IdeoTargetBinary SameIdeology Male MaleTarget SameGender  mn_attractive mn_eval_attractive, cl(ideval)
est store Model1
*t-stat on interaction is 1.69
*use jacknife
reg attractive IdeoEvalBinary  IdeoTargetBinary SameIdeology Male MaleTarget SameGender  mn_attractive mn_eval_attractive, vce(jackknife)
est store Model1_JK
*t-stat on interaction is 1.65

*2
*model 2
*Unadjusted attractiveness of target = (evaluator ideology) + (target ideology) + ( -|evaluator ideology - target ideology| ) + (evaluator is female) + (target is female) + (evaluator and target are same sex) + (mean attractiveness of target) + (mean evaluation of evaluator)
gen IdeoDiffAbs=-abs(politicalIdeo-IdeoTarget) 
replace IdeoDiffAbs=. if (politicalIdeo==.|IdeoTarget==.)
label var IdeoDiffAbs "-Abs. Ideology Diff."
reg attractive politicalIdeo IdeoTarget IdeoDiffAbs  Male MaleTarget SameGender  mn_attractive mn_eval_attractive, cl(ideval)
est store Model2
**t-stat negative absolute difference is 1.48

*use jacknife
reg attractive politicalIdeo IdeoTarget IdeoDiffAbs  Male MaleTarget SameGender  mn_attractive mn_eval_attractive, vce(jackknife)
est store Model2_JK
**t-stat negative absolute difference is 1.42


*3
*model 3
*Unadjusted attractiveness of target = ( -|evaluator ideology - target ideology| ) + (evaluator and target are same sex) + evaluator fixed effects + target fixed effects
xi: reg attractive   IdeoDiffAbs SameGender i.ideval i.type, cl(ideval)
est store Model3

xi: reg attractive   IdeoDiffAbs SameGender i.ideval i.type, vce(jackknife)
est store Model3_JK
*t stat on the negative absolute distance is t=1.45


esta Model1 Model2 Model3 using "ModelResultsMainPaper.doc", se nostar brackets label drop(_I*) order(SameIdeology IdeoDiffAbs SameGender IdeoEvalBinary  IdeoTargetBinary politicalIdeo IdeoTarget Male MaleTarget ) replace
esta Model1_JK Model2_JK Model3_JK using "ModelResultsMainPaper_JK.doc", se nostar brackets label drop(_I*) order(SameIdeology IdeoDiffAbs SameGender IdeoEvalBinary  IdeoTargetBinary politicalIdeo IdeoTarget Male MaleTarget ) replace


