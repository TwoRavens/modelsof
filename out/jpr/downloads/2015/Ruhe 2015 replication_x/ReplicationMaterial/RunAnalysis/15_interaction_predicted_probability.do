

*comparing pure model against pure model without interaction effect


*load data anew
use "$data", clear
xtset dyad_u month
foreach var in lbest_est fatal lwma_distance_mean lwma_distance_mean2 /*
*/ cum_ldeaths bilateral_talks1 pko observer_mission  /*
*/ good_office fact_finding lwma_distance_mean_c previous {
gen L3`var'=L3.`var'
}


*varying distance

forvalues f=1(2)9 {
capture drop b1-b16   
estsimp logit talks L3fatal /*
*/ L3lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3cum_ldeaths L3.bilateral_talks1 L3pko /*
*/ L3good_office L3lwma_distance_mean_c L3previous /*
*/ p_polity2 logwdi_gdpc nr_dems gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

capture drop p p5 p95
gen p=.
gen p5=.
gen p95=.
forvalues i=1/81 {
local events=`f'
local dist=`i'/10
setx mean
setx L3fatal `events' L3lwma_distance_mean `dist' L3lwma_distance_mean2 `dist'^2 /*
      */ cL3fatalcL3lwma_distance_mean `events'*`dist'  /*
	  */ cL3fatalcL3lwma_distance_mean2 `events'*(`dist'^2)  /*
	  */ (gapt gapt2 gapt3) 0
capture drop pred
simqi, genpr(pred)
replace pred=1-pred
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
*/        xtitle("avg. distance from capital in km") ylab(0(.2)1) /*
*/        ytitle("predicted probability of mediation") title("w/ interaction"))
graph save p_i.gph

	  
capture drop b1-b18	  
estsimp logit talks L3fatal /*
*/ L3lwma_distance_mean L3lwma_distance_mean2 /*
*/ L3cum_ldeaths L3bilateral_talks1 L3pko /*
*/ L3good_office L3lwma_distance_mean_c L3previous /*
*/ p_polity2 logwdi_gdpc nr_dems gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

capture drop p p5 p95
gen p=.
gen p5=.
gen p95=.
forvalues i=1/81 {
local events=`f'
local dist=`i'/10
setx mean
setx L3fatal `events' L3lwma_distance_mean `dist' L3lwma_distance_mean2 `dist'^2 /*
	  */ (gapt gapt2 gapt3) 0
capture drop pred
simqi, genpr(pred)
replace pred=1-pred
quietly sum pred, d
replace p = r(mean) in `i'
replace p5 = r(p5) in `i'
replace p95 = r(p95) in `i'
}

*graph
twoway (line p xaxis, lcolor(black) legend(off))  /*
*/     (line p5 p95 xaxis, lcolor(black black)  /*
*/        lpattern(dash dash)  xlab(5 25 50 100 250 500) xscal(log) /*
*/        xtitle("avg. distance from capital in km") ylab(0(.2)1) /*
*/        ytitle("predicted probability of mediation") title("w/o interaction"))
graph save p_0.gph


graph combine p_i.gph p_0.gph, title("`f' fatal event(s)") saving(ff`f')
erase p_i.gph
erase p_0.gph
}

graph combine ff1.gph ff3.gph ff5.gph ff7.gph ff9.gph, cols(1) ysize(10) xsize(5)
forvalues f=1(2)9 {
erase ff`f'.gph
}
graph export __graph10_intercomp.pdf, replace
graph export __graph10_intercomp.png, replace



*varying events

forvalues f=0(2)6 {
capture drop b1-b16   
estsimp logit talks L3fatal /*
*/ L3lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3cum_ldeaths L3bilateral_talks1 L3pko /*
*/ L3good_office L3lwma_distance_mean_c L3previous /*
*/ p_polity2 logwdi_gdpc nr_dems gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

capture drop p p5 p95
gen p=.
gen p5=.
gen p95=.
forvalues i=0/8 {
local events=`i'
local dist=`f'
setx mean
setx L3fatal `events' L3lwma_distance_mean `dist' L3lwma_distance_mean2 `dist'^2 /*
      */ cL3fatalcL3lwma_distance_mean `events'*`dist'  /*
	  */ cL3fatalcL3lwma_distance_mean2 `events'*(`dist'^2)  /*
	  */ (gapt gapt2 gapt3) 0
capture drop pred
simqi, genpr(pred)
replace pred=1-pred
quietly sum pred, d
local j=`i'+1
replace p = r(mean) in `j'
replace p5 = r(p5) in `j'
replace p95 = r(p95) in `j'
}

*prepare x-axis
capture drop xaxis
egen xaxis=seq(),f(0) t(8)

*graph
twoway (line p xaxis, lcolor(black) legend(off))  /*
*/     (line p5 p95 xaxis, lcolor(black black)  /*
*/        lpattern(dash dash)  /*
*/        xtitle("number of fatal events") ylab(0(.2)1) /*
*/        ytitle("predicted probability of mediation") title("w/o interaction"))
graph save p_i.gph

	  
capture drop b1-b18	  
estsimp logit talks L3fatal /*
*/ L3lwma_distance_mean L3lwma_distance_mean2 /*
*/ L3cum_ldeaths L3bilateral_talks1 L3pko /*
*/ L3good_office L3lwma_distance_mean_c L3previous /*
*/ p_polity2 logwdi_gdpc nr_dems gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

capture drop p p5 p95
gen p=.
gen p5=.
gen p95=.
forvalues i=0/8 {
local events=`i'
local dist=`f'
setx mean
setx L3fatal `events' L3lwma_distance_mean `dist' L3lwma_distance_mean2 `dist'^2 /*
	  */ (gapt gapt2 gapt3) 0
capture drop pred
simqi, genpr(pred)
replace pred=1-pred
quietly sum pred, d
local j=`i'+1
replace p = r(mean) in `j'
replace p5 = r(p5) in `j'
replace p95 = r(p95) in `j'
}

*graph
twoway (line p xaxis, lcolor(black) legend(off))  /*
*/     (line p5 p95 xaxis, lcolor(black black)  /*
*/        lpattern(dash dash)  /*
*/        xtitle("number of fatal events") ylab(0(.2)1) /*
*/        ytitle("predicted probability of mediation") title("w/o interaction"))
graph save p_0.gph

local d=round(exp(`f'))
graph combine p_i.gph p_0.gph, title("`d' km") saving(ff`f')
erase p_i.gph
erase p_0.gph
}

graph combine ff0.gph ff2.gph ff4.gph ff6.gph, cols(1) ysize(8) xsize(5)
forvalues f=0(2)6 {
erase ff`f'.gph
}
graph export __graph11_intercomp.pdf, replace
graph export __graph11_intercomp.png, replace
