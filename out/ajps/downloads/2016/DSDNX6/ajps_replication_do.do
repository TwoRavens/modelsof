* Replicate Tables from Manuscript Text *

* Justification Experiment *
use "cces2014.dta", clear

* Table 1 *
logit bypasscongressbin bypassobstruct gop5 dem5  male education age white, robust
outreg2 using table1, word label dec(2) sortvar(bypassobstruct bypassobstructxgop5 bypassobstructxdem5 gop5 dem5 male education age white) replace 2aster 
logit bypasscongressbin bypassobstruct bypassobstructxgop5 bypassobstructxdem5 gop5 dem5 male education age white, robust
outreg2 using table1, word label dec(2) sortvar(bypassobstruct bypassobstructxgop5 bypassobstructxdem5 gop5 dem5 male education age white) append 2aster 

* Two Presidencies Experiment *
use "yougovsurvey1.dta", clear

* Table 2 *
logit supportuabin foreign gop5 dem5 male age education white, robust
outreg2 using table2, word label dec(2) sortvar(foreign foreignxgop5 foreignxdem5 gop5 dem5 male education age white) replace 2aster
logit supportuabin foreign foreignxgop5 foreignxdem5 gop5 dem5 male age education white, robust
outreg2 using table2, word label dec(2) sortvar(foreign foreignxgop5 foreignxdem5 gop5 dem5 male education age white) append 2aster

* Bush vs. Obama Experiment *
use "cces2014.dta", clear

* Table 3 *
logit toofarterror bushtreat gop5 dem5 male education age white, robust
outreg2 using table3, word label dec(2) sortvar(bushtreat bushtreatxgop5 bushtreatxdem5 gop5 dem5 male education age white) replace 2aster
logit toofarterror bushtreat bushtreatxgop5 bushtreatxdem5 gop5 dem5 male education age white, robust
outreg2 using table3, word label dec(2) sortvar(bushtreat bushtreatxgop5 bushtreatxdem5 gop5 dem5 male education age white) append 2aster

* Student Loans EO vs. Law Experiment *

* Table 4 *
logit studentloanbin loaneotreat gop5 dem5 male education age white studentloandebt, robust
outreg2 using table4, word label dec(2)  sortvar(studentloanbin loaneotreat loaneotreatxgop5 loaneotreatxdem5 loaneotreatxstudentloandebt gop5 dem5 male education age white studentloandebt) replace 2aster
logit studentloanbin loaneotreat loaneotreatxgop5 loaneotreatxdem5 gop5 dem5 male education age white studentloandebt, robust
outreg2 using table4, word label dec(2)  sortvar(studentloanbin loaneotreat loaneotreatxgop5 loaneotreatxdem5 loaneotreatxstudentloandebt gop5 dem5 male education age white studentloandebt) append 2aster
logit studentloanbin loaneotreat loaneotreatxstudentloandebt gop5 dem5 male education age white studentloandebt, robust
outreg2 using table4, word label dec(2)  sortvar(studentloanbin loaneotreat loaneotreatxgop5 loaneotreatxdem5 loaneotreatxstudentloandebt gop5 dem5 male education age white studentloandebt) append 2aster

* Immigration EO vs. Law Experiment *
use "yougovsurvey2.dta", clear

* Table 5 *
logit immigrationbin eotreat gop5 dem5 male education age white latino, robust
outreg2 using table5, word label dec(2)  sortvar(eotreat eotreatxgop5 eotreatxdem5 eotreatxlatino gop5 dem5 male education age white latino) replace 2aster
logit immigrationbin eotreat eotreatxgop5 eotreatxdem5 gop5 dem5 male education age white latino, robust
outreg2 using table5, word label dec(2)  sortvar(eotreat eotreatxgop5 eotreatxdem5 eotreatxlatino gop5 dem5 male education age white latino) append 2aster
logit immigrationbin eotreat eotreatxlatino gop5 dem5 male education age white latino, robust
outreg2 using table5, word label dec(2)  sortvar(eotreat eotreatxgop5 eotreatxdem5 eotreatxlatino gop5 dem5 male education age white latino) append 2aster


* Replicate Tables from Supporting Information *

* SI Table 1 -- summary statistics *
use "cces2014.dta", clear
sum gop3 gop5 dem3 dem5 male age white black latino
tab educ
tab faminc

use "yougovsurvey1.dta", clear
sum gop3 gop5 dem3 dem5 male age white black latino
tab educ
tab faminc

