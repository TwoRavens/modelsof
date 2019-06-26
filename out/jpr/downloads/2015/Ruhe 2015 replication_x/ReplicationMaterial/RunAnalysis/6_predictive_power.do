** 9

*assess predictive power of the model

*How well does the model predict in-sample if only years 1993-2001 are used to
*estimate the model?

*load data anew
use "$data", clear
xtset dyad_u month
foreach var in lbest_est fatal lwma_distance_mean lwma_distance_mean2 /*
*/ cum_ldeaths bilateral_talks1 pko observer_mission  /*
*/ good_office fact_finding lwma_distance_mean_c previous {
gen L3`var'=L3.`var'
}


*casualties

*in-sample
logit talks L3.lbest_est /*
*/ L3.lwma_distance_mean c.L3.lbest_est#c.L3.lwma_distance_mean /*
*/ L3.lwma_distance_mean2 c.L3.lbest_est#c.L3.lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1 & year<2002, vce(cluster dyad_unique)
capture drop p_talks
predict p_talks
roctab talks p_talks if year<2002 & L.talks!=1, graph title("in-sample") ytitle("true postive rate") xtitle("false positive rate") saving(in.gph)

*How well does the model predict out-of-sample?
roctab talks p_talks if year>2001 & L.talks!=1, graph title("out-of-sample") ytitle("true postive rate") xtitle("false positive rate") saving(out.gph)

graph combine in.gph out.gph
erase in.gph
erase out.gph
graph export __graph6_ROC_c.pdf, replace
graph export __graph6_ROC_c.png, replace



*comparing against pure model 
logit talks L3.lbest_est /*
*/ L3.lwma_distance_mean c.L3.lbest_est#c.L3.lwma_distance_mean /*
*/ L3.lwma_distance_mean2 c.L3.lbest_est#c.L3.lwma_distance_mean2 L3.previous gapt* /*
*/ if L.talks!=1 & year<2002, vce(cluster dyad_unique)
capture drop p_talks
predict p_talks

roctab talks p_talks if year<2002 & L.talks!=1, graph title("in-sample") ytitle("true postive rate") xtitle("false positive rate") saving(in.gph)
roctab talks p_talks if year>2001 & L.talks!=1, graph title("out-of-sample") ytitle("true postive rate") xtitle("false positive rate") saving(out.gph)

graph combine in.gph out.gph
erase in.gph
erase out.gph
graph export __graph7_ROCcomp_c.pdf, replace
graph export __graph7_ROCcomp_c.png, replace





*fatal events

*in-sample
logit talks L3fatal /*
*/ L3lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1 & year<2002, vce(cluster dyad_unique)
capture drop p_talks
predict p_talks
roctab talks p_talks if year<2002 & L.talks!=1, graph title("in-sample") ytitle("true postive rate") xtitle("false positive rate") saving(in.gph)


*How well does the model predict out-of-sample?
roctab talks p_talks if year>2001 & L.talks!=1, graph title("out-of-sample") ytitle("true postive rate") xtitle("false positive rate") saving(out.gph)

graph combine in.gph out.gph
erase in.gph
erase out.gph
graph export __graph8_ROC_f.pdf, replace
graph export __graph8_ROC_f.png, replace



*comparing against pure model 
logit talks L3fatal /*
*/ L3lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 L3.previous gapt* /*
*/ if L.talks!=1 & year<2002, vce(cluster dyad_unique)
capture drop p_talks
predict p_talks

roctab talks p_talks if year<2002 & L.talks!=1, graph title("in-sample") ytitle("true postive rate") xtitle("false positive rate") saving(in.gph)
roctab talks p_talks if year>2001 & L.talks!=1, graph title("out-of-sample") ytitle("true postive rate") xtitle("false positive rate") saving(out.gph)

graph combine in.gph out.gph
erase in.gph
erase out.gph
graph export __graph9_ROCcomp_f.pdf, replace
graph export __graph9_ROCcomp_f.png, replace
