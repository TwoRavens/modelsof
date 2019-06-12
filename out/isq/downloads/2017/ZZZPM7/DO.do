*** This do file creates the database for  												*/
*** FOI and Natural Resources paper														*/
*** Indra de Soysa (NTNU, Trondheim) 													*/
*** Krishna Chaitanya Vadlamannati(NTNU, Trondheim) 									*/
*****************************************************************************************
*** Last update: March 15, 2016
*****************************************************************************************
/* Note: This do file contains three parts: 											*/
/* 1) Preparation of data file															*/
/* 2) Data Manipulation		  															*/
/* 3) Regression Analysis 																*/
/* Change local FOI to the directory where you store the raw data						*/
/* Running the do file creates the transformed data in the file "Master"				*/
/* The corresponding output tables are saved in the new folder "tables"					*/
/* The output tables are saved into excel using "outreg2" command						*/
*****************************************************************************************

set more off 

******************************** Provide labels ********************************************

label var foi "Freedom of Information Act (Incidence dummy)"
label var end "Freedom of Information Act (Onset dummy)"
label var duration "Count of No Freedom of Information Act Years"
label var af "Post-FOI years(dummy)"
label var foiy "Year Freedom of Information Act is adopted (dummy)"
label var foi_s "Strong Freedom of Information Act (dummy)"
label var fn "Freedom of Information Act Countries (dummy)"
label var rentsgdp "Natural Resources Rents/GDP"
label var oilgdp "Oil Rents/GDP"
label var mineralsgdp "Mineral Rents/GDP"
label var gasgdp "Gas Rents/GDP"
label var rentspc "Natural Resources Rents Per Capita"
label var oilpc "Oil Rents Per Capita"
label var mineralpc "Mineral Rents Per Capita"
label var gaspc "Gas Rents Per Capita"
label var lnrentspc "Natural Resources Rents Per Capita (log)"
label var lnoilpc "Oil Rents Per Capita (log)"
label var lnmineralpc "Mineral Rents Per Capita (log)"
label var lngaspc "Gas Rents Per Capita (log)"
label var pcgdp "Per capita GDP"
label var lnpcgdp "Per capita GDP (log)"
label var pop "Population"
label var lnpop "Population (log)"
label var polity "Polity Index"
label var dem "Democracy 1-21"
label var corr "ICRG Corruption Index"
label var ngo "NGOs"
label var lnngo "NGOs (Log)"
label var trade "Trade/GDP"
label var oecd "OECD nations dummy"
label var rentspc_new "Natural Resources Rents Per Capita (w/o outliers)"
label var oilpc_new "Oil Rents Per Capita (w/o outliers)"
label var mineralpc_new "Mineral Rents Per Capita (w/o outliers)"
label var gaspc_new "Gas Rents Per Capita (w/o outliers)"
label var low "LOW Natural Resources Rents Per Capita(< 300$)"
label var mod "MODERATE Natural Resources Rents Per Capita(> 300$ < 1000$)"
label var high "HIGH Natural Resources Rents Per Capita(>1000$)"
label var low_oil "LOW oil Rents Per Capita(< 300$)"
label var mod_oil "MODERATE oil Rents Per Capita(> 300$ < 1000$)"
label var high_oil "HIGH oil Rents Per Capita(>1000$)"
label var low_mineral "Mineral Rents Per Capita(< 300$)"
label var mod_mineral "Mineral Rents Per Capita(> 300$ < 1000$)"
label var high_mineral "Mineral Rents Per Capita(>1000$)"
label var low_gas "Gas Rents Per Capita(< 300$)"
label var mod_gas "Gas Rents Per Capita(> 300$ < 1000$)"
label var high_gas "Gas Rents Per Capita(>1000$)"
label var maj "Seats share if Ruling party"
label var frac "Opposition Fractionlization index"
label var durable "Democratic durability"


******************************************************* Descriptive Statistics **********************************************************


sum(end foi duration rentspc oilpc mineralpc gaspc lnrentspc lnoilpc lnmineralpc lngaspc pcgdp lnpcgdp dem corr ndem trade ngo lnngo)


****************************************************** Correlation Matrix ****************************************************************


corr(end foi duration rentspc oilpc mineralpc gaspc lnrentspc lnoilpc lnmineralpc lngaspc lnpcgdp dem corr ndem trade lnngo)


****************************************************** Graphs ****************************************************************

*** Figure 1

graph bar foi, over(year)


*************************************************************************************************************************************************************************
********************************************************************* TABLE 1  [Baseline Models: TOTAL RENTS] ***********************************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Rents per capita

xi: probit end l.rentspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post 
tab country if e(sample)==1
estimates store t1
outreg2 using "t1", excel

*** Column 2: Probit - Rents per capita

xi: probit end l.rentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post 
tab country if e(sample)==1
outreg2 using "t1", excel

*** Column 3: Probit - Rents per capita

xi: probit end l.rentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(*) at( _all) post 
tab country if e(sample)==1
outreg2 using "t1", excel

*** Column 4: OLS-FE - Rents per capita

xi: xtreg end l.rentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
tab country if e(sample)==1
outreg2 using "t1", excel

*** Column 5: Probit - Rents per capita (Log)

xi: probit end l.lnrentspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post 
tab country if e(sample)==1
outreg2 using "t1", excel

*** Column 6: Probit - Rents per capita (Log)

xi: probit end l.lnrentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post 
tab country if e(sample)==1
outreg2 using "t1", excel

