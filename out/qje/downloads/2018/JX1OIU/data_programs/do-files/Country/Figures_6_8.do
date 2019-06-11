use "Data_programs/Data/CountryData.dta", clear


*** Figure 6

tw (scatter s_diff_trust_out_in kinship_score,mlabel(isocode)) (lfit s_diff_trust_o kinship_score, title("Kinship tightness and in-group vs. out-group trust") xtitle("Kinship tightness") xscale(range(0 1.02)) ytitle("Δ Trust [In-group vs. out-group]") ylabel(-2 -1 0 1 2) legend(off) note("") graphregion(fcolor(white) lcolor(white)))
graph export Source_files/Figs/Trust_kinship.pdf, replace



* Figure 8

pca s_diff_trust_out_in s_religion_hell s_values_uniform s_mfq_disgusting s_gps_punish_revenge
predict communal_kernel

tw (scatter communal_kernel kinship_score,mlabel(isocode)) (lfit communal_kernel kinship_score, title("Kinship tightness and morality kernel") xtitle("Kinship tightness") xscale(range(0 1.02)) ylabel(-3 -1.5 0 1.5 3) ytitle("PCA of moral variables") legend(off) note("") graphregion(fcolor(white) lcolor(white)))
graph export Source_files/Figs/Kernel_kinship.pdf, replace


