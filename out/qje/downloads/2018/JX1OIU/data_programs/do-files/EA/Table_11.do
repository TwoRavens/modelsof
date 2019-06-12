use "Data_programs/Data/EAShort.dta", clear


* Table 11

eststo clear
eststo: qui reg s_ln_popd kinship_score, cluster(cluster)
eststo: qui reg s_ln_popd kinship_score small_scale $controls_history cont_*, cluster(cluster)
eststo: qui reg s_settlement_patterns kinship_score, cluster(cluster)
eststo: qui reg s_settlement_patterns kinship_score small_scale $controls_history cont_*, cluster(cluster)
eststo: qui reg s_size_community kinship_score, cluster(cluster)
eststo: qui reg s_size_community kinship_score small_scale $controls_history cont_*, cluster(cluster)
esttab using Source_files/Tables/Development_EA.tex, booktabs nonotes replace compress  label nomtitles indicate("Continent FE=*cont*" "Log [\# of years since obs.]=ln_time_obs_ea")  drop(_cons  $controls_history_drop) se(2) b(a2) r2(2)  star(* 0.10 ** 0.05 *** 0.01) prehead("{\begin{tabular}{l*{6}{c}}\toprule\toprule&\multicolumn{6}{c}{\textit{Dependent variable:}}\\[.1cm] &  \multicolumn{2}{c}{Log [1+ Population} &\multicolumn{2}{c}{Complexity} &\multicolumn{2}{c}{Size of}\\ &\multicolumn{2}{c}{density]} & \multicolumn{2}{c}{settlements} & \multicolumn{2}{c}{community}\\\cmidrule(lr){2-3}\cmidrule(lr){4-5}\cmidrule(lr){6-7}")