use "yougovsurvey2.dta", clear
sum gop3 gop5 dem3 dem5 male age white black latino
tab educ
tab faminc

* SI Table 2 -- Justification experiment difference in means *
use "cces2014.dta", clear
ttest bypasscongressbin, by(bypassobstruct)
ttest bypasscongressbin if gop5 == 1, by(bypassobstruct)
ttest bypasscongressbin if dem5 == 1, by(bypassobstruct)
ttest bypasscongressbin if gop5 == 0 & dem5 == 0, by(bypassobstruct)

* SI Table 3 -- Two presidenceis experiment difference in means *
use "yougovsurvey1.dta", clear
ttest supportuabin, by(foreign)
ttest supportuabin if gop5 == 1, by(foreign)
ttest supportuabin if dem5 == 1, by(foreign)
ttest supportuabin if dem5 == 0 & gop5 == 0, by(foreign)

* SI Table 4 -- Partisan source experiment difference in means *
use "cces2014.dta", clear
ttest toofarterror, by(bushtreat)
ttest toofarterror if gop5 == 1, by(bushtreat)
ttest toofarterror if dem5 == 1, by(bushtreat)
ttest toofarterror if dem5 == 0 & gop5 == 0, by(bushtreat)

* SI Table 5 -- Student loans experiment difference in means *
use "cces2014.dta", clear
ttest studentloanbin, by(loaneotreat)
ttest studentloanbin if gop5 == 1, by(loaneotreat)
ttest studentloanbin if dem5 == 1, by(loaneotreat)
ttest studentloanbin if dem5 == 0 & gop5 == 0, by(loaneotreat)
ttest studentloanbin if studentloandebt == 1, by(loaneotreat)
ttest studentloanbin if studentloandebt == 0, by(loaneotreat)

* SI Table 6 -- Immigration reform experiment difference in means *
use "yougovsurvey2.dta", clear
ttest immigrationbin, by(eotreat)
ttest immigrationbin if gop5 == 1, by(eotreat)
ttest immigrationbin if dem5 == 1, by(eotreat)
ttest immigrationbin if gop5 == 0 & dem5 == 0, by(eotreat)
ttest immigrationbin if latino == 1, by(eotreat)
ttest immigrationbin if latino == 0, by(eotreat)

* SI Table 7 -- Justification experiment, leaners treated as independents *
use "cces2014.dta", clear
ttest bypasscongressbin, by(bypassobstruct)
ttest bypasscongressbin if gop3 == 1, by(bypassobstruct)
ttest bypasscongressbin if dem3 == 1, by(bypassobstruct)
ttest bypasscongressbin if gop3 == 0 & dem3 == 0, by(bypassobstruct)

* SI Table 8 -- robustness checks on justification experiment *
logit bypasscongressbin bypassobstruct bypassobstructxgop3 bypassobstructxdem3 gop3 dem3 male education age white, robust 
outreg2 using sitable8, word label dec(2) sortvar(bypassobstruct bypassobstructxgop3 bypassobstructxdem3 bypassobstructxgop5 bypassobstructxdem5 gop3 dem3 gop5 dem5 male education age white) replace 2aster
logit bypasscongressbin bypassobstruct bypassobstructxgop3 bypassobstructxdem3 gop3 dem3 male education age white if pid7 < 8, robust
outreg2 using sitable8, word label dec(2) sortvar(bypassobstruct bypassobstructxgop3 bypassobstructxdem3 bypassobstructxgop5 bypassobstructxdem5 gop3 dem3 gop5 dem5 male education age white) append 2aster
logit bypasscongressbin bypassobstruct bypassobstructxgop5 bypassobstructxdem5 gop5 dem5 male education age white if pid7 < 8, robust
outreg2 using sitable8, word label dec(2) sortvar(bypassobstruct bypassobstructxgop3 bypassobstructxdem3 bypassobstructxgop5 bypassobstructxdem5 gop3 dem3 gop5 dem5 male education age white) append 2aster