*** Column 7: Probit - Rents per capita (Log)

xi: probit end l.lnrentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(*) at( _all) post 
tab country if e(sample)==1
outreg2 using "t1", excel

*** Column 8: OLS-FE - Rents per capita (Log)

xi: xtreg end l.lnrentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
tab country if e(sample)==1
outreg2 using "t1", excel


*************************************************************************************************************************************************************************
************************************************************** TABLE 2  [Disaggregated Resource Rents per capita] *******************************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Oil Rents per capita

xi: probit end l.oilpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
estimates store t2
outreg2 using "t2", excel

* 1-exp(_b[l.oilpc])
* 1-exp(_b[l.oilpc]*2.57)
* 1-exp(_b[l.oilpc]*33.10)

*** Column 2: Probit - Oil Rents per capita

xi: probit end l.oilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t2", excel

*** Column 3: Probit - Oil Rents per capita

xi: probit end l.oilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t2", excel

*** Column 4: OLS-FE - Oil Rents per capita

xi: xtreg end l.oilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
tab country if e(sample)==1
outreg2 using "t2", excel

*** Column 5: Probit - Gas Rents per capita

xi: probit end l.gaspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t2", excel

*** Column 6: Probit - Gas Rents per capita

xi: probit end l.gaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t2", excel

*** Column 7: Probit - Gas Rents per capita

xi: probit end l.gaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t2", excel

*** Column 8: OLS-FE - Gas Rents per capita

xi: xtreg end l.gaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
tab country if e(sample)==1
outreg2 using "t2", excel

*** Column 9: Probit - Mineral Rents per capita

xi: probit end l.mineralpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t2", excel

*** Column 10: Probit - Mineral Rents per capita

xi: probit end l.mineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t2", excel

*** Column 11: Probit - Mineral Rents per capita

xi: probit end l.mineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t2", excel

*** Column 12: OLS-FE - Mineral Rents per capita

xi: xtreg end l.mineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
tab country if e(sample)==1
outreg2 using "t2", excel


*************************************************************************************************************************************************************************
********************************************************** TABLE 3  [Disaggregated Resource Rents Per capita LOG] *******************************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Oil Rents per capita (Log)

xi: probit end l.lnoilpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
estimates store t3
outreg2 using "t3", excel

*** Column 2: Probit - Oil Rents per capita (Log)

xi: probit end l.lnoilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t3", excel

*** Column 3: Probit - Oil Rents per capita (Log)

xi: probit end l.lnoilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t3", excel

*** Column 4: OLS-FE - Oil Rents per capita (Log)

xi: xtreg end l.lnoilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
tab country if e(sample)==1
outreg2 using "t3", excel

*** Column 5: Probit - Oil Rents per capita (Log)

xi: probit end l.lngaspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t3", excel

*** Column 6: Probit - Oil Rents per capita (Log)

xi: probit end l.lngaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t3", excel

*** Column 7: Probit - Oil Rents per capita (Log)

xi: probit end l.lngaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t3", excel

*** Column 8: OLS-FE - Oil Rents per capita (Log)

xi: xtreg end l.lngaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
tab country if e(sample)==1
outreg2 using "t3", excel

*** Column 9: Probit - Oil Rents per capita (Log)

xi: probit end l.lnmineralpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t3", excel

*** Column 10: Probit - Oil Rents per capita (Log)

xi: probit end l.lnmineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t3", excel

*** Column 11: Probit - Oil Rents per capita (Log)

xi: probit end l.lnmineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(*) at( _all) post
tab country if e(sample)==1
outreg2 using "t3", excel

*** Column 12: OLS-FE - Oil Rents per capita (Log)

xi: xtreg end l.lnmineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
tab country if e(sample)==1
outreg2 using "t3", excel


*************************************************************************************************************************************************************************
*********************************************************** TABLE 4  [Interaction Effects] ******************************************************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Rents per capita Interactions
xi: probit end c.l.rentspc#c.l.dem l.rentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo i.year if af==0, robust difficult
tab country if e(sample)==1
estimates store t4
outreg2 using "t4", excel

*** Column 2: Probit - Rents per capita (Log) Interactions
xi: probit end c.l.lnrentspc#c.l.dem l.lnrentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo i.year if af==0, robust difficult
tab country if e(sample)==1
outreg2 using "t4", excel

*** Column 3: Probit - Rents Interactions
xi: probit end c.l.rentspc#c.l.corr l.rentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
tab country if e(sample)==1
outreg2 using "t4", excel

*** Column 4: Probit - Rents per capita (Log) Interactions
xi: probit end c.l.lnrentspc#c.l.corr l.lnrentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
tab country if e(sample)==1
outreg2 using "t4", excel


*********************** FIGURE 3 - Marginal Plot: (From Column 1)
xi: probit end c.l.rentspc#c.l.dem l.rentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(l.rentspc) at(l.dem=(1 (1) 21)(mean)_all) post
marginsplot, level(90) recast(line) recastci(rarea) scheme(s1color)
***********************


*********************** FIGURE 4 - Marginal Plot: (From Column 2)
xi: probit end c.l.lnrentspc#c.l.dem l.lnrentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(l.lnrentspc) at(l.dem=(1 (1) 21)(mean)_all) post
marginsplot, level(90) recast(line) recastci(rarea) scheme(s1color)
***********************


*********************** FIGURE 5 - Marginal Plot: (From Column 3)
xi: probit end c.l.rentspc#c.l.corr l.rentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(l.rentspc) at(l.corr=(0 (1) 6)(mean)_all) post
marginsplot, level(90) recast(line) recastci(rarea) scheme(s1color)
***********************


