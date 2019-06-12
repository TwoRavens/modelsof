clear
version 14.2

** Name: Survey_Analyse_Labeling.do
** Date Created: 07/01/2017 by Christophe Misner (cmisner@povertyactionlab.org)
** Last Updated: 

* Data In: [Survey.dta]
* Data Out: [Survey.dta]

* Purpose of do-file: Labeling variables.

set more off 

* Setting file path

*global DIRECTORY "..."
global data "${DIRECTORY}/Data"

cd "${data}"

* Opening dataset

use "Survey_Analyse.dta", clear


* Labeling variables 

la var	register_any	"Register anywhere"
la var	treatment_any	"Received and treatement"
la var	treatment_canvassing	"Canvassing group (one visit)"
la var	treatment_home	"Home registration group (one visit)"
la var	treatment_double	"Double visit group"
la var	treatment_EC	"Received Early Canvassing only"
la var	treatment_LC	"Received Late Canvassing only"
la var	treatment_ER	"Received Early home Registration only"
la var	treatment_LR	"Received Late home Registration only"
la var	treatment_ECLR	"Received Early Canvassing and Late home Registration only"
la var	treatment_ERLR	"Received Early home Registration and Late home Registration only"
la var	A4_job	"Has an occupation"
la var	A4_unemployed	"Is unemployed"
la var	A4_inactive	"Is inactive"
la var	A10_nodegree	"Don't have any diploma"
la var	A10_degree_infbac	"Have a diploma inf to bac"
la var	A10_degree_bac	"Have a bac diploma no more"
la var	A10_degree_supbac	"Have a diploma sup to bac"
la var	address_householdsize	"Size of the household"
la var	A14_couple	"In couple whatever the marital status"
la var	A15_french_always	"Speak only french"
la var	A15_french_few	"Speak french sometimes"
la var	A15_french_never	"Never speak french"
la var	A17_owner	"Own his home"
la var	A17_tenant_social	"Social housing tenant"
la var	A17_tenant_private	"Private housing tenant"
la var	A18_Income_inf700	"Income inf to 700€"
la var	A18_Income_inf1100	"Income between 700€ & 1100€"
la var	A18_Income_inf1500	"Income between 1100€ & 1500€"
la var	A18_Income_sup1500	"Income sup to 1500€"
la var	A20_live_inf2	"Live here for less than 2 years"
la var	A20_live_inf5	"Live here between 2 & 5 years"
la var	A20_live_inf10	"Live here between 5 & 10 years"
la var	A20_live_sup10	"Live here for more than 10 years"
la var	F3_practice_often	"Regular religious practice"
la var	indiv_survey_age	"(Age in 2012/10)"
la var	A7_tooearly	"Leave home more than 30min before town hall open"
la var	A8_toolate	"Return home more than 30min after town hall close"
la var	indiv_survey_age2	"(indiv_survey_age)²"
la var	A14_nocouple	"Not in couple"
la var	indiv_birth_abroad	"Born abroad"
la var	A25_otherdep	"Born in another department that the one of the survey"
la var	F1_nonbeliever	"Non believer"
la var	F3_practice_rare	"Iregular religious practice"

foreach var of varlist _all {
capture confirm variable `var'_treat
if !_rc {
la var	`var'_treat	"Dummy var * any treatment"
}
capture confirm variable `var'_canv
if !_rc {
la var	`var'_canv	"Dummy var * canvassing treatment"
}
capture confirm variable `var'_home
if !_rc {
la var	`var'_home	"Dummy var * home registration treatment"
}
capture confirm variable `var'_double
if !_rc {
la var	`var'_double	"Dummy var * double visit treatment"
}
capture confirm variable `var'x99
if !_rc {
la var	`var'x99	"Don't Know"
}
capture confirm variable `var'x97
if !_rc {
la var	`var'x97	"Refuse to answer"
}
}

