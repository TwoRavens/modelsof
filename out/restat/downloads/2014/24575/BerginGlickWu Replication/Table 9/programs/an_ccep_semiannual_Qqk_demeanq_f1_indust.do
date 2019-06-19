*** Uses first filter: complete balanced sample **

** Seminnual observations, local currency **

*** Written by Andy Cohn, Aug 2009
*** Note: this file uses the Indust cutdown sample: i.e. (industrial country)/(US) pairs
*** Note that this file uses the alternate 'demeanq' variant, wherein qk on the RHS is replaced by qk-Q

matrix drop _all
clear
clear results
clear mata
capture log close
set more off
set mem 700m
set varabbrev off



local programpath "P:\BerginGlickWu Replication\Table 9\programs"
local outpath1 "P:\BerginGlickWu Replication\Table 9\results"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"

global datasetPWT "semiannual_lc_newPT3_PWT_f1_wide_indust.dta"



/* Load the relevant variables of the datasets by product type, run the regresssions, 
   store the results in matrix, then open up the next product dataset.
*/
capture program drop _all

cd "`programpath'"
set maxvar 30000
set matsize 5000

local tsobs = 35
local numgoods = 101
local numpairs = 20
local nirp = 40
**************************************************
*						 *
****************** Traded Goods ******************
*						 *
**************************************************



*
************* Seminnual - Traded - PW - Filter 1 ************
*

local filename "Qqk_demeanq_semiannual_PW_f1_indust.csv"



	use "`datapath'/$datasetPWT", clear
	ccep_pt2_Qqk_demeanq, group(`numpairs') goods(`numgoods') nirp(`nirp') tsobs(`tsobs')

	
	outsheet using "`outpath1'/`filename'", comma replace
	

capture log close

exit