* SI Table 9 -- justification experiment controlling for presidential approval *
logit bypasscongressbin bypassobstruct gop5 dem5  male education age white approveobamabin, robust
outreg2 using sitable9, word label dec(2) sortvar(bypassobstruct bypassobstructxgop5 bypassobstructxdem5 gop5 dem5 male education age white approveobamabin) replace 2aster
logit bypasscongressbin bypassobstruct bypassobstructxgop5 bypassobstructxdem5 gop5 dem5 male education age white approveobamabin, robust
outreg2 using sitable9, word label dec(2) sortvar(bypassobstruct bypassobstructxgop5 bypassobstructxdem5 gop5 dem5 male education age white approveobamabin) append 2aster
logit bypasscongressbin bypassobstruct bypassobstructxapproveobama  gop5 dem5 male education age white approveobamabin, robust
outreg2 using sitable9, word label dec(2) sortvar(bypassobstruct bypassobstructxgop5 bypassobstructxdem5 bypassobstructxapproveobama gop5 dem5 male education age white approveobamabin) append 2aster

* SI Table 10 -- partisan source experiment controlling for presidential approval *
logit toofarterror bushtreat gop5 dem5 male education age white approveobamabin, robust
outreg2 using sitable10, word label dec(2) sortvar(bushtreat bushtreatxgop5 bushtreatxdem5 gop5 dem5 male education age white approveobamabin) replace 2aster
logit toofarterror bushtreat bushtreatxgop5 bushtreatxdem5 gop5 dem5 male education age white approveobamabin, robust
outreg2 using sitable10, word label dec(2) sortvar(bushtreat bushtreatxgop5 bushtreatxdem5 gop5 dem5 male education age white approveobamabin) append 2aster
logit toofarterror bushtreat  bushtreatxapproveobama gop5 dem5 male education age white approveobamabin, robust
outreg2 using sitable10, word label dec(2) sortvar(bushtreat bushtreatxgop5 bushtreatxdem5 bushtreatxapproveobama gop5 dem5 male education age white approveobamabin) append 2aster

* SI Table 11 -- student loans experiment controlling for presidential approval *
logit studentloanbin loaneotreat gop5 dem5 male education age white approveobamabin studentloandebt, robust
outreg2 using sitable11, word label dec(2)  sortvar(studentloanbin loaneotreat loaneotreatxgop5 loaneotreatxdem5 loaneotreatxstudentloandebt gop5 dem5 male education age white approveobamabin studentloandebt) replace 2aster
logit studentloanbin loaneotreat loaneotreatxgop5 loaneotreatxdem5 gop5 dem5 male education age white approveobamabin studentloandebt, robust
outreg2 using sitable11, word label dec(2)  sortvar(studentloanbin loaneotreat loaneotreatxgop5 loaneotreatxdem5 loaneotreatxstudentloandebt gop5 dem5 male education age white approveobamabin studentloandebt) append 2aster
logit studentloanbin loaneotreat loaneotreatxstudentloandebt gop5 dem5 male education age white approveobamabin studentloandebt, robust
outreg2 using sitable11, word label dec(2)  sortvar(studentloanbin loaneotreat loaneotreatxgop5 loaneotreatxdem5 loaneotreatxstudentloandebt gop5 dem5 male education age white approveobamabin studentloandebt) append 2aster
logit studentloanbin loaneotreat loaneotreatxapproveobama gop5 dem5 male education age white approveobamabin studentloandebt, robust
outreg2 using sitable11, word label dec(2)  sortvar(studentloanbin loaneotreat loaneotreatxgop5 loaneotreatxdem5 loaneotreatxstudentloandebt loaneotreatxapproveobama gop5 dem5 male education age white approveobamabin studentloandebt) append 2aster

* SI Table 12 -- is justification treatment effect moderated by political knowledge *

* Generate Additive Political Knowledge Measure from Six CCES Questions *
*CC14_309a                     Party of Government Knowledge - Reps
*CC14_309b                     Party of Government Knowledge - Senate
*CC14_310a                     Party Recall + Name Recognition - Governor
*CC14_310b                     Party Recall + Name Recognition - Senator 1
*CC14_310c                     Party Recall + Name Recognition - Senator 2
*CC14_310d                     Party Recall + Name Recognition - Rep

* Republicans controlled the House *
gen knowpartycontrolhouse = 0
replace knowpartycontrolhouse = 1 if CC14_309a == 1
* Democrats controlled the Senate -- question asked on preelection wave of CCES survey *
gen knowpartycontrolsenate = 0
replace knowpartycontrolsenate = 1 if CC14_309b == 2

gen knowpartygov = 0
gen knowpartysen1 = 0
gen knowpartysen2 = 0
gen knowpartyhouse = 0

