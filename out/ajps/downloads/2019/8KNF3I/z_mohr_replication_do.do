*﻿*************************************************************************************************************
* Replication do-file for "Strategic Spending: Does Politics Influence Election Administration Expenditure?" 
*************************************************************************************************************

*Mohr, Zachary T., Pope, JoEllen V., Kropf, Martha E.,Shepherd, Mary J. 2019. "Strategic Spending: Does Politics Influence Election Administration Expenditure?"


/*open a log file*/
capture mkdir "c:\stata"
log using "c:\stata\replication_log.log", replace

***************************
* Variable Transformations
***************************

/*save data file to working directory/
/use AJPS_strategic_spending_original_data.dta, clear*/

/*Install xtabond2 package*/
ssc install xtabond2, replace
/*Stata/IC 14.2 (64-bit x86-64) and xtabond2, version 03.06.00*/
sort county year
xtset county year, delta(2)
set scheme s1mono
set more off


/*Used US DOL BLS CPI U Research Series using current methods 1977-2016 
  pulled prior to updating 2010-2015 to adjust to 2016 dollars*/
/*https://www2.census.gov/programs-surveys/demo/tables/p60/259/CPI_U_RS.xlsx*/

/*total election expenditures per registered voter from NC Treasurer AFIR
https://www.nctreasurer.com/slg/lfm/forms-instructions/Pages/Annual-Financial-Information-Report.aspx*/
/*adjusted to 2016 dollars*/
replace electop=electwages+electother if electop==.
gen totelectspend= electop+electconst+electfixed
gen adjtotelectspend=totelectspend/cpi*352.6
gen adjtotexpvoter=adjtotelectspend/registered
gen lnadjtotexpvoter=ln(adjtotexpvoter)
sort county year
gen lag1lnadjtotexpvoter=l.lnadjtotexpvoter
gen lag2lnadjtotexpvoter=l2.lnadjtotexpvoter
gen adjtotexpvoterchg=adjtotexpvoter-l.adjtotexpvoter
gen lag1adjtotexpvoter=l.adjtotexpvoter
gen lag2adjtotexpvoter=l2.adjtotexpvoter

/*voting age population total and stratified,NC LINC*/
/*age*/
gen pervapu25= totvapunder25/vap * 100
gen pervapo64= totvapover64/vap * 100
gen pervap25to64 =totvap25to64/vap * 100 
gen lnpervapu25= ln(pervapu25)
gen lnpervapo64= ln(pervapo64)
gen lnpervap25to64 = ln(pervap25to64)

/*white and nonwhite*/
gen pervapw = whitevap/vap*100
gen pervapnw = nonwhitevap/vap*100

/*votes cast for president in general election NC LINC*/
gen percrepvote=votesreppres/votespres*100

/*public high school graduation rate per enrollment NC LINC*/
gen pubhsgradrate=pubshgrads/pubhsenroll*100

/*total property value in $1000's from 
NC LINC http://data.osbm.state.nc.us/pls/linc/dyn_linc_main.show*/
/*adjust to 2016 dollars*/
gen adjtotpropval000=totpropval000/cpi*352.6
gen adjtotpropval000percap=adjtotpropval000/totpop
gen lnadjtotpropval000percap=ln(adjtotpropval000percap)
gen lag1lnadjtotpropval000percap=l.lnadjtotpropval000percap

/*number of precincts and registered voters per pct*/
gen avgvotepct=registered/votepct
gen lnavgvotepct=ln(avgvotepct)

/*population versus log of population*/
gen lntotpop=ln(totpop)

/*voting equipment for spending*/
gen punchcard=1 if votequip==1
replace punchcard=0 if punchcard==.
gen leverbudget=1 if votequip==3
replace leverbudget=0 if leverbudget==.
gen paperbudget=1 if votequip==4
replace paperbudget=0 if paperbudget==.
gen drebudget=1 if votequip==6 | votequip==9
replace drebudget=0 if drebudget==.
gen opticalbudget=1 if votequip==5 | votequip==8
replace opticalbudget=0 if opticalbudget==.

