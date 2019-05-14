clear
version 14.2

** Name: Survey_ValueLabels.do
** Date Created: 07/01/2017 by Christophe Misner (cmisner@povertyactionlab.org)
** Last Updated: 

* Data In: [Survey.dta]
* Data Out: [Survey.dta]

* Purpose of do-file: Labeling values.

/* 
Note : Label definition is on another do file "Label_define.do"
*/

set more off 


* Setting file path

* global DIRECTORY "..."
global data "${DIRECTORY}/Data"
global dofiles "${DIRECTORY}/DoFiles"

cd "${data}"


* Opening dataset

use "Survey_Analyse.dta", clear


* Labeling values

la val treatment_any yesno
la val	register_any	yesno
la val	treatment_EC	yesno
la val	treatment_LC	yesno
la val	treatment_ER	yesno
la val	treatment_LR	yesno
la val	treatment_ECLR	yesno
la val	treatment_ERLR	yesno
la val	A4_job	yesno
la val	A4_unemployed	yesno
la val	A4_inactive	yesno
la val	A10_nodegree	yesno
la val	A10_degree_infbac	yesno
la val	A10_degree_bac	yesno
la val	A10_degree_supbac	yesno
la val	address_householdsize	yesno
la val	A14_couple	yesno
la val	A15_french_always	yesno
la val	A15_french_few	yesno
la val	A15_french_never	yesno
la val	A17_owner	yesno
la val	A17_tenant_social	yesno
la val	A17_tenant_private	yesno
la val	A18_Income_inf700	yesno
la val	A18_Income_inf1100	yesno
la val	A18_Income_inf1500	yesno
la val	A18_Income_sup1500	yesno
la val	A20_live_inf2	yesno
la val	A20_live_inf5	yesno
la val	A20_live_inf10	yesno
la val	A20_live_sup10	yesno
la val	F3_practice_often	yesno
la val	A7_tooearly	yesno
la val	A8_toolate	yesno
la val	A14_nocouple	yesno
la val	indiv_birth_abroad	yesno
la val	A25_otherdep	yesno
la val	F1_nonbeliever	yesno
la val	F3_practice_rare	yesno
la val	vote_any	yesno
la val	pol_interest	yesno
la val	pol_interest_more	yesno
la val	pol_position	yesno
la val	pol_follow_pres	yesno
la val	pol_follow_leg	yesno
la val	pol_tv	yesno
la val	pol_radio	yesno
la val	pol_newspaper	yesno
la val	pol_internet	yesno
la val	pol_spoke_familly	yesno
la val	pol_spoke_friends	yesno
la val	pol_spoke_colleagues	yesno
la val	pol_spoke_neighboors	yesno
la val	pol_debate	yesno
la val	pol_preference_pres_round1	yesno
la val	pol_preference_pres_round2	yesno
la val	pol_preference_leg_round1	yesno
la val	pol_preference_leg_round2	yesno
la val	pol_know_mayor	yesno
la val	pol_know_party_mayor	yesno
la val	pol_know_3rd_pos	yesno
la val	pol_know_party_3rd_pos	yesno
la val	pol_know_president	yesno
la val	pol_know_party_president	yesno
la val	pol_know_premier_minister	yesno
la val	pol_know_party_premier	yesno
la val	pol_know_deputy	yesno
la val	pol_know_party_deputy	yesno
la val	pol_know_elections_2014	yesno
la val	pol_know_next_pres	yesno
la val	pol_perception_impact	yesno
la val	pol_perception_help	yesno
la val	pol_perception_polfig_con	yesno
la val	pol_perception_polfig_trust	yesno
la val	vote_left_pres_1st	yesno
la val	vote_left_pres_2nd	yesno
la val	vote_left_leg_1st	yesno
la val	vote_left_leg_2nd	yesno
la val	left	yesno


* Saving dataset

save "Survey_Analyse.dta", replace

***********************************************************************
