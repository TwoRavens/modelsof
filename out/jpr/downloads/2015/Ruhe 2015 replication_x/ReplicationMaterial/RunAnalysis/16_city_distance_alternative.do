


*load data anew
use "$data", clear
xtset dyad_u month
foreach var in lbest_est fatal lwma_distance_mean lwma_distance_mean2 /*
*/ cum_ldeaths bilateral_talks1 pko observer_mission  /*
*/ good_office fact_finding lwma_distance_mean_c previous {
gen L3`var'=L3.`var'
}



*using distance to major city as proxy for p(win)/strength
eststo clear

gen L3cinter=L3.lbest_est*L3.lwma_distance_mean_c
gen L3cinter2=L3.lbest_est*L3.lwma_distance_mean_c2

gen L3finter=L3.fatal*L3.lwma_distance_mean_c
gen L3finter2=L3.fatal*L3.lwma_distance_mean_c2

eststo: logit talks L3.lbest_est L3.cum_ldeaths L3.bilateral_talks1  /*
*/ L3.pko L3.observer_mission L3.good_office L3.fact_finding L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

eststo: logit talks L3.lbest_est /*
*/ L3.lwma_distance_mean_c L3cinter /*
*/ L3.lwma_distance_mean_c2 L3cinter2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

eststo: logit talks L3.fatal L3.cum_ldeaths L3.bilateral_talks1  /*
*/ L3.pko L3.observer_mission L3.good_office L3.fact_finding L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

eststo: logit talks L3.fatal /*
*/ L3.lwma_distance_mean_c L3finter /*
*/ L3.lwma_distance_mean_c2 L3finter2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

esttab, star(† 0.1 * 0.05 ** 0.01) se label
esttab using __table7_citydist.csv, star(† 0.1 * 0.05 ** 0.01) se label csv replace order(L3.lbest_est /*
*/ L3.lwma_distance_mean_c L3.lwma_distance_mean_c2 L3cinter /*
*/ L3cinter2 L3.fatal_events L3finter /*
*/  L3finter2) scalar(ll) b(3) drop(gapt* oL3.fact_finding /*
*/ o.stronger) varlabels(L3.lbest_est "casualties (log) t-3" /*
*/ L3.lwma_distance_mean "avg. distance from capital (log of km) t-3" /*
*/ L3cinter "casualties*distance t-3" /*
*/ L3cinter2 "casualties*distance^2 t-3" /*
*/ L3.fatal_events "no of fatal battles t-3" /*
*/ L3finter "fatal battles*distance t-3" /*
*/ L3finter2 "fatal battles*distance^2 t-3" /*
*/ L3.bilateral_talks1 "bilateral talks t-3" /*
*/ L3.pko "peacekeeping mission t-3" /*
*/ L3.cum_ldeaths "cumulative casualties (log) t-3" /*
*/ L3.observer_mission "observer mission t-3" /*
*/ L3.good_office "good office t-3" /*
*/ L3.fact_finding "fact finding mission t-3" /*
*/ L3.previous "previous mediation t-3" /*
*/ L3.lwma_distance_mean_c "avg. distance to closest city (log) t-3" /*
*/ L3.lwma_distance_mean_c2 "avg. distance to closest city (log)^2 t-3" /*
*/ _cons constant) /*
*/ nodepvar nomtitl  nonotes /*
*/ addnotes("cluster robust standard errors in parentheses, † p < 0.1, * p < 0.05, ** p < 0.01" /*
*/ "all models are logit models and include polynomials of time since last event (coefficients not reported)")
esttab using __table7_citydist.tex, star(\dagger 0.1 * 0.05 ** 0.01) se label replace order(L3.lbest_est /*
*/ L3.lwma_distance_mean_c L3.lwma_distance_mean_c2 L3cinter /*
*/ L3cinter2 L3.fatal_events L3finter /*
*/  L3finter2) scalar(ll) b(3) drop(gapt* oL3.fact_finding /*
*/ o.stronger)  varlabels(L3.lbest_est "casualties (log) t-3" /*
*/ L3.lwma_distance_mean "avg. distance from capital (log of km) t-3" /*
*/ L3cinter "casualties*distance t-3" /*
*/ L3cinter2 "casualties*distance$^2$ t-3" /*
*/ L3.fatal_events "no of fatal battles t-3" /*
*/ L3finter "fatal battles*distance t-3" /*
*/ L3finter2 "fatal battles*distance$^2$ t-3" /*
*/ L3.bilateral_talks1 "bilateral talks t-3" /*
*/ L3.pko "peacekeeping mission t-3" /*
*/ L3.cum_ldeaths "cumulative casualties (log) t-3" /*
*/ L3.observer_mission "observer mission t-3" /*
*/ L3.good_office "good office t-3" /*
*/ L3.fact_finding "fact finding mission t-3" /*
*/ L3.previous "previous mediation t-3" /*
*/ L3.lwma_distance_mean_c "avg. distance to closest city (log) t-3" /*
*/ L3.lwma_distance_mean_c2 "avg. distance to closest city (log)$^2$ t-3" /*
*/ _cons constant) /*
*/ nodepvar nomtitl nonotes booktabs /*
*/ addnotes("cluster robust standard errors in parentheses, $\dagger$ p \textless 0.1, * p \textless 0.05, ** p \textless 0.01" /*
*/ "all models are logit models and include polynomials of time since last event (coefficients not reported)")


