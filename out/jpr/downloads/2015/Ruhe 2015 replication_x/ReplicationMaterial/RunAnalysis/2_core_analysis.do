** 2

*principal table

eststo clear

eststo: logit talks L3.lbest_est L3.cum_ldeaths L3.bilateral_talks1  /*
*/ L3.pko L3.observer_mission L3.good_office L3.fact_finding L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

eststo: logit talks L3.lbest_est /*
*/ L3.lwma_distance_mean cL3lbest_estcL3lwma_distance_m /*
*/ L3.lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

eststo: logit talks L3.fatal L3.cum_ldeaths L3.bilateral_talks1  /*
*/ L3.pko L3.observer_mission L3.good_office L3.fact_finding L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

eststo: logit talks L3.fatal /*
*/ L3.lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3.lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

logit talks L3.lbest_est /*
*/ L3.lwma_distance_mean cL3lbest_estcL3lwma_distance_m /*
*/ L3.lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m2 /*
*/ L3.previous gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

logit talks L3.fatal /*
*/ L3.lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3.lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3.previous gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

esttab, star(† 0.1 * 0.05 ** 0.01) se label
esttab using __table1_core.csv, star(† 0.1 * 0.05 ** 0.01) se label csv replace order(L3.lbest_est /*
*/ L3.lwma_distance_mean L3.lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m /*
*/ cL3lbest_estcL3lwma_distance_m2 L3.fatal_events cL3fatalcL3lwma_distance_mean /*
*/  cL3fatalcL3lwma_distance_mean2) scalar(ll) b(3) drop(gapt* oL3.fact_finding /*
*/ o.stronger) varlabels(L3.lbest_est "casualties (log) t-3" /*
*/ L3.lwma_distance_mean "avg. distance from capital (log of km) t-3" /*
*/ L3.lwma_distance_mean2 "avg. distance from capital (log of km)² t-3" /*
*/ cL3lbest_estcL3lwma_distance_m "casualties*distance t-3" /*
*/ cL3lbest_estcL3lwma_distance_m2 "casualties*distance² t-3" /*
*/ L3.fatal_events "no of fatal battles t-3" /*
*/ cL3fatalcL3lwma_distance_mean "fatal battles*distance t-3" /*
*/ cL3fatalcL3lwma_distance_mean2 "fatal battles*distance² t-3" /*
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
*/ addnotes("cluster robust standard errors in parentheses, † p < 0.1, * p < 0.05, ** p < 0.01" /*
*/ "all models are logit models and include polynomials of time since last event (coefficients not reported)")
esttab using __table1_core.tex, star(\dagger 0.1 * 0.05 ** 0.01) se label replace order(L3.lbest_est /*
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
*/ addnotes("cluster robust standard errors in parentheses, $\dagger$ p \textless 0.1, * p \textless 0.05, ** p \textless 0.01" /*
*/ "all models are logit models and include polynomials of time since last event (coefficients not reported)")
