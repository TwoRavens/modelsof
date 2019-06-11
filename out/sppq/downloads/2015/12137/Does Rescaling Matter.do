/*

 This do file generates simulated data to demonstrate the effect
  of rescaling model variables on predictions and uncertainty.
  
 This program is referenced in Arceneaux and Huber.
 
 This program also uses Clarify to estimate confidence intervals for
  point estimates and first differences. See Gking.harvard.edu to download
  and install the software
  
*/

set mem 100m
set obs 200
set seed 1236

*******************************************************************
* Generate Simulated Data                                         *
*  x1 is distributed uniform                                      *
*  x2 is binary 0,1, with prob. = 1 of .5                         *
*  x1x2=x1*x2                                                     *
*  true model is outcome=1*x1 + 0*x2 + -.5*x1*x2                  *
*                                                                 *
*******************************************************************

gen x1=uniform()
gen x2=int(uniform()+.5)
gen x1x2=x1*x2
pwcorr x1 x2 x1x2, sig
summ x1
gen remeanx1=x1-r(mean)
gen remeanx1x2=remeanx1*x2
pwcorr remeanx1 x2 remeanx1x2, sig

summ x1 x2 x1x2
summ remeanx1 x2 remeanx1x2

*gen y = -.5*x1x2 + invnorm(uniform())
gen y = x1 + -.5*x1x2 + invnorm(uniform())


*******************************************************************
* Perform Base Regressions and display correlations (Table 3)     *
*******************************************************************

pwcorr x1 x2 x1x2, sig
pwcorr remeanx1 x2 remeanx1x2, sig

regress y x1 x2 x1x2
regress y remeanx1 x2 remeanx1x2

*******************************************************************
* Use Clarify to estimate quantities of interest and uncertainty  *
*******************************************************************

**********************************************************************
* These variables are point predictions and 95% confidence intervals *
*  for different levels of X1                                        *
**********************************************************************

gen PredX2_0Unscaled=.
gen PredX2_1Unscaled=.
gen PredX2_01Unscaled=.
gen LPredX2_0Unscaled=.
gen UPredX2_0Unscaled=.
gen LPredX2_1Unscaled=.
gen UPredX2_1Unscaled=.
gen LPredX2_01Unscaled=.
gen UPredX2_01Unscaled=.

gen PredX2_0Scaled=.
gen PredX2_1Scaled=.
gen PredX2_01Scaled=.
gen LPredX2_0Scaled=.
gen UPredX2_0Scaled=.
gen LPredX2_1Scaled=.
gen UPredX2_1Scaled=.
gen LPredX2_01Scaled=.
gen UPredX2_01Scaled=.

gen FD_Hold=.
gen UFD_Hold=.
gen LFD_Hold=.
gen FDLabel=.

label def FDLabels 1 "X1 0->1 Given X2=0"
label def FDLabels 2 "Scaled X1 -.5->.5 Given X2=0", add
label def FDLabels 3 "X1 0->1 Given X2=1", add
label def FDLabels 4 "Scaled X1 -.5->.5 Given X2=1", add 
label values FDLabel FDLabels

**********************************************************************
* Create scaled and unscaled measures for subsequent graphing.       *
*  NOTE THAT HERE BOTH ARE INTEGERS GOING FROM 0 TO 10               *
*  BELOW WE DIVIDE BY 10 AND RESCALED SCALEDX1                       *
**********************************************************************

gen unscaledx1=(_n-1) in 1/11
gen scaledx1=(_n-1) in 1/11

*******************************************************************
* Unrescaled Model                                                *
*******************************************************************

estsimp regress y x1 x2 x1x2, sims(5000) 

**********************************************************************
* Loop over values of X1 (and where X2=1, X1X2)                      *
**********************************************************************

setx x1 0 x2 0 x1x2 0
simqi, fd(ev genev(pred)) changex(x1 0 1)
_pctile pred, p(2.5,50,97.5)
replace LFD_Hold=r(r1) in 1
replace FD_Hold=r(r2) in 1
replace UFD_Hold=r(r3) in 1
replace FDLabel=1 in 1
drop pred

setx x1 0 x2 1 x1x2 0
simqi, fd(ev genev(pred)) changex(x1 0 1 x1x2 0 1)
_pctile pred, p(2.5,50,97.5)
replace LFD_Hold=r(r1) in 3
replace FD_Hold=r(r2) in 3
replace UFD_Hold=r(r3) in 3
replace FDLabel=3 in 3

drop pred

local ctr=0

