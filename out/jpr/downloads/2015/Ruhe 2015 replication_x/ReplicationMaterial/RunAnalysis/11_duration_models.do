** 5

*compare results when other duration models are used



*first create necessary lagged variables (st-commands do not allow lag-operator)
use "$data", clear
xtset dyad_u month
foreach var in lbest_est fatal lwma_distance_mean lwma_distance_mean2 /*
*/ cum_ldeaths bilateral_talks1 pko observer_mission  /*
*/ good_office fact_finding lwma_distance_mean_c previous {
gen L3`var'=L3.`var'
}




*compare BTSCS against Cox conditional risk set model (time since last event)


*casualties

eststo clear
eststo, title(original): logit talks L3lbest_est /*
*/ L3lwma_distance_mean cL3lbest_estcL3lwma_distance_m /*
*/ L3lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m2 /*
*/ L3cum_ldeaths L3bilateral_talks1 L3pko L3observer_mission  /*
*/ L3good_office L3lwma_distance_mean_c L3previous  /*
*/ p_polity2 logwdi_gdpc  mweak weak gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)


*to turn into duration data drop all cases of ongoing mediation
keep if L.talks!=1

*declare dataset as duration data
stset month, failure(talks) enter(time 0) 

*estimate cox model
eststo, title(Cox): stcox  L3lbest_est /*
*/ L3lwma_distance_mean cL3lbest_estcL3lwma_distance_m /*
*/ L3lwma_distance_mean2 cL3lbest_estcL3lwma_distance_m2 /*
*/ L3cum_ldeaths L3bilateral_talks1 L3pko L3observer_mission  /*
*/ L3good_office L3lwma_distance_mean_c L3previous  /*
*/ p_polity2 logwdi_gdpc  mweak weak   /*
*/ , nohr efron cluster(dyad_u) 



esttab, star(† 0.1 * 0.05 ** 0.01) se label
esttab using __table4_dura_c.csv, star(† 0.1 * 0.05 ** 0.01) se label csv replace /*
*/ scalar(ll) b(3) drop(gapt*)/*
*/ varlabels(L3lbest_est "casualties (log) t-3" /*
*/ L3lwma_distance_mean "avg. distance from capital (log of km) t-3" /*
*/ L3lwma_distance_mean2 "avg. distance from capital (log of km)^2 t-3" /*
*/ cL3lbest_estcL3lwma_distance_m "casualties*distance t-3" /*
*/ cL3lbest_estcL3lwma_distance_m2 "casualties*distance^2 t-3" /*
*/ L3fatal "no of fatal battles t-3" /*
*/ cL3fatalcL3lwma_distance_mean "fatal battles*distance t-3" /*
*/ cL3fatalcL3lwma_distance_mean2 "fatal battles*distance^2 t-3" /*
*/ L3bilateral_talks1 "bilateral talks t-3" /*
*/ L3pko "peacekeeping mission t-3" /*
*/ L3cum_ldeaths "cumulative casualties (log) t-3" /*
*/ L3observer_mission "observer mission t-3" /*
*/ L3good_office "good office t-3" /*
*/ L3previous "previous mediation t-3" /*
*/ L3lwma_distance_mean_c "avg. distance to closest city (log) t-3" /*
*/ _cons constant) /*
*/ nodepvar mtitl  nonotes /*
*/ addnotes("cluster robust standard errors in parentheses, † p < 0.1, * p < 0.05, ** p < 0.01" /*
*/ "original model includes polynomials of time since last event (coefficients not reported")
esttab using __table4_dura_c.tex, star(\dagger 0.1 * 0.05 ** 0.01) se label replace /*
*/ scalar(ll) b(3) drop(gapt*)/*
*/ varlabels(L3lbest_est "casualties (log) t-3" /*
*/ L3lwma_distance_mean "avg. distance from capital (log of km) t-3" /*
*/ L3lwma_distance_mean2 "avg. distance from capital (log of km)$^2$ t-3" /*
*/ cL3lbest_estcL3lwma_distance_m "casualties*distance t-3" /*
*/ cL3lbest_estcL3lwma_distance_m2 "casualties*distance$^2$ t-3" /*
*/ L3fatal "no of fatal battles t-3" /*
*/ cL3fatalcL3lwma_distance_mean "fatal battles*distance t-3" /*
*/ cL3fatalcL3lwma_distance_mean2 "fatal battles*distance$^2$ t-3" /*
*/ L3bilateral_talks1 "bilateral talks t-3" /*
*/ L3pko "peacekeeping mission t-3" /*
*/ L3cum_ldeaths "cumulative casualties (log) t-3" /*
*/ L3observer_mission "observer mission t-3" /*
*/ L3good_office "good office t-3" /*
*/ L3previous "previous mediation t-3" /*
*/ L3lwma_distance_mean_c "avg. distance to closest city (log) t-3" /*
*/ _cons constant) /*
*/ nodepvar mtitl nonotes booktabs /*
*/ addnotes("(cluster) robust standard errors in parentheses, $\dagger$ p \textless 0.1, * p \textless 0.05, ** p \textless 0.01" /*
*/ "original model includes polynomials of time since last event (coefficients not reported)")