*comparing territorial and government conflicts
eststo clear

eststo, title(revolutionary): logit talks L3.lbest_est /*
*/ L3.lwma_distance_mean_c L3cinter /*
*/ L3.lwma_distance_mean_c2 L3cinter2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1 & territorial==0, vce(cluster dyad_unique)

eststo, title(secessionist): logit talks L3.lbest_est /*
*/ L3.lwma_distance_mean_c L3cinter /*
*/ L3.lwma_distance_mean_c2 L3cinter2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.fact_finding L3.lwma_distance_mean L3.previous /*
*/  logwdi_gdpc nr_dems weak  gapt* /*
*/ if L.talks!=1 & territorial==1, vce(cluster dyad_unique)

eststo, title(revolutionary): logit talks L3.fatal /*
*/ L3.lwma_distance_mean_c L3finter /*
*/ L3.lwma_distance_mean_c2 L3finter2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1 & territorial==0, vce(cluster dyad_unique)

eststo, title(secessionist): logit talks L3.fatal /*
*/ L3.lwma_distance_mean_c L3finter /*
*/ L3.lwma_distance_mean_c2 L3finter2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission /*
*/ L3.fact_finding L3.lwma_distance_mean L3.previous /*
*/ logwdi_gdpc nr_dems weak  gapt* /*
*/ if L.talks!=1 & territorial==1, vce(cluster dyad_unique)

esttab, star(† 0.1 * 0.05 ** 0.01) se label mtitle
esttab using __table8_citydist2.csv, star(† 0.1 * 0.05 ** 0.01) se label csv replace order(L3.lbest_est /*
*/ L3.lwma_distance_mean_c L3.lwma_distance_mean_c2 L3cinter /*
*/ L3cinter2 L3.fatal_events L3finter /*
*/  L3finter2) scalar(ll) b(3) drop(gapt* oL3.fact_finding /*
*/ o.stronger oL3.pko oL3.observer_mission) /*
*/  varlabels(L3.lbest_est "casualties (log) t-3" /*
*/ L3.lwma_distance_mean "avg. distance from capital (log of km) t-3" /*
*/ L3cinter "casualties*distance t-3" /*
*/ L3cinter2 "casualties*distance^2 t-3" /*
*/ L3.fatal_events "no of fatal battles t-3" /*
*/ L3finter "fatal battles*distance t-3" /*
*/ L3finter2 "fatal battles*distance^2 t-3" /*
*/ L3.bilateral_talks1 "bilateral talks t-3" /*
*/ L3.pko "peacekeeping mission t-3" /*
*/ L3.cum_ldeaths "cumulative casualties (log) t-3" /*
*/ L3.observer_mission "observer mission t-3" /*
*/ L3.good_office "good office t-3" /*
*/ L3.fact_finding "fact finding mission t-3" /*
*/ L3.previous "previous mediation t-3" /*
*/ L3.lwma_distance_mean_c "avg. distance to closest city (log) t-3" /*
*/ L3.lwma_distance_mean_c2 "avg. distance to closest city (log)^2 t-3" /*
*/ _cons constant) /*
*/ nodepvar  nonotes mtitle /*
*/ addnotes("cluster robust standard errors in parentheses, † p < 0.1, * p < 0.05, ** p < 0.01" /*
*/ "all models are logit models and include polynomials of time since last event (coefficients not reported)")
esttab using __table8_citydist2.tex, star(\dagger 0.1 * 0.05 ** 0.01) se label replace order(L3.lbest_est /*
*/ L3.lwma_distance_mean_c L3.lwma_distance_mean_c2 L3cinter /*
*/ L3cinter2 L3.fatal_events L3finter /*
*/  L3finter2) scalar(ll) b(3) drop(gapt* oL3.fact_finding /*
*/ o.stronger oL3.pko oL3.observer_mission) /*
*/    varlabels(L3.lbest_est "casualties (log) t-3" /*
*/ L3.lwma_distance_mean "avg. distance from capital (log of km) t-3" /*
*/ L3cinter "casualties*distance t-3" /*
*/ L3cinter2 "casualties*distance$^2$ t-3" /*
*/ L3.fatal_events "no of fatal battles t-3" /*
*/ L3finter "fatal battles*distance t-3" /*
*/ L3finter2 "fatal battles*distance$^2$ t-3" /*
*/ L3.bilateral_talks1 "bilateral talks t-3" /*
*/ L3.pko "peacekeeping mission t-3" /*
*/ L3.cum_ldeaths "cumulative casualties (log) t-3" /*
*/ L3.observer_mission "observer mission t-3" /*
*/ L3.good_office "good office t-3" /*
*/ L3.fact_finding "fact finding mission t-3" /*
*/ L3.previous "previous mediation t-3" /*
*/ L3.lwma_distance_mean_c "avg. distance to closest city (log) t-3" /*
*/ L3.lwma_distance_mean_c2 "avg. distance to closest city (log)$^2$ t-3" /*
*/ _cons constant) /*
*/ nodepvar nonotes booktabs mtitle /*
*/ addnotes("cluster robust standard errors in parentheses, $\dagger$ p \textless 0.1, * p \textless 0.05, ** p \textless 0.01" /*
*/ "all models are logit models and include polynomials of time since last event (coefficients not reported)")
