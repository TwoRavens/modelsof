/* Created by Alec Kennedy on 9/27/2011
This program takes the unrestricted irf_coeffs after going through the "irf_newPT3_cvd" ado file, and calculates half-lives
by individual good IRF instead of taking the half-life of the average of the 101 goods.

*/

matrix drop _all
clear
clear results
clear mata
capture log close
set more off
set mem 700m
set varabbrev off

local programpath "P:\BerginGlickWu Replication\Table 8\8a\programs"
local outpath1 "P:\BerginGlickWu Replication\Table 8\results\8a"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"

global datasetPWT "irfcoeffs_only_semiannual_PW_f1_indust.dta"

local numgoods = 101
local nirp = 40
cd "`programpath'"

************************************************************
** Reading in the data
************************************************************

use "`datapath'/$datasetPWT", clear

************************************************************
** Cleaning the data
************************************************************
keep if horizon <= `nirp'
keep girff*
renpfix girff_

************************************************************
** calculating the half-lives by good and storing them
************************************************************
* calculating the half-lives
forvalues k = 1/`numgoods'{
	* checking to see if the good has data
	clear results
	capture quietly summ *_good`k'
	capture local goodexists_`k' = r(mean)
	
	if `goodexists_`k'' != . {
		mkmat *_good`k', matrix(irf_good`k')
		halflife_calc irf_good`k'			//half-life calculation
		mat hl_good`k' = r(halflife)
	}
}

* storing the results
mat missing = J(1,15,.)
forvalues k = 1/`numgoods'{
	if `goodexists_`k'' != . {
		if `k' == 1{
			mat hl = hl_good`k'
		}
		else{
			mat hl = hl\hl_good`k'
		}
	}
	else{
		mat hl = hl\missing
	}
}
local colnames : colnames(hl)
local colnames = subinstr("`colnames'","_good1","",.)
mat colnames hl = `colnames'

clear
set obs `numgoods'
gen good = _n
svmat hl, names(col)

************************************************************
** outputting the results
************************************************************
local filename "ccep_halflives_unrestricted_ecm_newPT3_semiannual_PW_f1_indust.csv"
outsheet good q* using "`outpath1'/`filename'", comma replace

log close
exit



