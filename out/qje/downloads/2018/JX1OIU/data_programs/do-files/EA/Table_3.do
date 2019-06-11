use "Data_programs/Data/EAShort.dta", clear




* Table 3


eststo clear
eststo: reg kinship_score s_malariaindex,cluster(cluster)
eststo: reg kinship_score small_scale s_malariaindex,cluster(cluster)
eststo: reg kinship_score small_scale s_malariaindex cont_* $controls_history_origins, cluster(cluster)
eststo: bs,reps(500): reg kinship_score s_malariaindex if malaria_sample==1,cluster(cluster)
eststo: bs,reps(500): reg kinship_score s_malariaindex small_scale $controls_history_origins if malaria_sample==1,cluster(cluster)
eststo: bs,reps(500): reg kinship_score s_distance_mutation if malaria_sample==1,cluster(cluster)
eststo: bs,reps(500): reg kinship_score s_distance_mutation small_scale $controls_history_origins if malaria_sample==1,cluster(cluster)
eststo: bs,reps(500): reg kinship_score s_tsi if malaria_sample==1,cluster(cluster)
eststo: bs,reps(500): reg kinship_score s_tsi small_scale $controls_history_origins if malaria_sample==1,cluster(cluster)
eststo: bs,reps(500): reg kinship_score s_malariaindex s_tsi small_scale $controls_history_origins if malaria_sample==1,cluster(cluster)
eststo: bs,reps(500): reg kinship_score s_distance_mutation s_tsi small_scale $controls_history_origins if malaria_sample==1,cluster(cluster)
esttab using Source_files/Tables/Determinants_EA.tex, booktabs nonotes replace compress  label nomtitles indicate("Continent FE=*cont_*" "Log [\# of years since obs.]=ln_time_obs_ea")  drop(_cons) se(2) b(a2) r2(2)  star(* 0.10 ** 0.05 *** 0.01) prehead("{\begin{tabular}{l*{11}{c}}\toprule\toprule&\multicolumn{11}{c}{\textit{Dependent variable:}}\\[.1cm] & \multicolumn{11}{c}{Kinship tightness [0--1]}\\\cmidrule(lr){2-12} \\ &\multicolumn{3}{c}{Full sample} &\multicolumn{8}{c}{Common sample (Africa)}\\\cmidrule(lr){2-4}\cmidrule(lr){5-12}")


