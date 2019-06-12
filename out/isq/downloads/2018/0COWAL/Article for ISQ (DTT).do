**************************************************************************************************
*** This do file creates the replication results for 
*** Competing for Scarce Foreign Capita: Spatial Dependence in the Diffusion of Double Taxation Treaties 						 	*/
*** Fabian Barthel (LSE)																		*/
*** Eric Neumayer (LSE)																			*/
*** 																							*/
*** Published in: International Studies Quarterly, 2012															*/
**************************************************************************************************
**************************************************************************************************
/* Note: 
You have to change "local DIR" to the directory you copy the original stata files contained 	*/
/* in the zip file and then run the do file. 													*/
**************************************************************************************************

version 11.0
drop _all
clear matrix
clear mata
set mem 800m
set mat 5000

capture net install outreg2, from(http://fmwww.bc.edu/RePEc/bocode/o)			/* checks whether outreg2 is installed 		*/

***********************************************************************************
local DIR = "C:\Research\Development finance\Barthel\"  /*change relative path to the directory where the files are located */
cd "`DIR'"
***********************************************************************************

use "Article for ISQ undirected (DTT).dta", clear

stset year, id(dyadid) failure(dtt) enter (indep_new) origin(time year==1925)


**** TABLE 3: FULL SAMPLE
set more off
stcox L1_comregion_prod L1_exp_market_sim_plus L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host, nohr vce(cluster dyadid)

stcox L1_comregion_prod lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table3.xls, stats(coef tstat) replace
stcox  L1_exp_market_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table3.xls, stats(coef tstat)
stcox  L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2  prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table3.xls, stats(coef tstat) 
stcox L1_comregion_prod L1_exp_market_sim_plus lnpop_prod lngdppc_prod  L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table3.xls, stats(coef tstat)
stcox L1_comregion_prod L1_exp_prod_sim_plus lnpop_prod lngdppc_prod  L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table3.xls, stats(coef tstat)
stcox L1_exp_market_sim_plus L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table3.xls, stats(coef tstat)
stcox L1_comregion_prod L1_exp_market_sim_plus L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table3.xls, stats(coef tstat)




**** TABLE 4: ONLY OECD-nonOECD
set more off
stcox L1_comregion_prod L1_exp_market_sim_plus L1_exp_prod_sim_plus lnpop_prod   L1_ln_trade2 lngdppc_prod  prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if oecd_nonoecd==1, nohr vce(cluster dyadid)


stcox L1_comregion_prod lnpop_prod lngdppc_prod   L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample) &  oecd_nonoecd==1, nohr vce(cluster dyadid)
outreg2 using table4.xls, stats(coef tstat) replace
stcox  L1_exp_market_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample) &  oecd_nonoecd==1, nohr vce(cluster dyadid)
outreg2 using table4.xls, stats(coef tstat)
stcox  L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample) &  oecd_nonoecd==1, nohr vce(cluster dyadid)
outreg2 using table4.xls, stats(coef tstat) 



**** TABLE 4: TIME ITERACTIONS: Grambsch and Therneau test
set more off

stcox L1_comregion_prod L1_exp_market_sim_plus L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host, nohr vce(cluster dyadid)
stcox L1_comregion_prod lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*

stcox  L1_exp_market_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*

stcox  L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2  prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*

stcox L1_comregion_prod L1_exp_market_sim_plus lnpop_prod lngdppc_prod  L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*

stcox L1_comregion_prod L1_exp_prod_sim_plus lnpop_prod lngdppc_prod  L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*

stcox L1_exp_market_sim_plus L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*

stcox L1_comregion_prod L1_exp_market_sim_plus L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid) schoenfeld(sch*) scaledsch(sca*)
stphtest, detail
drop sch* sca*




**** TABLE 4: TIME ITERACTIONS
set more off
stcox L1_comregion_prod L1_exp_market_sim_plus L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host, nohr vce(cluster dyadid)

stcox L1_comregion_prod c.lntime#c.L1_comregion_prod lnpop_prod c.lntime#c.lnpop_prod lngdppc_prod c.lntime#c.lngdppc_prod L1_ln_trade2 c.lntime#c.L1_ln_trade2 prod_openness_trade  bitdummy rta c.lntime#c.rta ofc_oecd c.lntime#c.ofc_oecd dipl_repr lndistance c.lntime#c.lndistance  polconv_prod  oecd_oecd c.lntime#c.oecd_oecd oecd_nonoecd c.lntime#c.oecd_nonoecd indep_years c.lntime#c.indep_years L1_dtt_max c.lntime#c.L1_dtt_max L1_cumm_rep c.lntime#c.L1_cumm_rep L1_cumm_host c.lntime#c.L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table4a.xls, stats(coef tstat) replace
stcox  L1_exp_market_sim_plus lnpop_prod c.lntime#c.lnpop_prod lngdppc_prod c.lntime#c.lngdppc_prod L1_ln_trade2 c.lntime#c.L1_ln_trade2 prod_openness_trade  bitdummy rta c.lntime#c.rta ofc_oecd c.lntime#c.ofc_oecd dipl_repr lndistance c.lntime#c.lndistance polconv_prod  oecd_oecd c.lntime#c.oecd_oecd oecd_nonoecd c.lntime#c.oecd_nonoecd indep_years c.lntime#c.indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table4a.xls, stats(coef tstat)
stcox  L1_exp_prod_sim_plus lnpop_prod c.lntime#c.lnpop_prod lngdppc_prod c.lntime#c.lngdppc_prod L1_ln_trade2 c.lntime#c.L1_ln_trade2 prod_openness_trade  bitdummy rta c.lntime#c.rta ofc_oecd c.lntime#c.ofc_oecd dipl_repr lndistance c.lntime#c.lndistance polconv_prod  oecd_oecd c.lntime#c.oecd_oecd oecd_nonoecd c.lntime#c.oecd_nonoecd  indep_years c.lntime#c.indep_years L1_dtt_max L1_cumm_rep L1_cumm_host c.lntime#c.L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table4a.xls, stats(coef tstat) 



