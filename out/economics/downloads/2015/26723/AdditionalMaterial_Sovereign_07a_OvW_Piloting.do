
// ##############################################################################################
// *
// * dofile: Sovereign_07a_OvW_Piloting.do
// * author: Finn Marten Körner
// * last edit: 24/09/2013
// * source data:  /CRA/Data/output/analysis/Portfolio_Ratings_UnilateralDataset
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
if "`os'" == "Windows" 	global zentra "C:\Users\\`user'\PowerFolders\CRA\Data"
if "`os'" == "MacOSX" 	global dropbox "/Users/`user'/Desktop/Dropbox/CRA/Data"
if "`os'" == "Windows" 	global dropbox "C:\Users\`user'\Dropbox\CRA\Data"
if "`user'" == "VwlZenTra" global zentra "D:\PowerFolder\CRA\Data"
if "`user'" == "VwlZenTra" global dropbox "D:\Dropbox\CRA\Data"



cd
cd $zentra

// ##############################################################################################
// # 2. RANDOM effects estimation with ratings
// ##############################################################################################

use $zentra/output/analysis/Portfolio_Ratings_UnilateralDataset
// equivalent to: Sovereign_OvW_Piloting.dta

tsset num year, yearly

gen X_i = EWN_Portf_equity_liab + EWN_Debt_liab
bysort year: egen W_j = sum(EWN_Total_assets)
replace W_j = W_j - EWN_Total_assets
gen W_i = EWN_Total_assets
bysort year: egen A = total(EWN_Total_assets*10^-6)

// Select sample
levelsof isoalpha3code if X_i != . & X_i != 0 & year == 1976, local(countrylist_EWN) clean
forvalues t = 1971 (5) 2011 {
	qui count if X_i != . & X_i != 0 & year == `t'
	di as text"EWN PI holdings countries in "as input `t' as text" are: "as result `=r(N)'
}

forvalues t = 1971 (5) 2011 {
	qui count if WB_Portf_Inv_inflows != . & WB_Portf_Inv_inflows != 0 & year == `t'
	di as text"WB PI inflows countries in "as input `t' as text" are: "as result `=r(N)'
}

forvalues t = 1971 (5) 2011 {
	qui count if rating_20 != . & year == `t'
	di as text"Rated countries in "as input `t' as text" are: "as result `=r(N)'
}

// Select countries with non-missing EWN values and drop all others
gen keep = 0
foreach c of local countrylist_EWN {
	qui replace keep = 1 if isoalpha3code == "`c'"
}

replace keep = 0 if tin(,1975)
drop if keep == 0
sort num year
gen rtg_1st = rating_first
forvalues i = 1 / 4 {
	gen L`i'_rtg_1st = (rtg_1st[_n-`i'] == 1)
	label variable L`i'_rtg_1st "L`i'_rtg_1st_i"
}

// GET A PSEUDO R-SQUARED (McFADDEN'S)
// local r2_p = 1 - e(ll) / e(ll_0)
// Alternatively, generally:
// predict Yhat if e(sample)
// corr X_i_W_j Yhat if e(sample)
// local r2: di r(rho)^2

// Adjust rating variables
rename rating_20 rating_i
replace rating_i = . if rating_i > 21
gen rtg_stage = 0
replace rtg_stage = 2 if rating_i <= 21
replace rtg_stage = 1 if rating_i <= 14

gen invgrade_i = (rating_i >= 14 & rating_i <= 21)
gen invup_i = (invgrade_i > invgrade_i[_n-1] & num == num[_n-1])
label variable invgrade_i "invgrade_i"
gen invXrtg_i = invgrade_i * rating_i
label variable  invXrtg_i "invXrtg_i"
gen invXrtg_1st = invgrade_i * rating_first
label variable  invXrtg_1st "invXrtg_1st"

label variable  rating_i "rating_i"
label variable  kaopen "kaopen_i"
label variable  rtg_1st "rtg_1st_i"
label variable has_rating "has_rating"

// ################################################################################
// ESTIMATION EQUATION FOR PILOTING
// HOLDINGS
// (14) X_ij/W_j =α_0 S_i^(α_1 ) A^(α_2 ) 〖Π_i〗^(α_3 ) e^(θ_i d_i )
// ################################################################################

