***Appendix
set more off
*Table 1: Summary statistics for the variables used in table 2 in the main text (Ulfelder data)
cd "D:\Felix\JPR\replication files"
use "Ulfeldertscsfinal.dta", clear
sum Llrgdppc mil previnst Lpropdem Lltpop Lup

*Tables 2-5: Grambsch-Therneau tests for the panel data models
use "Ulfeldertscsfinal.dta", clear
stset duration, id(regid) failure(failure) scale(1)
stcox RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup, robust cluster(regid) schoenfeld(sch*) scaledsch(sca*)
*Table 2: Test for Model 2 in Table 2, linear version (Ulfelder data)
estat phtest, detail 
*Table 3: Test for Model 2 in Table 2, logarithmic transformation (Ulfelder data)
estat phtest, detail log
*Table 4: Test for Model 2 in Table 2, Kaplan-Meier transformation (Ulfelder data)
estat phtest, detail km
*Table 5: Test for Model 2 in Table 2, rank transformation (Ulfelder data)
estat phtest, detail rank
drop sch* sca*

*Table 6: Summary statistics for covariates used to estimate the propensity score (Ulfelder data)
use "Ulfelderdatafinal.dta", clear
sum Llrgdppc mil previnst Lpropdem Lltpop Lup

*Table 7: Balancing statistics (Ulfelder data)
insheet using "balancingulf.csv", comma clear 
rename v1 covariate
replace fullsampleulfkstest =. if covariate=="miltt"
replace greedysampleulfkstest =. if covariate=="miltt"
replace calipersampleulfkstest =. if covariate=="miltt"
replace optimalsampleulfkstest =. if covariate=="miltt"
drop fullsampleulfsd greedysampleulfsd calipersampleulfsd optimalsampleulfsd
list

*Tables 8-10: Grambsch-Therneau tests for the matched samples
*Table 8: Grambsch-Therneau test: Greedy sample in Table 3 (Ulfelder data)
use "greedysampleulf.dta", clear
gen greedypair = _id if _treated==0 
replace greedypair = _n1 if _treated==1
stcox RCdum, robust cluster(greedypair) schoenfeld(sch*) scaledsch(sca*)
estat phtest, detail 
estat phtest, detail log
estat phtest, detail km
estat phtest, detail rank
drop sch* sca*
*Table 9: Grambsch-Therneau test: Caliper Sample in Table 3 (Ulfelder data)
use "calipersampleulf.dta", clear
gen caliper20pair = _id if _treated==0 
replace caliper20pair = _n1 if _treated==1
stcox RCdum, robust cluster(caliper20pair) schoenfeld(sch*) scaledsch(sca*)
estat phtest, detail 
estat phtest, detail log
estat phtest, detail km
estat phtest, detail rank
drop sch* sca*
*Table 10: Grambsch-Therneau test: Optimal Sample in Table 3 (Ulfelder data)
use "optimalsampleulf.dta", clear
stcox RCdum, robust cluster(optpair) schoenfeld(sch*) scaledsch(sca*)
estat phtest, detail 
estat phtest, detail log
estat phtest, detail km
estat phtest, detail rank
drop sch* sca*

*Table 11: Cox model with NVR as a time-dependent covariate (Ulfelder data)
use "optimalsampleulf.dta", clear
stcox RCdum, tvc(RCdum) texp(_t) vce(cluster optpair)
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear

**GWF Data Analysis
use "GWFdatafinal.dta", clear

***Specify and describe survival data
stset regdur, failure(failure) scale(1)
stsum
sum regdur

***Figure 1: Kaplan-Meier Survivor Function (Geddes data)
sts graph, title("") risktable  risktable(, size(small) rowtitle(, size(small)) title(, size(small)))

***Table 12: Categorical coding of resistance campaigns during transitions (Geddes data)
tab RC

