*calculating joint effect of severity and distance


**Casualties

*load data anew
use "$data", clear
xtset dyad_u month
foreach var in lbest_est fatal lwma_distance_mean lwma_distance_mean2 /*
*/ cum_ldeaths bilateral_talks1 pko observer_mission  /*
*/ good_office fact_finding lwma_distance_mean_c previous {
gen L3`var'=L3.`var'
}

gen L3lwma_distance_mean_c2=L3.lwma_distance_mean_c2
gen L3cinter=L3.lbest_est*L3.lwma_distance_mean_c
gen L3cinter2=L3.lbest_est*L3.lwma_distance_mean_c2

estsimp logit talks L3lbest_est /*
*/ L3lwma_distance_mean_c L3cinter /*
*/ L3lwma_distance_mean_c2 L3cinter2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office  L3.lwma_distance_mean L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

capture drop p p5 p95
gen p=.
gen p5=.
gen p95=.
forvalues i=1/81 {
capture drop pred0 pred3 pred
local dist=`i'/10
setx mean
setx L3lbest_est 0 L3lwma_distance_mean_c `dist' L3lwma_distance_mean_c2 `dist'^2 /*
      */ L3cinter 0*`dist'  /*
	  */ L3cinter2 0*(`dist'^2)  /*
	  */ (gapt gapt2 gapt3) 0
simqi, genpr(pred0)
replace pred0=1-pred0
setx mean
setx L3lbest_est log(22) L3lwma_distance_mean_c `dist' L3lwma_distance_mean_c2 `dist'^2 /*
      */ L3cinter log(22)*`dist'  /*
	  */ L3cinter2 log(22)*(`dist'^2)  /*
	  */ (gapt gapt2 gapt3) 0
simqi, genpr(pred3)
replace pred3=1-pred3
gen pred=pred3-pred0
quietly sum pred, d
replace p = r(mean) in `i'
replace p5 = r(p5) in `i'
replace p95 = r(p95) in `i'
}

*prepare x-axis
capture drop xaxis
egen xaxis=seq(),f(0) t(81)
replace xaxis=xaxis*.1
replace xaxis=exp(xaxis)

*graph
twoway (line p xaxis, lcolor(black) legend(off))  /*
*/     (line p5 p95 xaxis, lcolor(black black)  /*
*/        lpattern(dash dash)  xlab(5 25 50 100 250 500) xscal(log) /*
*/        xtitle("avg. distance from closest city in km") yline(0, lpattern(dot)) /*
*/        ytitle("predicted change in Pr(mediation)") title("Model 2"))
capture erase cas.gph
graph save cas.gph



**Fatal events
gen L3finter=L3.fatal*L3.lwma_distance_mean_c
gen L3finter2=L3.fatal*L3.lwma_distance_mean_c2

capture drop b1-b21   
estsimp logit talks L3fatal /*
*/ L3lwma_distance_mean_c L3finter /*
*/ L3lwma_distance_mean_c2 L3finter2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission /*
*/ L3.good_office L3.lwma_distance_mean L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)
capture drop p p5 p95
gen p=.
gen p5=.
gen p95=.
forvalues i=1/81 {
capture drop pred0 pred3 pred
local dist=`i'/10
setx mean
setx L3fatal 0 L3lwma_distance_mean_c `dist' L3lwma_distance_mean_c2 `dist'^2 /*
      */ L3finter 0*`dist'  /*
	  */ L3finter2 0*(`dist'^2)  /*
	  */ (gapt gapt2 gapt3) 0
simqi, genpr(pred0)
replace pred0=1-pred0
setx mean
setx L3fatal 3 L3lwma_distance_mean_c `dist' L3lwma_distance_mean_c2 `dist'^2 /*
      */ L3finter 3*`dist'  /*
	  */ L3finter2 3*(`dist'^2)  /*
	  */ (gapt gapt2 gapt3) 0
simqi, genpr(pred3)
replace pred3=1-pred3
gen pred=pred3-pred0
quietly sum pred, d
replace p = r(mean) in `i'
replace p5 = r(p5) in `i'
replace p95 = r(p95) in `i'
}

*prepare x-axis
capture drop xaxis
egen xaxis=seq(),f(0) t(81)
replace xaxis=xaxis*.1
replace xaxis=exp(xaxis)

*graph
twoway (line p xaxis, lcolor(black) legend(off))  /*
*/     (line p5 p95 xaxis, lcolor(black black)  /*
*/        lpattern(dash dash)  xlab(5 25 50 100 250 500) xscal(log) /*
*/        xtitle("avg. distance from closest city in km") yline(0, lpattern(dot)) /*
*/        ytitle("predicted change in Pr(mediation)") title("Model 4"))
capture erase fat.gph
graph save fat.gph


graph combine cas.gph fat.gph, ycommon
erase cas.gph
erase fat.gph
graph export __graph25_citydist_effect.pdf, replace
graph export __graph25_citydist_effect.png, replace
