*** Uses data from Imbs et all (2005, QJE) **

** Monthly observations, local currency **

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
*** Note: this file uses the Imbs et al aggregate data: 11 countries(end up dropping Finland, so 10), 19 sectors


clear all
capture log close
set more off
set mem 700m
set varabbrev off

local programpath "P:\BerginGlickWu Replication\Table 5\agg\programs"
local outpath1 "P:\BerginGlickWu Replication\Table 5\results"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"

global ImbsDataset "imbsdata_agg_lc_wide.dta"


/* Load the relevant variables of the datasets by product type, run the regresssions, 
   store the results in matrix, then open up the next product dataset.
*/
program drop _all

cd "`programpath'"
set maxvar 30000
set matsize 5000

local numcountries = 10
local type "CCEP ECM"

**************************************************
*						 *
****************** Estimation on Imbs aggregate panel
*						 *
**************************************************


local filename "ecm_full_imbsdata_AGG.csv"

capture program drop _all
matrix avg_stat1_ = J(1,11,.)
matrix avg_stat2_ = J(1,11,.)


	global j = 1
	use date p_* s_* using "`datapath'/$ImbsDataset", clear
	ccep_ecm_imbsdata, group(`numcountries') 




forvalues m=1/2 {
	store_results_ccep`m'_ecm_full
	outsheet using "`outpath1'\ccep`m'_`filename'", comma names replace
}


capture log close
exit


