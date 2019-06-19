
clear
clear mata

set more off
set mem 200m
est clear

use aha_final_esr.dta

keep if south == 1
keep if year >= 1970 & year <= 1990

xi i.year i.stateEconArea


**
* set-up
** 
local clusterVariable = "fipsStateCode"
local absorbVariable  = "stateEconArea"

local aha_var = "exptot"
local instrument = "sizeXlogoil"

global fs_stats = "effect_1sd_size effect_2sd_size"

global absorbVariable = "`absorbVariable'"
global instrument = "`instrument'"



**
* baseline, cluster at state
**
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
xi i.year i.stateEconArea

ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable') 
 est store baseline_iv

predict resid, resid
sort stateEconArea year
by stateEconArea: gen resid_prev = resid[_n - 1]
reg resid resid_prev


sort `absorbVariable' year
by `absorbVariable': gen lagged_depvar = log_`aha_var'[_n - 1] if year == year[_n - 1] + 1
ivreg log_`aha_var' (log_payroll = `instrument') lagged_depvar _I* [aw=wgt], cluster(`clusterVariable') 
est store lagged_depvar
nlcom _b[log_payroll] / (1 - _b[lagged_depvar])


/**
sort `absorbVariable' year
by `absorbVariable': gen lagged_depvar3 = log_`aha_var'[_n - 4]
ivreg log_`aha_var' (log_payroll lagged_depvar = `instrument' lagged_depvar3) _I* [aw=wgt], cluster(`clusterVariable') 
est store lagged_depvar2
nlcom _b[log_payroll] / (1 - _b[lagged_depvar])
 **/


preserve
xi i.year i.stateEconArea
**xtset stateEconArea year
tsset stateEconArea year


**
* FIRST DIFFERENCES
**
reg D.log_payroll D.`instrument' _Iy*, cluster(`clusterVariable')
ivreg D.log_`aha_var' (D.log_payroll = D.`instrument') _Iy*, cluster(`clusterVariable')

