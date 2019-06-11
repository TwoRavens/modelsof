use "Data_programs/Data/EAShort.dta", clear


* Figs 2-3

binscatter kinship_score small_scale, title("Kinship tightness and hunter-gatherer subsistence") ytitle("Kinship tightness") yscale(range(.4 .9)) xtitle("Dependence on hunting and gathering") legend(off) note("") graphregion(fcolor(white) lcolor(white))
graph export Source_files/Figs/Hunter_kinship.pdf, replace


binscatter kinship_score s_distance_mutation, nquant(15) title("Kinship tightness and distance to origin of sickle cell") ytitle("Kinship tightness") xtitle("Shortest distance to origin of any of four sickle cell mutations") legend(off) note("") graphregion(fcolor(white) lcolor(white))
graph export Source_files/Figs/Sickle_kinship.pdf, replace


