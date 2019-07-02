*use hultman_ii.dta


*RECODE VARIABLES


recode polity2 (3/max=1) (nonmissing=0), gen (polity_demox)



*decay function (using the btscs tool)

gen osv_reb_lag = osv_reb[_n-1]

*RESULTS

*models 1-5

nbreg osv_reb poly_index_lag poly_index_lag_sq gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)
nbreg osv_reb polity_lag polity_sq_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)
nbreg osv_reb polity_demo_lag polity_anoc_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)

*appendix

*alternative specifications
nbreg osv_reb polity_demox_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)

nbreg osv_reb poly_index_lag poly_index_lag_sq gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay if cow!=100 & cow!=666 & cow!=750, nolog cluster (id_act)

nbreg osv_reb poly_index_lag poly_index_lag_sq gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (cow)
nbreg osv_reb polity_lag polity_sq_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (cow)

nbreg osv_reb poly_index_lag poly_index_lag_sq gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000, nolog cluster (id_act)

nbreg osv_reb poly_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)
nbreg osv_reb poly_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay if cow!=100 & cow!=666 & cow!=750, nolog cluster (id_act)
listcoef poly_demo_lag, help percent
nbreg osv_reb polity_demo_lag polity_anoc_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)