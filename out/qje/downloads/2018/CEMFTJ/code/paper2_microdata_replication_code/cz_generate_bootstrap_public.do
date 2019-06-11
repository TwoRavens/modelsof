/***
 This program generates raw bootstrapped causal estimates at the Commuting Zone level for all the outcomes
 Inputs: raw bootstrapped estimates by CZ sent out of IRS
 Output: raw causal bootstrapped place effects at the CZ level
 
	Note: the input data to this script is not publicly available.
	All variable inputs come from the output of %make_beta_ijs_bs() in beta_macros_vSubmission_public
***/

clear all
set matsize 5000
set maxvar  32767 

global irsdata "/Users/${user}/Dropbox/movers/analysis/irsdata/cz_2steps_boot_final/"
global save "/Users/${user}/Dropbox/movers/analysis/beta/beta_final/CZ_boot/used_specs/"
global save2 "/Users/${user}/Dropbox/movers/analysis/beta/beta_final/CZ_boot/other_specs/"

********************************************************************************
* SPECS USED IN FINAL_CZ DATASET
********************************************************************************

foreach outcome in kr26 kir26 c1823 { 
foreach spec in "_cc2" {

forvalue it=1(1)100{
foreach ppp in 1 25 50 75 99 { 

di in red "outcome `outcome'`spec'" 
di in red " P `ppp' iteration `it'"


* input data and generate beta ij and precision weights
use "${irsdata}beta_v12_bs_cz`outcome'`spec'.dta", clear
keep if n_od_`it'>=25

* compute beta ij, variance and precision weights
g Bij_`ppp'_`it' = -100*(ageatmove_`it' + (`ppp'/100) * ageatmove_par_rank_n_`it')
gen var_ageatmove_`it' = se_ageatmove_`it'^2
gen var_ageatmove_par_rank_n_`it' = se_ageatmove_par_rank_n_`it'^2
gen var_Bij_p`ppp'_`it' = (100^2)*(var_ageatmove_`it' +((`ppp'/100)^2)*var_ageatmove_par_rank_n_`it' + 2*(`ppp'/100)*cov_`it')
gen inv_var_`ppp'_`it' = 1/var_Bij_p`ppp'_`it'

* create gary's matrix
local rhs=""
rename par_cz_orig o
rename par_cz_dest d
drop if o == 0 | d == 0
qui levelsof d, local(d)
qui levelsof o, local(o)
local places : list o | d
qui foreach p of local places {
if "`p'"!="19400"{
  gen p`p' = (d == `p')
  replace p`p' = -1 if o == `p'
  local rhs "`rhs' p`p'"
}
}

* regress beta ij on gary's matrix
qui reg Bij_`ppp'_`it' `rhs' [w=inv_var_`ppp'_`it'], nocons
clear
local wc : word count `places'
set obs `wc'
gen cz = .
gen Bj_p`ppp'_cz`outcome'`spec'_`it' = .
local i = 1
qui foreach p of local places {
if "`p'"!="19400"{
  replace cz = `p' in `i'  
  replace Bj_p`ppp'_cz`outcome'`spec'_`it' = 0 in `i'
  replace Bj_p`ppp'_cz`outcome'`spec'_`it' = _b[p`p'] in `i'
  }
 else if "`p'"=="19400"{
  replace cz = `p' in `i'
  replace Bj_p`ppp'_cz`outcome'`spec'_`it' = 0 in `i' 
}
  local ++i
  }
  
* Take care of the connected sets issue 

count if Bj_p`ppp'_cz`outcome'`spec'_`it' ==0
local N_zero = r(N)

if `N_zero'>1{

local N_zero2 = `N_zero'-1 
tab cz if Bj_p`ppp'_cz`outcome'`spec'_`it'==0 & cz ~= 19400 ,  matrow(badcz) 
di in red "ERROR : `outcome'`spec' ; Nb beta = 0 is `N_zero2'"
matrix list badcz

local bad = `N_zero' 
while `bad' > 1 {

gen goodcz = .
replace goodcz = 1 if Bj_p`ppp'_cz`outcome'`spec'_`it'!=0 
replace goodcz = 1 if cz==19400
qui levelsof cz if goodcz ==1 , local(places)

* re-input data and start over with new place list
use "${irsdata}beta_v12_bs_cz`outcome'`spec'.dta", clear
keep if n_od_`it'>=25

local N_badczs = `N_zero' - 1
forval bads = 1(1)`N_badczs' {
	local badcz = badcz[`bads',1]
	drop if par_cz_orig == `badcz' | par_cz_dest == `badcz'
}

* compute beta ij, variance and precision weights
g Bij_`ppp'_`it' = -100*(ageatmove_`it' + (`ppp'/100) * ageatmove_par_rank_n_`it')
gen var_ageatmove_`it' = se_ageatmove_`it'^2
gen var_ageatmove_par_rank_n_`it' = se_ageatmove_par_rank_n_`it'^2
gen var_Bij_p`ppp'_`it' = (100^2)*(var_ageatmove_`it' +((`ppp'/100)^2)*var_ageatmove_par_rank_n_`it' + 2*(`ppp'/100)*cov_`it')
gen inv_var_`ppp'_`it' = 1/var_Bij_p`ppp'_`it'

* create gary's matrix
local rhs=""
rename par_cz_orig o
rename par_cz_dest d
drop if o == 0 | d == 0
qui foreach p of local places {
if "`p'"!="19400"{ // NYC 19400
  gen p`p' = (d == `p')
  replace p`p' = -1 if o == `p'
  local rhs "`rhs' p`p'"
}
}

* regress beta ij on gary's matrix
qui reg Bij_`ppp'_`it' `rhs' [w=inv_var_`ppp'_`it'], nocons
clear
local wc : word count `places'
set obs `wc'
gen cz = .
gen Bj_p`ppp'_cz`outcome'`spec'_`it' = .
local i = 1
qui foreach p of local places {
if "`p'"!="19400"{ // NYC 19400
  replace cz = `p' in `i'  
  replace Bj_p`ppp'_cz`outcome'`spec'_`it' = 0 in `i' 
  replace Bj_p`ppp'_cz`outcome'`spec'_`it' = _b[p`p'] in `i'
  }
 else if "`p'"=="19400"{
  replace cz = `p' in `i'
  replace Bj_p`ppp'_cz`outcome'`spec'_`it' = 0 in `i' 
}
  local ++i
  }
 
count if Bj_p`ppp'_cz`outcome'`spec'_`it' ==0
local N_zero = r(N)

local N_zero2 = `N_zero'-1 
tab cz if Bj_p`ppp'_cz`outcome'`spec'_`it'==0 & cz ~= 19400 ,  matrow(badcz) 
di in red "ERROR : `outcome'`spec' ; Nb beta = 0 is `N_zero2'"
matrix list badcz

local bad = `N_zero'  
 
}
}

tempfile perc`ppp'
save `perc`ppp''
}

* merge percentiles together
foreach ppp in 1 25 50 75 99  { 
merge 1:1 cz using `perc`ppp'', nogen
} 
	
tempfile boot_`it'
save `boot_`it''
}

forvalues t=1(1)99{
merge 1:1 cz using `boot_`t'', nogen
}

compress
save ${save}cz_`outcome'`spec'.dta, replace
}		
}