/*voting equipment coding for model switch*/
gen mod_switch=0 if year!=1994
replace mod_switch=1 if vemodelcode!=l.vemodelcode & year!=1994

****************
* Manuscript
****************

/*xtabond2 logs model for manuscript Table 1*/
#delimit ;
xtabond2 lnadjtotexpvoter lag1lnadjtotexpvoter lag2lnadjtotexpvoter
  lntotpop punchcard leverbudget paperbudget drebudget section5 lnavgvotepct lnadjtotpropval000percap pervapnw 
  lnpervapu25 lnpervapo64 mod_switch msacategory2 pubhsgradrate 
  c.percrepvote##i.partcommrep ib(1998).year if registered>6500, 
  gmm(lag1lnadjtotexpvoter lag2lnadjtotexpvoter  lag1lnadjtotpropval000percap, collapse) iv( punchcard leverbudget 
  paperbudget drebudget section5 lnavgvotepct 
  msacategory2 mod_switch pervapnw  lnpervapu25 lnpervapo64 pubhsgradrate 
  c.percrepvote##i.partcommrep lntotpop  ib(1998).year, eq(level)) robust twostep;
#delimit cr

/*Marginal effects Figure 1*/
quietly margins,dydx(partcommrep) at(percrepvote=(25(.5)75))  
#delimit ;
marginsplot,  recast(line) recastci(rline) plotopts(lpattern(longdash)) ciopts(lpattern(dash)) yline(0) xlabel(25(5)75) 
  plotregion(lcolor(black)) graphregion(lcolor(black)) ylab( ,nogrid ) title(" ") 
  xtitle(Presidential Votes Cast for the Repulican Candidate (% of Total Votes)) 
  ytitle(Effect on Election Admin Expenditures (ln $/Registered Voter)) name(manuscriptfig1, replace);
#delimit cr

/*Predicted marigins Figure 2*/
quietly margins, at(percrepvote=(25(.5)75)partcommrep=(0 1))
#delimit ;
marginsplot,  recast(line) recastci(rline) ci2opts(lpattern(dash)) yline(0) xlabel(25(5)75) plot2opts(lpattern(longdash)) 
  plotregion(lcolor(black)) graphregion(lcolor(black)) ylab( ,nogrid ) title(" ") 
  xtitle(Presidential Votes Cast for the Repulican Candidate (% of Total Votes)) 
  ytitle(Election Admin Expenditures (ln $/Registered Voter)) name(manuscriptfig2, replace);
#delimit cr

/*Determine the % votes cast for Rep Pres where Rep partisanship of commission
is significantly different from not Rep partisanshp*/
lincom 1.partcommrep + 1.partcommrep#c.percrepvote*57.5
/*No significant difference at 57.5*/
lincom 1.partcommrep + 1.partcommrep#c.percrepvote*57.6
/*Significant difference at 57.6*/

/*Determine dollar amounts at breakover point*/
margins, at(percrepvote=(57.6)partcommrep=(1))
display exp(2.027604)
/*$7.60*/
margins, at(percrepvote=(57.6)partcommrep=(0))
display exp(2.138365)
/*$8.49*/
display 8.49-7.60
/*Difference of $0.89*/
/*Determine average over all counties over all years 1994-2014 (delta 2)*/
sum adjtotexpvoter
/*Determine percentage difference is of average*/
display 0.89/8.67*100

/*Determine dollar amounts at 65% votes cast for Rep Pres*/
margins, at(percrepvote=(65)partcommrep=(1))
display exp(2.007762)
/*$7.45*/
margins, at(percrepvote=(65)partcommrep=(0))
display exp(2.194502)
/*$8.98*/
display 8.98-7.45
/*Difference of about $1.53*/
/*Determine percentage difference is of average*/
display 1.53/8.67*100

*************************
* Appendix
*************************

/*Descriptives Appendix Table 2*/
#delimit ;
xtsum lnadjtotexpvoter percrepvote partcommrep lntotpop opticalbudget
  punchcard leverbudget paperbudget drebudget mod_switch section5 lnavgvotepct 
  lnadjtotpropval000percap pervapnw lnpervapu25 lnpervapo64 
  msacategory2 pubhsgradrate  ;
#delimit cr

/*Additional modeling discussion*/
/*fisher-type unit root test Table 3*/
/*use ADF unit-root tests specify lag structure for prewhitening*/
xtunitroot fisher lnadjtotexpvoter, dfuller lags(0)
xtunitroot fisher lnadjtotexpvoter, dfuller lags(1)
xtunitroot fisher lnadjtotexpvoter, dfuller lags(2)
xtunitroot fisher lnadjtotexpvoter, dfuller lags(3)
/*use Phillips–Perron unit-root tests specify lag structure for prewhitening*/
xtunitroot fisher lnadjtotexpvoter, pp lags(0)
xtunitroot fisher lnadjtotexpvoter, pp lags(1)
xtunitroot fisher lnadjtotexpvoter, pp lags(2)
xtunitroot fisher lnadjtotexpvoter, pp lags(3)

/*xtabond2 no logs model robustness check Appendix Table 4*/
#delimit ;
xtabond2  adjtotexpvoter lag1adjtotexpvoter lag2adjtotexpvoter
   totpop punchcard leverbudget paperbudget drebudget section5  avgvotepct  adjtotpropval000percap pervapnw 
   pervapu25  pervapo64 mod_switch msacategory2 pubhsgradrate 
  c.percrepvote##i.partcommrep ib(1998).year if registered>6500, 
  gmm(lag1adjtotexpvoter lag2adjtotexpvoter l.adjtotpropval000percap, collapse) iv( punchcard leverbudget 
  paperbudget drebudget section5  avgvotepct 
  msacategory2 mod_switch pervapnw   pervapu25  pervapo64 pubhsgradrate 
  c.percrepvote##i.partcommrep  totpop  ib(1998).year, eq(level)) robust twostep;
#delimit cr

/*Marginal effects Appendix Figure 1*/
quietly margins,dydx(partcommrep) at(percrepvote=(25(.5)75))
#delimit ;
marginsplot,  recast(line) recastci(rline) plotopts(lpattern(longdash)) ciopts(lpattern(dash)) yline(0) xlabel(25(5)75) 
  plotregion(lcolor(black)) graphregion(lcolor(black)) ylab( ,nogrid ) title(" ") 
  xtitle(Presidential Votes Cast for the Repulican Candidate (% of Total Votes)) 
  ytitle(Effect on Election Admin Expenditures (ln $/Registered Voter))name(AppendixFig1, replace);
#delimit cr

/*Marginal effects Appendix Figure 2*/
quietly margins, at(percrepvote=(25(.5)75)partcommrep=(0 1))
#delimit ;
marginsplot,  recast(line) recastci(rline) ci2opts(lpattern(dash)) yline(0) xlabel(25(5)75) plot2opts(lpattern(longdash)) 
  plotregion(lcolor(black)) graphregion(lcolor(black)) ylab( ,nogrid ) title(" ") 
  xtitle(Presidential Votes Cast for the Repulican Candidate (% of Total Votes)) 
  ytitle(Election Admin Expenditures (ln $/Registered Voter)) name(AppendixFig2, replace);
#delimit cr

/*logs no interaction Appendix table 5*/
#delimit ;
xtabond2 lnadjtotexpvoter lag1lnadjtotexpvoter lag2lnadjtotexpvoter
  lntotpop punchcard leverbudget paperbudget drebudget section5 lnavgvotepct lnadjtotpropval000percap pervapnw 
  lnpervapu25 lnpervapo64 mod_switch msacategory2 pubhsgradrate 
  percrepvote partcommrep i.year if registered>6500, 
  gmm(lag1lnadjtotexpvoter lag2lnadjtotexpvoter l.lnadjtotpropval000percap, collapse) iv( punchcard leverbudget 
  paperbudget drebudget section5 lnavgvotepct 
  msacategory2 mod_switch pervapnw  lnpervapu25 lnpervapo64 pubhsgradrate 
  percrepvote partcommrep lntotpop  i.year, eq(level)) robust twostep;
#delimit cr

/*Appendix table 5 R2 and adjusted R2 only from this output*/
#delimit ;
quietly reg adjtotexpvoterchg totpop punchcard leverbudget paperbudget drebudget section5 
avgvotepct adjtotpropval000percap pervapnw pervapu25 pervapo64 mod_switch msacategory2 pubhsgradrate 
c.percrepvote##i.partcommrep i.year i.county if registered>6500;
#delimit cr
/*R2*/
display e(r2)
/*adj R2*/
display e(r2_a)

/*linear First Diff DV model county and year FEs Appendix table 6*/
#delimit ;
xtreg adjtotexpvoterchg totpop punchcard leverbudget paperbudget drebudget section5 
avgvotepct adjtotpropval000percap pervapnw pervapu25 pervapo64 mod_switch msacategory2 pubhsgradrate 
c.percrepvote##i.partcommrep i.year if registered>6500, fe r;
#delimit cr

/*mariginal effects figure 3*/
quietly margins,dydx(partcommrep) at(percrepvote=(25(.5)75))
#delimit ;
marginsplot,  recast(line) recastci(rline) plotopts(lpattern(longdash)) ciopts(lpattern(dash)) yline(0) xlabel(25(5)75) 
  plotregion(lcolor(black)) graphregion(lcolor(black)) ylab( ,nogrid ) title(" ") 
  xtitle(Presidential Votes Cast for the Repulican Candidate (% of Total Votes)) 
  ytitle(Effect on Election Admin Expenditures (ln $/Registered Voter))name(AppendixFig3, replace) ;
#delimit cr

/*predicted margins figure 4*/
quietly margins, at(percrepvote=(25(.5)75)partcommrep=(0 1))
#delimit ;
marginsplot,  recast(line) recastci(rline) ci2opts(lpattern(dash)) yline(0) xlabel(25(5)75) plot2opts(lpattern(longdash)) 
  plotregion(lcolor(black)) graphregion(lcolor(black)) ylab( ,nogrid ) title(" ") 
  xtitle(Presidential Votes Cast for the Repulican Candidate (% of Total Votes)) 
  ytitle(Election Admin Expenditures (ln $/Registered Voter)) name(AppendixFig4, replace);
#delimit cr

/*Prais Winsten model with logs Appendix table 7*/
#delimit ;
prais lnadjtotexpvoter lntotpop punchcard leverbudget paperbudget drebudget section5  msacategory2 lnavgvotepct lnpervapo64 
  lnadjtotpropval000percap pervapnw lnpervapu25  mod_switch pubhsgradrate c.percrepvote##i.partcommrep i.year, cluster(county);
#delimit cr

/*mariginal effects figure 5*/
quietly margins,dydx(partcommrep) at(percrepvote=(25(.5)75))
#delimit ;
marginsplot,  recast(line) recastci(rline) plotopts(lpattern(longdash)) ciopts(lpattern(dash)) yline(0) xlabel(25(5)75) 
  plotregion(lcolor(black)) graphregion(lcolor(black)) ylab( ,nogrid ) title(" ") 
  xtitle(Presidential Votes Cast for the Repulican Candidate (% of Total Votes)) 
  ytitle(Effect on Election Admin Expenditures (ln $/Registered Voter))name(AppendixFig5, replace) ;
#delimit cr

/*predicted margins figure 6*/
quietly margins, at(percrepvote=(25(.5)75)partcommrep=(0 1))
#delimit ;
marginsplot,  recast(line) recastci(rline) ci2opts(lpattern(dash)) yline(0) xlabel(25(5)75) plot2opts(lpattern(longdash)) 
  plotregion(lcolor(black)) graphregion(lcolor(black)) ylab( ,nogrid ) title(" ") 
  xtitle(Presidential Votes Cast for the Repulican Candidate (% of Total Votes)) 
  ytitle(Election Admin Expenditures (ln $/Registered Voter)) name(AppendixFig6, replace);
#delimit cr

/*closing the log file*/
log close
exit


