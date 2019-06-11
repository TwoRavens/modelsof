use "Data_programs/Data/CountryData.dta", clear


* Table 6

eststo clear
eststo: qui reg s_diff_trust_out_in kinship_score, ro
eststo: qui reg s_diff_trust_out_in kinship_score cont_* $controls_country, ro
eststo: qui reg s_diff_trust_family kinship_score, ro
eststo: qui reg s_diff_trust_family kinship_score cont_* $controls_country, ro

preserve
use "Data_programs/Data/WVS_EA_Ind.dta", clear
eststo: qui reg s_diff_trust_out_in kinship_score dum_country* i.wave, cl(group)
eststo: qui reg s_diff_trust_out_in kinship_score dum_country* i.wave $controls_ind $controls_ethnic, cl(group)
eststo: qui reg s_diff_trust_family kinship_score dum_country* i.wave, cl(group)
eststo: qui reg s_diff_trust_family kinship_score dum_country* i.wave $controls_ind $controls_ethnic, cl(group)

esttab using Source_files/Tables/Trust.tex, booktabs nonotes replace compress  label nomtitles indicate("Country-level controls=ln_time_obs_ea" "Continent FE=*cont*" "Country FE=*dum_*" "Wave FE=*wave*" "Individual-level controls=female" "Ethnicity-level controls=ln_time_obs_ea_e")  drop(_cons $controls_country_drop $controls_ind_drop $controls_ethnic_drop) se(2) b(a2) r2(2)  star(* 0.10 ** 0.05 *** 0.01) prehead("{\begin{tabular}{l*{8}{c}}\toprule\toprule Variation is across:& \multicolumn{4}{c}{Countries} &\multicolumn{4}{c}{Ethnic groups (WVS)}\\\cmidrule(lr){2-5}\cmidrule(lr){6-9}\\ &\multicolumn{8}{c}{\textit{Dependent variable:}}\\ &\multicolumn{8}{c}{$\Delta$ Trust in:}\\\cmidrule(lr){2-9} &\multicolumn{2}{c}{In- vs. out-group} &\multicolumn{2}{c}{Family vs. others} &\multicolumn{2}{c}{In- vs. out-group} &\multicolumn{2}{c}{Family vs. others}   \\\cmidrule(lr){2-3}\cmidrule(lr){4-5}\cmidrule(lr){6-7}\cmidrule(lr){8-9}")
restore





* Table 7

eststo clear
eststo: qui reg s_religion_hell kinship_score, ro
eststo: qui reg s_religion_hell kinship_score s_religion_god, ro
eststo: qui reg s_religion_hell kinship_score $controls_country s_religion_god, ro
eststo: qui reg s_religion_hell kinship_score cont_* $controls_country s_religion_god, ro

preserve
use "Data_programs/Data/WVS_EA_Ind.dta", clear
eststo: qui reg s_religion_hell kinship_score dum_country* i.wave, cl(group)
eststo: qui reg s_religion_hell kinship_score dum_country* i.wave s_religion_god, cl(group)
eststo: qui reg s_religion_hell kinship_score dum_country* i.wave $controls_ind s_religion_god, cl(group)
eststo: qui reg s_religion_hell kinship_score dum_country* i.wave $controls_ind $controls_ethnic s_religion_god, cl(group)

esttab using Source_files/Tables/Religion.tex, booktabs nonotes replace compress  label nomtitles indicate("Country-level controls=ln_time_obs_ea" "Continent FE=*cont*" "Country FE=*dum_*" "Wave FE=*wave*" "Individual-level controls=female" "Ethnicity-level controls=ln_time_obs_ea_e")  drop(_cons $controls_country_drop $controls_ind_drop $controls_ethnic_drop) se(2) b(a2) r2(2)  star(* 0.10 ** 0.05 *** 0.01) prehead("{\begin{tabular}{l*{8}{c}}\toprule\toprule Variation is across:& \multicolumn{4}{c}{Countries} &\multicolumn{4}{c}{Ethnic groups (WVS)}\\\cmidrule(lr){2-5}\cmidrule(lr){6-9}\\ &\multicolumn{8}{c}{\textit{Dependent variable:}}\\ &\multicolumn{8}{c}{Belief in hell}\\\cmidrule(lr){2-9}")
restore




