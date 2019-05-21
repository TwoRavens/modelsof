* Please change the directory in STATA to wherever you have saved the replication data files *

set more off

* Table 1 *
use "ck_cces2014.dta", replace
logit epabin epaconst epapolicy gop5 dem5 male education age white globalwarmbin, robust
outreg2 using table1, word label sortvar(epaconst epapolicy     epaconstxglobalwarmbin epapolicyxglobalwarmbin gop5 dem5 male education age white globalwarmbin) dec(3) 2aster replace
logit epabin epaconst  epapolicy epaconstxglobalwarmbin epapolicyxglobalwarmbin gop5 dem5 male education age white globalwarmbin, robust
outreg2 using table1, word label sortvar(epaconst epapolicy    epaconstxglobalwarmbin epapolicyxglobalwarmbin gop5 dem5 male education age white globalwarmbin) dec(3) 2aster append

* Create measure of political knowledge *
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

gen epaconstxknowledge = epaconst*knowledge
label var epaconstxknowledge "Constitutional objections X Knowledge"
gen epapolicyxknowledge = epapolicy*knowledge
label var epapolicyxknowledge "Policy criticism X Knowledge"

logit epabin epaconst  epapolicy epaconstxknowledge epapolicyxknowledge gop5 dem5 male education age white globalwarmbin knowledge, robust
outreg2 using table1, word label sortvar(epaconst epapolicy    epaconstxglobalwarmbin epapolicyxglobalwarmbin epaconstxknowledge epapolicyxknowledge gop5 dem5 male education age white globalwarmbin knowledge) dec(3) 2aster append


* Table 2 *
use "ck_yougov1.dta", replace
logit isisbin isiscongopp gop5 dem5 male education age white, robust
outreg2 using table2, word label sortvar(isiscongopp loanscongopp gop5 dem5 male education age white) dec(3) 2aster replace
logit loansbin loanscongopp gop5 dem5 male education age white, robust
outreg2 using table2, word label sortvar(isiscongopp loanscongopp gop5 dem5 male education age white) dec(3) 2aster append

* Table 3 *
use "ck_yougov2.dta", replace
logit isissupport  isiscongshort isislawprof isismedia isiscongboth dem5 gop5 education age white male, robust
outreg2 using table3, word label replace 2aster dec(3)

* Table 4 *
use "ck_yougov3.dta", replace
logit epasuppbin epagop epadem gop5 dem5 male education age white, robust
outreg2 using table4, word label sortvar(epagop  epadem epagopxdem5 epademxdem5 gop5 dem5 male education age white) replace dec(3) 2aster 


* Create Figures *

* The figures in the text were created using the data obtained from simulations using Clarify. *
* If you do not have Clarify installed, you will need to do so. *
* To install Clarify, enter "findit clarify" in the command line. *
* The figures themselves were created using a graphic arts program, Kaleidagraph *
* Similar graphs can be created in STATA using eclplot *
* If you do not have the eclplot module installed, you will need to install it to create the actual figure. *
* To install enter "findit eclplot" in the command line. *
* Note: As a reminder, the figures are created using data generated from simulations; as a result, each run will produce slightly different point estimates and confidence intervals. *

* Figure 1 *
use "ck_cces2014.dta", replace

gen fig1mean = .
gen fig1upper = .
gen fig1lower = .
gen fig1label = _n
replace fig1label = . if fig1label > 9
label define fig1labels 1 "Constitutional objections" 2 "Policy criticism" 3 "Republican" 4 "Democrat" 5 "Male" 6 "Education" 7 "Age" 8 "Non-white" 9 "Global warming"
label values fig1label fig1labels
label var fig1label ""

estsimp logit epabin epaconst epapolicy gop5 dem5 male education age white globalwarmbin, robust
setx median
setx epaconst 0 epapolicy 0 gop5 0 dem5 0 globalwarmbin 0
simqi, genpr(preds0 preds1)
egen baseline = mean(preds1)
drop preds0 preds1

setx epaconst 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 1
replace fig1lower = r(r2) if fig1label == 1 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 1
drop x preds0 preds1

setx epaconst 0 epapolicy 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 2
replace fig1lower = r(r2) if fig1label == 2 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 2
drop x preds0 preds1

