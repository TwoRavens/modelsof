*******************************************************************************************
*                                                                                         * 
* The importance of conflict characteristics for the diffusion of international mediation *
*                                                                                         * 
* Replication Instructions, November 25, 2015                                             *
*                                                                                         * 
* Tobias Böhmelt - University of Essex & ETH Zurich                                       *
*                                                                                         * 
*******************************************************************************************

cd "C:\Users\tbohmelt\Desktop\

set matsize 8000

use "Baseline.dta", clear

*********************************************************************************************
* Data Setup and Appendix Table II - Spatial Lags: Conflict Characteristics in Same Region  *
*********************************************************************************************

spatwmat using "ethnic_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_ethnic_2

spatwmat using "geo_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_geo_2

spatwmat using "protac_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_protrac_2

spatwmat using "viol_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_violence_2

********************************************************************************************************************
* Data Setup and Appendix Table II - Spatial Lags: Conflict Characteristics in Same Region and Effective Mediation *
********************************************************************************************************************

spatwmat using "ethnic_2.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_ethnic_e

spatwmat using "geo_2.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_geo_e

spatwmat using "protac_2.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_protrac_e

spatwmat using "viol_2.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_violence_e

*************************************
* Main Article Table I - Models 1-2 *
*************************************

probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust

***************************************************************************
* Main Article - Figure 1 (First Difference Estimates Saved in "FDS.dta") *
***************************************************************************

estsimp probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
setx median
simqi, fd(prval(1)) changex(wy_ethnic_2 p25 p75) level(95)
simqi, fd(prval(1)) changex(wy_geo_2 p25 p75) level(95)
simqi, fd(prval(1)) changex(wy_protrac_2 p25 p75) level(95)
simqi, fd(prval(1)) changex(wy_violence_2 p25 p75) level(95)
drop b1-b15
drop in 450/1000

estsimp probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
setx median
simqi, fd(prval(1)) changex(wy_ethnic_e p25 p75) level(95)
simqi, fd(prval(1)) changex(wy_geo_e p25 p75) level(95)
simqi, fd(prval(1)) changex(wy_protrac_e p25 p75) level(95)
simqi, fd(prval(1)) changex(wy_violence_e p25 p75) level(95)
drop b1-b15
drop in 450/1000

graph use "Graph.gph" 

****************************************************
* m-STAR Model I (Main Article - Table I, Model 3) *
****************************************************

clear
pr drop _all
set more off
set matsize 8000

* Likelihood Evaluator  

program define splag_ll

args lnf mu rho1 rho2 rho3 rho4 sigma
tempvar A rSL1 rSL2 rSL3 rSL4
gen double `rSL1'=`rho1'*SL1
gen double `rSL2'=`rho2'*SL2
gen double `rSL3'=`rho3'*SL3
gen double `rSL4'=`rho4'*SL4
scalar p1 = `rho1'
scalar p2 = `rho2'
scalar p3 = `rho3'
scalar p4 = `rho4'
matrix p1W1 = p1*W1
matrix p2W2 = p2*W2
matrix p3W3 = p3*W3
matrix p4W4 = p4*W4
matrix IpW = I_n - p1W1 - p2W2- p3W3- p4W4
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`rSL2'-`rSL3'-`rSL4'-`mu', 0, `sigma'))
end

* Open Data For Weights

spatwmat using "ethnic_2.dta", name(W1)standardize

spatwmat using "geo_2.dta", name(W2)standardize

spatwmat using "protac_2.dta", name(W3)standardize

spatwmat using "viol_2.dta", name(W4)standardize

* Open Data for Regression

drop _all
use "Baseline.dta", clear
global nobs = 449
matrix I_n = I($nobs)
global Y mediation_dummy 
global X democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3
global Z mediation_dummy
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)
matrix SL2 = W2*Z
svmat SL2, n(SL2)
matrix SL3 = W3*Z
svmat SL3, n(SL3)
matrix SL4 = W4*Z
svmat SL4, n(SL4)

* Produce Starting Values

regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model

