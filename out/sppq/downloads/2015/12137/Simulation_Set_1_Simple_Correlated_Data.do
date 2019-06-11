/*

 This do file includes a simulator that creates simulated correlated data
 with specified sample size, correlation, and coefficients.

 It then analyzes the data using OLS, both in a full model and after dropping variables.

 Summary results are saved in the specified out file for subsequent analysis

 This program creates Figure 1 and Figure 2 in Arceneaux and Huber.
 Note: Variable A is labeled X1 is the paper, and B is labeled X2 in the paper.

*/

set more off
set memory 256m

*****************************************************************
* Program caascd: Creates And Analyzes Simulated Collinear Data *
*****************************************************************

program define caascd, rclass
 syntax [, obs(integer 1) corr(real 0) coefa(real 0) coefb(real 0) intercept(real 0) saving(string) reps(integer 1)]

**********************************************************
* Create empty simulations results file         *
**********************************************************

quietly {
 clear
 set obs 1
 gen beta_a_full =.
 gen beta_b_full =.
 gen r2_full =.
 gen drop_a_decision_full= .
 gen drop_b_decision_full= .
 gen jtsig_ab_full = .
 gen beta_b_justb =.
 gen drop_b_decision_justb=.
 gen false_b_effect_type1=.
 gen false_b_effect_type2=.
 gen false_b_effect_ptl_type3=.
 gen false_b_effect_type3=.
 gen false_b_effect_ptl_type4=.
 gen false_b_effect_type4=.
 gen obs=.
 gen corr=.
 gen observedcorr=.
 gen coefa=.
 gen coefb=.
 gen intercept=.
 save "`saving'", replace
}

**********************************************************
* Draw Random Number Seed                *
**********************************************************

local seed2 = int(uniform()*1000000)

**********************************************************
* Begin casewise simulation               *
**********************************************************

local i=1

