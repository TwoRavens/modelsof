 
*     ***************************************************************** *;
*     ***************************************************************** *;
*       File-Name:      Extralegal_analysis_final.do                  	*;
*       Date:           03/14/2017                                      *;
*       Author:         Baccini & Chow                      			*;
*       Purpose:        Replication of "The Politics of Preferential    *;
*						Trade Liberalization in Authoritarian Countries"*;                                                                      
*       Input Files:    Extralegal_PTA_Main.dta 		&				*;
*						Extralegal_PTA_Monadic.dta 		&				*; 
*                       Extralegal_PTA_Figures1_2   	&               *;
*						Extralegal_PTA_Appendix							*;
*       Output Files:   GINI_logfile                                    *;
*       Machine:        Office                                          *;
*       Program: 		Stata 14                                        *;
*     ****************************************************************  *;
*     ****************************************************************  *;

cd "\Replication_BacciniChow"
use Extralegal_PTA_Main, clear
log using GINI_logfile.log
set more off 

* Setting up survival time
gen year1=year+1
gen month=1
gen day=1
gen myend=mdy( month, day, year1)
gen mybegin=mdy(month, day, year)
stset myend, id(id) time0(mybegin) origin(time mybegin) failure(pta==1) exit(time .) scale(365.25)

* Generating controls
global baseline distln exportln_l gdpln_a_l gdpln_b_l
global full distln exportln_l gdpln_a_l gdpln_b_l gattwto_l gdppcln_a_l ///
	   gdppcln_b_l gdp_growth_a_l gdp_growth_b_l armconflict_l polity2_a_l polity2_b_l ///
	   party_a_l military_a_l personal_a_l 
global ecm_controls l.distln d.exportsln l.exportsln d.gattwto l.gattwto ///
	   d.gdpln_a l.gdpln_a d.gdpln_b l.gdpln_b d.gdppcln_a l.gdppcln_a d.gdppcln_b ///
	   l.gdppcln_b l.armconflict d.armconflict d.polity2_a l.polity2_a d.polity2_b ///
	   l.polity2_b d.party_a l.party_a d.military_a l.military_a d.personal_a_l ///
	   d.personal_a l.personal_a

##### Table 1

*(1)
quietly xi: stcox entry1_l $baseline, cluster(id) r nohr efron strata(year)
outreg2 using table1.xls, bdec(2) sdec(2) ctitle(Cox Model) label ///
addtext(Year FE, YES, Full Model, NO) keep(entry1_l $baseline) append

*(2)
quietly xi: stcox entry1_l $full, cluster(id) r nohr efron strata(year)
outreg2 using table1.xls, bdec(2) sdec(2) ctitle(Cox Model) label ///
addtext(Year FE, YES, Full Model, YES) keep(entry1_l $full) append

*(3)
quietly xi: tobit Depth_rasch1 entry1_l $baseline i.year, r cluster(id) ll(0)
outreg2 using table1.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(entry1_l $baseline) ctitle(Tobit Model) label addtext(Year FE, YES, Full Model, NO) append

*(4)
quietly xi: tobit Depth_rasch1 entry1_l $full i.year,r cluster(id) ll(0)
outreg2 using table1.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(entry1_l $full) ctitle(Tobit Model) label addtext(Full Model, YES, Year FE, YES) append


#### Table 2

