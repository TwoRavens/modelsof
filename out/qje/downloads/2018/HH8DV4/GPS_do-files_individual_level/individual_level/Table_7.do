use ../Data/Individual.dta

replace age=age/100
replace age_sqr=age^2



reg save_last_year patience i.ison, cluster(ison)
reg save_last_year patience i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)
reg edu_level patience i.ison, cluster(ison)
reg edu_level patience i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)
reg own_business risktaking i.ison, cluster(ison)
reg own_business risktaking i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)
reg plan_own_business risktaking i.ison, cluster(ison)
reg plan_own_business risktaking i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)
reg smoke risktaking i.ison, cluster(ison)
reg smoke risktaking i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)

