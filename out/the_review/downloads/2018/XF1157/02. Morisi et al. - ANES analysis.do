****************************************************************************************************************
**																											  **
** This do file is part of the replication material for the following article: 								  **
**  "An Asymmetrical 'President-in-Power' Effect" 											                  **
** 		Authors: Davide Morisi, John Jost, and Vishal Singh													  **
** 		Journal: American Political Science Review															  **
**																											  **
** This file replicates the following things from the article/appendix: 									  **
**	Figure 1 (results for ANES only)
**	Table 1 (results for ANES only)
**	Figure 2 (results for ANES only)
**	Appendix A (results for ANES only)
**	Appendix B (results for ANES only)
**	Appendix C (results for ANES only)
**	Appendix G (results for ANES only)
****************************************************************************************************************

*Starting file
*use "...\anes_combined.dta", clear

set more off
global demo1anes "female i.agegroup i.edu4 i.black i.unempl i.income5 i.religion"

*******************************************************************************
*******************************************************************************
*FIGURES AND TABLE IN THE ARTICLE

*
*FIGURE 1. Trust in the government by ideology (ANES)
egen trustlib = mean(trustall) if ideo2==1, by(year)
egen trustcon = mean(trustall) if ideo2==2, by(year)
twoway (scatter trustlib year if year>1970, sort(year) connect(ascending) color(blue) xlabel(1970(2)2016, valuelabel) title("Trust trend ANES")) ///
	(scatter trustcon year if year>1970, sort(year) connect(ascending) color(red) ///	
	xline(1970, lpattern(dash) lcolor(gs10)) text(0.3 1970 "Nixon/Ford", color(gs10) orientation(vertical) placement(2)) ///
	xline(1977, lpattern(dash) lcolor(gs10)) text(0.3 1977 "Carter", color(gs10) orientation(vertical) placement(2)) ///
	xline(1981, lpattern(dash) lcolor(gs10)) text(0.3 1981 "Reagan/Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(1993, lpattern(dash) lcolor(gs10)) text(0.3 1993 "Clinton", color(gs10) orientation(vertical) placement(2)) ///
	xline(2001, lpattern(dash) lcolor(gs10)) text(0.3 2001 "Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(2009, lpattern(dash) lcolor(gs10)) text(0.3 2009 "Obama", color(gs10) orientation(vertical) placement(2)) name(fig1_ANES))

*
*TABLE 1. President-in-power effects on trust in the government by ideology (ANES)
*See Table A3 below (same table)

*
*FIGURE 2. President-in-power effects on trust in the government by ideology (ANES)
reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census year [pweight=weightall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=1) // liberals
marginsplot, recast(bar) plotopts(barw(.8)) name(fig2_anesA)
reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census year [pweight=weightall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=2) // conservatives
marginsplot, recast(bar) plotopts(barw(.8)) name(fig2_anesB)
reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census year [pweight=weightall]
margins ideo2, dydx(ownpresLC) post
coefplot, vert yline(0) name(fig2_anesC)
graph combine fig2_anesA fig2_anesB fig2_anesC


*******************************************************************************
*******************************************************************************
*APPENDIX A: Analysis of trust in the government by ideology (ANES)

*
*Table A1. Trust in the government (summary statistics)
ta trust
ta trust16

*
*Table A2. Summary statistics for all variables included in regression models
ta prespower if trustall!=.
ta ideo3 if trustall!=.
ta ideo7 if trustall!=.
ta partyid3 if trustall!=.
ta partyid7 if trustall!=.
ta female if trustall!=.
ta agegroup if trustall!=.
ta edu4 if trustall!=.
ta black if trustall!=.
ta unempl if trustall!=.
ta income5 if trustall!=.
ta religion if trustall!=.
ta census if trustall!=.

*
*Table A3. President-in-power effects on trust in the government by ideology (ANES)
*Panel A
eststo clear
eststo: reg trustall i.ownpresLC##i.ideo2 [pweight=weightall]
eststo: reg trustall i.ownpresLC##i.ideo2 $demo1anes [pweight=weightall]
eststo: reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census i.preschange [pweight=weightall]
eststo: reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census year [pweight=weightall]
esttab using "~TableA3_ANES.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table A3. ANES")  compress noeqlines replace
*Panel B
reg trustall i.ownpresLC##i.ideo2 [pweight=weightall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=(1 2))
margins ideo2, dydx(ownpresLC)
reg trustall i.ownpresLC##i.ideo2 $demo1anes [pweight=weightall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=(1 2))
margins ideo2, dydx(ownpresLC)
reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census i.preschange [pweight=weightall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=(1 2))
margins ideo2, dydx(ownpresLC)
reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census year [pweight=weightall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=(1 2))
margins ideo2, dydx(ownpresLC) 

*
*Table A5. President-in-power effects on trust in the government by ideology, additional models (ANES)
eststo clear
eststo: reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census year ib2.partyid3 [pweight=weightall]
eststo: reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census year ib2.partyid3 i.partysen i.partyhouse [pweight=weightall]
esttab using "~TableA5_ANES.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p) title("anes")  compress noeqlines replace 

*
*Table A6. President-in-power effects on trust in the government by ideology (logistic regressions) 
eststo clear
eststo: logit trustdum i.ownpresLC##i.ideo2 $demo1anes [pweight=weightall]
eststo: logit trustdum i.ownpresLC##i.ideo2 $demo1anes i.census i.preschange [pweight=weightall]
eststo: logit trustdum i.ownpresLC##i.ideo2 $demo1anes i.census year [pweight=weightall]
esttab using "~TableA6.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p) title("Table A6. ANES")  compress noeqlines replace 

*
*Table A7. President-in-power effects on trust in the government by ideology (trust index)
eststo clear
eststo: reg trust_index01 i.ownpresLC##i.ideo2 $demo1anes [pweight=weightall]
eststo: reg trust_index01 i.ownpresLC##i.ideo2 $demo1anes i.census i.preschange [pweight=weightall]
eststo: reg trust_index01 i.ownpresLC##i.ideo2 $demo1anes i.census year [pweight=weightall]
esttab using "~TableA7.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table A7. ANES")  compress noeqlines replace 

*
*Table A8. President-in-power effects on trust in the government by ideology and switch years
*Panel A. ANES
eststo clear
eststo: reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census i.switch [pweight=weightall] // all
eststo: reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census if switch==1 [pweight=weightall] // 76/78
eststo: reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census if switch==2 [pweight=weightall] // 80/82
eststo: reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census if switch==3 [pweight=weightall] // 92/94
eststo: reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census if switch==4 [pweight=weightall] // 00/02
eststo: reg trustall i.ownpresLC##i.ideo2 $demo1anes i.census if switch==5 [pweight=weightall] // 08/12
esttab using "~TableA8_ANES.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p) title("Table A8. ANES")  compress noeqlines replace 

*
*Table A9. President-in-power effects on trust in the government by ideology and united/divided Congress (ANES)
eststo clear
eststo: reg trustall i.ownpresLC##i.ideo2##i.congr_dum $demo1anes ib2.partyid3 i.census year [pweight=weightall]
esttab using "~TableA9_anes.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p) title("Table A9. Anes")  compress noeqlines replace 

*
*Figure A1. President-in-power effects on trust in the government by four categories of ideology (ANES)
recode ideo7 (1/2=1 "(extreme) liberals") (3=2 "sligthly liberals") (4=.) (5=3 "sligthly conservatives") (6/7=4 "(extreme) conservatives"), gen(ideo4)
reg trustall i.ownpresLC##i.ideo4 $demo1anes i.census year [pweight=weightall]
margins ideo4, dydx(ownpresLC) 
marginsplot, yline(0) name(figA1_anes)


*******************************************************************************
*******************************************************************************
*APPENDIX B: Analysis of trust in the government by partisanship (ANES)

*
*Figure B1. Trust in the government by partisanship (ANES)
egen trustdem = mean(trustall) if partyid2==1, by(year)
egen trustrep = mean(trustall) if partyid2==2, by(year)
twoway (scatter trustdem year, sort(year) connect(ascending) color(blue) xlabel(1970(2)2016, valuelabel) title("Trust trend ANES")) ///
	(scatter trustrep year, sort(year) connect(ascending) color(red) ///	
	xline(1970, lpattern(dash) lcolor(gs10)) text(0.3 1970 "Nixon/Ford", color(gs10) orientation(vertical) placement(2)) ///
	xline(1977, lpattern(dash) lcolor(gs10)) text(0.3 1977 "Carter", color(gs10) orientation(vertical) placement(2)) ///
	xline(1981, lpattern(dash) lcolor(gs10)) text(0.3 1981 "Reagan/Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(1993, lpattern(dash) lcolor(gs10)) text(0.3 1993 "Clinton", color(gs10) orientation(vertical) placement(2)) ///
	xline(2001, lpattern(dash) lcolor(gs10)) text(0.3 2001 "Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(2009, lpattern(dash) lcolor(gs10)) text(0.3 2009 "Obama", color(gs10) orientation(vertical) placement(2)) name(figB1_ANES))


*
*Table B1. Correlations between party identification and ideology by decades (ANES)
gen decades =.
replace decades=1 if year<1980
replace decades=2 if year>=1980 & year<1990
replace decades=3 if year>=1990 & year<2000
replace decades=4 if year>=2000 & year<2010
replace decades=5 if year>=2010
label de decades 1"70s" 2"80s" 3"90s" 4"2000s" 5"2010s"
label values decades decades
ta year decades
bys decades: pwcorr partyid2 ideo2, sig

*
*Table B2. President-in-power effects on trust in the government by partisanship (ANES)
*Panel A
eststo clear
eststo: reg trustall i.ownpresDR##i.partyid2 [pweight=weightall]
eststo: reg trustall i.ownpresDR##i.partyid2 $demo1anes [pweight=weightall]
eststo: reg trustall i.ownpresDR##i.partyid2 $demo1anes i.census i.preschange [pweight=weightall]
eststo: reg trustall i.ownpresDR##i.partyid2 $demo1anes i.census year [pweight=weightall]
eststo: reg trustall i.ownpresDR##i.partyid2 $demo1anes i.census year ib2.ideo3 [pweight=weightall]
eststo: reg trustall i.ownpresDR##i.partyid2 $demo1anes i.census year ib2.ideo3 partysen partyhouse [pweight=weightall]
esttab using "~TableB2_ANES.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p) title("table B2. ANES")  compress noeqlines replace 
*Panel B
reg trustall i.ownpresDR##i.partyid2 [pweight=weightall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)
reg trustall i.ownpresDR##i.partyid2 $demo1anes [pweight=weightall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)
reg trustall i.ownpresDR##i.partyid2 $demo1anes i.census i.preschange [pweight=weightall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)
reg trustall i.ownpresDR##i.partyid2 $demo1anes i.census year [pweight=weightall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)
reg trustall i.ownpresDR##i.partyid2 $demo1anes i.census year ib2.ideo3 [pweight=weightall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)
reg trustall i.ownpresDR##i.partyid2 $demo1anes i.census year ib2.ideo3 partysen partyhouse [pweight=weightall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)

*
*Figure B2. President-in-power effects on trust in the government by partisanship (ANES)
reg trustall i.ownpresDR##i.partyid2 $demo1anes i.census year [pweight=weightall] // model 4
margins 0.ownpresDR 1.ownpresDR, at(partyid2=1) // democrats
marginsplot, recast(bar) plotopts(barw(.8)) name(figB2_anesA)
reg trustall i.ownpresDR##i.partyid2 $demo1anes i.census year [pweight=weightall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=2) // republicans
marginsplot, recast(bar) plotopts(barw(.8)) name(figB2_anesB)
reg trustall i.ownpresDR##i.partyid2 $demo1anes i.census year [pweight=weightall]
margins partyid2, dydx(ownpresDR) post
coefplot, vert yline(0) name(figB2_anesC)
graph combine figB2_anesA figB2_anesB figB2_anesC



*******************************************************************************
*******************************************************************************
*APPENDIX C: The role of moderates and independents (ANES)

*
*Figure C1. Trust in the government by ideology (time trends including moderates) (ANES)
egen trustmod = mean(trustall) if ideo3==2, by(year)
twoway (scatter trustlib year, sort(year) connect(ascending) color(blue) xlabel(1970(2)2016, valuelabel) title("Trust trend ANES")) ///
	(scatter trustmod year, sort(year) connect(ascending) color(gs6)) ///	
	(scatter trustcon year, sort(year) connect(ascending) color(red) ///	
	xline(1970, lpattern(dash) lcolor(gs10)) text(0.3 1970 "Nixon/Ford", color(gs10) orientation(vertical) placement(2)) ///
	xline(1977, lpattern(dash) lcolor(gs10)) text(0.3 1977 "Carter", color(gs10) orientation(vertical) placement(2)) ///
	xline(1981, lpattern(dash) lcolor(gs10)) text(0.3 1981 "Reagan/Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(1993, lpattern(dash) lcolor(gs10)) text(0.3 1993 "Clinton", color(gs10) orientation(vertical) placement(2)) ///
	xline(2001, lpattern(dash) lcolor(gs10)) text(0.3 2001 "Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(2009, lpattern(dash) lcolor(gs10)) text(0.3 2009 "Obama", color(gs10) orientation(vertical) placement(2)) name(figC1_ANES))

*
*Table C1. President-in-power effects on trust in the government by ideology (including moderates) (ANES)
eststo clear
eststo: reg trustall i.ownpresLCM##i.ideo3 $demo1anes i.census year ib2.partyid3 [pweight=weightall]
eststo: reg trustall i.ownpresLCM##ib2.ideo3 $demo1anes i.census year ib2.partyid3 [pweight=weightall]
esttab using "~TableC1_ANES.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table C1. Anes")  compress noeqlines replace 

*
*Figure C2. President-in-power effects on trust in the government by ideology (including moderates) (ANES)
reg trustall i.ownpresLCM##i.ideo3 $demo1anes i.census year ib2.partyid3 [pweight=weightall]
margins ideo3, dydx(ownpresLCM) post
coefplot, vert yline(0) name(figC2_anes)

*
*Figure C3. Trust in the government by partisanship (time trends including independents) (ANES)
egen trustind = mean(trustall) if partyid3==2, by(year)
twoway (scatter trustdem year, sort(year) connect(ascending) color(blue) xlabel(1970(2)2016, valuelabel) title("Trust trend ANES")) ///
	(scatter trustind year, sort(year) connect(ascending) color(gs6)) ///	
	(scatter trustrep year, sort(year) connect(ascending) color(red) ///	
	xline(1970, lpattern(dash) lcolor(gs10)) text(0.3 1970 "Nixon/Ford", color(gs10) orientation(vertical) placement(2)) ///
	xline(1977, lpattern(dash) lcolor(gs10)) text(0.3 1977 "Carter", color(gs10) orientation(vertical) placement(2)) ///
	xline(1981, lpattern(dash) lcolor(gs10)) text(0.3 1981 "Reagan/Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(1993, lpattern(dash) lcolor(gs10)) text(0.3 1993 "Clinton", color(gs10) orientation(vertical) placement(2)) ///
	xline(2001, lpattern(dash) lcolor(gs10)) text(0.3 2001 "Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(2009, lpattern(dash) lcolor(gs10)) text(0.3 2009 "Obama", color(gs10) orientation(vertical) placement(2)) name(figC3_ANES))


*
*Table C2. President-in-power effects on trust in the government by partisanship (including independents) (ANES)
eststo clear
eststo: reg trustall i.ownpresDRI##i.partyid3 $demo1anes i.census year ib2.ideo3 [pweight=weightall]
eststo: reg trustall i.ownpresDRI##ib2.partyid3 $demo1anes i.census year ib2.ideo3 [pweight=weightall]
esttab using "~TableC2_ANES.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table C2. Anes")  compress noeqlines replace 

*
*Figure C4. President-in-power effects on trust in the government by partisanship (including independents) (ANES)
reg trustall i.ownpresDRI##i.partyid3 $demo1anes i.census year ib2.ideo3 [pweight=weightall]
margins partyid3, dydx(ownpresDRI) post
coefplot, vert yline(0) name(figC4_anes)


*******************************************************************************
*******************************************************************************
*APPENDIX G: Analysis of changing effects over time

*
*Figure G1. Change in “trust gap” by ideology and partisanship over time (ANES)
preserve
	collapse (mean) trustlib trustcon trustdem trustrep, by(year)
	gen trustgap_ideo = abs(trustlib-trustcon)
	gen trustgap_pid = abs(trustdem-trustrep)
	twoway (scatter trustgap_ideo year, sort(year) connect(ascending) color(green) xlabel(1972(4)2016, valuelabel) xtitle("Years") ytitle("Trust gap (absolute values)") title("ANES")) ///
	  (scatter trustgap_pid year, sort(year) connect(ascending) color(orange) name(figG1_anes)) ///
	  (lfit trustgap_ideo year, color(green) lpattern(dash))  (lfit trustgap_pid year, color(orange) lpattern(dash))

	*Table G1. Regressions of “trust gap” on time variables (ANES)
	*Column 1 (ideology)
	gen trustgap_ideo100 = trustgap_ideo*100 // rescale DV from 0 to 100
	eststo clear
	eststo: reg trustgap_ideo100 year
	*Column 2 (pid)
	gen trustgap_pid100 = trustgap_pid*100
	eststo: reg trustgap_pid100 year
	esttab using "~TableG1_ANES.rtf", ///
	b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table G1. Anes")  compress noeqlines replace 
	

*
*Table G2. President-in-power effects on trust in the government by ideology and time variables (ANES)
eststo clear
eststo: reg trustall i.ownpresLC##i.ideo2##c.year $demo1anes i.census [pweight=weightall]
esttab using "~TableG2_ANES.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table G2. Anes")  compress noeqlines replace 

*
*Figure G2. President-in-power effects on trust in the government by time variables (difference between conservatives and liberals) (ANES)
reg trustall i.ownpresLC##i.ideo2##c.year $demo1anes i.census [pweight=weightall]
margins r.ideo2, dydx(ownpresLC) at(year==(1972(4)2016))
marginsplot, yline(0) name(figG2_anes)



