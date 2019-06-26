***Stata code
set more off
version 14

***Install ados
ssc install psmatch2, all replace
ssc install estout, all replace


***Define working directory: Change to the folder where the replication files are stored
cd "D:\Felix\JPR\replication files"
use "Ulfelderdatafinal.dta", clear

***Specify and describe survival data
stset regdur, failure(failure) scale(1)
sum regdur

***Figure 1: Kaplan-Meier Survivor Function
sts graph, risktable risktable(, size(small) title(, size(small))) plotopts(lcolor(black)) ytitle(Proportion surviving) ytitle(, size(small) margin(small)) ylabel(, labsize(small) nogrid) xtitle(Survival time) xtitle(, size(small) margin(small)) xline(11, lwidth(thin) lpattern(dash) lcolor(black)) xlabel(, labsize(small)) title("") graphregion(margin(small) fcolor(white))

***Table 1: Categorical coding of resistance campaigns during transitions
tab RC

***Figure 2: Kaplan-Meier Survivor Functions by Campaign Type
replace RC="No campaign" if RC=="."
replace RC="Violent campaign" if RC=="V"
replace RC="NVR campaign" if RC=="NV"
sts graph, by(RC) risktable risktable(, size(small) title(, size(small))) plot1opts(lcolor(black) lpattern(dash)) plot2opts(lcolor(black) lpattern(solid)) plot3opts(lcolor(gs10) lpattern(solid)) ytitle(Proportion surviving) ytitle(, size(small) margin(small)) ylabel(, labsize(small) nogrid) xtitle(Survival time) xtitle(, size(small) margin(small)) xlabel(, labsize(small)) title("") legend(rows(1) size(small) region(margin(small))) graphregion(margin(small) fcolor(white))
sts test RC, logrank
stsum, by(RC)

***Table 2: Results from the Cox model with time-varying covariates
use "Ulfeldertscsfinal.dta", clear
stset duration, id(regid) failure(failure) scale(1)
stcox Llrgdppc mil previnst Lpropdem Lltpop Lup,  robust cluster(regid) 
eststo
stcox RCdum Llrgdppc mil previnst Lpropdem Lltpop Lup,  robust cluster(regid) 
eststo
esttab, eform se b(%10.3f) scalars("N_sub Regimes" "N_fail Democratic Breakdowns" "aic AIC" "bic BIC" "ll Log lik." "chi2 Chi-squared") label mtitles star(* 0.10 ** 0.05)
est clear
