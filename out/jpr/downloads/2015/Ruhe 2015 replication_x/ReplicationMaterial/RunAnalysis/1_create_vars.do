** 1

*create variables necessary for analysis


*combine information on mediation in a single variable
gen talks=indirect_talks1 +direct_talks1 +unclear_talks1 
replace talks=(talks>0)
gen talks_gov=talks
replace talks_gov=0 if incomp_gov==0
gen talks_terr=talks
replace talks_terr=0 if incomp_terr==0

*generate distance to cities variable
gen distance_mean_c=distance_mean_c1
forvalues i=2/6 {
replace distance_mean_c=distance_mean_c`i' if distance_mean_c`i'<distance_mean_c
}

*replace missing distance information due to no events with zero
by dyad_u: gen n=_n
replace distance_mean=0 if distance_mean==. & n==1
replace distance_mean_c=0 if distance_mean_c==. & n==1
replace distance_mean=L.distance_mean if distance_mean==.
replace distance_mean_c=L.distance_mean_c if distance_mean_c==.
*some conflicts were interrupted and therefore lags don't work
replace distance_mean=distance_mean[_n-1] if distance_mean==.
replace distance_mean_c=distance_mean_c[_n-1] if distance_mean_c==.

*replace distance as weighed moving average of distance over half a year
gen wma_distance_mean = (distance_mean/2^0 + L1.distance_mean/2^1 + L2.distance_mean/2^2 /*
*/ + L3.distance_mean/2^3 + L4.distance_mean/2^4 + L5.distance_mean/2^5)/ /*
*/ (1/2^0 + 1/2^1 + 1/2^2 + 1/2^3 + 1/2^4 + 1/2^5)
gen wma_distance_mean_c = (distance_mean_c/2^0 + L1.distance_mean_c/2^1 + L2.distance_mean_c/2^2 /*
*/ + L3.distance_mean_c/2^3 + L4.distance_mean_c/2^4 + L5.distance_mean_c/2^5)/ /*
*/ (1/2^0 + 1/2^1 + 1/2^2 + 1/2^3 + 1/2^4 + 1/2^5)

*generate log-transformed versions of variables
foreach var of varlist best_est fatal deaths_a deaths_b wma_distance_mean wma_distance_mean_c {
gen l`var'= log(`var')
replace l`var'=0 if l`var'==.
}

*generated squared/cubed log distance variable
replace lwma_distance_mean=0 if lwma_distance_mean<0
gen lwma_distance_mean2=lwma_distance_mean^2
gen lwma_distance_mean3=lwma_distance_mean^3
replace lwma_distance_mean_c=0 if lwma_distance_mean_c<0
gen lwma_distance_mean_c2=lwma_distance_mean_c^2

*generate step variable indicating previous mediation
by dyad_u: gen previous = talks[_n-1]
by dyad_u: replace previous = previous[_n-1] if previous[_n-1]==1

*generate step variable indicating previous bilateral talks
by dyad_u: gen previous_bilateral = bilateral_talks1[_n-1]
by dyad_u: replace previous_bilateral = previous_bilateral[_n-1] if previous_bilateral[_n-1]==1

*calculate cumulative deaths
by dyad_unique: gen cum_deaths=sum(best_est)
gen cum_ldeaths = log(cum_deaths)
replace cum_ld = 0 if cum_ld==.

*generate territorial conflict indicator
gen territorial = (incomp==1)

*gen time since last month with mediation variables
btscs talks month dyad_unique, generate(gapt) failure
gen gapt2=gapt^2
gen gapt3=gapt^3

*gen time since start of conflict variables
by dyad_u: gen t=_n
gen t2=t^2
gen t3=t^3
gen t4=t^4

*generating interaction variables necessary for esttab command
gen cL3fatalcL3lwma_distance_mean=c.L3.fatal#c.L3.lwma_distance_mean
gen cL3fatalcL3lwma_distance_mean2=c.L3.fatal#c.L3.lwma_distance_mean2
gen cL3fatalcL3lwma_distance_mean3=c.L3.fatal#c.L3.lwma_distance_mean3
gen cL3lbest_estcL3lwma_distance_m=c.L3.lbest_est#c.L3.lwma_distance_mean
gen cL3lbest_estcL3lwma_distance_m2=c.L3.lbest_est#c.L3.lwma_distance_mean2
gen cL3lbest_estcL3lwma_distance_m3=c.L3.lbest_est#c.L3.lwma_distance_mean3

*take natural log of GDP p.c. variable
gen logwdi_gdpc=log(wdi_gdpc)


*generate support indicators
gen gsupport=(govsupport=="explicit")
gen rsupport=(rebelsupport=="explicit")

*generate relative strength indicators
gen weaker=(rebstrength=="weaker")
gen mweaker=(rebstrength=="much weaker")
gen stronger=(rebstrength=="stronger")



*label variables
label var talks mediation
label var previous "previous mediation"
label var bilateral_talks1 "bilateral talks"
label var best_est casualties
label var fatal "no of fatal battles"
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


keep dyad_u-reg_id talks lbest_est fatal lwma_distance_mean /*
*/ lwma_distance_mean* cum_ld bilateral_talks1 pko observer_mission /*
*/ good_office fact_finding previous lwma_distance_mean_c /*
*/ p_polity2 logwdi_gdpc nr_dems mweaker weaker strong gapt* /*
*/ t-cL3lbest_estcL3lwma_distance_m3 wma_distance* indirect_talks1 /*
*/ direct_talks1 unclear_talks1 best_est distance_mean deaths_* lfatal /*
*/ cum_d ldeaths* territorial


*table with descriptive statistics
eststo clear
estpost summarize talks lbest_est fatal lwma_distance_mean /*
*/ lwma_distance_mean2 cum_ld bilateral_talks1 pko observer_mission /*
*/ good_office fact_finding previous lwma_distance_mean_c /*
*/ p_polity2 logwdi_gdpc nr_dems mweaker weaker strong, listwise

esttab, cells("mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))")  /*
*/ nomtitle nonumber label 
esttab using __table0_descr.csv, cells("mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))")  /*
*/ nomtitle nonumber label csv replace
esttab using __table0_descr.tex, cells("mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))")  /*
*/ nomtitle nonumber label booktabs replace /*
*/ varlabels( /*
*/ lwma_distance_mean "avg. distance to capital (log)" /*
*/ lwma_distance_mean2 "avg. distance to capital (log)$^2$" /*
*/ lwma_distance_mean_c "avg. distance to closest city (log)" /*
*/ _cons "constant") 




