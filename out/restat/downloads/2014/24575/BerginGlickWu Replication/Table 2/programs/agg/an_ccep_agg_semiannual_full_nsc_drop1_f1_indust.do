*** Uses first filter: complete balanced sample **

** Drops intracountry pairs

** Semiannual observations, aggregate price level **

/*
      ======================================     Pesaran (2006, Econometrica) CCEP(hetro) ======================================

      The program is used to compute CCEP(hetro) estimate and its t ratrio provided by Pesaran (2006, Econometrica)
       The  equation number in the program relates to  Pesaran (2004, working paper)

      AR(1) Model:   q(ij, t)_k = a(ij)_k+b(ij)_k*q(ij,t-1)_k + e(ij,t)_k      ij=1,...,N; k=1,,,,K;  t=1,...,T.

      Regression equation:     q(ij, t)_k = a(ij)_k+b(ij)_k*q(ij,t-1)_k + c1(ij)_k*q_bar(t)+c2(ij)_k*(q_bar(t-1)+v(ij,t)_k     

      Software:  STAT
     Provider:  Jyh-Lin Wu 
    =============================================================================================================
*/
*** Note: this file uses the US cutdown sample: i.e. (...)/(US) pairs

** Modified by Andy Cohn, Oct 2008
clear all
capture log close
set more off
set mem 720m
set varabbrev off


global programpath "P:\BerginGlickWu Replication\Table 2\programs\agg"
local outpath1 "P:\BerginGlickWu Replication\Table 2\results"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"

local descrip "indust"
local filename "agg_semiannual_nsc_drop1_f1_`descrip'.csv"

cd "$programpath"
set maxvar 30000
set matsize 5000


**************************************************
*						 *
****************** Traded Goods ******************
*						 *
**************************************************

capture program drop _all
matrix avg_stat1_ = J(1,9,.)
matrix avg_stat2_ = J(1,9,.)


*
************* Semiannual - Traded - PW - Filter 1 ************
*

global j = 1

use "`datapath'\aggregate_semiannual_nsc_drop1_f1_wide_`descrip'.dta", clear

ccep_agg_semi_full_pw, group(420)


** Store results
forvalues m=1/2 {
	store_results_ccep`m'
	outsheet using "`outpath1'\ccep`m'_`filename'", comma names replace

}


exit
