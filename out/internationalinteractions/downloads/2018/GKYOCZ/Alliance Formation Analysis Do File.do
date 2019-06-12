*cd  "BOS_II_Replication" /*Please enter your own directory here*/
do "Prog No Interaction.do" /*Run the Simulation Do File*/
*ssc install estout, replace /*please enable the line if estout is not installed on the device*/
*If not installed, please install "clarify" to simulate the predicted values from regression analyses. Available at https://gking.harvard.edu/files/gking/files/clarify.zip
*If not installed, please install "btscs" to create cubic splines. Available at https://www.prio.org/Global/upload/CSCW/Data/btscs.zip


log using "Alliance Formation Log.log", replace
clear
use "Alliance Formation Data"
*********************************************
******SUMMARY STATISTICS*********************
*********************************************
su  atopally0 W_SystemRELa   W_Regionalb   W_SystemRELaarep_MBallSW       arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using

*********************************************
******TABLE 1********************************
*********************************************

eststo clear
eststo:  probit atopally0              arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID)
eststo:  probit atopally0 W_SystemRELa arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID)
eststo:  probit atopally0 W_Regionalb  arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID)
eststo:  probit atopally0              arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using if polrel==1, cl(dirdyadID)
eststo:  probit atopally0 W_SystemRELa arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using if polrel==1, cl(dirdyadID)


esttab , b(a2) se(2) replace label star(* 0.10 ** 0.05 *** 0.01) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
title(Table 1: Uncertainty and Alliance Formation)       ///
nonumbers   ///
mtitles("Model A1" "Model A2" "Model A3" "Model A4" "Model A5" "Model A6")  ///
order(W_SystemRELa W_Regionalb  arep_MBallSW) ///
nogap


*********************************************
******SIMULATIONS****************************
*********************************************
***********Pr(Alliance Formation|Uncertainty)
set seed 12345
estsimp probit atopally0 W_SystemRELa arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID)
*Average Case Simulations
setx aiis_bl mean S mean I mean sqrtdist mean jointenemy_dum median mpctdum median poldif_using median pol5_using median
clarifyone W_SystemRELa 100
simqi, fd(prval(1)) changex(W_SystemRELa min max)
setx W_SystemRELa min
simqi, prval(1)
setx W_SystemRELa max
simqi, prval(1)

*Most Alliance Prone Simulations
setx arep_MBallSW max aiis_bl max S max I max sqrtdist min jointenemy_dum max mpctdum max poldif_using min pol5_using min
simqi, fd(prval(1)) changex(W_SystemRELa min max)
setx W_SystemRELa min
simqi, prval(1)
setx W_SystemRELa max
simqi, prval(1)





*********************************************
**********TABLE 3****************************
*********************************************
*In-Sample and Out-of-Sample Performance - Alliance Formation

clear
use "Alliance Formation Data"
g perrornull=.
g perrorSys=.
g perrorReg=.
g perrornullPR=.
g perrorSysPR=.

qui{

levelsof ccode1
foreach country in `r(levels)'{
probit  atopally0              arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  if ccode1!=`country', nolog
predict phat
replace perrornull=-(atopally0*log(phat)+(1-atopally0)*log(1-phat)) if ccode1==`country'
drop phat
}
levelsof ccode1
foreach country in `r(levels)'{
probit  atopally0     W_SystemRELa         arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  if ccode1!=`country', nolog
predict phat
replace perrorSys=-(atopally0*log(phat)+(1-atopally0)*log(1-phat)) if ccode1==`country'
drop phat
}
levelsof ccode1
foreach country in `r(levels)'{
probit  atopally0      W_Regionalb        arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  if ccode1!=`country', nolog
predict phat
replace perrorReg=-(atopally0*log(phat)+(1-atopally0)*log(1-phat)) if ccode1==`country'
drop phat
}


levelsof ccode1
foreach country in `r(levels)'{
probit  atopally0     arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  if ccode1!=`country' & polrel==1, nolog
predict phat
replace perrornullPR=-(atopally0*log(phat)+(1-atopally0)*log(1-phat)) if ccode1==`country' & polrel==1
drop phat
}


levelsof ccode1
foreach country in `r(levels)'{
probit  atopally0  W_SystemRELa   arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using  if ccode1!=`country' & polrel==1, nolog
predict phat
replace perrorSysPR=-(atopally0*log(phat)+(1-atopally0)*log(1-phat)) if ccode1==`country' & polrel==1
drop phat
}


}
su perrornull perrorSys perrorReg perrornullPR perrorSysPR

g cvlnull=-(atopally0*log(0.5)+(1-atopally0)*log(1-0.5))
su cvlnull
scalar cvlnulla=r(mean)

foreach v in perrornull perrorSys perrorReg  perrornullPR perrorSysPR {
qui su `v'
qui scalar PRI`v'=(.6931472-r(mean))/.6931472
di  PRI`v'
}



