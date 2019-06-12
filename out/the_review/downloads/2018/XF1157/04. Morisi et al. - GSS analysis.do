****************************************************************************************************************
**																											  **
** This do file is part of the replication material for the following article: 								  **
**  "An Asymmetrical 'President-in-Power' Effect" 											                  **
** 		Authors: Davide Morisi, John Jost, and Vishal Singh													  **
** 		Journal: American Political Science Review															  **
**																											  **
** This file replicates the following things from the article/appendix: 									  **
**	Figure 1 (results for GSS only)
*	Table 1 (results for GSS only)
**	Figure 2 (results for GSS only)
**	Appendix A (results for GSS only)
**	Appendix B (results for GSS only)
**	Appendix C (results for GSS only)
**	Appendix G (results for GSS only)
****************************************************************************************************************

*Starting file
*clear all
*set maxvar 10000
set more off
*use "...\GSS7216_R4_recoded.DTA", clear

global demo1gss "female i.agegroup i.edu i.black i.unempl i.income5anes i.rel4"

*******************************************************************************
*******************************************************************************
*FIGURES AND TABLE IN THE ARTICLE

*
*FIGURE 1. Trust in the government by ideology (GSS)
egen trustlib = mean(trust01) if ideo2==1, by(year)
egen trustcon = mean(trust01) if ideo2==2, by(year)
twoway (scatter trustlib year if year>1970, sort(year) connect(ascending) color(blue) xlabel(1970(2)2016, valuelabel) title("Trust trend GSS")) ///
	(scatter trustcon year if year>1970, sort(year) connect(ascending) color(red) ///	
	xline(1970, lpattern(dash) lcolor(gs10)) text(0.2 1970 "Nixon/Ford", color(gs10) orientation(vertical) placement(2)) ///
	xline(1977, lpattern(dash) lcolor(gs10)) text(0.2 1977 "Carter", color(gs10) orientation(vertical) placement(2)) ///
	xline(1981, lpattern(dash) lcolor(gs10)) text(0.2 1981 "Reagan/Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(1993, lpattern(dash) lcolor(gs10)) text(0.2 1993 "Clinton", color(gs10) orientation(vertical) placement(2)) ///
	xline(2001, lpattern(dash) lcolor(gs10)) text(0.2 2001 "Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(2009, lpattern(dash) lcolor(gs10)) text(0.2 2009 "Obama", color(gs10) orientation(vertical) placement(2)) name(fig1_gss))

*
*TABLE 1. President-in-power effects on trust in the government by ideology (GSS)
*See Table A4 below (same table)

*
*FIGURE 2. President-in-power effects on trust in the government by ideology (GSS)
reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census year [pweight=wtssall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=1) // liberals
marginsplot, recast(bar) plotopts(barw(.8)) name(fig2_gssA)
reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census year [pweight=wtssall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=2) // conservatives
marginsplot, recast(bar) plotopts(barw(.8)) name(fig2_gssB)
reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census year [pweight=wtssall]
margins ideo2, dydx(ownpresLC) post
coefplot, vert yline(0) name(fig2_gssC)
graph combine fig2_gssA fig2_gssB fig2_gssC


*******************************************************************************
*******************************************************************************
*APPENDIX A: Analysis of trust in the government by ideology (GSS)

*
*Table A1. Trust in the government (summary statistics)
ta confed_rec

*
*Table A2. Summary statistics for all variables included in regression models
ta prespower if trust01!=. 
ta ideo3 if trust01!=. 
ta polviews if trust01!=. 
ta partyid3 if trust01!=. 
ta partyid7 if trust01!=. 
ta female if trust01!=. 
ta agegroup if trust01!=. 
ta edu if trust01!=. 
ta black if trust01!=. 
ta unempl if trust01!=. 
ta income5anes if trust01!=. 
ta rel4 if trust01!=. 
ta census if trust01!=. 

*
*Table A4. President-in-power effects on trust in the government by ideology (GSS)
*Panel A
eststo clear
eststo: reg trust01 i.ownpresLC##i.ideo2 [pweight=wtssall]
eststo: reg trust01 i.ownpresLC##i.ideo2 $demo1gss [pweight=wtssall]
eststo: reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census i.preschange [pweight=wtssall]
eststo: reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census year [pweight=wtssall]
esttab using "~TableA4_GSS.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p) title("Table A4. GSS")  compress noeqlines replace 
*Panel B
reg trust01 i.ownpresLC##i.ideo2 [pweight=wtssall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=(1 2))
margins ideo2, dydx(ownpresLC)
reg trust01 i.ownpresLC##i.ideo2 $demo1gss [pweight=wtssall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=(1 2))
margins ideo2, dydx(ownpresLC)
reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census i.preschange [pweight=wtssall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=(1 2))
margins ideo2, dydx(ownpresLC)
reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census year [pweight=wtssall]
margins 0.ownpresLC 1.ownpresLC, at(ideo2=(1 2))
margins ideo2, dydx(ownpresLC)

*
*Table A5. President-in-power effects on trust in the government by ideology, additional models (GSS)
eststo clear
eststo: reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census year ib2.partyid3 [pweight=wtssall]
eststo: reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census year ib2.partyid3 i.partysen i.partyhouse [pweight=wtssall]
esttab using "~TableA5_GSS.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p) title("table A5. gss")  compress noeqlines replace 

*
*Table A8. President-in-power effects on trust in the government by ideology and switch years
*Panel B. GSS
eststo clear
eststo: reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census i.switch [pweight=wtssall] // all
eststo: reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census if switch==1 [pweight=wtssall] // 76/78
eststo: reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census if switch==2 [pweight=wtssall] // 80/82
eststo: reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census if switch==3 [pweight=wtssall] // 91/93
eststo: reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census if switch==4 [pweight=wtssall] // 00/02
eststo: reg trust01 i.ownpresLC##i.ideo2 $demo1gss i.census if switch==5 [pweight=wtssall] // 08/12
esttab using "~TableA8_GSS.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p) title("table A8. gss")  compress noeqlines replace 

*
*Table A9. President-in-power effects on trust in the government by ideology and united/divided Congress (GSS)
eststo clear
eststo: reg trust01 i.ownpresLC##i.ideo2##i.congr_dum $demo1gss ib2.partyid3 i.census year [pweight=wtssall]
esttab using "~TableA9_gss.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p) title("table A9. gss")  compress noeqlines replace 

*
*Figure A1. President-in-power effects on trust in the government by four categories of ideology (GSS)
recode polviews (1/2=1 "(extreme) liberals") (3=2 "sligthly liberals") (4=.) (5=3 "sligthly conservatives") (6/7=4 "(extreme) conservatives"), gen(ideo4)
reg trust01 i.ownpresLC##i.ideo4 $demo1gss i.census year [pweight=wtssall]
margins ideo4, dydx(ownpresLC) 
marginsplot, yline(0) name(figA1_gss)


*******************************************************************************
*******************************************************************************
*APPENDIX B: Analysis of trust in the government by partisanship (GSS)

*
*Figure B1. Trust in the government by partisanship (GSS)
egen trustdem = mean(trust01) if partyid2==1, by(year)
egen trustrep = mean(trust01) if partyid2==2, by(year)
twoway (scatter trustdem year, sort(year) connect(ascending) color(blue) xlabel(1970(2)2016, valuelabel) title("Trust trend GSS")) ///
	(scatter trustrep year, sort(year) connect(ascending) color(red) ///	
	xline(1970, lpattern(dash) lcolor(gs10)) text(0.2 1970 "Nixon/Ford", color(gs10) orientation(vertical) placement(2)) ///
	xline(1977, lpattern(dash) lcolor(gs10)) text(0.2 1977 "Carter", color(gs10) orientation(vertical) placement(2)) ///
	xline(1981, lpattern(dash) lcolor(gs10)) text(0.2 1981 "Reagan/Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(1993, lpattern(dash) lcolor(gs10)) text(0.2 1993 "Clinton", color(gs10) orientation(vertical) placement(2)) ///
	xline(2001, lpattern(dash) lcolor(gs10)) text(0.2 2001 "Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(2009, lpattern(dash) lcolor(gs10)) text(0.2 2009 "Obama", color(gs10) orientation(vertical) placement(2)) name(figB1_gss))

*	
*Table B1. Correlations between party identification and ideology by decades (GSS)
ta year
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
*Table B3. President-in-power effects on trust in the government by partisanship (GSS)
*Panel A
eststo clear
eststo: reg trust01 i.ownpresDR##i.partyid2 [pweight=wtssall]
eststo: reg trust01 i.ownpresDR##i.partyid2 $demo1gss [pweight=wtssall]
eststo: reg trust01 i.ownpresDR##i.partyid2 $demo1gss i.census i.preschange [pweight=wtssall]
eststo: reg trust01 i.ownpresDR##i.partyid2 $demo1gss i.census year [pweight=wtssall]
eststo: reg trust01 i.ownpresDR##i.partyid2 $demo1gss i.census year ib2.ideo3 [pweight=wtssall]
eststo: reg trust01 i.ownpresDR##i.partyid2 $demo1gss i.census year ib2.ideo3 partysen partyhouse [pweight=wtssall]
esttab using "~TableB3_GSS.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("table B3. gss")  compress noeqlines replace 
*Panel B
reg trust01 i.ownpresDR##i.partyid2 [pweight=wtssall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)
reg trust01 i.ownpresDR##i.partyid2 $demo1gss [pweight=wtssall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)
reg trust01 i.ownpresDR##i.partyid2 $demo1gss i.census i.preschange [pweight=wtssall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)
reg trust01 i.ownpresDR##i.partyid2 $demo1gss i.census year [pweight=wtssall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)
reg trust01 i.ownpresDR##i.partyid2 $demo1gss i.census year ib2.ideo3 [pweight=wtssall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)
reg trust01 i.ownpresDR##i.partyid2 $demo1gss i.census year ib2.ideo3 partysen partyhouse [pweight=wtssall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=(1 2))
margins partyid2, dydx(ownpresDR)

*
*Figure B2. President-in-power effects on trust in the government by partisanship (GSS)
reg trust01 i.ownpresDR##i.partyid2 $demo1gss i.census year [pweight=wtssall] // model 4
margins 0.ownpresDR 1.ownpresDR, at(partyid2=1) // democrats
marginsplot, recast(bar) plotopts(barw(.8)) name(figB2_gssA)
reg trust01 i.ownpresDR##i.partyid2 $demo1gss i.census year [pweight=wtssall]
margins 0.ownpresDR 1.ownpresDR, at(partyid2=2) // reublicans
marginsplot, recast(bar) plotopts(barw(.8)) name(figB2_gssB)
reg trust01 i.ownpresDR##i.partyid2 $demo1gss i.census year [pweight=wtssall]
margins partyid2, dydx(ownpresDR) post
coefplot, vert yline(0) name(figB2_gssC)
graph combine figB2_gssA figB2_gssB figB2_gssC


*******************************************************************************
*******************************************************************************
*APPENDIX C: The role of moderates and independents (GSS)

*
*Figure C1. Trust in the government by ideology (time trends including moderates) (GSS)
fre ideo3
egen trustmod = mean(trust01) if ideo3==2, by(year)
twoway (scatter trustlib year, sort(year) connect(ascending) color(blue) xlabel(1970(2)2016, valuelabel) title("Trust trend GSS")) ///
	(scatter trustmod year, sort(year) connect(ascending) color(gs6)) ///	
	(scatter trustcon year, sort(year) connect(ascending) color(red) ///	
	xline(1970, lpattern(dash) lcolor(gs10)) text(0.2 1970 "Nixon/Ford", color(gs10) orientation(vertical) placement(2)) ///
	xline(1977, lpattern(dash) lcolor(gs10)) text(0.2 1977 "Carter", color(gs10) orientation(vertical) placement(2)) ///
	xline(1981, lpattern(dash) lcolor(gs10)) text(0.2 1981 "Reagan/Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(1993, lpattern(dash) lcolor(gs10)) text(0.2 1993 "Clinton", color(gs10) orientation(vertical) placement(2)) ///
	xline(2001, lpattern(dash) lcolor(gs10)) text(0.2 2001 "Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(2009, lpattern(dash) lcolor(gs10)) text(0.2 2009 "Obama", color(gs10) orientation(vertical) placement(2)) name(figC1_gss))

*
*Table C1. President-in-power effects on trust in the government by ideology (including moderates) (GSS)
eststo clear
eststo: reg trust01 i.ownpresLCM##i.ideo3 $demo1gss i.census year ib2.partyid3 [pweight=wtssall]
eststo: reg trust01 i.ownpresLCM##ib2.ideo3 $demo1gss i.census year ib2.partyid3 [pweight=wtssall]
esttab using "~TableC1_GSS.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("table C1. gss")  compress noeqlines replace 

*
*Figure C2. President-in-power effects on trust in the government by ideology (including moderates) (GSS)
reg trust01 i.ownpresLCM##i.ideo3 $demo1gss i.census year ib2.partyid3 [pweight=wtssall]
margins ideo3, dydx(ownpresLCM) post
coefplot, vert yline(0) name(figC2_gss)

*
*Figure C3. Trust in the government by partisanship (time trends including independents) (GSS)
fre partyid3
egen trustind = mean(trust01) if partyid3==2, by(year)
twoway (scatter trustdem year, sort(year) connect(ascending) color(blue) xlabel(1970(2)2016, valuelabel) title("Trust trend GSS")) ///
	(scatter trustind year, sort(year) connect(ascending) color(gs6)) ///	
	(scatter trustrep year, sort(year) connect(ascending) color(red) ///	
	xline(1970, lpattern(dash) lcolor(gs10)) text(0.2 1970 "Nixon/Ford", color(gs10) orientation(vertical) placement(2)) ///
	xline(1977, lpattern(dash) lcolor(gs10)) text(0.2 1977 "Carter", color(gs10) orientation(vertical) placement(2)) ///
	xline(1981, lpattern(dash) lcolor(gs10)) text(0.2 1981 "Reagan/Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(1993, lpattern(dash) lcolor(gs10)) text(0.2 1993 "Clinton", color(gs10) orientation(vertical) placement(2)) ///
	xline(2001, lpattern(dash) lcolor(gs10)) text(0.2 2001 "Bush", color(gs10) orientation(vertical) placement(2)) ///
	xline(2009, lpattern(dash) lcolor(gs10)) text(0.2 2009 "Obama", color(gs10) orientation(vertical) placement(2)) name(figC3_gss))

*
*Table C2. President-in-power effects on trust in the government by partisanship (including independents) (GSS)
eststo clear
eststo: reg trust01 i.ownpresDRI##i.partyid3 $demo1gss i.census year ib2.ideo3 [pweight=wtssall]
eststo: reg trust01 i.ownpresDRI##ib2.partyid3 $demo1gss i.census year ib2.ideo3 [pweight=wtssall]
esttab using "~TableC2_GSS.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("table C2. gss")  compress noeqlines replace 

*
*Figure C4. President-in-power effects on trust in the government by partisanship (including independents) (GSS)
reg trust01 i.ownpresDRI##i.partyid3 $demo1gss i.census year ib2.ideo3 [pweight=wtssall]
margins partyid3, dydx(ownpresDRI) post
coefplot, vert yline(0) name(figC4_gss)


*******************************************************************************
*******************************************************************************
*APPENDIX G: Analysis of changing effects over time

*
*Figure G1. Change in “trust gap” by ideology and partisanship over time (GSS)
preserve
	collapse (mean) trustlib trustcon trustdem trustrep, by(year)
	gen trustgap_ideo = abs(trustlib-trustcon)
	gen trustgap_pid = abs(trustdem-trustrep)
	twoway (scatter trustgap_ideo year, sort(year) connect(ascending) color(green) xlabel(1972(4)2016, valuelabel) xtitle("Years") ytitle("Trust gap (absolute values)") title("GSS")) ///
	  (scatter trustgap_pid year, sort(year) connect(ascending) color(orange) name(figG1_gss)) ///
	  (lfit trustgap_ideo year, color(green) lpattern(dash))  (lfit trustgap_pid year, color(orange) lpattern(dash))

	*Table G1. Regressions of “trust gap” on time variables (GSS)
	*Column 3 (ideology)
	gen trustgap_ideo100 = trustgap_ideo*100 // rescale DV from 0 to 100
	eststo clear
	eststo: reg trustgap_ideo100 year
	*Column 4 (pid)
	gen trustgap_pid100 = trustgap_pid*100
	eststo: reg trustgap_pid100 year
	esttab using "~TableG1_gss.rtf", ///
	b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table G1. gss")  compress noeqlines replace 


*
*Table G2. President-in-power effects on trust in the government by ideology and time variables (GSS)
eststo clear
eststo: reg trust01 i.ownpresLC##i.ideo2##c.year $demo1gss i.census [pweight=wtssall]
esttab using "~TableG2_GSS.rtf", ///
b(%6.3f) se(%6.3f) starlevels(* .05 ** .01 *** .001)  scalars (r2_a r2_p bic aic) title("Table G2. gss")  compress noeqlines replace 


*
*Figure G2. President-in-power effects on trust in the government by time variables (difference between conservatives and liberals) (GSS)
reg trust01 i.ownpresLC##i.ideo2##c.year $demo1gss i.census [pweight=wtssall]
margins r.ideo2, dydx(ownpresLC) at(year==(1972(4)2016))
marginsplot, yline(0) name(figG2_gss)