*********************** FIGURE 6 - Marginal Plot: (From Column 4)
xi: probit end c.l.lnrentspc#c.l.corr l.lnrentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
margins, dydx(l.lnrentspc) at(l.corr=(0 (1) 6)(mean)_all) post
marginsplot, level(90) recast(line) recastci(rarea) scheme(s1color)
***********************





*************************************************************************************************************************************************************************
******************************************** ROBUSTNESS CHECK 1  [Baseline Models: NO OECD COUNTRIES - TOTAL RENTS] *****************************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Rents per capita (NO OECD COUNTRIES)

xi: probit end l.rentspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
estimates store r1
outreg2 using "r1", excel

*** Column 2: Probit - Rents per capita (NO OECD COUNTRIES)

xi: probit end l.rentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1", excel

*** Column 3: Probit - Rents per capita (NO OECD COUNTRIES)

xi: probit end l.rentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
outreg2 using "r1", excel

*** Column 4: OLS-FE - Rents per capita (NO OECD COUNTRIES)

xi: xtreg end l.rentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0 & oecd==0, robust
outreg2 using "r1", excel

*** Column 5: Probit - Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lnrentspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1", excel

*** Column 6: Probit - Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lnrentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1", excel

*** Column 7: Probit - Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lnrentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
outreg2 using "r1", excel

*** Column 8: OLS-FE - Rents per capita (Log) (NO OECD COUNTRIES)

xi: xtreg end l.lnrentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0 & oecd==0, robust
outreg2 using "r1", excel


*************************************************************************************************************************************************************************
***************************************** ROBUSTNESS CHECK 1B  [NO OECD COUNTRIES - Disaggregated Resource Rents per capita] ********************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Oil Rents per capita (NO OECD COUNTRIES)

xi: probit end l.oilpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
estimates store r1b
outreg2 using "r1b", excel

*** Column 2: Probit - Oil Rents per capita (NO OECD COUNTRIES)

xi: probit end l.oilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1b", excel

*** Column 3: Probit - Oil Rents per capita (NO OECD COUNTRIES)

xi: probit end l.oilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
outreg2 using "r1b", excel

*** Column 4: OLS-FE - Oil Rents per capita (NO OECD COUNTRIES)

xi: xtreg end l.oilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0 & oecd==0, robust
outreg2 using "r1b", excel

*** Column 5: Probit - Gas Rents per capita (NO OECD COUNTRIES)

xi: probit end l.gaspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1b", excel

*** Column 6: Probit - Gas Rents per capita (NO OECD COUNTRIES)

xi: probit end l.gaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1b", excel

*** Column 7: Probit - Gas Rents per capita (NO OECD COUNTRIES)

xi: probit end l.gaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
outreg2 using "r1b", excel

*** Column 8: OLS-FE - Gas Rents per capita (NO OECD COUNTRIES)

xi: xtreg end l.gaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0 & oecd==0, robust
outreg2 using "r1b", excel

*** Column 9: Probit - Mineral Rents per capita (NO OECD COUNTRIES)

xi: probit end l.mineralpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1b", excel

*** Column 10: Probit - Mineral Rents per capita (NO OECD COUNTRIES)

xi: probit end l.mineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1b", excel

*** Column 11: Probit - Mineral Rents per capita (NO OECD COUNTRIES)

xi: probit end l.mineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
outreg2 using "r1b", excel

*** Column 12: OLS-FE - Mineral Rents per capita (NO OECD COUNTRIES)

xi: xtreg end l.mineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0 & oecd==0, robust
outreg2 using "r1b", excel


*************************************************************************************************************************************************************************
********************************************* ROBUSTNESS CHECK 1C  [NO OECD COUNTRIES - Disaggregated Resource Rents Per capita LOG] ************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lnoilpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
estimates store r1c
outreg2 using "r1c", excel

*** Column 2: Probit - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lnoilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1c", excel

*** Column 3: Probit - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lnoilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
outreg2 using "r1c", excel

*** Column 4: OLS-FE - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: xtreg end l.lnoilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0 & oecd==0, robust
outreg2 using "r1c", excel

*** Column 5: Probit - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lngaspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1c", excel

*** Column 6: Probit - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lngaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1c", excel

*** Column 7: Probit - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lngaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
outreg2 using "r1c", excel

*** Column 8: OLS-FE - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: xtreg end l.lngaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0 & oecd==0, robust
outreg2 using "r1c", excel

*** Column 9: Probit - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lnmineralpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1c", excel

*** Column 10: Probit - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lnmineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0 & oecd==0, robust difficult
outreg2 using "r1c", excel

*** Column 11: Probit - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: probit end l.lnmineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
outreg2 using "r1c", excel

*** Column 12: OLS-FE - Oil Rents per capita (Log) (NO OECD COUNTRIES)

xi: xtreg end l.lnmineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0 & oecd==0, robust
outreg2 using "r1c", excel

*************************************************************************************************************************************************************************
******************************************* ROBUSTNESS CHECK 1D  [NO OECD COUNTRIES -Interaction Effects] ***************************************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Rents per capita Interactions (NO OECD COUNTRIES)

xi: probit end c.l.rentspc#c.l.dem l.rentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
estimates store r1d
outreg2 using "r1d", excel
 
*** Column 2: Probit - Rents per capita (Log) Interactions (NO OECD COUNTRIES)