gen X_i_W_j = X_i / W_j
label variable X_i_W_j "X_i/W_j"
// gen ln_X_i_W_j = log(X_i_W_j)
gen S_i = EWN_Total_assets*10^-6
label variable S_i "S_i"
gen ln_S_i = log(S_i)
label variable ln_S_i "log(S_i)"
bysort year: egen ln_A = total(EWN_Total_assets*10^-6)
replace ln_A = log(ln_A)
label variable ln_A "log(A)"
// gen regid = 1 if X_i_W_j != . & S_i != . & has_rating != . & kaopen != .
gen no_rating = (rating_i == .)

local depvar "X_i_W_j"
local baseline "`depvar' ln_S_i ln_A i.year"
foreach model in  reg xtreg { // xtpoisson {
if "`model'" == "reg" {
	local options "if tin(1976,2011), cluster(num) robust"
	local options2 "if tin(1976,2011) & rating_i != ., cluster(num) robust"
	local reg "`model'"
}
if "`model'" == "xtreg" {
	local options "if tin(1976,2011), fe robust"
	local options2 "if tin(1976,2011) & rating_i != ., fe robust"
	local reg "`model'"
}
if "`model'" == "xtpoisson" {
	local options "if tin(1976,2011), fe robust"
	local options2 "if tin(1976,2011) & rating_i != ., fe robust"
	local reg "`model'"
}

// Estimate constant model
qui xi: `reg' `depvar' i.year `options'
local ll_0 = e(ll)

qui xi: `reg' `depvar' i.year `options2'
local ll_0_2 = e(ll)

local i = 1
xi: `reg' `baseline' 	 	`options'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0'
local ++i

xi: `reg' `baseline' 	rtg_stage 	`options'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0'
local ++i

xi: `reg' `baseline' 	rtg_1st invXrtg_1st `options2'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0_2'
local ++i

xi: `reg' `baseline' 			 rtg_1st invXrtg_1st L*_rtg_1st	`options2'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0_2'
local ++i

xi: `reg' `baseline' 			 rtg_1st invXrtg_1st L1_rtg_1st-L4_rtg_1st rating_i invXrtg_i	`options2'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0_2'
local ++i

xi: `reg' `baseline' 	rating_i invXrtg_i  `options2'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0_2'
local ++i

// Create pseudo R-squared values against ll(null)
matrix ll = (`r2_p_1')
local colnames = "X_i_W_j_`m' "
forvalues m = 2 / `=`i'-1' {
	di as text "LL of model `m' is "as input"`r2_p_`m''"
	matrix ll = (ll, `r2_p_`m'')
	local colnames = "`colnames'X_i_W_j_`m' "
}
matrix colnames ll = `colnames'
matrix rownames ll = R2_p
matrix list ll, format(%9.4f)

est table `model'_*, star(.1 .05 .01) stats(N ll aic bic) drop(*year*) b(%9.4f) label
}
est table *, star(.1 .05 .01) stats(N ll aic bic) drop(*year*) label

foreach target in zentra dropbox {
	local file "$`target'/output/tables/A Portfolio Home Bias/OvW_Piloting_holdings"
	outreg2 [X_i_W_j_*] using "`file'", replace word drop(_Iyear* _Inum*) fmt(%9.4f) // noparen
	outreg2 [X_i_W_j_*] using "`file'", replace tex  drop(_Iyear* _Inum*) fmt(%9.4f)
}

// ################################################################################
// ESTIMATION EQUATION PILOTING
// CHANGES (NET INFLOWS)
// (14) X_ij/W_j =α_0 S_i^(α_1 ) A^(α_2 ) 〖Π_i〗^(α_3 ) e^(θ_i d_i )
// ################################################################################
*/
gen dotX_i_W_j = WB_Portf_Inv_inflows * 10^-6 / W_j
label variable dotX_i_W_j "`=char(198)'X_i_W_j"
tsset num year, yearly
foreach var in S_i A {
	gen dot`var' = D.`var'
	label variable dot`var' "`=char(198)'`var'"
}

local depvar "dotX_i_W_j"
local baseline "`depvar' dotS_i dotA i.year"

local models "xtpoisson reg xtreg" //
foreach model in `models' {
if "`model'" == "reg" {
	local options "if tin(1976,2011), cluster(num) robust"
	local options2 "if tin(1976,2011) & rating_i != ., cluster(num) robust"
	local reg "`model'"
}
if "`model'" == "xtreg" {
	local options "if tin(1976,2011), fe robust"
	local options2 "if tin(1976,2011) & rating_i != ., fe robust"
	local reg "`model'"
}
if "`model'" == "xtpoisson" {
	local options "if tin(1976,2011) & dotX_i_W_j >= 0, fe robust"
	local options2 "if tin(1976,2011) & rating_i != . & dotX_i_W_j >= 0, fe robust"
	local reg "`model'"
}
local model "`model'"