ml model lf splag_ll (mu: $Y=$X) (rho1:) (rho2:) (rho3:) (rho4:) (sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init rho3:_cons=0
ml init rho4:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

*****************************************************
* m-STAR Model II (Main Article - Table I, Model 4) *
*****************************************************

clear
pr drop _all
set more off
set matsize 8000

* Likelihood Evaluator  

program define splag_ll

args lnf mu rho1 rho2 rho3 rho4 sigma
tempvar A rSL1 rSL2 rSL3 rSL4
gen double `rSL1'=`rho1'*SL1
gen double `rSL2'=`rho2'*SL2
gen double `rSL3'=`rho3'*SL3
gen double `rSL4'=`rho4'*SL4
scalar p1 = `rho1'
scalar p2 = `rho2'
scalar p3 = `rho3'
scalar p4 = `rho4'
matrix p1W1 = p1*W1
matrix p2W2 = p2*W2
matrix p3W3 = p3*W3
matrix p4W4 = p4*W4
matrix IpW = I_n - p1W1 - p2W2- p3W3- p4W4
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`rSL2'-`rSL3'-`rSL4'-`mu', 0, `sigma'))
end

* Open Data For Weights

spatwmat using "ethnic_2.dta", name(W1)standardize

spatwmat using "geo_2.dta", name(W2)standardize

spatwmat using "protac_2.dta", name(W3)standardize

spatwmat using "viol_2.dta", name(W4)standardize

* Open Data for Regression

drop _all
use "Baseline.dta", clear
global nobs = 449
matrix I_n = I($nobs)
global Y mediation_dummy 
global X democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3
global Z effectiveness
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)
matrix SL2 = W2*Z
svmat SL2, n(SL2)
matrix SL3 = W3*Z
svmat SL3, n(SL3)
matrix SL4 = W4*Z
svmat SL4, n(SL4)

* Produce Starting Values

regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model

ml model lf splag_ll (mu: $Y=$X) (rho1:) (rho2:) (rho3:) (rho4:) (sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init rho3:_cons=0
ml init rho4:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

********************
* Appendix Table I *
********************

sum mediation_dummy democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 period4
sum wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 
sum wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e

***************************************************************
* Appendix Table III: In-Sample and Out-of-Sample Predictions *
***************************************************************

probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
lroc, nograph
probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
lroc, nograph
probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
lroc, nograph
probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
lroc, nograph
probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
lroc, nograph

probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
lroc, nograph
probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
lroc, nograph
probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
lroc, nograph
probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
lroc, nograph
probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
lroc, nograph

********************************************************************************

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

********************************************************************************

quietly probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

********************************************************************************

quietly probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

********************************************************************************

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

********************************************************************************

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

********************************************************************************

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

********************************************************************************

quietly probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

********************************************************************************

quietly probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

********************************************************************************

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

********************************************************************************

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

quietly probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
predict fitted, pr
roctab mediation_dummy fitted
xtile group=uniform(), nq(4)
gen cv_fitted=.
forvalues i=1/4 {

qui probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3 if group~=`i', robust
qui predict cv_fittedi, pr

qui replace cv_fitted=cv_fittedi if group==`i'
qui drop cv_fittedi
}

roctab mediation_dummy cv_fitted

capture drop fitted group cv_fitted

*************************************************************************************************************************
* Data Setup and Appendix Table IV - Spatial Lags: Conflict Characteristics in Same Region Weighted by Inverse of Time  *
*************************************************************************************************************************

spatwmat using "ethnic_t.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_ethnic_t

spatwmat using "geo_t.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_geo_t

spatwmat using "protac_t.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_protrac_t

spatwmat using "viol_t.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_violence_t

******************************************************************************************************************************************
* Data Setup and Appendix Table IV - Spatial Lags: Conflict Characteristics in Same Region Weighted by Inverse of Time and Effectiveness *
******************************************************************************************************************************************

spatwmat using "ethnic_t.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_ethnic_te

spatwmat using "geo_t.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_geo_te

spatwmat using "protac_t.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_protrac_te

spatwmat using "viol_t.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_violence_te

*********************************
* Appendix Table V - Models 1-2 *
*********************************

probit mediation_dummy wy_ethnic_t wy_geo_t wy_protrac_t wy_violence_t democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
probit mediation_dummy wy_ethnic_te wy_geo_te wy_protrac_te wy_violence_te democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust

*********************************
* Appendix Table V - Models 3-4 *
*********************************

clear
pr drop _all
set more off
set matsize 8000

* Likelihood Evaluator  

program define splag_ll

args lnf mu rho1 rho2 rho3 rho4 sigma
tempvar A rSL1 rSL2 rSL3 rSL4
gen double `rSL1'=`rho1'*SL1
gen double `rSL2'=`rho2'*SL2
gen double `rSL3'=`rho3'*SL3
gen double `rSL4'=`rho4'*SL4
scalar p1 = `rho1'
scalar p2 = `rho2'
scalar p3 = `rho3'
scalar p4 = `rho4'
matrix p1W1 = p1*W1
matrix p2W2 = p2*W2
matrix p3W3 = p3*W3
matrix p4W4 = p4*W4
matrix IpW = I_n - p1W1 - p2W2- p3W3- p4W4
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`rSL2'-`rSL3'-`rSL4'-`mu', 0, `sigma'))
end

* Open Data For Weights

spatwmat using "ethnic_t.dta", name(W1)standardize

spatwmat using "geo_t.dta", name(W2)standardize

spatwmat using "protac_t.dta", name(W3)standardize

spatwmat using "viol_t.dta", name(W4)standardize

* Open Data for Regression

drop _all
use "Baseline.dta", clear
global nobs = 449
matrix I_n = I($nobs)
global Y mediation_dummy 
global X democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3
global Z mediation_dummy
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)
matrix SL2 = W2*Z
svmat SL2, n(SL2)
matrix SL3 = W3*Z
svmat SL3, n(SL3)
matrix SL4 = W4*Z
svmat SL4, n(SL4)

