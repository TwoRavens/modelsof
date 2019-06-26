set more off
***Figure 3: Standardized differences for different matching schemes
***Blancing tables and figures
cd "D:\Felix\JPR\replication files"
insheet using "balancingulf.csv", comma clear 
rename v1 covariate
gen fullabssd =abs( fullsampleulfsd)
gen greedyabssd =abs( greedysampleulfsd)
gen caliperabssd =abs( calipersampleulfsd)
gen optimalabssd =abs( optimalsampleulfsd)
gen sort=.
replace sort=1 if covariate=="GDPpctt"
replace sort=2 if covariate=="miltt"
replace sort=3 if covariate=="previnsttt"
replace sort=4 if covariate=="Lpropdemtt"
replace sort=5 if covariate=="Lltpoptt"
replace sort=6 if covariate=="Luptt"
replace covariate="GDP p.c." if covariate=="GDPpctt"
replace covariate="Military legacy" if covariate=="miltt"
replace covariate="Previous instability" if covariate=="previnsttt"
replace covariate="Neighboring democracies" if covariate=="Lpropdemtt"
replace covariate="Total population" if covariate=="Lltpoptt"
replace covariate="Urbanization" if covariate=="Luptt" 
graph dot (asis) fullabssd greedyabssd caliperabssd optimalabssd, over(covariate, sort(sort) label(labcolor(black) labsize(small))) marker(1, mcolor(black) msymbol(circle)) marker(2, mcolor(black) msymbol(diamond)) marker(3, mcolor(black) msymbol(square)) marker(4, mcolor(black) msymbol(triangle)) ytitle(Standardized difference) ytitle(, size(small) margin(small)) ylabel(, labsize(small)) legend(order( 1 "Full sample" 2 "Greedy sample" 3 "Caliper sample" 4 "Optimal sample") rows(1) size(small)) graphregion(margin(small) fcolor(white))


***Figure 4: Kaplan-Meier Survival Curves by NVR Presence for different Samples
use "greedysampleulf.dta", clear
gen greedypair = _id if _treated==0 
replace greedypair = _n1 if _treated==1
sts graph, by(RCdum) plot1opts(lcolor(black) lpattern(solid)) plot2opts(lcolor(black) lpattern(dash)) ytitle(Proportion surviving) ytitle(, size(small) margin(small)) ylabel(, labsize(small) nogrid) xtitle(Survival time) xtitle(, size(small) margin(small)) xlabel(, labsize(small)) title("Greedy sample", size(small)) legend(off) graphregion(margin(none) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "greedykmulf.gph", replace
sts test RCdum, logrank strata(greedypair)

use "calipersampleulf.dta", clear
gen caliper20pair = _id if _treated==0 
replace caliper20pair = _n1 if _treated==1
sts graph, by(RCdum) plot1opts(lcolor(black) lpattern(solid)) plot2opts(lcolor(black) lpattern(dash)) ytitle(Proportion surviving) ytitle(, size(small) margin(small)) ylabel(, labsize(small) nogrid) xtitle(Survival time) xtitle(, size(small) margin(small)) xlabel(, labsize(small)) title("Caliper sample", size(small)) legend(off) graphregion(margin(none) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "caliperkmulf.gph", replace
sts test RCdum, logrank strata(caliper20pair)

use "optimalsampleulf.dta", clear
sts graph, by(RCdum) plot1opts(lcolor(black) lpattern(solid)) plot2opts(lcolor(black) lpattern(dash)) ytitle(Proportion surviving) ytitle(, size(small) margin(small)) ylabel(, labsize(small) nogrid) xtitle(Survival time) xtitle(, size(small) margin(small)) xlabel(, labsize(small)) title("Optimal sample", size(small)) legend(off) graphregion(margin(none) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "optkmulf.gph", replace
sts test RCdum, logrank strata(optpair)

graph combine "greedykmulf.gph" "caliperkmulf.gph" "optkmulf.gph", rows(1) iscale(*1) imargin(small) commonscheme xsize(10) scale(1) graphregion(margin(tiny) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none)) plotregion(margin(tiny) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


***Table 3: Results from the Cox model using matched samples
use "greedysampleulf.dta", clear
gen greedypair = _id if _treated==0 
replace greedypair = _n1 if _treated==1
stcox RCdum, robust cluster(greedypair) schoenfeld(sch*) scaledsch(sca*)
eststo
use "calipersampleulf.dta", clear
gen caliper20pair = _id if _treated==0 
replace caliper20pair = _n1 if _treated==1
stcox RCdum, robust cluster(caliper20pair) schoenfeld(sch*) scaledsch(sca*)
eststo
use "optimalsampleulf.dta", clear
stcox RCdum, robust cluster(optpair) schoenfeld(sch*) scaledsch(sca*)
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear
