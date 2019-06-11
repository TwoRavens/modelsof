// ##############################################################################################
// *
// * dofile: Sovereign_07b_OvW_Home-bias-cutting.do
// * author: Finn Marten Körner
// * last edit: 24/09/2013
// * source data:  /CRA/Data/output/analysis/Portfolio_Ratings_BilateralDataset
// * target data:
// *
// * ORGANISATION:
// *
// ##############################################################################################

// ##############################################################################################
// # 0. PRELIMINARIES
// ##############################################################################################

clear
clear matrix
clear mata
set maxvar 10000
set mem 300m
set more off, perm
program drop _all
capture log close
local time_start = c(current_time)

global do   "do/"
global data "data/"
global output "output/"

local os: di c(os)
local user: di c(username)
if "`os'" == "MacOSX" 	global zentra "/Users/`user'/ZenTra/Data/Data"
if "`os'" == "Windows" 	global zentra "C:\Users\`user'\PowerFolders\CRA\Data"

cd
cd $zentra

// ##############################################################################################
// # 1. 	HOME BIAS ESTIMATION
// ##############################################################################################

use $zentra/output/analysis/Portfolio_Ratings_BilateralDataset
// equivalent to: Sovereign_OvW_Home-bias_cutting.dta

egen cpair = group(from_cou to_cou)
tsset cpair year, yearly

gen EMU_country = 0
label variable EMU_country "Country belongs to the EMU (=1)"
foreach country in Austria Belgium Cyprus Estonia Finland France Germany Greece Ireland Italy Luxembourg Malta Netherlands Portugal Slovakia Slovenia Spain {
	replace EMU_country = 1 if from_cou == "`country'" | to_cou == "`country'"
}
// gen Trade = GATT_ltrade / GATT_lrgdp
gen Legal = 1 if from_LaPorta_uk_mom + to_LaPorta_uk_mom == 2 | from_LaPorta_frsp_mom + to_LaPorta_frsp_mom == 2 | to_LaPorta_scan_mom + from_LaPorta_scan_mom == 2 | from_LaPorta_ger_mom + to_LaPorta_ger_mom == 2
replace Legal = 0 if Legal == .

// drop empty market size values
drop if A_j == 0

// From equation (54) in Okawa & van Wincoop (2010: 21)
// tau = ( X_ij / W_j ) / (X_ii / W_i)^-1
gen tau_ii = (( X_ii / A_i ) / ( X_ii / A_i ))^(-1)
gen tau_ij = (( X_ij / A_j ) / ( X_ii / A_i ))^(-1)
gen tau_ji = (( X_ji / A_i ) / ( X_jj / A_j ))^(-1)


// rename dist_cepii_smctry Home
// rename ln_dist_cepii_distcap
// rename dist_cepii_comlang_off Language
// rename dist_cepii_contig Adjacent
// rename Legal Legal
// // rename GATT_custrict CU
// rename EMU_country CU
// // rename RegSim
// // rename TimeZone
// rename GATT_regional RTA
// // reg ln_tau Home D Trade Language Adjacent Legal CU RTA


// RENAME and adjust rating variables to fit gravity specification
rename from_rating_20 rating_j
rename to_rating_20 rating_i
rename to_kaopen kaopen_i
rename from_kaopen kaopen_j
rename to_rating_invupgrade invupgrade_i
rename from_rating_invupgrade invupgrade_j
rename to_rating_invdowngrade invdowngrade_i
rename from_rating_invdowngrade invdowngrade_j

foreach dir in i j {
	gen rtg_stage_`dir' = 0
	replace rtg_stage_`dir' = 2 if rating_`dir' <= 21
	replace rtg_stage_`dir' = 1 if rating_`dir' <= 14
	label variable rtg_stage_`dir' "rtg_stage_`dir'"
}

foreach k in i j {
	gen invgr_`k' = (rating_`k' >= 14)
	label variable  rating_`k' "rating_`k'"
	label variable  kaopen_`k' "kaopen_`k'"
	label variable invgr_`k' "invgrade_`k'"
	gen invXrtg_`k' = invgr_`k' * rating_`k'
	label variable  invXrtg_`k' "invXrtg_`k'"
	label variable invupgrade_`k' "invupgrade_`k'"
	label variable invdowngrade_`k' "invdowngrade_`k'"
}

// Create additional variables for home bias regression in gravity specification
local logs "nologs"
if "`logs'" == "logs" {
	gen HB_j = log(from_HB_FPI)
	gen Si_A = log((A_i) / A)
	bysort from_iso year: egen W_j_tau_A = total((W_j) / (tau_ij * A))
	replace W_j_tau_A = log(W_j_tau_A)
	gen Aj_A = log(1 - (A_j / A))
}
else {
	gen HB_j = from_HB_FPI
	gen Si_A = (A_i) / A
	gen ln_Si_A = log(Si_A)
	bysort from_iso year: egen W_j_tau_A = total((W_j) / (tau_ij * A))
	gen ln_W_j_tau_A = log(W_j_tau_A)
	bysort to_iso year: egen Etau_ij = total(tau_ij)
	gen ln_Etau_ij = log(Etau_ij)
	gen Aj_A = log(1 - (A_j / A))
}
label variable HB_j "HB_j"
label variable Si_A "Si/A"
label variable ln_Si_A "log(Si/A)"
label variable W_j_tau_A "W_k/tau_ik*A"
label variable ln_W_j_tau_A "log(W_k/tau_ik*A)"
label variable Etau_ij "tau_ij"
label variable ln_Etau_ij "log(tau_ij)"
label variable Aj_A "log(1-A_j/A)"

// Create weighted rating difference variables
bysort from_cou year: egen II_total = total(X_ij) if invgr_i == 1 & invgr_j == 1
bysort from_cou year: egen NI_total = total(X_ij) if invgr_i == 0 & invgr_j == 1
bysort from_cou year: egen IN_total = total(X_ij) if invgr_i == 1 & invgr_j == 0
bysort from_cou year: egen NN_total = total(X_ij) if invgr_i == 0 & invgr_j == 0
egen inv_total = rowtotal(II_total NI_total IN_total NN_total), missing
gen  inv_share = X_ij / inv_total
bysort from_cou invgr_i invgr_j year: egen rtgdiff_ij = mean((rating_j - rating_i)*inv_share)
gen inv_iXrtgdiff = invgr_i*rtgdiff_ij if invgr_i == 1 & invgr_j == 0
gen inv_jXrtgdiff = invgr_j*rtgdiff_ij if invgr_i == 0 & invgr_j == 1
gen inv_ijXrtgdiff = invgr_j*invgr_i*rtgdiff_ij  if invgr_i == 1 & invgr_j == 1
recode *diff* (. = 0)
replace rtgdiff_ij = 0 if invgr_i == 1 | invgr_j == 1

label variable GATT_ltrade "log(trade)"
label variable GATT_ldist  "log(distance)"
label variable GATT_comlang "comlang"
label variable GATT_border "border"
label variable GATT_curcol "colonial"
label variable GATT_rta "trade_agr"

gen W_tau = W_j_tau_A / Etau_ij
gen ln_W_tau = log(W_tau)
label variable W_tau "W_k/tau_ik*A / tau_ij"
label variable ln_W_tau "log(W_k/tau_ik*A / tau_ij)"

gen ln_HB_j = log(HB_j)
label variable ln_HB_j "log(HB_j)"


// ##############################################################################################
// # 1.1 	Home bias estimation
est drop _all

// Estimation equation
tsset cpair year, yearly
// Reduce sample to (2001-2011) and with non-missing HB and A_j values
keep if tin(2001,2011)
keep if to_HB_FPI != .
replace Aj_A = log((1 - (A_j / A))*10^-6)

local depvar "HB_j"
local gravityvars "ln_Si_A ln_W_j_tau_A ln_Etau_ij Aj_A"
local gravityvars2 "ln_Si_A W_j_tau_A Etau_ij Aj_A"
local gravityvars3 "ln_Si_A ln_W_tau Aj_A"
local macrovars " to_ca_gdp "
local finvars " kaopen_j "
local invgrade " invgr_j"
local ratingvars "rating_j"
local otherratingvars "invupgrade_j invdowngrade_j "
local insecvars "L.to_ratingaction to_WB_GDP_deflator"
local othergravityvars "GATT_ltrade GATT_ldist GATT_comlang GATT_border  GATT_rta"
local fixed_effects "i.year"
local from "2001"
local to "2011"

local models " xtpoisson cgmreg xtreg"
foreach model in `models' {
local no = 1
if "`model'" == "cgmreg" {
	local depvar "ln_HB_j"
	local restraints  "if tin(`from',`to') & HB_j >= 0 & HB_j <= 1, cluster(num) "
	local restraints2 "if tin(`from',`to') & HB_j >= 0 & HB_j <= 1 & rating_j != ., cluster(num) "
	local reg "`model'"
}
if "`model'" == "xtreg" {
	local depvar "ln_HB_j"
	local restraints  "if tin(`from',`to') & HB_j >= 0 & HB_j <= 1, fe robust"
	local restraints2 "if tin(`from',`to') & HB_j >= 0 & HB_j <= 1 & rating_j != ., fe robust"
	local reg "`model'"
}
if "`model'" == "xtpoisson" {
	local depvar "HB_j"
	local restraints  "if tin(`from',`to') & HB_j >= 0 & HB_j <= 1, fe robust"
	local restraints2 "if tin(`from',`to') & HB_j >= 0 & HB_j <= 1 & rating_j != ., fe robust"
	local reg "`model'"
}
local model "`model'_`from'_`to'"


// Estimate constant model
qui xi: `reg' `depvar' `fixed_effects' `restraints'
local ll_0 = e(ll)
qui xi: `reg' `depvar' `fixed_effects' `restraints2'
local ll_02 = e(ll)

// 1a Baseline estimation
qui xi: `reg' `depvar' `gravityvars' `fixed_effects' `restraints'
est store `model'_`no'
local r2_p_`no' = 1 - e(ll)/`ll_0'
local ++no

// 1b Baseline estimation
qui xi: `reg' `depvar' `gravityvars' `fixed_effects' rtgdiff_ij inv*rtgdiff `restraints'
est store `model'_`no'
local r2_p_`no' = 1 - e(ll)/`ll_0'
local ++no

// 2b Baseline: investment grade dummy
qui xi: `reg' `depvar' `gravityvars' 		`fixed_effects' `invgrade' `restraints'
est store `model'_`no'
local r2_p_`no' = 1 - e(ll)/`ll_0'
local ++no

// 1c Baseline estimation
qui xi: `reg' `depvar' `gravityvars' `fixed_effects'  `ratingvars' 	`restraints2'
est store `model'_`no'
local r2_p_`no' = 1 - e(ll)/`ll_02'
local ++no

// 2a Baseline: financial development and capital account openness
qui xi: `reg' `depvar' `gravityvars'  `ratingvars' `fixed_effects' invXrtg_j  `restraints2'
est store `model'_`no'
local r2_p_`no' = 1 - e(ll)/`ll_02'
local ++no

// 2a Baseline: financial development and capital account openness
qui xi: `reg' `depvar' `gravityvars'  `ratingvars' invXrtg_j `fixed_effects' rtgdiff_ij inv*rtgdiff `otherratingvars' `restraints2'
est store `model'_`no'
local r2_p_`no' = 1 - e(ll)/`ll_02'
local ++no
/*
// 3a Baseline: other rating variables
// xi: `reg' `depvar' `gravityvars'  `ratingvars'  `fixed_effects' `finvars' invXrtg_* `restraints'
// est store `model'_`no'
// local r2_p_`no' = 1 - e(ll)/`ll_0'
// local ++no

// 3b Baseline: investment security variables
// xi: `reg' `depvar' `gravityvars' 			 `fixed_effects' `finvars' `otherratingvars' `insecvars' if tin(`from',`to') `restraints'
// est store `model'_`no'
// local ++no

// 3b Baseline: other gravity variables
qui xi: `reg' `depvar' `gravityvars'  `othergravityvars' `fixed_effects'  `restraints2'
est store `model'_`no'
local r2_p_`no' = 1 - e(ll)/`ll_02'
local ++no

// 3c Baseline: other gravity and rating variables
qui xi: `reg' `depvar' `gravityvars'  `ratingvars' `invgrade' `fixed_effects' invXrtg_j `othergravityvars' `restraints2'
est store `model'_`no'
local r2_p_`no' = 1 - e(ll)/`ll_02'
local ++no
*/
// Create pseudo R-squared values against ll(null)
matrix ll = (`r2_p_1')
local colnames = "HB_j_`m' "
forvalues m = 2 / `=`no'-1' {
	di as text "LL of model `m' is "as input"`r2_p_`m''"
	matrix ll = (ll, `r2_p_`m'')
	local colnames = "`colnames'HB_j_`m' "
}
matrix colnames ll = `colnames'
matrix rownames ll = r2_p
matrix list ll, format(%9.4f)

est table `model'*, star stats(N ll aic bic) drop(*year*) label b(%9.4f)
est table `model'*, star stats(N ll aic bic) drop(*year*) label

}

foreach model in `models' {
	est table `model'*, star(.1 .05 .01) stats(N ll aic bic) drop(*year*) b(%9.4f) label
	est table `model'*, star(.1 .05 .01) stats(N ll aic bic) drop(*year*) label
}
