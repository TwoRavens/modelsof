clear
version 14.2

** Name: Registration&Turnout_ValueLabels.do
** Date Created: 07/01/2017 by Christophe Misner (cmisner@povertyactionlab.org)
** Last Updated: 

* Data In: [Registration&Turnout_Analyse.dta]
* Data Out: [Registration&Turnout_Analyse.dta]

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

use "Registration&Turnout_Analyse.dta", clear


* Labeling values

la val	register_new_city	yesno
la val	register_new_othcity	yesno
la val	register_new_unreg	yesno
la val	register_new_automatically	yesno
la val	treatment_EC	yesno
la val	treatment_LC	yesno
la val	treatment_ER	yesno
la val	treatment_LR	yesno
la val	treatment_ECLR	yesno
la val	treatment_ERLR	yesno
la val	treatment_any	yesno

la val	treatment_any_activist	yesno
la val	treatment_any_NGO	yesno
la val	treatment_any_student	yesno
la val	treatment_any_register_new	yesno
la val	treatment_EC_register_new	yesno
la val	treatment_LC_register_new	yesno
la val	treatment_ER_register_new	yesno
la val	treatment_LR_register_new	yesno
la val	treatment_ECLR_register_new	yesno
la val	treatment_ERLR_register_new	yesno
la val	vote_any	yesno
la val	treatment_any_regnew_unreg	yesno
la val	treatment_any_regnew_othcity	yesno
la val	treatment_any_regnew_city	yesno
la val	treatment_any_regnew_auto	yesno

foreach value in EC LC ER LR ECLR ERLR {
la val	treatment_`value'_regnew_unreg	yesno
la val	treatment_`value'_regnew_othcity	yesno
la val	treatment_`value'_regnew_city	yesno
la val	treatment_`value'_regnew_auto	yesno
}
/*
la val	vote_left_pres_1st	yesno
la val	vote_left_pres_2nd	yesno
la val	vote_left_leg_1st	yesno
la val	vote_left_leg_2nd	yesno
la val	left	yesno
*/
la val	indiv_birth_othercity	yesno
la val	indiv_birth_otherdepartment	yesno
la val	indiv_birth_otherregion	yesno
la val	register_new_home_novisit	yesno
la val	register_new_out_novisit	yesno
la val	register_new_home_onevisit	yesno
la val	register_new_out_onevisit	yesno
la val	register_new_home_twovisits	yesno
la val	register_new_out_twovisits	yesno
/*
la val	vote_left_pres_1st_R	yesno
la val	vote_left_pres_2nd_R	yesno
la val	vote_left_leg_1st_R	yesno
la val	vote_left_leg_2nd_R	yesno
la val	left_R	yesno
*/



* Saving dataset

save "Registration&Turnout_Analyse.dta", replace

***********************************************************************

