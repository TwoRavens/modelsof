/* integrating the unobserved V shock conditional on firm getting max subsidy*/
local p = 100 /* # integration rounds */
local k = 20 /* upper limit of integration for eta*/
gen z = `k'/`p' /* z = the step in the integration in the inner loop (eta), `p'*`z' = `k' has to hold */
gen z2 = 1/sig_eta
local t = 0
local m = -1
gen q = s_H - es_uc  /* creation of eta_min = lower limit of integration, es_uc is the estimated Zd+(1-g) without censoring*/
/* inner loop: integrates over eta on [, eps_max] */
while `t' < `p'+1 {
gen func_`t' =0
replace func_`t' = 0.5*z*(q+`t'*z)*(normalden((q+`t'*z-0.5*z),0,sig_eta)+normalden((q+`t'*z+0.5*z),0,sig_eta)) if tukint == s_H
replace func_`t' = cond(`t'>0, func_`m'+func_`t', func_`t') 
if `m'>-1 drop func_`m'
local t = `t' + 1
local m = `m' + 1
}
replace func_`p' = func_`p'/(1-normal(q*z2))
drop z* q