* Produce Starting Values

regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model

ml model lf splag_ll (mu: $Y=$X) (rho1:) (rho2:) (rho3:) (rho4:) (sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init rho3:_cons=0
ml init rho4:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

clear
pr drop _all
set more off
set matsize 8000

* Likelihood Evaluator  

program define splag_ll

args lnf mu rho1 rho2 rho3 rho4 sigma
tempvar A rSL1 rSL2 rSL3 rSL4
gen double `rSL1'=`rho1'*SL1
gen double `rSL2'=`rho2'*SL2
gen double `rSL3'=`rho3'*SL3
gen double `rSL4'=`rho4'*SL4
scalar p1 = `rho1'
scalar p2 = `rho2'
scalar p3 = `rho3'
scalar p4 = `rho4'
matrix p1W1 = p1*W1
matrix p2W2 = p2*W2
matrix p3W3 = p3*W3
matrix p4W4 = p4*W4
matrix IpW = I_n - p1W1 - p2W2- p3W3- p4W4
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`rSL2'-`rSL3'-`rSL4'-`mu', 0, `sigma'))
end

* Open Data For Weights

spatwmat using "ethnic_t.dta", name(W1)standardize

spatwmat using "geo_t.dta", name(W2)standardize

spatwmat using "protac_t.dta", name(W3)standardize

spatwmat using "viol_t.dta", name(W4)standardize

* Open Data for Regression

drop _all
use "Baseline.dta", clear
global nobs = 449
matrix I_n = I($nobs)
global Y mediation_dummy 
global X democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3
global Z effectiveness
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)
matrix SL2 = W2*Z
svmat SL2, n(SL2)
matrix SL3 = W3*Z
svmat SL3, n(SL3)
matrix SL4 = W4*Z
svmat SL4, n(SL4)

* Produce Starting Values

regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model