replace knowpartygov = 1 if CurrentGovParty == "Democratic" & CC14_310a == 3
replace knowpartygov = 1 if CurrentGovParty == "Republican" & CC14_310a == 2

replace knowpartyhouse = 1 if CurrentHouseParty == "Democratic" & CC14_310d == 3
replace knowpartyhouse = 1 if CurrentHouseParty == "Republican" & CC14_310d == 2

replace knowpartysen1 = 1 if CurrentSen1Party == "Democratic" & CC14_310b == 3
replace knowpartysen1 = 1 if CurrentSen1Party == "Republican" & CC14_310b == 2

replace knowpartysen2 = 1 if CurrentSen2Party == "Democratic" & CC14_310c == 3
replace knowpartysen2 = 1 if CurrentSen2Party == "Republican" & CC14_310c == 2

* Create additive political knowledge measure -- simply the number of questions correctly answered: zero to six *
gen knowledge = knowpartycontrolhouse+knowpartycontrolsenate+knowpartygov+knowpartyhouse+knowpartysen1+knowpartysen2
label var knowledge "Political knowledge" 
label define knowledge1 0 "zero questions correct" 1 "one question correct" 2 "two questions correct" 3 "three questions correct" 4 "four questions correct" 5 "five questions correct" 6 "six questions correct"
label values knowledge knowledge1

gen bypassobstructxknowledge = bypassobstruct*knowledge
label var bypassobstructxknowledge "Executive order treatment X Political knowledge"
gen loaneotreatxknowledge = loaneotreat*knowledge
label var loaneotreatxknowledge "Executive order treatment X Political knowledge"

logit bypasscongressbin bypassobstruct bypassobstructxknowledge gop5 dem5  male education age white knowledge, robust
outreg2 using sitable12, word label dec(2)  sortvar(studentloanbin loaneotreat loaneotreatxgop5 loaneotreatxdem5 loaneotreatxstudentloandebt gop5 dem5 male education age white approveobamabin studentloandebt) replace 2aster

* SI Table 13 -- is executive order treatment effect moderated by political knowledge *
logit studentloanbin loaneotreat loaneotreatxknowledge gop5 dem5 male education age white studentloandebt knowledge, robust
outreg2 using sitable13, word label dec(2)  sortvar(studentloanbin loaneotreat loaneotreatxgop5 loaneotreatxdem5 loaneotreatxstudentloandebt gop5 dem5 male education age white approveobamabin studentloandebt) replace 2aster

* Run Simulations to Create Data Needed to Create Figures *

* Simulations for Figure 1 *
use "cces2014.dta", clear

gen fig1mean = .
gen fig1upper = .
gen fig1lower = .
gen fig1label = _n
replace fig1label = . if fig1label > 6
label define fig1labels 1 "Ind X Control" 2 "Ind X Justification" 3 "GOP X Control" 4 "GOP X Justification" 5 "Dem X Control" 6 "Dem X Justification" 
label values fig1label fig1labels
label var fig1label ""

estsimp logit bypasscongressbin bypassobstruct bypassobstructxgop5 bypassobstructxdem5 gop5 dem5 male education age white
setx median
setx bypassobstruct 0 gop5 0 dem5 0
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 1
replace fig1lower = r(r2) if fig1label == 1 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 1
drop x preds0 preds1

setx bypassobstruct 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 2
replace fig1lower = r(r2) if fig1label == 2 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 2
drop x preds0 preds1 

setx bypassobstruct 0 gop5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 3
replace fig1lower = r(r2) if fig1label == 3 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 3
drop x preds0 preds1 

setx bypassobstruct 1 bypassobstructxgop5 1 gop5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 4
replace fig1lower = r(r2) if fig1label == 4 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 4
drop x preds0 preds1 

setx bypassobstruct 0 bypassobstructxgop5 0 gop5 0 dem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 5
replace fig1lower = r(r2) if fig1label == 5 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 5
drop x preds0 preds1 

setx bypassobstruct 1 bypassobstructxdem5 1 dem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 6
replace fig1lower = r(r2) if fig1label == 6 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 6
drop x preds0 preds1 
drop b1-b10

* The figures in the text were created using the data obtained from simulations using the method above. *
* The figures themselves were created using a graphic arts program, Kaleidagraph *
* Similar graphs can be created in STATA using eclplot *
* If you do not have the eclplot module installed, you will need to install it to create the actual figure. *
* To install enter "findit eclplot" in the command line *
* Note: As a reminder, the figures are created using data generated from simulations; as a result, each run will produce slightly different point estimates and confidence intervals *