*(5)
quietly xi: stcox c.tenure##entry1_l $full, cluster(id) r nohr efron strata(year)
outreg2 using table2.xls, bdec(3) sdec(3) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(c.tenure##entry1_l) ctitle(Cox Model) label addtext(Year FE, YES, Full Model, YES) append	

*(6)
quietly xi: tobit Depth_rasch1 c.tenure##entry1_l $full i.year, r cluster(id) ll(0)
outreg2 using table2.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(c.tenure##entry1_l) ctitle(Tobit Model) label addtext(Full Model, YES, Year FE, YES) append

*Figure 3

quietly margins, dydx(entry1_l) at( tenure=(1(8)49)) atmeans
marginsplot, addplot(histogram tenure if e(sample),  percent fcolor(none) ///
		lcolor(gs5) yaxis(2) yscale(alt  axis(2)) xlabel(0(5)50) ytitle("Percent (Tenure)", axis(2))) ///
		level(90) xlabel(0(5)50) graphregion(color(white)) xtitle("Tenure") ///
		ytitle("Marginal Effects of Extralegal Leader on Depth") legend(off) ///
		title("") scheme(s2mono) plotopts(mcolor(gs0) lcolor(gs0)) ciopts(lpattern(dash) lcolor(gs0)) 
graph save tenure.gph, replace


*(7) 
quietly reg d.Depth_rasch1 l.Depth_rasch1 d.entry1 l.entry1 $ecm_controls, r cluster(id) 
outreg2 using table2.xls, bdec(3) sdec(3) keep(l.Depth_rasch1 d.entry1 l.entry1) ///
ctitle(ECM) label addtext(Full Model, YES, Year FE, NO) 
* Bewley transformation: the coefficient of entry1_l is the LONG TERM MULTIPLIER
xi: ivreg2 Depth_rasch1 d.entry1 l.entry1 $ecm_controls (d.Depth_rasch1 = l.Depth_rasch1 d.entry1 d.entry1 $ecm_controls), r cluster(id)  

*(8)
quietly xi: tobit Depth_rasch1 c.BS_couprisk_l##entry1_l $full i.year,r cluster(id) ll(0)
outreg2 using table2.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(c.BS_couprisk_l##entry1_l) ctitle(Tobit Model) label addtext(Full Model, YES, Year FE, YES) 

*Figure 4

quietly margins, dydx(entry1_l) at( BS_couprisk_l=(6(3)12)) atmeans
marginsplot, addplot(histogram BS_couprisk_l if e(sample), percent fcolor(none) ///
			 lcolor(gs5) yaxis(2) yscale(alt  axis(2)) ytitle("Percent (Coup Risk)", axis(2))) ///
			 level(90) graphregion(color(white)) xtitle("Coup Risk") ytitle("Marginal Effects of Extralegal Leader on Depth") ///
			 title("")  scheme(s2mono) plotopts(mcolor(gs0) lcolor(gs0)) ciopts(lpattern(dash) lcolor(gs0)) ///
			 legend(off) 
graph save BS_couprisk.gph, replace


*(9)
quietly xi: tobit Depth_rasch1 c.trade_open_l##entry1_l $full i.year, r cluster(id) ll(0)
outreg2 using table2.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(c.trade_open_l##entry1_l) ctitle(Tobit Model) label addtext(Full Model, YES, Year FE, YES) append

*Figure 5

quietly margins, dydx(entry1_l) at( trade_open_l=(0(.2)1)) atmeans
marginsplot, addplot(histogram trade_open_l if trade_open_l>0 & e(sample),  percent ///
			 fcolor(none) lcolor(gs5) yaxis(2) yscale(alt  axis(2)) ytitle("Percent (Trade Openness)", axis(2))) ///
			 level(90) graphregion(color(white)) xtitle("Trade Openness") ///
			 ytitle("Marginal Effects of Extralegal Leader on Depth") legend(off) ///
			 title("") scheme(s2mono) plotopts(mcolor(gs0) lcolor(gs0)) ciopts(lpattern(dash) lcolor(gs0)) 
graph save trade.gph, replace


#### Table 3

*(10)
quietly xi: tobit Enforcement1 entry1_l $baseline i.year, r cluster(id) ll(0)
outreg2 using table3.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(entry1_l) ctitle(Tobit Model) label addtext(Including colonizer & ///
U.S. dummies, NO, Including Cold War dummy, NO, Full Model, NO, Year FE, YES)

*(11)
quietly xi: tobit Depth_rasch1 entry1_l entry1_l#c.polity2_b_l $full i.year,r cluster(id) ll(0)
outreg2 using table3.xls, bdec(3) sdec(3) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(entry1_l polity2_b_l entry1_l#c.polity2_b_l) ctitle(Tobit Model) label addtext(Including colonizer ///
& U.S. dummies, NO, Including Cold War dummy, NO, Full Model, YES, Year FE, YES) append

*(12)
quietly xi: tobit Depth_rasch_NS entry1_l $full i.year,r cluster(id) ll(0)
outreg2 using table3.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(entry1_l) ctitle(Tobit Model -- NS PTAs) label  addtext(Including ///
colonizer & U.S. dummies, NO, Including Cold War dummy, NO, Full Model, YES, Year FE, YES)  append

*(13)
quietly xi: tobit Depth_rasch_SS entry1_l $full i.year,r cluster(id) ll(0)
outreg2 using table3.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(entry1_l) ctitle(Tobit Model -- SS PTAs) label addtext(Including colonizer ///
& U.S. dummies, NO, Including Cold War dummy, NO, Full Model, YES, Year FE, YES)  append

*(14)
quietly xi: tobit Depth_rasch1 entry1_l fra-usa $full i.year,r cluster(id) ll(0)
outreg2 using table3.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(entry1_l) ctitle(Tobit Model -- NS PTAs) label addtext(Including colonizer ///
& U.S. dummies, YES, Including Cold War dummy, NO, Full Model, YES, Year FE, YES) append

*(15)
quietly xi: tobit Depth_rasch1 entry1_l cold_war $full i.year,r cluster(id) ll(0)
outreg2 using table3.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(entry1_l) ctitle(Tobit Model -- NS PTAs) label addtext(Including ///
colonizer & U.S. dummies, NO, Including Cold War dummy, YES, Full Model, YES, Year FE, YES) append


#### Table 4
/*
Note: reg3hdfe package for Stata must be manually applied. This package can be 
downloaded at https://www.aeaweb.org/articles?id=10.1257/mac.4.2.133
*/

egen it=group(iso1 year)
egen jt=group(iso2 year)

*(16)
reg3hdfe exportsln pta_l gattwto_l if entry1==1, id1(it) id2(jt) id3(id) tol(0.01)
outreg2 using table4.xls, bdec(2) sdec(2) e(rmse) keep(pta_l gattwto_l) ///
addtext(Country A-year FE, YES, Country B-year FE, YES, Dyad effects, YES) label

*(17)
reg3hdfe exportsln Depth_rasch1_l gattwto_l if entry1==1, id1(it) id2(jt) id3(id) tol(0.01)
outreg2 using table4.xls, bdec(2) sdec(2) e(rmse) keep(Depth_rasch1_l gattwto_l) ///
addtext(Country A-year FE, YES, Country B-year FE, YES, Dyad effects, YES) label append

*(18)
reg3hdfe exportsln Enforcement1_l gattwto_l if entry1==1, id1(it) id2(jt) id3(id) tol(0.01)
outreg2 using table4.xls, bdec(2) sdec(2) e(rmse) keep(Enforcement1_l gattwto_l) ///
addtext(Country A-year FE, YES, Country B-year FE, YES, Dyad effects, YES) label append


########################
#### FIGURES 1 & 2 #####
########################

use Extralegal_PTA_Figures1_2, clear

set scheme s2mono	/* Setting gray-scale for figures */

 * Setup for survival analysis
gen year1 = year+1
gen month=1
gen day=1
gen myend=mdy(month,day,year1)
gen mybegin=mdy(month,day,year)

stset myend, id(leadid) time0(mybegin) origin(time mybegin) ///
failure(coup_attempt=1) exit(time .) scale(365.25)

******************

*** Figure 1: Mode of Entry, Insiders, and Outsiders
** Note: Figure 1 requires the coefplot package for Stata (ssc install coefplot)

quietly proportion insider, over(entry)
estimates store insider1

coefplot insider1, keep(_prop_2:) ///
	vertical xtitle("") ytitle("Proportion of Regime Insiders") ///
	graphregion(color(white)) ///	
	ylabel(0(.2).8) ///
	recast(bar) barwidth(1) fcolor(*.2) ///
	xlabel(1 "Legal" 2 "Extralegal") ///
	legend( order(1 "Regime Insider" 2 "95% Confidence Interval"  )) ///
	title("", color(black)) ///
	ciopts(recast(rcap) color(black) lwidth(.4)) citop citype(logit) 

*graph save Figure1.gph, replace
	
*** Figure 2: Mode of Entry and Coup Risk

sts graph, hazard ci by(entry) noboundary ///
	xlab(0(5)30) graphregion(color(white)) ///
	xtitle("Years in Power") ///
	ytitle("Hazard of Coup Attempt") title("") ///
	legend(label(5 "Legal") label(6 "Extralegal") ///
	label(1 "95% Confidence Interval") label(3 "95% Confidence Interval") ///
	order(6 3 5 1))

*graph save Figure2.gph, replace


######################
###### APPENDIX ######
######################

use Extralegal_PTA_Main, clear

global baseline distln exportln_l gdpln_a_l gdpln_b_l
global full distln exportln_l gdpln_a_l gdpln_b_l gattwto_l gdppcln_a_l ///
	   gdppcln_b_l gdp_growth_a_l gdp_growth_b_l armconflict_l polity2_a_l ///
	   polity2_b_l party_a_l military_a_l personal_a_l 

##### Table A1

quietly xi: tobit Depth_rasch1 entry1_l $baseline i.year, r cluster(id) ll(0)
sum Depth_rasch1 entry1_l distln exportln_l gdpln_a_l gdpln_b_l if e(sample)

quietly xi: tobit Depth_rasch1 entry1_l $full i.year,r cluster(id) ll(0)
sum gattwto_l gdppcln_a_l gdppcln_b_l gdp_growth_a_l gdp_growth_b_l armconflict_l  polity2_b_l party_a_l military_a_l personal_a_l if e(sample)

quietly xi: tobit Depth_rasch1 c.tenure##entry1_l $full i.year, r cluster(id) ll(0)
sum tenure if e(sample)

quietly xi: tobit Depth_rasch1 c.BS_couprisk_l##entry1_l $full i.year,r cluster(id) ll(0)
sum BS_couprisk_l if e(sample)

quietly xi: tobit Depth_rasch1 c.trade_open_l##entry1_l $full i.year, r cluster(id) ll(0)
sum trade_open if e(sample)

##### Table A2

*(A1)
quietly xi: tobit Depth_rasch1 entry1_l major_power $full i.year,r cluster(id) ll(0)
outreg2 using table5.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') keep(entry1_l) ctitle(Tobit Model) label ///
addtext(Including major powers, YES, Including oil, NO, Full Model, YES, Year FE, YES, ///
Dyad FE, NO, Country FE, NO) 

*(A2)
quietly xi: nbreg hr_treaties entry1_l $full i.year,r cluster(id)
outreg2 using table5.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(entry1_l) ctitle(NBREG) label addtext(Including major powers, NO, Including oil, NO, ///
Full Model, YES, Year FE, YES, Dyad FE, NO, Country FE, NO) append

*(A3)
quietly xi: tobit Depth_rasch_neg entry1_l $full i.year,r cluster(id) ll(0)
outreg2 using table5.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(entry1_l) ctitle(Tobit Model) addtext(Including major powers, NO, Including oil, ///
NO, Full Model, YES, Year FE, YES, Dyad FE, NO, Country FE, NO) append

*(A4)
quietly xi: tobit Depth_rasch1 entry1_l lnoil_prod_l $full i.year,r cluster(id) ll(0)
outreg2 using table5.xls, bdec(2) sdec(2) addstat(Pseudo R-squared, `e(r2_p)') ///
keep(entry1_l) ctitle(Tobit Model) label addtext(Including major powers, NO, ///
Including oil, YES, Full Model, YES, Year FE, YES, Dyad FE, NO, Country FE, NO)  append

*(A5)
quietly xi: reg Depth_rasch1 entry1_l $full i.year i.iso1,r cluster(id) 
outreg2 using table5.xls, bdec(2) sdec(2) keep(entry1_l ) ctitle(OLS Model) ///
label addtext(Including major powers, NO, Including oil, NO, Full Model, YES, ///
Year FE, YES,Dyad FE, NO, Country FE, YES) append

*(A6)
quietly xi: xtreg Depth_rasch1 entry1_l $full i.year,r cluster(id) fe
outreg2 using table5.xls, bdec(2) sdec(2) keep(entry1_l ) ctitle(OLS Model) ///
addtext(Including major powers, NO, Including oil, NO, Full Model, YES, ///
Year FE, YES, Dyad FE, YES, Country FE, NO) append


##### Table A3

use Extralegal_PTA_Monadic, clear
xtset iso1 year
global full_monadic l.trade_open l.gdpln_a l.gdppcln_a l.gdpgrowth_a l.polity2_a 

*(A7)
xi: reg Depth_rasch1 l.entry1 $full_monadic i.year, r cluster(iso)
outreg2 using table6.xls, bdec(2) sdec(2) addstat(R-squared, `e(r2)') ///
keep(l.entry1) ctitle(OLS Model) label addtext(Full Model, YES, Year FE, YES) 

*(A8)
xi: reg Enforcement1 l.entry1 $full_monadic i.year, r cluster(iso1)
outreg2 using table6.xls, bdec(2) sdec(2) addstat(R-squared, `e(r2)') ///
keep(l.entry1) ctitle(OLS Model) label addtext(Full Model, YES, Year FE, YES) append

*(A9)
xi: reg Depth_rasch1 c.tenure##l.entry1 $full_monadic i.year, r cluster(iso1)
outreg2 using table6.xls, bdec(3) sdec(3) addstat(R-squared, `e(r2)') ///
keep(c.tenure##l.entry1) ctitle(OLS Model) label addtext(Full Model, YES, Year FE, YES) append

*(A10)
gen BS_couprisk_l = l.BS_couprisk /* generate lagged BS_couprisk for interaction term */
xi: reg Depth_rasch1 c.BS_couprisk_l##l.entry1 $full_monadic i.year, r cluster(iso1)
outreg2 using table6.xls, bdec(2) sdec(2) addstat(R-squared, `e(r2)') ///
keep(c.BS_couprisk_l##l.entry1) ctitle(OLS Model) label addtext(Full Model, YES, Year FE, YES) append
 

#################################
#### FIGURES A1, A2, and A3 #####
#################################

use Extralegal_PTA_Appendix, clear

gen year1=year+1
gen month=1
gen day=1
gen myend=mdy( month, day, year1)
gen mybegin=mdy(month, day, year)

* Figure A1
stset myend, id(id) time0(mybegin) origin(time mybegin) failure(pta==1) exit(time .) scale(365.25)
sts graph, by(entry1) ci haz level(99) ///
	graphregion(color(white)) xtitle("Time Span") ///
	ytitle("") title("Hazard estimates - PTA Formation") ///
	legend(label(5 "Legal") label(6 "Extralegal") ///
	label(1 "99% Confidence Interval") label(3 "99% Confidence Interval") ///
	order(6 3 5 1)) scheme(s2mono)
*graph save pta_hz.gph, replace

* Figure A2
preserve

collapse Depth_rasch Enforcement, by(number)
kdensity Depth_rasch, xline(.572, lpattern(dash))  graphregion(color(white)) xtitle("PTA Depth") ///
		 ytitle("Density") scheme(s2mono) title("") xlabel(1 2 3 4)
*graph save depth.gph, replace

* Figure A3
kdensity Enforcement, xline(1.06, lpattern(dash)) graphregion(color(white)) ///
		 xtitle("PTA Enforcement") ytitle("Density") scheme(s2mono) title("") xlabel(1 2 3 4)
*graph save enforcement.gph, replace

restore 