xi: probit end c.l.lnrentspc#c.l.dem l.lnrentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
outreg2 using "r1d", excel

*** Column 3: Probit - Rents Interactions (NO OECD COUNTRIES)

xi: probit end c.l.rentspc#c.l.corr l.rentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
outreg2 using "r1d", excel

*** Column 4: Probit - Rents per capita (Log) Interactions (NO OECD COUNTRIES)

xi: probit end c.l.lnrentspc#c.l.corr l.lnrentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0 & oecd==0, robust difficult
outreg2 using "r1d", excel


*************************************************************************************************************************************************************************
************************************************** ROBUSTNESS CHECK 2  [Baseline Models: NO OUTLIERS - TOTAL RENTS] *****************************************************
*************************************************************************************************************************************************************************

* EXCLUDING OUTLIERS (10K US$) - TOTAL RENTS

* g new=1 if rentspc<10 & rentspc~=.
* replace new=0 if new~=1 & rentspc~=.
* g rentspc_new = rentspc*new


*** Column 1: Probit - Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.rentspc_new l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
estimates store r2
outreg2 using "r2", excel

*** Column 2: Probit - Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.rentspc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r2", excel

*** Column 3: Probit - Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.rentspc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
outreg2 using "r2", excel

*** Column 4: OLS-FE - Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: xtreg end l.rentspc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
outreg2 using "r2", excel


*************************************************************************************************************************************************************************
*********************************************** ROBUSTNESS CHECK 2B  [NO OUTLIERS - Disaggregated Resource Rents per capita] ********************************************
*************************************************************************************************************************************************************************

* EXCLUDING OUTLIERS (10K US$) - OIL RENTS

* g new1=1 if oilpc<10 & oilpc~=.
* replace new1=0 if new1~=1 & oilpc~=.
* g oilpc_new = oilpc*new1

* EXCLUDING OUTLIERS (10K US$) - GAS RENTS

* g new2=1 if gaspc<10 & gaspc~=.
* replace new2=0 if new2~=1 & gaspc~=.
* g gaspc_new = gaspc*new2

* EXCLUDING OUTLIERS (10K US$) - MINERAL RENTS

* g new3=1 if mineralpc<10 & mineralpc~=.
* replace new3=0 if new3~=1 & mineralpc~=.
* g mineralpc_new = mineralpc*new3


*** Column 1: Probit - Oil Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.oilpc_new l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
estimates store r2a
outreg2 using "r2a", excel

*** Column 2: Probit - Oil Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.oilpc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r2a", excel

*** Column 3: Probit - Oil Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.oilpc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
outreg2 using "r2a", excel

*** Column 4: OLS-FE - Oil Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: xtreg end l.oilpc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
outreg2 using "r2a", excel

*** Column 5: Probit - Gas Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.gaspc_new l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r2a", excel

*** Column 6: Probit - Gas Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.gaspc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r2a", excel

*** Column 7: Probit - Gas Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.gaspc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
outreg2 using "r2a", excel

*** Column 8: OLS-FE - Gas Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: xtreg end l.gaspc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
outreg2 using "r2a", excel

*** Column 9: Probit - Mineral Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.mineralpc_new l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r2a", excel

*** Column 10: Probit - Mineral Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.mineralpc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r2a", excel

*** Column 11: Probit - Mineral Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: probit end l.mineralpc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
outreg2 using "r2a", excel

*** Column 12: OLS-FE - Mineral Rents per capita (EXCLUDING OUTLIERS: 10K US$)

xi: xtreg end l.mineralpc_new l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
outreg2 using "r2a", excel


*************************************************************************************************************************************************************************
************************************************** ROBUSTNESS CHECK 3  [Baseline Models: LOW / MODERATE / HIGH - TOTAL RENTS] *******************************************
*************************************************************************************************************************************************************************

* Low / Moderate / High - TOTAL RENTS

* g low=1 if rentspc<0.3 & rentspc~=.
* replace low=0 if low~=1 & rentspc~=.

* g mod=1 if rentspc>0.3 <0.99 & rentspc~=.
* replace mod=0 if mod~=1 & rentspc~=.

* g high=1 if rentspc>1 & rentspc~=.
* replace high=0 if high~=1 & rentspc~=.


*** Column 1: Probit - Rents per capita (Low / Moderate / High)

xi: probit end l.low l.mod l.high l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
estimates store r3
outreg2 using "r3", excel

*** Column 2: Probit - Rents per capita (Low / Moderate / High)

xi: probit end l.low l.mod l.high l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r3", excel

*** Column 3: Probit - Rents per capita (Low / Moderate / High)

xi: probit end l.low l.mod l.high l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
outreg2 using "r3", excel

*** Column 4: OLS-FE - Rents per capita (Low / Moderate / High)

xi: xtreg end l.low l.mod l.high l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
outreg2 using "r3", excel


*************************************************************************************************************************************************************************
*********************************************** ROBUSTNESS CHECK 3B  [NO OUTLIERS - Disaggregated Resource Rents per capita] ********************************************
*************************************************************************************************************************************************************************

* Low / Moderate / High - OIL RENTS

* g low_oil=1 if oilpc<0.3 & oilpc~=.
* replace low_oil=0 if low_oil~=1 & oilpc~=.

* g mod_oil=1 if oilpc>0.3 <0.99 & oilpc~=.
* replace mod_oil=0 if mod_oil~=1 & oilpc~=.

* g high_oil=1 if oilpc>1 & oilpc~=.
* replace high_oil=0 if high_oil~=1 & oilpc~=.

