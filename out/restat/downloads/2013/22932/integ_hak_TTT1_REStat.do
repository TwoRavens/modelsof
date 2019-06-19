local p = 100 /* # integration rounds */
local k = 20 /* support for integration */
local r = `k'/2 /* upper limit of integration for epsilon */
gen z = `k'/`p' /* z = the step in the integration, `p'*`z' = `k' has to hold */
gen z2 = 1/csig_e
gen xbs = ess1 /* xb - note that lnhaettu = ln(haet_kust)+ln(1-s_H) */
gen q = xbs-ytheta+lnlnes  /* creation of q used in nu0<=q+crh*e and e>nu-q, note that crh<0*/
gen nu0 = .
capture gen e = .
local i=0
local j=-1
while `i'<`p'+1 {
replace nu0 = -`r'+`i'*z
gen prob_nu0_`i' = . /* prob(nu0=nu0_i) */
replace prob_nu0_`i' = (z/2)*(normalden((nu0-0.5*z),0,csig_nu0)+normalden((nu0+0.5*z),0,csig_nu0)) if hakija ==1
local t=0
local m=-1
while `t'< `p'+1 {
replace e= -`r' + `t'*z
gen phi_e_`t' = cond(e<=-(1/crh)*(q-nu0),(z/2)*(normalden((e-0.5*z),0,csig_e)+normalden((e+0.5*z),0,csig_e)),0)

gen prob_1a_`t'=. /* prof w/o s*prob(e=e_t) */
replace prob_1a_`t'= (xbs+e-1)*exp(xbs+e)*phi_e_`t' if hakija==1
replace prob_1a_`t'= cond(`t'>0, (prob_1a_`t' + prob_1a_`m'), prob_1a_`t')

gen prob_2a_`t'=. /* mprof*prob(e=e_t) */
replace prob_2a_`t'= exp(xbs+e)*phi_e_`t' if hakija==1
replace prob_2a_`t'= cond(`t'>0, (prob_2a_`t' + prob_2a_`m'), prob_2a_`t')

gen prob_3a_`t'=. /* hakukust*prob(e=e_t) */
replace prob_3a_`t' = (exp(ytheta+(1-crh)*e+nu0))*phi_e_`t' if hakija ==1
replace prob_3a_`t' = cond(`t'>0, (prob_3a_`t' + prob_3a_`m'), prob_3a_`t')

gen prob_4a_`t'=. /* net profits with es*prob(e=e_t) */
replace prob_4a_`t' = ((exp(xbs+e))*(lnes)- exp(ytheta+(1-crh)*e+nu0))*phi_e_`t' if hakija ==1
replace prob_4a_`t' = cond(`t'>0, (prob_4a_`t' + prob_4a_`m'), prob_4a_`t')

gen prob_5a_`t'=. /* increase in gross profits due to es */
replace prob_5a_`t' = exp(xbs+e)*lnes *phi_e_`t' if hakija ==1
replace prob_5a_`t' = cond(`t'>0, (prob_5a_`t' + prob_5a_`m'), prob_5a_`t')

gen prob_6a_`t'=. /* increase in net profits due to s */
replace prob_6a_`t' = (-ln(1-tukint)*exp(xbs+e)-exp(ytheta+(1-crh)*e+nu0))*phi_e_`t' if hakija ==1
replace prob_6a_`t' = cond(`t'>0, (prob_6a_`t' + prob_6a_`m'), prob_6a_`t')

gen prob_7a_`t'=. /* increase in gross profit due to s */
replace prob_7a_`t' = phi_e_`t'*exp(xbs+e)*(-ln(1-tukint)) if hakija ==1
replace prob_7a_`t' = cond(`t'>0, (prob_7a_`t' + prob_7a_`m'), prob_7a_`t')

gen prob_8a_`t'=. /* private rate of return w/o s */
replace prob_8a_`t' = (xbs+e-1)*phi_e_`t' if hakija ==1
replace prob_8a_`t' = cond(`t'>0, (prob_8a_`t' + prob_8a_`m'), prob_8a_`t')