**ivreg log_`aha_var' (log_payroll lagged_depvar = `instrument' L4.log_`aha_var') _I*, cluster(`clusterVariable')
**ivreg log_`aha_var' (log_payroll lagged_depvar = `instrument' L2.log_`aha_var') _I*, cluster(`clusterVariable')
**ivreg log_`aha_var' (log_payroll lagged_depvar = `instrument' L4.log_`aha_var' L5.log_`aha_var') _I*, cluster(`clusterVariable')
**nlcom _b[log_payroll] / (1 - _b[lagged_depvar])
**kaboom


xi i.year
local lags = 1
local maxldep = 2
local maxlags = 2

**replace sizeXlogoil_fd = D.sizeXlogoil

xtabond log_`aha_var' log_payroll _Iy*, inst(sizeXlogoil_fd) lags(`lags') maxldep(`maxldep') twostep artests(2) maxlags(`maxlags')
local sargan_val = e(sargan)
local sargan_df = e(sar_df)
global sarg_p2 =  1 - chi2(`sargan_df', `sargan_val')
local arm2 = e(arm2)
global arm2_p2 =  2*(1 - normal(abs(`arm2')))
local arm1 = e(arm1)
global arm1_p2 =  2*(1 - normal(abs(`arm1')))
xtabond log_`aha_var' log_payroll _Iy*, inst(sizeXlogoil_fd) lags(`lags') maxldep(`maxldep') vce(robust) artests(2) maxlags(`maxlags')
xtabond_noto 
ereturn list
est store `aha_var_str'_rf_ab38
**nlcom min_lr:_b[D.log_payroll]/(1-_b[LD.log_`aha_var']), post
**nlcom min_lr:_b[log_payroll]/(1-_b[L1.log_`aha_var']-_b[L2.log_`aha_var']), post
nlcom min_lr:_b[log_payroll]/(1-_b[L1.log_`aha_var']), post
est store `aha_var_str'_rf_ab_lr
restore


**
* IV-GLS ...
** 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
tab `absorbVariable', missing
bys `absorbVariable': keep if _N == 21

sort `absorbVariable' year
capture drop myn
by `absorbVariable': gen myn = _n

xi i.year i.`absorbVariable'

gen cons = 1
ivreg log_exptot (log_payroll = `instrument') _I* cons, noconstant cluster(fipsStateCode)
capture drop resid*
predict resid, resid
sort `absorbVariable' year
by `absorbVariable': gen resid_prev = resid[_n - 1]
by `absorbVariable': gen resid_prev2 = resid[_n - 2]
est store iv_gls_sample


**
* global AR(1)
**

rename `absorbVariable' `absorbVariable'_raw
egen `absorbVariable' = group(`absorbVariable')
summ `absorbVariable'
local N_g = r(max)
global N_g = r(max)

**forvalues type = 3(1)3 {
/**
 **
 Type
 1 - AR(1)
 2 - AR(1) (arima)
 3 - AR(2) (arima)
 4 - MA(1)
 5 - ARMA(1,1)
 **
 **/

foreach type of numlist 1 3 {

local rho_numer = 0
local rho_denom = 0
local rho2_numer = 0
local rho2_denom = 0
local ma_numer = 0
local ma_denom = 0
global N = 0

di "(Type=`type') Calculating rho_hat, rho2_hat and ma_hat ..."

forvalues g = 1(1)`N_g' {

 preserve
 keep if `absorbVariable' == `g'

 if (`type' == 1) {
  sort `absorbVariable' year
  qui reg resid resid_prev 
  local rho_numer = `rho_numer' + _b[resid_prev] * (e(N) + 1)
 }

 if (`type' == 2 | `type' >= 4) {
  tsset, clear
  tsset `absorbVariable' year
 }

 if (`type' == 2) {
  arima resid, ar(1)
  matrix b = e(b)
  matrix list b
  local rho_numer = `rho_numer' + b[1,2] * (e(N) + 1)
 }

 if (`type' == 3) {
  sort `absorbVariable' year
  qui reg resid resid_prev resid_prev2
  local rho_numer = `rho_numer' + _b[resid_prev] * (e(N) + 1)
  local rho2_numer = `rho2_numer' + _b[resid_prev2] * (e(N) + 1)
/**
  qui arima resid, ar(1/2)
  matrix b = e(b)
  matrix list b
  local rho_numer = `rho_numer' + b[1,2] * (e(N) + 1) 
  local rho2_numer = `rho2_numer' + b[1,3] * (e(N) + 1) 
 **/
 }

 if (`type' == 4) {
  arima resid, ma(1) 
  matrix b = e(b)
  matrix list b
  local ma_numer = `ma_numer' + b[1,2] * (e(N) + 1) 
 }

 if (`type' == 5) {
  arima resid, ar(1) ma(1) 
  matrix b = e(b)
  matrix list b
  local rho_numer = `rho_numer' + b[1,2] * (e(N) + 1) 
  local ma_numer = `ma_numer' + b[1,3] * (e(N) + 1) 
 }

 ** ereturn list
 local rho_denom = `rho_denom' + e(N) + 1
 local rho2_denom = `rho2_denom' + e(N) + 1
 local ma_denom = `ma_denom' + e(N) + 1

 restore 

** end for each grop
}
di "Done with loop... `rho_numer' , `rho_denom' ..."
local rho_hat = min(0.999, `rho_numer' / `rho_denom')
local rho_hat = max(-0.999, `rho_numer' / `rho_denom')
local rho2_hat = `rho2_numer' / `rho2_denom'
local ma_hat = `ma_numer' / `ma_denom'
di "global rho: `rho_hat' ..."
di "global rho2: `rho2_hat' ..."
di "global ma: `ma_hat' ..."

preserve

**foreach var of varlist log_exptot log_payroll `instrument' _I* cons {
foreach var of varlist log_exptot log_payroll _I* cons {

 qui {

  ** AR(1) or AR(2)
  if (`type' == 1 | `type' == 2) {
  capture drop q
  gen q = .
  sort `absorbVariable' year
  replace q = `var' - `rho_hat' * `var'[_n - 1]  if myn >= 2
  replace q = sqrt(1 - `rho_hat' * `rho_hat') * `var' if myn == 1
  replace `var' = q
  }

  if (`type' == 3) {
  
  capture drop q
  gen q = .
  sort `absorbVariable' year
  replace q = `var' - `rho_hat' * `var'[_n - 1] - `rho2_hat' * `var'[_n - 2] if myn >= 3
  replace q = `var' - `rho_hat' * `var'[_n - 1]  if myn == 2
  replace q = sqrt(1 - `rho_hat' * `rho_hat') * `var' if myn == 1
  replace `var' = q

  }

  if (`type' == 4) {
   sort `absorbVariable' year
   capture drop q
   gen q = .
   replace q = `var' - `ma_hat' * resid[_n - 1]
   replace `var' = q
  }

 }
}
ivreg log_exptot (log_payroll = `instrument') _I* cons, noconstant cluster(fipsStateCode)
do gls_h "exptot"
est store gls_global_`type'
restore

** end FOR EACH type
}






foreach panelvar of varlist fipsStateCode {

**
* state-specific AR(1)
**
preserve
capture drop `panelvar'_raw
rename `panelvar' `panelvar'_raw
egen `panelvar' = group(`panelvar')
summ `panelvar'
local N_s = r(max)
gen n = _n
gen rho_hat = .
forvalues s = 1(1)`N_s' {
 di "calculating rho s=`s' ..."
 qui {
 reg resid resid_prev if `panelvar' == `s'
 local rho_hat = min( 0.999, _b[resid_prev])
 local rho_hat = max(-0.999, `rho_hat')
 replace rho_hat = `rho_hat' if n == `s'
 }
 di "updating x's ..."
 qui {
 ** foreach var of varlist log_exptot log_payroll `instrument' _I* cons {
 foreach var of varlist log_exptot log_payroll _I* cons {
  capture drop q
  gen q = .
  sort `absorbVariable' year
  replace q = `var' - `rho_hat' * `var'[_n - 1]  if myn >= 2 & `panelvar' == `s'
  replace q = sqrt(1 - `rho_hat' * `rho_hat') * `var' if myn == 1 & `panelvar' == `s'
  replace `var' = q if `panelvar' == `s'
 }
 }
}
summ rho*_hat, det
ivreg log_exptot (log_payroll = `instrument') _I* cons, noconstant robust
do gls_h "exptot"
est store gls_`panelvar'_ar1
restore

**
* state-specific AR(2)
**
preserve
capture drop `panelvar'_raw
rename `panelvar' `panelvar'_raw
egen `panelvar' = group(`panelvar')
summ `panelvar'
local N_s = r(max)
gen n = _n
gen rho_hat = .
gen rho2_hat = .
forvalues s = 1(1)`N_s' {

 di "updating s=`s' ..."

 reg resid resid_prev resid_prev2 if `panelvar' == `s'
 local rho_hat = _b[resid_prev]
 local rho2_hat = _b[resid_prev2]
 if (_b[resid_prev] + _b[resid_prev2] > 0.999) {
  local rho_hat = _b[resid_prev] - (_b[resid_prev] + _b[resid_prev2] - 0.999) / 2
  local rho2_hat = _b[resid_prev2] - (_b[resid_prev] + _b[resid_prev2] - 0.999) / 2
 }
 if (_b[resid_prev] + _b[resid_prev2] < -0.999) {
  local rho_hat = _b[resid_prev] + (_b[resid_prev] + _b[resid_prev2] + 0.999) / 2
  local rho2_hat = _b[resid_prev2] + (_b[resid_prev] + _b[resid_prev2] + 0.999) / 2
 }
 di "rhos: `rho_hat', `rho2_hat' ..."
 assert(`rho_hat' + `rho2_hat' <  0.9999)
 assert(`rho_hat' + `rho2_hat' > -0.9999)



 ** foreach var of varlist log_exptot log_payroll `instrument' _I* cons {
 foreach var of varlist log_exptot log_payroll _I* cons {
  qui {
  replace rho_hat = `rho_hat' if n == `s'
  replace rho2_hat = `rho2_hat' if n == `s'
  capture drop q
  gen q = .
  sort `absorbVariable' year
  replace q = `var' - `rho_hat' * `var'[_n - 1] - `rho2_hat' * `var'[_n - 2] if myn >= 3 & `panelvar' == `s'
  replace q = `var' - (`rho_hat' + `rho2_hat') * `var'[_n - 1]  if myn == 2 & `panelvar' == `s'
  replace q = sqrt(1 - (`rho_hat' + `rho2_hat') * (`rho_hat' + `rho2_hat')) * `var' if myn == 1 & `panelvar' == `s'
  replace `var' = q if `panelvar' == `s'
  }
 }
}
qui summ rho*_hat, det
qui ivreg log_exptot (log_payroll = `instrument') _I* cons, noconstant robust
do gls_h "exptot"
est store gls_`panelvar'_ar2
restore

}


*estout iv_gls_sample gls* lagged_depvar *ab* ///
* using table12C_gls.txt, ///
*    stats(r2 N fstat $fs_stats, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
*    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
*    style(tab) replace notype mlabels(, numbers ) drop(_* *_I* *cons*) title("`title_str'")




exit