* Table 9

eststo clear
preserve
use "Data_programs/Data/ISEAR_Ind.dta", clear
eststo: qui reg s_disgust kinship_score, cluster(isocode)
eststo: qui reg s_disgust kinship_score $controls_ind, cluster(isocode)
eststo: qui reg s_disgust kinship_score $controls_ind $controls_country, cluster(isocode)
eststo: qui reg s_diff_shame_guilt_overall kinship_score, cluster(isocode)
eststo: qui reg s_diff_shame_guilt_overall kinship_score $controls_ind, cluster(isocode)
eststo: qui reg s_diff_shame_guilt_overall kinship_score $controls_ind $controls_country, cluster(isocode)
restore
preserve
use "Data_programs/Data/GTrends.dta", clear
eststo: qui reg s_diff_shame_guilt kinship_score i.lang, cl(isocode)
eststo: qui reg s_diff_shame_guilt kinship_score i.lang $controls_country, cl(isocode)
restore
esttab using Source_files/Tables/Shame.tex, booktabs nonotes replace compress  label nomtitles rename() indicate("Individual-level controls=female" "Country-level controls=ln_time_obs_ea" "Language FE=*lang*")  drop(_cons $controls_ind_drop $controls_country_drop) se(2) b(a2) r2(2)  star(* 0.10 ** 0.05 *** 0.01) prehead("{\begin{tabular}{l*{8}{c}}\toprule\toprule&\multicolumn{8}{c}{\textit{Dependent variable:}}\\[.1cm] & \multicolumn{3}{c}{Disgust} &\multicolumn{5}{c}{$\Delta$ [Shame -- guilt]}\\\cmidrule(lr){2-4}\cmidrule(lr){5-9} &\multicolumn{3}{c}{ISEAR (self-reports)} &\multicolumn{3}{c}{ISEAR (self-reports)} &\multicolumn{2}{c}{Google searches} \\\cmidrule(lr){2-4}\cmidrule(lr){5-7}\cmidrule(lr){8-9}")




* Table 10

* Please note that the individual-level GPS data cannot be shared because of a license agreement with Gallup that prohibits the sharing of information on country of birth
* The individual-level data on punishment can be downloaded from https://www.briq-institute.org/global-preferences/home
* These can be merged with the country of origin kinship tightness score if a Gallup World Poll license is available
* Columns (4)--(6) can then be replicated

eststo clear
eststo: qui reg s_gps_punish_revenge kinship_score, ro
eststo: qui reg s_gps_punish_revenge kinship_score $controls_country, ro
eststo: qui reg s_gps_punish_revenge kinship_score cont_* $controls_country, ro

preserve
*eststo: qui reg s_punish_revenge corigin_kinship_score dum_country*, cl(isocode_past)
*eststo: qui reg s_punish_revenge corigin_kinship_score dum_country* $controls_ind, cl(isocode_past)
*eststo: qui reg s_punish_revenge corigin_kinship_score dum_country* $controls_ind $controls_country_migrant, cl(isocode_past)

*esttab using Source_files/Tables/GPS_punish.tex, booktabs nonotes replace compress rename(kinship_score corigin_kinship_score) label nomtitles indicate("Country-level controls=ln_time_obs_ea" "Continent FE=*cont*" "Country FE=*dum_*" "Individual-level controls=female" "Country of origin controls=corigin_ln_time_obs_ea")  drop(_cons $controls_country_drop $controls_ind_drop $controls_country_migrant_drop) se(2) b(a2) r2(2)  star(* 0.10 ** 0.05 *** 0.01) prehead("{\begin{tabular}{l*{6}{c}}\toprule\toprule Variation is across:& \multicolumn{3}{c}{Countries} &\multicolumn{3}{c}{Migrants (GPS)}\\\cmidrule(lr){2-4}\cmidrule(lr){5-7}\\ &\multicolumn{6}{c}{\textit{Dependent variable:}}\\ & \multicolumn{6}{c}{$\Delta$ Willingness to punish [Revenge vs. Altruistic]}\\\cmidrule(lr){2-7}")
restore













