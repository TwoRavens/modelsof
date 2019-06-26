** 3

* graphs for interpretation



*casualties

*first recreate original data to run old model, then run model
use "$data", clear
xtset dyad_unique month
foreach var in lbest_est fatal lwma_distance_mean lwma_distance_mean2 /*
*/ cum_ldeaths bilateral_talks1 pko observer_mission  /*
*/ good_office fact_finding lwma_distance_mean_c previous {
gen L3`var'=L3.`var'
}

*replicate the core model with casualties as intensity measure, jackknife
eststo clear
eststo: logit talks L3.lbest_est /*
*/ L3.lwma_distance_mean cL3lbest_estcL3lwma_distance_m /*
*/ L3.lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(jack, cluster(dyad_u))

preserve

*draw 1000 potential realization from the coefficient distribution
set seed 2138975154
drawnorm beta1-beta22 beta0, n(1000) means(e(b)) cov(e(V)) clear
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
gen where=-5.9
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
*/  || scatter where plot_dist if tag_plot_dist & plot_dist!=0, /*
*/        plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(symbol) mlabpos(6) /*
*/        legend(off) xlab(5 25 50 100 250 500) xscal(log) saving(cas.gph)

drop beta*



*fatal events

xtset dyad_unique month
eststo: logit talks L3.fatal /*
*/ L3.lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3.lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(jack, cluster(dyad_u))

preserve

*draw 1000 potential realization from the coefficient distribution
set seed 2138975154
drawnorm beta1-beta22 beta0, n(1000) means(e(b)) cov(e(V)) clear
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
*/  || scatter where plot_dist if tag_plot_dist & plot_dist!=0, /*
*/        plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(symbol) mlabpos(6) /*
*/        legend(off) xlab(5 25 50 100 250 500) xscal(log)  saving(fat.gph)



*combining both graphs
graph combine cas.gph fat.gph, ycommon
erase cas.gph
erase fat.gph
graph export __graph22_core_jackknife.pdf, replace
graph export __graph22_core_jackknife.png, replace


esttab, star(† 0.1 * 0.05 ** 0.01) se label
esttab using __table6_core_jackknife.csv, star(† 0.1 * 0.05 ** 0.01) se label csv replace order(L3.lbest_est /*
*/ L3.lwma_distance_mean L3.lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m /*
*/ cL3lbest_estcL3lwma_distance_m2 L3.fatal_events cL3fatalcL3lwma_distance_mean /*
*/  cL3fatalcL3lwma_distance_mean2) scalar(ll) b(3) drop(gapt* oL3.fact_finding /*
*/ o.stronger) varlabels(L3.lbest_est "casualties (log) t-3" /*
*/ L3.lwma_distance_mean "avg. distance from capital (log of km) t-3" /*
*/ L3.lwma_distance_mean2 "avg. distance from capital (log of km)^2 t-3" /*
*/ cL3lbest_estcL3lwma_distance_m "casualties*distance t-3" /*
*/ cL3lbest_estcL3lwma_distance_m2 "casualties*distance^2 t-3" /*
*/ L3.fatal_events "no of fatal battles t-3" /*
*/ cL3fatalcL3lwma_distance_mean "fatal battles*distance t-3" /*
*/ cL3fatalcL3lwma_distance_mean2 "fatal battles*distance^2 t-3" /*
*/ L3.bilateral_talks1 "bilateral talks t-3" /*
*/ L3.pko "peacekeeping mission t-3" /*
*/ L3.cum_ldeaths "cumulative casualties (log) t-3" /*
*/ L3.observer_mission "observer mission t-3" /*
*/ L3.good_office "good office t-3" /*
*/ L3.fact_finding "fact finding mission t-3" /*
*/ L3.previous "previous mediation t-3" /*
*/ L3.lwma_distance_mean_c "avg. distance to closest city (log) t-3" /*
*/ _cons constant) /*
*/ nodepvar nomtitl  nonotes /*
*/ addnotes("jackknife standard errors in parentheses, † p < 0.1, * p < 0.05, ** p < 0.01" /*
*/ "all models specified as in original paper")
esttab using __table6_core_jackknife.tex, star(\dagger 0.1 * 0.05 ** 0.01) se label replace order(L3.lbest_est /*
*/ L3.lwma_distance_mean L3.lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m /*
*/ cL3lbest_estcL3lwma_distance_m2 L3.fatal_events cL3fatalcL3lwma_distance_mean /*
*/  cL3fatalcL3lwma_distance_mean2) scalar(ll) b(3) drop(gapt* oL3.fact_finding /*
*/ o.stronger)  varlabels(L3.lbest_est "casualties (log) t-3" /*
*/ L3.lwma_distance_mean "avg. distance from capital (log of km) t-3" /*
*/ L3.lwma_distance_mean2 "avg. distance from capital (log of km)$^2$ t-3" /*
*/ cL3lbest_estcL3lwma_distance_m "casualties*distance t-3" /*
*/ cL3lbest_estcL3lwma_distance_m2 "casualties*distance$^2$ t-3" /*
*/ L3.fatal_events "no of fatal battles t-3" /*
*/ cL3fatalcL3lwma_distance_mean "fatal battles*distance t-3" /*
*/ cL3fatalcL3lwma_distance_mean2 "fatal battles*distance$^2$ t-3" /*
*/ L3.bilateral_talks1 "bilateral talks t-3" /*
*/ L3.pko "peacekeeping mission t-3" /*
*/ L3.cum_ldeaths "cumulative casualties (log) t-3" /*
*/ L3.observer_mission "observer mission t-3" /*
*/ L3.good_office "good office t-3" /*
*/ L3.fact_finding "fact finding mission t-3" /*
*/ L3.previous "previous mediation t-3" /*
*/ L3.lwma_distance_mean_c "avg. distance to closest city (log) t-3" /*
*/ _cons constant) /*
*/ nodepvar nomtitl nonotes booktabs /*
*/ addnotes("jackknife standard errors in parentheses, $\dagger$ p \textless 0.1, * p \textless 0.05, ** p \textless 0.01" /*
*/ "all models specified as in original paper")