*fatalities

*first recreate original data to run old model, then run model
use "$data", clear
xtset dyad_unique month
foreach var in lbest_est fatal lwma_distance_mean lwma_distance_mean2 /*
*/ cum_ldeaths bilateral_talks1 pko observer_mission  /*
*/ good_office fact_finding lwma_distance_mean_c previous {
gen L3`var'=L3.`var'
}


eststo clear
eststo, title(original): logit talks L3fatal /*
*/ L3lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3cum_ldeaths L3bilateral_talks1 L3pko L3observer_mission  /*
*/ L3good_office L3lwma_distance_mean_c L3previous  /*
*/ p_polity2 logwdi_gdpc  mweak weak gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)


*again turn into duration data by dropping all cases of ongoing mediation
keep if L.talks!=1

*declare dataset as duration data
stset month, failure(talks) enter(time 0) 

*estimate cox model
eststo, title(Cox): stcox L3fatal /*
*/ L3lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3cum_ldeaths L3bilateral_talks1 L3pko L3observer_mission  /*
*/ L3good_office L3lwma_distance_mean_c L3previous  /*
*/ p_polity2 logwdi_gdpc  mweak weak   /*
*/ , nohr efron cluster(dyad_u)

esttab, star(† 0.1 * 0.05 ** 0.01) se label
esttab using __table5_dura_f.csv, star(† 0.1 * 0.05 ** 0.01) se label csv replace  /*
*/ scalar(ll) b(3) drop(gapt*)/*
*/ varlabels(L3lbest_est "casualties (log) t-3" /*
*/ L3lwma_distance_mean "avg. distance from capital (log of km) t-3" /*
*/ L3lwma_distance_mean2 "avg. distance from capital (log of km)^2 t-3" /*
*/ cL3lbest_estcL3lwma_distance_m "casualties*distance t-3" /*
*/ cL3lbest_estcL3lwma_distance_m2 "casualties*distance^2 t-3" /*
*/ L3fatal "no of fatal battles t-3" /*
*/ cL3fatalcL3lwma_distance_mean "fatal battles*distance t-3" /*
*/ cL3fatalcL3lwma_distance_mean2 "fatal battles*distance^2 t-3" /*
*/ L3bilateral_talks1 "bilateral talks t-3" /*
*/ L3pko "peacekeeping mission t-3" /*
*/ L3cum_ldeaths "cumulative casualties (log) t-3" /*
*/ L3observer_mission "observer mission t-3" /*
*/ L3good_office "good office t-3" /*
*/ L3previous "previous mediation t-3" /*
*/ L3lwma_distance_mean_c "avg. distance to closest city (log) t-3" /*
*/ _cons constant) /*
*/ nodepvar mtitl  nonotes /*
*/ addnotes("cluster robust standard errors in parentheses, † p < 0.1, * p < 0.05, ** p < 0.01" /*
*/ "original model includes polynomials of time since last event (coefficients not reported")
esttab using __table5_dura_f.tex, star(\dagger 0.1 * 0.05 ** 0.01) se label replace /*
*/ scalar(ll) b(3) drop(gapt*)/*
*/ varlabels(L3lbest_est "casualties (log) t-3" /*
*/ L3lwma_distance_mean "avg. distance from capital (log of km) t-3" /*
*/ L3lwma_distance_mean2 "avg. distance from capital (log of km)$^2$ t-3" /*
*/ cL3lbest_estcL3lwma_distance_m "casualties*distance t-3" /*
*/ cL3lbest_estcL3lwma_distance_m2 "casualties*distance$^2$ t-3" /*
*/ L3fatal "no of fatal battles t-3" /*
*/ cL3fatalcL3lwma_distance_mean "fatal battles*distance t-3" /*
*/ cL3fatalcL3lwma_distance_mean2 "fatal battles*distance$^2$ t-3" /*
*/ L3bilateral_talks1 "bilateral talks t-3" /*
*/ L3pko "peacekeeping mission t-3" /*
*/ L3cum_ldeaths "cumulative casualties (log) t-3" /*
*/ L3observer_mission "observer mission t-3" /*
*/ L3good_office "good office t-3" /*
*/ L3previous "previous mediation t-3" /*
*/ L3lwma_distance_mean_c "avg. distance to closest city (log) t-3" /*
*/ _cons constant) /*
*/ nodepvar mtitl nonotes booktabs /*
*/ addnotes("cluster robust standard errors in parentheses, $\dagger$ p \textless 0.1, * p \textless 0.05, ** p \textless 0.01" /*
*/ "original model includes polynomials of time since last event (coefficients not reported")
