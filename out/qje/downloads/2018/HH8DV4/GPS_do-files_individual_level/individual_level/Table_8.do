use ../Data/Individual.dta

replace age=age/100
replace age_sqr=age^2


reg donated_money posrecip negrecip altruism trust i.ison, cluster(ison)
reg donated_money posrecip negrecip altruism trust i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)
reg volunteered_time posrecip negrecip altruism trust i.ison, cluster(ison)
reg volunteered_time posrecip negrecip altruism trust i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)
reg helped_stranger posrecip negrecip altruism trust i.ison, cluster(ison)
reg helped_stranger posrecip negrecip altruism trust i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)
reg sent_money posrecip negrecip altruism trust i.ison, cluster(ison)
reg sent_money posrecip negrecip altruism trust i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)
reg voiced_opinion posrecip negrecip altruism trust i.ison, cluster(ison)
reg voiced_opinion posrecip negrecip altruism trust i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)
reg count_on_help posrecip negrecip altruism trust i.ison, cluster(ison)
reg count_on_help posrecip negrecip altruism trust i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)
reg relationship posrecip negrecip altruism trust i.ison, cluster(ison)
reg relationship posrecip negrecip altruism trust i.id_region age age_sqr gender math ln_inc_pc rel_*, cluster(ison)