// Estimate constant model
qui xi: `reg' `depvar' i.year `options'
local ll_0 = e(ll)

qui xi: `reg' `depvar' i.year `options2'
local ll_0_2 = e(ll)

local i = 1
xi: `reg' `baseline' 	 	`options'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0'
local ++i


xi: `reg' `baseline' 	rtg_stage 	`options'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0'
local ++i

xi: `reg' `baseline' 	rtg_1st invXrtg_1st `options2'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0'
local ++i

xi: `reg' `baseline' 			 rtg_1st invXrtg_1st L*_rtg_1st	`options2'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0'
local ++i

xi: `reg' `baseline' 			 rtg_1st invXrtg_1st L1_rtg_1st-L4_rtg_1st rating_i invXrtg_i	`options2'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0'
local ++i

xi: `reg' `baseline' 	rating_i invXrtg_i  `options2'
est sto `model'_`i'
local r2_p_`i' = 1 - e(ll)/`ll_0'
local ++i


// Create pseudo R-squared values against ll(null)
matrix r2_p = (`r2_p_1')
local colnames = "X_i_W_j_`m' "
forvalues m = 2 / `=`i'-1' {
	di as text "LL of model `m' is "as input"`r2_p_`m''"
	matrix r2_p = (r2_p, `r2_p_`m'')
	local colnames = "`colnames'X_i_W_j_`m' "
}
matrix colnames r2_p = `colnames'
matrix rownames r2_p = r2_p
matrix list r2_p, format(%9.4f)
}

foreach model in `models' {
	est table `model'*, star(.1 .05 .01) stats(N ll aic bic) drop(*year*) b(%9.4f) label
	est table `model'*, star(.1 .05 .01) stats(N ll aic bic) drop(*year*) label
}
foreach target in zentra dropbox {
	local file "$`target'/output/tables/A Portfolio Home Bias/OvW_Piloting_inflows"
	outreg2 [X_i_W_j_*] using "`file'", replace word drop(_Iyear* _Inum*) // noparen dec(3)
	outreg2 [X_i_W_j_*] using "`file'", replace tex  drop(_Iyear* _Inum*)
}


// ################################################################################
// ESTIMATION EQUATION PILOTING
// CHANGES (NET INFLOWS)
// (14) X_ij/W_j =α_0 S_i^(α_1 ) A^(α_2 ) 〖Π_i〗^(α_3 ) e^(θ_i d_i )
// ################################################################################

local baseline "`depvar' ln_S_i ln_A"
replace keep = 0
forvalues i = 1/10 {
	replace keep = 1 if L`i'_rtg_1st != 0 | rtg_1st != 0
}
drop if keep == 0

gen t = _n
tsset t, yearly

local reg "arima"
local options ", vce(robust)"

// Estimate constant model
xi: qui `reg' `depvar' `baseline' `options'
local ll_0 = e(ll)

predict yhat
gen res = yhat - `depvar'
corrgram res
wntestq res
qui reg res
archlm

forvalues d = 0 / 1 {
	forvalues q = 0 / 3 {
		forvalues p = 0 / 3 {
			local i = 1
			di as result "Estimate ARIMA(p,d,q) model with "as input `p' `d' `q'
			xi: qui `reg' `depvar' `baseline' `options' arima(`p',`d',`q')
			estat ic
			est sto ARIMA_`p'`d'`q'
			// Store pseudo R-squared
			local r2_p_`p'`d'`q' = 1 - e(ll)/`ll_0'
			local ++i
			// Make post-estimation tests on residuals
			predict yhat_`p'`d'`q'
			gen res_`p'`d'`q' = yhat_`p'`d'`q' - `depvar'
			qui corrgram res_`p'`d'`q'
			// Portmanteau White-Noise test
			wntestq res_`p'`d'`q'
			// ARCH-LM test on heteroskedasticity
			qui reg res_`p'`d'`q'
			archlm

		}
	}
}
