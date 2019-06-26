***************************************************
*                                                 *
* Grievances, economic wealth, and civil conflict *
*                                                 *
* Vally Koubi & Tobias Boehmelt                   *
*                                                 *
* Replication instructions                        *
*                                                 *
* This version: July 16, 2013                     *
*                                                 *
* Stata 12.1                                      *
*                                                 *
* tobias.boehmelt@ir.gess.ethz.ch                 *
*                                                 *
***************************************************

* use "Data Koubi Boehmelt JPR.dta" *

***********
* Table 1 *
***********

sum onset_new power_parity_pop lag_lGDP_pc power_GDP Oil lag_xpolity xpolity_square lpop ethfrac lmtnest MEA NAF SSA LAM NAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005

***********
* Table 2 *
***********

estsimp probit onset_new lag_lGDP_pc Oil lag_xpolity xpolity_square lpop ethfrac lmtnest peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
setx lag_lGDP_pc median Oil median lag_xpolity median xpolity_square median lpop median ethfrac median lmtnest median peaceyrs median peaceyrs2 median peaceyrs3 median
simqi, fd(prval(1)) changex(lag_lGDP_pc min max) level(90)
simqi, fd(prval(1)) changex(Oil min max) level(90)
simqi, fd(prval(1)) changex(lag_xpolity min max) level(90)
simqi, fd(prval(1)) changex(xpolity_square min max) level(90)
simqi, fd(prval(1)) changex(lpop min max) level(90)
simqi, fd(prval(1)) changex(ethfrac min max) level(90)
simqi, fd(prval(1)) changex(lmtnest min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs2 min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs3 min max) level(90)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11
probit onset_new lag_lGDP_pc Oil lag_xpolity xpolity_square lpop ethfrac lmtnest peaceyrs peaceyrs2 peaceyrs3, cluster (cowcode)
lroc, nograph

estsimp probit onset_new lag_lGDP_pc Oil lag_xpolity xpolity_square lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
setx lag_lGDP_pc median Oil median lag_xpolity median xpolity_square median lpop median ethfrac median lmtnest median MEA median NAF median SSA median LAM median eastasia median westasia median peaceyrs median peaceyrs2 median peaceyrs3 median
simqi, fd(prval(1)) changex(lag_lGDP_pc min max) level(90)
simqi, fd(prval(1)) changex(Oil min max) level(90)
simqi, fd(prval(1)) changex(lag_xpolity min max) level(90)
simqi, fd(prval(1)) changex(xpolity_square min max) level(90)
simqi, fd(prval(1)) changex(lpop min max) level(90)
simqi, fd(prval(1)) changex(ethfrac min max) level(90)
simqi, fd(prval(1)) changex(lmtnest min max) level(90)
simqi, fd(prval(1)) changex(MEA min max) level(90)
simqi, fd(prval(1)) changex(NAF min max) level(90)
simqi, fd(prval(1)) changex(SSA min max) level(90)
simqi, fd(prval(1)) changex(LAM min max) level(90)
simqi, fd(prval(1)) changex(eastasia min max) level(90)
simqi, fd(prval(1)) changex(westasia min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs2 min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs3 min max) level(90)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17
probit onset_new lag_lGDP_pc Oil lag_xpolity xpolity_square lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
lroc, nograph

estsimp probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_square lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
setx power_parity_pop median lag_lGDP_pc median Oil median lag_xpolity median xpolity_square median lpop median ethfrac median lmtnest median MEA median NAF median SSA median LAM median eastasia median westasia median peaceyrs median peaceyrs2 median peaceyrs3 median
simqi, fd(prval(1)) changex(power_parity_pop min max) level(90)
simqi, fd(prval(1)) changex(lag_lGDP_pc min max) level(90)
simqi, fd(prval(1)) changex(Oil min max) level(90)
simqi, fd(prval(1)) changex(lag_xpolity min max) level(90)
simqi, fd(prval(1)) changex(xpolity_square min max) level(90)
simqi, fd(prval(1)) changex(lpop min max) level(90)
simqi, fd(prval(1)) changex(ethfrac min max) level(90)
simqi, fd(prval(1)) changex(lmtnest min max) level(90)
simqi, fd(prval(1)) changex(MEA min max) level(90)
simqi, fd(prval(1)) changex(NAF min max) level(90)
simqi, fd(prval(1)) changex(SSA min max) level(90)
simqi, fd(prval(1)) changex(LAM min max) level(90)
simqi, fd(prval(1)) changex(eastasia min max) level(90)
simqi, fd(prval(1)) changex(westasia min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs2 min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs3 min max) level(90)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18
probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_square lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
lroc, nograph

