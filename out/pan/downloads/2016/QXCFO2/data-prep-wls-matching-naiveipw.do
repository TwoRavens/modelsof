*********************************************
*GLOBAL MACROS
*********************************************

* cd "/scratch/cds2083"
cd "~/Dropbox (Samii-research)/COLOMBIA_PRIVATE/WRITING/Machine_Learning/aaaa-submitted/replication-archive/to-post/starting-data"

set more off 
 
use "COLOMBIA_STEP8_Regressions_REDO.dta", clear

capture mi unset
mi import flong, m(m_impute) id(ID_num) clear
mi svyset svypsu [pweight=wgt_main], strata(svystrat)

*********************************************
* Define intervention variables
********************************************* 

* Economic 
	g int_emp = p136_emp_REC3

* Security 
	replace p145_atrisk_REC2 = 0 if p145_atrisk_REC1b==1
	replace p145_atrisk_REC2 = 0 if p145_atrisk_REC1b==2
	replace p145_atrisk_REC2 = 1 if p145_atrisk_REC1b==3
	replace p145_atrisk_REC2 = 1 if p145_atrisk_REC1b==4
	g int_secure = 1 - p145_atrisk_REC2

* Credible Commitment
	g int_confident = .
	replace int_confident = 0 if p111_gov_promises_1year_REC1 <= 5 & p111_gov_promises_1year_REC1!=.  
	replace int_confident = 1 if p111_gov_promises_1year_REC1 > 5 & p111_gov_promises_1year_REC1!=.  

* Emotions
	g int_upbeat = .
	replace int_upbeat = 0 if index_reint_psych_neg >= .5723912 & index_reint_psych_neg!=.
	replace int_upbeat = 1 if index_reint_psych_neg < .5723912 & index_reint_psych_neg!=.

* Horizontal Networks (excombatant peers)
	g int_excompeers = .
	replace int_excompeers = 0 if p150_know_excom_REC1b >= 3 & p150_know_excom_REC1b!=.
	replace int_excompeers = 1 if p150_know_excom_REC1b < 3 & p150_know_excom_REC1b!=.
	
* Vertical Networks (speak to commander) 
	g int_commander = .
	replace int_commander = 0 if p66_sup1_talk_REC1 >=2 & p66_sup1_talk_REC1!=.
	replace int_commander = 1 if p66_sup1_talk_REC1 <2 & p66_sup1_talk_REC1!=.

la var int_emp "Employed"
la var int_secure "Feels secure"
la var int_confident "Confident in govt."
la var int_upbeat "Psych. upbeat"
la var int_excompeers "Less than half peers excoms."
la var int_commander "Not speaking to commander"	

encode mpio, generate(mpio_num)

*********************************************
* Cross tabulations
********************************************* 


mi estimate, post: proportion recid_scale
mi estimate, post: svy: proportion recid_scale
mi estimate, post: svy:  proportion int_emp
mi estimate, post: svy:  proportion int_secure
mi estimate, post: svy:  proportion int_confident
mi estimate, post: svy:  proportion int_upbeat
mi estimate, post: svy:  proportion int_excompeers
mi estimate, post: svy:  proportion int_commander

mi estimate, post: svy:  proportion recid_scale, over(int_emp)
mi estimate, post: svy:  proportion recid_scale, over(int_secure)
mi estimate, post: svy:  proportion recid_scale, over(int_confident)
mi estimate, post: svy:  proportion recid_scale, over(int_upbeat)
mi estimate, post: svy:  proportion recid_scale, over(int_excompeers)
mi estimate, post: svy:  proportion recid_scale, over(int_commander)

mi estimate, post: mean recid_scale
mi estimate, post: svy: mean recid_scale

mi estimate, post: svy: mean recid_scale, over(int_emp)
mi estimate, post: svy: mean recid_scale, over(int_secure)
mi estimate, post: svy: mean recid_scale, over(int_confident)
mi estimate, post: svy: mean recid_scale, over(int_upbeat)
mi estimate, post: svy: mean recid_scale, over(int_excompeers)
mi estimate, post: svy: mean recid_scale, over(int_commander)

*********************************************
* Individual-level control variable vectors
*********************************************

