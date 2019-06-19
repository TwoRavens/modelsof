/* AllcottWoznyProjectMaster.do */
/* Hunt Allcott and Nathan Wozny (2012) */
/* This is the master do file for the paper, "Gasoline Prices, Fuel Economy, and the Energy Paradox." */
/* Notes:

 */

/* SETUP */
clear all
capture cd C:/Analysis
capture cd C:/Users/Hunt/Documents/IDR/Analysis 
set mem 5g
set more off


/* OTHER */
include Calculate_r.do 


/* DATA PREP */
include DataPrep.do


/* REGRESSIONS */
include Estimation/SumStats
include Estimation/MakeTable3
include Estimation/MakeTable3Mart
include Estimation/MakeTable4
include Estimation/MakeTable5
include Estimation/MakeTable5Mart
include Estimation/MakeTable6
include Estimation/MakeTable7
include Estimation/MakeTablesNL
include Estimation/MakeTableMisc


/* GRAPHS */
include DataGraphs.do


*