eclplot fig1mean fig1lower fig1upper fig1label, ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1) ytitle(Pred. prob. of supporting unilateral action) xtitle("") xlabel(,angle(vertical))

* Simulations for Figure 2 *
use "yougovsurvey1.dta", clear
gen fig2mean = .
gen fig2upper = .
gen fig2lower = .
gen fig2label = _n
replace fig2label = . if fig2label > 7
label define fig2labels 1 "Foreign policy" 2 "Republican" 3 "Democrat" 4 "Male" 5 "Education" 6 "Age" 7 "Non-white"
label values fig2label fig2labels
label var fig2label ""

estsimp logit supportuabin foreign gop5 dem5 male age education white, robust
setx median
setx foreign 0 gop5 0 dem5 0
simqi, genpr(preds0 preds1)
egen baseline = mean(preds1)
drop preds0 preds1

setx foreign 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig2upper = r(r1) if fig2label == 1
replace fig2lower = r(r2) if fig2label == 1 
egen x = mean(preds1)
replace fig2mean = x if fig2label == 1
drop x preds0 preds1

setx foreign 0
setx gop5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig2upper = r(r1) if fig2label == 2
replace fig2lower = r(r2) if fig2label == 2 
egen x = mean(preds1)
replace fig2mean = x if fig2label == 2
drop x preds0 preds1

setx gop5 0
setx dem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig2upper = r(r1) if fig2label == 3
replace fig2lower = r(r2) if fig2label == 3 
egen x = mean(preds1)
replace fig2mean = x if fig2label == 3
drop x preds0 preds1

setx dem5 0
setx male 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig2upper = r(r1) if fig2label == 4
replace fig2lower = r(r2) if fig2label == 4 
egen x = mean(preds1)
replace fig2mean = x if fig2label == 4
drop x preds0 preds1

setx male 0
setx education 5
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig2upper = r(r1) if fig2label == 5
replace fig2lower = r(r2) if fig2label == 5 
egen x = mean(preds1)
replace fig2mean = x if fig2label == 5
drop x preds0 preds1

setx education median
setx age 84
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig2upper = r(r1) if fig2label == 6
replace fig2lower = r(r2) if fig2label == 6 
egen x = mean(preds1)
replace fig2mean = x if fig2label == 6
drop x preds0 preds1

setx age median
setx white 0
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig2upper = r(r1) if fig2label == 7
replace fig2lower = r(r2) if fig2label == 7 
egen x = mean(preds1)
replace fig2mean = x if fig2label == 7
drop x preds0 preds1

drop b1-b8

