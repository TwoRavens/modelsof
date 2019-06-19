/* calculates the expected value of -ln(1-s) and s for each different combination of tech_chall and risk evaluations
when s is not restricted by the lower or the upper bound */
gen z = s_H/100
local p = 100
local w = 0
while `w' <5 {
local s = 0
while `s' <5 {
gen q = yhat`w'`s'
local t = 0
local m = -1
while `t' < `p'+1 {
gen lnexpb`t' = -ln(1-`t'*z)*0.5*z*(normalden((-q+`t'*z-0.5*z),0,sig_e)+ normalden((-q+`t'*z+0.5*z),0,sig_e ))
gen lnexpa`t' = .
replace lnexpa`t' = cond(`t'>0,lnexpa`m'+lnexpb`t', lnexpb`t') 
gen expb`t' = (`t'*z)*0.5*z*(normalden((-q+`t'*z-0.5*z),0,sig_e)+ normalden((-q+`t'*z+0.5*z),0,sig_e ))
gen expa`t' = .
replace expa`t' = cond(`t'>0,expa`m'+expb`t', expb`t') 
local t = `t' + 1
local m = `m' + 1
}
gen lnexpe_`w'`s' = lnexpa`p'
gen expe_`w'`s' = expa`p'
drop lnexpa*
drop lnexpb*
drop expa*
drop expb*
drop q
local s = `s'+1
}
local w = `w' +1
}
drop z