la var	vote_average	"Average number of vote for the four elections"
la var	vote_any	"Voted at at list one election"
la var	pol_interest	"Interested in politics"
la var	pol_interest_more	"More and more interested in politics"
la var	pol_topics_nb	"Number of political topics mentionned"
la var	pol_campain_topics_nb	"Number of political topics which marked the campain mentionned"
la var	pol_position	"Position himself politically"
la var	pol_interest_mean	"Means by treatment group"
la var	pol_interest_more_mean	"Means by treatment group"
la var	pol_interest_index	"Index of political interest (C1 & C2)"
la var	pol_topics_nb_mean	"Means by treatment group"
la var	pol_campain_topics_nb_mean	"Means by treatment group"
la var	pol_topics_nb_index	"Index of political topics mentionned (C7 & E11)"
la var	pol_position_mean	"Means by treatment group"
la var	pol_position_index	"Index of political positionnement (C8)"
la var	pol_follow_pres	"Followed presidential campain"
la var	pol_follow_leg	"Followed legislative campain"
la var	pol_tv	"Watched pol programs on tv"
la var	pol_radio	"Listened pol programs on radio"
la var	pol_newspaper	"Read pol articles in newspaper"
la var	pol_internet	"Read pol articles on internet"
la var	pol_spoke_familly	"Recently spoked about politics with familly"
la var	pol_spoke_friends	"Recently spoked about politics with friends"
la var	pol_spoke_colleagues	"Recently spoked about politics with colleagues"
la var	pol_spoke_neighboors	"Recently spoked about politics with neighboors"
la var	pol_debate	"Watched between two round debate"
la var	pol_follow_pres_mean	"Means by treatment group"
la var	pol_follow_leg_mean	"Means by treatment group"
la var	pol_tv_mean	"Means by treatment group"
la var	pol_radio_mean	"Means by treatment group"
la var	pol_newspaper_mean	"Means by treatment group"
la var	pol_internet_mean	"Means by treatment group"
la var	pol_spoke_familly_mean	"Means by treatment group"
la var	pol_spoke_friends_mean	"Means by treatment group"
la var	pol_spoke_colleagues_mean	"Means by treatment group"
la var	pol_spoke_neighboors_mean	"Means by treatment group"
la var	pol_debate_mean	"Means by treatment group"
la var	pol_follow_overall_index	"Index of overall political follow (E1 & E4)"
la var	pol_follow_media_index	"Index of media political follow (E7 & E9)"
la var	pol_follow_talk_index	"Index of talk political follow (E8)"
la var	pol_preference_pres_round1	"Has a preference for 1st round of pres elections"
la var	pol_preference_pres_round2	"Has a preference for 2nd round of pres elections"
la var	pol_preference_leg_round1	"Has a preference for 1st round of leg elections"
la var	pol_preference_leg_round2	"Has a preference for 2nd round of leg elections"
la var	pol_preference_pres_round1_mean	"Means by treatment group"
la var	pol_preference_pres_round2_mean	"Means by treatment group"
la var	pol_preference_leg_round1_mean	"Means by treatment group"
la var	pol_preference_leg_round2_mean	"Means by treatment group"
la var	pol_preference_index	"Index of political preferences based on expressions of prefs (C9)"
la var	pol_know_mayor	"Know mayor name"
la var	pol_know_party_mayor	"Know mayor pol party"
la var	pol_know_3rd_pos	"Know who was in 3rd pos at 1st round of pres election"
la var	pol_know_party_3rd_pos	"Know the party of the one who was in 3rd pos at 1st round of pres election"
la var	pol_know_president	"Know president name"
la var	pol_know_party_president	"Know president party"
la var	pol_know_premier_minister	"Know prime minister name"
la var	pol_know_party_premier	"Know prime minister party"
la var	pol_know_deputy	"Know his deputy name"
la var	pol_know_party_deputy	"Know his deputy party name"
la var	pol_know_elections_2014	"Know which elections will take place in 2014"
la var	pol_know_next_pres	"Know when will take place the next presidential elections"
la var	pol_know_mayor_mean	"Means by treatment group"
la var	pol_know_party_mayor_mean	"Means by treatment group"
la var	pol_know_3rd_pos_mean	"Means by treatment group"
la var	pol_know_party_3rd_pos_mean	"Means by treatment group"
la var	pol_know_president_mean	"Means by treatment group"
la var	pol_know_party_president_mean	"Means by treatment group"
la var	pol_know_premier_minister_mean	"Means by treatment group"
la var	pol_know_party_premier_mean	"Means by treatment group"
la var	pol_know_deputy_mean	"Means by treatment group"
la var	pol_know_party_deputy_mean	"Means by treatment group"
la var	pol_know_elections_2014_mean	"Means by treatment group"
la var	pol_know_next_pres_mean	"Means by treatment group"
la var	pol_knowledge_figures_index	"Index of knowledges about political figures (D7 & E12.a)"
la var	pol_knowledge_parties_index	"Index of knowledges about political parties (E12.b)"
la var	pol_knowledge_dates_index	"Index of knowledges about political event dates (E13 & E14)"
la var	pol_perception_impact	"Think politics have an impact on his life"
la var	pol_perception_help	"Think he have a chance to receive any help from state"
la var	pol_perception_polfig_con	"Think politicians are concerned about what he think"
la var	pol_perception_polfig_trust	"Trust politicians"
la var	pol_perception_impact_mean	"Means by treatment group"
la var	pol_perception_help_mean	"Means by treatment group"
la var	pol_perception_polfig_con_mean	"Means by treatment group"
la var	pol_perception_polfig_trust_mean	"Means by treatment group"
la var	pol_perception_impact_index	"Index of perception about political impact in their life (F4 & F5)"
la var	pol_perception_politicians_index	"Index of perception about politicians (F7 & F8)"
la var	pol_general_index	"General index with all instruments"
la var	vote_left_pres_1st	"Voted left at the first round of pres elections"
la var	vote_left_pres_2nd	"Voted left at the second round of pres elections"
la var	vote_left_leg_1st	"Voted left at the first round of leg elections"
la var	vote_left_leg_2nd	"Voted left at the second round of leg elections"
la var	left	"Consider himself on the left"

* Saving dataset

save "Survey_Analyse.dta", replace

***********************************************************************
