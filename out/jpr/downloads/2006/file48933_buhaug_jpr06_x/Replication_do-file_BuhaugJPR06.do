* REPLICATION DATA 
* Article: 'Relative Capability and Rebel Objective in Civil War'
* Journal: Journal of Peace Research 2006, vol. 43 no. 6, pp. 691-708
* Author: Halvard Buhaug




*** TABLE II

* MODEL 1 Logit model of civil war onset
logit onset05 dem mix gdpenl oil lnlandar ethfrac decay2, nolog robust


* MODEL 2 Multinomial logit of civil war onset
mlogit m_onset05 dem mix gdpenl oil lnlandar ethfrac decay2, nolog robust

* Test difference between territorial and governmental effect
test [1=2]: dem
test [1=2]: mix
test [1=2]: gdpenl
test [1=2]: oil
test [1=2]: lnlandar
test [1=2]: ethfrac




*** TABLE III 

* predicted probabilities
quietly estsimp mlogit m_onset05 dem mix gdpenl oil lnlandar ethfrac decay2, nolog robust

setx median 
simqi, pr
setx dem 1
simqi, pr
setx dem 0 mix 1
simqi, pr

setx median 
setx gdpenl p5
simqi, pr
setx gdpenl p95
simqi, pr

setx median
setx oil p5
simqi, pr
setx oil p95
simqi, pr

setx median 
setx lnlandar p5
simqi, pr
setx lnlandar p95
simqi, pr

setx median
setx ethfrac p5
simqi, pr
setx ethfrac p95
simqi, pr

drop b*





*** FIGURE 2
* predicted probabilities (Model 2)
gen pterr_dem= 1/(1+2.71^(-(-12.483+(0.9*1)+(0.228*0)+(-0.167*gdpenl)+(0.585*0)+(0.494*12.4)+(1.566*0.39)+(3.17*0.011))))
gen pgov_dem= 1/(1+2.71^(-(-4.4+(-0.133*1)+(0.568*0)+(-0.158*gdpenl)+(0.838*0)+(0.035*12.4)+(0.53*0.39)+(0.89*0.011))))

gen pterr_mix= 1/(1+2.71^(-(-12.483+(0.9*0)+(0.228*1)+(-0.167*gdpenl)+(0.585*0)+(0.494*12.4)+(1.566*0.39)+(3.17*0.011))))
gen pgov_mix= 1/(1+2.71^(-(-4.4+(-0.133*0)+(0.568*1)+(-0.158*gdpenl)+(0.838*0)+(0.035*12.4)+(0.53*0.39)+(0.89*0.011))))

gen pterr_aut= 1/(1+2.71^(-(-12.483+(0.9*0)+(0.228*0)+(-0.167*gdpenl)+(0.585*0)+(0.494*12.4)+(1.566*0.39)+(3.17*0.011))))
gen pgov_aut= 1/(1+2.71^(-(-4.4+(-0.133*0)+(0.568*0)+(-0.158*gdpenl)+(0.838*0)+(0.035*12.4)+(0.53*0.39)+(0.89*0.011))))

twoway (mband pterr_dem gdpenl if gdpenl<15, clcolor(gs4) clpat(solid)) (mband pterr_mix gdpenl if gdpenl<15, clcolor(gs4) clpat(longdash)) ///
(mband pterr_aut gdpenl if gdpenl<15, clcolor(gs4) clpat(shortdash)), ytitle(p(territorial conflict), size(large)) ///
xtitle(GDP capita, size(large)) legend(cols(1) order(1 "democracies" 2 "anocracies" 3 "autocracies")) scheme(s1mono)

twoway (mband pgov_dem gdpenl if gdpenl<15, clcolor(gs4) clpat(solid)) (mband pgov_mix gdpenl if gdpenl<15, clcolor(gs4) clpat(longdash)) ///
(mband pgov_aut gdpenl if gdpenl<15, clcolor(gs4) clpat(shortdash)), ytitle(p(governmental conflict), size(large)) ///
xtitle(GDP capita, size(large)) legend(cols(1) order(1 "democracies" 2 "anocracies" 3 "autocracies")) scheme(s1mono)





*** TABLE IV 

* MODEL 3 Regime dummies replaced with linear and quadr. terms
mlogit m_onset05 polity2l polity2sq gdpenl oil lnlandar ethfrac decay2, nolog robust

test [1=2]: polity2l
test [1=2]: polity2sq
test [1=2]: gdpenl
test [1=2]: oil
test [1=2]: lnlandar
test [1=2]: ethfrac

* MODEL 4 Fearon & Laitin civil wars
mlogit m_flonset polity2l polity2sq gdpenl oil lnlandar ethfrac decayfl2, nolog robust

test [1=2]: polity2l
test [1=2]: polity2sq
test [1=2]: gdpenl
test [1=2]: oil
test [1=2]: lnlandar
test [1=2]: ethfrac

