use "C:\greig isq replication data.dta", clear
set more off
 
label variable concentration3 "Battle dispersion (Mean distance*Inverse max dist)"
label variable mean_distance3 "Mean distance between battles"
label variable extreme_dist "Inverse of longest distance in country"
label variable decay_city "Major city distance (weighted historical avg)"
label variable decay_capitol "Capital distance (weighted historical distance)"
label variable secessionist_decaycapital "Secessionist conflict*Capital distance (weighted historical distance)"
label variable lndeaths "Total battle-deaths to date"
label variable elapsed_time "Conflict duration"
label variable deathtime "Total deaths*Conflict duration"
label variable military_reb "Military support"
label variable lag_med_count "Prior diplomatic efforts"
label variable lndeath_change "Change in battle deaths (month-to-month)"
label variable med_lastmo "Diplomatic effort last month"
label variable pop15_pct "Percentage of population w/in 15km of battle"
label variable pop15 "Population w/in 15km of battle"
label variable inv_tpop "Inverse of total population"
label variable igos "IGO memberships"
label variable democracies "Global democracies"
label variable lnarea "Geographic area (logged)"
label variable secessionist "Secessionist conflict"

label variable nearest3 "Battle dispersion (Mean nearest neighbor*Inverse max dist)"
label variable nearest_distance3 "Mean distance to nearest neighbor"

label variable avg_city "Average distance to major city in month"
label variable avg_capitol "Average distance to capitol in month"
label variable secessionist_avg_capital "Secessionist conflict*Average distance to capital" 

label variable cap_velocity_ext "Capital velocity*Inverse maximum distance"
label variable city_velocity_ext "City velocity*Inverse maximum distance"
label variable avg_cap_velocity "Capital velocity"
label variable avg_city_velocity "City velocity"
label variable x1x2 "Capital velocity*City velocity"
label variable x1x2x3 "Capital velocity*City velocity*Inverse of maximum length"
label variable agreement "Agreement reached"

*** Table 1 models
logit med_ongoing lndeaths elapsed_time deathtime decay_city pop15_pct pop15 inv_tpop decay_capitol secessionist_decaycapital secessionist concentration3 mean_distance3 extreme_dist military_reb lag_med_count lndeath_change med_lastmo igos democracies lnarea , cluster(dyadid)

logit med_ongoing lndeaths elapsed_time deathtime decay_city pop15_pct pop15 inv_tpop decay_capitol secessionist_decaycapital secessionist nearest3 nearest_distance3 extreme_dist military_reb lag_med_count lndeath_change med_lastmo lnarea igos democracies, cluster(dyadid)

logit med_ongoing lndeaths elapsed_time deathtime avg_city pop15_pct pop15 inv_tpop avg_capitol secessionist_avg_capital secessionist concentration3 mean_distance3 extreme_dist military_reb lag_med_count lndeath_change med_lastmo lnarea igos democracies, cluster(dyadid)

logit med_ongoing lndeaths elapsed_time deathtime pop15_pct pop15 inv_tpop secessionist cap_velocity_ext city_velocity_ext avg_cap_velocity avg_city_velocity x1x2 x1x2x3 extreme_dist military_reb lag_med_count lndeath_change med_lastmo lnarea igos democracies, cluster(dyadid)


*** Table 2 models
heckprob agreement lndeaths elapsed_time deathtime decay_city pop15_pct pop15 inv_tpop decay_capitol secessionist_decaycapital secessionist concentration3 mean_distance3 extreme_dist military_reb lag_med_count lndeath_change ongoing_efforts rebel_sides, sel(med_ongoing=concentration3 mean_distance3 extreme_dist decay_city decay_capitol secessionist_decaycapital lndeaths elapsed_time deathtime military_reb lag_med_count lndeath_change med_lastmo pop15_pct pop15 inv_tpop igos democracies lnarea secessionist) cluster(dyadid)

heckprob agreement lndeaths elapsed_time deathtime pop15_pct pop15 inv_tpop secessionist cap_velocity_ext city_velocity_ext avg_cap_velocity avg_city_velocity x1x2 x1x2x3 extreme_dist military_reb lag_med_count lndeath_change ongoing_efforts rebel_sides, sel(med_ongoing=cap_velocity_ext city_velocity_ext avg_cap_velocity avg_city_velocity extreme_dist x1x2 x1x2x3 lndeaths elapsed_time deathtime military_reb lag_med_count lndeath_change med_lastmo pop15_pct pop15 inv_tpop igos democracies lnarea secessionist) cluster(dyadid)




