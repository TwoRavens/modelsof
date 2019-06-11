use "Data_programs/Data/MFQ_Ind.dta", clear



* Table 8
eststo clear
eststo: qui reg s_mfq_loyalty corigin_kinship_score dum_country* i.year $controls_ind $controls_country_migrant, cl(isocode_past)
eststo: qui reg s_mfq_rights corigin_kinship_score dum_country* i.year $controls_ind $controls_country_migrant, cl(isocode_past)
eststo: qui reg s_values_uniform corigin_kinship_score dum_country* i.year, cl(isocode_past)
eststo: qui reg s_values_uniform corigin_kinship_score dum_country* i.year $controls_ind $controls_country_migrant, cl(isocode_past)
eststo: qui reg s_mfq_disgusting corigin_kinship_score dum_country* i.year, cl(isocode_past)
eststo: qui reg s_mfq_disgusting corigin_kinship_score dum_country* i.year $controls_ind $controls_country_migrant, cl(isocode_past)
eststo: qui reg s_mfq_decency corigin_kinship_score dum_country* i.year, cl(isocode_past)
eststo: qui reg s_mfq_decency corigin_kinship_score dum_country* i.year $controls_ind $controls_country_migrant, cl(isocode_past)
esttab using Source_files/Tables/Moral_values.tex, booktabs nonotes replace compress  label nomtitles indicate("Country FE=*dum_country*" "Year FE=*year" "Individual-level controls=female" "Country of origin controls=corigin_ln_time_obs_ea")  drop(_cons $controls_ind_drop $controls_country_migrant_drop) se(2) b(a2) r2(2)  star(* 0.10 ** 0.05 *** 0.01) prehead("{\begin{tabular}{l*{8}{c}}\toprule\toprule &\multicolumn{4}{c}{Communal vs. universal values} & \multicolumn{4}{c}{Disgust}\\\cmidrule(lr){2-5}\cmidrule(lr){6-9}\\ &\multicolumn{8}{c}{\textit{Dependent variable:}}\\[.1cm] & \multicolumn{8}{c}{Moral relevance of:}\\\cmidrule(lr){2-9} &\multicolumn{1}{c}{Loyalty}& \multicolumn{1}{c}{Rights} &\multicolumn{2}{c}{$\Delta$ [Comm. -- universal]} &\multicolumn{2}{c}{Disgust} & \multicolumn{2}{c}{Purity}\\\cmidrule(lr){2-2}\cmidrule(lr){3-3}\cmidrule(lr){4-5}\cmidrule(lr){6-7}\cmidrule(lr){8-9}")




