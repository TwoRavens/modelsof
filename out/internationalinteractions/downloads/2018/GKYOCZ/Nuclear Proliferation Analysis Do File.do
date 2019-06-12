*cd  "BOS_II_Replication" /*Please enter your own directory here*/
do "Prog No Interaction.do" /*Run the Simulation Do File*/
*ssc install estout, replace /*please enable the line if estout is not installed on the device*/
*If not installed, please install "clarify" to simulate the predicted values from regression analyses. Available at https://gking.harvard.edu/files/gking/files/clarify.zip
*If not installed, please install "btscs" to create cubic splines. Available at https://www.prio.org/Global/upload/CSCW/Data/btscs.zip

log using "Nuclear Proliferation Log.log", replace
clear
use "Nuclear Proliferation Data.dta"
*********************************************
******SUMMARY STATISTICS*********************
*********************************************
su  pursueonly gjprog W_SystemRELa reg5_w persdumjlw_lag  land 



*************************************************************
********************TABLE 2**********************************
*************************************************************
eststo clear 
xtlogit pursueonly persdumjlw_lag  land   timeSW timeSW2 timeSW3, nolog
qui estimate store nullSW
xtlogit pursueonly W_SystemRELa persdumjlw_lag  land   timeSW timeSW2 timeSW3, nolog
qui estimate store W_SystemRELaSW
xtlogit pursueonly reg5_w  persdumjlw_lag  land   timeSW timeSW2 timeSW3, nolog
qui estimate store reg5_wSW
xtlogit gjprog  persdumjlw_lag land timeGJ timeGJ2 timeGJ3, nolog
qui estimate store nullGJ
xtlogit gjprog  W_SystemRELa persdumjlw_lag land timeGJ timeGJ2 timeGJ3, nolog
qui estimate store W_SystemRELaGJ
xtlogit gjprog  reg5_w persdumjlw_lag land timeGJ timeGJ2 timeGJ3, nolog
qui estimate store reg5_wGJ

esttab  nullSW W_SystemRELaSW reg5_wSW nullGJ W_SystemRELaGJ reg5_wGJ  , b(a2) se(2) replace label star(* 0.10 ** 0.05 *** 0.011) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
title(Table 2: Uncertainty and Nuclear Proliferation)       ///
nonumbers   ///
mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6")  ///
order(W_SystemRELa reg5_w persdumjlw_lag land) ///
drop(timeSW timeSW2 timeSW3  timeGJ timeGJ2 timeGJ3 ) ///
nogap