* Low / Moderate / High - GAS RENTS

* g low_gas=1 if gaspc<0.3 & gaspc~=.
* replace low_gas=0 if low_gas~=1 & gaspc~=.

* g mod_gas=1 if gaspc>0.3 <0.99 & gaspc~=.
* replace mod_gas=0 if mod_gas~=1 & gaspc~=.

* g high_gas=1 if gaspc>1 & gaspc~=.
* replace high_gas=0 if high_gas~=1 & gaspc~=.

* Low / Moderate / High - MINERAL RENTS

* g low_mineral=1 if mineralpc<0.3 & mineralpc~=.
* replace low_mineral=0 if low_mineral~=1 & mineralpc~=.

* g mod_mineral=1 if mineralpc>0.3 <0.99 & mineralpc~=.
* replace mod_mineral=0 if mod_mineral~=1 & mineralpc~=.

* g high_mineral=1 if mineralpc>1 & mineralpc~=.
* replace high_mineral=0 if high_mineral~=1 & mineralpc~=.


*** Column 1: Probit - Oil Rents per capita (Low / Moderate / High)

xi: probit end l.low_oil l.mod_oil l.high_oil l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
estimates store r3a
outreg2 using "r3a", excel

*** Column 2: Probit - Oil Rents per capita (Low / Moderate / High)

xi: probit end l.low_oil l.mod_oil l.high_oil l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r3a", excel

*** Column 3: Probit - Oil Rents per capita (Low / Moderate / High)

xi: probit end l.low_oil l.mod_oil l.high_oil l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
outreg2 using "r3a", excel

*** Column 4: OLS-FE - Oil Rents per capita (Low / Moderate / High)

xi: xtreg end l.low_oil l.mod_oil l.high_oil l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
outreg2 using "r3a", excel

*** Column 5: Probit - Gas Rents per capita (Low / Moderate / High)

xi: probit end l.low_gas l.mod_gas l.high_gas l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r3a", excel

*** Column 6: Probit - Gas Rents per capita (Low / Moderate / High)

xi: probit end l.low_gas l.mod_gas l.high_gas l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r3a", excel

*** Column 7: Probit - Gas Rents per capita (Low / Moderate / High)

xi: probit end l.low_gas l.mod_gas l.high_gas l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
outreg2 using "r3a", excel

*** Column 8: OLS-FE - Gas Rents per capita (Low / Moderate / High)

xi: xtreg end l.low_gas l.mod_gas l.high_gas l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
outreg2 using "r3a", excel

*** Column 9: Probit - Mineral Rents per capita (Low / Moderate / High)

xi: probit end l.low_mineral l.mod_mineral l.high_mineral l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r3a", excel

*** Column 10: Probit - Mineral Rents per capita (Low / Moderate / High)

xi: probit end l.low_mineral l.mod_mineral l.high_mineral l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r3a", excel

*** Column 11: Probit - Mineral Rents per capita (Low / Moderate / High)

xi: probit end l.low_mineral l.mod_mineral l.high_mineral l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
outreg2 using "r3a", excel

*** Column 12: OLS-FE - Mineral Rents per capita (Low / Moderate / High)

xi: xtreg end l.low_mineral l.mod_mineral l.high_mineral l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af==0, robust
outreg2 using "r3a", excel


*************************************************************************************************************************************************************************
********************************************************* ROBUSTNESS CHECK 4  [FOI INCIDENCE - Baseline Models] ********************************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Rents per capita (FOI INCIDENCE)
xi: probit foi l.rentspc l.lnpcgdp i.year, robust difficult
estimates store r4a
outreg2 using "r4a", excel

*** Column 2: Probit - Rents per capita (FOI INCIDENCE)
xi: probit foi l.rentspc l.lnpcgdp l.dem i.year, robust difficult
outreg2 using "r4a", excel

*** Column 3: Probit - Rents per capita (FOI INCIDENCE)
xi: probit foi l.rentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year, robust difficult
outreg2 using "r4a", excel

*** Column 4: OLS(FE) - Rents per capita (FOI INCIDENCE)
xi: xtreg foi l.rentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id, robust
outreg2 using "r4a", excel

*** Column 5: Probit - Rents per capita (Log) (FOI INCIDENCE)
xi: probit foi l.lnrentspc l.lnpcgdp i.year, robust difficult
outreg2 using "r4a", excel

*** Column 6: Probit - Rents per capita (Log) (FOI INCIDENCE)
xi: probit foi l.lnrentspc l.lnpcgdp l.dem i.year, robust difficult
outreg2 using "r4a", excel

*** Column 7: Probit - Rents per capita (Log) (FOI INCIDENCE)
xi: probit foi l.lnrentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year, robust difficult
outreg2 using "r4a", excel

*** Column 8: OLS(FE) - Rents per capita (Log) (FOI INCIDENCE)
xi: xtreg foi l.lnrentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id, robust
outreg2 using "r4a", excel


*************************************************************************************************************************************************************************
************************************************** ROBUSTNESS CHECK 4B  [FOI INCIDENCE - Disaggregated Resource Rents per capita] ***************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Oil Rents per capita (FOI INCIDENCE)
xi: probit foi l.oilpc l.lnpcgdp l.dem i.year, robust difficult
estimates store r4b
outreg2 using "r4b", excel

*** Column 2: Probit - Oil Rents per capita (FOI INCIDENCE)
xi: probit foi l.oilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year, robust difficult
outreg2 using "r4b", excel