setx epapolicy 0 gop5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 3
replace fig1lower = r(r2) if fig1label == 3 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 3
drop x preds0 preds1

setx gop5 0 dem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 4
replace fig1lower = r(r2) if fig1label == 4 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 4
drop x preds0 preds1

setx dem5 0
setx male 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 5
replace fig1lower = r(r2) if fig1label == 5 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 5
drop x preds0 preds1

setx male 0
setx education 5
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 6
replace fig1lower = r(r2) if fig1label == 6 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 6
drop x preds0 preds1

setx education median
setx age 84
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 7
replace fig1lower = r(r2) if fig1label == 7 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 7
drop x preds0 preds1

setx age median
setx white 0
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 8
replace fig1lower = r(r2) if fig1label == 8
egen x = mean(preds1)
replace fig1mean = x if fig1label == 8
drop x preds0 preds1

setx white median
setx globalwarmbin 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 9
replace fig1lower = r(r2) if fig1label == 9
egen x = mean(preds1)
replace fig1mean = x if fig1label == 9
drop x preds0 preds1

drop b1-b10

eclplot fig1mean fig1lower fig1upper fig1label, ylabel(.1 .2 .3 .4 .5 .6 .7 .8 .9) ytitle(Pred. prob. of supporting unilateral action) xtitle("") xlabel(1 2 3 4 5 6 7 8 9,angle(vertical)) yline(`=baseline[1]') graphregion(fcolor(white))  ciopts(blcolor(black)) estopts(mcolor(black) msymbol(circle))

* Figure 2 *
use "ck_yougov1.dta", replace

gen fig2mean = .
gen fig2upper = .
gen fig2lower = .
gen fig2label = _n
replace fig2label = . if fig2label > 7
label define fig2labels 1 "Constitutional objections" 2 "Republican" 3 "Democrat" 4 "Male" 5 "Education" 6 "Age" 7 "Non-white"
label values fig2label fig2labels
label var fig2label ""

estsimp logit isisbin isiscongopp gop5 dem5 male education age white, robust
setx median
setx isiscongopp 0 gop5 0 dem5 0 
simqi, genpr(preds0 preds1)
egen baseline = mean(preds1)
drop preds0 preds1

setx isiscongopp 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig2upper = r(r1) if fig2label == 1
replace fig2lower = r(r2) if fig2label == 1 
egen x = mean(preds1)
replace fig2mean = x if fig2label == 1
drop x preds0 preds1

setx isiscongopp 0 gop5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig2upper = r(r1) if fig2label == 2
replace fig2lower = r(r2) if fig2label == 2 
egen x = mean(preds1)
replace fig2mean = x if fig2label == 2
drop x preds0 preds1

setx gop5 0 dem5 1
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
setx age 79
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

eclplot fig2mean fig2lower fig2upper fig2label, ylabel(.1 .2 .3 .4 .5 .6 .7 .8 .9) ytitle(Pred. prob. of supporting unilateral action) xtitle("") xlabel(1 2 3 4 5 6 7,angle(vertical)) yline(`=baseline[1]') graphregion(fcolor(white))  ciopts(blcolor(black)) estopts(mcolor(black) msymbol(circle))

* Figure 3 *
use "ck_yougov1.dta", replace

gen fig3mean = .
gen fig3upper = .
gen fig3lower = .
gen fig3label = _n
replace fig3label = . if fig3label > 7
label define fig3labels 1 "Constitutional objections" 2 "Republican" 3 "Democrat" 4 "Male" 5 "Education" 6 "Age" 7 "Non-white"
label values fig3label fig3labels
label var fig3label ""

estsimp logit loansbin loanscongopp gop5 dem5 male education age white, robust
setx median
setx loanscongopp 0 gop5 0 dem5 0 
simqi, genpr(preds0 preds1)
egen baseline = mean(preds1)
drop preds0 preds1

setx loanscongopp 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 1
replace fig3lower = r(r2) if fig3label == 1 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 1
drop x preds0 preds1

setx loanscongopp 0 gop5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 2
replace fig3lower = r(r2) if fig3label == 2 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 2
drop x preds0 preds1

setx gop5 0 dem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 3
replace fig3lower = r(r2) if fig3label == 3 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 3
drop x preds0 preds1

setx dem5 0
setx male 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 4
replace fig3lower = r(r2) if fig3label == 4 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 4
drop x preds0 preds1

setx male 0
setx education 5
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 5
replace fig3lower = r(r2) if fig3label == 5 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 5
drop x preds0 preds1

setx education median
setx age 79
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 6
replace fig3lower = r(r2) if fig3label == 6 
egen x = mean(preds1)
replace fig3mean = x if fig3label == 6
drop x preds0 preds1

setx age median
setx white 0
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig3upper = r(r1) if fig3label == 7
replace fig3lower = r(r2) if fig3label == 7
egen x = mean(preds1)
replace fig3mean = x if fig3label == 7
drop x preds0 preds1


drop b1-b8

eclplot fig3mean fig3lower fig3upper fig3label, ylabel(.1 .2 .3 .4 .5 .6 .7 .8 .9) ytitle(Pred. prob. of supporting unilateral action) xtitle("") xlabel(1 2 3 4 5 6 7,angle(vertical)) yline(`=baseline[1]') graphregion(fcolor(white))  ciopts(blcolor(black)) estopts(mcolor(black) msymbol(circle))

* Figure 4 *
use "ck_yougov2.dta", replace

gen fig4mean = .
gen fig4upper = .
gen fig4lower = .
gen fig4label = _n
replace fig4label = . if fig4label > 10
label define fig4labels 1 "Congress" 2 "Law professors" 3 "Media" 4 "Congress expanded" 5 "Republican" 6 "Democrat" 7 "Male" 8 "Education" 9 "Age" 10 "Non-white"
label values fig4label fig4labels
label var fig4label ""

estsimp logit isissupport  isiscongshort isislawprof isismedia isiscongboth dem5 gop5 education age white male
setx median
setx isiscongshort 0 isislawprof 0 isismedia 0 isiscongboth 0 gop5 0 dem5 0
simqi, genpr(preds0 preds1)
egen baseline = mean(preds1)
drop preds0 preds1

setx isiscongshort 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 1
replace fig4lower = r(r2) if fig4label == 1 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 1
drop x preds0 preds1

setx isiscongshort 0 isislawprof 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 2
replace fig4lower = r(r2) if fig4label == 2 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 2
drop x preds0 preds1

setx isislawprof 0 isismedia 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 3
replace fig4lower = r(r2) if fig4label == 3 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 3
drop x preds0 preds1

setx isismedia 0 isiscongboth 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 4
replace fig4lower = r(r2) if fig4label == 4 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 4
drop x preds0 preds1

setx isiscongboth 0 gop5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 5
replace fig4lower = r(r2) if fig4label == 5 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 5
drop x preds0 preds1

setx gop5 0 dem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 6
replace fig4lower = r(r2) if fig4label == 6 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 6
drop x preds0 preds1

setx dem5 0
setx male 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 7
replace fig4lower = r(r2) if fig4label == 7 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 7
drop x preds0 preds1

setx male 0
setx education 5
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 8
replace fig4lower = r(r2) if fig4label == 8 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 8
drop x preds0 preds1

setx education median
setx age 80
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 9
replace fig4lower = r(r2) if fig4label == 9 
egen x = mean(preds1)
replace fig4mean = x if fig4label == 9
drop x preds0 preds1

setx age median
setx white 0
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig4upper = r(r1) if fig4label == 10
replace fig4lower = r(r2) if fig4label == 10
egen x = mean(preds1)
replace fig4mean = x if fig4label == 10
drop x preds0 preds1

drop b1-b11

eclplot fig4mean fig4lower fig4upper fig4label, ylabel(.1 .2 .3 .4 .5 .6 .7 .8 .9) ytitle(Pred. prob. of supporting unilateral action) xtitle("") xlabel(1 2 3 4 5 6 7 8 9 10,angle(vertical)) yline(`=baseline[1]') graphregion(fcolor(white))  ciopts(blcolor(black)) estopts(mcolor(black) msymbol(circle))

* Figure 5 *
use "ck_yougov3.dta", replace

gen fig5mean = .
gen fig5upper = .
gen fig5lower = .
gen fig5label = _n
replace fig5label = . if fig5label > 8
label define fig5labels 1 "GOP challenge" 2 "Dem challenge" 3 "Republican" 4 "Democrat" 5 "Male" 6 "Education" 7 "Age" 8 "Non-white"
label values fig5label fig5labels
label var fig5label ""

estsimp logit epasuppbin epagop epadem gop5 dem5 male education age white
setx median
setx epagop 0 epadem 0 gop5 0 dem5 0
simqi, genpr(preds0 preds1)
egen baseline = mean(preds1)
drop preds0 preds1

setx epagop 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 1
replace fig5lower = r(r2) if fig5label == 1 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 1
drop x preds0 preds1

setx epagop 0 epadem 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 2
replace fig5lower = r(r2) if fig5label == 2 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 2
drop x preds0 preds1

setx epadem 0 gop5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 3
replace fig5lower = r(r2) if fig5label == 3 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 3
drop x preds0 preds1

setx gop5 0 dem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 4
replace fig5lower = r(r2) if fig5label == 4 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 4
drop x preds0 preds1

setx dem5 0
setx male 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 5
replace fig5lower = r(r2) if fig5label == 5 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 5
drop x preds0 preds1

setx male 0
setx education 5
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 6
replace fig5lower = r(r2) if fig5label == 6 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 6
drop x preds0 preds1

setx education median
setx age 80
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 7
replace fig5lower = r(r2) if fig5label == 7 
egen x = mean(preds1)
replace fig5mean = x if fig5label == 7
drop x preds0 preds1

setx age median
setx white 0
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig5upper = r(r1) if fig5label == 8
replace fig5lower = r(r2) if fig5label == 8
egen x = mean(preds1)
replace fig5mean = x if fig5label == 8
drop x preds0 preds1

drop b1-b9

eclplot fig5mean fig5lower fig5upper fig5label, ylabel(.1 .2 .3 .4 .5 .6 .7 .8 .9 1) xscale(range(.75 8.25)) ytitle("Predicted probability of supporting executive action" " ") xtitle("") xlabel(1 2 3 4 5 6 7 8,angle(vertical)) yline(`=baseline[1]')  graphregion(fcolor(white))  ciopts(blcolor(black)) estopts(mcolor(black) msymbol(circle))

* SI Figure 1 *
use "ck_cces2014.dta", replace

gen fig1mean = .
gen fig1upper = .
gen fig1lower = .
gen fig1label = _n
replace fig1label = . if fig1label > 9
label define fig1labels 1 "Constitutional objections" 2 "Policy criticism" 3 "Republican" 4 "Democrat" 5 "Male" 6 "Education" 7 "Age" 8 "White" 9 "No global warming"
label values fig1label fig1labels
label var fig1label ""

estsimp logit epabin epaconst epapolicy gop5 dem5 male education age white globalwarmbin, robust
setx median
setx epaconst 0 epapolicy 0 gop5 0 dem5 0 globalwarmbin 1
simqi, genpr(preds0 preds1)
egen baseline = mean(preds1)
drop preds0 preds1

setx epaconst 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 1
replace fig1lower = r(r2) if fig1label == 1 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 1
drop x preds0 preds1

setx epaconst 0 epapolicy 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 2
replace fig1lower = r(r2) if fig1label == 2 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 2
drop x preds0 preds1

setx epapolicy 0 gop5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 3
replace fig1lower = r(r2) if fig1label == 3 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 3
drop x preds0 preds1

setx gop5 0 dem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 4
replace fig1lower = r(r2) if fig1label == 4 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 4
drop x preds0 preds1

setx dem5 0
setx male 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 5
replace fig1lower = r(r2) if fig1label == 5 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 5
drop x preds0 preds1

setx male 0
setx education 5
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 6
replace fig1lower = r(r2) if fig1label == 6 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 6
drop x preds0 preds1

setx education median
setx age 84
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 7
replace fig1lower = r(r2) if fig1label == 7 
egen x = mean(preds1)
replace fig1mean = x if fig1label == 7
drop x preds0 preds1

setx age median
setx white 0
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 8
replace fig1lower = r(r2) if fig1label == 8
egen x = mean(preds1)
replace fig1mean = x if fig1label == 8
drop x preds0 preds1

setx white median
setx globalwarmbin 0
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace fig1upper = r(r1) if fig1label == 9
replace fig1lower = r(r2) if fig1label == 9
egen x = mean(preds1)
replace fig1mean = x if fig1label == 9
drop x preds0 preds1

drop b1-b10

eclplot fig1mean fig1lower fig1upper fig1label, ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1) ytitle(Pred. prob. of supporting unilateral action) xtitle("") xlabel(1 2 3 4 5 6 7 8 9,angle(vertical)) yline(`=baseline[1]')

* SI Figure 2 *
use "ck_cces2014.dta", replace

* Create measure of political knowledge *
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

gen epaconstxknowledge = epaconst*knowledge
label var epaconstxknowledge "Constitutional objections X Knowledge"
gen epapolicyxknowledge = epapolicy*knowledge
label var epapolicyxknowledge "Policy criticism X Knowledge"

* plot interaction effects *
* label values for graphing  
gen epaconstd = epaconst
label var epaconstd "Constitutional objections" 
label define epaconstd 0 "Control" 1 "Treatment"
gen epapolicyd = epapolicy
label var epapolicyd "Policy criticism" 
label define epapolicyd 0 "Control" 1 "Treatment"
gen knowledged = knowledge
label var knowledged "Political knowledge" 
label define knowledged 0 "Low" 1 "1" 2 "2" 3 "Moderate" 4 "4" 5 "5" 6 "High"

* margins of knowledge interactions 
logit epabin i.epaconstd##c.knowledged i.epapolicyd##c.knowledged gop5 dem5 male education age white globalwarmbin, robust
sum epabin epaconstd epapolicyd knowledged gop5 dem5 male education age white globalwarmbin
* policy interaction graph 
margins, at(knowledged=(0(1)6) epapolicyd=(0 1) epaconstd=0 gop5=0 dem5=0 male=1 white=1 globalwarmbin=0 education=3 age=50) vsquish 
marginsplot, x(knowledged)  title("") yti("Pr(Support Obama on EPA)") legend(order(1 "Control" 2 "Treatment") ring(0) pos(2) cols(1)) scheme(s1mono) ci1opts(fintensity(100)) level(95) 
* constitutional interaction graph 
margins, at(knowledged=(0(1)6) epaconstd=(0 1) epapolicyd=0 gop5=0 dem5=0 male=1 white=1 globalwarmbin=0 education=3 age=50) vsquish
marginsplot, x(knowledged)  title("") yti("Pr(Support Obama on EPA)") legend(order(1 "Control" 2 "Treatment") ring(0) pos(2) cols(1)) scheme(s1mono) ci1opts(fintensity(20)) level(95) 


* SI Figure 3 *
use "ck_yougov3.dta", replace

gen sifig2mean = .
gen sifig2upper = .
gen sifig2lower = .
gen sifig2label = _n
replace sifig2label = . if sifig2label > 4
label define sifig2labels 1 "GOP challenge" 2 "Democratic challenge" 3 "GOP challenge X Democrat" 4 "Dem challenge X Democrat" 
label values sifig2label sifig2labels
label var sifig2label ""

estsimp logit epasuppbin epagop epagopxdem5 epadem epademxdem5 gop5 dem5 male education age white
setx median
setx epagop 0 epagopxdem5 0 epadem 0 epademxdem5 0 gop5 0 dem5 0
simqi, genpr(preds0 preds1)
egen baseline1 = mean(preds1)
drop preds0 preds1

setx median
setx epagop 0 epagopxdem5 0 epadem 0 epademxdem5 0 gop5 0 dem5 1
simqi, genpr(preds0 preds1)
egen baseline2 = mean(preds1)
drop preds0 preds1

setx median
setx epagop 0 epagopxdem5 0 epadem 0 epademxdem5 0 gop5 0 dem5 0
setx epagop 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace sifig2upper = r(r1) if sifig2label == 1
replace sifig2upper = sifig2upper-baseline1
replace sifig2lower = r(r2) if sifig2label == 1 
replace sifig2lower = sifig2lower-baseline1
egen x = mean(preds1)
replace sifig2mean = x if sifig2label == 1
replace sifig2mean = sifig2mean-baseline1
drop x preds0 preds1

setx median
setx epagop 0 epagopxdem5 0 epadem 0 epademxdem5 0 gop5 0 dem5 1
setx epagop 1 epagopxdem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace sifig2upper = r(r1) if sifig2label == 3
replace sifig2upper = sifig2upper-baseline2 if sifig2label == 3
replace sifig2lower = r(r2) if sifig2label == 3 
replace sifig2lower = sifig2lower-baseline2 if sifig2label == 3
egen x = mean(preds1)
replace sifig2mean = x if sifig2label == 3
replace sifig2mean = sifig2mean-baseline2 if sifig2label == 3
drop x preds0 preds1

setx median
setx epagop 0 epagopxdem5 0 epadem 0 epademxdem5 0 gop5 0 dem5 0
setx epadem 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace sifig2upper = r(r1) if sifig2label == 2
replace sifig2upper = sifig2upper-baseline1 if sifig2label == 2
replace sifig2lower = r(r2) if sifig2label == 2 
replace sifig2lower = sifig2lower-baseline1 if sifig2label == 2
egen x = mean(preds1)
replace sifig2mean = x if sifig2label == 2
replace sifig2mean = sifig2mean-baseline1 if sifig2label == 2
drop x preds0 preds1

setx median
setx epagop 0 epagopxdem5 0 epadem 0 epademxdem5 0 gop5 0 dem5 1
setx epadem 1 epademxdem5 1
simqi, genpr(preds0 preds1)
_pctile preds1, p(2.5,97.5)
replace sifig2upper = r(r1) if sifig2label == 4
replace sifig2upper = sifig2upper-baseline2 if sifig2label == 4
replace sifig2lower = r(r2) if sifig2label == 4 
replace sifig2lower = sifig2lower-baseline2 if sifig2label == 4
egen x = mean(preds1)
replace sifig2mean = x if sifig2label == 4
replace sifig2mean = sifig2mean-baseline2 if sifig2label == 4
drop x preds0 preds1

drop b1-b11

eclplot sifig2mean sifig2lower sifig2upper sifig2label, xlabel(-.4 -.3 -.2 -.1 0 .1) yscale(range(.75 4.25)) xtitle(" " "Change in predicted probability of support") ytitle("") ylabel(1 2 3 4,angle(horizontal)) xline(0)  graphregion(fcolor(white))  ciopts(blcolor(black)) estopts(mcolor(black) msymbol(circle)) horizontal


* SI Table 1 -- sample characteristics *
use "ck_cces2014.dta", replace
sum gop3 gop5 dem3 dem5 male age white black latino 
sum education, detail
gen income = faminc
recode income (98=.) (99=.) (97=.)
sum income, detail

use "ck_yougov3.dta", replace
sum gop3 gop5 dem3 dem5 male age white black latino 
sum education, detail
sum faminc, detail

use "ck_yougov1.dta", replace
sum gop3 gop5 dem3 dem5 male age white black latino 
sum education, detail
sum faminc, detail

use "ck_yougov2.dta", replace
sum gop3 gop5 dem3 dem5 male age white black latino 
sum education, detail
sum faminc, detail

* SI Table 2 *
use "ck_cces2014.dta", replace
logit epabin epaconst epapolicy gop5 dem5 male education age white, robust
outreg2 using sitable2, word label sortvar(epaconst epapolicy gop5 dem5 male education age white globalwarmbin) dec(3) 2aster replace

* SI Table 3 *
use "ck_cces2014.dta", replace
gen approveobamabin = 0
replace approveobamabin = 1 if CC14_308a == 1
replace approveobamabin = 1 if CC14_308a == 2
replace approveobamabin = . if CC14_308a == 8
replace approveobamabin = . if CC14_308a == 5

logit epabin epaconst epapolicy gop5 dem5 male education age white globalwarmbin approveobamabin, robust
outreg2 using sitable3, word label sortvar(epaconst epapolicy     epaconstxglobalwarmbin epapolicyxglobalwarmbin gop5 dem5 male education age white globalwarmbin approveobamabin) dec(3) 2aster replace
logit epabin epaconst  epapolicy epaconstxglobalwarmbin epapolicyxglobalwarmbin gop5 dem5 male education age white globalwarmbin approveobamabin, robust
outreg2 using sitable3, word label sortvar(epaconst epapolicy    epaconstxglobalwarmbin epapolicyxglobalwarmbin gop5 dem5 male education age white globalwarmbin approveobamabin) dec(3) 2aster append


* Create measure of political knowledge *
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

gen epaconstxknowledge = epaconst*knowledge
label var epaconstxknowledge "Constitutional objections X Knowledge"
gen epapolicyxknowledge = epapolicy*knowledge
label var epapolicyxknowledge "Policy criticism X Knowledge"

logit epabin epaconst  epapolicy epaconstxknowledge epapolicyxknowledge gop5 dem5 male education age white globalwarmbin approveobamabin knowledge, robust
outreg2 using sitable3, word label sortvar(epaconst epapolicy    epaconstxglobalwarmbin epapolicyxglobalwarmbin epaconstxknowledge epapolicyxknowledge  gop5 dem5 male education age white globalwarmbin approveobamabin) dec(3) 2aster append


* SI Table 4 *
use "ck_cces2014.dta", replace
ologit epa epaconst epapolicy gop5 dem5 male education age white globalwarmbin, robust
outreg2 using sitable4, word label sortvar(epaconst epapolicy     epaconstxglobalwarmbin epapolicyxglobalwarmbin gop5 dem5 male education age white globalwarmbin) dec(3) 2aster replace
ologit epa epaconst  epapolicy epaconstxglobalwarmbin epapolicyxglobalwarmbin gop5 dem5 male education age white globalwarmbin, robust
outreg2 using sitable4, word label sortvar(epaconst epapolicy    epaconstxglobalwarmbin epapolicyxglobalwarmbin gop5 dem5 male education age white globalwarmbin) dec(3) 2aster append

* Create measure of political knowledge *
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

gen epaconstxknowledge = epaconst*knowledge
label var epaconstxknowledge "Constitutional objections X Knowledge"
gen epapolicyxknowledge = epapolicy*knowledge
label var epapolicyxknowledge "Policy criticism X Knowledge"

ologit epa epaconst  epapolicy epaconstxknowledge epapolicyxknowledge gop5 dem5 male education age white globalwarmbin knowledge, robust
outreg2 using sitable4, word label sortvar(epaconst epapolicy    epaconstxglobalwarmbin epapolicyxglobalwarmbin epaconstxknowledge epapolicyxknowledge  gop5 dem5 male education age white globalwarmbin approveobamabin) dec(3) 2aster append


* SI Table 5 *
use "ck_yougov1.dta", replace
ologit isis isiscongopp gop5 dem5 male education age white, robust
outreg2 using sitable5, word label sortvar(isiscongopp loanscongopp gop5 dem5 male education age white) dec(3) 2aster replace
ologit loans loanscongopp gop5 dem5 male education age white, robust
outreg2 using sitable5, word label sortvar(isiscongopp loanscongopp gop5 dem5 male education age white) dec(3) 2aster append

* SI Table 6 *
use "ck_yougov2.dta", replace
ologit isis  isiscongshort isislawprof isismedia isiscongboth dem5 gop5 education age white male, robust
outreg2 using sitable6, word label replace 2aster dec(3)

* SI Table 7 *
use "ck_yougov3.dta", replace
ologit epasupp epagop epadem gop5 dem5 male education age white, robust
outreg2 using sitable7, word label sortvar(epagop  epadem epagopxdem5 epademxdem5 gop5 dem5 male education age white) replace dec(3) 2aster 

* SI Table 8 *
use "ck_cces2014.dta", replace
set more off 

* Create measure of political knowledge *
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

gen epaconstxknowledge = epaconst*knowledge
label var epaconstxknowledge "Constitutional objections X Knowledge"
gen epapolicyxknowledge = epapolicy*knowledge
label var epapolicyxknowledge "Policy criticism X Knowledge"

logit epabin epaconst  epapolicy epaconstxknowledge epapolicyxknowledge gop5 dem5 male education age white globalwarmbin knowledge, robust
outreg2 using sitable8, word label  dec(3)  replace  2aster 

* SI Table 9 *
use "ck_yougov3.dta", replace
logit epasuppbin epagop epagopxdem5 epadem epademxdem5 gop5 dem5 male education age white, robust
outreg2 using sitable9, word label sortvar(epagop  epadem epagopxdem5 epademxdem5 gop5 dem5 male education age white) replace dec(3) 2aster 