*************************************************************
*Predicted Probabilities from Logit**************************
*************************************************************
set seed 12345
estsimp logit pursueonly W_SystemRELa persdumjlw_lag  land   timeSW timeSW2 timeSW3
setx persdumjlw_lag 0 land 5 timeSW 0 timeSW2 0 timeSW3 0
clarifyone W_SystemRELa 100
simqi, fd(prval(1)) changex(W_SystemRELa min max)
capture drop `e(allsims)'
*********************************************
******SIMULATIONS****************************
*********************************************
***************Pr(Pursuit|System Uncertainty)
xtlogit pursueonly W_SystemRELa persdumjlw_lag  land   timeSW timeSW2 timeSW3, nolog
matrix param=e(b)
matrix P=e(V)
save temp, replace
use temp, clear
drawnorm bW_SystemRELa bpersdumjlw_lag  bland   btimeSW btimeSW2 btimeSW3 bcons blnsig2v, means(param) cov(P) double n(1000) seed(12345)  clear
qui merge using temp
expand 2 in 1


qui replace persdumjlw_lag = 1 in 7515
qui replace land = 10 in 7515
qui replace timeSW = 0 in 7515
qui replace timeSW2 = 0 in 7515
qui replace timeSW3 = 0 in 7515

foreach x in 1 27{
g p_`x'_Uncert=.
forvalues i=1/1000 {
qui replace W_SystemRELa =.188 +(`x'-1)*.002 in 7515
qui generate Pr`x'_`i'=invlogit( bcons[`i']+bW_SystemRELa[`i']*W_SystemRELa[7515]+bpersdumjlw_lag[`i']*persdumjlw_lag[7515]+ bland[`i']*land[7515]+ btimeSW[`i']*timeSW[7515]+ btimeSW2[`i']*timeSW2[7515]+ btimeSW3[`i']*timeSW3[7515])
qui summarize Pr`x'_`i', meanonly
qui replace p_`x'_Uncert = r(mean) in `i'
drop Pr`x'_`i'
}
}
g diff= p_27_Uncert- p_1_Uncert
su  p_1_Uncert p_27_Uncert  diff 
qui _pctile  p_1_Uncert, p(2.5 97.5)
di r(r1) r(r2)
qui _pctile  p_27_Uncert, p(2.5 97.5)
di r(r1) r(r2)
qui _pctile  diff, p(2.5 97.5)
di r(r1) r(r2)

drop _merge p_1_Uncert p_27_Uncert diff  bW_SystemRELa bpersdumjlw_lag bland btimeSW btimeSW2 btimeSW3 bcons blnsig2v


***************Pr(Pursuit|Fixed Region Uncertainty)

xtlogit pursueonly reg5_w persdumjlw_lag  land   timeSW timeSW2 timeSW3, nolog
matrix param=e(b)
matrix P=e(V)
save temp, replace
use temp, clear
drawnorm breg5_w bpersdumjlw_lag  bland   btimeSW btimeSW2 btimeSW3 bcons blnsig2v, means(param) cov(P) double n(1000) seed(12345)  clear
qui merge using temp
expand 2 in 1


qui replace persdumjlw_lag = 1 in 7515
qui replace land = 10 in 7515
qui replace timeSW = 0 in 7515
qui replace timeSW2 = 0 in 7515
qui replace timeSW3 = 0 in 7515

foreach x in 1 18{
g p_`x'_Uncert=.
forvalues i=1/1000 {
qui replace reg5_w =0.280 +(`x'-1)*.02  in 7515
qui generate Pr`x'_`i'=invlogit( bcons[`i']+breg5_w[`i']*reg5_w[7515]+bpersdumjlw_lag[`i']*persdumjlw_lag[7515]+ bland[`i']*land[7515]+ btimeSW[`i']*timeSW[7515]+ btimeSW2[`i']*timeSW2[7515]+ btimeSW3[`i']*timeSW3[7515])
qui summarize Pr`x'_`i', meanonly
qui replace p_`x'_Uncert = r(mean) in `i'
drop Pr`x'_`i'
}
}
g diff= p_18_Uncert- p_1_Uncert
su  p_1_Uncert p_18_Uncert  diff 
qui _pctile  p_1_Uncert, p(2.5 97.5)
di r(r1) r(r2)
qui _pctile  p_18_Uncert, p(2.5 97.5)
di r(r1) r(r2)
qui _pctile  diff, p(2.5 97.5)
di r(r1) r(r2)

drop _merge  p_1_Uncert p_18_Uncert diff  breg5_w bpersdumjlw_lag bland btimeSW btimeSW2 btimeSW3 bcons blnsig2v





*********************************************
**********TABLE 3****************************
*********************************************
*In-Sample and Out-of-Sample Performance - Nuclear Proliferation

g perrornullSW=.
g perrorSysSW=.
g perrorRegSW=.
g perrornullGJ=.
g perrorSysGJ=.
g perrorRegGJ=.
qui{

levelsof ccode
foreach country in `r(levels)'{
xtlogit pursueonly persdumjlw_lag  land   timeSW timeSW2 timeSW3  if ccode!=`country', nolog
predict phat,pu0
replace perrornullSW=-(pursueonly*log(phat)+(1-pursueonly)*log(1-phat)) if ccode==`country'
drop phat
}

levelsof ccode
foreach country in `r(levels)'{
xtlogit pursueonly W_SystemRELa persdumjlw_lag  land   timeSW timeSW2 timeSW3  if ccode!=`country', nolog
predict phat,pu0
replace perrorSysSW=-(pursueonly*log(phat)+(1-pursueonly)*log(1-phat)) if ccode==`country'
drop phat
}

