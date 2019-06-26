** 10

*individual predicted probability graphs


*obtain dyad id's as matrix
preserve
gen some_variable=1
collapse (max) some_variable, by(dyad_u)
mkmat dyad_u, matrix(D)
restore

*calculate predicted probabilities
logit talks L3.fatal /*
*/ L3.lwma_distance_mean cL3fatalcL3lwma_distance_mean /*
*/ L3.lwma_distance_mean2 cL3fatalcL3lwma_distance_mean2 /*
*/ L3.cum_ldeaths L3.bilateral_talks1 L3.pko L3.observer_mission  /*
*/ L3.good_office L3.fact_finding L3.lwma_distance_mean_c L3.previous /*
*/ p_polity2 logwdi_gdpc nr_dems mweak weak strong gapt* /*
*/ if L.talks!=1, vce(cluster dyad_unique)
capture drop p_talks
predict p_talks

*remember working directory
local w_dir =c(pwd)

*generate graphics and save them
forvalues i = 1/62 {
preserve
insheet using cases.txt, clear
local dyad = dyad_u in `i'
local gov = location in `i'
local rebels = sideb in `i'
local start = start in `i'
local end = end in `i'
local incomp = incomp2 in `i'
restore
*change working directory to store graphs
cd "_predictedProbTS"
capture erase "`dyad'.gph"
twoway (connected p_talks month if e(sample), msize(.9) color(red) ylab(0(.1)1)) /*
*/ (spike indirect_talks1 month if e(sample), color(gs13))  /*
*/ (spike unclear_talks1 month if e(sample), color(gs9))  /*
*/ (spike direct_talks1 month if e(sample), color(black))  /*
*/ if dyad_u==`dyad', legend(label(1 "model prediction")  /*
*/ label(2 "indirect talks") label(3 "unclear talks")  /*
*/ label(4 "direct talks")) ylab(0(.2)1) ytitle(Pr(talks)) /*
*/ t1title("Gov. of `gov' vs. `rebels'") /*
*/ note("dyad ID: `dyad';" /*
*/ "observed from `start' to `end'; incompatibility concerning `incomp'") /*
*/ saving("`dyad'.gph") 
graph export "`dyad'.pdf", replace
graph export "`dyad'.png", replace
*reset working directory
cd "`w_dir'"
}

cd "`w_dir'"
