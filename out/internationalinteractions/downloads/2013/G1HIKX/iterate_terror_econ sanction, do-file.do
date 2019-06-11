* Sept 22, 2012
* ITERATE

set matsize 240
set mem 150m
set more off

use "F:\research, journal papers\terrorism and economic sanctions, international\final submission\replication materials\data\iterate_terror" 

******** Appendix 1 
nbreg ld_nterror ussanc polity2 failure log_gdppc log_pop interstate postcoldwar incident_nation, nolog robust cluster(ccode) dispersion(mean)
nbreg ld_nterror unisanc polity2 failure log_gdppc log_pop interstate postcoldwar incident_nation, nolog robust cluster(ccode) dispersion(mean)
nbreg ld_nterror multisanc polity2 failure log_gdppc log_pop interstate postcoldwar incident_nation, nolog robust cluster(ccode) dispersion(mean)

******** Appendix 2
nbreg nattack_lead sanction polity2 failure log_gdppc log_pop interstate postcoldwar nattack, nolog robust cluster(ccode) dispersion(mean)
nbreg nattack_total_lead sanction polity2 failure log_gdppc log_pop interstate postcoldwar nattack_total, nolog robust cluster(ccode) dispersion(mean)

******** Appendix 3, Model 1
nbreg uscitizens_lead ussanc usintervene polity2 failure log_gdppc log_pop interstate postcoldwar uscitizens, nolog robust cluster(ccode) dispersion(mean)


******** Table 1, Model 1, negative binomial regression 
nbreg ld_nterror sanction polity2 failure log_gdppc log_pop interstate postcoldwar incident_nation, nolog robust cluster(ccode) dispersion(mean)

******** Table 2, Model 1, substantive effects 
 mfx compute, at(mean sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean sanction=1 interstate=0 postcoldwar=0) nose
 mfx compute, at(mean failure=2.44 sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean failure=4.21 sanction=0 interstate=0 postcoldwar=0) nose
 mfx compute, at(mean log_gdppc=9.56 sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean log_gdppc=10.70 sanction=0 interstate=0 postcoldwar=0) nose
 mfx compute, at(mean log_pop=10.55 sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean log_pop=12.04 sanction=0 interstate=0 postcoldwar=0) nose
 mfx compute, at(mean sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean sanction=0 interstate=0 postcoldwar=1) nose
 mfx compute, at(mean incident_nation=5.88 sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean incident_nation=10.47 sanction=0 interstate=0 postcoldwar=0) nose

******** Table 1, Model 2, zero-inflated negative binomial regression 
zinb ld_nterror sanction polity2 failure log_gdppc log_pop interstate postcoldwar incident_nation, inflate(sanction polity2 failure log_gdppc log_pop interstate postcoldwar incident_nation) robust cluster(ccode) nolog 

******** Table 1, Model 3, conditional fixed-effects
xtnbreg ld_nterror sanction polity2 failure log_gdppc log_pop interstate postcoldwar incident_nation, nolog i(ccode) fe   

******** Table 3, Model 1 
drop if sanction_lead == . 
drop if trade == .
drop if gdpgrowth == .
logit sanction_lead incident_nation polity2 interstate trade gdpgrowth sanction, nolog robust cluster(ccode)  
predict sanction_lead_predicted
gen sanction_lead_predicted_lagged = L.sanction_lead_predicted
nbreg ld_nterror sanction_lead_predicted_lagged polity2 failure log_gdppc log_pop interstate postcoldwar incident_nation, nolog robust cluster(ccode) dispersion(mean)

******** Table 4, Model 1
drop if gini_net == .
drop if gini_net_lead == .
reg gini_net_lead sanction
predict gini_predicted
gen gini_predicted_lag = L.gini_predicted
nbreg ld_nterror gini_predicted_lag polity2 failure log_gdppc log_pop interstate postcoldwar incident_nation, nolog robust cluster(ccode) dispersion(mean)

******** Table 4, Model 2 
reg gini_net_lead sanction polity2 log_gdppc 
predict gini_predicted2
gen gini_predicted_lag2 = L.gini_predicted2
nbreg ld_nterror gini_predicted_lag2 polity2 failure log_gdppc log_pop interstate postcoldwar incident_nation, nolog robust cluster(ccode) dispersion(mean)




