*Jeremy Berkowitz
*Department of Political Science, Binghamton University
*Replication materials for "Delegating Terror: Principal-Agent Based Decision Making in State Sponsorship of Terrorism

clear all
set mem 1000m


use "delegatingterror.dta", clear


*Table 1
*Regression Analyses
logit  unanimous_support strategic_rivalry weaker_state_difference rivalry_weaker coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_unanimous timelastsponsor_unanimous, vce(robust)
lroc, nograph
logit  nonunanimous_support strategic_rivalry weaker_state_difference rivalry_weaker coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous, vce(robust)
lroc, nograph
logit  total_support strategic_rivalry weaker_state_difference rivalry_weaker coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
lroc, nograph

*Figure 1
*Predicted Probabilities
prgen rivalry_weaker, generate(H1) x(strategic_rivalry=1) rest(mean) n(10) ci
*Graphing Predicted Probabilities
label var  H1x "Relative Weakness"
label var  H1p1 "Predicted Probability"
label var  H1p1lb "Lower Bounds"
label var  H1p1ub "Upper Bounds"
twoway (line  H1p1  H1x) (line  H1p1lb H1x) (line  H1p1ub H1x) (histogram rivalry_weaker if rivalry_weaker != 0, bin(90) fintensity(45) fraction yaxis(2)), scheme(tufte) ytitle(Probability of Sponsorship) title({bf:Figure 1} Probability of terrorism sponsorship) subtitle(for strategic rivals across values of relative weakness) ytitle(Distribution of Relative Weakness, axis(2))legend(lab(4 "Distribution of Relative Weakness"))

*Table 2
*Regression Analyses
logit  unanimous_support unanimoustargeted_tminus1 coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_unanimous timelastsponsor_unanimous, vce(robust)
lroc, nograph
logit  nonunanimous_support nonunanimoustargeted_tminus1 coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous, vce(robust)
lroc, nograph
logit  total_support totaltargeted_tminus1 coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
lroc, nograph

*Figure 2
**Predicted Probabilities**
prgen totaltargeted_tminus1, generate(H2) rest(mean) n(10) ci
*Graphing Predicted probabilities
label var H2x "Targeted at Time Minus One"
label var H2p1 "Predicted Probability"
label var H2p1lb "Lower Bounds"
label var H2p1ub "Upper Bounds"
twoway (line  H2p1 H2x) (line H2p1lb  H2x) (line H2p1ub H2x), scheme(tufte) ytitle(Probability of Sponsorship) title({bf:Figure 2} Probability of reciprocal sponsorship)


*Table 3
*Regression Analyses
logit  unanimous_support xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_unanimous timelastsponsor_unanimous, vce(robust)
lroc, nograph
logit  nonunanimous_support xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous, vce(robust)
lroc, nograph
logit  total_support xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
lroc, nograph

*Figure 3
*Predicted Probabilities
prgen xconst, generate(H3) rest(mean) n(10) ci
*Graphing Predicted Probabilites
label var H3x "Executive Constraints"
label var H3p1 "Predicted Probability"
label var H3p1lb "Lower Bounds"
label var H3p1ub "Upper Bounds"
twoway (line  H3p1  H3x) (line H3p1lb H3x) (line H3p1ub H3x) (histogram xconst, fintensity(45) fraction yaxis(2)), scheme(tufte) ytitle(Probability of Sponsorship) ytitle(Distribution of Executive Constraints, axis(2)) title({bf:Figure 3} Probability of terrorism sponsorship) subtitle(across values of executive constraints) legend(lab(4 "Distribution of Executive Constraints"))


*Table 4
*Regression Analyses
logit  unanimous_support strategic_rivalry weaker_state_difference rivalry_weaker unanimoustargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_unanimous timelastsponsor_unanimous, vce(robust)
lroc, nograph
logit  nonunanimous_support strategic_rivalry weaker_state_difference rivalry_weaker nonunanimoustargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict  preexisting_nonunamious timelastsponsor_nonunanimous, vce(robust)
lroc, nograph
logit  total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
*Figure 4
lroc, scheme(lean1) ytitle(True positive rate) xtitle(False positive rate) title({bf:Figure 4} In-sample prediction) subtitle(area under ROC curve for full model (all cases)) pstyle(p1)

*Figure 5
*Note: Given the size of this data, expect several days to complete given standard computer speed
quietly logit  total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference rivalry_weaker totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

*Sample 2

quietly logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference  totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted


quietly logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference  totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

quietly logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total, vce(robust)
predict fitted, pr
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui logit total_support strategic_rivalry weaker_state_difference totaltargeted_tminus1 xconst coldwar NorthAmerica_WestEurope LatinAmerica Africa Middle_East EastEurope_CentralAsia militaryconflict preexisting_total timelastsponsor_total if group~=`i', vce(robust)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab total_support cv_fitted

capture drop fitted group cv_fitted

*Graphing Out of Sample Predictions
clear
set mem 1000m
use delegatingterror_outofsample.dta
twoway (scatter area run if sample==1), ytitle(Total Area Under Curve) yline(.89192, lpattern(dash)) ylabel(0.88(0.01)0.91) xtitle(Cycle Run) title(Full Model) xlabel(1(1)10) legend(off) scheme(tufte) name(graph1, replace)
twoway (scatter area run if sample==2), ytitle(Total Area Under Curve) yline(.89219, lpattern(dash)) ylabel(0.88(0.01)0.91) xtitle(Cycle Run) title(Full Model without Interactive Term) xlabel(1(1)10) legend(off) scheme(tufte) name(graph2, replace)
graph combine graph1 graph2, title({bf:Figure 5} Out-of-sample Prediction: fourfold cross-validation) ycommon scheme(tufte)





