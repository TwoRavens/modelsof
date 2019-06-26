version 8.2

capture log close
log using analysis_no_graphs.log, replace
clear
set more off
set mem 96m

***************** the bootstrapping process starts here *****************

capture use btscoef.dta
capture drop _all
capture set obs 1
capture gen double b1=.
capture gen double b2=.
capture gen double b3=.
capture gen double b4=.
capture gen double b5=.
capture gen double b6=.
capture gen double b7=.
capture gen double b8=.
capture gen double b9=.
capture gen double b10=.
capture save btscoef.dta, replace
capture clear

use 2stage.dta

keep calcdur censored mzmid1 ldistance lev4cont minpower powdisparity allies jointdem kdeplo kdephi _spline1 _spline2 _spline3 _spline4 censormid flag1stage dyad

capture drop probMID
capture program drop btscox

program define btscox
preserve
bsample
qui logit mzmid1 ldistance lev4cont powdisparity minpower allies jointdem kdeplo kdephi _spline1 _spline2 _spline3 _spline4 if censormid!=1&flag1stage==., cluster(dyad)
qui predict probMID
qui stcox ldistance lev4cont powdisparity allies jointdem kdeplo probMID, efron nohr tvc(allies jointdem probMID) texp( ln(_t) )
drop _all
matrix b=get(_b)
capture svmat b
capture append using btscoef
save btscoef, replace
restore
end

stset calcdur if calcdur!=., failure(censored==.)

set seed 12425324

local i=0

