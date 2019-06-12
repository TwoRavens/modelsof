*****************************************************************************
** A Story of Institutional Misfit: Congress and US Economic Sanctions*******
** Foreign Policy Analysis - Codebook and Dofile*****************************
** Analyses Run in STATA 11 *************************************************
** Sanctions Data Compiled from TIES Dataset ********************************
** For inquiries, please contact Emre Hatipoglu / ehatipoglu@sabanciuniv.edu*
*****************************************************************************

*sanxduration: the duration of a sanction in days
*lawtool: sanctions executed through Congress (dummy)
*execgovttool: sanctions executed through the executive branch (dummy)
*iotool: sanctions executed through an IO (dummy)

*issued: whether the contested issue is security related (dummy)
*lnsrelcap: the relative capability of US vis-a-vis the target (logged)
*lntdeptrade: the target's dependence on bilateral trade with the US (logged)
*allied: whether the target is allied with the US (dummy)
*tdem: whether the target is a democracy (dummy)
*lastyearmid: whether the target had a MID with the US during the previous year (dummy)
*oa3=failure variable when the cases in which target acquiesced are treated as right censored


stset sanxduration, failure(failure)
* Model 1
stcox lawtool execgovttool iotool 
estimates store D1

* Model 2
stcox lawtool execgovttool iotool issued lnsrelcap allied tdem
estimates store D2


estimates table D1 D2, b(%7.2f) t(%7.2f) p(%7.3f) se(%7.2f) stats(N ll) eform



***Figure 1***********************************************************
***after duration model of your choice, add the option  , basehr(surv0)
***Then calculate survival rates by "gen surv1=surv0*(exp(XB))"********

stset sanxduration, failure(failure)
stcox lawtool execgovttool iotool issued lnsrelcap allied tdem, nohr basesurv(surv0)
gen surv1=surv0^exp((-1.12+1.8*0.116+0.639))
gen surv2=surv0^exp((0.024+1.8*0.116+0.639))
twoway (line surv1 _t,s(.) c(J) ylab(0 .1 to 1) xlab(0 730 to 8000) sort) (line surv2 _t, sort lcolor(red)), xtitle("Duration of Imposition") ytitle("p(Sanction episode lasting survives)")

***Formatted Version of Figure 1
#delimit
twoway(line surv1 _t, sort lwidth(medthick) lpattern(solid)) (line surv2 _t, sort lcolor(black) 
lwidth(medthick) lpattern(longdash_dot_dot)), ytitle(p(sanction episode survives)) ytitle(, size(medium) margin(medium)) 
xlab(0 730 to 8000) xtitle(days elapsed) xtitle(, size(medium) margin(medium)) title("The Effect of Institutional Medium on Sanction Duration") 
caption("TIES Dataset, US Sanctions 1971-2000", size(small) 
position(6)) note("Semi-parametric (Cox) time invariant duration model estimates", size(small) position(6)) 
legend(size(small) position(7)) graphregion(fcolor(white) lcolor(black) lwidth(none) lpattern(solid) ifcolor(white) 
ilcolor(none)) ;
#delimit cr;

***********************************************************************************




***************************************************
***APPENDIX MATERIAL*******************************
***************************************************


***OA 1: Two-Step Estimation for U.S. Sanction Duration
dursel sanxduration lawtool execgovttool iotool issued lnsrelcap allied tdem, select(escalate = lnsrelcap lntd issued allied tdem) dist(weibull) rtcensor(rightcensor) 
****************************************************************************************


****OA 2: The Effect of Institutional Origin on U.S. Sanction Duration: Additional Control Variables
***Model A1 in the online appendix
stcox lawtool execgovttool iotool issued lnsrelcap allied tdem lastyearmid  lntdeptrade
****************************************************************************************

***OA 3: Treating the Cases where the Target Acquiesced as Censored
stset sanxduration, failure(oa3)
stcox lawtool execgovttool iotool issued lnsrelcap allied tdem
****************************************************************************************

***OA4: Adding CIs around the legislated sanctions' survival curve (Online Appendix)
gen surv1hi=surv0^exp((-1.887+1.8*0.116+0.639))
gen surv1lo=surv0^exp((-.372+1.8*0.116+0.639))
#delimit

***Comparing these CI's with baseline (executive order) survival curve

#delimit
twoway (line surv1 _t,s(.) c(J) ylab(0 .1 to 1) xlab(0 730 to 8000) sort) (line surv1hi _t, sort lcolor(gs11)) 
(line surv1lo _t, sort lcolor(gs11)) (line surv2 _t, lcolor(red) sort);
#delimit cr

****OA 5: Proportional Hazards Test

stset sanxduration, failure(failure)
stcox lawtool execgovttool iotool issued lnsrelcap allied tdem
stphplot, by(lawtool)

estat phtest // Schoenfeld residual test

****************************************************************************************
****************************************************************************************

