*use hultman_ii.dta
sort id_act_period yeartsset id_act_period year

*RECODE VARIABLES
*democracy variablesgen poly_index_lag = poly_index[_n-1]replace poly_index_lag = . if id_act_period!= id_act_period[_n-1]gen poly_index_sq= poly_index* poly_indexgen poly_index_lag_sq=poly_index_lag*poly_index_laggen poly_demo = (poly_comp>30 & poly_part>10) if poly_comp<. & poly_part<.gen poly_demo_lag = poly_demo[_n-1]replace poly_demo_lag = . if id_act_period!= id_act_period[_n-1]gen polity_lag = polity2[_n-1]replace polity_lag = . if id_act_period!= id_act_period[_n-1]gen polity_sq= polity2*polity2gen polity_sq_lag= polity_lag*polity_lagrecode polity2 (6/max=1) (nonmissing=0), gen (polity_demo)gen polity_demo_lag = polity_demo[_n-1]replace polity_demo_lag = . if id_act_period!= id_act_period[_n-1]recode polity2 (-5/5=1) (nonmissing=0), gen (polity_anoc)gen polity_anoc_lag = polity_anoc[_n-1]replace polity_anoc_lag = . if id_act_period!= id_act_period[_n-1]

recode polity2 (3/max=1) (nonmissing=0), gen (polity_demox)gen polity_demox_lag = polity_demox[_n-1]replace polity_demox_lag = . if id_act_period!= id_act_period[_n-1]

*conflict variables

*decay function (using the btscs tool)btscs osv_reb year id_act_period, g(noosvreb) nspl(3)replace noosvreb=999 if id_act_period!= id_act_period[_n-1] & osv_reb==0by id_act_period: replace noosvreb=999 if noosvreb[_n-1]==999 & osv_reb[_n-1]==0generate osvreb_decay= 2^(-noosvreb/3)

gen osv_reb_lag = osv_reb[_n-1]replace osv_reb_lag = . if id_act_period!= id_act_period[_n-1]gen osv_gov1= osv_gov+1gen osv_govln=ln(osv_gov1)gen osv_govln_lag = osv_govln[_n-1]replace osv_govln_lag = . if id_act_period!= id_act_period[_n-1]gen bd1=bdbest+1gen bdln=ln(bd1)gen bdln_lag = bdln[_n-1]replace bdln_lag = . if id_act_period!= id_act_period[_n-1]gen rebsize1000=rebel_troops/1000gen army1000=govt_troops/1000*other control variablesgen popln=ln(pop)gen gdpln=ln(rgdpch)gen gdpln_lag = gdpln[_n-1]replace gdpln_lag = . if id_act_period!= id_act_period[_n-1]

*RESULTS

*models 1-5

nbreg osv_reb poly_index_lag poly_index_lag_sq gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)
nbreg osv_reb polity_lag polity_sq_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)nbreg osv_reb poly_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)nbreg osv_reb polity_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)
nbreg osv_reb polity_demo_lag polity_anoc_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)

*appendix
inspect id_act if osv_reb>1inspect id_act if poly_demo==1inspect id_act if osv_reb>1 & poly_demo_lag==1list name__conflict_ actor year if osv_reb>1 & poly_demo_lag==1
*alternative specifications
nbreg osv_reb polity_demox_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)

nbreg osv_reb poly_index_lag poly_index_lag_sq gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay if cow!=100 & cow!=666 & cow!=750, nolog cluster (id_act)nbreg osv_reb polity_lag polity_sq_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay if cow!=100 & cow!=666 & cow!=750, nolog cluster (id_act)nbreg osv_reb poly_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay if cow!=100 & cow!=666 & cow!=750, nolog cluster (id_act)nbreg osv_reb polity_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay if cow!=100 & cow!=666 & cow!=750, nolog cluster (id_act)nbreg osv_reb polity_demo_lag polity_anoc_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay if cow!=100 & cow!=666 & cow!=750, nolog cluster (id_act)

nbreg osv_reb poly_index_lag poly_index_lag_sq gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (cow)
nbreg osv_reb polity_lag polity_sq_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (cow)nbreg osv_reb poly_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (cow)nbreg osv_reb polity_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (cow)nbreg osv_reb polity_demo_lag polity_anoc_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (cow)

nbreg osv_reb poly_index_lag poly_index_lag_sq gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000, nolog cluster (id_act)nbreg osv_reb poly_index_lag poly_index_lag_sq gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osv_reb_lag , nolog cluster (id_act)nbreg osv_reb polity_lag polity_sq_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000, nolog cluster (id_act)nbreg osv_reb polity_lag polity_sq_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osv_reb_lag , nolog cluster (id_act)nbreg osv_reb poly_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000, nolog cluster (id_act)nbreg osv_reb poly_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osv_reb_lag , nolog cluster (id_act)nbreg osv_reb polity_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000, nolog cluster (id_act)nbreg osv_reb polity_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osv_reb_lag , nolog cluster (id_act)nbreg osv_reb polity_demo_lag polity_anoc_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000, nolog cluster (id_act)nbreg osv_reb polity_demo_lag polity_anoc_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osv_reb_lag , nolog cluster (id_act)*post estimations (using spost)

nbreg osv_reb poly_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)listcoef poly_demo_lag, help percent
nbreg osv_reb poly_demo_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay if cow!=100 & cow!=666 & cow!=750, nolog cluster (id_act)
listcoef poly_demo_lag, help percent
nbreg osv_reb polity_demo_lag polity_anoc_lag gdpln_lag popln resource army1000 bdln_lag incomp_gov osv_govln_lag rebsize1000 osvreb_decay, nolog cluster (id_act)listcoef polity_demo_lag polity_anoc_lag, help percent
