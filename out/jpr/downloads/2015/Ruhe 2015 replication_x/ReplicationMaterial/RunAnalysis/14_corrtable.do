label var previous "previous mediation"
label var bilateral_talks1 "bilateral talks"
label var best_est casualties
label var fatal_event "fatal battles"
label var distance_mean "avg. distance from capital (km)"
label var deaths_a "government fatalities"
label var deaths_b "rebel fatalities"
label var lbest_est "casualties"
label var lfatal "no of fatal battles (log)"
label var lwma_distance_mean "distance from capital"
label var lwma_distance_mean2 "avg. distance from capital (log of km)^2"
label var lwma_distance_mean_c "distance from closest city"
label var ldeaths_a "government fatalities (log)"
label var ldeaths_b "rebel fatalities (log)"
label var cum_d "cumulative casualties"
label var cum_ld "cum. casualties"
label var territorial "territorial conflict"
label var gapt "time since last event"
label var gapt2 "time since last event^2"
label var gapt3 "time since last event^3"
label var cL3fatalcL3lwma_distance_mean "fatal battles*distance t-3"
label var cL3fatalcL3lwma_distance_mean2 "fatal battles*distance^2 t-3"
label var cL3fatalcL3lwma_distance_mean3 "fatal battles*distance^3 t-3"
label var cL3lbest_estcL3lwma_distance_m "casualties*distance t-3"
label var cL3lbest_estcL3lwma_distance_m2 "casualties*distance^2 t-3"
label var cL3lbest_estcL3lwma_distance_m3 "casualties*distance^3 t-3"
label var pko "peacekeeping"
label var observer_mission "observer"
label var good_office "good office"
label var fact_finding "fact finding"
label var logwdi_gdpc "GDP p.c."
label var p_polity2 "polity score"
label var nr_dems "number of democracies"
label var mweaker "rebels much weaker"
label var weaker "weaker"
label var strong "stronger"


set scheme s1mono
corrtable lbest_est fatal_event lwma_distance_mean /*
*/ cum_ld bilateral_talks1 pko observer_mission /*
*/ good_office fact_finding previous lwma_distance_mean_c /*
*/ p_polity2 logwdi_gdpc nr_dems mweaker weaker stron, xsize(10) ysize(4) half mlabsize(20)/*
*/ rformat(%5.2f) flag1(r(rho) > 0.8) howflag1(plotregion(color(gs8))) /*
*/ flag2(inrange(abs(r(rho)), 0.6, 0.8)) howflag2(plotregion(color(gs10))) /*
*/ flag3(inrange(abs(r(rho)), 0.4, 0.6)) howflag3(plotregion(color(gs12))) /*
*/ flag4(inrange(abs(r(rho)), 0.2, 0.4)) howflag4(plotregion(color(gs14))) /*
*/ diagonal(mlabsize(20) mlabpos(3) ysc(off) xsc(off) plotregion(color(white)))
graph export __graph23_corrtable.pdf, replace
graph export __graph23_corrtable.png, replace

set scheme s1color


label var previous "previous mediation"
label var bilateral_talks1 "bilateral talks"
label var best_est casualties
label var fatal_event "no of fatal battles"
label var distance_mean "avg. distance from capital (km)"
label var deaths_a "government fatalities"
label var deaths_b "rebel fatalities"
label var lbest_est "casualties (log)"
label var lfatal "no of fatal battles (log)"
label var lwma_distance_mean "avg. distance from capital (log of km)"
label var lwma_distance_mean2 "avg. distance from capital (log of km)^2"
label var lwma_distance_mean_c "avg. distance from closest city (log of km)"
label var ldeaths_a "government fatalities (log)"
label var ldeaths_b "rebel fatalities (log)"
label var cum_d "cumulative casualties"
label var cum_ld "cumulative casualties (log)"
label var territorial "territorial conflict"
label var gapt "time since last event"
label var gapt2 "time since last event^2"
label var gapt3 "time since last event^3"
label var cL3fatalcL3lwma_distance_mean "fatal battles*distance t-3"
label var cL3fatalcL3lwma_distance_mean2 "fatal battles*distance^2 t-3"
label var cL3fatalcL3lwma_distance_mean3 "fatal battles*distance^3 t-3"
label var cL3lbest_estcL3lwma_distance_m "casualties*distance t-3"
label var cL3lbest_estcL3lwma_distance_m2 "casualties*distance^2 t-3"
label var cL3lbest_estcL3lwma_distance_m3 "casualties*distance^3 t-3"
label var pko "peacekeeping mission"
label var observer_mission "observer mission"
label var good_office "good office"
label var fact_finding "fact finding mission"
label var logwdi_gdpc "GDP p.c. (log)"
label var p_polity2 "combined polity score"
label var nr_dems "number of democracies"
label var mweaker "rebels much weaker"
label var weaker "rebels weaker"
label var strong "rebels stronger"
