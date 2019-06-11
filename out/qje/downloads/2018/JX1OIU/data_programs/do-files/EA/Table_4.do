use "Data_programs/Data/EAShort.dta", clear


* Table 4
fvset base 1 isonum

eststo clear
eststo: qui bs,reps(500): reg s_diff_violence kinship_score small_scale, cluster(cluster)
eststo: qui bs,reps(500): reg s_diff_violence kinship_score small_scale $controls_history, cluster(cluster)
eststo: qui reg s_moral_god kinship_score small_scale, cluster(cluster)
eststo: qui reg s_moral_god kinship_score small_scale s_have_god $controls_history cont_*, cluster(cluster)
eststo: qui reg s_moral_god kinship_score small_scale s_have_god $controls_history i.isonum, cluster(cluster)
eststo: qui bs,reps(500): reg s_loyalty_local kinship_score small_scale, cluster(cluster)
eststo: qui bs,reps(500): reg s_loyalty_local kinship_score small_scale $controls_history, cluster(cluster)
eststo: qui reg s_sex_taboo kinship_score small_scale, cluster(cluster)
eststo: qui reg s_sex_taboo kinship_score small_scale $controls_history cont_*, cluster(cluster)
eststo: qui reg s_hierabovelocal kinship_score small_scale, cluster(cluster)
eststo: qui reg s_hierabovelocal kinship_score small_scale $controls_history cont_*, cluster(cluster)
eststo: qui reg s_hierabovelocal kinship_score small_scale $controls_history i.isonum, cluster(cluster)
eststo: qui reg s_hierlocal_village kinship_score small_scale, cluster(cluster)
eststo: qui reg s_hierlocal_village kinship_score small_scale $controls_history cont_*, cluster(cluster)
eststo: qui reg s_hierlocal_village kinship_score small_scale $controls_history i.isonum, cluster(cluster)
esttab using Source_files/Tables/Enforcement_EA.tex, booktabs nonotes replace compress  label nomtitles indicate("Dependence on hg=small_scale" "Log [\# of years since obs.]=ln_time_obs_ea" "Continent FE=*cont*" "Country FE=*isonum*")  drop(_cons $controls_history_drop) se(2) b(a2) r2(2)  star(* 0.10 ** 0.05 *** 0.01) prehead("{\begin{tabular}{l*{15}{c}}\toprule\toprule&\multicolumn{15}{c}{\textit{Dependent variable:}}\\[.1cm] &\multicolumn{2}{c}{$\Delta$ Violence}&\multicolumn{3}{c}{Religion}& \multicolumn{4}{c}{Morality}&   \multicolumn{6}{c}{Institutions: Jurisdictional hierarchy}  \\\cmidrule(lr){4-6}\cmidrule(lr){7-10}\cmidrule(lr){11-16} & \multicolumn{2}{c}{[Out- vs. in-group]} &\multicolumn{3}{c}{Moralizing god}  &\multicolumn{2}{c}{Loyalty community} &\multicolumn{2}{c}{Purity (sex taboo)} &\multicolumn{3}{c}{Above local level} &\multicolumn{3}{c}{Village level}\\\cmidrule(lr){2-3}\cmidrule(lr){4-6}\cmidrule(lr){7-8}\cmidrule(lr){9-10}\cmidrule(lr){11-13}\cmidrule(lr){14-16}")