while `i' < 1000 {
		qui btscox
		qui local i=`i'+1
		display `i'
	}

clear
use 2stage.dta

********************** Table II*********************************

logit mzmid1 ldistance lev4cont powdisparity minpower allies jointdem kdeplo kdephi _spline1 _spline2 _spline3 _spline4 if censormid!=1&flag1stage==., cluster(dyad)

*adding the peace years variable in addition to the peace years splines does
*not seem to make any difference except for the significance of the alliance variable
*although it improves the log-likelihood

logit mzmid1 ldistance lev4cont powdisparity minpower allies jointdem kdeplo kdephi pcyrs _spline1 _spline2 _spline3 _spline4 if censormid!=1&flag1stage==., cluster(dyad)

clear

use btscoef.dta
centile b1 b2 b3 b4 b5 b6 b7 b8 b9 b10, centile(2.5 50 97.5)
****************************************************************
clear

************* the discrete time analysis starts here *****************

set mem 64m
use duration.dta

describe
su

drop if marker==0

keep dyad caseid calcdur censored ldistance lev4cont powdisparity allies jointdem kdeplo

stset calcdur, failure(censored==.)

stsum

stset, clear

expand calcdur
sort caseid
qui by caseid: gen daynum=_n
label var daynum "Successive day of MID"
gen dead=0
by caseid: replace dead=1 if censored==.&_n==_N
label var dead "Observation fails in this DAYNUM"

describe
su

stset daynum, f(dead) id(caseid)
stsum

gen t2=daynum^2
gen t3=daynum^3
btscs _d _t caseid, g(middays) lspline(1,33,176)

gen allieslnt=allies*ln(daynum)
gen jdemlnt=jointdem*ln(daynum)
label var allieslnt "ALLIES x Ln(DAYNUM)"
label var jdemlnt "JOINTDEM x Ln(DAYNUM)"

cloglog dead ldistance lev4cont powdisparity allies jointdem kdeplo allieslnt jdemlnt daynum t2 t3
lrtest, saving(0)
cloglog dead ldistance lev4cont powdisparity allies jointdem kdeplo daynum t2 t3
lrtest, using(0)
drop _est_LRTEST_0

cloglog dead ldistance lev4cont powdisparity allies jointdem kdeplo allieslnt jdemlnt daynum t2 t3, cluster(dyad)
cloglog dead ldistance lev4cont powdisparity allies jointdem kdeplo allieslnt jdemlnt daynum t2 t3, cluster(caseid)
************* Table I.6,7 **********************
pgmhaz8 ldistance lev4cont powdisparity allies jointdem kdeplo allieslnt jdemlnt daynum t2 t3, id(caseid) d(dead) s(daynum)
************************************************

*the results are similar to Model 2 from Table I except for the alliance and jointdemocracy coefficients
*so the cloglog models are also estimated with the splines

cloglog dead ldistance lev4cont powdisparity allies jointdem kdeplo allieslnt jdemlnt middays _spline1 _spline2 _spline3
lrtest, saving(0)
cloglog dead ldistance lev4cont powdisparity allies jointdem kdeplo middays _spline1 _spline2 _spline3
lrtest, using(0)
drop _est_LRTEST_0

cloglog dead ldistance lev4cont powdisparity allies jointdem kdeplo allieslnt jdemlnt middays _spline1 _spline2 _spline3, cluster(dyad)
cloglog dead ldistance lev4cont powdisparity allies jointdem kdeplo allieslnt jdemlnt middays _spline1 _spline2 _spline3, cluster(caseid)

*now the alliance and joint democracy coefficients seem more proximate to those in Model 2

clear

*repeating the analysis with the the square root transformation of the lower trade-to-GDP ratio:

use duration.dta

drop if marker==0

keep dyad caseid calcdur censored ldistance lev4cont powdisparity allies jointdem kdeplo

stset calcdur, failure(censored==.)

stsum

stset, clear

expand calcdur
sort caseid
qui by caseid: gen daynum=_n
label var daynum "Successive day of MID"
gen dead=0
by caseid: replace dead=1 if censored==.&_n==_N
label var dead "Observation fails in this DAYNUM"

describe
su

stset daynum, f(dead) id(caseid)
stsum
stset, clear

gen t2=daynum^2
gen t3=daynum^3

sort caseid daynum
btscs dead daynum caseid, g(middays) nspline(3)

gen allieslnt=allies*ln(daynum)
gen jdemlnt=jointdem*ln(daynum)

label var allieslnt "ALLIES x Ln(DAYNUM)"
label var jdemlnt "JOINTDEM x Ln(DAYNUM)"

gen kdeplosqrt=sqrt(kdeplo)

cloglog dead ldistance lev4cont powdisparity allies jointdem kdeplosqrt allieslnt jdemlnt daynum t2 t3

cloglog dead ldistance lev4cont powdisparity allies jointdem kdeplosqrt allieslnt jdemlnt daynum t2 t3, cluster(dyad)

************* Table I.8 ***********************
pgmhaz8 ldistance lev4cont powdisparity allies jointdem kdeplosqrt allieslnt jdemlnt daynum t2 t3 , id(caseid) d(dead) s(daynum)
***********************************************

clear

************ the continuous time analysis starts here ********************

set mem 16m
use duration.dta

describe
su

*We stset the data for the time-fixed covariate models:

capture stset, clear
stset calcdur if marker==1, failure(censored==.)

*First, we are going to estimate a control model that regresses MID duration only
*on the control variables:

stcox ldistance lev4cont powdisparity allies jointdem, efron nohr
stcox ldistance lev4cont powdisparity allies jointdem, efron nolog

*Next, we add the lower trade-to-GDP ratio in the disputing dyad to model with time-fixed covariates:

************* Table I.1*************************
stcox ldistance lev4cont powdisparity allies jointdem kdeplo, efron nohr
************************************************
stcox ldistance lev4cont powdisparity allies jointdem kdeplo, efron nolog

*Now it is time to test the important proportionality assumption:

stcox ldistance lev4cont powdisparity allies jointdem kdeplo, nolog efron nohr sch(sch*) sca(sca*)

stphtest, detail

stphtest, detail log

drop sch* sca*

*To amend for the disproportionality of the offending variables, we interact them with ln(time):

************* Table I.2*************************
stcox ldistance lev4cont powdisparity allies jointdem kdeplo, tvc(allies jointdem) texp( ln(_t) ) efron nohr
************************************************
lrtest, saving(0)
qui stcox ldistance lev4cont powdisparity allies jointdem kdeplo, efron nohr
lrtest, using(0)

*We apply the same test to the modified model to check if the detected disproportionality has been corrected:

stcox ldistance lev4cont powdisparity allies jointdem kdeplo, tvc(allies jointdem) texp( ln(_t) ) efron nohr sch(sch*) sca(sca*)

stphtest, detail log

drop sch* sca*

*It seems that the main specification has to include the interactions
*of ALLIES and JOINTDEM with the log of time.
*Now, we will check the goodness of the overall fit of the model:

*First:

stcox ldistance lev4cont powdisparity allies jointdem kdeplo, tvc(allies jointdem) texp( ln(_t) ) efron nohr
linktest

*And then:

stcox ldistance lev4cont powdisparity allies jointdem kdeplo, tvc(allies jointdem) texp( ln(_t) ) efron nohr mgale(martingale)

predict CoxSnell, csnell

stset, clear
stset CoxSnell if marker==1&martingale!=., fail(censored==.)

sts generate km=s
gen double H_cs=-log(km)

/*
sort CoxSnell
twoway (connected CoxSnell H_cs, sort ), ytitle(H(t) based on Cox-Snell Residuals) xtitle(Cox-Snell Residuals) title(Assessment of Model Fit)
graph save model_fit, replace
mark passage as comment later */

drop CoxSnell km H_cs

*Next, we are going to test whether the functional form of the covariates
*deviates from the linearity assumption:

stset, clear
stset calcdur if marker==1, failure(censored==.)

/*
lowess martingale ldistance
graph save ldistance_lowess, replace
lowess martingale lev4cont
graph save lev4cont_lowess, replace
lowess martingale powdisparity
graph save powdisparity_lowess, replace
lowess martingale allies
graph save allies_lowess, replace
lowess martingale jointdem
graph save jointdem_lowess, replace
lowess martingale kdeplo
graph save kdeplo_lowess, replace
mark passage as comment later */

capture drop _est_LRTEST_0 martingale

*Since KDEPLO is not too close to linear, we are going to try a sqrt transformation:

gen kdeplosqrt=sqrt(kdeplo)
stcox ldistance lev4cont powdisparity allies jointdem kdeplosqrt, tvc(allies jointdem) texp( ln(_t) ) efron nohr

*Now, we are going to re-run the model once after dropping each successive
*observation to assess the impact of potential influential obseravtions:

capture drop if marker==0

capture matrix drop b

stcox ldistance lev4cont powdisparity allies jointdem kdeplo, efron nohr

matrix b=get(_b)

capture gen obs=_n

capture gen ldistance_i=.
capture gen lev4cont_i=.
capture gen powdisparity_i=.
capture gen allies_i=.
capture gen jointdem_i=.
capture gen kdeplo_i=.

local i=1

while `i' < 1525 {
		qui capture matrix drop c
		qui stcox ldistance lev4cont powdisparity allies jointdem kdeplo if _n!=`i', efron nohr
		qui matrix c=get(_b)
		qui replace ldistance_i=b[1,1]-c[1,1] if _n==`i'
		qui replace lev4cont_i=b[1,2]-c[1,2]  if _n==`i'
		qui replace powdisparity_i=b[1,3]-c[1,3]  if _n==`i'
		qui replace allies_i=b[1,4]-c[1,4]  if _n==`i'
		qui replace jointdem_i=b[1,5]-c[1,5] if _n==`i'
		qui replace kdeplo_i=b[1,6]-c[1,6] if _n==`i'		
		qui local i=`i'+1
	}