eclplot fig2mean fig2lower fig2upper fig2label, ylabel(.1 .2 .3 .4 .5 .6 .7 .8 .9) ytitle(Pred. prob. of supporting unilateral action) xtitle("") xlabel(1 2 3 4 5 6 7,angle(vertical)) yline(`=baseline[1]')

* Simulations for Figure 3 *
use "cces2014.dta", clear
gen fig3mean = .
gen fig3upper = .
gen fig3lower = .
gen fig3label = _n
replace fig3label = . if fig3label > 6
label define fig3labels 1 "GOP X Obama" 2 "GOP X Bush" 3 "Dem X Obama" 4 "Dem X Bush" 5 "Ind X Obama" 6 "Ind X Bush" 
label values fig3label fig3labels
label var fig3label ""


estsimp logit toofarterror bushtreat bushtreatxgop5 bushtreatxdem5 gop5 dem5 male education age white
setx median
setx bushtreat 0 gop5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 1
replace fig3lower = r(r2) if fig3label == 1 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 1
drop x preds0 preds1


setx bushtreat 1 bushtreatxgop5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 2
replace fig3lower = r(r2) if fig3label == 2 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 2
drop x preds0 preds1

setx gop5 0 dem5 1 bushtreat 0 bushtreatxgop5 0
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 3
replace fig3lower = r(r2) if fig3label == 3 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 3
drop x preds0 preds1

setx bushtreat 1 bushtreatxdem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 4
replace fig3lower = r(r2) if fig3label == 4 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 4
drop x preds0 preds1

setx bushtreat 0 bushtreatxdem5 0 gop5 0 dem5 0
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 5
replace fig3lower = r(r2) if fig3label == 5 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 5
drop x preds0 preds1

setx bushtreat 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 6
replace fig3lower = r(r2) if fig3label == 6 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 6
drop x preds0 preds1
drop b1-b10

eclplot fig3mean fig3lower fig3upper fig3label, ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8) ytitle(Pred. prob. of believing president went too far) xtitle("") xlabel(1 2 3 4 5 6,angle(vertical))


* Simulations for Figure 4 *
use "cces2014.dta", clear
gen fig4mean = .
gen fig4upper = .
gen fig4lower = .
gen fig4label = _n
replace fig4label = . if fig4label > 8
label define fig4labels 1 "EO treatment" 2 "Republican" 3 "Democrat" 4 "Male" 5 "Education" 6 "Age" 7 "Non-white" 8 "Student loan debt"
label values fig4label fig4labels
label var fig4label ""

estsimp logit studentloanbin loaneotreat gop5 dem5 male education age white studentloandebt
setx median
setx gop5 0 dem5 0 loaneotreat 0
simqi, genpr(preds0 preds1)
egen baseline = mean(preds1)
drop preds0 preds1

setx loaneotreat 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 1
replace fig4lower = r(r2) if fig4label == 1 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 1
drop x preds0 preds1

setx loaneotreat 0
setx gop5 1 
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 2
replace fig4lower = r(r2) if fig4label == 2 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 2
drop x preds0 preds1

setx gop5 0
setx dem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 3
replace fig4lower = r(r2) if fig4label == 3 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 3
drop x preds0 preds1

setx dem5 0
setx male 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 4
replace fig4lower = r(r2) if fig4label == 4 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 4
drop x preds0 preds1

setx male 0
setx education 5
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 5
replace fig4lower = r(r2) if fig4label == 5 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 5
drop x preds0 preds1

setx education median
setx age 84
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 6
replace fig4lower = r(r2) if fig4label == 6 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 6
drop x preds0 preds1

setx age median
setx white 0
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 7
replace fig4lower = r(r2) if fig4label == 7 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 7
drop x preds0 preds1

setx white 1
setx studentloandebt 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 8
replace fig4lower = r(r2) if fig4label == 8 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 8
drop x preds0 preds1
drop b1-b9

eclplot fig4mean fig4lower fig4upper fig4label, ylabel(.3 .4 .5 .6 .7 .8 .9 1) ytitle(Pred. prob. of supporting Obama) xtitle("") xlabel(1 2 3 4 5 6 7 8,angle(vertical)) yline(`=baseline[1]')

* Simulations for Figure 5 *
use "yougovsurvey2.dta", clear
gen fig5mean = .
gen fig5upper = .
gen fig5lower = .
gen fig5label = _n
replace fig5label = . if fig5label > 7
label define fig5labels 1 "EO treatment" 2 "Republican" 3 "Democrat" 4 "Male" 5 "Education" 6 "Age" 7 "Latino"
label values fig5label fig5labels
label var fig5label ""

estsimp logit immigrationbin eotreat gop5 dem5 male education age white latino, robust
setx median
setx gop5 0 dem5 0 eotreat 0
simqi, genpr(preds0 preds1)
egen baseline = mean(preds1)
drop preds0 preds1

setx eotreat 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 1
replace fig5lower = r(r2) if fig5label == 1 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 1
drop x preds0 preds1

setx eotreat 0
setx gop5 1 
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 2
replace fig5lower = r(r2) if fig5label == 2 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 2
drop x preds0 preds1

setx gop5 0
setx dem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 3
replace fig5lower = r(r2) if fig5label == 3 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 3
drop x preds0 preds1

setx dem5 0
setx male 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 4
replace fig5lower = r(r2) if fig5label == 4 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 4
drop x preds0 preds1

setx male 0
setx education 5
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 5
replace fig5lower = r(r2) if fig5label == 5 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 5
drop x preds0 preds1

setx education median
setx age 84
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 6
replace fig5lower = r(r2) if fig5label == 6 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 6
drop x preds0 preds1

setx age median
setx white 0
setx latino 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 7
replace fig5lower = r(r2) if fig5label == 7 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 7
drop x preds0 preds1

drop b1-b9

eclplot fig5mean fig5lower fig5upper fig5label, ylabel(0 .1 .2 .3 .4 .5 .6 .7) ytitle(Pred. prob. of supporting Obama) xtitle("") xlabel(1 2 3 4 5 6 7,angle(vertical)) yline(`=baseline[1]')