*** Column 3: OLS(FE) - Oil Rents per capita (FOI INCIDENCE)
xi: xtreg foi l.oilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id, robust
outreg2 using "r4b", excel

*** Column 4: Probit - Mineral Rents per capita (FOI INCIDENCE)
xi: probit foi l.mineralpc l.lnpcgdp l.dem i.year, robust difficult
outreg2 using "r4b", excel

*** Column 5: Probit - Mineral Rents per capita (FOI INCIDENCE)
xi: probit foi l.mineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year, robust difficult
outreg2 using "r4b", excel

*** Column 6: OLS(FE) - Mineral Rents per capita (FOI INCIDENCE)
xi: xtreg foi l.mineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id, robust
outreg2 using "r4b", excel

*** Column 7: Probit - Gas Rents per capita (FOI INCIDENCE)
xi: probit foi l.gaspc l.lnpcgdp l.dem i.year, robust difficult
outreg2 using "r4b", excel

*** Column 8: Probit - Gas Rents per capita (FOI INCIDENCE)
xi: probit foi l.gaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year, robust difficult
outreg2 using "r4b", excel

*** Column 9: OLS(FE) - Gas Rents per capita (FOI INCIDENCE)
xi: xtreg foi l.gaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id, robust
outreg2 using "r4b", excel


*************************************************************************************************************************************************************************
***************************************************** ROBUSTNESS CHECK 4C  [FOI INCIDENCE - Disaggregated Resource Rents Per capita LOG] ********************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Oil Rents per capita (Log) (FOI INCIDENCE)
xi: probit foi l.lnoilpc l.lnpcgdp l.dem i.year, robust difficult
estimates store r4c
outreg2 using "r4c", excel

*** Column 2: Probit - Oil Rents per capita (Log) (FOI INCIDENCE)
xi: probit foi l.lnoilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year, robust difficult
outreg2 using "r4c", excel

*** Column 3: OLS(FE) - Oil Rents per capita (Log) (FOI INCIDENCE)
xi: xtreg foi l.lnoilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id, robust
outreg2 using "r4c", excel

*** Column 4: Probit - Mineral Rents per capita (Log) (FOI INCIDENCE)
xi: probit foi l.lnmineralpc l.lnpcgdp l.dem i.year, robust difficult
outreg2 using "r4c", excel

*** Column 5: Probit - Mineral Rents per capita (Log) (FOI INCIDENCE)
xi: probit foi l.lnmineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year, robust difficult
outreg2 using "r4c", excel

*** Column 6: OLS(FE) - Mineral Rents per capita (Log) (FOI INCIDENCE)
xi: xtreg foi l.lnmineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id, robust
outreg2 using "r4c", excel

*** Column 7: Probit - Gas Rents per capita (Log) (FOI INCIDENCE)
xi: probit foi l.lngaspc l.lnpcgdp l.dem i.year, robust difficult
outreg2 using "r4c", excel

*** Column 8: Probit - Gas Rents per capita (Log) (FOI INCIDENCE)
xi: probit foi l.lngaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year, robust difficult
outreg2 using "r4c", excel

*** Column 9: OLS(FE) - Gas Rents per capita (Log) (FOI INCIDENCE)
xi: xtreg foi l.lngaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id, robust
outreg2 using "r4c", excel


*************************************************************************************************************************************************************************
********************************************** ROBUSTNESS CHECK 4D  [FOI INCIDENCE - Interaction Effects] ***************************************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Rents per capita Interactions (FOI INCIDENCE)
xi: probit foi c.l.rentspc#c.l.dem l.rentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo i.year, robust difficult
estimates store r4d
outreg2 using "r4d", excel
*margins, dydx(l.rentspc) at(l.dem=(1 (1) 21)(mean)_all) post


*** Column 2: Probit - Rents per capita (Log) Interactions (FOI INCIDENCE)
xi: probit foi c.l.lnrentspc#c.l.dem l.lnrentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo i.year, robust difficult
outreg2 using "r4d", excel
*margins, dydx(l.lnrentspc) at(l.dem=(1 (1) 21)(mean)_all) post


*** Column 3: Probit - Rents Interactions (FOI INCIDENCE)
xi: probit foi c.l.rentspc#c.l.corr l.rentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year, robust difficult
outreg2 using "r4d", excel
*margins, dydx(l.rentspc) at(l.corr=(0 (1) 6)(mean)_all) post


*** Column 4: Probit - Rents per capita (Log) Interactions (FOI INCIDENCE)
xi: probit foi c.l.lnrentspc#c.l.corr l.lnrentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year, robust difficult
outreg2 using "r4d", excel
*margins, dydx(l.lnrentspc) at(l.corr=(0 (1) 6)(mean)_all) post


*************************************************************************************************************************************************************************
************************************************************************* ROBUSTNESS CHECK 5  [COX DURATION MODELS] *****************************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - All Rents per capita

xi: streg lrentspc llnpcgdp ldem lndem ltrade llnngo, d(w) nohr
estimates store r5
outreg2 using "r5", excel

*** Column 2: Probit - All Rents per capita (Log)

xi: streg llnrentspc llnpcgdp ldem lndem ltrade llnngo, d(w) nohr
outreg2 using "r5", excel

*** Column 3: Probit - Oil Rents per capita

xi: streg loilpc llnpcgdp ldem lndem ltrade llnngo, d(w) nohr
outreg2 using "r5", excel

*** Column 4: Probit - Oil Rents per capita (Log)