levelsof ccode
foreach country in `r(levels)'{
xtlogit pursueonly reg5_w persdumjlw_lag  land   timeSW timeSW2 timeSW3  if ccode!=`country', nolog
predict phat,pu0
replace perrorRegSW=-(pursueonly*log(phat)+(1-pursueonly)*log(1-phat)) if ccode==`country'
drop phat
}


levelsof ccode
foreach country in `r(levels)'{
xtlogit gjprog  persdumjlw_lag land timeGJ timeGJ2 timeGJ3 if ccode!=`country', nolog
predict phat,pu0
replace perrornullGJ=-(gjprog*log(phat)+(1-gjprog)*log(1-phat)) if ccode==`country'
drop phat
}


levelsof ccode
foreach country in `r(levels)'{
xtlogit gjprog  W_SystemRELa persdumjlw_lag land timeGJ timeGJ2 timeGJ3 if ccode!=`country', nolog
predict phat,pu0
replace perrorSysGJ=-(gjprog*log(phat)+(1-gjprog)*log(1-phat)) if ccode==`country'
drop phat
}


levelsof ccode
foreach country in `r(levels)'{
xtlogit gjprog  reg5_w persdumjlw_lag land timeGJ timeGJ2 timeGJ3 if ccode!=`country', nolog
predict phat,pu0
replace perrorRegGJ=-(gjprog*log(phat)+(1-gjprog)*log(1-phat)) if ccode==`country'
drop phat
}

}

g cvlnullsw=-(pursueonly*log(0.5)+(1-pursueonly)*log(1-0.5))
su cvlnullsw
scalar nullswcvl=r(mean)

g cvlnullgj=-(gjprog*log(0.5)+(1-gjprog)*log(1-0.5))
su cvlnullgj
scalar nullgjcvl=r(mean)


foreach v in perrornullSW perrorSysSW perrorRegSW {
qui su `v'
qui scalar PRI`v'=(.6931472-r(mean))/.6931472
di  PRI`v'
}


foreach v in  perrornullGJ perrorSysGJ perrorRegGJ{
qui su `v'
qui scalar PRI`v'=(.6931472-r(mean))/.6931472
di  PRI`v'
}


*********************************************
*APPENDIX TABLE 4****************************
*********************************************
*Europe and Africa as Reference Category
eststo clear 
xtlogit pursueonly W_SystemRELa persdumjlw_lag  land  Meast Asia Americas   timeSW timeSW2 timeSW3, nolog
qui estimate store W_SystemRELaSW
xtlogit pursueonly reg5_w  persdumjlw_lag  land  Meast Asia Americas   timeSW timeSW2 timeSW3, nolog
qui estimate store reg5_wSW
xtlogit gjprog  W_SystemRELa persdumjlw_lag land  Meast Asia Americas  timeGJ timeGJ2 timeGJ3, nolog
qui estimate store W_SystemRELaGJ
xtlogit gjprog  reg5_w persdumjlw_lag land  Meast Asia Americas  timeGJ timeGJ2 timeGJ3, nolog
qui estimate store reg5_wGJ

esttab  W_SystemRELaSW reg5_wSW W_SystemRELaGJ reg5_wGJ, b(a2) se(2) replace label star(* 0.10 ** 0.05 *** 0.011) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
title(Table A4: Uncertainty and Nuclear Proliferation)       ///
nonumbers   ///
mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6")  ///
order(W_SystemRELa reg5_w persdumjlw_lag land) ///
drop(timeSW timeSW2 timeSW3  timeGJ timeGJ2 timeGJ3 ) ///
nogap



*********************************************
*APPENDIX TABLE 7**************************** 
*********************************************
*Uncertainty and Nuclear Proliferation Singh and Way | DOE Scores

eststo clear
foreach v in SystemE W_SystemE W_System_d1E W_System_d2E W_System_d1cE W_System_d2cE {
xtlogit pursueonly  `v'    persdumjlw_lag  land   timeSW timeSW2 timeSW3, nolog
qui estimate store _est`v'
}

esttab  _estSystemE _estW_SystemE _estW_System_d1E _estW_System_d2E _estW_System_d1cE _estW_System_d2cE, b(a2) se(2) replace star(* 0.10 ** 0.05 *** 0.011) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
title(Table A7: Uncertainty and Nuclear Proliferation)       ///
nonumbers   ///
mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6")  ///
order(SystemE W_SystemE W_System_d1E W_System_d2E W_System_d1cE W_System_d2cE) ///
drop(timeSW timeSW2 timeSW3   ) ///
nogap


