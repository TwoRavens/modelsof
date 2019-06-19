*** Uses first filter: complete balanced sample **
** Drop intracountry pairs
** SemiAnnual observations **
** Created by Andy Cohn Sept 2008

/*
     ======================================     Pesaran (2006, Econometrica) CCEMG   ======================================
      The program is used to compute CCEMG estimate and its t ratrio provided by Pesaran (2006, Econometrica)
       The  equation number in the program relates to Pesaran (2004, working paper)

      AR(1) Model:   q(ij, t)_k = a(ij)_k+b(ij)_k*q(ij,t-1)_k + e(ij,t)_k      ij=1,...,N; k=1,,,,K;  t=1,...,T.

      Regression equation:     q(ij, t)_k = a(ij)_k+b(ij)_k*q(ij,t-1)_k + c1(ij)_k*q_bar(t)+c2(ij)_k*(q_bar(t-1)+v(ij,t)_k     
*/
*** Note: this file uses the US cutdown sample: i.e. (...)/(US) pairs


clear all
capture log close
set more off
set mem 700m
set varabbrev off
capture program drop _all


local descrip "indust"

global programpath "P:\BerginGlickWu Replication\Table 2\programs\disagg"
local outpath1 "P:\BerginGlickWu Replication\Table 2\results"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"

/* Load the relevant variables of the datasets by product type, run the regresssions, 
   store the results in matrix, then open up the next product dataset.
*/

cd "$programpath"
set maxvar 20000
set matsize 5000
set varabbrev off

**************************************************
*						 *
****************** Traded Goods ******************
*						 *
**************************************************

*
************* SemiAnnual - Traded - PW - Filter 1 ************
*

capture program drop _all
matrix avg_stat1_ = J(101,5,.)
matrix avg_stat2_ = J(101,9,.)

local filename "semiannual_full_nsc_PW_drop1_f1_`descrip'.csv"
global sample "II_ccep_semi_constr_nsc_pw_f1"

forvalues i = 1/101 {
	global j = `i'
	use series_title date q* ERprod_PWonecity* if series_title == `i' using "`datapath'\semiannual_nsc_drop1_f1_wide_indust.dta", clear
	ccep_semiannual_pw_full, group(532)
}

forvalues m=1/2 {
	store_results_ccep`m'
	outsheet using "`outpath1'\ccep`m'_`filename'", comma names replace
}



capture log close
exit


