** 7

***Dyad FE


*show graphic comparisson of interaction terms when using conditional fixed 
*effects logit



*first recreate original data to run old model, then run model
use "$data", clear
xtset dyad_unique month



**casualties variable

*rerun model as conditional fixed effects logit (see 4_heterogeneity.do)
xtlogit talks L3.lbest_est /*
*/ L3.lwma_distance_mean c.L3.lbest_est#c.L3.lwma_distance_mean /*
*/ L3.lwma_distance_mean2 c.L3.lbest_est#c.L3.lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ , fe

preserve

*draw 1000 potential realization from the coefficient distribution
set seed 2138975154
drawnorm beta1-beta22, n(1000) means(e(b)) cov(e(V)) clear
save betasims.dta, replace
restore
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
gen beta_casualties = beta1 + beta3*ln_dist + beta5*(ln_dist^2)
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

*prepare for rug plot
gen where=-3.9
gen symbol = "|"
gen plot_dist=wma_distance_mean
replace plot_dist=1.001 if plot_dist>0 & plot_dist<1
egen tag_plot_dist = tag(plot_dist)

*graph
twoway (line casualties_interaction xaxis, lcolor(black) yline(0, lpattern(dot) /*
*/        lcolor(black)) legend(off))  /*
*/     (line casualties_inter_up casualties_inter_low xaxis, lcolor(black black)  /*
*/        lpattern(dash dash)  xlab(5 25 50 100 250 500) xscal(log) /*
*/        xtitle("avg. distance from capital in km") /*
*/        ytitle("coefficient of casualties variable")) /*
rug plot:
*/  || scatter where plot_dist if tag_plot_dist & plot_dist!=0 & e(sample), /*
*/        plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(symbol) mlabpos(6) /*
*/        legend(off) xlab(5 25 50 100 250 500) xscal(log) saving(cas.gph)

drop beta*




**fatal events variable

*rerun model as conditional fixed effects logit (see 4_heterogeneity.do)
xtset dyad_unique month
xtlogit talks L3.fatal /*
*/ L3.lwma_distance_mean c.L3.fatal#c.L3.lwma_distance_mean /*
*/ L3.lwma_distance_mean2 c.L3.fatal#c.L3.lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ , fe


preserve

*draw 1000 potential realization from the coefficient distribution
set seed 2138975154
drawnorm beta1-beta22, n(1000) means(e(b)) cov(e(V)) clear
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
gen beta_fatal = beta1 + beta3*ln_dist + beta5*(ln_dist^2)
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
*/        ytitle("coefficient of fatal events variable")) /*
rug plot:
*/  || scatter where plot_dist if tag_plot_dist & plot_dist!=0 & e(sample), /*
*/        plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(symbol) mlabpos(6) /*
*/        legend(off) xlab(5 25 50 100 250 500) xscal(log)  saving(fat.gph)



*combining both graphs
graph combine cas.gph fat.gph, ycommon
erase cas.gph
erase fat.gph
graph export __graph5_FE.pdf, replace
graph export __graph5_FE.png, replace

drop fatal_inter*



***Dyad-Year FE

*show graphic comparisson of interaction terms when using conditional fixed 
*effects logit



*first recreate original data to run old model, then run model
use "$data", clear
xtset dyad_unique month

tostring dyad_u, gen(strdyad)
tostring year, gen(stryear)
gen strdy=strdyad+" "+stryear
encode strdy, gen(dy)

xtset dy month


**casualties variable

*rerun model as conditional fixed effects logit (see 4_heterogeneity.do)
xtlogit talks L3.lbest_est /*
*/ L3.lwma_distance_mean c.L3.lbest_est#c.L3.lwma_distance_mean /*
*/ L3.lwma_distance_mean2 c.L3.lbest_est#c.L3.lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ , fe

preserve

*draw 1000 potential realization from the coefficient distribution
set seed 2138975154
drawnorm beta1-beta22, n(1000) means(e(b)) cov(e(V)) clear
save betasims.dta, replace
restore
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
gen beta_casualties = beta1 + beta3*ln_dist + beta5*(ln_dist^2)
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

*prepare for rug plot
gen where=-5.8
gen symbol = "|"
gen plot_dist=wma_distance_mean
replace plot_dist=1.001 if plot_dist>0 & plot_dist<1
egen tag_plot_dist = tag(plot_dist)

*graph
twoway (line casualties_interaction xaxis, lcolor(black) yline(0, lpattern(dot) /*
*/        lcolor(black)) legend(off))  /*
*/     (line casualties_inter_up casualties_inter_low xaxis, lcolor(black black)  /*
*/        lpattern(dash dash)  xlab(5 25 50 100 250 500) xscal(log) /*
*/        xtitle("avg. distance from capital in km") /*
*/        ytitle("coefficient of casualties variable")) /*
rug plot:
*/  || scatter where plot_dist if tag_plot_dist & plot_dist!=0 & e(sample), /*
*/        plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(symbol) mlabpos(6) /*
*/        legend(off) xlab(5 25 50 100 250 500) xscal(log) saving(cas.gph)

drop beta*




**fatal events variable

*rerun model as conditional fixed effects logit (see 4_heterogeneity.do)
xtset dy month
xtlogit talks L3.fatal /*
*/ L3.lwma_distance_mean c.L3.fatal#c.L3.lwma_distance_mean /*
*/ L3.lwma_distance_mean2 c.L3.fatal#c.L3.lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ , fe


preserve

*draw 1000 potential realization from the coefficient distribution
set seed 2138975154
drawnorm beta1-beta22, n(1000) means(e(b)) cov(e(V)) clear
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
gen beta_fatal = beta1 + beta3*ln_dist + beta5*(ln_dist^2)
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
*/        ytitle("coefficient of fatal events variable")) /*
rug plot:
*/  || scatter where plot_dist if tag_plot_dist & plot_dist!=0 & e(sample), /*
*/        plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(symbol) mlabpos(6) /*
*/        legend(off) xlab(5 25 50 100 250 500) xscal(log)  saving(fat.gph)



*combining both graphs
graph combine cas.gph fat.gph, ycommon
erase cas.gph
erase fat.gph
graph export __graph5_dyFE.pdf, replace
graph export __graph5_dyFE.png, replace

drop fatal_inter*