xi: streg llnoilpc llnpcgdp ldem lndem ltrade llnngo, d(w) nohr
outreg2 using "r5", excel

*** Column 5: Probit - Gas Rents per capita

xi: streg lgaspc llnpcgdp ldem lndem ltrade llnngo, d(w) nohr
outreg2 using "r5", excel

*** Column 6: Probit - Gas Rents per capita (Log)

xi: streg llngaspc llnpcgdp ldem lndem ltrade llnngo, d(w) nohr
outreg2 using "r5", excel

*** Column 7: Probit - Mineral Rents per capita

xi: streg lmineralpc llnpcgdp ldem lndem ltrade llnngo, d(w) nohr
outreg2 using "r5", excel

*** Column 8: Probit - Mineral Rents per capita (Log)

xi: streg llnmineralpc llnpcgdp ldem lndem ltrade llnngo, d(w) nohr
outreg2 using "r5", excel


*************************************************************************************************************************************************************************
************************************************************************* ROBUSTNESS CHECK 6  [NEGATIVE BINOMIAL MODELS] ************************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - All Rents per capita

xi: nbreg duration lrentspc llnpcgdp ldem lndem ltrade llnngo i.year, robust difficult
estimates store r6
outreg2 using "r6", excel

*** Column 2: Probit - All Rents per capita (Log)

xi: nbreg duration lnrentspc llnpcgdp ldem lndem ltrade llnngo i.year, robust difficult
outreg2 using "r6", excel

*** Column 3: Probit - Oil Rents per capita

xi: nbreg duration loilpc llnpcgdp ldem lndem ltrade llnngo i.year, robust difficult
outreg2 using "r6", excel

*** Column 4: Probit - Oil Rents per capita (Log)

xi: nbreg duration lnoilpc llnpcgdp ldem lndem ltrade llnngo i.year, robust difficult
outreg2 using "r6", excel

*** Column 5: Probit - Gas Rents per capita

xi: nbreg duration lgaspc llnpcgdp ldem lndem ltrade llnngo i.year, robust difficult
outreg2 using "r6", excel

*** Column 6: Probit - Gas Rents per capita (Log)

xi: nbreg duration lngaspc llnpcgdp ldem lndem ltrade llnngo i.year, robust difficult
outreg2 using "r6", excel

*** Column 7: Probit - Mineral Rents per capita

xi: nbreg duration lmineralpc llnpcgdp ldem lndem ltrade llnngo i.year, robust difficult
outreg2 using "r6", excel

*** Column 8: Probit - Mineral Rents per capita (Log)

xi: nbreg duration lnmineralpc llnpcgdp ldem lndem ltrade llnngo i.year, robust difficult
outreg2 using "r6", excel


*************************************************************************************************************************************************************************
******************************************** ROBUSTNESS CHECK 7  [Baseline Models: NO FOI for Malaysia & Philippines - TOTAL RENTS] *************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.rentspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
estimates store r7
outreg2 using "r7", excel

*** Column 2: Probit - Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.rentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7", excel 

*** Column 3: Probit - Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.rentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
outreg2 using "r7", excel

*** Column 4: OLS-FE - Rents per capita (NO FOI for Malaysia & Philippines)

xi: xtreg end_mp l.rentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af_mp==0, robust
outreg2 using "r7", excel

*** Column 5: Probit - Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lnrentspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7", excel

*** Column 6: Probit - Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lnrentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7", excel

*** Column 7: Probit - Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lnrentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
outreg2 using "r7", excel 

*** Column 8: OLS-FE - Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: xtreg end_mp l.lnrentspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af_mp==0, robust
outreg2 using "r7", excel


*************************************************************************************************************************************************************************
***************************************** ROBUSTNESS CHECK 7B  [NO FOI for Malaysia & Philippines - Disaggregated Resource Rents per capita] ****************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Oil Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.oilpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
estimates store r7b
outreg2 using "r7b", excel

*** Column 2: Probit - Oil Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.oilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7b", excel

*** Column 3: Probit - Oil Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.oilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
outreg2 using "r7b", excel

*** Column 4: OLS-FE - Oil Rents per capita (NO FOI for Malaysia & Philippines)

xi: xtreg end_mp l.oilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af_mp==0, robust
outreg2 using "r7b", excel

*** Column 5: Probit - Gas Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.gaspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7b", excel

*** Column 6: Probit - Gas Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.gaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7b", excel

*** Column 7: Probit - Gas Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.gaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
outreg2 using "r7b", excel

*** Column 8: OLS-FE - Gas Rents per capita (NO FOI for Malaysia & Philippines)

xi: xtreg end_mp l.gaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af_mp==0, robust
outreg2 using "r7b", excel

*** Column 9: Probit - Mineral Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.mineralpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7b", excel

*** Column 10: Probit - Mineral Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.mineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7b", excel

