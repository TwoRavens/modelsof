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

estsimp logit talks L3lbest_est /*
*/ L3lwma_distance_mean cL3lbest_estcL3lwma_distance_m /*
*/ L3lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m2 /*
*/ L3cum_ldeaths L3bilateral_talks1 L3pko L3observer_mission/*
*/ L3good_office L3lwma_distance_mean_c L3previous /*
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
setx L3lbest_est 0 L3lwma_distance_mean `dist' L3lwma_distance_mean2 `dist'^2 /*
      */ cL3lbest_estcL3lwma_distance_m 0*`dist'  /*
	  */ cL3lbest_estcL3lwma_distance_m2 0*(`dist'^2)  /*
	  */ (gapt gapt2 gapt3) 0
simqi, genpr(pred0)
replace pred0=1-pred0
setx mean
setx L3lbest_est log(22) L3lwma_distance_mean `dist' L3lwma_distance_mean2 `dist'^2 /*
      */ cL3lbest_estcL3lwma_distance_m log(22)*`dist'  /*
	  */ cL3lbest_estcL3lwma_distance_m2 log(22)*(`dist'^2)  /*
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
*/        xtitle("avg. distance from capital in km") yline(0, lpattern(dot)) /*
*/        ytitle("predicted change in Pr(mediation)") title("Model 2"))
capture erase cas.gph
graph save cas.gph



**Fatal events

capture drop b1-b21   
estsimp logit talks L3fatal /*
*/ L3lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3cum_ldeaths L3bilateral_talks1 L3pko L3observer_mission /*
*/ L3good_office L3lwma_distance_mean_c L3previous /*
*/ p_polity2 logwdi_gdpc nr_dems  mweak weak gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

capture drop p p5 p95
gen p=.
gen p5=.
gen p95=.
forvalues i=1/81 {
capture drop pred0 pred3 pred
local dist=`i'/10
setx mean
setx L3fatal 0 L3lwma_distance_mean `dist' L3lwma_distance_mean2 `dist'^2 /*
      */ cL3fatalcL3lwma_distance_mean 0*`dist'  /*
	  */ cL3fatalcL3lwma_distance_mean2 0*(`dist'^2)  /*
	  */ (gapt gapt2 gapt3) 0
simqi, genpr(pred0)
replace pred0=1-pred0
setx mean
setx L3fatal 3 L3lwma_distance_mean `dist' L3lwma_distance_mean2 `dist'^2 /*
      */ cL3fatalcL3lwma_distance_mean 3*`dist'  /*
	  */ cL3fatalcL3lwma_distance_mean2 3*(`dist'^2)  /*
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
*/        xtitle("avg. distance from capital in km") yline(0, lpattern(dot)) /*
*/        ytitle("predicted change in Pr(mediation)") title("Model 4"))
capture erase fat.gph
graph save fat.gph


graph combine cas.gph fat.gph, ycommon
erase cas.gph
erase fat.gph
graph export __graph24_joint_effect.pdf, replace
graph export __graph24_joint_effect.png, replace
