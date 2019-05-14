clear
version 14.2

** Name: Registration&Turnout_Analyse_Labeling.do
** Date Created: 07/01/2017 by Christophe Misner (cmisner@povertyactionlab.org)
** Last Updated: 

* Data In: [Registration&Turnout_Analyse.dta]
* Data Out: [Registration&Turnout_Analyse.dta]

* Purpose of do-file: Labeling variables.

set more off 

* Setting file path

* global DIRECTORY "..."
global data "${DIRECTORY}/Data"

cd "${data}"

* Opening dataset

use "Registration&Turnout_Analyse.dta", clear


* Labeling variables 

la var cluster "Cluster at the building level"
la var	register_new_city	"Newly registered citizens who were previously registered at another address in this city"
la var	register_new_othcity	"Newly registered citizens who were previously registered in another city"
la var	register_new_unreg	"Newly registered citizens who were previously unregistered"
la var	register_new_automatically	"Newly registered citizens who were automatically registered"
la var	treatment_earlyvisit_startdate	"Starting date of the early visit by city and polling station"
la var	treatment_latevisit_startdate	"Starting date of the late visit by city and polling station"
la var	register_new_hh	"Number of newly registered by household"
la var	address_building_rank	"Observation rank at the building level"
la var	address_household_rank	"Observation rank at the household level"
la var	vote_pres_1st_regnew_hh	"Number of newly registered votes at the 1st round of the presidential election per household"
la var	vote_pres_2nd_regnew_hh	"Number of newly registered votes at the 2nd round of the presidential election per household"
la var	vote_leg_1st_regnew_hh	"Number of newly registered votes at the 1st round of the legislative election per household"
la var	vote_leg_2nd_regnew_hh	"Number of newly registered votes at the 2nd round of the legislative election per household"
la var	vote_register1112_avrg_building	"Average participation of 2011 registered still registered in 2012 per buildings"
la var	register_1112_hh	"Number of 2011 registered still registered in 2012 per households"
la var	treatment_EC	"Received Early Canvassing only"
la var	treatment_LC	"Received Late Canvassing only"
la var	treatment_ER	"Received Early home Registration only"
la var	treatment_LR	"Received Late home Registration only"
la var	treatment_ECLR	"Received Early Canvassing and Late home Registration only"
la var	treatment_ERLR	"Received Early home Registration and Late home Registration only"
la var	treatment_any	"Received and treatement"

la var	address_hh_sample	"Number of appartments included in the sample"
la var	treatment_any_activist	"Received any treatment given by a political activist"
la var	treatment_any_NGO	"Reveived any treatment given by an NGO member"
la var	treatment_any_student	"Received any treatment given by a student"
la var	register_new_unreg_hh	"Number of newly first registered per household"
la var	register_new_othcity_hh	"Number of newly registered because recently arrived in the city per household"
la var	register_new_city_hh	"Number of newly registered because of a change in address in the same city per household"
la var	register_new_automatically_hh	"Number of newly registered because recently aged 18 years old per household"
la var	treatment_any_register_new	"Any treatment received and newly registered"
la var	treatment_EC_register_new	"Early Canvassing treatment received and newly registered"
la var	treatment_LC_register_new	"Late Canvassing treatment received and newly registered"
la var	treatment_ER_register_new	"Early home Registering treatment received and newly registered"
la var	treatment_LR_register_new	"Late home Registering treatment received and newly registered"
la var	treatment_ECLR_register_new	"Early Canvassing and Late home Registering treatment received and newly registered"
la var	treatment_ERLR_register_new	"Early and Late home Registering treatment received and newly registered"
la var	vote_average	"Average number of vote for the four elections"
la var	vote_any	"Voted at at list one election"
la var	treatment_any_regnew_unreg	"Any treatment received by newly registered citizens who were previously unregistered"
la var	treatment_any_regnew_othcity	"Any treatment received by newly registered citizens who were previously registered in another city"
la var	treatment_any_regnew_city	"Any treatment received by newly registered citizens who were previously registered at another address in this city"
la var	treatment_any_regnew_auto	"Any treatment received by newly registered citizens who were automatically registered"

foreach value in EC LC ER LR ECLR ERLR {
la var	treatment_`value'_regnew_unreg	"Treatment `value' received by newly registered citizens who were previously unregistered"
la var	treatment_`value'_regnew_othcity	"Treatment `value' received by newly registered citizens who were previously registered in another city"
la var	treatment_`value'_regnew_city	"Treatment `value' received by newly registered citizens who were previously registered at another address in this city"
la var	treatment_`value'_regnew_auto	"Treatment `value' received by newly registered citizens who were automatically registered"
}
/*
la var	vote_left_pres_1st	"(Prediction) Voted for left candidate at the first round of presidential elections"
la var	vote_left_pres_2nd	"(Prediction) Voted for left candidate at the second round of presidential elections"
la var	vote_left_leg_1st	"(Prediction) Voted for left candidate at the first round of legislative elections"
la var	vote_left_leg_2nd	"(Prediction) Voted for left candidate at the second round of legislative elections"
la var	left	"(Prediction) Position on the left"
*/
la var	indiv_birth_othercity	"Born in another city of the department"
la var	indiv_birth_otherdepartment	"Born in another department of the region"
la var	indiv_birth_otherregion	"Born in another region"
la var	indiv_age_bis "indiv_age/10"
la var	indiv_age2 "(indiv_age_bis/10)²"
la var	register_home_hh	"Number of home registrations per household"
la var	vote_regnew_average_hh	"Average number of vote for the four elections of newly registered per household"
la var	register_new_home_novisit	"Newly registered at home before the 1st visit start time"
la var	register_new_out_novisit	"Newly registered out of home before the 1st visit start time"
la var	register_new_home_novisit_hh	"Number of newly registered at home before the 1st visit start time per household"
la var	register_new_out_novisit_hh	"Number of newly registered out of home before the 1st visit start time per household"
la var	register_new_home_onevisit	"Newly registered at home after the 1st visit and before the 2nd visit start time"
la var	register_new_out_onevisit	"Newly registered out of home after the 1st visit and before the 2nd visit start time"
la var	register_new_home_onevisit_hh	"Number of newly registered at home after the 1st visit and before the 2nd visit start time per household"
la var	register_new_out_onevisit_hh	"Number of newly registered out of home after the 1st visit and before the 2nd visit start time per household"
la var	register_new_home_twovisits	"Newly registered at home"
la var	register_new_out_twovisits	"Newly registered out of home"
la var	register_new_home_twovisits_hh	"Number of newly registered at home per household"
la var	register_new_out_twovisits_hh	"Number of newly registered out of home per household"
/*
la var	vote_left_pres_1st_R	"(Prediction) Voted for left candidate at the first round of presidential elections (for robustness check)"
la var	vote_left_pres_2nd_R	"(Prediction) Voted for left candidate at the second round of presidential elections (for robustness check)"
la var	vote_left_leg_1st_R	"(Prediction) Voted for left candidate at the first round of legislative elections (for robustness check)"
la var	vote_left_leg_2nd_R	"(Prediction) Voted for left candidate at the second round of legislative elections (for robustness check)"
la var	left_R	"(Prediction) Position on the left (for robustness check)"
*/
* Saving dataset

save "Registration&Turnout_Analyse.dta", replace

***********************************************************************




