* Sept 22, 2012
* GTD

set matsize 240
set mem 150m
set more off

use "F:\research, journal papers\terrorism and economic sanctions, international\final submission\replication materials\data\gtd_terror.dta", clear

******** Appendix 3, Model 2
nbreg gtd_uscitizens_lead ussanc usintervene polity2 failure log_gdppc log_pop interstate postcoldwar gtd_uscitizens, nolog robust cluster(ccode) dispersion(mean)


******** Table 1, Model 4, negative binomial regression 
nbreg gtd_lead sanction polity2 failure log_gdppc log_pop /*physint*/ interstate postcoldwar gtd, nolog robust cluster(ccode) dispersion(mean)

******** Table 2, Model 4, substantive effects 
 mfx compute, at(mean sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean sanction=1 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean polity2=7.77 sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean polity2=15.3 sanction=0 interstate=0 postcoldwar=0) nose
 mfx compute, at(mean failure=2.44 sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean failure=4.21 sanction=0 interstate=0 postcoldwar=0) nose
 mfx compute, at(mean log_gdppc=9.56 sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean log_gdppc=10.70 sanction=0 interstate=0 postcoldwar=0) nose
 mfx compute, at(mean log_pop=10.55 sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean log_pop=12.04 sanction=0 interstate=0 postcoldwar=0) nose
 mfx compute, at(mean gtd=8.82 sanction=0 interstate=0 postcoldwar=0) nose 
 mfx compute, at(mean gtd=15.57 sanction=0 interstate=0 postcoldwar=0) nose

******** Table 1, Model 5, zero-inflated negative binomial regression 
zinb gtd_lead sanction polity2 failure log_gdppc log_pop interstate postcoldwar gtd, inflate(sanction polity2 failure log_gdppc log_pop interstate postcoldwar gtd) robust cluster(ccode) nolog 

******** Table 1, Model 6, conditional fixed-effects
xtnbreg gtd_lead sanction polity2 failure log_gdppc log_pop interstate postcoldwar gtd, nolog i(ccode) fe   

******** Table 3, Model 2 
drop if sanction_lead == . 
drop if trade == .
drop if gdpgrowth == .
logit sanction_lead gtd polity2 interstate trade gdpgrowth sanction, nolog robust cluster(ccode)  
predict sanction_lead_predicted
gen sanction_lead_predicted_lagged = L.sanction_lead_predicted
nbreg gtd_lead sanction_lead_predicted_lagged polity2 failure log_gdppc log_pop interstate postcoldwar gtd, nolog robust cluster(ccode) dispersion(mean)

******** Table 4, Model 3
reg gini_net_lead sanction
predict gini_predicted
gen gini_predicted_lag = L.gini_predicted
nbreg gtd_lead gini_predicted_lag polity2 failure log_gdppc log_pop interstate postcoldwar gtd, nolog robust cluster(ccode) dispersion(mean)

******** Table 4, Model 4 
reg gini_net_lead sanction polity2 log_gdppc 
predict gini_predicted2
gen gini_predicted_lag2 = L.gini_predicted2
nbreg gtd_lead gini_predicted_lag2 polity2 failure log_gdppc log_pop interstate postcoldwar gtd, nolog robust cluster(ccode) dispersion(mean)




