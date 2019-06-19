*** Uses first filter: complete balanced sample **

** Semiannual observations, aggregate price level **

** Drop intracountry pairs

/* This program is a first-run at the following regression:
   	LHS: change in q (for a given product k, t minus t-1)
   	RHS: lagged q (ij,k,t) , delta avg q, constant
   	
*/
** Modified by Andy Cohn, Oct2008

clear all
capture log close
set more off
set mem 720m
set varabbrev off

global programpath "P:\BerginGlickWu Replication\Table 1\programs"
local outpath1 "P:\BerginGlickWu Replication\Table 1\results"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"

local descrip "indust"
local filename "agg_semiannual_nsc_drop1_f1_`descrip'.csv"

**cd U:\Ann\Reuven\Bergin\BGW\Programs
cd "$programpath"
set maxvar 30000
set matsize 5000

local pairs = 420

**************************************************
*						 *
****************** Traded Goods ******************
*						 *
**************************************************

capture program drop _all
matrix avg_stat1_ = J(2,7,.)
matrix avg_stat2_ = J(2,7,.)

*
************* Semiannual - Traded - PW - Filter 1 ************
*

global j = 1

use "`datapath'\aggregate_semiannual_nsc_drop1_f1_wide_`descrip'.dta", clear

reg1_agg_semiannual_pw, group(`pairs')


**************************************************
*						 *
*************** Non-Traded Goods *****************
*						 *
**************************************************

*
************* Semiannual - Non-Traded - PW - Filter 1 ************
*

global j = 2

use "`datapath'\aggregate_semiannual_nt_nsc_drop1_f1_wide_`descrip'.dta", clear

reg1_agg_semiannual_pw, group(`pairs')


** Store results
forvalues k=1/1{
	store_results`k'
	outsheet using "`outpath1'\reg`k'_`filename'", comma names replace
}



exit