gen prob_9a_`t'=. /* private gross rate of return with es */
replace prob_9a_`t' = (1-es_i)*(xbs+e+lnes-1)*phi_e_`t' if hakija ==1
replace prob_9a_`t' = cond(`t'>0, (prob_9a_`t' + prob_9a_`m'), prob_9a_`t')

gen prob_10a_`t'=. /* private gross rate of return with s */
replace prob_10a_`t' = (1-tukint)*(xbs+e-ln(1-tukint)-1)*phi_e_`t' if hakija ==1
replace prob_10a_`t' = cond(`t'>0, (prob_10a_`t' + prob_10a_`m'), prob_10a_`t')

gen prob_11a_`t'=. /* private net rate of return with es */
replace prob_11a_`t' = ((1-es_i)*(xbs+e+lnes-1)-(exp(ytheta+(1-crh)*e+nu0)/exp(xbs+e)))*phi_e_`t' if hakija ==1
replace prob_11a_`t' = cond(`t'>0, (prob_11a_`t' + prob_11a_`m'), prob_11a_`t')

gen prob_12a_`t'=. /* private net rate of return with s */
replace prob_12a_`t' = ((1-tukint)*(xbs+e-ln(1-tukint)-1)-(exp(ytheta+(1-crh)*e+nu0)/exp(xbs+e)))*phi_e_`t' if hakija ==1
replace prob_12a_`t' = cond(`t'>0, (prob_12a_`t' + prob_12a_`m'), prob_12a_`t')

drop phi_e_`t'
if `m'>-1 drop  prob_1a_`m' prob_2a_`m' prob_3a_`m' prob_4a_`m' prob_5a_`m' prob_6a_`m' prob_7a_`m' prob_8a_`m' prob_9a_`m' ///
prob_10a_`m' prob_11a_`m' prob_12a_`m'
local t = `t'+1
local m = `m'+1
}