*** Column 11: Probit - Mineral Rents per capita (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.mineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
outreg2 using "r7b", excel

*** Column 12: OLS-FE - Mineral Rents per capita (NO FOI for Malaysia & Philippines)

xi: xtreg end_mp l.mineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af_mp==0, robust
outreg2 using "r7b", excel


*************************************************************************************************************************************************************************
********************************************* ROBUSTNESS CHECK 7C  [NO FOI for Malaysia & Philippines - Disaggregated Resource Rents Per capita LOG] ********************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lnoilpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
estimates store r7c
outreg2 using "r7c", excel

*** Column 2: Probit - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lnoilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7c", excel

*** Column 3: Probit - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lnoilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
outreg2 using "r7c", excel

*** Column 4: OLS-FE - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: xtreg end_mp l.lnoilpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af_mp==0, robust
outreg2 using "r7c", excel

*** Column 5: Probit - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lngaspc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7c", excel

*** Column 6: Probit - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lngaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7c", excel

*** Column 7: Probit - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lngaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
outreg2 using "r7c", excel

*** Column 8: OLS-FE - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: xtreg end_mp l.lngaspc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af_mp==0, robust
outreg2 using "r7c", excel

*** Column 9: Probit - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lnmineralpc l.lnpcgdp l.dem fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7c", excel

*** Column 10: Probit - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lnmineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af_mp==0, robust difficult
outreg2 using "r7c", excel

*** Column 11: Probit - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: probit end_mp l.lnmineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
outreg2 using "r7c", excel

*** Column 12: OLS-FE - Oil Rents per capita (Log) (NO FOI for Malaysia & Philippines)

xi: xtreg end_mp l.lnmineralpc l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year i.id if af_mp==0, robust
outreg2 using "r7c", excel


*************************************************************************************************************************************************************************
******************************************* ROBUSTNESS CHECK 7D  [NO FOI for Malaysia & Philippines -Interaction Effects] ***********************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Rents per capita Interactions (NO FOI for Malaysia & Philippines)

xi: probit end_mp c.l.rentspc#c.l.dem l.rentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
estimates store r7d
outreg2 using "r7d", excel
*margins, dydx(l.rentspc) at(l.dem=(1 (1) 21)(mean)_all) post
 
*** Column 2: Probit - Rents per capita (Log) Interactions (NO FOI for Malaysia & Philippines)

xi: probit end_mp c.l.lnrentspc#c.l.dem l.lnrentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
outreg2 using "r7d", excel
*margins, dydx(l.lnrentspc) at(l.dem=(1 (1) 21)(mean)_all) post

*** Column 3: Probit - Rents Interactions (NO FOI for Malaysia & Philippines)

xi: probit end_mp c.l.rentspc#c.l.corr l.rentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
outreg2 using "r7d", excel
*margins, dydx(l.rentspc) at(l.corr=(0 (1) 6)(mean)_all) post

*** Column 4: Probit - Rents per capita (Log) Interactions (NO FOI for Malaysia & Philippines)

xi: probit end_mp c.l.lnrentspc#c.l.corr l.lnrentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af_mp==0, robust difficult
outreg2 using "r7d", excel
*margins, dydx(l.lnrentspc) at(l.corr=(0 (1) 6)(mean)_all) post


*************************************************************************************************************************************************************************
************************************************************ ROBUSTNESS CHECK 8  [INTERACTIONS WITH DEMOCRATIC DURABILITY] **********************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Rents per capita Interactions (with time dummies)

xi: probit end c.l.rentspc#c.l.durable l.rentspc l.durable l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
estimates store r8
outreg2 using "r8", excel
*margins, dydx(l.rentspc) at(l.durable=(0 (10) 67)(mean)_all) post

*** Column 2: Probit - Rents per capita (Log) Interactions (with time dummies)

xi: probit end c.l.lnrentspc#c.l.durable l.lnrentspc l.durable l.lnpcgdp l.dem l.ndem l.trade l.lnngo i.year if af==0, robust difficult
outreg2 using "r8", excel
*margins, dydx(l.lnrentspc) at(l.durable=(0 (10) 67)(mean)_all) post

*** Column 3: Probit - Rents per capita Interactions (with splines)

xi: probit end c.l.rentspc#c.l.durable l.rentspc l.durable l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r8", excel
*margins, dydx(l.rentspc) at(l.durable=(0 (10) 67)(mean)_all) post

*** Column 4: Probit - Rents per capita (Log) Interactions (with splines)

xi: probit end c.l.lnrentspc#c.l.durable l.lnrentspc l.durable l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r8", excel
*margins, dydx(l.lnrentspc) at(l.durable=(0 (10) 67)(mean)_all) post


*************************************************************************************************************************************************************************
***************************************************** ROBUSTNESS CHECK 9  [INTERACTIONS EFFECTS IN TABLE 4 WITH SPLINES] ************************************************
*************************************************************************************************************************************************************************

*** Column 1: Probit - Rents per capita Interactions

xi: probit end c.l.rentspc#c.l.dem l.rentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
estimates store r9
outreg2 using "r9", excel
*margins, dydx(l.rentspc) at(l.dem=(1 (1) 21)(mean)_all) post

*** Column 2: Probit - Rents per capita (Log) Interactions

xi: probit end c.l.lnrentspc#c.l.dem l.lnrentspc l.dem l.lnpcgdp l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r9", excel
*margins, dydx(l.lnrentspc) at(l.dem=(1 (1) 21)(mean)_all) post

*** Column 3: Probit - Rents per capita Interactions

xi: probit end c.l.rentspc#c.l.corr l.rentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r9", excel
*margins, dydx(l.rentspc) at(l.corr=(0 (1) 6)(mean)_all) post

*** Column 4: Probit - Rents per capita (Log) Interactions

xi: probit end c.l.lnrentspc#c.l.corr l.lnrentspc l.corr l.lnpcgdp l.dem l.ndem l.trade l.lnngo fyrs _spline1 _spline2 _spline3 if af==0, robust difficult
outreg2 using "r9", excel
*margins, dydx(l.lnrentspc) at(l.corr=(0 (1) 6)(mean)_all) post