drop *est_*
*********************************************
*APPENDIX TABLE 8****************************
*********************************************
*Uncertainty and Nuclear Proliferation Gartzke and Jo | DOE Scores
foreach v in SystemE W_SystemE W_System_d1E W_System_d2E W_System_d1cE W_System_d2cE{
xtlogit gjprog `v'   persdumjlw_lag land timeGJ timeGJ2 timeGJ3, nolog
qui estimate store _est`v'
}


esttab    _estSystemE _estW_SystemE _estW_System_d1E _estW_System_d2E _estW_System_d1cE _estW_System_d2cE, b(a2) se(2) replace star(* 0.10 ** 0.05 *** 0.011) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
title(Table 2: Uncertainty and Nuclear Proliferation)       ///
nonumbers   ///
mtitles("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6")  ///
order(SystemE W_SystemE W_System_d1E W_System_d2E W_System_d1cE W_System_d2cE ) ///
drop(time* ) ///
nogap



*********************************************
******APPENDIX TABLE 10**********************
*********************************************
*Uncertainty and Nuclear Proliferation, Singh and Way | Hierarchical Model
btscs pursueonly  year ccode, g(swt) nspline(3)

set more off
eststo:  xtmelogit pursueonly              persdumjlw_lag  land   swt _spline1 _spline2 _spline3  || year:, intpoints(10)
eststo:  xtmelogit pursueonly W_SystemRELa persdumjlw_lag  land   swt _spline1 _spline2 _spline3  || year:, intpoints(10)
eststo:  xtmelogit pursueonly W_SystemRELa persdumjlw_lag  land   swt _spline1 _spline2 _spline3  || year: W_SystemRELa, intpoints(10)
eststo:  xtmelogit pursueonly reg5_w       persdumjlw_lag  land   swt _spline1 _spline2 _spline3  || EUGENERegions:, intpoints(10)
eststo:  xtmelogit pursueonly reg5_w       persdumjlw_lag  land   swt _spline1 _spline2 _spline3  || EUGENERegions: reg5_w, intpoints(10)

esttab, b(a2) se(2) replace label star(* 0.10 ** 0.05 *** 0.01) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
title(Table 2a: Uncertainty and Nuclear Proliferation, Multilevel Model)       ///
nonumbers   ///
mtitles("Model SW1" "Model SW2" "Model SW3" "Model SW4" "Model SW5")  ///
order(W_SystemRELa reg5_w persdumjlw_lag) ///
drop( _spline1 _spline2 _spline3) ///
nogap

rename _spline1 SW_spline1 
rename _spline2 SW_spline2 
rename _spline3 SW_spline3 


*********************************************
******APPENDIX TABLE 11**********************
*********************************************
*Uncertainty and Nuclear Proliferation, Gartzke and Jo | Hierarchical Model

btscs gjprog  year ccode, g(gjt) nspline(3)
eststo clear
eststo:  xtmelogit gjprog              persdumjlw_lag  land   gjt _spline1 _spline2 _spline3  || year:, intpoints(10)
eststo:  xtmelogit gjprog W_SystemRELa persdumjlw_lag  land   gjt _spline1 _spline2 _spline3  || year:, intpoints(10)
eststo:  xtmelogit gjprog W_SystemRELa persdumjlw_lag  land   gjt _spline1 _spline2 _spline3  || year: W_SystemRELa, intpoints(10)
eststo:  xtmelogit gjprog reg5_w       persdumjlw_lag  land   gjt _spline1 _spline2 _spline3  || EUGENERegions:, intpoints(10)
eststo:  xtmelogit gjprog reg5_w       persdumjlw_lag  land   gjt _spline1 _spline2 _spline3  || EUGENERegions: reg5_w, intpoints(10)
esttab, b(a2) se(2) replace label star(* 0.10 ** 0.05 *** 0.01) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
title(Table 2b: Uncertainty and Nuclear Proliferation, Multilevel Model)       ///
nonumbers   ///
mtitles("Model SW1" "Model SW2" "Model SW3" "Model SW4" "Model SW5")  ///
order(W_SystemRELa reg5_w persdumjlw_lag) ///
drop( _spline1 _spline2 _spline3) ///
nogap
log close