/*
twoway (scatter ldistance_i obs, msymbol(triangle) msize(tiny) mcolor(none) mlabel(obs) mlabcolor(black) mlabposition(1)), ytitle(Coef. difference when obs. dropped) yline(0) xtitle(Observation) title(ldistance influence diagnostics) name(ldistance_i, replace)
graph save ldistance_i, replace
twoway (scatter lev4cont_i obs, msymbol(triangle) msize(tiny) mcolor(none) mlabel(obs) mlabcolor(black) mlabposition(1)), ytitle(Coef. difference when obs. dropped) yline(0) xtitle(Observation) title(lev4cont influence diagnostics) name(lev4cont_i, replace)
graph save lev4cont_i, replace
twoway (scatter powdisparity_i obs, msymbol(triangle) msize(tiny) mcolor(none) mlabel(obs) mlabcolor(black) mlabposition(1)), ytitle(Coef. difference when obs. dropped) yline(0) xtitle(Observation) title(powdisparity influence diagnostics) name(powdisparity_i, replace)
graph save powdisparity_i, replace
twoway (scatter allies_i obs, msymbol(triangle) msize(tiny) mcolor(none) mlabel(obs) mlabcolor(black) mlabposition(1)), ytitle(Coef. difference when obs. dropped) yline(0) xtitle(Observation) title(allies influence diagnostics) name(allies_i, replace)
graph save allies_i, replace
twoway (scatter jointdem_i obs, msymbol(triangle) msize(tiny) mcolor(none) mlabel(obs) mlabcolor(black) mlabposition(1)), ytitle(Coef. difference when obs. dropped) yline(0) xtitle(Observation) title(jointdem influence diagnostics) name(jointdem_i, replace)
graph save jointdem_i, replace
twoway (scatter kdeplo_i obs, msymbol(triangle) msize(tiny) mcolor(none) mlabel(obs) mlabcolor(black) mlabposition(1)), ytitle(Coef. difference when obs. dropped) yline(0) xtitle(Observation) title(kdeplo influence diagnostics) name(kdeplo_i, replace)
graph save kdeplo_i, replace
mark passage as comment later */

