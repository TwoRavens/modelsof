********************************************************************************
*                                                                              * 
* The Impact of Institutional Coup-Proofing on Coup Attempts and Coup Outcomes *
*                                                                              *
* Tobias Boehmelt and Ulrich Pilster                                           *
*                                                                              * 
* This Version: March 13, 2014                                                 *
*                                                                              * 
* Stata 13.1                                                                   *
*                                                                              * 
* Address correspondence to: tbohmelt@essex.ac.uk                              *
*                                                                              * 
********************************************************************************

use "/Users/tobiasbohmelt/Dropbox/Coups Curvilinear/Final Files/Coup Curvilinear Replication.dta", clear

***********
* TABLE 2 *
***********

sum success attempt chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3

***********
* TABLE 3 *
***********

heckprob success chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber EffectiveNumber_sq, sel (attempt = chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3) robust

***********
* TABLE 4 *
***********

logit attempt chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3, robust
logit attempt chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3, robust
logit attempt chgdp lgdppcl instab dem auth milreg EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3, robust
logit attempt EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3, robust

************
* FIGURE 1 *
************

logit attempt chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3, robust
predict lr_index, xb
predict se_index, stdp
generate p_hat = exp(lr_index)/(1+exp(lr_index))
gen lb = lr_index - invnormal(0.95)*se_index
gen ub = lr_index + invnormal(0.95)*se_index
gen plb = exp(lb)/(1+exp(lb))
gen pub = exp(ub)/(1+exp(ub))
twoway (qfit p_hat EffectiveNumber, lcolor(black) lpattern(solid)) (qfit plb EffectiveNumber, lcolor(black) lpattern(dash)) (qfit pub EffectiveNumber, lcolor(black) lpattern(dash)), xlabel(1(0.5)4.5) scheme(lean1) legend(off) name(graph1, replace)
drop lr_index se_index p_hat lb ub plb pub

logit attempt EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3, robust
predict lr_index if e(sample), xb
predict se_index if e(sample), stdp
generate p_hat = exp(lr_index)/(1+exp(lr_index))
gen lb = lr_index - invnormal(0.95)*se_index
gen ub = lr_index + invnormal(0.95)*se_index
gen plb = exp(lb)/(1+exp(lb))
gen pub = exp(ub)/(1+exp(ub))
twoway (qfit p_hat EffectiveNumber, lcolor(black) lpattern(solid)) (qfit plb EffectiveNumber, lcolor(black) lpattern(dash)) (qfit pub EffectiveNumber, lcolor(black) lpattern(dash)), xlabel(1(0.5)4.5) scheme(lean1) legend(off) name(graph2, replace)
drop lr_index se_index p_hat lb ub plb pub

graph combine graph1 graph2, ycommon scheme(lean1)

************
* FIGURE 2 *
************

findit cdfplot

cdfplot EffectiveNumber, scheme(lean1)

************
* FIGURE 3 *
************

logit attempt chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3, robust
adjust chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3, by(EffectiveNumber) ci se level(90) generate(prob standard_error)
generate postgr3_prob = exp(prob)/(1+exp(prob))
generate lb = prob - invnormal(0.95)* standard_error
generate ub = prob + invnormal(0.95)* standard_error
generate postgr3_lb = exp(lb)/(1+exp(lb))
generate postgr3_ub = exp(ub)/(1+exp(ub))
twoway (qfit postgr3_prob EffectiveNumber, sort) (qfit postgr3_lb EffectiveNumber, sort lpattern(dash)) (qfit postgr3_ub EffectiveNumber, sort lpattern(dash)), scheme(lean1) legend(off) name(graph1, replace)
drop prob standard_error postgr3_prob lb ub postgr3_lb postgr3_ub

use "/Users/tobiasbohmelt/Dropbox/Coups Curvilinear/Final Files/Coup Curvilinear Constrained.dta", clear

logit attempt chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3, robust
adjust chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3, by(EffectiveNumber) ci se level(90) generate(prob standard_error)
generate postgr3_prob = exp(prob)/(1+exp(prob))
generate lb = prob - invnormal(0.95)* standard_error
generate ub = prob + invnormal(0.95)* standard_error
generate postgr3_lb = exp(lb)/(1+exp(lb))
generate postgr3_ub = exp(ub)/(1+exp(ub))
twoway (qfit postgr3_prob EffectiveNumber, sort) (qfit postgr3_lb EffectiveNumber, sort lpattern(dash)) (qfit postgr3_ub EffectiveNumber, sort lpattern(dash)), scheme(lean1) legend(off) name(graph2, replace)
drop prob standard_error postgr3_prob lb ub postgr3_lb postgr3_ub

graph combine graph1 graph2, ycommon scheme(lean1)

clear all

************************
* Robustness - TABLE 1 *
************************

use "/Users/tobiasbohmelt/Dropbox/Coups Curvilinear/Final Files/Coup Curvilinear Replication.dta", clear

mkspline effect = EffectiveNumber , cubic nknots(3)

reg3 (attempt= chmilex soquall lmilper instab dem auth milreg effect1 effect2 powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3) (effect1 = attempt)  (effect2 = attempt), exog(chgdp lgdppcl)

************************
* Robustness - TABLE 2 *
************************

generate time=powthy_peace
generate time_sq=time*time
generate time_3=time_sq*time

logit attempt chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber time time_sq time_3 if year>1974, robust
logit attempt chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber EffectiveNumber_sq time time_sq time_3 if year>1974, robust
logit attempt chgdp lgdppcl instab dem auth milreg EffectiveNumber EffectiveNumber_sq time time_sq time_3 if year>1974, robust
logit attempt EffectiveNumber EffectiveNumber_sq time time_sq time_3 if year>1974, robust

************************
* Robustness - TABLE 3 *
************************

xtlogit attempt chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3 if year>1974, fe
xtlogit attempt chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3 if year>1974, fe
xtlogit attempt chgdp lgdppcl instab dem auth milreg EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3 if year>1974, fe
xtlogit attempt EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3 if year>1974, fe

************************
* Robustness - TABLE 4 *
************************

logit attempt duration chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3 if year>1974, robust
logit attempt duration chgdp lgdppcl instab dem auth chmilex soquall lmilper milreg EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3 if year>1974, robust
logit attempt duration chgdp lgdppcl instab dem auth milreg EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3 if year>1974, robust
logit attempt duration EffectiveNumber EffectiveNumber_sq powthy_peace _powthy_spline1 _powthy_spline2 _powthy_spline3 if year>1974, robust

clear all