***Figure 2: Kaplan-Meier Survivor Functions by Campaign Type (Geddes data)
sts graph, by(RC) title("")  risktable risktable(, size(small) rowtitle(, size(small)) title(, size(small))) risktable(, size(small) rowtitle(No Campaign, size(small)) group(#1)) risktable(, size(small) rowtitle(NVR Campaign, size(small)) group(#2)) risktable(, size(small) rowtitle(Violent Campaign, size(small)) group(#3))
sts test RC, logrank
stsum, by(RC)

*Table 13: Descriptive statistics for variables used in the Cox models with time-varying covariates (Geddes data)
use "GWFdatatscsfinal.dta", clear
sum Llrgdppc mil previnst Lpropdem Lltpop Lup

*Table 14: Cox proportional hazards models with time-varying covariates (Geddes data)
use "GWFdatatscsfinal.dta", clear
stset duration, id(regid) failure(failure) scale(1)
stcox Llrgdppc mil previnst Lpropdem Lltpop Lup,  robust cluster(regid) 
eststo
stcox RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup,  robust cluster(regid) 
eststo
gen RCdumdur=RCdum*_t
stcox RCdum RCdumdur Llrgdppc mil previnst Lpropdem Lltpop Lup, robust cluster(regid) 
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear

*Tables 15-18: Grambsch-Therneau tests for the panel data models
stcox RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup, robust cluster(regid) schoenfeld(sch*) scaledsch(sca*)
*Table 15: Grambsch-Therneau test for Model 2 in Table 14, linear version (Geddes data)
estat phtest, detail
*Table 16: Grambsch-Therneau test for Model 2 in Table 14, logarithmic transformation (Geddes data)
estat phtest, detail log
*Table 17: Grambsch-Therneau test for Model 2 in Table 14, Kaplan-Meier transformation (Geddes data)
estat phtest, detail km
*Table 18: Grambsch-Therneau test for Model 2 in Table 14, rank transformation (Geddes data)
estat phtest, detail rank
drop sch* sca*

*Table 19: Summary statistics for the covariates used to estimate the propensity score (Geddes data)
use "GWFdatafinal.dta", clear
sum Llrgdppc mil previnst Lpropdem Lltpop Lup

*Figure 3: Standardized differences for different matching schemes (Geddes data)
insheet using "balancinggwf.csv", comma clear 
rename v1 covariate
gen fullabssd =abs( fullsamplegwfsd)
gen greedyabssd =abs( greedysamplegwfsd)
gen caliperabssd =abs( calipersamplegwfsd)
gen optimalabssd =abs( optimalsamplegwfsd)
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

*Table 20: Balancing statistics (Geddes data)
insheet using "balancinggwf.csv", comma clear 
rename v1 covariate
replace fullsamplegwfkstest =. if covariate=="miltt"
replace greedysamplegwfkstest =. if covariate=="miltt"
replace calipersamplegwfkstest =. if covariate=="miltt"
replace optimalsamplegwfkstest =. if covariate=="miltt"
drop fullsamplegwfsd greedysamplegwfsd calipersamplegwfsd optimalsamplegwfsd
list

*Figure 4: Kaplan-Meier Survival Curves by NVR Presence for different Samples (Geddes data)
use "greedysamplegwf.dta", clear
gen greedypair = _id if _treated==0 
replace greedypair = _n1 if _treated==1
sts graph, by(RCdum) plot1opts(lcolor(black) lpattern(solid)) plot2opts(lcolor(black) lpattern(dash)) ytitle(Proportion surviving) ytitle(, size(small) margin(small)) ylabel(, labsize(small) nogrid) xtitle(Survival time) xtitle(, size(small) margin(small)) xlabel(, labsize(small)) title("Greedy sample", size(small)) legend(off) graphregion(margin(none) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "greedykmgwf.gph", replace
sts test RCdum, logrank strata(greedypair)

use "calipersamplegwf.dta", clear
gen caliper20pair = _id if _treated==0 
replace caliper20pair = _n1 if _treated==1
sts graph, by(RCdum) plot1opts(lcolor(black) lpattern(solid)) plot2opts(lcolor(black) lpattern(dash)) ytitle(Proportion surviving) ytitle(, size(small) margin(small)) ylabel(, labsize(small) nogrid) xtitle(Survival time) xtitle(, size(small) margin(small)) xlabel(, labsize(small)) title("Caliper sample", size(small)) legend(off) graphregion(margin(none) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "caliperkmgwf.gph", replace
sts test RCdum, logrank strata(caliper20pair)

use "optimalsamplegwf.dta", clear
sts graph, by(RCdum) plot1opts(lcolor(black) lpattern(solid)) plot2opts(lcolor(black) lpattern(dash)) ytitle(Proportion surviving) ytitle(, size(small) margin(small)) ylabel(, labsize(small) nogrid) xtitle(Survival time) xtitle(, size(small) margin(small)) xlabel(, labsize(small)) title("Optimal sample", size(small)) legend(off) graphregion(margin(none) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "optkmgwf.gph", replace
sts test RCdum, logrank strata(optpair)
graph combine "greedykmgwf.gph" "caliperkmgwf.gph" "optkmgwf.gph", rows(1) iscale(*1) imargin(small) commonscheme xsize(10) scale(1) graphregion(margin(tiny) fcolor(white) lcolor(white) lwidth(none) ifcolor(white) ilcolor(white) ilwidth(none)) plotregion(margin(tiny) fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))

*Table 21: Results from the Cox models using matched samples (Geddes data)
use "greedysamplegwf.dta", clear
stset regdur, failure(failure) scale(1)
gen greedypair = _id if _treated==0 
replace greedypair = _n1 if _treated==1
stcox RCdum, robust cluster(greedypair)
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear
stcox RCdum, tvc(RCdum) texp(_t) robust cluster(greedypair)
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear
use "calipersamplegwf.dta", clear
stset regdur, failure(failure) scale(1)
gen caliper20pair = _id if _treated==0 
replace caliper20pair = _n1 if _treated==1
stcox RCdum, robust cluster(caliper20pair)
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear
stcox RCdum, tvc(RCdum) texp(_t) robust cluster(caliper20pair)
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear
use "optimalsamplegwf.dta", clear
stset regdur, failure(failure) scale(1)
stcox RCdum, robust cluster(optpair)
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear
stcox RCdum, tvc(RCdum) texp(_t) robust cluster(optpair)
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear

*Tables 22-24: Grambsch-Therneau tests for the matched samples
*Table 22: Grambsch-Therneau test: Greedy sample in Table 21 (Geddes data)
use "greedysamplegwf.dta", clear
stset regdur, failure(failure) scale(1)
gen greedypair = _id if _treated==0 
replace greedypair = _n1 if _treated==1
stcox RCdum, robust cluster(greedypair) schoenfeld(sch*) scaledsch(sca*)
estat phtest, detail 
estat phtest, detail log
estat phtest, detail km
estat phtest, detail rank
drop sch* sca*
*Table 23: Grambsch-Therneau test: Caliper sample in Table 21 (Geddes data)
use "calipersamplegwf.dta", clear
stset regdur, failure(failure) scale(1)
gen caliper20pair = _id if _treated==0 
replace caliper20pair = _n1 if _treated==1
stcox RCdum, robust cluster(caliper20pair) schoenfeld(sch*) scaledsch(sca*)
estat phtest, detail 
estat phtest, detail log
estat phtest, detail km
estat phtest, detail rank
drop sch* sca*
*Table 24: Grambsch-Therneau test: Optimal sample in Table 21 (Geddes data)
use "optimalsamplegwf.dta", clear
stset regdur, failure(failure) scale(1)
stcox RCdum, robust cluster(optpair) schoenfeld(sch*) scaledsch(sca*)
estat phtest, detail 
estat phtest, detail log
estat phtest, detail km
estat phtest, detail rank
drop sch* sca*

*Table 25: Cox proportional hazards models with shared country/regime frailties, 
*Note that due to difficulties with these models converging, we had to alter some of maximization procedures and handling of tied failures 
use "Ulfeldertscsfinal.dta", clear
stset duration, id(regid) failure(failure) scale(1)
stcox RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup, shared(regid) efron
eststo
stcox RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup, shared(ccode) efron technique(dfp) 
eststo
use "GWFdatatscsfinal.dta", clear
stset duration, id(regid) failure(failure) scale(1)
stcox RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup, shared(regid) 
eststo
stcox RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup, shared(ccode) efron
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear

**Table 26: Cox-models that rely on the matched samples, but also include time-varying covariates measured after the transition

*gen sample ID-variables, Ulfelder sample
use "greedysampleulf.dta", clear
gen greedysampleid=1
keep ccode begin greedysampleid
save "greedysampleulfid.dta", replace
use "calipersampleulf.dta", clear
gen calipersampleid=1
keep ccode begin calipersampleid
save "calipersampleulfid.dta", replace
use "optimalsampleulf.dta", clear
gen optsampleid=1
keep ccode begin optsampleid
save "optsampleulfid.dta", replace

*merge with tscs-data
use "Ulfeldertscsfinal.dta", clear
sort ccode begin
merge n:1 ccode begin using "greedysampleulfid.dta"
drop _m
merge n:1 ccode begin using "calipersampleulfid.dta"
drop _m
merge n:1 ccode begin using "optsampleulfid.dta"
drop _m
save "Ulfeldertscsfinal.dta", replace

*gen sample ID-variables, GWF sample
use "greedysamplegwf.dta", clear
gen greedysampleid=1
keep ccode begin greedysampleid
save "greedysamplegwfid.dta", replace
use "calipersamplegwf.dta", clear
gen calipersampleid=1
keep ccode begin calipersampleid
save "calipersamplegwfid.dta", replace
use "optimalsamplegwf.dta", clear
gen optsampleid=1
keep ccode begin optsampleid
save "optsamplegwfid.dta", replace

*merge with tscs-data
use "GWFdatatscsfinal.dta", clear
sort ccode begin
merge n:1 ccode begin using "greedysamplegwfid.dta"
drop _m
merge n:1 ccode begin using "calipersamplegwfid.dta"
drop _m
merge n:1 ccode begin using "optsamplegwfid.dta"
drop _m
save "GWFdatatscsfinal.dta", replace

*Gen Tables
use "Ulfeldertscsfinal.dta", clear
stset duration, id(regid) failure(failure) scale(1)
stcox RCdum Llrgdppc Lpropdem Lltpop Lup if greedysampleid==1,  robust cluster(regid) 
eststo
stcox RCdum Llrgdppc Lpropdem Lltpop Lup if calipersampleid==1,  robust cluster(regid) 
eststo
stcox RCdum Llrgdppc Lpropdem Lltpop Lup if optsampleid==1,  robust cluster(regid) 
eststo
use "GWFdatatscsfinal.dta", clear
stset duration, id(regid) failure(failure) scale(1)
stcox RCdum Llrgdppc Lpropdem Lltpop Lup if greedysampleid==1,  robust cluster(regid) 
eststo
stcox RCdum Llrgdppc Lpropdem Lltpop Lup if calipersampleid==1,  robust cluster(regid) 
eststo
stcox RCdum Llrgdppc Lpropdem Lltpop Lup if optsampleid==1,  robust cluster(regid) 
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear

*Table 27: Regimes included in the Ulfelder dataset
use "Ulfelderdatafinal.dta", clear
order country begin end failure censoring campaignname RC
sort country begin
export excel country begin end failure censoring campaignname RC using "Ulfelder dataset.xls", firstrow(variables) replace

*Table 28: Regimes included in the Geddes dataset
use "GWFdatafinal.dta", clear
order country begin end failure censoring campaign RC
sort country begin
export excel country begin end failure censoring campaign RC using "GWF dataset.xls", firstrow(variables) replace
