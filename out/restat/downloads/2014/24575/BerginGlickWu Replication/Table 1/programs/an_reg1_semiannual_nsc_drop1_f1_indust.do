***Obsolete
*** Uses first filter: complete balanced sample **
** Drop intracountry pairs
** Semiannual observations ***

/* This program is a first-run at the following regression:
   	LHS: change in q (for a given product k, t minus t-1)
   	RHS: lagged q (ij,k,t) , delta avg q, constant
   	
*/
*** Note: this file uses the Industrial version of the US cutdown sample: i.e. (industrial countries)/(US) pairs

clear all
capture log close
set more off
set mem 700m
set varabbrev off



/* Load the relevant variables of the datasets by product type, run the regresssions, 
   store the results in matrix, then open up the next product dataset.
*/

global programpath "P:\BerginGlickWu Replication\Table 1\programs"
local outpath1 "P:\BerginGlickWu Replication\Table 1\results"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"

local descrip "indust"

cd "$programpath"
set maxvar 30000
set matsize 5000

local pairs = 532

**************************************************
*						 *
****************** Traded Goods ******************
*						 *
**************************************************


*
************* SemiAnnual - Traded - PW - Filter 1 ************
*

capture program drop _all
matrix avg_stat1_ = J(101,7,.)
matrix avg_stat2_ = J(101,7,.)

global sample "I_semi_constr_nsc_pw_f1"
local filename "semiannual_nsc_PW_drop1_f1_`descrip'.csv"

forvalues i = 1/101 {
	global j = `i'
	use series_title date q* ERprod_PWonecity* if series_title == `i' using "`datapath'\semiannual_nsc_drop1_f1_wide_`descrip'.dta", clear
	reg1_semiannual_pw, group(`pairs')
}

** Storing /outputting results
forvalues k=1/1 {
	store_results`k'
	outsheet using "`outpath1'\reg`k'_`filename'", comma names replace

}



**************************************************
*						 *
*************** Non-Traded Goods *****************
*						 *
**************************************************


*
************* SemiAnnual - Non-Traded - PW - Filter 1 ************
*

capture program drop _all
matrix avg_stat1_ = J(37,7,.)
matrix avg_stat2_ = J(37,7,.)

global sample "I_semi_nt_constr_nsc_pw_f1"
local filename "semiannual_nt_nsc_PW_drop1_f1_`descrip'.csv"

forvalues i = 1/37 {
	global j = `i'
	use series_title date q* ERprod_PWonecity* if series_title == `i' using "`datapath'\semiannual_nt_nsc_drop1_f1_wide_`descrip'.dta", clear
	reg1_semiannual_pw, group(`pairs')
}

** Storing /outputting results
forvalues k=1/1 {
	store_results`k'
	outsheet using "`outpath1'\reg`k'_`filename'", comma names replace

}



capture log close

exit
