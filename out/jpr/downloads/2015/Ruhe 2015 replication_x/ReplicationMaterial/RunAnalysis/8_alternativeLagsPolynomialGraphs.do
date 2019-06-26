** 5

* graphs for interpretation

set more off
cd "`w_dir'"

*casualties

*third order polynomial
forvalues t = 1/5 {

*first recreate original data to run old model, then run model
use "$data", clear
xtset dyad_unique month


foreach var in lbest_est fatal lwma_distance_mean lwma_distance_mean2 /*
*/ lwma_distance_mean3 /*
*/ cum_ldeaths bilateral_talks1 pko observer_mission  /*
*/ good_office fact_finding lwma_distance_mean_c previous {
gen L`t'`var'=L`t'.`var'
}

*model with casualties as intensity measure

quietly logit talks L`t'lbest_est /*
*/ L`t'lwma_distance_mean c.L`t'lbest_est#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'lbest_est#c.L`t'lwma_distance_mean2 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, 
est store restr
quietly logit talks L`t'lbest_est /*
*/ L`t'lwma_distance_mean c.L`t'lbest_est#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'lbest_est#c.L`t'lwma_distance_mean2 /*
*/ L`t'lwma_distance_mean3 c.L`t'lbest_est#c.L`t'lwma_distance_mean3 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, 
lrtest restr
local p=round(r(p), .001)

logit talks L`t'lbest_est /*
*/ L`t'lwma_distance_mean c.L`t'lbest_est#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'lbest_est#c.L`t'lwma_distance_mean2 /*
*/ L`t'lwma_distance_mean3 c.L`t'lbest_est#c.L`t'lwma_distance_mean3 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)


preserve

*draw 1000 potential realization from the coefficient distribution
set seed 2138975154
drawnorm beta1-beta24 beta0, n(1000) means(e(b)) cov(e(V)) clear
save betasims.dta, replace
restore
capture drop _merge
merge using betasims.dta 
tab _merge, miss
drop _merge
*beta1, beta3 and beta5 are the relevant coefficients for the interaction term

capture drop casualties_inter*
gen casualties_interaction=.
gen casualties_inter_up=.
gen casualties_inter_low=.
local n=1

*calculate coefficient of casualties given different values of ln(distance)
forvalues i=0(.1)8 {
scalar ln_dist = `i'
capture drop beta_casualties
gen beta_casualties = beta1 + beta3*ln_dist + beta5*(ln_dist^2) + beta7*(ln_dist^3)  
quietly sum beta_casualties, d
replace casualties_interaction=r(mean) in `n'
replace casualties_inter_up=r(p95) in `n'
replace casualties_inter_low=r(p5) in `n'
local n=`n'+1
}

*prepare x-axis
egen xaxis=seq(),f(0) t(81)
replace xaxis=xaxis*.1
replace xaxis=exp(xaxis)


*graph
twoway (line casualties_interaction xaxis, lcolor(black) yline(0, lpattern(dot) /*
*/        lcolor(black)) legend(off))  /*
*/     (line casualties_inter_up casualties_inter_low xaxis, lcolor(black black)  /*
*/        lpattern(dash dash)  xlab(5 25 50 100 250 500) xscal(log) /*
*/        xtitle("avg. distance from capital in km") /*
*/        ytitle("coefficient of casualties variable") /*
*/			note("LR-Test against quadratic model, p-value=`p'"))
graph save cas.gph

drop beta*



*model with fatal events as intensity indicator
xtset dyad_unique month
quietly logit talks L`t'fatal /*
*/ L`t'lwma_distance_mean c.L`t'fatal#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'fatal#c.L`t'lwma_distance_mean2 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, 
est stor restr
quietly logit talks L`t'fatal /*
*/ L`t'lwma_distance_mean c.L`t'fatal#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'fatal#c.L`t'lwma_distance_mean2 /*
*/ L`t'lwma_distance_mean3 c.L`t'fatal#c.L`t'lwma_distance_mean3 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, 
lrtest restr
local p=round(r(p), .001)

logit talks L`t'fatal /*
*/ L`t'lwma_distance_mean c.L`t'fatal#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'fatal#c.L`t'lwma_distance_mean2 /*
*/ L`t'lwma_distance_mean3 c.L`t'fatal#c.L`t'lwma_distance_mean3 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

preserve

*draw 1000 potential realization from the coefficient distribution
set seed 2138975154
drawnorm beta1-beta24 beta0, n(1000) means(e(b)) cov(e(V)) clear
save betasims.dta, replace
restore
merge using betasims.dta 
tab _merge, miss
drop _merge
*beta1, beta3 and beta5 are the relevant coefficients for the interaction term

capture drop fatal_inter*
gen fatal_interaction=.
gen fatal_inter_up=.
gen fatal_inter_low=.
local n=1

*calculate coefficient of casualties given different values of ln(distance)
forvalues i=0(.1)8 {
scalar ln_dist = `i'
capture drop beta_fatal
gen beta_fatal = beta1 + beta3*ln_dist + beta5*(ln_dist^2) + beta7*(ln_dist^3)  
quietly sum beta_fatal, d
replace fatal_interaction=r(mean) in `n'
replace fatal_inter_up=r(p95) in `n'
replace fatal_inter_low=r(p5) in `n'
local n=`n'+1
}


*graph
twoway (line fatal_interaction xaxis, lcolor(black) yline(0, lpattern(dot) /*
*/        lcolor(black)) legend(off))  /*
*/     (line fatal_inter_up fatal_inter_low xaxis, lcolor(black black)  /*
*/        lpattern(dash dash)  xlab(5 25 50 100 250 500) xscal(log) /*
*/        xtitle("avg. distance from capital in km") /*
*/        ytitle("coefficient of fatal events variable") /*  
*/			note("LR-Test against quadratic model, p-value=`p'"))
graph save fat.gph



*combining both graphs
graph combine cas.gph fat.gph, ycommon title("lag `t'")
erase cas.gph
erase fat.gph
graph save lag`t'.gph

}

graph combine lag1.gph lag2.gph lag3.gph lag4.gph lag5.gph, ycommon cols(1) ysize(10) xsize(5)
graph export __graph3_poly3lagcompare.pdf, replace
graph export __graph3_poly3lagcompare.png, replace
forvalues t=1/5 {
erase lag`t'.gph
}











*fourth order polynomial
forvalues t = 1/5 {

*first recreate original data to run old model, then run model
use "$data", clear
xtset dyad_unique month

gen lwma_distance_mean4=lwma_distance_mean^4
gen lwma_distance_mean5=lwma_distance_mean^5

foreach var in lbest_est fatal lwma_distance_mean lwma_distance_mean2 /*
*/ lwma_distance_mean3 lwma_distance_mean4 lwma_distance_mean5 /*
*/ cum_ldeaths bilateral_talks1 pko observer_mission  /*
*/ good_office fact_finding lwma_distance_mean_c previous {
gen L`t'`var'=L`t'.`var'
}

*model with casualties as intensity measure
quietly logit talks L`t'lbest_est /*
*/ L`t'lwma_distance_mean c.L`t'lbest_est#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'lbest_est#c.L`t'lwma_distance_mean2 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, 
est store restr
quietly logit talks L`t'lbest_est /*
*/ L`t'lwma_distance_mean c.L`t'lbest_est#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'lbest_est#c.L`t'lwma_distance_mean2 /*
*/ L`t'lwma_distance_mean3 c.L`t'lbest_est#c.L`t'lwma_distance_mean3 /*
*/ L`t'lwma_distance_mean4 c.L`t'lbest_est#c.L`t'lwma_distance_mean4 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, 
lrtest restr
local p=round(r(p), .001)

logit talks L`t'lbest_est /*
*/ L`t'lwma_distance_mean c.L`t'lbest_est#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'lbest_est#c.L`t'lwma_distance_mean2 /*
*/ L`t'lwma_distance_mean3 c.L`t'lbest_est#c.L`t'lwma_distance_mean3 /*
*/ L`t'lwma_distance_mean4 c.L`t'lbest_est#c.L`t'lwma_distance_mean4 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

preserve

*draw 1000 potential realization from the coefficient distribution
set seed 2138975154
drawnorm beta1-beta26 beta0, n(1000) means(e(b)) cov(e(V)) clear
save betasims.dta, replace
restore
capture drop _merge
merge using betasims.dta 
tab _merge, miss
drop _merge
*beta1, beta3 and beta5 are the relevant coefficients for the interaction term

capture drop casualties_inter*
gen casualties_interaction=.
gen casualties_inter_up=.
gen casualties_inter_low=.
local n=1

*calculate coefficient of casualties given different values of ln(distance)
forvalues i=0(.1)8 {
scalar ln_dist = `i'
capture drop beta_casualties
gen beta_casualties = beta1 + beta3*ln_dist + beta5*(ln_dist^2) + beta7*(ln_dist^3) + beta9*(ln_dist^4) 
quietly sum beta_casualties, d
replace casualties_interaction=r(mean) in `n'
replace casualties_inter_up=r(p95) in `n'
replace casualties_inter_low=r(p5) in `n'
local n=`n'+1
}

*prepare x-axis
egen xaxis=seq(),f(0) t(81)
replace xaxis=xaxis*.1
replace xaxis=exp(xaxis)


*graph
twoway (line casualties_interaction xaxis, lcolor(black) yline(0, lpattern(dot) /*
*/        lcolor(black)) legend(off))  /*
*/     (line casualties_inter_up casualties_inter_low xaxis, lcolor(black black)  /*
*/        lpattern(dash dash)  xlab(5 25 50 100 250 500) xscal(log) /*
*/        xtitle("avg. distance from capital in km") /*
*/        ytitle("coefficient of casualties variable") /*  
*/			note("LR-Test against quadratic model, p-value=`p'")) 
graph save cas.gph

drop beta*



*model with fatal events as intensity indicator
xtset dyad_unique month
quietly logit talks L`t'fatal /*
*/ L`t'lwma_distance_mean c.L`t'fatal#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'fatal#c.L`t'lwma_distance_mean2 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, 
est stor restr
quietly logit talks L`t'fatal /*
*/ L`t'lwma_distance_mean c.L`t'fatal#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'fatal#c.L`t'lwma_distance_mean2 /*
*/ L`t'lwma_distance_mean3 c.L`t'fatal#c.L`t'lwma_distance_mean3 /*
*/ L`t'lwma_distance_mean4 c.L`t'fatal#c.L`t'lwma_distance_mean4 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, 
lrtest restr
local p=round(r(p), .001)

logit talks L`t'fatal /*
*/ L`t'lwma_distance_mean c.L`t'fatal#c.L`t'lwma_distance_mean /*
*/ L`t'lwma_distance_mean2 c.L`t'fatal#c.L`t'lwma_distance_mean2 /*
*/ L`t'lwma_distance_mean3 c.L`t'fatal#c.L`t'lwma_distance_mean3 /*
*/ L`t'lwma_distance_mean4 c.L`t'fatal#c.L`t'lwma_distance_mean4 /*
*/ L`t'cum_ldeaths L`t'bilateral_talks1 L`t'pko L`t'observer_mission  /*
*/ L`t'good_office L`t'fact_finding L`t'lwma_distance_mean_c L`t'previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

preserve

*draw 1000 potential realization from the coefficient distribution
set seed 2138975154
drawnorm beta1-beta26 beta0, n(1000) means(e(b)) cov(e(V)) clear
save betasims.dta, replace
restore
merge using betasims.dta 
tab _merge, miss
drop _merge
*beta1, beta3 and beta5 are the relevant coefficients for the interaction term

capture drop fatal_inter*
gen fatal_interaction=.
gen fatal_inter_up=.
gen fatal_inter_low=.
local n=1

*calculate coefficient of casualties given different values of ln(distance)
forvalues i=0(.1)8 {
scalar ln_dist = `i'
capture drop beta_fatal
gen beta_fatal = beta1 + beta3*ln_dist + beta5*(ln_dist^2) + beta7*(ln_dist^3) + beta9*(ln_dist^4) 
quietly sum beta_fatal, d
replace fatal_interaction=r(mean) in `n'
replace fatal_inter_up=r(p95) in `n'
replace fatal_inter_low=r(p5) in `n'
local n=`n'+1
}


*graph
twoway (line fatal_interaction xaxis, lcolor(black) yline(0, lpattern(dot) /*
*/        lcolor(black)) legend(off))  /*
*/     (line fatal_inter_up fatal_inter_low xaxis, lcolor(black black)  /*
*/        lpattern(dash dash)  xlab(5 25 50 100 250 500) xscal(log) /*
*/        xtitle("avg. distance from capital in km") /*
*/        ytitle("coefficient of fatal events variable") /*  
*/			note("LR-Test against quadratic model, p-value=`p'"))   
graph save fat.gph



*combining both graphs
graph combine cas.gph fat.gph, ycommon title("lag `t'")
erase cas.gph
erase fat.gph
graph save lag`t'.gph

}

graph combine lag1.gph lag2.gph lag3.gph lag4.gph lag5.gph, ycommon cols(1) ysize(10) xsize(5)
graph export __graph4_poly4lagcompare.pdf, replace
graph export __graph4_poly4lagcompare.png, replace
forvalues t=1/5 {
erase lag`t'.gph
}