ml model lf splag_ll (mu: $Y=$X) (rho1:) (rho2:) (rho3:) (rho4:) (sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init rho3:_cons=0
ml init rho4:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

******************************************************************************************************************************************
* Data Setup and Appendix Table VI - Spatial Lags: Conflict Characteristics in Same Region Weighted by Inverse of Time and Effectiveness *
******************************************************************************************************************************************

spatwmat using "joint_region_dummy", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_regio

*******************************
* Appendix Table VI - Model 5 *
*******************************

probit mediation_dummy wy_regio democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust

*******************************
* Appendix Table VI - Model 6 *
*******************************

clear
pr drop _all
set more off
set matsize 8000

program define splag_ll

args lnf mu rho1 sigma
tempvar A rSL1 
gen double `rSL1'=`rho1'*SL1
scalar p1 = `rho1'
matrix p1W1 = p1*W1
matrix IpW = I_n - p1W1
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`mu', 0, `sigma'))
end

spatwmat using "joint_region_dummy.dta", name(W1)standardize

drop _all
use "C:\Users\tbohmelt\Polybox\Mediation Spatial\Data\New Project\Baseline.dta", clear
global nobs = 449
matrix I_n = I($nobs)
global Y mediation_dummy 
global X democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3
global Z effectiveness
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)

* Produce Starting Values

regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model

ml model lf splag_ll (mu: $Y=$X) (rho1:) (sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

********************************************************
* Appendix Table VII - Low and High Levels of Violence *
********************************************************

clear
pr drop _all
set more off
set matsize 8000

use "Baseline.dta", clear

spatwmat using "ethnic_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_ethnic_2

spatwmat using "geo_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_geo_2

spatwmat using "protac_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_protrac_2

spatwmat using "viol_region_low.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_violence_low

spatwmat using "viol_region_high.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_violence_high

probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_low wy_violence_high democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust

clear
pr drop _all
set more off
set matsize 8000

program define splag_ll

args lnf mu rho1 rho2 rho3 rho4 rho5 sigma
tempvar A rSL1 rSL2 rSL3 rSL4 rSL5
gen double `rSL1'=`rho1'*SL1
gen double `rSL2'=`rho2'*SL2
gen double `rSL3'=`rho3'*SL3
gen double `rSL4'=`rho4'*SL4
gen double `rSL5'=`rho5'*SL5
scalar p1 = `rho1'
scalar p2 = `rho2'
scalar p3 = `rho3'
scalar p4 = `rho4'
scalar p5 = `rho5'
matrix p1W1 = p1*W1
matrix p2W2 = p2*W2
matrix p3W3 = p3*W3
matrix p4W4 = p4*W4
matrix p5W5 = p5*W5
matrix IpW = I_n - p1W1 - p2W2- p3W3- p4W4- p5W5
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`rSL2'-`rSL3'-`rSL4'-`rSL5'-`mu', 0, `sigma'))
end

* Open Data For Weights

spatwmat using "ethnic_2.dta", name(W1)standardize

spatwmat using "geo_2.dta", name(W2)standardize

spatwmat using "protac_2.dta", name(W3)standardize

spatwmat using "viol_region_low.dta", name(W4)standardize

spatwmat using "viol_region_high.dta", name(W5)standardize

* Open Data for Regression

drop _all
use "Baseline.dta", clear
global nobs = 449
matrix I_n = I($nobs)
global Y mediation_dummy 
global X democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3
global Z mediation_dummy
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)
matrix SL2 = W2*Z
svmat SL2, n(SL2)
matrix SL3 = W3*Z
svmat SL3, n(SL3)
matrix SL4 = W4*Z
svmat SL4, n(SL4)
matrix SL5 = W5*Z
svmat SL5, n(SL5)

* Produce Starting Values

regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model

ml model lf splag_ll (mu: $Y=$X) (rho1:) (rho2:) (rho3:) (rho4:) (rho5:) (sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init rho3:_cons=0
ml init rho4:_cons=0
ml init rho5:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

****************************************************
* Appendix Table VIII: RE-Logit and Dropping Cases *
****************************************************

set matsize 8000

use "Baseline.dta", clear

spatwmat using "ethnic_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_ethnic_2

spatwmat using "geo_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_geo_2

spatwmat using "protac_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_protrac_2

spatwmat using "viol_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_violence_2

spatwmat using "ethnic_2.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_ethnic_e

spatwmat using "geo_2.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_geo_e

spatwmat using "protac_2.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_protrac_e

spatwmat using "viol_2.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_violence_e

xtset crisno yrtrig

xtlogit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, re
xtlogit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, re

probit mediation_dummy , robust
predict yhat1

probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
preserve
predict yhat2
drop if yhat2<=yhat1
probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
restore

probit mediation_dummy wy_ethnic_e wy_geo_e wy_protrac_e wy_violence_e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
preserve
predict yhat2
drop if yhat2<=yhat1
probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
restore

*******************************************************************************
* Data Setup Appendix Table IX - Spatial Lags: Conflict Characteristics Only  *
*******************************************************************************

set matsize 8000

use "Baseline.dta", clear

spatwmat using "ethnic.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail 
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_ethnic_1

spatwmat using "geo.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_geo_1

spatwmat using "protac.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_protrac_1

spatwmat using "viol.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_violence_1

spatwmat using "ethnic.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_ethnic_1e

spatwmat using "geo.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_geo_1e

spatwmat using "protac.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_protrac_1e

spatwmat using "viol.dta", name(W)standardize
spatgsa effectiveness, w(W) m twotail
splagvar effectiveness, wname(W) wfrom(Stata)
rename wy_effectiveness wy_violence_1e

probit mediation_dummy wy_ethnic_1 wy_geo_1 wy_protrac_1 wy_violence_1 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust
probit mediation_dummy wy_ethnic_1e wy_geo_1e wy_protrac_1e wy_violence_1e democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust

clear
pr drop _all
set more off
set matsize 8000

* Likelihood Evaluator  

program define splag_ll

args lnf mu rho1 rho2 rho3 rho4 sigma
tempvar A rSL1 rSL2 rSL3 rSL4
gen double `rSL1'=`rho1'*SL1
gen double `rSL2'=`rho2'*SL2
gen double `rSL3'=`rho3'*SL3
gen double `rSL4'=`rho4'*SL4
scalar p1 = `rho1'
scalar p2 = `rho2'
scalar p3 = `rho3'
scalar p4 = `rho4'
matrix p1W1 = p1*W1
matrix p2W2 = p2*W2
matrix p3W3 = p3*W3
matrix p4W4 = p4*W4
matrix IpW = I_n - p1W1 - p2W2- p3W3- p4W4
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`rSL2'-`rSL3'-`rSL4'-`mu', 0, `sigma'))
end

* Open Data For Weights

spatwmat using "ethnic.dta", name(W1)standardize

spatwmat using "geo.dta", name(W2)standardize

spatwmat using "protac.dta", name(W3)standardize

spatwmat using "viol.dta", name(W4)standardize

* Open Data for Regression

drop _all
use "Baseline.dta", clear
global nobs = 449
matrix I_n = I($nobs)
global Y mediation_dummy 
global X democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3
global Z mediation_dummy
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)
matrix SL2 = W2*Z
svmat SL2, n(SL2)
matrix SL3 = W3*Z
svmat SL3, n(SL3)
matrix SL4 = W4*Z
svmat SL4, n(SL4)

