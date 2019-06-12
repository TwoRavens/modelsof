/*******************************
* analyzeTimeInconsistency.do
*
* Analyze results from a 2014 CCES module with
* basic questions on time inconsistency.
*
* Seth Hill, June 2018
*******************************/
clear
set more off
* Toggle on additional specification with additional controls.
local extraControls = 1

*Data from 2014 CCES, pooled from two team contents.
use "CCESTurnoutData.dta", clear

*Base rate.
tab hyperb_disc [aweight=weight]
*By education.
tab educ voted_vv [aweight=weight], row

*******
*Relationship of present bias to income, education, and stock ownership.
*******
tab investor hyperb_disc [aweight=weight], col
reg hyperb_disc faminc [aweight=weight] if faminc < 97
**Each category of income decreases prob present bias by 0.5 percent. With 16 categories, going from lowes to highest family income implies 8 percentage point diff.
reg hyperb_disc educ [aweight=weight]
**Each category of education decreases prob present bias by 2.1 percent.

*******
*Relationship of present bias to other cognitive bias: over-reporting turnout and
*mathematical aptitude.
*******
qui gen over_report = (voted_self_rep == 1 & voted_vv == 0)|(voted_self_rep == 1 & voted_vv == .)
label var over_report "Reported voting in 2014 but no validated record"
tab over_report voted_vv, miss
tab over_report hyperb_disc [aweight=weight], col
* Only among those successfully matched to voter records.
tab over_report hyperb_disc if voted_vv != . [aweight=weight], col

*******
*Relationship of present bias to validated turnout.
*******
local tabl "TimeIncon_Table01.tex"
local tabl2 "TimeIncon_Table01-probit.tex"
label var hyperb_disc "Present biased (1=yes,0=no)"
*Validated general.
*Without controls.
reg voted_vv hyperb_disc [aweight=weight]
 outreg2 hyperb_disc using "`tabl'", replace tex(fragment) ctitle("General") addtext("Demographic controls","No") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
probit voted_vv hyperb_disc [pweight=weight]
 outreg2 hyperb_disc using "`tabl2'", replace tex(fragment) ctitle("General") addtext("Demographic controls","No") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
