/* GENERATE THE PREDICTED VALUE FOR THE SUBSIDY TERM IN THE SELECTION EQUATION */
/* 3.c generate the full expected value of -ln(1-s) and s taking expectations both with respect to eta and 
the screening outcomes */

local w = 0
while `w' <5 {
local s = 0
while `s' <5 {
gen phi_H`w'`s' = normal(s_H/sig_e-yhat`w'`s'/sig_e)
gen lnph_H`w'`s' = (1-phi_H`w'`s')*(-ln(1-s_H))
gen ph_H`w'`s' = (1-phi_H`w'`s')*s_H
gen lnep`w'`s' = lnph_H`w'`s'+lnexpe_`w'`s'
gen ep`w'`s' = ph_H`w'`s'+expe_`w'`s'
drop yhat`w'`s' phi_H`w'`s' lnph_H`w'`s' ph_H`w'`s' lnexpe_`w'`s' expe_`w'`s'
local s = `s'+1
}
local w = `w' +1
}

/* 3.d. generate the actual expected value of -ln(1-s)=lnes*/
gen lne0i = ph0*pr0*lnep00+ph0*pr1*lnep01+ph0*pr2*lnep02+ph0*pr3*lnep03+ph0*pr4*lnep04
gen lne1i = ph1*pr0*lnep10+ph1*pr1*lnep11+ph1*pr2*lnep12+ph1*pr3*lnep13+ph1*pr4*lnep14
gen lne2i = ph2*pr0*lnep20+ph2*pr1*lnep21+ph2*pr2*lnep22+ph2*pr3*lnep23+ph2*pr4*lnep24
gen lne3i = ph3*pr0*lnep30+ph3*pr1*lnep31+ph3*pr2*lnep32+ph3*pr3*lnep33+ph3*pr4*lnep34
gen lne4i = ph4*pr0*lnep40+ph4*pr1*lnep41+ph4*pr2*lnep42+ph4*pr3*lnep43+ph4*pr4*lnep44
gen lnes = lne0i+lne1i+lne2i+lne3i+lne4i
drop lnep* lne0i lne1i lne2i lne3i lne4i

/* 3.e. generate the actual expected value of s=es_i*/
gen e0i = ph0*pr0*ep00+ph0*pr1*ep01+ph0*pr2*ep02+ph0*pr3*ep03+ph0*pr4*ep04
gen e1i = ph1*pr0*ep10+ph1*pr1*ep11+ph1*pr2*ep12+ph1*pr3*ep13+ph1*pr4*ep14
gen e2i = ph2*pr0*ep20+ph2*pr1*ep21+ph2*pr2*ep22+ph2*pr3*ep23+ph2*pr4*ep24
gen e3i = ph3*pr0*ep30+ph3*pr1*ep31+ph3*pr2*ep32+ph3*pr3*ep33+ph3*pr4*ep34
gen e4i = ph4*pr0*ep40+ph4*pr1*ep41+ph4*pr2*ep42+ph4*pr3*ep43+ph4*pr4*ep44
gen es_i = e0i+e1i+e2i+e3i+e4i
drop ep0* ep1* ep2* ep3* ep4* e0i e1i e2i e3i e4i



