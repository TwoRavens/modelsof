/*

 This do file includes a simulator that creates simulated correlated data 
 with specified sample size, correlation, and coefficients.
 
 It then analyzes the data using OLS, both in a full model and after dropping variables.
 
 Summary results are saved in the specified out file for subsequent analysis
 
 This program creates Figure 4 and Figure 5 in Arceneaux and Huber.
 Note: Variable A is labeled X1 is the paper, B is labeled X2 in the paper, and AB is labeled X1X2 in the paper. 
  
*/

set more off
set memory 256m

*******************************************************************
* Program caasid: Creates And Analyzes Simulated Interaction Data *
*******************************************************************

program define caasid, rclass
 syntax [, obs(integer 1) thresh(real 0) coefa(real 0) coefb(real 0) coefab(real 0) intercept(real 0) saving(string) reps(integer 1)]

**********************************************************
* Create empty simulations results file                  *
**********************************************************

quietly {
 clear
 set obs 1
 gen beta_a_full =.
 gen stderror_a_full =.
 gen beta_b_full =.
 gen stderror_b_full =.
 gen beta_ab_full =.
 gen stderror_ab_full =.
 gen beta_c_full =.
 gen stderror_c_full =.
 gen fstat_full =.
 gen r2_full =. 
 
 gen beta_b_noa =.
 gen stderror_b_noa =.
 gen beta_ab_noa =.
 gen stderror_ab_noa =.
 gen beta_c_noa =.
 gen stderror_c_noa =.

 gen obs=.
 gen thresh=.
 gen observedcorr_a_b=.
 gen observedcorr_a_ab=.
 gen observedcorr_b_ab=.

 gen coefa=.
 gen coefb=.
 gen coefab=.
 gen intercept=.
 save "`saving'", replace
}

**********************************************************
* Draw Random Number Seed                                *
**********************************************************

local seed2 = int(uniform()*1000000)

**********************************************************
* Begin casewise simulation                              *
**********************************************************

local i=1

