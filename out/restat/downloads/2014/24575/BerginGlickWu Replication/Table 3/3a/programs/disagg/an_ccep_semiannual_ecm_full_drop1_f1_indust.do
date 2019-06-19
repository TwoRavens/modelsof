*** Uses first filter: complete balanced sample **

** Seminnual observations, local currency **

** Part 3

/*
//      ======================================     Pesaran (2006, Econometrica) CCEMG =========================================
//      The program is used to compute CCEMG estimate and of an bivariate VECM(1) model
///
//      VECM(1) Model:   ds(ij, t)_k = a1(ij)_k + b1(ij)_k*q(ij,t-1)_k + c1(ij)_k*ds(ij,t-1)_k +c2(ij)_k*dp(ij,t-1)+ e(ij,t)_k.           ij=1,...,N; k=1,,,,K;  t=1,...,T.
//                                      dp(ij, t)_k = a2(ij)_k + b2(ij)_k*q(ij,t-1)_k + d1(ij)_k*ds(ij,t-1)_k +d2(ij)_k*dp(ij,t-1)+ e(ij,t)_k.           ij=1,...,N; k=1,,,,K;  t=1,...,T.
//
//      Regression equation:      ds(ij, t)_k = a1(ij)_k + b1(ij)_k*q(ij,t-1)_k + c1(ij)_k*ds(ij,t-1)_k +c2(ij)_k*dp(ij,t-1)+e1(ij)_k*ds_bar(t) + e2(ij)_k*q_bar(t-1) + e3(ij)_k*ds_bar(t-1) +  e4(ij)_k*dp_bar(t-1) + v(ij,t)_k   
//                                             dp(ij, t)_k = a2(ij)_k + b2(ij)_k*q(ij,t-1)_k + f1(ij)_k*ds(ij,t-1)_k +f2(ij)_k*dp(ij,t-1)+g1(ij)_k*ds_bar(t) + g2(ij)_k*q_bar(t-1) + g3(ij)_k*ds_bar(t-1) +  g4(ij)_k*dp_bar(t-1) + v(ij,t)_k   
//      where s, p and q are nominal exchange rate, price differential and real exchange rate respectively.
//      Software:  STAT
//      Provider:  Jyh-Lin Wu 
//     =============================================================================================================

*/
*** Note: this file uses the Industrial cutdown sample: i.e. (industrial country)/(US) pairs


clear all
capture log close
set more off
set mem 720m
set varabbrev off

local programpath "P:\BerginGlickWu Replication\Table 3\3a\programs\disagg"
local outpath1 "P:\BerginGlickWu Replication\Table 3\results\3a"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"


/* Load the relevant variables of the datasets by product type, run the regresssions, 
   store the results in matrix, then open up the next product dataset.
*/
program drop _all

cd "`programpath'"
set maxvar 30000
set matsize 5000

local nirp = 40
local type "CCEP ECM"
**************************************************
*						 *
****************** Traded Goods ******************
*						 *
**************************************************


*
************* Seminnual - Traded - PW - Filter 1 ************
*

local filename "semiannual_PW_ecm_full_drop1_d1_indust.csv"

capture program drop _all
matrix avg_stat1_ = J(101,11,.)
matrix avg_stat2_ = J(101,11,.)

forvalues i = 1/101 {
	global j = `i'
	use series_title date q* s* ERprod_PWonecity* if series_title == `i' using "`datapath'\semiannual_lc_drop1_f1_wide_`descrip'.dta", clear
	ccep_semi_ecm_full_pw_v2, group(532) type("`type'") nirp(`nirp')
}

forvalues m=1/2 {
	store_results_ccep`m'_ecm_full
	outsheet using "`outpath1'\ccep`m'_`filename'", comma names replace
}

capture log close

exit