*Now, we are going to re-run the model once after dropping each successive
*observation to assess the impact of potential influential obseravtions
*but this time with KDEPLOSQRT instead of KDEPLO:

capture gen kdeplosqrt_i=.

capture matrix drop b

stcox ldistance lev4cont powdisparity allies jointdem kdeplosqrt, efron nohr

matrix b=get(_b)

local i=1

while `i' < 1524 {
		qui capture matrix drop c
		qui stcox ldistance lev4cont powdisparity allies jointdem kdeplosqrt if _n!=`i', efron nohr
		qui matrix c=get(_b)
		qui replace kdeplosqrt_i=b[1,6]-c[1,6] if _n==`i'		
		qui local i=`i'+1
	}

/*
twoway (scatter kdeplosqrt_i obs, msymbol(triangle) msize(tiny) mcolor(none) mlabel(obs) mlabcolor(black) mlabposition(1)), ytitle(Coef. difference when obs. dropped) yline(0) xtitle(Observation) title(kdeplo influence diagnostics) name(kdeplosqrt_i, replace)
graph save kdeplosqrt_i, replace
mark passage as comment later */

*Here we might rerun the model after removing individual influential observations:

stcox ldistance lev4cont powdisparity allies jointdem kdeplo if _n!=1359, efron nohr
stcox ldistance lev4cont powdisparity allies jointdem kdeplosqrt if _n!=1359, efron nohr

clear
set mem 16m
use duration.dta
drop if marker==0
keep calcdur censored dyad ldistance lev4cont powdisparity allies jointdem kdeplo
stset calcdur, fail(censored==.)

*Finally, we are going to estimate a frailty model to assess unobserved heterogeneiety:

set matsize 500
****************** Table I.3 ******************
stcox ldistance lev4cont powdisparity allies jointdem kdeplo, tvc(allies jointdem) texp( ln( _t)) efron nohr shared(dyad) effects(frailty)
***********************************************
gen frailty1=frailty[_n+1]
drop if frailty==frailty1
gen obs=_n

/*
twoway (scatter frailty obs, msymbol(triangle) msize(tiny) mcolor(none) mlabel(dyad) mlabcolor(black) mlabposition(1)), ytitle(Observation frailty) yline(0) xtitle(Observation) title(Unobserved heterogeneity diagnostic) name(heterogeneity, replace)
graph save heterogeneity, replace
mark passage as comment later */

