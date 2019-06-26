*****************************************************
* Polo, Sara and Kristian Skrede Gleditsch. 
* "Twisting Arms and Sending Messages: Terrorist Tactics
* in Civil War"
* Journal of Peace Research
*
* This script generates the results reported in the article 
* 
* June 2016
* Contact: sara.polo@rice.edu, ksg@essex.ac.uk
****************************************************

cd ".. "

use "PG_replication_final.dta", clear

* This replicates Table 4 in the paper

* Model 1
* Lag of repression, territorial control, number of rebel groups
nbreg attack troopratio_all pts_average_lag media_freedom territory1 confl_actors rgdppc_log log_pop demdum t t2 t3, cluster(dyadid)
est store model1

* Model 2
* Lag of repression, territorial control, number of rebel groups
nbreg attacksum_nomil_new troopratio_all pts_average_lag media_freedom territory1 confl_actors rgdppc_log log_pop demdum t t2 t3, cluster(dyadid)
est store model2

* Write table to html formatted file
esttab model1 model2 using tab4.html, se label star (+ 0.10 * 0.05 ** 0.01 *** 0.001) title({Empirical Results}) replace


 
* This replicates Table 5 in the paper

* Model 3 Inclusive definition 
glm hard_ksg nationalistseparatist ethnoreligious religious other_noideo regimechangenospecificideology demdum pts_average media_freedom troopratio_all rgdppc_log log_pop, family(binomial) link(logit) cluster(dyadid)
est store model3

* Model 4 (including both territorial control and rebel support)
glm hard_ksg nationalistseparatist ethnoreligious religious other_noideo regimechangenospecificideology demdum pts_average media_freedom troopratio_all rgdppc_log log_pop rebsupp territory1, family(binomial) link(logit) cluster(dyadid)
est store model4

* Model 5 Most restrictive definition
glm hard_new2 nationalistseparatist ethnoreligious religious other_noideo regimechangenospecificideology demdum pts_average media_freedom troopratio_all rgdppc_log log_pop, family(binomial) link(logit) cluster(dyadid)
est store model5

* Model 6 Rebel support and territorial control
glm hard_new2 nationalistseparatist ethnoreligious religious other_noideo regimechangenospecificideology demdum pts_average media_freedom troopratio_all rgdppc_log log_pop territory rebsupp, family(binomial) link(logit) cluster(dyadid)
est store model6

* Write table to html formatted file
esttab model3 model4 model5 model6 using tab5.html, se label star (+ 0.10 * 0.05 ** 0.01 *** 0.001) title({Empirical Results}) replace

clear
