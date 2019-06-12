*********************************************************
*                                                       *
* International Treaty Ratification and Leader Turnover *
*                                                       *
* Tobias Böhmelt                                        *
*                                                       *
* University of Essex & ETH Zürich                      *
*                                                       *
* Address Correspondance to: tbohmelt@essex.ac.uk       *
*                                                       *
* This Version: August 1, 2017                          *
*                                                       *
*********************************************************

*************
* Open Data *
*************

use "FPA Data.dta", clear

************************************
* Table 1 - Descriptive Statistics *
************************************

sum ratification solschdum_exo election_dummy number_ratified_max polity_first_year securitycrime environment trade humanrights powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3

collin solschdum_exo election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap

*************************
* Table 2 - Main Models *
*************************

eststo clear

eststo: logit ratification solschdum_exo rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
epcp
estimates store logit1
fitstat

eststo: logit ratification election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
epcp
estimates store logit2
fitstat

eststo: logit ratification solschdum_exo election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
epcp
estimates store logit3
fitstat

esttab logit1 logit2 logit3, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label

*************************************************
* Figure 2 - Substantive Quantities of Interest *
*************************************************

preserve

estsimp logit ratification solschdum_exo election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)

setx median
simqi, fd(prval(1)) changex(solschdum_exo min max) level(90)
simqi, fd(prval(1)) changex(election_dummy min max) level(90)
simqi, fd(prval(1)) changex(number_ratified_max min max) level(90)
simqi, fd(prval(1)) changex(polity_first_year min max) level(90)
simqi, fd(prval(1)) changex(securitycrime min max) level(90)
simqi, fd(prval(1)) changex(environment min max) level(90)
simqi, fd(prval(1)) changex(trade min max) level(90)
simqi, fd(prval(1)) changex(powermilit_first_year min max) level(90)
simqi, fd(prval(1)) changex(openk_first_year min max) level(90)
simqi, fd(prval(1)) changex(NUMIGO_first_year min max) level(90)
simqi, fd(prval(1)) changex(leg_ap min max) level(90)

setx median
setx solschdum_exo min
simqi, prval(1) level(84)
setx solschdum_exo max
simqi, prval(1) level(84)

generate var57 = 0.8575566 in 1
replace var57 = 0.5535766 in 2
generate var58 = 0.815474 in 1
replace var58 = 0.4619174 in 2
generate var59 = 0.8939391 in 1
replace var59 = 0.6394741 in 2

qui logit ratification solschdum_exo election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
sum solschdum_exo election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3 if e(sample), detail
gen sim_probs=(exp(b15*1+b1*0+b2*1+b3*68+b4*7+b5*0+b6*0+b7*0+b8*-.0079326+b9*64.51057+b10*69+b11*1+b12*0+b13*0+b14*0))/(1+(exp(b15*1+b1*0+b2*1+b3*68+b4*7+b5*0+b6*0+b7*0+b8*-.0079326+b9*64.51057+b10*69+b11*1+b12*0+b13*0+b14*0)))
gen sim_probs2=(exp(b15*1+b1*1+b2*1+b3*68+b4*7+b5*0+b6*0+b7*0+b8*-.0079326+b9*64.51057+b10*69+b11*1+b12*0+b13*0+b14*0))/(1+(exp(b15*1+b1*1+b2*1+b3*68+b4*7+b5*0+b6*0+b7*0+b8*-.0079326+b9*64.51057+b10*69+b11*1+b12*0+b13*0+b14*0)))

generate var63 = 0.5 in 1
replace var63 = 0.5 in 2
generate var64 = 1 in 1
replace var64 = 2 in 2

twoway (scatter var63 var57 if var64==1) (rcap var58 var59 var63 if var64==1, horizontal msize(zero)) (scatter var63 var57 if var64==2) (rcap var58 var59 var63 if var64==2, horizontal msize(zero)) kdensity sim_probs || kdensity sim_probs2, scheme(lean1) legend(off) aspectratio(1)

