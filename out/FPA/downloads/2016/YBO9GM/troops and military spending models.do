clear all
set mem 50m
use "troops and military spending data.dta"


* Prais-Winsten Models
tsset ccode year
set more off
eststo clear
	//	All States
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr l.threat_environment war movav3 borderstates civilwar if year<2004 , corr(ar1) pairwise	
	// 	Non-NATO US Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr l.threat_environment war movav3 borderstates civilwar if atopally == 1 & NATO == 0 & year<2004, corr(ar1) pairwise
	//	NATO Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr l.threat_environment war movav3 borderstates civilwar if NATO == 1 & year<2004 , corr(ar1) pairwise
	// 	Non-US Allies
eststo:   xtpcse defburden l.lntroops l.lntroops_spmean l.polity l.growth2 l.lntpop l.imr l.threat_environment war movav3 borderstates civilwar if atopally ==0 & year<2004 , corr(ar1) pairwise
	esttab _all using FPA_Table_1.tex, replace title(US Troop Deployments and the Defense Burden, 1950--2003) ///
	mtitles("All States" "Non-NATO Allies" "NATO Allies" "Non-Allies") ///
	scalars("p Prob $ > \chi^2$") r2 obslast label se nogaps star(* 0.1 ** 0.05 *** 0.01) ///
	order(L.lntroops L.lntroops_spmean L.polity L.growth2 L.lntpop  L.imr war civilwar movav3 L.threat_environment) 


* 3SLS Models

tsset ccode year
set more off
eststo clear
	//	All States
eststo:   reg3 (defburden l.lntroops l.lntroops_spmean l.edugdp l.polity l.growth2 l.lntpop l.imr war civilwar movav3 l.threat_environment borderstates) (edugdp = l.lntroops l.defburden l.growth2 l.gdppc l.polity l.lntpop l.imr) (l.lntroops = l2.lntroops l2.defburden l2.lntpop l2.movav3 l2.war l2.atopally l2.threat_environment)  if year<2004 
estimates store tsls1
reg defburden l.lntroops l.lntroops_spmean l.edugdp l.polity l.growth2 l.lntpop l.imr war movav3 borderstates civilwar  l.threat_environment
hausman tsls1 ., equations(1:1)	
	
	// 	Non-NATO US Allies
eststo:   reg3 (defburden l.lntroops l.lntroops_spmean l.edugdp l.polity l.growth2 l.lntpop l.imr war civilwar movav3 l.threat_environment borderstates) (edugdp = l.lntroops l.defburden l.growth2 l.gdppc l.polity l.lntpop l.imr) (l.lntroops = l2.lntroops l2.defburden l2.lntpop l2.movav3 l2.war l2.threat_environment) if atopally == 1 & NATO == 0 & year<2004 
estimates store tsls1
reg defburden l.lntroops l.lntroops_spmean l.edugdp l.polity l.growth2 l.lntpop l.imr war civilwar movav3 borderstates  l.threat_environment if atopally == 1 & NATO == 0 & year<2004
hausman tsls1 ., equations(1:1)		
	//	NATO Allies
eststo:   reg3 (defburden l.lntroops l.lntroops_spmean l.edugdp l.polity l.growth2 l.lntpop l.imr war civilwar movav3 l.threat_environment borderstates) (edugdp = l.lntroops l.defburden  l.growth2 l.gdppc l.polity l.lntpop l.imr) (l.lntroops = l2.lntroops l2.defburden l2.lntpop l2.movav3 l2.war l2.threat_environment)   if NATO == 1 & year<2004
estimates store tsls1
reg defburden l.lntroops l.lntroops_spmean l.edugdp l.polity l.growth2 l.lntpop l.imr war civilwar movav3 borderstates  l.threat_environment if NATO == 1 & year<2004
hausman tsls1 ., equations(1:1)	

eststo:   reg3 (defburden l.lntroops l.lntroops_spmean l.edugdp l.polity l.growth2 l.lntpop l.imr war civilwar movav3 l.threat_environment borderstates ) (edugdp = l.lntroops l.defburden l.growth2 l.gdppc l.polity l.lntpop l.imr) (l.lntroops = l2.lntroops l2.defburden l2.lntpop l2.movav3 l2.war l2.threat_environment)  if atopally ==0 & year<2004
estimates store tsls1
reg defburden l.lntroops l.lntroops_spmean l.edugdp l.polity l.growth2 l.lntpop l.imr war movav3 borderstates civilwar  l.threat_environment if atopally ==0 & year<2004
hausman tsls1 ., equations(1:1)	

	esttab est1 est2 est3 est4 using FPA_Table_2.tex, replace title(US Troop Deployments and the Defense Burden, 1950--2003) ///
	mtitles("All States" "Non-NATO Allies" "NATO Allies" "Non-Allies") ///
	obslast label se nogaps star(* 0.1 ** 0.05 *** 0.01) order(L.lntroops L.lntroops_spmean) 