gen prob_1_`i'=.
replace prob_1_`i' = prob_nu0_`i' *prob_1a_`p' if hakija==1
gen e1func_`i'=.
replace e1func_`i' = prob_1_`i' if hakija==1
replace e1func_`i' = cond(`i'>0,(e1func_`i'+ e1func_`j'),e1func_`i')
gen prob_2_`i'=.
replace prob_2_`i' = prob_nu0_`i' *prob_2a_`p' if hakija==1
gen e2func_`i'=.
replace e2func_`i' = prob_2_`i' if hakija==1
replace e2func_`i' = cond(`i'>0,(e2func_`i'+ e2func_`j'),e2func_`i')
gen prob_3_`i'=.
replace prob_3_`i' = prob_nu0_`i' *prob_3a_`p' if hakija==1
gen e3func_`i'=.
replace e3func_`i' = prob_3_`i' if hakija==1
replace e3func_`i' = cond(`i'>0,(e3func_`i'+ e3func_`j'),e3func_`i')
gen prob_4_`i'=.
replace prob_4_`i' = prob_nu0_`i' *prob_4a_`p' if hakija==1
gen e4func_`i'=.
replace e4func_`i' = prob_4_`i' if hakija==1
replace e4func_`i' = cond(`i'>0,(e4func_`i'+ e4func_`j'),e4func_`i')
gen prob_5_`i'=.
replace prob_5_`i' = prob_nu0_`i' *prob_5a_`p' if hakija==1
gen e5func_`i'=.
replace e5func_`i' = prob_5_`i' if hakija==1
replace e5func_`i' = cond(`i'>0,(e5func_`i'+ e5func_`j'),e5func_`i')
gen prob_6_`i'=.
replace prob_6_`i' = prob_nu0_`i' *prob_6a_`p' if hakija==1
gen e6func_`i'=.
replace e6func_`i' = prob_6_`i' if hakija==1
replace e6func_`i' = cond(`i'>0,(e6func_`i'+ e6func_`j'),e6func_`i')
gen prob_7_`i'=.
replace prob_7_`i' = prob_nu0_`i' *prob_7a_`p' if hakija==1
gen e7func_`i'=.
replace e7func_`i' = prob_7_`i' if hakija==1
replace e7func_`i' = cond(`i'>0,(e7func_`i'+ e7func_`j'),e7func_`i')
gen prob_8_`i'=.
replace prob_8_`i' = prob_nu0_`i' *prob_8a_`p' if hakija==1
gen e8func_`i'=.
replace e8func_`i' = prob_8_`i' if hakija==1
replace e8func_`i' = cond(`i'>0,(e8func_`i'+ e8func_`j'),e8func_`i')
gen prob_9_`i'=.
replace prob_9_`i' = prob_nu0_`i' *prob_9a_`p' if hakija==1
gen e9func_`i'=.
replace e9func_`i' = prob_9_`i' if hakija==1
replace e9func_`i' = cond(`i'>0,(e9func_`i'+ e9func_`j'),e9func_`i')
gen prob_10_`i'=.
replace prob_10_`i' = prob_nu0_`i' *prob_10a_`p' if hakija==1
gen e10func_`i'=.
replace e10func_`i' = prob_10_`i' if hakija==1
replace e10func_`i' = cond(`i'>0,(e10func_`i'+ e10func_`j'),e10func_`i')
gen prob_11_`i'=.
replace prob_11_`i' = prob_nu0_`i' *prob_11a_`p' if hakija==1
gen e11func_`i'=.
replace e11func_`i' = prob_11_`i' if hakija==1
replace e11func_`i' = cond(`i'>0,(e11func_`i'+ e11func_`j'),e11func_`i')
gen prob_12_`i'=.
replace prob_12_`i' = prob_nu0_`i' *prob_12a_`p' if hakija==1
gen e12func_`i'=.
replace e12func_`i' = prob_12_`i' if hakija==1
replace e12func_`i' = cond(`i'>0,(e12func_`i'+ e12func_`j'),e12func_`i')
drop prob_1a_`p' prob_2a_`p' prob_3a_`p' prob_4a_`p' prob_5a_`p' prob_6a_`p' prob_7a_`p' prob_8a_`p' ///
prob_9a_`p' prob_10a_`p' prob_11a_`p' prob_12a_`p' prob_nu0_`i' prob_1_`i' prob_2_`i' prob_3_`i' prob_4_`i' ///
prob_5_`i' prob_6_`i' prob_7_`i' prob_8_`i' prob_9_`i' prob_10_`i' prob_11_`i' prob_12_`i'
if `j'>-1 drop e1func_`j' e2func_`j' e3func_`j' e4func_`j' e5func_`j' e6func_`j' e7func_`j' e8func_`j' ///
e9func_`j' e10func_`j' e11func_`j' e12func_`j'
local i = `i'+1
local j = `j'+1
}
gen prob_hak = normal(q*isignu) if hakija == 1
local p = 100
gen f1unc`p'_hak = e1func_`p'/prob_hak
gen f2unc`p'_hak = e2func_`p'/prob_hak
gen f3unc`p'_hak = e3func_`p'/prob_hak
gen f4unc`p'_hak = e4func_`p'/prob_hak
gen f5unc`p'_hak = e5func_`p'/prob_hak
gen f6unc`p'_hak = e6func_`p'/prob_hak
gen f7unc`p'_hak = e7func_`p'/prob_hak
gen f8unc`p'_hak = e8func_`p'/prob_hak
gen f9unc`p'_hak = e9func_`p'/prob_hak
gen f10unc`p'_hak = e10func_`p'/prob_hak
gen f11unc`p'_hak = e11func_`p'/prob_hak
gen f12unc`p'_hak = e12func_`p'/prob_hak

drop  e1func_`p' e2func_`p' e3func_`p' e4func_`p' e5func_`p' e6func_`p' e7func_`p' e8func_`p' ///
e9func_`p' e10func_`p' e11func_`p' e12func_`p' z* q xbs nu0 e prob_hak

