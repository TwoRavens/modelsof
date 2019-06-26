** 6

*the two models are compared against random effects logit and 
*conditional fixed-effects logit
use "$data", clear
xtset dyad_u month


tostring dyad_u, gen(strdyad)
tostring year, gen(stryear)
gen strdy=strdyad+" "+stryear
encode strdy, gen(dy)


* casualties

eststo clear

eststo, title(original): logit talks L3.lbest_est /*
*/ L3.lwma_distance_mean cL3lbest_estcL3lwma_distance_m /*
*/ L3.lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

eststo, title(RE): xtlogit talks L3.lbest_est /*
*/ L3.lwma_distance_mean cL3lbest_estcL3lwma_distance_m /*
*/ L3.lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, re

eststo, title(dyad FE): xtlogit talks L3.lbest_est /*
*/ L3.lwma_distance_mean cL3lbest_estcL3lwma_distance_m /*
*/ L3.lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ , fe

xtset dy month
eststo, title(dyad-year FE): xtlogit talks L3.lbest_est /*
*/ L3.lwma_distance_mean cL3lbest_estcL3lwma_distance_m /*
*/ L3.lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ , fe

esttab, star(† 0.1 * 0.05 ** 0.01) se label
esttab using __table2_het_c.csv, star(† 0.1 * 0.05 ** 0.01) se label csv replace /*
*/ noobs scalar(sigma_u N ll) b(3) drop(gapt* lnsig2u: oL3.fact_finding /*
*/ o.stronger o.p_polity2 o.logwdi_gdpc o.mweaker o.nr_dems)/*
*/ varlabels(L3.lbest_est "casualties (log) t-3" /*
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
*/ nodepvar mtitl  nonotes /*
*/ addnotes("(cluster) robust standard errors in parentheses, † p < 0.1, * p < 0.05, ** p < 0.01" /*
*/ "all models include polynomials of time since last event (coefficients not reported")
esttab using __table2_het_c.tex, star(\dagger 0.1 * 0.05 ** 0.01) se label replace /*
*/ noobs scalar(sigma_u N ll) b(3) drop(gapt* lnsig2u: oL3.fact_finding /*
*/ o.stronger o.p_polity2 o.logwdi_gdpc o.mweaker o.nr_dems)/*
*/ varlabels(L3.lbest_est "casualties (log) t-3" /*
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
*/ nodepvar mtitl nonotes booktabs /*
*/ addnotes("(cluster) robust standard errors in parentheses, $\dagger$ p \textless 0.1, * p \textless 0.05, ** p \textless 0.01" /*
*/ "all models include polynomials of time since last event (coefficients not reported)")




* fatal events
xtset dyad_u month

eststo clear

eststo, title(original): logit talks L3.fatal /*
*/ L3.lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3.lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)

eststo, title(RE): xtlogit talks L3.fatal /*
*/ L3.lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3.lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, re

eststo, title(dyad FE): xtlogit talks L3.fatal /*
*/ L3.lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3.lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ , fe

xtset dy month
eststo, title(dyad-year FE): xtlogit talks L3.fatal /*
*/ L3.lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3.lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous  /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ , fe

esttab, star(† 0.1 * 0.05 ** 0.01) se label
esttab using __table3_het_f.csv, star(† 0.1 * 0.05 ** 0.01) se label csv replace  /*
*/ noobs scalar(sigma_u N ll) b(3) drop(gapt* lnsig2u: oL3.fact_finding /*
*/ o.stronger o.p_polity2 o.logwdi_gdpc o.mweaker o.nr_dems)/*
*/ varlabels(L3.lbest_est "casualties (log) t-3" /*
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
*/ nodepvar mtitl  nonotes /*
*/ addnotes("(cluster) robust standard errors in parentheses, † p < 0.1, * p < 0.05, ** p < 0.01" /*
*/ "all models include polynomials of time since last event (coefficients not reported")
esttab using __table3_het_f.tex, star(\dagger 0.1 * 0.05 ** 0.01) se label replace /*
*/  noobs scalar(sigma_u N ll) b(3) drop(gapt* lnsig2u: oL3.fact_finding /*
*/ o.stronger o.p_polity2 o.logwdi_gdpc o.mweaker o.nr_dems)/*
*/ varlabels(L3.lbest_est "casualties (log) t-3" /*
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
*/ nodepvar mtitl nonotes booktabs /*
*/ addnotes("(cluster) robust standard errors in parentheses, $\dagger$ p \textless 0.1, * p \textless 0.05, ** p \textless 0.01" /*
*/ "all models include polynomials of time since last event (coefficients not reported)")