*With SES controls.
xi: reg voted_vv hyperb_disc i.educ i.faminc i.agedec i.race [aweight=weight]
 outreg2 hyperb_disc using "`tabl'", append tex(fragment) ctitle("General") addtext("Demographic controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
xi: probit voted_vv hyperb_disc i.educ i.faminc i.agedec i.race [pweight=weight]
 outreg2 hyperb_disc using "`tabl2'", append tex(fragment) ctitle("General") addtext("Demographic controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
if (`extraControls') {
  xi: reg voted_vv hyperb_disc i.educ i.faminc i.agedec i.race i.pid_strength i.ideo5 over_report [aweight=weight]
   outreg2 hyperb_disc using "`tabl'", append tex(fragment) ctitle("General") addtext("Demographic controls","Yes","Additional controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
  xi: probit voted_vv hyperb_disc i.educ i.faminc i.agedec i.race i.pid_strength i.ideo5 over_report [pweight=weight]
   outreg2 hyperb_disc using "`tabl2'", append tex(fragment) ctitle("General") addtext("Demographic controls","Yes","Additional controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
}

*Validated primary.
*Without controls.
reg pvoted_vv hyperb_disc [aweight=weight]
 outreg2 hyperb_disc using "`tabl'", append tex(fragment) ctitle("Primary") addtext("Demographic controls","No") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
probit pvoted_vv hyperb_disc [pweight=weight]
 outreg2 hyperb_disc using "`tabl2'", append tex(fragment) ctitle("Primary") addtext("Demographic controls","No") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
*With SES controls.
xi: reg pvoted_vv hyperb_disc i.educ i.faminc i.agedec [aweight=weight]
 outreg2 hyperb_disc using "`tabl'", append tex(fragment) ctitle("Primary") addtext("Demographic controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
xi: probit pvoted_vv hyperb_disc i.educ i.faminc i.agedec [pweight=weight]
 outreg2 hyperb_disc using "`tabl2'", append tex(fragment) ctitle("Primary") addtext("Demographic controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
if (`extraControls') {
  xi: reg pvoted_vv hyperb_disc i.educ i.faminc i.agedec i.race i.pid_strength i.ideo5 over_report [aweight=weight]
   outreg2 hyperb_disc using "`tabl'", append tex(fragment) ctitle("Primary") addtext("Demographic controls","Yes","Additional controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
  xi: probit pvoted_vv hyperb_disc i.educ i.faminc i.agedec i.race i.pid_strength i.ideo5 over_report [pweight=weight]
   outreg2 hyperb_disc using "`tabl2'", append tex(fragment) ctitle("Primary") addtext("Demographic controls","Yes","Additional controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
}

*******
*Relationship of present bias to self-reported turnout.
*******
local tabl "TimeIncon_TableA01.tex"
local tabl2 "TimeIncon_TableA01-probit.tex"
label var hyperb_disc "Present biased (1=yes,0=no)"
*Without controls.
reg voted_self_rep hyperb_disc [aweight=weight]
 outreg2 hyperb_disc using "`tabl'", replace tex(fragment) ctitle("Self-report") addtext("Demographic controls","No") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
probit voted_self_rep hyperb_disc [pweight=weight]
 outreg2 hyperb_disc using "`tabl2'", replace tex(fragment) ctitle("Self-report") addtext("Demographic controls","No") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
*With SES controls.
xi: reg voted_self_rep hyperb_disc i.educ i.faminc i.agedec [aweight=weight]
 outreg2 hyperb_disc using "`tabl'", append tex(fragment) ctitle("Self-report") addtext("Demographic controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
xi: probit voted_self_rep hyperb_disc i.educ i.faminc i.agedec [pweight=weight]
 outreg2 hyperb_disc using "`tabl2'", append tex(fragment) ctitle("Self-report") addtext("Demographic controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
if (`extraControls') {
  xi: reg voted_self_rep hyperb_disc i.educ i.faminc i.agedec i.race i.pid_strength i.ideo5 over_report [aweight=weight]
   outreg2 hyperb_disc using "`tabl'", append tex(fragment) ctitle("Self-report") addtext("Demographic controls","Yes","Additional controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
  xi: probit voted_self_rep hyperb_disc i.educ i.faminc i.agedec i.race i.pid_strength i.ideo5 over_report [pweight=weight]
   outreg2 hyperb_disc using "`tabl2'", append tex(fragment) ctitle("Self-report") addtext("Demographic controls","Yes","Additional controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
}


*******
*Following through.
*******
*Basic relationship.
tab CC354 [aweight=weight]
bys hyperb_disc: tab voted_vv CC354 [aweight=weight], col
gen followed_through = voted_vv if CC354 == 1
replace followed_through = . if voted_vv == . | CC354 == .
label var followed_through "Followed through on intention to vote"
tab followed_through
*Relationship to present bias.
tab followed_through hyperb_disc [aweight=weight], col

*Does present bias influence reported intention to vote?
tab CC354 hyperb_disc [aweight=weight], col

*Turnout among those who definitely plan to vote by present bias.
tab voted_vv hyperb_disc if CC354 == 1 [aweight=weight], col
*Among those not or undecided on voting.
tab voted_vv hyperb_disc if CC354 == 5 | CC354 == 6 [aweight=weight], col

*Regression models.
*Argument is that present bias hinders following through on an intention to vote.
local tabl "TimeIncon_Table02.tex"
local tabl2 "TimeIncon_Table02-probit.tex"
*Without controls.
reg voted_vv hyperb_disc if CC354 == 1 [aweight=weight]
 outreg2 hyperb_disc using "`tabl'", replace tex(fragment) ctitle("General") addtext("Demographic controls","No") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
probit voted_vv hyperb_disc if CC354 == 1 [pweight=weight]
 outreg2 hyperb_disc using "`tabl2'", replace tex(fragment) ctitle("General") addtext("Demographic controls","No") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
*With SES controls.
xi: reg voted_vv hyperb_disc i.educ i.faminc i.agedec if CC354 == 1  [aweight=weight]
 outreg2 hyperb_disc using "`tabl'", append tex(fragment) ctitle("General") addtext("Demographic controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
xi: probit voted_vv hyperb_disc i.educ i.faminc i.agedec if CC354 == 1  [pweight=weight]
 outreg2 hyperb_disc using "`tabl2'", append tex(fragment) ctitle("General") addtext("Demographic controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
if (`extraControls') {
  xi: reg voted_vv hyperb_disc i.educ i.faminc i.agedec i.race i.pid_strength i.ideo5 if CC354 == 1  [aweight=weight]
   outreg2 hyperb_disc using "`tabl'", append tex(fragment) ctitle("General") addtext("Demographic controls","Yes","Additional controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
  xi: probit voted_vv hyperb_disc i.educ i.faminc i.agedec i.race i.pid_strength i.ideo5 if CC354 == 1  [pweight=weight]
   outreg2 hyperb_disc using "`tabl2'", append tex(fragment) ctitle("General") addtext("Demographic controls","Yes","Additional controls","Yes") sdec(2) 2aster auto(2) rdec(3) label keep(hyperb_disc)
}
 
window manage close graph _all

*Save out dta with recodes for R graphics.
saveold "Recoded-CCESTurnoutData.dta", replace version(12)
