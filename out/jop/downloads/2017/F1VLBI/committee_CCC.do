* Replication materials for 
* Cirone, Alexandra and Van Coppenolle, Brenda
* ‘Cabinets, Committees and Careers: The Causal Effect of Committee Service'
* The Journal of Politics

* Dofile 1/3 (main paper)

 
use "committee_CCC.dta", clear

xi: gen i.year
 


/* 0. Descriptive Statistics */
*******************************

* Figure 1: Main Categories of Sponsored Bills

*This is a simple tally of bills, done by authors; see paper for more information.




/* 1. Instrument */
********************

* Figure 2: Balance in characteristics (p-values)

local i=1
while `i'<=11 {
gen bureau`i'=(bureau==`i')
local ++i
}
ivreg2 age bureau2 bureau3 bureau4 bureau5 bureau6 bureau7 bureau8 bureau9 bureau10 bureau11 _I*, cluster(id clburyear) partial(_I*) 
outreg2 using bureaubalance_up_pval, dec(3) nonotes keep(bureau2 bureau3 bureau4 bureau5 bureau6 bureau7 bureau8 bureau9 bureau10 bureau11) stats(pval) nor2 noobs replace 
foreach var of varlist permargin inscrits proprietaire lib_all civil paris cummyears budgetincumbent budgetexptermyears {
ivreg2 `var' bureau2 bureau3 bureau4 bureau5 bureau6 bureau7 bureau8 bureau9 bureau10 bureau11 _I*, cluster(id clburyear) partial(_I*) 
outreg2 using bureaubalance_up_pval, dec(3) nonotes keep(bureau2 bureau3 bureau4 bureau5 bureau6 bureau7 bureau8 bureau9 bureau10 bureau11) stats(pval) nor2 noobs append 
}

*to create bureaubalance_up_pval.csv (already provided with replication files)

/*preserve
insheet using "bureaubalance_up_pval.csv", clear names
destring bureau, gen(bureau_str) ignore("bureau") 
drop bureau 
rename bureau_str bureau
gen id=_n
rename age Pvalue_var1
rename permargin Pvalue_var2
rename inscrits Pvalue_var3
rename proprietaire Pvalue_var4
rename lib_all Pvalue_var5
rename civil Pvalue_var6
rename paris Pvalue_var7
rename cummyears Pvalue_var8
rename budgetincumbent Pvalue_var9
rename budgetexptermyears Pvalue_var10
reshape long Pvalue_var ,i(id)
gen covariate=""
replace covariate="age" if _j==1
replace covariate="permargin" if _j==2
replace covariate="inscrits" if _j==3
replace covariate="proprietaire" if _j==4
replace covariate="lib_all" if _j==5
replace covariate="civil" if _j==6
replace covariate="paris" if _j==7
replace covariate="cummyears" if _j==8
replace covariate="budgetincumbent" if _j==9
replace covariate="budgetexptermyears" if _j==10
outsheet using "bureaubalance_up_pval_long.csv", replace
insheet using "bureaubalance_up_pval_long.csv", clear names
twoway (scatter bureau pvalue if covariate=="age", msymbol(diamond_hollow) sort) (scatter bureau pvalue if covariate=="permargin", msymbol(circle_hollow) sort) (scatter bureau pvalue if covariate=="inscrits", msymbol(square_hollow) sort) (scatter bureau pvalue if covariate=="proprietaire", msymbol(triangle_hollow) sort) (scatter bureau pvalue if covariate=="lib_all", msymbol(diamond) sort) (scatter bureau pvalue if covariate=="civil", msymbol(circle) sort) 	 (scatter bureau pvalue if covariate=="paris", msymbol(square) sort) (scatter bureau pvalue if covariate=="cummyears", msymbol(triangle) sort) (scatter bureau pvalue if covariate=="budgetincumbent", msymbol(plus) sort) (scatter bureau pvalue if covariate=="budgetexptermyears", msymbol(lgx) sort) (scatter bureau pvalue if covariate=="age", msymbol(diamond_hollow) sort), ytitle(Bureau number) xtitle(p-value) xline(0.05) xlabel (0 0.05 0.2 (0.2) 1) ylabel(2(1)11) graphregion(fcolor(white) lcolor(white)) scheme(s2mono) legend(order(1 "Age" 2 "Electoral Margin" 3 "Electors" 4 "Upper Class" 5 "Middle Class" 6 "Civil Service" 7 "Paris" 8 "Parl Exp Years" 9 "Budget Incumbent" 10 "Budget Exp Years") cols(4))
restore
*/


* Figure 3: Pretreatment Covariates and Instrument

ivreg2 age bureauotherbudgetincumbent _I*, cluster(id clburyear) partial(_I*) 
estimates store age
foreach var of varlist permargin inscrits proprietaire lib_all civil paris cummyears budgetincumbent budgetexptermyears {
ivreg2 `var' bureauotherbudgetincumbent _I*, cluster(id clburyear) partial(_I*) 
estimates store `var'
}

 coefplot (permargin) (proprietaire) (lib_all) (civil) (paris) (budgetincumbent), drop(_cons) keep(bureauotherbudgetincumbent) xline(0) aseq swapnames byopts(xrescale) graphregion(fcolor(white) lcolor(white)) scheme(s2mono) legend(off) msymbol(diamond)
 coefplot (age) (inscrits) (cummyears) (budgetexptermyears), drop(_cons) keep(bureauotherbudgetincumbent) xline(0) aseq swapnames byopts(xrescale) graphregion(fcolor(white) lcolor(white)) scheme(s2mono) legend(off) msymbol(diamond)

 

/* 2. Results */
*****************

* Table 2: Budget Committee and Future Budget Bill Sponsorship

ivreg2 F1to5billbudgetdummy budget _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5billbudgetdummy budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
xtivreg2 F1to5billbudgetdummy budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) fe partial(_I*)
ivreg2 F1to5billbudgetdummy (budget = bureauotherbudgetincumbent) _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5billbudgetdummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) 
xtivreg2 F1to5billbudgetdummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe


* Figure 4: Estimates of Committee Service on Sponsorship by Category, 1894-1913

ivreg2 F1to5billbudgetdummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent, cluster(id clburyear) partial(_I*) 
estimates store Budget
ivreg2 F1to5billinterpdummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent, cluster(id clburyear) partial(_I*) 
estimates store Interpellation
ivreg2 F1to5billecondummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent, cluster(id clburyear) partial(_I*) 
estimates store Economics
ivreg2 F1to5billagendadummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent, cluster(id clburyear) partial(_I*) 
estimates store Agenda
ivreg2 F1to5billwelfaredummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent, cluster(id clburyear) partial(_I*) 
estimates store SocialWelfare
ivreg2 F1to5billfinancedummy (budget = bureauotherbudgetincumbent) _I* budgetincumbent, cluster(id clburyear) partial(_I*) 
estimates store Finance

coefplot (Budget) (Interpellation) (Economics) (Agenda) (SocialWelfare) (Finance), drop(_cons) keep(budget) xline(0) aseq swapnames byopts(xrescale) graphregion(fcolor(white) lcolor(white)) scheme(s2mono) legend(off) msymbol(diamond)


* Figure 5: Estimates of Committee Service on Career Outcomes Within Five Years, 1894-1913

ivreg2 F1to5firstminyear (budget = bureauotherbudgetincumbent) _I*, cluster(id clburyear) partial(_I*) 
estimates store Minister
ivreg2 F1to5firstminyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
estimates store min1
xtivreg2 F1to5firstminyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe
estimates store min2

ivreg2 F1to5firstleaderyear (budget = bureauotherbudgetincumbent) _I*, cluster(id clburyear) partial(_I*) 
estimates store Leader
ivreg2 F1to5firstleaderyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
estimates store lead1
xtivreg2 F1to5firstleaderyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe
estimates store lead2

ivreg2 F1to5senateyear (budget = bureauotherbudgetincumbent) _I*, cluster(id clburyear) partial(_I*) 
estimates store Senator
ivreg2 F1to5senateyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
estimates store senate1
xtivreg2 F1to5senateyear (budget = bureauotherbudgetincumbent) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe
estimate store senate2

coefplot (Minister, label(Model 1, Baseline 2SLS))(min1, label(Model 2, with Individual Controls)) (min2, label(Model 3, with Individual Controls and FE)) || Senator senate1 senate2|| Leader lead1 lead2,  keep(budget)  drop(_cons) xline(0)    bycoefs byopts(yrescale)  scheme(s2mono) graphregion(fcolor(white) lcolor(white))  legend(row(3))


* Table 3: Reelection, within the Next Two Terms

xi: gen i.term
preserve
sort id term termyear
bysort id term: egen lastty=max(termyear)
gen keeptag=(termyear==lastty)
keep if keeptag==1
tab rannext,m

ivreg2 reelectterm (budget = bureauotherbudgetincumbent ) _I* if rannext==1, cluster(id clburyear) first partial(_I*)
ivreg2 reelectterm (budget = bureauotherbudgetincumbent ) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris if rannext==1, cluster(id clburyear) first partial(_I*)
ivreg2 reelecttwoterm (budget = bureauotherbudgetincumbent ) _I* if rannext==1, cluster(id clburyear) first partial(_I*)
ivreg2 reelecttwoterm (budget = bureauotherbudgetincumbent ) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris if rannext==1, cluster(id clburyear) first partial(_I*)
ivreg2 rannext (budget = bureauotherbudgetincumbent ) _I*, cluster(id clburyear) first partial(_I*)
ivreg2 rannext (budget = bureauotherbudgetincumbent ) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) first partial(_I*)
restore


* Table 4: Future Bill Co-Sponsorship in Budget Committee Networks

xi: gen i.year
ivreg2 F1to5cosponsordummy_anybm budget _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5cosponsordummy_anybm budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*)
xtivreg2 F1to5cosponsordummy_anybm budget _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) fe partial(_I*)
ivreg2 F1to5cosponsordummy_anybm (budget = bureauotherbudgetincumbent ) _I*, cluster(id clburyear) partial(_I*)
ivreg2 F1to5cosponsordummy_anybm (budget = bureauotherbudgetincumbent ) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) 
xtivreg2 F1to5cosponsordummy_anybm (budget = bureauotherbudgetincumbent ) _I* budgetincumbent cummyears cummyears2 age age2 permargin permargin2 inscrits inscrits2 proprietaire lib_all civil paris, cluster(id clburyear) partial(_I*) fe