quietly while `ctr'<11 {

setx x1 (`ctr'/10) x2 0 x1x2 0
simqi, ev genev(pred)
_pctile pred, p(2.5,50,97.5)
replace LPredX2_0Unscaled=r(r1) if unscaledx1==`ctr'
replace PredX2_0Unscaled=r(r2) if unscaledx1==`ctr'
replace UPredX2_0Unscaled=r(r3) if unscaledx1==`ctr'
drop pred

setx x1 (`ctr'/10) x2 1 x1x2 (`ctr'/10)
simqi, ev genev(pred)
_pctile pred, p(2.5,50,97.5)
replace LPredX2_1Unscaled=r(r1) if unscaledx1==`ctr'
replace PredX2_1Unscaled=r(r2) if unscaledx1==`ctr'
replace UPredX2_1Unscaled=r(r3) if unscaledx1==`ctr'
drop pred

setx x1 (`ctr'/10) x2 0 x1x2 0
simqi, fd(ev genev(pred)) changex(x2 0 1 x1x2 0 (`ctr'/10))
_pctile pred, p(2.5,50,97.5)
replace LPredX2_01Unscaled=r(r1) if unscaledx1==`ctr'
replace PredX2_01Unscaled=r(r2) if unscaledx1==`ctr'
replace UPredX2_01Unscaled=r(r3) if unscaledx1==`ctr'
drop pred

local ctr = `ctr' + 1
}

drop b*

*******************************************************************
* Rescaled Model                                                  *
*******************************************************************

estsimp regress y remeanx1 x2 remeanx1x2, sims(5000)

**********************************************************************
* Loop over values of rescaledX1 (and where X2=1, rescaledX1X2)      *
**********************************************************************

setx remeanx1 -.5 x2 0 remeanx1x2 0
simqi, fd(ev genev(pred)) changex(remeanx1 -.5 .5)
_pctile pred, p(2.5,50,97.5)
replace LFD_Hold=r(r1) in 2
replace FD_Hold=r(r2) in 2
replace UFD_Hold=r(r3) in 2
replace FDLabel=2 in 2

drop pred

setx remeanx1 -.5 x2 1 remeanx1x2 -.5
simqi, fd(ev genev(pred)) changex(remeanx1 -.5 .5 remeanx1x2 -.5 .5)
_pctile pred, p(2.5,50,97.5)
replace LFD_Hold=r(r1) in 4
replace FD_Hold=r(r2) in 4
replace UFD_Hold=r(r3) in 4
replace FDLabel=4 in 4
drop pred

local ctr=0
quietly while `ctr'<11 {

setx remeanx1 ((`ctr'/10)-.5) x2 0 remeanx1x2 0
simqi, ev genev(pred)
_pctile pred, p(2.5,50,97.5)
replace LPredX2_0Scaled=r(r1) if scaledx1==`ctr'
replace PredX2_0Scaled=r(r2) if scaledx1==`ctr'
replace UPredX2_0Scaled=r(r3) if scaledx1==`ctr'
drop pred

setx remeanx1 ((`ctr'/10)-.5) x2 1 remeanx1x2 ((`ctr'/10)-.5)
simqi, ev genev(pred)
_pctile pred, p(2.5,50,97.5)
replace LPredX2_1Scaled=r(r1) if scaledx1==`ctr'
replace PredX2_1Scaled=r(r2) if scaledx1==`ctr'
replace UPredX2_1Scaled=r(r3) if scaledx1==`ctr'
drop pred

setx remeanx1 ((`ctr'/10)-.5) x2 0 remeanx1x2 0
simqi, fd(ev genev(pred)) changex(x2 0 1 remeanx1x2 0 ((`ctr'/10)-.5))
_pctile pred, p(2.5,50,97.5)
replace LPredX2_01Scaled=r(r1) if scaledx1==`ctr'
replace PredX2_01Scaled=r(r2) if scaledx1==`ctr'
replace UPredX2_01Scaled=r(r3) if scaledx1==`ctr'
drop pred

local ctr = `ctr' + 1
}

drop b*

**********************************************************************
* Divide unscaledx1 and scaledx1 by 10 and recenter scaledx1 for     *
*  subsequent graphing.                                              *
**********************************************************************

replace unscaledx1=unscaledx1/10
replace scaledx1=(scaledx1/10)-.5

**********************************************************************
* Draw graphs
**********************************************************************

line PredX2_01Unscaled unscaledx1, pstyle(p1) || line LPredX2_01Unscaled unscaledx1,pstyle(p7) || line UPredX2_01Unscaled unscaledx1, pstyle(p7) legend(off) yline(0) ytitle("Predicted First Difference and 95% Confidence Intervals") xtitle(X1) xlabel(0(.25)1) ylabel(-1(.5)1.5) name(ShiftX201Unscaled, replace)
line PredX2_01Scaled scaledx1, pstyle(p1) || line LPredX2_01Scaled scaledx1,pstyle(p7) || line UPredX2_01Scaled scaledx1, pstyle(p7) legend(off) yline(0) ytitle("Predicted First Difference and 95% Confidence Intervals") xtitle(Rescaled X1) xlabel(-.5(.25).5) ylabel(-1(.5)1.5) name(ShiftX201Scaled, replace)
graph combine ShiftX201Unscaled ShiftX201Scaled, ycommon cols(2) title("Predicted Effects of First Difference Shift in X2 for Different Levels of X1", size(medium)) name(ShiftX2combined, replace) imargin(small) graphregion(margin(small)) 

twoway rcap UFD_Hold LFD_Hold FDLabel, blcolor(black) || scatter FD_Hold FDLabel,  mcolor(black) title("Predicted Effects of First Difference Shift in X1 for X2=0 or X2=1", size(medium)) xlabel(1 2 3 4, valuelabel labsize(vsmall)) legend(off) ytitle("Predicted First Difference and 95% Confidence Intervals",  size(small)) xtitle("") graphregion(margin(large)) name(FDcombined, replace)

graph combine ShiftX2combined FDcombined, imargin(zero) graphregion(margin(large)) cols(1) ysize(9) xsize(6)

graph set eps fontface "Arial"
graph export "FigureRescaling.eps", as(eps) preview(on) replace