restore

*******************************
* Table 3 - Additional Models *
*******************************

eststo clear

eststo: logit ratification solschdum_exo minimum rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
epcp
estimates store logit11
fitstat

eststo: logit ratification minimum election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
epcp
estimates store logit12
fitstat

eststo: logit ratification solschdum_exo minimum election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
epcp
estimates store logit13
fitstat

esttab logit11 logit12 logit13, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label

***************************
* Supplementary Materials *
***************************

****** Table A1 ******

eststo clear

preserve

sum year_diff
keep if year_diff<r(mean)

eststo: logit ratification solschdum_exo election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
estimates store logit4
fitstat

esttab logit4, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label

restore

****** Table A2 ******

eststo clear

eststo: logit ratification solschdum_exo election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3, vce(bootstrap, rep(1000))
estimates store logit5
fitstat

esttab logit5, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label

****** Table A3 ******

eststo clear

stset year_diff, failure(ratification) id(dyad2)

eststo: stcox solschdum_exo election_dummy number_ratified_max polity_first_year powermilit_first_year openk_first_year NUMIGO_first_year leg_ap, cluster(ccode) efron nohr strata(humanrights securitycrime environment trade)
estimates store stcox6

esttab stcox6, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label
 
****** Table A4 ******

eststo clear

use "FPA Country-Treaty-Year.dta", clear

eststo: stcox solschdum_exo any_election NUMIGO number_ratified_per_year ppolity2 powermilit openk leg_ap, tvc(any_election NUMIGO number_ratified_per_year ppolity2 powermilit openk leg_ap) texp(ln(_t)) efron nohr cluster(ccode) strata(humanrights securitycrime environment trade)
estimates store stcox7

eststo: logit status solschdum_exo any_election NUMIGO number_ratified_per_year ppolity2 powermilit openk securitycrime environment trade leg_ap ratyears ratyears2 ratyears3, cluster(ccode)
estimates store logit8

esttab stcox7 logit8, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label

****** Table A5 and Figure A1 ******

use "FPA Data.dta", clear

preserve

logit ratification i.solschdum_exo##c.polity_first_year election_dummy number_ratified_max securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
fitstat

margins, dydx(solschdum_exo) at(polity_first_year=(-10(1)10)) vsquish
marginsplot, level(90) recast(line) recastci(rline) name(graph1, replace) addplot (histogram polity_first_year, xlabel(-10(1)10) yaxis(2) blcolor(gray) bfcolor(none)) legend(off)

restore

****** Table A6 ******

eststo clear

preserve

qui tab ccode, gen(fes)
eststo: logit ratification solschdum_exo election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3 fes*, cluster(ccode)
estimates store logit10
fitstat

esttab logit10, aic se star(* 0.10 ** 0.05 *** 0.01) b(%9.3f) label

restore

****** Figure A2 ******

logit ratification solschdum_exo rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
predict phat if e(sample)
logit ratification election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
predict phat2 if e(sample)
logit ratification solschdum_exo election_dummy number_ratified_max polity_first_year securitycrime environment trade powermilit_first_year openk_first_year NUMIGO_first_year leg_ap rat_yrs rat_yrs2 rat_yrs3, cluster(ccode)
predict phat3 if e(sample)

keep ratification phat phat2 phat3
drop if phat==.
drop if phat2==.
drop if phat3==.

export delimited using "test.csv", replace

* Switch to R -- Change Working Directory *

library(separationplot) 

df <- read.csv("/Users/tobiasbohmelt/polybox/Treaty Ratification and Leadership/1_New Data/test.csv")  

separationplot(pred=df$phat, actual=df$ratification, type="rect", show.expected=TRUE)
separationplot(pred=df$phat2, actual=df$ratification, type="rect", show.expected=TRUE)
separationplot(pred=df$phat3, actual=df$ratification, type="rect", show.expected=TRUE)