clear
use duration.dta
stset calcdur if marker==1, fail(censored==.)

*We estimate the model using Barbieri's (1996) measures of interdependence:

capture drop barbieri_measure

gen barbieri_measure=(sqrt(kdeplo*kdephi))*(1-(kdephi-kdeplo))

stcox ldistance lev4cont powdisparity allies jointdem barbieri_measure if barbieri_measure>=0, tvc(allies jointdem) texp( ln( _t)) efron nohr sch(sch*) sca(sca*)
*First using the trade-to_GDP ratios
*The IF excludes three perverse cases in which BARBIERI_MEASURE is negative

stphtest, detail log

drop sch* sca*

*Second, using the trade-to-total trade ratios

**************** Table I.4 *********************
stcox ldistance lev4cont powdisparity allies jointdem btrade if btrade>=0, tvc(allies jointdem) texp( ln( _t)) efron nohr sch(sch*) sca(sca*)
************************************************
stphtest, detail log

drop sch* sca*


*Controlling for asymmetry using the Russett&Oneal measure:

stcox ldistance lev4cont powdisparity allies jointdem kdeplo kdephi, tvc(allies jointdem) texp( ln( _t)) efron nohr sch(sch*) sca(sca*)

stphtest, detail log

drop sch* sca*

lrtest, saving(0)

stcox ldistance lev4cont powdisparity allies jointdem kdeplo, tvc(allies jointdem) texp( ln( _t)) efron nohr

*We check whether the addition of KDEPHI improves the model:
lrtest, using(0)
* Seems it doesn't
drop _est_LRTEST_0

*Controlling for trade openness

****************** Table I.5 ********************
stcox ldistance lev4cont powdisparity allies jointdem kdeplo kopenlo, tvc(allies jointdem) texp( ln( _t)) efron nohr sch(sch*) sca(sca*)
*************************************************
stphtest, detail log

drop sch* sca*

*Removing 1 day MIDs:

stcox ldistance lev4cont powdisparity allies jointdem kdeplo if calcdur>1, efron nohr sch(sch*) sca(sca*)

stphtest, detail log

drop sch* sca*

*Removing joiner dyads:

stcox ldistance lev4cont powdisparity allies jointdem kdeplo if orgndyad==1, tvc(allies jointdem) texp( ln( _t)) efron nohr sch(sch*) sca(sca*)

stphtest, detail log

drop sch* sca*

*Removing multilateral MIDs:

stcox ldistance lev4cont powdisparity allies jointdem kdeplo if multi==0, tvc(allies jointdem) texp( ln( _t)) efron nohr sch(sch*) sca(sca*)

stphtest, detail log

drop sch* sca*

*Excluding cases with imputed zeroes:

stcox ldistance lev4cont powdisparity allies jointdem kdeplo, tvc(allies jointdem) texp( ln(_t) ) efron nohr sch(sch*) sca(sca*), if impzero==0

stphtest, detail log

drop sch* sca*

*Measuring common interests by UN voting instead of alliance status:
******************* Table I, Endnote 2 **********************
stcox ldistance lev4cont powdisparity sun3cati jointdem kdeplo, tvc(jointdem) texp( ln( _t)) efron nohr sch(sch*) sca(sca*)
*************************************************************
stphtest, detail log

drop sch* sca*

*Now, we are moving to the analysis with time-varying covariates

clear
use duration.dta
stset TVCtime, id(caseid) failure(TVCdead)

stsum

stcox ldistance lev4cont powdisparity allies jointdem kdeplo, efron nohr sch(sch*) sca(sca*) robust cluster(caseid)

stphtest, detail log

drop sch* sca*

stcox ldistance lev4cont powdisparity allies jointdem kdeplo, tvc(lev4cont allies jointdem) texp( ln(_t) ) efron nohr sch(sch*) sca(sca*) robust cluster(caseid)

stphtest, log detail

clear
capture log close
