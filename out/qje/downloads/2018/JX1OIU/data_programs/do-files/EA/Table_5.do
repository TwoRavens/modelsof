use "Data_programs/Data/EA_contiguous.dta", clear

* Table 5

preserve
keep if geodist<=500

foreach i in moral_god hierabovelocal hierlocal_village have_god{
egen s_`i'=std(`i')
}

label var s_have_god "1 if society has high god [std.]"
label var s_moral_god "Belief in moralizing god [std.]"
label var s_hierabovelocal "Jurisdictional hierarchy beyond local community [std.]"
label var s_hierlocal_village "Has village-level jurisdictional hierarchy [std.]"



eststo clear
eststo: qui areg s_moral_god kinship_score small_scale,a(match) cluster(cluster)
eststo: qui areg s_moral_god kinship_score small_scale $controls_history s_have_god,a(match) cluster(cluster)
eststo: qui areg s_hierabovelocal kinship_score small_scale,a(match) cluster(cluster)
eststo: qui areg s_hierabovelocal kinship_score small_scale $controls_history ,a(match) cluster(cluster)
eststo: qui areg s_hierlocal_village kinship_score small_scale,a(match) cluster(cluster)
eststo: qui areg s_hierlocal_village kinship_score small_scale $controls_history, a(match) cluster(cluster)
esttab using Source_files/Tables/Contiguous_EA.tex, booktabs nonotes replace compress  label nomtitles indicate("Dependence on hg=small_scale" "Log [\# of years since obs.]=ln_time_obs_ea")  drop(_cons $controls_history_drop) se(2) b(a2) r2(2)  star(* 0.10 ** 0.05 *** 0.01) prehead("{\begin{tabular}{l*{6}{c}}\toprule\toprule&\multicolumn{6}{c}{\textit{Dependent variable:}}\\[.1cm] &    \multicolumn{2}{c}{Religion}&\multicolumn{4}{c}{Institutions: Jurisdictional hierarchy}\\\cmidrule(lr){2-3}\cmidrule(lr){4-7}  & \multicolumn{2}{c}{Moralizing god}&\multicolumn{2}{c}{Above local level} & \multicolumn{2}{c}{Village level}\\\cmidrule(lr){2-3}\cmidrule(lr){4-5}\cmidrule(lr){6-7}")
restore


