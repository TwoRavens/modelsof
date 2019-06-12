****************************************************************************************************************
**																											  **
** This do file is part of the replication material for the following article: 								  **
**  "An Asymmetrical 'President-in-Power' Effect" 											                  **
** 		Authors: Davide Morisi, John Jost, and Vishal Singh													  **
** 		Journal: American Political Science Review															  **
**																											  **
** This file replicates the following things from the article/appendix: 									  **
**	Appendix E 
**	Appendix G (results for PEW only)
****************************************************************************************************************

*Starting file
*use "pew_combined_2006-2017_recoded.dta", clear

global demopew "i.sex age_r i.edu4 i.black i.income5 i.relig4"

*
*Table E1. President-in-power effects on trust in the government by ideology (PEW)
eststo clear
eststo: reg trust01 i.ownpresLC##i.ideo2 [pweight=weight]
eststo: reg trust01 i.ownpresLC##i.ideo2 $demopew i.cregion ib2.party3 time [pweight=weight]
eststo: reg trust01 i.ownpresLC##i.ideo2 $demopew i.cregion ib2.party3 if year==2006 | (year==2010 & month==3) [pweight=weight]
eststo: reg trust01 i.ownpresLC##i.ideo2 $demopew i.cregion ib2.party3 if year==2015 | year==2017 [pweight=weight]
esttab using "~TableE1_PEW.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("table E1. PEW")  compress noeqlines replace 


*
*FIGURE E1. President-in-power effects on trust in the government by ideology (PEW)
reg trust01 i.ownpresLC##i.ideo2 $demopew i.cregion ib2.party3 time [pweight=weight]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=1) // liberals
marginsplot, recast(bar) plotopts(barw(.8)) name(figE1_pewA)
reg trust01 i.ownpresLC##i.ideo2 $demopew i.cregion ib2.party3 time [pweight=weight]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=2) // conservatives
marginsplot, recast(bar) plotopts(barw(.8)) name(figE1_pewB)
reg trust01 i.ownpresLC##i.ideo2 $demopew i.cregion ib2.party3 time [pweight=weight]
margins ideo2, dydx(ownpresLC) post
coefplot, vert yline(0) name(figE1_pewC)
graph combine figE1_pewA figE1_pewB figE1_pewC

*
*Table E2. President-in-power effects on trust in the government by partisanship (PEW)
eststo clear
eststo: reg trust01 i.ownpresDR##i.party2 [pweight=weight]
eststo: reg trust01 i.ownpresDR##i.party2 $demopew i.cregion ib2.ideo3 time [pweight=weight]
eststo: reg trust01 i.ownpresDR##i.party2 $demopew i.cregion ib2.ideo3 if year==2006 | (year==2010 & month==3) [pweight=weight]
eststo: reg trust01 i.ownpresDR##i.party2 $demopew i.cregion ib2.ideo3 if year==2015 | year==2017 [pweight=weight]
esttab using "~TableE2_PEW.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("table E2. PEW")  compress noeqlines replace 

*
*FIGURE E2. President-in-power effects on trust in the government by partisanship (PEW)
reg trust01 i.ownpresDR##i.party2 $demopew i.cregion ib2.ideo3 time [pweight=weight]
margins 0.ownpresDR 1.ownpresDR, at(party2=1) // democrats
marginsplot, recast(bar) plotopts(barw(.8)) name(figE2_pewA)
reg trust01 i.ownpresDR##i.party2 $demopew i.cregion ib2.ideo3 time [pweight=weight]
margins 0.ownpresDR 1.ownpresDR, at(party2=2) // reublicans
marginsplot, recast(bar) plotopts(barw(.8)) name(figE2_pewB)
reg trust01 i.ownpresDR##i.party2 $demopew i.cregion ib2.ideo3 time [pweight=weight]
margins party2, dydx(ownpresDR) post
coefplot, vert yline(0) name(figE2_pewC)
graph combine figE2_pewA figE2_pewB figE2_pewC


*******************************************************************************
*******************************************************************************
*APPENDIX G: Analysis of changing effects over time

*
*Figure G1. Change in “trust gap” by ideology and partisanship over time (PEW)
fre ideo2 party2
ta time
preserve
	egen trustlib = mean(trust01) if ideo2==1, by(time)
	egen trustcon = mean(trust01) if ideo2==2, by(time)
	egen trustdem = mean(trust01) if party2==1, by(time)
	egen trustrep = mean(trust01) if party2==2, by(time)
	collapse (mean) trustlib trustcon trustdem trustrep, by(time)
	gen trustgap_ideo = abs(trustlib-trustcon)
	gen trustgap_pid = abs(trustdem-trustrep)
	twoway (scatter trustgap_ideo time, sort(time) connect(ascending) color(green) xlabel(0(11)124, valuelabel) xtitle("Time (months)") ytitle("Trust gap (absolute values)") title("PEW")) ///
	  (scatter trustgap_pid time, sort(time) connect(ascending) color(orange) name(figG1_pew)) ///
	  (lfit trustgap_ideo time, color(green) lpattern(dash))  (lfit trustgap_pid time, color(orange) lpattern(dash))

	*Table G1. Regressions of “trust gap” on time variables (PEW)
	*Column 5 (ideology)
	gen trustgap_ideo100 = trustgap_ideo*100 // rescale DV from 0 to 100
	eststo clear
	eststo: reg trustgap_ideo100 time
	*Column 6 (pid)
	gen trustgap_pid100 = trustgap_pid*100
	eststo: reg trustgap_pid100 time
	esttab using "~TableG1_pew.rtf", ///
	b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table G1. pew")  compress noeqlines replace 
restore

*
*Table G2. President-in-power effects on trust in the government by ideology and time variables (PEW)	
eststo clear
eststo: reg trust01 i.ownpresLC##i.ideo2##c.time $demopew i.cregion ib2.party3 [pweight=weight]
esttab using "~TableG2_pew.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table G2. PEW")  compress noeqlines replace 

*
*Figure G2. President-in-power effects on trust in the government by time variables (difference between conservatives and liberals) (PEW)
reg trust01 i.ownpresLC##i.ideo2##c.time $demopew i.cregion ib2.party3 [pweight=weight]
margins r.ideo2, dydx(ownpresLC) at(time==(0(11)124))
marginsplot, yline(0) name(figG2_pew)