di ("simulator called with randseed=" + string(`seed2') + " obs=" + string(`obs') + " corr=" + string(`corr') + " betaa=" + string(`coefa') + " betab=" + string(`coefb') + " intercept=" + string(`intercept') + ".")
di string(`reps') + " repetitions:" _continue

**********************************************************
* Simulation iteration loop               *
**********************************************************

while `i' <=`reps' {
 
 quietly{

  ****************************************************************
  * This inner loop justs make sure the observed correlation in *
  * the simulated data is within .05 of the desired correlation *
  ****************************************************************

  local tempcorr=.
  while `tempcorr'==. | ((`tempcorr'+.05)< `corr') | ((`tempcorr'-.05)>`corr') {

  drop _all

  ***************************************************************
  * Draws random simulated data with desired correlation and  *
  * calculated observed correlation. Also increments random  *
  * number seed                        *
  ***************************************************************

  drawnorm a b, n(`obs') means(0 0) sds(1 1) corr(1, `corr' \ `corr',1) seed(`seed2')
  correlate a b
  local tempcorr=r(rho)
  local seed2=`seed2'+1
  }

 *************************************************************************
 * Store observed correlation                      *
 *************************************************************************

 gen observedcorr=`tempcorr'

 *************************************************************************
 * Generate outcome as specified function with random noise component  *
 *************************************************************************

 tempvar outcome
 gen outcome = ((a*`coefa') + (b*`coefb') + `intercept' + invnorm(uniform()))

 *************************************************************************
 * Run different regressions and store results              *
 *************************************************************************

 *Correct (full) model*
 regress outcome a b
 gen r2_full = e(r2)
 matrix c=e(b)
 svmat double c, name(_c)
 gen beta_a_full=_c1 in 1  /*save output for a's coefficeint*/
 gen beta_b_full=_c2 in 1 /*save output for b's coefficeint*/
 drop _*

 test a==0
 gen drop_a_decision_full= 1 in 1
 replace drop_a_decision_full= 0 if (r(p)<.05) in 1

 test b==0
 gen drop_b_decision_full= 1 in 1
 replace drop_b_decision_full= 0 if (r(p)<.05) in 1

 test a==b==0
 gen jtsig_ab_full=0 in 1
 replace jtsig_ab_full = 1 if (r(p)<=.05) in 1

 *Just Bmodel*
 regress outcome b
 matrix c=e(b)
 svmat double c, name(_c)
 gen beta_b_justb=_c1 in 1
 drop _*

 test b==0
 gen drop_b_decision_justb=1 in 1
 replace drop_b_decision_justb= 0 if (r(p)<.05) in 1

 *This math assumes that the true value of coefb is 0
 *When can we get an error and wrong attribute something to b?

 *This could happen in 4 ways:

 *1), we find a statistically significant result for a and b in the full model
 gen false_b_effect_type1=0 in 1
 replace false_b_effect_type1=1 if (drop_a_decision_full==0 & drop_b_decision_full==0) in 1

 *2), we find a statistically significant result for b but not a in the full model
 gen false_b_effect_type2=0 in 1
 replace false_b_effect_type2=1 if (drop_a_decision_full==1 & drop_b_decision_full==0) in 1

 *3), a is significant in the original model, b isn't, but we blame a and so we just estimate the effect of b and find it is significant
 gen false_b_effect_ptl_type3=0 in 1
 replace false_b_effect_ptl_type3=1 if drop_a_decision_full==0 & drop_b_decision_full==1 in 1
 gen false_b_effect_type3=0 in 1
 replace false_b_effect_type3=1 if drop_a_decision_full==0 & drop_b_decision_full==1 & drop_b_decision_justb==0 in 1

 *4), we don't find an effect for a or b in the full model, so we just estimate the effect of b and find it significant
 gen false_b_effect_ptl_type4=0 in 1
 replace false_b_effect_ptl_type4=1 if drop_a_decision_full==1 & drop_b_decision_full==1 in 1
 gen false_b_effect_type4=0 in 1
 replace false_b_effect_type4=1 if drop_a_decision_full==1 & drop_b_decision_full==1 & drop_b_decision_justb==0 in 1

 *************************************************************************
 * Drop underlying simulated data, saving just results          *
 *************************************************************************

 drop a b outcome
 gen obs=`obs'
 gen corr=`corr'
 gen coefa=`coefa'
 gen coefb=`coefb'
 gen intercept=`intercept'

 *************************************************************************
 * Append results to simulation results file and save updated file    *
 *************************************************************************

 append using "`saving'"
 *This line gets rid of the cases that are just left over from the original simulated data results file*
 drop if beta_a_full==.
 save "`saving'", replace
 }

 *************************************************************************
 * Display progress indicator and increment simulation iteration loop  *
 *************************************************************************
 if (int(10*(`i'/`reps'))~=int(10*((`i'-1)/`reps'))) di ("..." + string(int(10*(`i'/`reps'))*10) + "%") _continue
 local i=`i'+1
}
di "...Done"
end

*****************************************************************
* End Program caascd                      *
*****************************************************************

***************************************************************************
* First call simulation with 50 observations and correlation from 0 to .99 *
***************************************************************************

*50 OBS, coeffa=1, coeefb=0, intercept=0, reps=2500, for correlation between 0 and .99
local corrct=0
while `corrct'<=99 {
drop _all
local localfilename = "individualsimdatasets\simualteddata_n50_c" + string(int(`corrct'+.5)) + ".dta"
local tempcorr=int(`corrct'+.5)/100
caascd, obs(50) corr(`tempcorr=') coefa(1) coefb(0) intercept(0) reps(2500) saving(`localfilename')
*To graph and save the correlation between the estimated B1 and B2, uncomment the following 3 lines. This creates the figure in the appendix.
*label var beta_a_full "Estimated B1"
*label var beta_b_full "Estimated B2"
*scatter beta_b_full beta_a_full  in 1/2500, xlabel(-1(1)3) ylabel(-2(1)2) msize(vsmall) msymbol(o) note(N=50. Correlation between X1 and X2 is .9) yline(0) xline(1)
gen reps=1
_pctile beta_a_full, p(2.5,97.5)
gen p5beta_a_full=r(r1)
gen p95beta_a_full=r(r2)
_pctile beta_b_full, p(2.5,97.5)
gen p5beta_b_full=r(r1)
gen p95beta_b_full=r(r2)
_pctile beta_b_justb, p(2.5,97.5)
gen p5beta_b_justb=r(r1)
gen p95beta_b_justb=r(r2)
sort obs corr coefa coefb intercept
collapse (sum) reps (mean) r2_full observedcorr beta_a_full beta_b_full beta_b_justb drop_a_decision_full drop_b_decision_full jtsig_ab_full drop_b_decision_justb false_b_effect_type1-false_b_effect_type4 p5beta_a_full p5beta_b_full p5beta_b_justb p95beta_a_full p95beta_b_full p95beta_b_justb, by(obs corr coefa coefb intercept)
if `corrct'~=0 append using overall_results.dta
save overall_results.dta, replace
if `corrct'<75 local corrct=`corrct'+4
local corrct=`corrct'+1
}

*****************************************************************************
* Second call simulation with 500 observations and correlation from 0 to .99 *
*****************************************************************************

*500 OBS, coeffa=1, coeefb=0, intercept=0, reps=2500, for correlation between 0 and .99
local corrct=0
while `corrct'<=99 {
drop _all
local localfilename = "individualsimdatasets\simualteddata_n500_c" + string(int(`corrct'+.5)) + ".dta"
local tempcorr=int(`corrct'+.5)/100
caascd, obs(500) corr(`tempcorr=') coefa(1) coefb(0) intercept(0) reps(2500) saving(`localfilename')
gen reps=1
_pctile beta_a_full, p(2.5,97.5)
gen p5beta_a_full=r(r1)
gen p95beta_a_full=r(r2)
_pctile beta_b_full, p(2.5,97.5)
gen p5beta_b_full=r(r1)
gen p95beta_b_full=r(r2)
_pctile beta_b_justb, p(2.5,97.5)
gen p5beta_b_justb=r(r1)
gen p95beta_b_justb=r(r2)
sort obs corr coefa coefb intercept
collapse (sum) reps (mean) r2_full observedcorr beta_a_full beta_b_full beta_b_justb drop_a_decision_full drop_b_decision_full jtsig_ab_full drop_b_decision_justb false_b_effect_type1-false_b_effect_type4 p5beta_a_full p5beta_b_full p5beta_b_justb p95beta_a_full p95beta_b_full p95beta_b_justb, by(obs corr coefa coefb intercept)
append using overall_results.dta
save overall_results.dta, replace
if `corrct'<75 local corrct=`corrct'+4
local corrct=`corrct'+1
}

sort coefa coefb corr obs

l coefa coefb obs observedcorr corr r2_full

graph set eps fontface "Arial"

label var false_b_effect_type1 "Full Model: Both B1 and B2 Significant"
label var false_b_effect_type2 "Full Model: B1 Insignificant, B2 Significant"
label var false_b_effect_type3 "Full Model: B2 Insignificant, B1 Significant. Reduced Model: B2 Significant"
label var false_b_effect_type4 "Full Model: Neither B1 nor B2 Significant. Reduced Model: B2 Significant"
gen false_b_effect_tot=false_b_effect_type1+false_b_effect_type2+false_b_effect_type3+false_b_effect_type4
label var false_b_effect_tot "Total Error Rate"

*******************
* Create Figure 1 *
*******************

line p5beta_a_full beta_a_full p95beta_a_full corr if obs==50, yline(1) title(n=50) ytitle(Observed Coefficient B1) xtitle(Correlation between X1 and X2) xlabel(0(.2)1) sort legend(off) pstyle(p5 p1 p5) || line drop_a_decision_full corr, pstyle(p3) yaxis(2) ytitle("", axis(2)) ylabel(0(.25)1, axis(2)) name(BetaAFull50, replace), if obs==50

line p5beta_a_full beta_a_full p95beta_a_full corr if obs==500, yline(1) title(n=500) ytitle("") xtitle(Correlation between X1 and X2) xlabel(0(.2)1) sort legend(off) pstyle(p5 p1 p5) || line drop_a_decision_full corr, pstyle(p3) yaxis(2) ytitle(Proportion of B1 Coefficients Insignificant, axis(2)) ylabel(0(.25)1, axis(2)) name(BetaAFull500, replace), if obs==500

graph combine BetaAFull50 BetaAFull500, cols(2) ycommon ysize(4) xsize(8.5) altshrink imargin(vsmall) name(BetaAComparison, replace)

line p5beta_b_full beta_b_full p95beta_b_full corr if obs==50, yline(0) title(n=50) ytitle(Observed Coefficient B2) xtitle(Correlation between X1 and X2) xlabel(0(.2)1) sort legend(off) pstyle(p5 p1 p5) || line drop_b_decision_full corr, pstyle(p3) yaxis(2) ytitle("", axis(2)) ylabel(0(.25)1, axis(2)) name(BetaBFull50, replace), if obs==50

line p5beta_b_full beta_b_full p95beta_b_full corr if obs==500, yline(0) title(n=500) ytitle("") xtitle(Correlation between X1 and X2) xlabel(0(.2)1) sort legend(off) pstyle(p5 p1 p5) || line drop_b_decision_full corr, pstyle(p3) yaxis(2) ytitle(Proportion of B2 Coefficients Insignificant, axis(2)) ylabel(0(.25)1, axis(2)) name(BetaBFull500, replace), if obs==500

graph combine BetaBFull50 BetaBFull500, cols(2) ycommon ysize(4) xsize(8.5) altshrink imargin(vsmall) name(BetaBComparison, replace)

line p5beta_b_justb beta_b_justb p95beta_b_justb corr if obs==50, yline(0) title(n=50) ytitle("Observed Coefficient B2, Dropping X1") xtitle(Correlation between X1 and X2) xlabel(0(.2)1) sort legend(off) pstyle(p5 p1 p5) || line drop_b_decision_justb corr, pstyle(p3) yaxis(2) ytitle("", axis(2)) ylabel(0(.25)1, axis(2)) name(BetaBjustb50, replace), if obs==50

line p5beta_b_justb beta_b_justb p95beta_b_justb corr if obs==500, yline(0) title(n=500) ytitle("") xtitle(Correlation between X1 and X2) xlabel(0(.2)1) sort legend(off) pstyle(p5 p1 p5) || line drop_b_decision_justb corr, pstyle(p3) yaxis(2) ytitle(Proportion of B2 Coefficients Insignificant, axis(2)) ylabel(0(.25)1, axis(2)) name(BetaBjustb500, replace), if obs==500

graph combine BetaBjustb50 BetaBjustb500, cols(2) ycommon ysize(4) xsize(8.5) altshrink imargin(vsmall) name(BetaBJustBComparison, replace)

graph combine BetaAComparison BetaBComparison, cols(1) ycommon xcommon ysize(8) xsize(8) altshrink title("")

graph export "Figure1.eps", as(eps) preview(on) replace

label var beta_a_full "Average Estimated Coefficient"
label var p5beta_a_full "95% of Estimated Coefficients"
label var drop_a_decision "Proportion of Coefficients Insignificant"

line beta_a_full p5beta_a_full drop_a_decision corr if obs==50, sort pstyle(p5 p1 p3) legend(cols(3) size(tiny)) name(CorrLegend, replace)

graph export "Figure1Legend.eps", as(eps) preview(on) replace mag(250)

*******************
* Create Figure 2 *
*******************

graph combine BetaBJustBComparison, cols(1) ycommon xcommon ysize(4) xsize(8) altshrink title("")

graph export "Figure2.eps", as(eps) preview(on) replace

*******************
* Create Figure 3 *
*******************

line false_b_effect_type1 false_b_effect_type2 false_b_effect_type3 false_b_effect_type4 false_b_effect_tot corr if obs==50, pstyle(p7 p3 p2 p4 p1) title("n=50") ytitle(Probability of Error) xtitle(Correlation between X1 and X2) xlabel(0(.2)1) sort legend(off) name(Error50, replace)

graph export "Figure3.eps", as(eps) preview(on) replace

line false_b_effect_type1 false_b_effect_type2 false_b_effect_type3 false_b_effect_type4 false_b_effect_tot corr if obs==50, pstyle(p7 p3 p2 p4 p1) title("n=50") ytitle(Probability of Error) xtitle(Correlation between X1 and X2) xlabel(0(.2)1) sort legend(cols(1) size(tiny)  position(6) holes(1 4 7)) name(ErrorLegend, replace)

graph export "Figure3Legend.eps", as(eps) preview(on) replace