* Produce Starting Values

regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model

ml model lf splag_ll (mu: $Y=$X) (rho1:) (rho2:) (rho3:) (rho4:) (sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init rho3:_cons=0
ml init rho4:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

clear
pr drop _all
set more off
set matsize 8000

* Likelihood Evaluator  

program define splag_ll

args lnf mu rho1 rho2 rho3 rho4 sigma
tempvar A rSL1 rSL2 rSL3 rSL4
gen double `rSL1'=`rho1'*SL1
gen double `rSL2'=`rho2'*SL2
gen double `rSL3'=`rho3'*SL3
gen double `rSL4'=`rho4'*SL4
scalar p1 = `rho1'
scalar p2 = `rho2'
scalar p3 = `rho3'
scalar p4 = `rho4'
matrix p1W1 = p1*W1
matrix p2W2 = p2*W2
matrix p3W3 = p3*W3
matrix p4W4 = p4*W4
matrix IpW = I_n - p1W1 - p2W2- p3W3- p4W4
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`rSL2'-`rSL3'-`rSL4'-`mu', 0, `sigma'))
end

* Open Data For Weights

spatwmat using "ethnic.dta", name(W1)standardize

spatwmat using "geo.dta", name(W2)standardize

spatwmat using "protac.dta", name(W3)standardize

spatwmat using "viol.dta", name(W4)standardize

* Open Data for Regression

drop _all
use "Baseline.dta", clear
global nobs = 449
matrix I_n = I($nobs)
global Y mediation_dummy 
global X democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3
global Z effectiveness
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)
matrix SL2 = W2*Z
svmat SL2, n(SL2)
matrix SL3 = W3*Z
svmat SL3, n(SL3)
matrix SL4 = W4*Z
svmat SL4, n(SL4)