**** TABLE 5: SPECIFIC TARGET CONTAGION
use "Article for ISQ directed (DTT).dta", clear
stset year, id(dyadid) failure(dtt) enter (indep_new) origin(time year==1925)
set more off

stcox  L1_SL_sptarget_comregion L1_SL_sptarget_expmarket L1_SL_sptarget_exproduct lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host  if oecd_rep==1 & oecd_host==0, nohr vce(cluster dyadid)


stcox  L1_SL_sptarget_comregion lnpop_prod lngdppc_prod L1_ln_trade2  prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host  if oecd_rep==1 & oecd_host==0 & e(sample), nohr vce(cluster dyadid)
outreg2 using table5.xls, stats(coef tstat) replace 
stcox  L1_SL_sptarget_expmarket lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host  if oecd_rep==1 & oecd_host==0 & e(sample), nohr vce(cluster dyadid)
outreg2 using table5.xls, stats(coef tstat) 
stcox  L1_SL_sptarget_exproduct lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host  if oecd_rep==1 & oecd_host==0 & e(sample), nohr vce(cluster dyadid)
outreg2 using table5.xls, stats(coef tstat) 
stcox  L1_SL_sptarget_comregion L1_SL_sptarget_expmarket lnpop_prod lngdppc_prod L1_ln_trade2  prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host  if oecd_rep==1 & oecd_host==0 & e(sample), nohr vce(cluster dyadid)
outreg2 using table5.xls, stats(coef tstat) 
stcox  L1_SL_sptarget_comregion L1_SL_sptarget_exproduct lnpop_prod lngdppc_prod L1_ln_trade2  prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host  if oecd_rep==1 & oecd_host==0 & e(sample), nohr vce(cluster dyadid)
outreg2 using table5.xls, stats(coef tstat) 
stcox  L1_SL_sptarget_expmarket L1_SL_sptarget_exproduct lnpop_prod lngdppc_prod L1_ln_trade2  prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host  if oecd_rep==1 & oecd_host==0 & e(sample), nohr vce(cluster dyadid)
outreg2 using table5.xls, stats(coef tstat) 
stcox  L1_SL_sptarget_comregion L1_SL_sptarget_expmarket L1_SL_sptarget_exproduct lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host  if oecd_rep==1 & oecd_host==0 & e(sample), nohr vce(cluster dyadid)
outreg2 using table5.xls, stats(coef tstat) 




**** TABLE 6: INTERACTED WITH DTT_MAX
use "Article for ISQ undirected (DTT).dta", clear
stset year, id(dyadid) failure(dtt) enter (indep_new) origin(time year==1925)

set more off
stcox L1_comregion_prod L1_exp_market_sim_plus L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host, nohr vce(cluster dyadid)

stcox L1_comregion_prod c.L1_comregion_prod#c.L1_dtt_max lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table6.xls, stats(coef tstat) replace
stcox  L1_exp_market_sim_plus c.L1_exp_market_sim_plus#c.L1_dtt_max lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table6.xls, stats(coef tstat)
stcox  L1_exp_prod_sim_plus c.L1_exp_prod_sim_plus#c.L1_dtt_max lnpop_prod lngdppc_prod L1_ln_trade2  prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table6.xls, stats(coef tstat) 




**** TABLE 7: INTERACTED WITH YEARS SINCE INDEPENDENCE
set more off
stcox L1_comregion_prod L1_exp_market_sim_plus L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host, nohr vce(cluster dyadid)

stcox L1_comregion_prod c.L1_comregion_prod#c.indep_years lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table7.xls, stats(coef tstat) replace
stcox  L1_exp_market_sim_plus c.L1_exp_market_sim_pl#c.indep_years lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table7.xls, stats(coef tstat)
stcox  L1_exp_prod_sim_plus c.L1_exp_prod_sim_pl#c.indep_years lnpop_prod lngdppc_prod L1_ln_trade2  prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table7.xls, stats(coef tstat) 






**** TABLE 8: INTERACTED WITH PRODUCT OPENNESS TO TRADE
set more off
stcox L1_comregion_prod L1_exp_market_sim_plus L1_exp_prod_sim_plus lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host, nohr vce(cluster dyadid)

stcox L1_comregion_prod c.L1_comregion_prod#c.prod_openness_trade  lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table8a.xls, stats(coef tstat) replace
stcox  L1_exp_market_sim_plus c.L1_exp_market_sim_plus#c.prod_openness_trade lnpop_prod lngdppc_prod L1_ln_trade2 prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table8a.xls, stats(coef tstat)
stcox  L1_exp_prod_sim_plus c.L1_exp_prod_sim_plus#c.prod_openness_trade lnpop_prod lngdppc_prod L1_ln_trade2  prod_openness_trade  bitdummy rta  ofc_oecd dipl_repr lndistance polconv_prod  oecd_oecd oecd_nonoecd  indep_years L1_dtt_max L1_cumm_rep L1_cumm_host if e(sample), nohr vce(cluster dyadid)
outreg2 using table8a.xls, stats(coef tstat) 

  