local controls_reint_ix index_reint_prog_dissatis index_reint_state index_reint_prog_exposure
local controls_conf_ix  index_con_time index_con_rank_mid_commander index_con_rank_top_commander index_con_role_combatant index_con_unit_cohesion index_con_unit_discipline index_con_unit_hierarchy index_con_unit_motivation 
local controls_demob_ix index_demob_coerced index_demob_type 
local controls_join_ix index_join_ed index_join_fam index_join_forced index_join_griev index_join_ideo index_join_material index_join_network index_join_psych index_join_security index_join_welfare 
local controls_gen p8_sex p11_race_REC1 p9_age p104_minor p143_disabled_REC1 p25_grp_demob_name_AUC p122_risk_all p121_time_all p19_ageenter_group1
local controls_gen_cons p8_sex p11_race_REC1 p9_age p122_risk_all p121_time_all
local controls_join p19_ageenter_group1
local controls_conf p25_grp_demob_name_AUC
local controls_demo p104_minor 
local controls_rein p143_disabled_REC1  

*********************************************
* WLS w/ municipality FE fits
********************************************* 
eststo clear
eststo: mi estimate, post: areg recid_scale int_upbeat                                                               `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' [pweight=wgt_main],  absorb(mpio) cluster(svypsu)
eststo: mi estimate, post: areg recid_scale            int_emp                                                       `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' [pweight=wgt_main],  absorb(mpio) cluster(svypsu)
eststo: mi estimate, post: areg recid_scale                    int_secure                                            `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' [pweight=wgt_main],  absorb(mpio) cluster(svypsu)
eststo: mi estimate, post: areg recid_scale                               int_confident                              `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' [pweight=wgt_main],  absorb(mpio) cluster(svypsu)
eststo: mi estimate, post: areg recid_scale                                             int_excompeers               `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' [pweight=wgt_main],  absorb(mpio) cluster(svypsu)
eststo: mi estimate, post: areg recid_scale                                                            int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' [pweight=wgt_main],  absorb(mpio) cluster(svypsu)
eststo: mi estimate, post: areg recid_scale int_upbeat int_emp int_secure int_confident int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' [pweight=wgt_main],  absorb(mpio) cluster(svypsu)
esttab using "regressions_redo2.csv", replace wide keep(int_upbeat int_emp int_secure int_confident int_excompeers int_commander) b(2) se(2) star(* 0.05 ** 0.01 *** 0.001) l ti("Hypothetical interventions to reduce recidivism") addnotes("(Unadjusted two-sided p-values.)" "Weighted least squares with municipality FE and indiv. controls." "Standard errors account for municipality clustering.") page(fullpage)
eststo clear

*********************************************
* Mahalonobis distance matching estimator for the RIE
********************************************* 

capture drop match_* y0_* Dmatch_* omit_* r_omit_*

capture teffects nnmatch (recid_scale 		  int_upbeat int_secure int_confident int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_emp), atet tlevel(0) ematch(mpio_num) osample(omit_emp)
teffects nnmatch (recid_scale 		  int_upbeat int_secure int_confident int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_emp) if omit_emp==0, atet tlevel(0)  ematch(mpio_num) generate(match_emp)
predict y0_emp, po tlevel(1)
g Dmatch_emp = y0_emp - recid_scale
g r_omit_emp = 1-omit_emp
mi estimate, post: svy, subpop(r_omit_emp): mean Dmatch_emp

capture teffects nnmatch (recid_scale int_emp int_upbeat            int_confident int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_secure), atet tlevel(0) ematch(mpio_num _mi_m) osample(omit_secure) 
teffects nnmatch (recid_scale int_emp int_upbeat            int_confident int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_secure) if omit_secure==0, atet tlevel(0) ematch(mpio_num) generate(match_secure)
predict y0_secure, po tlevel(1)
g Dmatch_secure = y0_secure - recid_scale
g r_omit_secure = 1-omit_secure
mi estimate, post: svy, subpop(r_omit_secure): mean Dmatch_secure

capture teffects nnmatch (recid_scale int_emp int_upbeat int_secure               int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_confident), atet tlevel(0) ematch(mpio_num _mi_m) osample(omit_confident) 
teffects nnmatch (recid_scale int_emp int_upbeat int_secure               int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_confident) if omit_confident==0, atet tlevel(0) ematch(mpio_num) generate(match_confident) 
predict y0_confident, po tlevel(1)
g Dmatch_confident = y0_confident - recid_scale
g r_omit_confident = 1-omit_confident
mi estimate, post: svy, subpop(r_omit_confident): mean Dmatch_confident

capture teffects nnmatch (recid_scale int_emp            int_secure int_confident int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_upbeat), atet tlevel(0) ematch(mpio_num _mi_m) osample(omit_upbeat) 
teffects nnmatch (recid_scale int_emp            int_secure int_confident int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_upbeat) if omit_upbeat==0, atet tlevel(0) ematch(mpio_num) generate(match_upbeat) 
predict y0_upbeat, po tlevel(1)
g Dmatch_upbeat = y0_upbeat - recid_scale
g r_omit_upbeat = 1-omit_upbeat
mi estimate, post: svy, subpop(r_omit_upbeat): mean Dmatch_upbeat

capture teffects nnmatch (recid_scale int_emp int_upbeat int_secure int_confident                int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_excompeers), atet tlevel(0) ematch(mpio_num _mi_m) osample(omit_excompeers) 
teffects nnmatch (recid_scale int_emp int_upbeat int_secure int_confident                int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_excompeers) if omit_excompeers==0, atet tlevel(0) ematch(mpio_num _mi_m) generate(match_excompeers)  vce(iid)
predict y0_excompeers, po tlevel(1)
g Dmatch_excompeers = y0_excompeers - recid_scale
g r_omit_excompeers = 1-omit_excompeers
mi estimate, post: svy, subpop(r_omit_excompeers): mean Dmatch_excompeers

capture teffects nnmatch (recid_scale int_emp int_upbeat int_secure int_confident int_excompeers               `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_commander), atet tlevel(0) ematch(mpio_num _mi_m) osample(omit_commander) 
teffects nnmatch (recid_scale int_emp int_upbeat int_secure int_confident int_excompeers               `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein') (int_commander) if omit_commander==0, atet tlevel(0) ematch(mpio_num) generate(match_commander) 
predict y0_commander, po tlevel(1)
g Dmatch_commander = y0_commander - recid_scale
g r_omit_commander = 1-omit_commander
mi estimate, post: svy, subpop(r_omit_commander): mean Dmatch_commander

*********************************************
* Naive IPW
********************************************* 

capture drop xb_* 
capture drop phat_* 
capture drop Dnaive_* 
capture drop mpio_num

encode mpio, generate(mpio_num)

mi estimate, saving(mip_emp, replace): logit int_emp int_secure  int_confident int_upbeat int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' i.mpio_num [pweight=wgt_main]
mi predict xb_emp using mip_emp, storecompleted
g phat_emp = invlogit(xb_emp)
g Dnaive_emp = ((int_emp/phat_emp) - 1)*recid_scale
mi estimate, post: svy, subpop(r_omit_emp): mean Dnaive_emp

mi estimate, saving(mip_secure, replace): logit int_secure int_emp int_confident int_upbeat int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' i.mpio_num [pweight=wgt_main]
mi predict xb_secure using mip_secure, storecompleted
g phat_secure = invlogit(xb_secure)
g Dnaive_secure = ((int_secure/phat_secure) - 1)*recid_scale
mi estimate, post: svy, subpop(r_omit_secure): mean Dnaive_secure

mi estimate, saving(mip_confident, replace): logit int_confident int_emp int_secure int_upbeat int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' i.mpio_num [pweight=wgt_main]
mi predict xb_confident using mip_confident, storecompleted
g phat_confident = invlogit(xb_confident)
g Dnaive_confident = ((int_confident/phat_confident) - 1)*recid_scale
mi estimate, post: svy, subpop(r_omit_confident): mean Dnaive_confident

mi estimate, saving(mip_upbeat, replace): logit int_upbeat int_emp int_secure int_confident int_excompeers int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' i.mpio_num [pweight=wgt_main]
mi predict xb_upbeat using mip_upbeat, storecompleted
g phat_upbeat = invlogit(xb_upbeat)
g Dnaive_upbeat = ((int_upbeat/phat_upbeat) - 1)*recid_scale
mi estimate, post: svy, subpop(r_omit_upbeat): mean Dnaive_upbeat

mi estimate, saving(mip_excompeers, replace): logit int_excompeers  int_emp int_secure int_confident int_upbeat int_commander `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' i.mpio_num [pweight=wgt_main]
mi predict xb_excompeers using mip_excompeers, storecompleted
g phat_excompeers = invlogit(xb_excompeers)
g Dnaive_excompeers = ((int_excompeers/phat_excompeers) - 1)*recid_scale
mi estimate, post: svy, subpop(r_omit_excompeers): mean Dnaive_excompeers

mi estimate, saving(mip_commander, replace): logit int_commander int_emp int_secure int_confident int_upbeat int_excompeers `conf_ivs' `controls_reint_ix' `controls_conf_ix' `controls_demob_ix' `controls_join_ix' `controls_gen_cons' `controls_join' `controls_conf' `controls_demo' `controls_rein' i.mpio_num [pweight=wgt_main]
mi predict xb_commander using mip_commander, storecompleted
g phat_commander = invlogit(xb_commander)
g Dnaive_commander = ((int_commander/phat_commander) - 1)*recid_scale
mi estimate, post: svy, subpop(r_omit_commander): mean Dnaive_commander

saveold "COLOMBIA_STEP9_Interventions_REDO.dta", replace
