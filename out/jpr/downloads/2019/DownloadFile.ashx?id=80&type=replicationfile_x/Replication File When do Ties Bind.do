// Replication File for "When do Ties Bind? Foreign Fighters, Social Embeddedness, and Violence against Civilians"

** Main Regression Models (from Table 1) ***
use nsa_ff

** 1a:
nbreg best_fatality i.foreign_f, cluster(dyadid)

** 2a:
quietly nbreg best_fatality i.foreign_f rebstrength loot mobcap territorial islamist_nsa ///
leftist length pop_dens_ln gdp_cap_gr govtbestfatal_ln fatality_lag_ln intensity, ///
cluster(dyadid)
generate sample = e(sample)

nbreg best_fatality i.foreign_f rebstrength loot territorial islamist_nsa ///
leftist length if sample==1, cluster(dyadid) nolog

** 3a
nbreg best_fatality i.foreign_f pop_dens_ln gdp_cap_gr govtbestfatal_ln ///
fatality_lag_ln intensity if sample==1, cluster (dyadid) nolog

** 4a:
nbreg best_fatality i.foreign_f rebstrength loot territorial islamist_nsa ///
leftist length pop_dens_ln gdp_cap_gr govtbestfatal_ln fatality_lag_ln intensity if sample==1, ///
cluster(dyadid)

** Models 1b, 2b, 3b, 4b (subset of observations)
clear
use nsa_ff if foreign_f==1

** 1b
nbreg best_fatality i.b_neigh i.ff_coethnic, cluster(dyadid)

** 2b

quietly nbreg best_fatality i.b_neigh i.ff_coethnic rebstrength loot territorial islamist_nsa ///
leftist length pop_dens_ln gdp_cap_gr govtbestfatal_ln fatality_lag_ln intensity, cluster(dyadid)
generate sample= e(sample)

nbreg best_fatality i.b_neigh i.ff_coethnic rebstrength loot /// 
territorial islamist_nsa leftist length if sample==1, cluster(dyadid) nolog

** 3b

nbreg best_fatality i.b_neigh i.ff_coethnic pop_dens_ln gdp_cap_gr ///
govtbestfatal_ln fatality_lag_ln intensity if sample==1, cluster (dyadid) nolog

** 4b
nbreg best_fatality i.b_neigh i.ff_coethnic rebstrength loot territorial leftist islamist_nsa ///
length pop_dens_ln gdp_cap_gr govtbestfatal_ln fatality_lag_ln intensity, cluster(dyadid)

** Alternative Specifications (regression tables appear in Online Appendix)

clear
use nsa_ff

* Model 5a
zinb best_fatality i.foreign_f rebstrength loot territorial islamist_nsa ///
leftist length pop_dens_ln gdp_cap_gr govtbestfatal_ln fatality_lag_ln intensity, inflate(i.foreign_f ///
rebstrength loot territorial islamist_nsa leftist length pop_dens_ln gdp_cap_gr ///
govtbestfatal_ln fatality_lag_ln intensity) cluster(dyadid)

* Model 5b
clear
use nsa_ff if foreign_f==1

zinb best_fatality i.b_neigh i.ff_coethnic rebstrength loot territorial islamist_nsa ///
length pop_dens_ln gdp_cap_gr govtbestfatal_ln fatality_lag_ln intensity, inflate(i.b_neigh ///
i.ff_coethnic rebstrength loot territorial islamist_nsa length pop_dens_ln ///
gdp_cap_gr govtbestfatal_ln fatality_lag_ln intensity) cluster(dyadid)

* Model 6
nbreg best_fatality i.ff_type rebstrength loot territorial islamist_nsa ///
length pop_dens_ln gdp_cap_gr govtbestfatal_ln fatality_lag_ln intensity, vce(robust)

* Model 7
zinb best_fatality i.ff_type rebstrength loot territorial islamist_nsa ///
length pop_dens_ln gdp_cap_gr govtbestfatal_ln fatality_lag_ln intensity, inflate(i.ff_type ///
rebstrength loot territorial islamist_nsa length pop_dens_ln gdp_cap_gr ///
govtbestfatal_ln fatality_lag_ln intensity) vce(robust)

** Checks with Insurgencies grouped by Dyadid

* Models 8a-8d:
clear
use nsa_ff_crossx

* Model 8a
nbreg fatalities i.foreign_f, vce(robust)

* Model 8b
quietly nbreg fatalities i.foreign_f rebstrength loot territorial islamist ///
leftist length pop_dens_ln gdp_cap_gr gov_osv intensity, ///
vce(robust)
generate sample= e(sample)

nbreg fatalities i.foreign_f rebstrength loot territorial islamist leftist ///
length if sample==1, vce(robust)

* Model 8c
nbreg fatalities i.foreign_f pop_dens_ln gdp_cap_gr gov_osv intensity ///
if sample==1, vce(robust)

* Model 8d
nbreg fatalities i.foreign_f rebstrength loot territorial islamist ///
leftist length pop_dens_ln gdp_cap_gr gov_osv intensity, ///
vce(robust)

* Models 9a-9d:
clear
use nsa_ff_crossx if foreign_f==1

* Model 9a
nbreg fatalities i.b_neigh i.ff_coethnic, vce(robust)

* Model 9b
quietly nbreg fatalities i.b_neigh i.ff_coethnic rebstrength loot territorial islamist ///
length pop_dens_ln gdp_cap_gr gov_osv intensity, ///
vce(robust)
generate sample=e(sample)

nbreg fatalities i.b_neigh i.ff_coethnic rebstrength loot territorial islamist ///
length if sample==1, vce(robust)

* Model 9c
nbreg fatalities i.b_neigh i.ff_coethnic pop_dens_ln gdp_cap_gr gov_osv ///
intensity if sample==1, vce(robust)

* Model 9d
nbreg fatalities i.b_neigh i.ff_coethnic rebstrength loot territorial islamist ///
length pop_dens_ln gdp_cap_gr gov_osv intensity, ///
vce(robust)