estsimp probit onset_new power_parity_pop lag_lGDP_pc power_GDP Oil lag_xpolity xpolity_square lpop ethfrac lmtnest peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
setx power_parity_pop median lag_lGDP_pc median power_GDP median Oil median lag_xpolity median xpolity_square median lpop median ethfrac median lmtnest median peaceyrs median peaceyrs2 median peaceyrs3 median
simqi, fd(prval(1)) changex(power_parity_pop min max) level(90)
simqi, fd(prval(1)) changex(lag_lGDP_pc min max) level(90)
simqi, fd(prval(1)) changex(power_GDP min max) level(90)
simqi, fd(prval(1)) changex(Oil min max) level(90)
simqi, fd(prval(1)) changex(lag_xpolity min max) level(90)
simqi, fd(prval(1)) changex(xpolity_square min max) level(90)
simqi, fd(prval(1)) changex(lpop min max) level(90)
simqi, fd(prval(1)) changex(ethfrac min max) level(90)
simqi, fd(prval(1)) changex(lmtnest min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs2 min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs3 min max) level(90)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
probit onset_new power_parity_pop lag_lGDP_pc power_GDP Oil lag_xpolity xpolity_square lpop ethfrac lmtnest peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
lroc, nograph

estsimp probit onset_new power_parity_pop lag_lGDP_pc power_GDP Oil lag_xpolity xpolity_square lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
setx power_parity_pop median lag_lGDP_pc median power_GDP median Oil median lag_xpolity median xpolity_square median lpop median ethfrac median lmtnest median MEA median NAF median SSA median LAM median eastasia median westasia median peaceyrs median peaceyrs2 median peaceyrs3 median
simqi, fd(prval(1)) changex(power_parity_pop min max) level(90)
simqi, fd(prval(1)) changex(lag_lGDP_pc min max) level(90)
simqi, fd(prval(1)) changex(power_GDP min max) level(90)
simqi, fd(prval(1)) changex(Oil min max) level(90)
simqi, fd(prval(1)) changex(lag_xpolity min max) level(90)
simqi, fd(prval(1)) changex(xpolity_sq min max) level(90)
simqi, fd(prval(1)) changex(lpop min max) level(90)
simqi, fd(prval(1)) changex(ethfrac min max) level(90)
simqi, fd(prval(1)) changex(lmtnest min max) level(90)
simqi, fd(prval(1)) changex(MEA min max) level(90)
simqi, fd(prval(1)) changex(NAF min max) level(90)
simqi, fd(prval(1)) changex(SSA min max) level(90)
simqi, fd(prval(1)) changex(LAM min max) level(90)
simqi, fd(prval(1)) changex(eastasia min max) level(90)
simqi, fd(prval(1)) changex(westasia min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs2 min max) level(90)
simqi, fd(prval(1)) changex(peaceyrs3 min max) level(90)
drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19
probit onset_new power_parity_pop lag_lGDP_pc power_GDP Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
lroc, nograph

************
* Figure 1 *
************

probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
sum lag_lGDP_pc if e(sample)
margins, dydx(power_parity_pop) at(lag_lGDP_pc=(5(0.1)12)) vsquish
marginsplot, recast(line) recastci(rline) yline(0) level(90) scheme(lean1) addplot (scatter where lag_lGDP_pc, ms(none) mlabel(pipe) mlabpos(0)) name(graph1, replace) legend(off)

probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
sum lag_lGDP_pc if e(sample)
margins, dydx(power_parity_pop) at(lag_lGDP_pc=(5(0.1)12)) vsquish
marginsplot, recast(line) recastci(rline) yline(0) level(90) scheme(lean1) addplot (scatter where lag_lGDP_pc, ms(none) mlabel(pipe) mlabpos(0)) name(graph2, replace) legend(off)

graph combine graph1 graph2, scheme(lean1) ycommon

************
* Figure 2 *
************

probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict predicted if e(sample)
xtile predicted_new= predicted,  nquantiles(5)
tab predicted_new onset_new
egen count=total (onset_new), by( predicted_new)
replace count=. if predicted_new==.
twoway (bar count predicted_new, sort), scheme(lean1)
drop predicted predicted_new count

************
* Figure 3 *
************

probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
lroc, scheme(lean1)

************
* Figure 4 *
************

quietly probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new c.power_parity_pop##c.lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

quietly probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005, cluster (cowcode)
predict fitted, pr
roctab onset_new fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit onset_new power_parity_pop lag_lGDP_pc Oil lag_xpolity xpolity_sq lpop ethfrac lmtnest MEA NAF SSA LAM eastasia westasia peaceyrs peaceyrs2 peaceyrs3 if year>1949 & year<2005 & group~=`i', cluster(cowcode)
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab onset_new cv_fitted

capture drop fitted group cv_fitted

* use "Out of sample graph Koubi Boehmelt JPR.dta" *

twoway (scatter area run if sample==1), ytitle(Total Area Under Curve) yline(.67668998, lpattern(dash)) ylabel(0.4(0.1)1.0) xtitle(Cycle Run - Full Sample) xlabel(1(1)10) legend(off) scheme(lean1) name(graph1, replace)
twoway (scatter area run if sample==2), ytitle(Total Area Under Curve) yline(.66253, lpattern(dash)) ylabel(0.4(0.1)1.0) xtitle(Cycle Run - Constrained Sample without Interactive Term) xlabel(1(1)10) legend(off) scheme(lean1) name(graph2, replace)
graph combine graph1 graph2, ycommon