di ("simulator called with randseed=" + string(`seed2') + " obs=" + string(`obs') + " thresh=" + string(`thresh') + " betaa=" + string(`coefa') + " betab=" + string(`coefb') + " betaab=" + string(`coefab') + " intercept=" + string(`intercept') + ".")
di string(`reps') + " repetitions:" _continue

**********************************************************
* Simulation iteration loop                              *
**********************************************************

while `i' <=`reps' {

 quietly{

 drop _all

 ***************************************************************
 * Draws random simulated data with desired threshold.         *
 *  Also increments random number seed                         *
 ***************************************************************

 set obs `obs'
 gen a = uniform()
 gen b = int(uniform()+`thresh')
 
 local seed2=`seed2'+1
 
 gen ab= a*b
  
 *************************************************************************
 * Store observed correlations                                           *
 *************************************************************************

 correlate a b
 gen observedcorr_a_b=r(rho)

 correlate a ab
 gen observedcorr_a_ab=r(rho)

 correlate b ab
 gen observedcorr_b_ab=r(rho)
 
 *************************************************************************
 * Generate outcome as specified function with random noise component    *
 *************************************************************************

 tempvar outcome
 gen outcome = ((a*`coefa') + (b*`coefb') + (ab*`coefab') + `intercept' + invnorm(uniform()))

 *************************************************************************
 * Run different regressions and store results                           *
 *************************************************************************
 
 /*Correct/full model*/
 regress outcome a b ab
 gen r2_full = e(r2)
 matrix c=e(b)
 svmat double c, name(_c)
 gen beta_a_full=_c1 in 1                        /*save output for a's coefficeint*/
 gen beta_b_full=_c2 in 1                        /*save output for b's coefficeint*/
 gen beta_ab_full=_c3 in 1                       /*save output for ab's coefficeint*/
 gen beta_c_full=_c4 in 1                        /*save output for ab's coefficeint*/
 drop _*

 /*Dropping A Model*/
 regress outcome b ab
 matrix c=e(b)
 svmat double c, name(_c)
 gen beta_b_noa=_c1 in 1                         /*save output for b's coefficeint*/
 gen beta_ab_noa=_c2 in 1                        /*save output for ab's coefficeint*/
 gen beta_c_noa=_c3 in 1                         /*save output for c's coefficeint*/

 *************************************************************************
 * Drop underlying simulated data, saving just results                   *
 *************************************************************************

 drop a b ab outcome _* 
 gen obs=`obs'
 gen thresh=`thresh'
 gen coefa=`coefa'
 gen coefb=`coefb'
 gen coefab=`coefab'
 gen intercept=`intercept'

 *************************************************************************
 * Append results to simulation results file and save updated file       *
 *************************************************************************

 append using "`saving'"
 *This line gets rid of the cases that are just left over from the original simulated data results file*
 drop if beta_a_full==.
 save "`saving'", replace
 }

 *************************************************************************
 * Display progress indicator and increment simulation iteration loop    *
 *************************************************************************
 
 if (int(10*(`i'/`reps'))~=int(10*((`i'-1)/`reps')))  di ("..." + string(int(10*(`i'/`reps'))*10) + "%") _continue
 local i=`i'+1
}
di "...Done"
end

*****************************************************************
* End Program caasid                                            *
*****************************************************************

***************************************************************************
* Call simulation with 50 observations                                    *
***************************************************************************

!erase overall_results.dta

*50 OBS, coeffa=1, coeffb=0, coeffab=-.5, intercept=0, reps=2500, for thresh between .2 and .8
local corrct=20
while `corrct'<=80 {
drop _all
local localfilename = "individualsimdatasets\simualteddata_n50_t" + string(int(`corrct'+.5)) + ".dta"
local tempthresh=int(`corrct'+.5)/100
caasid, obs(50) thresh(`tempthresh') coefa(1) coefb(0) coefab(-.5) intercept(0) reps(2500) saving(`localfilename')
gen reps=1

_pctile beta_a_full, p(2.5,97.5)
gen p5beta_a_full=r(r1)
gen p95beta_a_full=r(r2)

_pctile beta_b_full, p(2.5,97.5)
gen p5beta_b_full=r(r1)
gen p95beta_b_full=r(r2)

_pctile beta_ab_full, p(2.5,97.5)
gen p5beta_ab_full=r(r1)
gen p95beta_ab_full=r(r2)

_pctile beta_ab_noa, p(2.5,97.5)
gen p5beta_ab_noa=r(r1)
gen p95beta_ab_noa=r(r2)

_pctile beta_b_noa, p(2.5,97.5)
gen p5beta_b_noa=r(r1)
gen p95beta_b_noa=r(r2)

sort obs thresh coefa coefb coefab intercept

collapse (sum) reps (mean) p5beta_a_full p95beta_a_full p5beta_b_full p95beta_b_full p5beta_ab_full p95beta_ab_full p5beta_ab_noa p95beta_ab_noa p5beta_b_noa p95beta_b_noa beta_a_full beta_b_full beta_ab_full beta_ab_noa beta_b_noa r2_full observedcorr*, by(obs thresh coefa coefb coefab intercept) 
if `corrct'~=20 append using overall_results.dta
save overall_results.dta, replace
local corrct=`corrct'+10
}

graph set eps fontface "Arial"

sort coefa coefb coefab obs thresh

l coefa coefb coefab obs thresh observedcorr* r2_full

label var  observedcorr_a_b "Corr. X1 X2"
label var  observedcorr_a_ab "Corr. X1 X1*X2"
label var  observedcorr_b_ab "Corr. X2 X1*X2"

***************************************************************************
* Graph Figure 4, observed correlations                                   *
***************************************************************************

line observedcorr_a_b observedcorr_a_ab observedcorr_b_ab thresh if obs==50, title("Observed Correlations in Interaction Model") ytitle(Average Correlation) xtitle(Probability X2=1) xlabel(.2(.2).8) ylabel(0(.25)1) sort pstyle(p3 p2 p1 p2 p3) legend(cols(3)) name(Correlations, replace)
graph export "Figure4.eps", as(eps) mag(200) preview(on) replace

***************************************************************************
* Graph Figure 5, Estimated Models                                        *
***************************************************************************

*full model
line p5beta_a_full beta_a_full p95beta_a_full thresh if obs==50, yline(1) ytitle(Observed Coefficient B1) xtitle(Probability X2=1) xlabel(.2(.2).8) sort legend(off) pstyle(p5 p1 p5) name(BetaAFull50, replace)
line p5beta_b_full beta_b_full p95beta_b_full thresh if obs==50, yline(0) ytitle(Observed Coefficient B2) xtitle(Probability X2=1) xlabel(.2(.2).8) sort legend(off) pstyle(p5 p1 p5) name(BetaBFull50, replace)
line p5beta_ab_full beta_ab_full p95beta_ab_full thresh if obs==50, yline(-.5) ytitle(Observed Coefficient B3) xtitle(Probability X2=1) xlabel(.2(.2).8) sort legend(off) pstyle(p5 p1 p5) name(BetaABFull50, replace)

*reduced model
twoway (line coefa thresh, clcolor(none)), yscale(off) xscale(off) graphregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) plotregion(fcolor(none) lcolor(none) ifcolor(none) ilcolor(none)) name(empty, replace)
line p5beta_b_noa beta_b_noa p95beta_b_noa thresh if obs==50, yline(0) ytitle(Observed Coefficient B2 Dropping X1) xtitle(Probability X2=1) xlabel(.2(.2).8) sort legend(off) pstyle(p5 p1 p5) name(BetaBNoA50, replace)
line p5beta_ab_noa beta_ab_noa p95beta_ab_noa thresh if obs==50, yline(-.5) ytitle(Observed Coefficient B3 Dropping X1) xtitle(Probability X2=1) xlabel(.2(.2).8) sort legend(off) pstyle(p5 p1 p5) name(BetaABNoA50, replace)

graph combine BetaAFull50 empty, cols(2) ycommon imargin(vsmall) name(Panel1, replace)
graph combine BetaBFull50 BetaBNoA50, cols(2) ycommon imargin(vsmall) name(Panel2, replace)
graph combine BetaABFull50 BetaABNoA50, cols(2) ycommon imargin(vsmall) name(Panel3, replace)

graph combine Panel1 Panel2 Panel3, cols(1) ysize(9) xsize(6.5) imargin(vsmall) name(BetaComparison, replace) title( "Full (Correct) and Reduced (Incorrect) Model Estimated Coefficients",size(small))
graph export "Figure5.eps", as(eps) preview(on) replace

*create legend
label var beta_a_full "Average Estimated Coefficient"
label var p5beta_a_full "95% of Estimated Coefficients"

line  beta_a_full p5beta_a_full thresh if obs==50, sort pstyle(p1 p5) legend(cols(1)) name(Legend, replace)
graph export "Figure5Legend.eps", as(eps) preview(on) mag(200) replace