*********************************************
*APPENDIX TABLE 1****************************
*********************************************
*Defense Pacts
eststo clear
eststo:  probit atopally0def arep_MBdefSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID)
eststo:  probit atopally0def W_SystemRELa arep_MBdefSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID)

esttab, b(a2) se(2) replace label star(* 0.10 ** 0.05 *** 0.01) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
title(Uncertainty and Alliance Formation)       ///
nonumbers   ///
mtitles("Model 1" "Model 2")  ///
order(W_SystemRELa   arep_MBdefSW) ///
nogap


*********************************************
*APPENDIX TABLE 2****************************
*********************************************
*Multinomial
g allytype=2 if atopally0def==1
replace allytype=1 if atopally0def==0 & atopally0==1
replace allytype=0  if atopally0==0

/*

   allytype  |      Freq.     Percent        Cum.
-------------+-----------------------------------
    Defense 2|      4,480        0.43        0.43
No Alliance 0|  1,038,553       99.32       99.74
Non-Defense 1|      2,674        0.26      100.00
-------------+-----------------------------------
      Total  |  1,045,707      100.00

*/

eststo clear
eststo: mlogit allytype arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID) base(0)
eststo: mlogit allytype W_SystemRELa arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID) base(0)
eststo: mlogit allytype W_Regionalb  arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID) base(0)

esttab, b(a2) se(2) replace label star(* 0.10 ** 0.05 *** 0.01) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
title(Multinomial Logit Analyses of Alliance Formation)       ///
nonumbers   ///
order(W_SystemRELa W_Regionalb) ///
addnote("") ///
nogap



*********************************************
*APPENDIX TABLE 6****************************
*********************************************
*Kenkel-Carroll Measure
eststo clear
foreach v in SystemE W_SystemE W_System_d1E W_System_d2E W_System_d1cE W_System_d2cE {
eststo:  probit atopally0    `v'          arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using, cl(dirdyadID)
}
esttab , b(a2) se(2) replace  star(* 0.10 ** 0.05 *** 0.01) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
title(Table 1: Uncertainty and Alliance Formation)       ///
nonumbers   ///
mtitles("Model A1" "Model A2" "Model A3" "Model A4" "Model A5" "Model A6")  ///
order(SystemE W_SystemE W_System_d1E W_System_d2E W_System_d1cE W_System_d2cE) ///
nogap


*********************************************
*APPENDIX TABLE 9****************************
*********************************************
*Hierarchical Models
eststo clear
eststo:  xtmelogit atopally0              arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using || year:               , intpoints(10)
eststo:  xtmelogit atopally0 W_SystemRELa arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using || year: 			  , intpoints(10)
eststo:  xtmelogit atopally0 W_SystemRELa arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using || year: W_SystemRELa  , intpoints(10)
eststo:  xtmelogit atopally0 W_Regionalb  arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using || year: 			  , intpoints(10)
eststo:  xtmelogit atopally0 W_Regionalb  arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using || year: W_Regionalb   , intpoints(10)

eststo:  xtmelogit atopally0              arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using || year:              if polrel==1  , intpoints(10)
eststo:  xtmelogit atopally0 W_SystemRELa arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using || year:              if polrel==1  , intpoints(10)
eststo:  xtmelogit atopally0 W_SystemRELa arep_MBallSW aiis_bl S I jointenemy_dum sqrtdist mpctdum poldif_using pol5_using || year: W_SystemRELa if polrel==1  , intpoints(10)

esttab, b(a2) se(2) replace label star(* 0.10 ** 0.05 *** 0.01) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
title(Table 1: Uncertainty and Alliance Formation, Multilevel Model)       ///
nonumbers   ///
mtitles("Model A1" "Model A2" "Model A3" "Model A4" "Model A5" "Model A6" "Model A7" "Model A8")  ///
order(W_SystemRELa W_Regionalb  arep_MBallSW) ///
nogap


*********************************************
*APPENDIX TABLE 3****************************
*********************************************
clear
use "K-adic Sample.dta"

*MODEL 1
qui eststo clear
qui eststo: logit defpact total_cinc total_cinc_square _prefail noallyrs _spline1 _spline2 _spline3
qui eststo: logit defpact W_SystemRELa total_cinc total_cinc_square noallyrs _prefail _spline1 _spline2 _spline3


esttab, b(a2) se(2) replace label star(* 0.10 ** 0.05 *** 0.01) scalars(N chi2  ll ) pr2(4) varwidth(25) modelwidth(9)  ///
nonumbers   ///
order(W_SystemRELa) ///
addnote("") ///
nogap

******Predicted Probabilities from k-adic sample**
capture drop `e(allsims)'
set seed 12345
estsimp logit defpact W_SystemRELa total_cinc total_cinc_square noallyrs _prefail _spline1 _spline2 _spline3
setx total_cinc .0874678 total_cinc_square .00765062 noallyrs min _prefail 0 _spline1 0 _spline2 0 _spline3 0
simqi, fd(prval(1)) changex(W_SystemRELa min max)
setx W_SystemRELa min
simqi, prval(1)
setx W_SystemRELa max
simqi, prval(1)



log close