* Produce Starting Values

regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model

ml model lf splag_ll (mu: $Y=$X) (rho1:) (rho2:) (rho3:) (rho4:) (sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init rho3:_cons=0
ml init rho4:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

********************
* Appendix Table X *
********************

use "ICB 2007.dta" 
recode geog (9 11 12 13 =1 ) (15=2) (20 21 22 23 24=3) (31 32 33 34 35=4) (41 42 43=5)
recode medwho (7 4 =4) (5 6 =5)
tab medwho geog if mediation_dummy ==1, col

****************************************
* Appendix Table XI: Mediator Identity *
****************************************

set matsize 8000

use "Baseline.dta", clear

spatwmat using "ethnic_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_ethnic_2

spatwmat using "geo_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_geo_2

spatwmat using "protac_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_protrac_2

spatwmat using "viol_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_violence_2

spatwmat using "joint_intervener_region.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_joint_intervener_region

probit mediation_dummy wy_joint_intervener_region wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3, robust

clear
pr drop _all
set more off
set matsize 8000
program define splag_ll
args lnf mu rho1 rho2 rho3 rho4 rho5 sigma
tempvar A rSL1 rSL2 rSL3 rSL4 rSL5
gen double `rSL1'=`rho1'*SL1
gen double `rSL2'=`rho2'*SL2
gen double `rSL3'=`rho3'*SL3
gen double `rSL4'=`rho4'*SL4
gen double `rSL5'=`rho5'*SL5
scalar p1 = `rho1'
scalar p2 = `rho2'
scalar p3 = `rho3'
scalar p4 = `rho4'
scalar p5 = `rho5'
matrix p1W1 = p1*W1
matrix p2W2 = p2*W2
matrix p3W3 = p3*W3
matrix p4W4 = p4*W4
matrix p5W5 = p5*W5
matrix IpW = I_n - p1W1 - p2W2- p3W3- p4W4- p5W5
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`rSL2'-`rSL3'-`rSL4'-`rSL5'-`mu', 0, `sigma'))
end

spatwmat using "ethnic_2.dta", name(W1)standardize
spatwmat using "geo_2.dta", name(W2)standardize
spatwmat using "protac_2.dta", name(W3)standardize
spatwmat using "viol_2.dta", name(W4)standardize
spatwmat using "joint_intervener_region.dta", name(W5)standardize

drop _all
use "Baseline.dta", clear
global nobs = 449
matrix I_n = I($nobs)
global Y mediation_dummy 
global X democracy ln_powdissy protrac geostr ethnic ln_duration viol period1 period2 period3
global Z mediation_dummy
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)
matrix SL2 = W2*Z
svmat SL2, n(SL2)
matrix SL3 = W3*Z
svmat SL3, n(SL3)
matrix SL4 = W4*Z
svmat SL4, n(SL4)
matrix SL5 = W5*Z
svmat SL5, n(SL5)

regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

ml model lf splag_ll (mu: $Y=$X) (rho1:) (rho2:) (rho3:) (rho4:) (rho5:) (sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init rho3:_cons=0
ml init rho4:_cons=0
ml init rho5:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

***********************************************
* Appendix Table XII: Dummy Variable Approach *
***********************************************

set matsize 8000

use "Baseline.dta", clear

spatwmat using "ethnic_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_ethnic_2

spatwmat using "geo_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_geo_2

spatwmat using "protac_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_protrac_2

spatwmat using "viol_2.dta", name(W)standardize
spatgsa mediation_dummy, w(W) m twotail
splagvar mediation_dummy, wname(W) wfrom(Stata)
rename wy_mediation_dummy wy_violence_2

sum democracy ln_powdissy protrac geostr ethnic ln_duration viol
xtile quart_pow = ln_powdissy, nq(4)
xtile quart_dur = ln_duration, nq(4)
tab protrac, gen(pro_dum)
tab geostr, gen(geo_dum)
tab viol, gen(viol_dum)
tab quart_pow, gen(pow_dum) 
tab quart_dur, gen (dur_dum)

probit mediation_dummy wy_ethnic_2 wy_geo_2 wy_protrac_2 wy_violence_2 democracy ethnic pro_dum1 pro_dum2 pro_dum3 geo_dum1 geo_dum2 geo_dum3 geo_dum4 geo_dum5 viol_dum1 viol_dum2 viol_dum3 viol_dum4 pow_dum1 pow_dum2 pow_dum3 pow_dum4 dur_dum1 dur_dum2 dur_dum3 period1 period2 period3, robust

clear
pr drop _all
set more off
set matsize 8000

* Likelihood Evaluator  

program define splag_ll

args lnf mu rho1 rho2 rho3 rho4 sigma
tempvar A rSL1 rSL2 rSL3 rSL4
gen double `rSL1'=`rho1'*SL1
gen double `rSL2'=`rho2'*SL2
gen double `rSL3'=`rho3'*SL3
gen double `rSL4'=`rho4'*SL4
scalar p1 = `rho1'
scalar p2 = `rho2'
scalar p3 = `rho3'
scalar p4 = `rho4'
matrix p1W1 = p1*W1
matrix p2W2 = p2*W2
matrix p3W3 = p3*W3
matrix p4W4 = p4*W4
matrix IpW = I_n - p1W1 - p2W2- p3W3- p4W4
qui gen double `A' = ln(det(IpW))/$nobs if _n == 1
scalar A = `A'
qui replace `lnf'= A + ln(normalden($ML_y1-`rSL1'-`rSL2'-`rSL3'-`rSL4'-`mu', 0, `sigma'))
end

* Open Data For Weights

spatwmat using "ethnic_2.dta", name(W1)standardize

spatwmat using "geo_2.dta", name(W2)standardize

spatwmat using "protac_2.dta", name(W3)standardize

spatwmat using "viol_2.dta", name(W4)standardize

* Open Data for Regression

drop _all
use "C:\Users\tbohmelt\Polybox\Mediation Spatial\Data\New Project\Baseline.dta", clear
global nobs = 449
matrix I_n = I($nobs)
global Y mediation_dummy 
sum democracy ln_powdissy protrac geostr ethnic ln_duration viol
xtile quart_pow = ln_powdissy, nq(4)
xtile quart_dur = ln_duration, nq(4)
tab protrac, gen(pro_dum)
tab geostr, gen(geo_dum)
tab viol, gen(viol_dum)
tab quart_pow, gen(pow_dum) 
tab quart_dur, gen (dur_dum)
global X democracy ethnic pro_dum1 pro_dum2 pro_dum3 geo_dum1 geo_dum2 geo_dum3 geo_dum4 geo_dum5 viol_dum1 viol_dum2 viol_dum3 viol_dum4 pow_dum1 pow_dum2 pow_dum3 pow_dum4 dur_dum1 dur_dum2 dur_dum3 period1 period2 period3
global Z mediation_dummy
mkmat $Y, matrix(Y)
mkmat $Z, matrix(Z)
matrix SL1 = W1*Z
svmat SL1, n(SL1)
matrix SL2 = W2*Z
svmat SL2, n(SL2)
matrix SL3 = W3*Z
svmat SL3, n(SL3)
matrix SL4 = W4*Z
svmat SL4, n(SL4)

* Produce Starting Values

regress $Y $X
matrix OLSb=e(b)
local OLSsigma=e(rmse)

* Estimate Spatial Lag Model

ml model lf splag_ll (mu: $Y=$X) (rho1:) (rho2:) (rho3:) (rho4:) (sigma:)
ml init OLSb
ml init rho1:_cons=0
ml init rho2:_cons=0
ml init rho3:_cons=0
ml init rho4:_cons=0
ml init sigma:_cons=`OLSsigma'
ml max

