*===================================================*
*													*
*			Models for FPA							*
*													*
*		Last Update: 4.25.2012						*
*													*
*===================================================*


clear all
use "troops and military spending.dta"



// SIMPLE MODELS
// Full Sample
tsset ccode year
set more off
eststo clear
	//	All States
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean if year<2004, corr(ar1) pairwise	
	// 	Non-NATO US Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean if atopally == 1 & NATO == 0 & year<2004, corr(ar1) pairwise
	//	NATO Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean if NATO == 1 & year<2004, corr(ar1) pairwise
	// 	Non-US Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean if atopally ==0 & year<2004, corr(ar1) pairwise
	esttab _all using isa2012_models_memo.tex, replace title(US Troop Deployments and the Defense Burden, 1950--2003) ///
	mtitles("All States" "Non-NATO Allies" "NATO Allies" "Non-Allies") ///
	scalars("p Prob $ > \chi^2$") r2 obslast label se nogaps star(* 0.1 ** 0.05 *** 0.01)

	
// SIMPLE MODELS w/ Lagged def burden	
// Full Sample
tsset ccode year
set more off
eststo clear
	//	All States
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.defburden if year<2004,  pairwise	
	// 	Non-NATO US Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.defburden if atopally == 1 & NATO == 0 & year<2004,  pairwise
	//	NATO Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.defburden if NATO == 1 & year<2004,  pairwise
	// 	Non-US Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.defburden if atopally ==0 & year<2004, pairwise
	esttab _all using isa2012_models_memo2.tex, replace title(US Troop Deployments and the Defense Burden, 1950--2003) ///
	mtitles("All States" "Non-NATO Allies" "NATO Allies" "Non-Allies") ///
	scalars("p Prob $ > \chi^2$") r2 obslast label se nogaps star(* 0.1 ** 0.05 *** 0.01)
			
	
// COLD WAR MODELS
tsset ccode year
set more off
eststo clear
	//	All States
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr war movav3 borderstates civilwar  l.threat_environment if year<1990, corr(ar1) pairwise	
	// 	Non-NATO US Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr war movav3 borderstates civilwar  l.threat_environment if atopally == 1 & NATO == 0 & year<1990, corr(ar1) pairwise
	//	NATO Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr war movav3 borderstates civilwar  l.threat_environment if NATO == 1 & year<1990, corr(ar1) pairwise
	// 	Non-US Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr war movav3 borderstates civilwar  l.threat_environment if atopally ==0 & year<1990, corr(ar1) pairwise
	esttab _all using isa2012_models.tex, replace title(US Troop Deployments and the Defense Burden -- Cold War Period) ///
	mtitles("All States" "Non-NATO Allies" "NATO Allies" "Non-Allies") scalars("p Prob $ > \chi^2$") ///
	r2 obslast label se nogaps star(* 0.1 ** 0.05 *** 0.01) ///
	order(L.lntroops L.lntroops_spmean L.polity L.lntpop L.growth2 L.imr war civilwar movav3 L.threat_environment) 


// POST-COLD WAR MODELS
tsset ccode year
set more off
eststo clear
	//	All States
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr war movav3 borderstates civilwar  l.threat_environment if year>1989, corr(ar1) pairwise	
	// 	Non-NATO US Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr war movav3 borderstates civilwar  l.threat_environment if atopally == 1 & NATO == 0 & year>1989, corr(ar1) pairwise
	//	NATO Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr war movav3 borderstates civilwar  l.threat_environment if NATO == 1 & year>1989, corr(ar1) pairwise
	// 	Non-US Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr war movav3 borderstates civilwar  l.threat_environment if atopally ==0 & year>1989, corr(ar1) pairwise
	esttab _all using isa2012_models.tex, replace title(US Troop Deployments and the Defense Burden -- Cold War Period) ///
	mtitles("All States" "Non-NATO Allies" "NATO Allies" "Non-Allies") scalars("p Prob $ > \chi^2$") ///
	r2 obslast label se nogaps star(* 0.1 ** 0.05 *** 0.01) ///
	order(L.lntroops L.lntroops_spmean L.polity L.lntpop L.growth2 L.imr war civilwar movav3 L.threat_environment) 


**************************************************************************************
// Figure 3
// Comparison of troops and polity variables - Prais Winsten Model 1
clear all
use "troops and military spending data.dta"
set more off
sort ccode year
gen lag_lntroops = l.lntroops
gen lag_lntroops_spmean = l.lntroops_spmean
gen lag_polity = l.polity
gen lag_lntpop = l.lntpop
gen lag_growth2 = l.growth2
gen lag_imr = l.imr
gen lag_borderstates = borderstates
gen lag_threat_environment = l.threat_environment

xtpcse defburden lag_lntroops lag_lntroops_spmean war civilwar borderstates lag_polity lag_lntpop lag_growth2 lag_imr movav3 lag_threat_environment if year<2004, corr(ar1) pairwise	

clear
range lag_lntroops 0 13 1200
gen lag_lntroops_spmean = 5.44
gen war = 0			//Modal Value
gen civilwar = 0 	//Modal Value
gen borderstates = 5 //Modal Value
gen lag_polity = 1 	//Rounded Mean Value
gen lag_lntpop = 9.06
gen lag_growth2 = .0353819
gen lag_imr = 66.89
gen movav3 = 1  	//Rounded Mean Value
gen lag_threat_environment = .651
predict spending, xb
predict spending_sterr, stdp
gen spending_CI = 1.96*spending_sterr
gen spending_LB = spending-spending_CI
gen spending_UB = spending+spending_CI

replace spending_LB = spending_LB * 100
replace spending_UB = spending_UB * 100
replace spending = spending * 100

twoway rarea spending_LB spending_UB lag_lntroops, color(gs14) fi(100) || ///
 line spending lag_lntroops, lcolor(black) title("(a)") ///
 xtitle("ln (Troops)") legend(off) ytitle("Defense Spending (Percent of GDP)") ylabel(-1(1)5) xlabel(#13) ///
  aspect(1) ///
saving(T1M1_troops.gph, replace)

clear
range lag_polity -10 10 1200
gen lag_lntroops_spmean = 5.44
gen lag_lntroops = 3.27
gen war = 0			//Modal Value
gen civilwar = 0 	//Modal Value
gen borderstates = 5 //Modal Value
gen lag_lntpop = 9.06
gen lag_growth2 = .0353819
gen lag_imr = 66.89
gen movav3 = 1  	//Rounded Mean Value
gen lag_threat_environment = .651
predict spending, xb
predict spending_sterr, stdp
gen spending_CI = 1.96*spending_sterr
gen spending_LB = spending-spending_CI
gen spending_UB = spending+spending_CI

replace spending_LB = spending_LB * 100
replace spending_UB = spending_UB * 100
replace spending = spending * 100

twoway rarea spending_LB spending_UB lag_polity, color(gs14) fi(100) || ///
 line spending lag_polity, lcolor(black)  title("(b)") ///
 xtitle("Polity") legend(off) ytitle("Defense Spending (Percent of GDP)") ylabel(-1(1)5) xlabel(-10(2)10)  ///
 aspect(1) ///
saving(T1M1_polity.gph, replace)

graph combine T1M1_troops.gph T1M1_polity.gph, cols(2) ycommon


