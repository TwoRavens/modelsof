clear
version 14.2
set more off
set mem 4g

** Name: Analyse.do
** Date Created: 06/19/2017 by Christophe Misner (cmisner@povertyactionlab.org)
** Last Updated: 

* Data In: [Registration&Turnout_Analyse.dta & Survey_Analyse.dta]
* Data Out: [Nothing]

* Purpose of do-file: Generating tables
* Part I : Paper tables - Outputs presented in the main paper
* Part II : Appendix tables - Outputs presented in the appendix

* Setting file path

* global DIRECTORY "..."
global data "${DIRECTORY}/Data"
global dofiles "${DIRECTORY}/DoFiles"
global appendix "${DIRECTORY}/Results/Appendix"
global paper "${DIRECTORY}/Results/Paper"

* Setting up the strata & individual controls
global controlsstrate = "st10 - st99"
global controlsind = "A1_gender indiv_survey_age indiv_survey_age2 A4_unemployed A4_inactive A10_degree_infbac A10_degree_bac A10_degree_supbac address_householdsize A14_couple A15_french_few A15_french_never A17_tenant_social A17_tenant_private A18_Income_inf1100 A18_Income_inf1500 A18_Income_sup1500 A20_live_inf5 A20_live_inf10 A20_live_sup10 A24a_birthcountry"

* Setting path directory
cd "${data}"

* Some Descriptive statistics *

* Sample size
use "Registration&Turnout_Analyse.dta", clear
* Number of buildings
count if sample_address == 1 & address_building_rank == 1

* Number of appartments
count if address_household_rank == 1 & sample_household == 1

* Number of participation datas
count if sample_address == 1 & vote_pres_1st ~= .
count if sample_address == 1 & vote_pres_2nd ~= .
count if sample_address == 1 & vote_leg_1st ~= .
count if sample_address == 1 & vote_leg_2nd ~= .

* Share of the sample in the cities of the post electoral survey
count if register_2012 == 1 & sample_address == 1
count if register_2012 == 1 & sample_address == 1 & (address_city == "Montpellier" | address_city == "Cergy" | address_city == "SaintDenis" | address_city == "Sevran")

********************
* I - Paper tables *
********************

* TABLE 1 & FIGURE 2 *

use "Registration&Turnout_Analyse.dta", clear

*Impact on the number of registrations
su register_new_hh if treatment_groups == "Control" & address_household_rank == 1 & sample_household == 1 
local mean_control=r(mean)

ivreg2 register_new_hh treatment_any ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
quietly outreg2 using "$paper\Table1_ImpactRegistration.xls", nonote se replace nolabel addstat("control mean", `mean_control') adec(3) bdec(3)

ivreg2 register_new_hh treatment_any address_newnames address_totalmailbox ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
quietly outreg2 using "$paper\Table1_ImpactRegistration.xls", nonote se append nolabel addstat("control mean", `mean_control') adec(3) bdec(3)

ivreg2 register_new_hh treatment_EC treatment_LC treatment_ER treatment_LR treatment_ECLR treatment_ERLR ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
estimates store temp_store1
quietly outreg2 using "$paper\Table1_ImpactRegistration.xls", nonote se append nolabel addstat("control mean", `mean_control') adec(3) bdec(3)

ivreg2 register_new_hh treatment_EC treatment_LC treatment_ER treatment_LR treatment_ECLR treatment_ERLR address_newnames address_totalmailbox ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
mat coef=e(b)
estimates store temp_store2
quietly outreg2 using "$paper\Table1_ImpactRegistration.xls", nonote se append nolabel addstat("control mean", `mean_control') adec(3) bdec(3)

local temp_meter=4
foreach z in "(treatment_EC + treatment_LC)/2" "(treatment_ER + treatment_LR)/2" "(treatment_ER + treatment_LR)/2 - (treatment_EC + treatment_LC)/2" "(treatment_LC + treatment_LR)/2 - (treatment_EC + treatment_ER)/2" {
	forvalue i=1/4 {
	if `temp_meter'==`i' {
			estimates restore temp_store1
			lincomest `z'
			estimates store temp_1`temp_meter'
}
}
			local temp_meter=`temp_meter'-1
}

estout temp_14 temp_13 temp_12 temp_11 using "$paper/Table1_LinearCombinationsOfEstimates.xls", replace cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" Number of new registrations (A&P controls: No)") mlabel("(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2" "(LC+LR)/2-(EC+ER)/2") stats(N)

local temp_meter=4
foreach z in "(treatment_EC + treatment_LC)/2" "(treatment_ER + treatment_LR)/2" "(treatment_ER + treatment_LR)/2 - (treatment_EC + treatment_LC)/2" "(treatment_LC + treatment_LR)/2 - (treatment_EC + treatment_ER)/2" {
	forvalue i=1/4 {
	if `temp_meter'==`i' {
			estimates restore temp_store2
			lincomest `z'
			estimates store temp_2`temp_meter'
}
}
			local temp_meter=`temp_meter'-1
}

estout temp_24 temp_23 temp_22 temp_21 using "$paper/Table1_LinearCombinationsOfEstimates.xls", append cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" Number of new registrations (A&P controls: Yes)") mlabel("(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2" "(LC+LR)/2-(EC+ER)/2") stats(N)

* Figure 2 creation & outsheet - It uses coefs of table 1 regressions
gen Control_Group=`mean_control'
gen treatment_EC_=coef[1,1] + Control_Group
gen treatment_LC_=coef[1,2] + Control_Group
gen treatment_ER_=coef[1,3] + Control_Group
gen treatment_LR_=coef[1,4] + Control_Group
gen treatment_ECLR_=coef[1,5] + Control_Group
gen treatment_ERLR_=coef[1,6] + Control_Group
replace Control_Group=round(Control_Group,0.01)
replace treatment_EC_=round(treatment_EC_,0.01)
replace treatment_LC_=round(treatment_LC_,0.01)
replace treatment_ER_=round(treatment_ER_,0.01)
replace treatment_LR_=round(treatment_LR_,0.01)
replace treatment_ECLR_=round(treatment_ECLR_,0.01)
replace treatment_ERLR_=round(treatment_ERLR_,0.01)

outsheet Control_Group treatment_EC_ treatment_LC_ treatment_ER_ treatment_LR_ treatment_ECLR_ treatment_ERLR_ if _n==1 using "$paper\Figure2_ImpactRegistration.xls", replace

estimates clear

* TABLE 2 & FIGURE 3 *

use "Registration&Turnout_Analyse.dta", clear

*Selection in terms of participation
keep if register_2012 == 1 & sample_address == 1

ivreg2 vote_pres_1st treatment_any_register_new register_new, cl(cluster)
mat coef=e(b)
outreg2 using "$paper\Table2_Vote_by_RegStatus&Treatment.xls", nonote se replace nolabel bdec(3)
ivreg2 vote_pres_1st treatment_EC_register_new treatment_LC_register_new treatment_ER_register_new treatment_LR_register_new treatment_ECLR_register_new treatment_ERLR_register_new register_new, cl(cluster)
quietly outreg2 using "$paper\Table2_Vote_by_RegStatus&Treatment.xls", nonote se append nolabel bdec(3)
estimates store temp_store1

* Gen var for figure 3 outsheet
gen vote_pres_1st_=coef[1,3] if _n==1
replace vote_pres_1st_=coef[1,3] + coef[1,2] if _n==2
replace vote_pres_1st_=coef[1,3] + coef[1,2] + coef[1,1] if _n==3
replace vote_pres_1st_=round(vote_pres_1st_,0.001)
replace vote_pres_1st_=vote_pres_1st_*100

gen Elect_Participation=""
replace Elect_Participation="Previously registered citizens, sample addresses" if _n==1
replace Elect_Participation="Newly registered citizens, control group" if _n==2
replace Elect_Participation="Newly registered citizens, treatment groups" if _n==3

local meter=2
foreach z in vote_pres_2nd vote_leg_1st vote_leg_2nd vote_average vote_any {
forvalue h=2/6 {
if `meter'==`h' {

ivreg2 `z' treatment_any_register_new register_new, cl(cluster)
mat coef=e(b)
gen `z'_=coef[1,3] if _n==1
replace `z'_=coef[1,3] + coef[1,2] if _n==2
replace `z'_=coef[1,3] + coef[1,2] + coef[1,1] if _n==3
replace `z'_=round(`z'_,0.001)
replace `z'_=`z'_*100

outreg2 using "$paper\Table2_Vote_by_RegStatus&Treatment.xls", nonote se append nolabel bdec(3)
ivreg2 `z' treatment_EC_register_new treatment_LC_register_new treatment_ER_register_new treatment_LR_register_new treatment_ECLR_register_new treatment_ERLR_register_new register_new, cl(cluster)
quietly outreg2 using "$paper\Table2_Vote_by_RegStatus&Treatment.xls", nonote se append nolabel bdec(3)
estimates store temp_store`h'

}
}
local meter=`meter'+1
}

* Outhseet of figure 3 using previous regression coefs.
outsheet Elect_Participation vote_pres_1st_ vote_pres_2nd_ vote_leg_1st_ vote_leg_2nd_ if _n<4 using "$paper\Figure3_Participation.xls", replace

forvalues k=1/6 {
local temp_meter=4
foreach z in "(treatment_EC_register_new + treatment_LC_register_new + treatment_ER_register_new + treatment_LR_register_new + treatment_ECLR_register_new + treatment_ERLR_register_new)/6" "(treatment_EC_register_new + treatment_LC_register_new)/2" "(treatment_ER_register_new + treatment_LR_register_new)/2" "(treatment_ER_register_new + treatment_LR_register_new)/2 - (treatment_EC_register_new + treatment_LC_register_new)/2" {
	forvalue i=1/4 {
	if `temp_meter'==`i' {
			estimates restore temp_store`k'
			lincomest `z'
			estimates store temp_`k'`temp_meter'
}
}
			local temp_meter=`temp_meter'-1
}
}

estout temp_14 temp_13 temp_12 temp_11 using "$paper/Table2_LinearCombinationsOfEstimates.xls", replace cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" Presidential Elections 1st Round") mlabel("(EC+LC+ER+LR+ECLR+ERLR)/6" "(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2") stats(N)
estout temp_24 temp_23 temp_22 temp_21 using "$paper/Table2_LinearCombinationsOfEstimates.xls", append cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" Presidential Elections 2nd Round") mlabel("(EC+LC+ER+LR+ECLR+ERLR)/6" "(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2") stats(N)
estout temp_34 temp_33 temp_32 temp_31 using "$paper/Table2_LinearCombinationsOfEstimates.xls", append cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" General Elections 1st Round") mlabel("(EC+LC+ER+LR+ECLR+ERLR)/6" "(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2") stats(N)
estout temp_44 temp_43 temp_42 temp_41 using "$paper/Table2_LinearCombinationsOfEstimates.xls", append cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" General Elections 2nd Round") mlabel("(EC+LC+ER+LR+ECLR+ERLR)/6" "(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2") stats(N)
estout temp_54 temp_53 temp_52 temp_51 using "$paper/Table2_LinearCombinationsOfEstimates.xls", append cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" Average on All Rounds") mlabel("(EC+LC+ER+LR+ECLR+ERLR)/6" "(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2") stats(N)
estout temp_64 temp_63 temp_62 temp_61 using "$paper/Table2_LinearCombinationsOfEstimates.xls", append cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" One Vote at Least") mlabel("(EC+LC+ER+LR+ECLR+ERLR)/6" "(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2") stats(N)
estimates clear

* TABLE 3 *

use "Registration&Turnout_Analyse.dta", clear

* By household, home registration treatment impact estimation
su register_new_hh if treatment_ECLR == 1 & address_household_rank == 1 & sample_household == 1 & treatment_latevisit == 1
local mean_control=r(mean)
ivreg2 register_new_hh treatment_ERLR if address_household_rank == 1 & (treatment_ECLR == 1 | treatment_ERLR == 1) & sample_household == 1 & treatment_latevisit == 1, cl(cluster) 
quietly outreg2 using "$paper\Table3_HomeRegistrationImpact.xls", nonote se replace nolabel addstat("control mean", `mean_control') adec(3) bdec(3)

foreach var of varlist register_home_hh vote_pres_1st_regnew_hh vote_pres_2nd_regnew_hh vote_leg_1st_regnew_hh vote_leg_2nd_regnew_hh vote_regnew_average_hh {
su `var' if treatment_ECLR == 1 & address_household_rank == 1 & sample_household == 1 & treatment_latevisit == 1
local mean_control=r(mean)
ivreg2 `var' treatment_ERLR if address_household_rank == 1 & (treatment_ECLR == 1 | treatment_ERLR == 1) & sample_household == 1 & treatment_latevisit == 1, cl(cluster) 
quietly outreg2 using "$paper\Table3_HomeRegistrationImpact.xls", nonote se append nolabel addstat("control mean", `mean_control') adec(3) bdec(3)
}

* TABLE 4 *

use "Registration&Turnout_Analyse.dta", clear

ivreg2 register_new indiv_gender indiv_age_bis indiv_age2 indiv_birth_othercity indiv_birth_otherdepartment indiv_birth_otherregion indiv_birth_abroad vote_register1112_avrg_building if (register_new == 1 | (register_2012 == 1 & register_new == 0)) & sample_address == 1 & treatment_groups == "Control", cl(cluster)
quietly outreg2 using "$paper\Table4_Selection.xls", nonote se replace nolabel bdec(3)
ivreg2 treatment_any_register_new indiv_gender indiv_age_bis indiv_age2 indiv_birth_othercity indiv_birth_otherdepartment indiv_birth_otherregion indiv_birth_abroad vote_register1112_avrg_building if register_new == 1 & sample_address == 1, cl(cluster)
quietly outreg2 using "$paper\Table4_Selection.xls", nonote se append nolabel bdec(3)

* /!\ Column 1 different from paper

* FIGURE 4 *

	use "Registration&Turnout_Analyse.dta", clear

	local meter=6
	foreach z in register_new_home_novisit_hh register_new_out_novisit_hh register_new_home_onevisit_hh register_new_out_onevisit_hh register_new_home_twovisits_hh register_new_out_twovisits_hh {
	forvalue h=1/6 {
	if `meter'==`h' {
	estpost su `z' if treatment_ECLR == 1 & address_household_rank == 1 & sample_household == 1 & treatment_latevisit == 1
	eststo temp_R1`h'
	estpost su `z' if treatment_ERLR == 1 & address_household_rank == 1 & sample_household == 1 & treatment_latevisit == 1
	eststo temp_R2`h'
	}
	}
	local meter=`meter'-1
	}


	estout temp_R16 temp_R15 temp_R26 temp_R25 using "$paper/Figure4_SelectionEffectControl.xls", replace cells(mean (fmt(%9.3f))) title("Before") mlabel("ECLR Home Registration" "ECLR Town Registration" "ERLR Home Registration" "ERLR Town Registration") note(" ")
	estout temp_R14 temp_R13 temp_R24 temp_R23 using "$paper/Figure4_SelectionEffectControl.xls", append cells(mean (fmt(%9.3f))) title("After early visit") mlabel("ECLR Home Registration" "ECLR Town Registration" "ERLR Home Registration" "ERLR Town Registration") note (" ")
	estout temp_R12 temp_R11 temp_R22 temp_R21 using "$paper/Figure4_SelectionEffectControl.xls", append cells(mean (fmt(%9.3f))) title("After late visit") mlabel("ECLR Home Registration" "ECLR Town Registration" "ERLR Home Registration" "ERLR Town Registration") note (" ")

	est clear

* FIGURE 5 *

use "Survey_Analyse.dta", clear

*Impact on information and politicization
ivreg2 pol_interest_index treatment_any ${controlsind}, cl(cluster_s) 
quietly outreg2 using "$paper\Figure5_ImpactPoliticizationIndex.xls",nonote se replace nolabel bdec(3)
foreach var in pol_topics_nb_index pol_position_index pol_follow_overall_index pol_follow_media_index pol_follow_talk_index pol_preference_index pol_knowledge_figures_index pol_knowledge_parties_index pol_knowledge_dates_index pol_perception_impact_index pol_perception_politicians_index pol_general_index{
ivreg2 `var' treatment_any ${controlsind}, cl(cluster_s) 
quietly outreg2 using "$paper\Figure5_ImpactPoliticizationIndex.xls",nonote se append nolabel bdec(3)
}

sum pol_topics_nb_index pol_preference_index pol_knowledge_figures_index pol_knowledge_parties_index pol_knowledge_dates_index pol_general_index

* FIGURE 6 *

use "Survey_Analyse.dta", clear

ivreg2 reg_city A1_gender indiv_survey_age indiv_survey_age2 A4_unemployed A4_inactive A10_nodegree A10_degree_infbac A10_degree_bac address_householdsize A14_nocouple A15_french_few A15_french_never indiv_birth_abroad A25_otherdep A27_naturalization A29_othernationality A17_tenant_social A17_tenant_private A18_Income_inf700 A18_Income_inf1100 A18_Income_sup1500 A20_live_inf2 A20_live_inf5 A20_live_inf10 F1_nonbeliever F3_practice_rare A7_tooearly A8_toolate /// 
A1_gender_treat indiv_survey_age_treat indiv_survey_age2_treat A4_unemployed_treat A4_inactive_treat A10_nodegree_treat A10_degree_infbac_treat A10_degree_bac_treat address_householdsize_treat A14_nocouple_treat A15_french_few_treat A15_french_never_treat indiv_birth_abroad_treat A25_otherdep_treat A27_naturalization_treat A29_othernationality_treat A17_tenant_social_treat A17_tenant_private_treat A18_Income_inf700_treat A18_Income_inf1100_treat A18_Income_sup1500_treat A20_live_inf2_treat A20_live_inf5_treat A20_live_inf10_treat F1_nonbeliever_treat F3_practice_rare_treat A7_tooearly_treat A8_toolate_treat treatment_any, cl(cluster_s)

mat beta=e(b)
gen Control=.
gen Treat=.
mat se=e(V)
mat dfr=e(Fdf2)
gen dfr=dfr[1,1]
gen Se_c=.
gen Se_t=.
gen pval_c=.
gen pval_t=.
gen star_c=""
gen star_t=""

forvalue z=1/29 {
replace Control=beta[1,`z'] if _n==`z'
replace Treat=beta[1,`z'+28] if _n==`z'
replace Se_c=sqrt(se[`z',`z']) if _n==`z'
replace Se_t=sqrt(se[`z'+28,`z'+28]) if _n==`z'
}
gen t_c=Control/Se_c
gen t_t=Treat/Se_t
foreach z in t c {
replace pval_`z'=2*ttail(dfr, abs(t_`z'))
replace star_`z'="*" if pval_`z'<0.1
replace star_`z'="**" if pval_`z'<0.05
replace star_`z'="***" if pval_`z'<0.01
}
replace Treat=Treat+Control

replace Control=round(Control,0.001)
replace Treat=round(Treat,0.001)
gen Control_=string(Control)
replace Control_=Control_+star_c
gen Treat_=string(Treat)
replace Treat_=Treat_+star_t

drop Control Treat dfr Se_c Se_t pval_c pval_t star_c star_t t_c t_t 

rename Control_ Control
rename Treat_ Treatment

gen Names=""
local meter=1
foreach z in A1_gender indiv_survey_age indiv_survey_age2 A4_unemployed A4_inactive A10_nodegree A10_degree_infbac A10_degree_bac address_householdsize A14_nocouple A15_french_few A15_french_never indiv_birth_abroad A25_otherdep A27_naturalization A29_othernationality A17_tenant_social A17_tenant_private A18_Income_inf700 A18_Income_inf1100 A18_Income_sup1500 A20_live_inf2 A20_live_inf5 A20_live_inf10 F1_nonbeliever F3_practice_rare A7_tooearly A8_toolate {
forvalues k=1/28 {
replace Names="`z'" if _n==`k' & `meter'==`k'
}
local meter=`meter'+1
}

outsheet Names Control Treatment  if _n<=28 using "$paper\Figure6_Selection.xls",replace

********

** Removing .txt files from the paper directory :
cd "${paper}"

local datafiles: dir "`paper'" files "*.txt"
foreach datafile of local datafiles {
        rm `datafile'
}

************************
* II - Appendix tables *
************************

* Setting path directory
cd "${data}"

* TABLE A1 *

use "Registration&Turnout_Analyse.dta", clear
* /!\ Panel C use Survey.Analyse.dta

*Randomization check
gen var=""
for any p control_mean control_sd treatment_mean treatment_sd N testp: gen X=.

*Panel A
#delimit;
local vars= 3;
for any address_totalmailbox address_hh_sample address_m2price
\ num 1/`vars': 
replace var="X" if _n==Y \ 
ivreg2 X treatment_any if sample_address == 1 & address_building_rank == 1 \ 
replace N=e(N) if _n==Y \ 
test treatment_any=0 \ 
replace p=r(p) if _n==Y \ 
sum X if treatment_any==0 & sample_address == 1 & address_building_rank == 1 \ 
replace control_mean=r(mean) if _n==Y \ 
replace control_sd=r(sd) if _n==Y \ 
sum X if treatment_any==1 & sample_address == 1 & address_building_rank == 1 \ 
replace treatment_mean=r(mean) if _n==Y \ 
replace treatment_sd=r(sd) if _n==Y \
ivreg2 X treatment_EC treatment_LC treatment_ER treatment_LR treatment_ECLR treatment_ERLR if sample_address == 1 & address_building_rank == 1 \ 
test (treatment_EC = 0) (treatment_LC = 0) (treatment_ER = 0) (treatment_LR = 0) (treatment_ECLR = 0) (treatment_ERLR = 0) \
replace testp = r(p) if _n == Y ;
for var p-testp: replace X=round(X, 0.001);
outsheet var control_mean control_sd treatment_mean treatment_sd p testp N if _n<=`vars' using "$appendix\TableA1_PanelA_RandomizationCheck.xls",replace;
#delimit cr

*Panel B
#delimit;
local vars= 1;
for any address_newnames
\ num 1/`vars': 
replace var="X" if _n==Y \ 
ivreg2 X treatment_any if address_household_rank == 1 & sample_household == 1, cl(cluster) \ 
replace N=e(N) if _n==Y \ 
test treatment_any=0 \ 
replace p=r(p) if _n==Y \ 
sum X if treatment_any==0 & address_household_rank == 1 & sample_household == 1 \ 
replace control_mean=r(mean) if _n==Y \ 
replace control_sd=r(sd) if _n==Y \ 
sum X if treatment_any==1 & address_household_rank == 1 & sample_household == 1 \ 
replace treatment_mean=r(mean) if _n==Y \ 
replace treatment_sd=r(sd) if _n==Y \
ivreg2 X treatment_EC treatment_LC treatment_ER treatment_LR treatment_ECLR treatment_ERLR if address_household_rank == 1 & sample_household == 1, cl(cluster) \ 
test (treatment_EC = 0) (treatment_LC = 0) (treatment_ER = 0) (treatment_LR = 0) (treatment_ECLR = 0) (treatment_ERLR = 0) \
replace testp = r(p) if _n == Y ;
for var p-testp: replace X=round(X, 0.001);
outsheet var control_mean control_sd treatment_mean treatment_sd p testp N if _n<=`vars' using "$appendix\TableA1_PanelB_RandomizationCheck.xls",replace;
#delimit cr

*Panel C
use "Survey_Analyse.dta", clear

replace indiv_survey_age=indiv_survey_age*10

gen var=""
for any diff p control_mean control_sd treatment_mean treatment_sd N testp testf: gen X=.
#delimit;
local vars= 31;
for any indiv_survey_age A1_gender A14_couple address_householdsize A10_nodegree A10_degree_infbac A10_degree_bac A10_degree_supbac A4_job A4_unemployed A4_inactive A17_owner A17_tenant_social A17_tenant_private A18_Income_inf700 A18_Income_inf1100 A18_Income_inf1500 A18_Income_sup1500 A24a_birthcountry A25_birth_samedep A27_naturalization A29_othernationality A15_french_always A15_french_few A15_french_never A20_live_inf2 A20_live_inf5 A20_live_inf10 A20_live_sup10 F1_believe F3_practice_often
\ num 1/`vars': 
replace var="X" if _n==Y \ 
ivreg2 X treatment_any, cl(cluster_s) \ 
replace N=e(N) if _n==Y \ 
mat beta=e(b) \ 
replace diff=beta[1,1] if _n==Y \ 
test treatment_any=0 \ 
replace p=r(p) if _n==Y \ 
sum X if treatment_any==0 \ 
replace control_mean=r(mean) if _n==Y \ 
replace control_sd=r(sd) if _n==Y \ 
sum X if treatment_any==1  \ 
replace treatment_mean=r(mean) if _n==Y \ 
replace treatment_sd=r(sd) if _n==Y \
ivreg2 X treatment_EC treatment_LC treatment_ER treatment_LR treatment_ECLR treatment_ERLR, cl(cluster_s) \ 
test (treatment_EC = 0) (treatment_LC = 0) (treatment_ER = 0) (treatment_LR = 0) (treatment_ECLR = 0) (treatment_ERLR = 0) \
replace testp = r(p) if _n == Y \
replace testf = r(F) if _n == Y;
for var diff-testf: replace X=round(X, 0.001);
outsheet var control_mean control_sd treatment_mean treatment_sd diff p testf testp N if _n<=`vars' using "$appendix\TableA1_PanelC_RandomizationCheck.xls",replace
;

#delimit cr

* TABLE A2 *

use "Registration&Turnout_Analyse.dta", clear

*Spillovers analysis
su register_new_hh if address_proximity == 0 & address_household_rank == 1 & sample_household == 1 
local mean_control=r(mean)
ivreg2 register_new_hh address_proximity ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
quietly outreg2 using "$appendix\TableA2_Spillovers.xls", nonote se replace nolabel addstat("control mean", `mean_control') adec(3) bdec(3)
ivreg2 register_new_hh address_proximity address_newnames address_totalmailbox ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
quietly outreg2 using "$appendix\TableA2_Spillovers.xls", nonote se append nolabel addstat("control mean", `mean_control') adec(3) bdec(3)

* TABLE A3 *

use "Registration&Turnout_Analyse.dta", clear

*Impact analysis per type of new registered
su register_new_hh if treatment_groups == "Control" & address_household_rank == 1 & sample_household == 1 
local mean_control=r(mean)
ivreg2 register_new_hh treatment_any address_newnames address_totalmailbox ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
quietly outreg2 using "$appendix\TableA3_ImpactRegistrationType.xls", nonote se replace nolabel addstat("control mean", `mean_control') adec(3) bdec(3)
su register_new_hh if treatment_groups == "Control" & address_household_rank == 1 & sample_household == 1 
local mean_control=r(mean)
ivreg2 register_new_hh treatment_EC treatment_LC treatment_ER treatment_LR treatment_ECLR treatment_ERLR address_newnames address_totalmailbox ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
estimates store temp_store5
quietly outreg2 using "$appendix\TableA3_ImpactRegistrationType.xls", nonote se append nolabel addstat("control mean", `mean_control') adec(3) bdec(3)

local meter=4
foreach z in register_new_unreg_hh register_new_othcity_hh register_new_city_hh register_new_automatically_hh {
forvalue h=1/4 {
if `meter'==`h' {
su `z' if treatment_groups == "Control" & address_household_rank == 1 & sample_household == 1 
local mean_control=r(mean)
ivreg2 `z' treatment_any address_newnames address_totalmailbox ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
quietly outreg2 using "$appendix\TableA3_ImpactRegistrationType.xls", nonote se append nolabel addstat("control mean", `mean_control') adec(3) bdec(3)

ivreg2 `z' treatment_EC treatment_LC treatment_ER treatment_LR treatment_ECLR treatment_ERLR address_newnames address_totalmailbox ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
estimates store temp_store`h'
quietly outreg2 using "$appendix\TableA3_ImpactRegistrationType.xls", nonote se append nolabel addstat("control mean", `mean_control') adec(3) bdec(3)

}
}
local meter=`meter'-1
}


forvalues k=1/5 {
local temp_meter=4
foreach z in "(treatment_EC + treatment_LC)/2" "(treatment_ER + treatment_LR)/2" "(treatment_ER + treatment_LR)/2 - (treatment_EC + treatment_LC)/2" "(treatment_LC + treatment_LR)/2 - (treatment_EC + treatment_ER)/2" {
	forvalue i=1/4 {
	if `temp_meter'==`i' {
			estimates restore temp_store`k'
			lincomest `z'
			estimates store temp_`k'`temp_meter'
}
}
			local temp_meter=`temp_meter'-1
}
}

estout temp_54 temp_53 temp_52 temp_51 using "$appendix/TableA3_LinearCombinationsOfEstimates.xls", replace cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" All newly registered (A&P controls: Yes)") mlabel("(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2" "(LC+LR)/2-(EC+ER)/2") stats(N)
estout temp_44 temp_43 temp_42 temp_41 using "$appendix/TableA3_LinearCombinationsOfEstimates.xls", append cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" Not registered before (A&P controls: Yes)") mlabel("(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2" "(LC+LR)/2-(EC+ER)/2") stats(N)
estout temp_34 temp_33 temp_32 temp_31 using "$appendix/TableA3_LinearCombinationsOfEstimates.xls", append cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" Registered in another city before (A&P controls: Yes)") mlabel("(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2" "(LC+LR)/2-(EC+ER)/2") stats(N)
estout temp_24 temp_23 temp_22 temp_21 using "$appendix/TableA3_LinearCombinationsOfEstimates.xls", append cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" Registered at another address in this city before (A&P controls: Yes)") mlabel("(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2" "(LC+LR)/2-(EC+ER)/2") stats(N)
estout temp_14 temp_13 temp_12 temp_11 using "$appendix/TableA3_LinearCombinationsOfEstimates.xls", append cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title(" Automatically registered (A&P controls: Yes)") mlabel("(EC+LC)/2" "(ER+LR)/2" "(ER+LR)/2-(EC+LC)/2" "(LC+LR)/2-(EC+ER)/2") stats(N)

estimates clear

* TABLE A4 *

use "Registration&Turnout_Analyse.dta", clear

*Impact on the number of registrations par type de canvasser
su register_new_hh if treatment_groups == "Control" & address_household_rank == 1 & sample_household == 1
local mean_control=r(mean)
ivreg2 register_new_hh treatment_any_student treatment_any_NGO treatment_any_activist ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
quietly outreg2 using "$appendix\TableA4_ImpactRegistrationCanvassers.xls", nonote se replace nolabel addstat("control mean", `mean_control') adec(3) bdec(3)
ivreg2 register_new_hh treatment_any_student treatment_any_NGO treatment_any_activist address_newnames address_totalmailbox ${controlsstrate} if address_household_rank == 1 & sample_household == 1, cl(cluster)
quietly outreg2 using "$appendix\TableA4_ImpactRegistrationCanvassers.xls", nonote se append nolabel addstat("control mean", `mean_control') adec(3) bdec(3)

* TABLE A5 *

use "Registration&Turnout_Analyse.dta", clear

keep if register_2012 == 1 & sample_address == 1 & (register_new == 0 | (register_new == 1 & register_motive_2012 ~= "Inconnu" & register_motive_2012 ~= "Autre"))
replace register_new_unreg = 0 if register_new == 0
replace register_new_othcity = 0 if register_new == 0
replace register_new_city = 0 if register_new == 0
replace register_new_automatically = 0 if register_new == 0

replace treatment_any_register_new = register_new * treatment_any 
replace treatment_any_regnew_unreg = register_new_unreg * treatment_any 
replace treatment_any_regnew_othcity = register_new_othcity * treatment_any 
replace treatment_any_regnew_city = register_new_city * treatment_any 
replace treatment_any_regnew_auto = register_new_automatically * treatment_any 
 
foreach value in EC LC ER LR ECLR ERLR {
replace treatment_`value'_regnew_unreg = register_new_unreg * treatment_`value' 
replace treatment_`value'_regnew_othcity = register_new_othcity * treatment_`value' 
replace treatment_`value'_regnew_city = register_new_city * treatment_`value' 
replace treatment_`value'_regnew_auto = register_new_automatically * treatment_`value' 
}

replace vote_average = (vote_pres_1st + vote_pres_2nd + vote_leg_1st + vote_leg_2nd) / 4
drop vote_any
egen vote_any = rmax(vote_pres_1st vote_pres_2nd vote_leg_1st vote_leg_2nd)
replace vote_any = . if vote_pres_1st == . | vote_pres_2nd == . | vote_leg_1st == . | vote_leg_2nd == .

ivreg2 vote_pres_1st treatment_any_regnew_unreg treatment_any_regnew_othcity treatment_any_regnew_city treatment_any_regnew_auto register_new_unreg register_new_othcity register_new_city register_new_automatically, cl(cluster)
quietly outreg2 using "$appendix\TableA5_ElectoralParticipation.xls", nonote se replace nolabel bdec(3)
foreach name in regnew_unreg regnew_othcity regnew_city regnew_auto {
count if treatment_any_`name' == 1
scalar nb_`name' =r(N)
}
foreach name in regnew_unreg regnew_othcity regnew_city regnew_auto {
scalar prop_`name' = nb_`name' / (nb_regnew_unreg + nb_regnew_othcity + nb_regnew_city + nb_regnew_auto)
}
eststo temp_R6 : lincomest treatment_any_regnew_unreg*prop_regnew_unreg + treatment_any_regnew_othcity*prop_regnew_othcity + treatment_any_regnew_city*prop_regnew_city + treatment_any_regnew_auto*prop_regnew_auto

local meter=5
foreach z in vote_pres_2nd vote_leg_1st vote_leg_2nd vote_average vote_any {
forvalue h=1/5 {
if `meter'==`h' {

ivreg2 `z' treatment_any_regnew_unreg treatment_any_regnew_othcity treatment_any_regnew_city treatment_any_regnew_auto register_new_unreg register_new_othcity register_new_city register_new_automatically, cl(cluster)
quietly outreg2 using "$appendix\TableA5_ElectoralParticipation.xls", nonote se append nolabel bdec(3)
foreach name in regnew_unreg regnew_othcity regnew_city regnew_auto {
count if treatment_any_`name' == 1
scalar nb_`name' =r(N)
}
foreach name in regnew_unreg regnew_othcity regnew_city regnew_auto {
scalar prop_`name' = nb_`name' / (nb_regnew_unreg + nb_regnew_othcity + nb_regnew_city + nb_regnew_auto)
}
eststo temp_R`h' : lincomest treatment_any_regnew_unreg*prop_regnew_unreg + treatment_any_regnew_othcity*prop_regnew_othcity + treatment_any_regnew_city*prop_regnew_city + treatment_any_regnew_auto*prop_regnew_auto

}
}
local meter=`meter'-1
}


estout temp_R6 temp_R5 temp_R4 temp_R3 temp_R2 temp_R1 using "$appendix/TableA5_LinearCombinationsOfEstimates.xls", replace cells(b(s label("coef") fmt(%9.3f)) se(par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Av. difference between newly reg. in treatment gr. and control, controlling for previous reg. status") mlabel("Pres. 1st" "Pres. 2nd" "Gen. 1st" "Gen. 2nd" "Average all rounds" "One vote at least") stats(N)

* TABLE A6 *

use "Registration&Turnout_Analyse.dta", clear

*Percent decline in turnout between the presidential and general elections, by registration status and treatment group
reg vote_pres_1st register_new treatment_any_register_new
estimates store temp1
reg vote_pres_2nd register_new treatment_any_register_new
estimates store temp2
reg vote_leg_1st register_new treatment_any_register_new
estimates store temp3
reg vote_leg_2nd register_new treatment_any_register_new
estimates store temp4
eststo temp_R01 : suest temp1 temp2 temp3 temp4, cl(cluster)

*Decline in previously registered citizens, all groups
est restore temp_R01
eststo temp_R1 : nlcom (([temp3_mean]_cons + [temp4_mean]_cons) / 2 - ([temp1_mean]_cons + [temp2_mean]_cons) / 2) / (([temp1_mean]_cons + [temp2_mean]_cons) / 2), post
*Decline in newly registered citizens, control group
est restore temp_R01
eststo temp_R2 : nlcom (([temp3_mean]_cons + [temp4_mean]_cons + [temp3_mean]register_new + [temp4_mean]register_new) / 2 - ([temp1_mean]_cons + [temp2_mean]_cons + [temp1_mean]register_new + [temp2_mean]register_new) / 2) / (([temp1_mean]_cons + [temp2_mean]_cons + [temp1_mean]register_new + [temp2_mean]register_new) / 2), post
*Decline in newly registered citizens, treatment groups
est restore temp_R01
eststo temp_R3 : nlcom (([temp3_mean]_cons + [temp4_mean]_cons + [temp3_mean]register_new + [temp4_mean]register_new + [temp3_mean]treatment_any_register_new + [temp4_mean]treatment_any_register_new) / 2 - ([temp1_mean]_cons + [temp2_mean]_cons + [temp1_mean]register_new + [temp2_mean]register_new + [temp1_mean]treatment_any_register_new + [temp2_mean]treatment_any_register_new) / 2) / (([temp1_mean]_cons + [temp2_mean]_cons + [temp1_mean]register_new + [temp2_mean]register_new + [temp1_mean]treatment_any_register_new + [temp2_mean]treatment_any_register_new) / 2), post
*Difference in decline between newly registered citizens and previously registered Citizens
est restore temp_R01
eststo temp_R4 : nlcom (([temp3_mean]_cons + [temp4_mean]_cons + [temp3_mean]register_new + [temp4_mean]register_new) / 2 - ([temp1_mean]_cons + [temp2_mean]_cons + [temp1_mean]register_new + [temp2_mean]register_new) / 2) / (([temp1_mean]_cons + [temp2_mean]_cons + [temp1_mean]register_new + [temp2_mean]register_new) / 2) - (([temp3_mean]_cons + [temp4_mean]_cons) / 2 - ([temp1_mean]_cons + [temp2_mean]_cons) / 2) / (([temp1_mean]_cons + [temp2_mean]_cons) / 2), post
*Difference in decline between newly registered citizens in treatment groups and control group
est restore temp_R01
eststo temp_R5 : nlcom (([temp3_mean]_cons + [temp4_mean]_cons + [temp3_mean]register_new + [temp4_mean]register_new + [temp3_mean]treatment_any_register_new + [temp4_mean]treatment_any_register_new) / 2 - ([temp1_mean]_cons + [temp2_mean]_cons + [temp1_mean]register_new + [temp2_mean]register_new + [temp1_mean]treatment_any_register_new + [temp2_mean]treatment_any_register_new) / 2) / (([temp1_mean]_cons + [temp2_mean]_cons + [temp1_mean]register_new + [temp2_mean]register_new + [temp1_mean]treatment_any_register_new + [temp2_mean]treatment_any_register_new) / 2) - (([temp3_mean]_cons + [temp4_mean]_cons + [temp3_mean]register_new + [temp4_mean]register_new) / 2 - ([temp1_mean]_cons + [temp2_mean]_cons + [temp1_mean]register_new + [temp2_mean]register_new) / 2) / (([temp1_mean]_cons + [temp2_mean]_cons + [temp1_mean]register_new + [temp2_mean]register_new) / 2), post

*Percent decline in turnout between the presidential and general elections, by registration status and treatment group (Specifying Canvassing and Home registration)
reg vote_pres_1st register_new treatment_EC_register_new treatment_LC_register_new treatment_ER_register_new treatment_LR_register_new treatment_ECLR_register_new treatment_ERLR_register_new
estimates store temp_1
reg vote_pres_2nd register_new treatment_EC_register_new treatment_LC_register_new treatment_ER_register_new treatment_LR_register_new treatment_ECLR_register_new treatment_ERLR_register_new
estimates store temp_2
reg vote_leg_1st register_new treatment_EC_register_new treatment_LC_register_new treatment_ER_register_new treatment_LR_register_new treatment_ECLR_register_new treatment_ERLR_register_new
estimates store temp_3
reg vote_leg_2nd register_new treatment_EC_register_new treatment_LC_register_new treatment_ER_register_new treatment_LR_register_new treatment_ECLR_register_new treatment_ERLR_register_new
estimates store temp_4
eststo temp_R02 : suest temp_1 temp_2 temp_3 temp_4, cl(cluster)

*Decline in newly reg. citizens, treatment groups, Canvassing group
est restore temp_R02
eststo temp_R6 : nlcom ((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new + 2*[temp_4_mean]register_new + [temp_3_mean]treatment_EC_register_new + [temp_4_mean]treatment_EC_register_new + [temp_3_mean]treatment_LC_register_new + [temp_4_mean]treatment_LC_register_new) / 4 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new + 2*[temp_2_mean]register_new + [temp_1_mean]treatment_EC_register_new + [temp_2_mean]treatment_EC_register_new + [temp_1_mean]treatment_LC_register_new + [temp_2_mean]treatment_LC_register_new) / 4) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new + 2*[temp_2_mean]register_new + [temp_1_mean]treatment_EC_register_new + [temp_2_mean]treatment_EC_register_new + [temp_1_mean]treatment_LC_register_new + [temp_2_mean]treatment_LC_register_new) / 4), post
*Decline in newly reg. citizens, treatment groups, Home Registration group
est restore temp_R02
eststo temp_R7 : nlcom ((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new + 2*[temp_4_mean]register_new + [temp_3_mean]treatment_ER_register_new + [temp_4_mean]treatment_ER_register_new + [temp_3_mean]treatment_LR_register_new + [temp_4_mean]treatment_LR_register_new) / 4 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new + 2*[temp_2_mean]register_new + [temp_1_mean]treatment_ER_register_new + [temp_2_mean]treatment_ER_register_new + [temp_1_mean]treatment_LR_register_new + [temp_2_mean]treatment_LR_register_new) / 4) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new + 2*[temp_2_mean]register_new + [temp_1_mean]treatment_ER_register_new + [temp_2_mean]treatment_ER_register_new + [temp_1_mean]treatment_LR_register_new + [temp_2_mean]treatment_LR_register_new) / 4), post
*Difference in decline between newly registered citizens in treatment groups and control group, Canvassing group
est restore temp_R02
eststo temp_R8 : nlcom ((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new + 2*[temp_4_mean]register_new + [temp_3_mean]treatment_EC_register_new + [temp_4_mean]treatment_EC_register_new + [temp_3_mean]treatment_LC_register_new + [temp_4_mean]treatment_LC_register_new) / 4 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new + 2*[temp_2_mean]register_new + [temp_1_mean]treatment_EC_register_new + [temp_2_mean]treatment_EC_register_new + [temp_1_mean]treatment_LC_register_new + [temp_2_mean]treatment_LC_register_new) / 4) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new + 2*[temp_2_mean]register_new + [temp_1_mean]treatment_EC_register_new + [temp_2_mean]treatment_EC_register_new + [temp_1_mean]treatment_LC_register_new + [temp_2_mean]treatment_LC_register_new) / 4) - (([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new + [temp_4_mean]register_new) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new + [temp_2_mean]register_new) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new + [temp_2_mean]register_new) / 2), post
*Difference in decline between newly registered citizens in treatment groups and control group, Home Registration group
est restore temp_R02
eststo temp_R9 : nlcom ((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new + 2*[temp_4_mean]register_new + [temp_3_mean]treatment_ER_register_new + [temp_4_mean]treatment_ER_register_new + [temp_3_mean]treatment_LR_register_new + [temp_4_mean]treatment_LR_register_new) / 4 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new + 2*[temp_2_mean]register_new + [temp_1_mean]treatment_ER_register_new + [temp_2_mean]treatment_ER_register_new + [temp_1_mean]treatment_LR_register_new + [temp_2_mean]treatment_LR_register_new) / 4) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new + 2*[temp_2_mean]register_new + [temp_1_mean]treatment_ER_register_new + [temp_2_mean]treatment_ER_register_new + [temp_1_mean]treatment_LR_register_new + [temp_2_mean]treatment_LR_register_new) / 4) - (([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new + [temp_4_mean]register_new) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new + [temp_2_mean]register_new) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new + [temp_2_mean]register_new) / 2), post

estout temp_R1 using "$appendix/TableA6_DeclineTurnout.xls", replace cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Previously reg. citizens, all groups (PANEL A)") mlabel("All Treatment")
estout temp_R2 using "$appendix/TableA6_DeclineTurnout.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Newly reg. citizens, control group (PANEL A)") mlabel("All Treatment") 
estout temp_R4 using "$appendix/TableA6_DeclineTurnout.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Difference between newly reg. citizens and previously reg. Citizens") mlabel("All Treatment")
estout temp_R3 temp_R6 temp_R7 using "$appendix/TableA6_DeclineTurnout.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Newly reg. citizens, treatment groups") mlabel("All Treatment" "Canvassing" "Home Registration")
estout temp_R5 temp_R8 temp_R9 using "$appendix/TableA6_DeclineTurnout.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Difference between newly reg. citizens in treatment groups and control group") mlabel("All Treatment" "Canvassing" "Home Registration")

estimates clear

* /!\ Difference between newly reg. citizens in treatment groups and control group, controlling for initial registration status : Done below with table A7


*TABLE A7 (and end of TABLE A6)

use "Registration&Turnout_Analyse.dta", clear

* Percent decline in turnout between the presidential and general elections among newly registered citizens by treatment group and previous registration status
* Test if greater decline of newly registered between pres and gen elections - all groups
reg vote_pres_1st treatment_any_regnew_unreg treatment_any_regnew_othcity treatment_any_regnew_city treatment_any_regnew_auto register_new_unreg register_new_othcity register_new_city register_new_automatically 
estimates store temp_1
reg vote_pres_2nd treatment_any_regnew_unreg treatment_any_regnew_othcity treatment_any_regnew_city treatment_any_regnew_auto register_new_unreg register_new_othcity register_new_city register_new_automatically 
estimates store temp_2
reg vote_leg_1st treatment_any_regnew_unreg treatment_any_regnew_othcity treatment_any_regnew_city treatment_any_regnew_auto register_new_unreg register_new_othcity register_new_city register_new_automatically 
estimates store temp_3
reg vote_leg_2nd treatment_any_regnew_unreg treatment_any_regnew_othcity treatment_any_regnew_city treatment_any_regnew_auto register_new_unreg register_new_othcity register_new_city register_new_automatically 
estimates store temp_4
eststo temp_R01 : suest temp_1 temp_2 temp_3 temp_4, cl(cluster)

* Test if greater decline of newly registered between pres and gen elections - Canvasser and Home Registration
reg vote_pres_1st treatment_EC_regnew_unreg treatment_EC_regnew_othcity treatment_EC_regnew_city treatment_EC_regnew_auto treatment_LC_regnew_unreg treatment_LC_regnew_othcity treatment_LC_regnew_city treatment_LC_regnew_auto treatment_ER_regnew_unreg treatment_ER_regnew_othcity treatment_ER_regnew_city treatment_ER_regnew_auto treatment_LR_regnew_unreg treatment_LR_regnew_othcity treatment_LR_regnew_city treatment_LR_regnew_auto treatment_ECLR_regnew_unreg treatment_ECLR_regnew_othcity treatment_ECLR_regnew_city treatment_ECLR_regnew_auto treatment_ERLR_regnew_unreg treatment_ERLR_regnew_othcity treatment_ERLR_regnew_city treatment_ERLR_regnew_auto register_new_unreg register_new_othcity register_new_city register_new_automatically
estimates store temp_1
reg vote_pres_2nd treatment_EC_regnew_unreg treatment_EC_regnew_othcity treatment_EC_regnew_city treatment_EC_regnew_auto treatment_LC_regnew_unreg treatment_LC_regnew_othcity treatment_LC_regnew_city treatment_LC_regnew_auto treatment_ER_regnew_unreg treatment_ER_regnew_othcity treatment_ER_regnew_city treatment_ER_regnew_auto treatment_LR_regnew_unreg treatment_LR_regnew_othcity treatment_LR_regnew_city treatment_LR_regnew_auto treatment_ECLR_regnew_unreg treatment_ECLR_regnew_othcity treatment_ECLR_regnew_city treatment_ECLR_regnew_auto treatment_ERLR_regnew_unreg treatment_ERLR_regnew_othcity treatment_ERLR_regnew_city treatment_ERLR_regnew_auto register_new_unreg register_new_othcity register_new_city register_new_automatically
estimates store temp_2
reg vote_leg_1st treatment_EC_regnew_unreg treatment_EC_regnew_othcity treatment_EC_regnew_city treatment_EC_regnew_auto treatment_LC_regnew_unreg treatment_LC_regnew_othcity treatment_LC_regnew_city treatment_LC_regnew_auto treatment_ER_regnew_unreg treatment_ER_regnew_othcity treatment_ER_regnew_city treatment_ER_regnew_auto treatment_LR_regnew_unreg treatment_LR_regnew_othcity treatment_LR_regnew_city treatment_LR_regnew_auto treatment_ECLR_regnew_unreg treatment_ECLR_regnew_othcity treatment_ECLR_regnew_city treatment_ECLR_regnew_auto treatment_ERLR_regnew_unreg treatment_ERLR_regnew_othcity treatment_ERLR_regnew_city treatment_ERLR_regnew_auto register_new_unreg register_new_othcity register_new_city register_new_automatically
estimates store temp_3
reg vote_leg_2nd treatment_EC_regnew_unreg treatment_EC_regnew_othcity treatment_EC_regnew_city treatment_EC_regnew_auto treatment_LC_regnew_unreg treatment_LC_regnew_othcity treatment_LC_regnew_city treatment_LC_regnew_auto treatment_ER_regnew_unreg treatment_ER_regnew_othcity treatment_ER_regnew_city treatment_ER_regnew_auto treatment_LR_regnew_unreg treatment_LR_regnew_othcity treatment_LR_regnew_city treatment_LR_regnew_auto treatment_ECLR_regnew_unreg treatment_ECLR_regnew_othcity treatment_ECLR_regnew_city treatment_ECLR_regnew_auto treatment_ERLR_regnew_unreg treatment_ERLR_regnew_othcity treatment_ERLR_regnew_city treatment_ERLR_regnew_auto register_new_unreg register_new_othcity register_new_city register_new_automatically
estimates store temp_4
eststo temp_R02 : suest temp_1 temp_2 temp_3 temp_4, cl(cluster)

/*
For each category (former unregistered / bad registered because other city / bad registered because other address but in same city / automatically registered because turning 18), calculation :
- Decline in participation in newly registered, control
- Decline in participation in newly registered, treatment
*/
foreach var in unreg othcity city auto {
est restore temp_R01
eststo temp_R1_`var' : nlcom (([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_`var' + [temp_4_mean]register_new_`var') / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var') / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var') / 2), post
est restore temp_R01
eststo temp_R2_`var' : nlcom (([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_`var' + [temp_4_mean]register_new_`var' + [temp_3_mean]treatment_any_regnew_`var' + [temp_4_mean]treatment_any_regnew_`var') / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var' + [temp_1_mean]treatment_any_regnew_`var' + [temp_2_mean]treatment_any_regnew_`var') / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var' + [temp_1_mean]treatment_any_regnew_`var' + [temp_2_mean]treatment_any_regnew_`var') / 2), post
est restore temp_R01
eststo temp_R3_`var' : nlcom (([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_`var' + [temp_4_mean]register_new_`var' + [temp_3_mean]treatment_any_regnew_`var' + [temp_4_mean]treatment_any_regnew_`var') / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var' + [temp_1_mean]treatment_any_regnew_`var' + [temp_2_mean]treatment_any_regnew_`var') / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var' + [temp_1_mean]treatment_any_regnew_`var' + [temp_2_mean]treatment_any_regnew_`var') / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_`var' + [temp_4_mean]register_new_`var') / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var') / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var') / 2)), post
}

/*
For each category (former unregistered / bad registered because other city / bad registered because other address but in same city / automatically registered because turning 18), calculation :
- Decline in participation in newly registered, Canvasser
- Decline in participation in newly registered, Home Registration
*/
foreach var in unreg othcity city auto{
est restore temp_R02
eststo temp_R5_`var' : nlcom ((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_`var' + 2*[temp_4_mean]register_new_`var' + [temp_3_mean]treatment_EC_regnew_`var' + [temp_4_mean]treatment_EC_regnew_`var' + [temp_3_mean]treatment_LC_regnew_`var' + [temp_4_mean]treatment_LC_regnew_`var') / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_`var' + 2*[temp_2_mean]register_new_`var' + [temp_1_mean]treatment_EC_regnew_`var' + [temp_2_mean]treatment_EC_regnew_`var' + [temp_1_mean]treatment_LC_regnew_`var' + [temp_2_mean]treatment_LC_regnew_`var') / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_`var' + 2*[temp_2_mean]register_new_`var' + [temp_1_mean]treatment_EC_regnew_`var' + [temp_2_mean]treatment_EC_regnew_`var' + [temp_1_mean]treatment_LC_regnew_`var' + [temp_2_mean]treatment_LC_regnew_`var') / 2), post
est restore temp_R02
eststo temp_R6_`var' : nlcom ((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_`var' + 2*[temp_4_mean]register_new_`var' + [temp_3_mean]treatment_ER_regnew_`var' + [temp_4_mean]treatment_ER_regnew_`var' + [temp_3_mean]treatment_LR_regnew_`var' + [temp_4_mean]treatment_LR_regnew_`var') / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_`var' + 2*[temp_2_mean]register_new_`var' + [temp_1_mean]treatment_ER_regnew_`var' + [temp_2_mean]treatment_ER_regnew_`var' + [temp_1_mean]treatment_LR_regnew_`var' + [temp_2_mean]treatment_LR_regnew_`var') / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_`var' + 2*[temp_2_mean]register_new_`var' + [temp_1_mean]treatment_ER_regnew_`var' + [temp_2_mean]treatment_ER_regnew_`var' + [temp_1_mean]treatment_LR_regnew_`var' + [temp_2_mean]treatment_LR_regnew_`var') / 2), post
est restore temp_R02
eststo temp_R7_`var' : nlcom ((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_`var' + 2*[temp_4_mean]register_new_`var' + [temp_3_mean]treatment_EC_regnew_`var' + [temp_4_mean]treatment_EC_regnew_`var' + [temp_3_mean]treatment_LC_regnew_`var' + [temp_4_mean]treatment_LC_regnew_`var') / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_`var' + 2*[temp_2_mean]register_new_`var' + [temp_1_mean]treatment_EC_regnew_`var' + [temp_2_mean]treatment_EC_regnew_`var' + [temp_1_mean]treatment_LC_regnew_`var' + [temp_2_mean]treatment_LC_regnew_`var') / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_`var' + 2*[temp_2_mean]register_new_`var' + [temp_1_mean]treatment_EC_regnew_`var' + [temp_2_mean]treatment_EC_regnew_`var' + [temp_1_mean]treatment_LC_regnew_`var' + [temp_2_mean]treatment_LC_regnew_`var') / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_`var' + [temp_4_mean]register_new_`var') / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var') / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var') / 2)), post
est restore temp_R02
eststo temp_R8_`var' : nlcom ((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_`var' + 2*[temp_4_mean]register_new_`var' + [temp_3_mean]treatment_ER_regnew_`var' + [temp_4_mean]treatment_ER_regnew_`var' + [temp_3_mean]treatment_LR_regnew_`var' + [temp_4_mean]treatment_LR_regnew_`var') / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_`var' + 2*[temp_2_mean]register_new_`var' + [temp_1_mean]treatment_ER_regnew_`var' + [temp_2_mean]treatment_ER_regnew_`var' + [temp_1_mean]treatment_LR_regnew_`var' + [temp_2_mean]treatment_LR_regnew_`var') / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_`var' + 2*[temp_2_mean]register_new_`var' + [temp_1_mean]treatment_ER_regnew_`var' + [temp_2_mean]treatment_ER_regnew_`var' + [temp_1_mean]treatment_LR_regnew_`var' + [temp_2_mean]treatment_LR_regnew_`var') / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_`var' + [temp_4_mean]register_new_`var') / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var') / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_`var' + [temp_2_mean]register_new_`var') / 2)), post
}

estout temp_R1_unreg using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", replace cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Control group (PANEL A - Unreg)") mlabel("Canvassing")
estout temp_R2_unreg temp_R5_unreg temp_R6_unreg using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Treatment groups (PANEL A - Unreg)") mlabel("All treatment" "Canvassing" "Home Registration")
estout temp_R3_unreg temp_R7_unreg temp_R8_unreg using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Difference between treatment groups and control group (PANEL A - Unreg)") mlabel("All treatment" "Canvassing" "Home Registration")

estout temp_R1_othcity using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Control group (PANEL B - Othcity)") mlabel("Canvassing")
estout temp_R2_othcity temp_R5_othcity temp_R6_othcity using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Treatment groups (PANEL B - Othcity)") mlabel("All treatment" "Canvassing" "Home Registration")
estout temp_R3_othcity temp_R7_othcity temp_R8_othcity using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Difference between treatment groups and control group (PANEL B - Othcity)") mlabel("All treatment" "Canvassing" "Home Registration")

estout temp_R1_city using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Control group (PANEL C - City)") mlabel("Canvassing")
estout temp_R2_city temp_R5_city temp_R6_city using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Treatment groups (PANEL C - City)") mlabel("All treatment" "Canvassing" "Home Registration")
estout temp_R3_city temp_R7_city temp_R8_city using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Difference between treatment groups and control group (PANEL C - City)") mlabel("All treatment" "Canvassing" "Home Registration")

estout temp_R1_auto using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Control group (PANEL D - Auto)") mlabel("Canvassing")
estout temp_R2_auto temp_R5_auto temp_R6_auto using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Treatment groups (PANEL D - Auto)") mlabel("All treatment" "Canvassing" "Home Registration")
estout temp_R3_auto temp_R7_auto temp_R8_auto using "$appendix/TableA7_DeclineTurnout_NewlyReg.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Difference between treatment groups and control group (PANEL D - Auto)") mlabel("All treatment" "Canvassing" "Home Registration")

* End of table A6 *

/*
* End of table A6 - Last line, column 1 *
Taking all category and calulation weighted average of the different newly registered treatment decline - newly registered control decline
Difference between newly reg. citizens in treatment groups and control group, controlling for initial registration status
*/
foreach name in regnew_unreg regnew_othcity regnew_city regnew_auto {
count if treatment_any_`name' == 1
scalar nb_`name' =r(N)
}
foreach name in regnew_unreg regnew_othcity regnew_city regnew_auto {
scalar prop_`name' = nb_`name' / (nb_regnew_unreg + nb_regnew_othcity + nb_regnew_city + nb_regnew_auto)
}
est restore temp_R01
eststo temp_R4 : nlcom prop_regnew_unreg * ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_unreg + [temp_4_mean]register_new_unreg + [temp_3_mean]treatment_any_regnew_unreg + [temp_4_mean]treatment_any_regnew_unreg) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_unreg + [temp_2_mean]register_new_unreg + [temp_1_mean]treatment_any_regnew_unreg + [temp_2_mean]treatment_any_regnew_unreg) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_unreg + [temp_2_mean]register_new_unreg + [temp_1_mean]treatment_any_regnew_unreg + [temp_2_mean]treatment_any_regnew_unreg) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_unreg + [temp_4_mean]register_new_unreg) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_unreg + [temp_2_mean]register_new_unreg) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_unreg + [temp_2_mean]register_new_unreg) / 2))) + prop_regnew_othcity * ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_othcity + [temp_4_mean]register_new_othcity + [temp_3_mean]treatment_any_regnew_othcity + [temp_4_mean]treatment_any_regnew_othcity) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_othcity + [temp_2_mean]register_new_othcity + [temp_1_mean]treatment_any_regnew_othcity + [temp_2_mean]treatment_any_regnew_othcity) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_othcity + [temp_2_mean]register_new_othcity + [temp_1_mean]treatment_any_regnew_othcity + [temp_2_mean]treatment_any_regnew_othcity) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_othcity + [temp_4_mean]register_new_othcity) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_othcity + [temp_2_mean]register_new_othcity) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_othcity + [temp_2_mean]register_new_othcity) / 2))) + prop_regnew_city * ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_city + [temp_4_mean]register_new_city + [temp_3_mean]treatment_any_regnew_city + [temp_4_mean]treatment_any_regnew_city) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_city + [temp_2_mean]register_new_city + [temp_1_mean]treatment_any_regnew_city + [temp_2_mean]treatment_any_regnew_city) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_city + [temp_2_mean]register_new_city + [temp_1_mean]treatment_any_regnew_city + [temp_2_mean]treatment_any_regnew_city) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_city + [temp_4_mean]register_new_city) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_city + [temp_2_mean]register_new_city) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_city + [temp_2_mean]register_new_city) / 2))) + prop_regnew_auto * ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_automatically + [temp_4_mean]register_new_automatically + [temp_3_mean]treatment_any_regnew_auto + [temp_4_mean]treatment_any_regnew_auto) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_automatically + [temp_2_mean]register_new_automatically + [temp_1_mean]treatment_any_regnew_auto + [temp_2_mean]treatment_any_regnew_auto) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_automatically + [temp_2_mean]register_new_automatically + [temp_1_mean]treatment_any_regnew_auto + [temp_2_mean]treatment_any_regnew_auto) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_automatically + [temp_4_mean]register_new_automatically) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_automatically + [temp_2_mean]register_new_automatically) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_automatically + [temp_2_mean]register_new_automatically) / 2))), post

/* 
* End of table A6 - last line, columns 2 and 3 *
Taking all category and calulation weighted average of Canvassing and Home Registration
Difference between newly reg. citizens in treatment groups and control group, controlling for initial registration status
*/
est restore temp_R02
eststo temp_R9 : nlcom prop_regnew_unreg * (((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_unreg + 2*[temp_4_mean]register_new_unreg + [temp_3_mean]treatment_EC_regnew_unreg + [temp_4_mean]treatment_EC_regnew_unreg + [temp_3_mean]treatment_LC_regnew_unreg + [temp_4_mean]treatment_LC_regnew_unreg) / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_unreg + 2*[temp_2_mean]register_new_unreg + [temp_1_mean]treatment_EC_regnew_unreg + [temp_2_mean]treatment_EC_regnew_unreg + [temp_1_mean]treatment_LC_regnew_unreg + [temp_2_mean]treatment_LC_regnew_unreg) / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_unreg + 2*[temp_2_mean]register_new_unreg + [temp_1_mean]treatment_EC_regnew_unreg + [temp_2_mean]treatment_EC_regnew_unreg + [temp_1_mean]treatment_LC_regnew_unreg + [temp_2_mean]treatment_LC_regnew_unreg) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_unreg + [temp_4_mean]register_new_unreg) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_unreg + [temp_2_mean]register_new_unreg) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_unreg + [temp_2_mean]register_new_unreg) / 2))) + prop_regnew_othcity * (((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_othcity + 2*[temp_4_mean]register_new_othcity + [temp_3_mean]treatment_EC_regnew_othcity + [temp_4_mean]treatment_EC_regnew_othcity + [temp_3_mean]treatment_LC_regnew_othcity + [temp_4_mean]treatment_LC_regnew_othcity) / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_othcity + 2*[temp_2_mean]register_new_othcity + [temp_1_mean]treatment_EC_regnew_othcity + [temp_2_mean]treatment_EC_regnew_othcity + [temp_1_mean]treatment_LC_regnew_othcity + [temp_2_mean]treatment_LC_regnew_othcity) / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_othcity + 2*[temp_2_mean]register_new_othcity + [temp_1_mean]treatment_EC_regnew_othcity + [temp_2_mean]treatment_EC_regnew_othcity + [temp_1_mean]treatment_LC_regnew_othcity + [temp_2_mean]treatment_LC_regnew_othcity) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_othcity + [temp_4_mean]register_new_othcity) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_othcity + [temp_2_mean]register_new_othcity) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_othcity + [temp_2_mean]register_new_othcity) / 2))) + prop_regnew_city * (((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_city + 2*[temp_4_mean]register_new_city + [temp_3_mean]treatment_EC_regnew_city + [temp_4_mean]treatment_EC_regnew_city + [temp_3_mean]treatment_LC_regnew_city + [temp_4_mean]treatment_LC_regnew_city) / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_city + 2*[temp_2_mean]register_new_city + [temp_1_mean]treatment_EC_regnew_city + [temp_2_mean]treatment_EC_regnew_city + [temp_1_mean]treatment_LC_regnew_city + [temp_2_mean]treatment_LC_regnew_city) / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_city + 2*[temp_2_mean]register_new_city + [temp_1_mean]treatment_EC_regnew_city + [temp_2_mean]treatment_EC_regnew_city + [temp_1_mean]treatment_LC_regnew_city + [temp_2_mean]treatment_LC_regnew_city) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_city + [temp_4_mean]register_new_city) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_city + [temp_2_mean]register_new_city) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_city + [temp_2_mean]register_new_city) / 2))) + prop_regnew_auto * (((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_automatically + 2*[temp_4_mean]register_new_automatically + [temp_3_mean]treatment_EC_regnew_auto + [temp_4_mean]treatment_EC_regnew_auto + [temp_3_mean]treatment_LC_regnew_auto + [temp_4_mean]treatment_LC_regnew_auto) / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_automatically + 2*[temp_2_mean]register_new_automatically + [temp_1_mean]treatment_EC_regnew_auto + [temp_2_mean]treatment_EC_regnew_auto + [temp_1_mean]treatment_LC_regnew_auto + [temp_2_mean]treatment_LC_regnew_auto) / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_automatically + 2*[temp_2_mean]register_new_automatically + [temp_1_mean]treatment_EC_regnew_auto + [temp_2_mean]treatment_EC_regnew_auto + [temp_1_mean]treatment_LC_regnew_auto + [temp_2_mean]treatment_LC_regnew_auto) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_automatically + [temp_4_mean]register_new_automatically) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_automatically + [temp_2_mean]register_new_automatically) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_automatically + [temp_2_mean]register_new_automatically) / 2))), post
est restore temp_R02
eststo temp_R10 : nlcom prop_regnew_unreg * (((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_unreg + 2*[temp_4_mean]register_new_unreg + [temp_3_mean]treatment_ER_regnew_unreg + [temp_4_mean]treatment_ER_regnew_unreg + [temp_3_mean]treatment_LR_regnew_unreg + [temp_4_mean]treatment_LR_regnew_unreg) / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_unreg + 2*[temp_2_mean]register_new_unreg + [temp_1_mean]treatment_ER_regnew_unreg + [temp_2_mean]treatment_ER_regnew_unreg + [temp_1_mean]treatment_LR_regnew_unreg + [temp_2_mean]treatment_LR_regnew_unreg) / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_unreg + 2*[temp_2_mean]register_new_unreg + [temp_1_mean]treatment_ER_regnew_unreg + [temp_2_mean]treatment_ER_regnew_unreg + [temp_1_mean]treatment_LR_regnew_unreg + [temp_2_mean]treatment_LR_regnew_unreg) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_unreg + [temp_4_mean]register_new_unreg) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_unreg + [temp_2_mean]register_new_unreg) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_unreg + [temp_2_mean]register_new_unreg) / 2))) + prop_regnew_othcity * (((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_othcity + 2*[temp_4_mean]register_new_othcity + [temp_3_mean]treatment_ER_regnew_othcity + [temp_4_mean]treatment_ER_regnew_othcity + [temp_3_mean]treatment_LR_regnew_othcity + [temp_4_mean]treatment_LR_regnew_othcity) / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_othcity + 2*[temp_2_mean]register_new_othcity + [temp_1_mean]treatment_ER_regnew_othcity + [temp_2_mean]treatment_ER_regnew_othcity + [temp_1_mean]treatment_LR_regnew_othcity + [temp_2_mean]treatment_LR_regnew_othcity) / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_othcity + 2*[temp_2_mean]register_new_othcity + [temp_1_mean]treatment_ER_regnew_othcity + [temp_2_mean]treatment_ER_regnew_othcity + [temp_1_mean]treatment_LR_regnew_othcity + [temp_2_mean]treatment_LR_regnew_othcity) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_othcity + [temp_4_mean]register_new_othcity) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_othcity + [temp_2_mean]register_new_othcity) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_othcity + [temp_2_mean]register_new_othcity) / 2))) + prop_regnew_city * (((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_city + 2*[temp_4_mean]register_new_city + [temp_3_mean]treatment_ER_regnew_city + [temp_4_mean]treatment_ER_regnew_city + [temp_3_mean]treatment_LR_regnew_city + [temp_4_mean]treatment_LR_regnew_city) / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_city + 2*[temp_2_mean]register_new_city + [temp_1_mean]treatment_ER_regnew_city + [temp_2_mean]treatment_ER_regnew_city + [temp_1_mean]treatment_LR_regnew_city + [temp_2_mean]treatment_LR_regnew_city) / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_city + 2*[temp_2_mean]register_new_city + [temp_1_mean]treatment_ER_regnew_city + [temp_2_mean]treatment_ER_regnew_city + [temp_1_mean]treatment_LR_regnew_city + [temp_2_mean]treatment_LR_regnew_city) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_city + [temp_4_mean]register_new_city) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_city + [temp_2_mean]register_new_city) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_city + [temp_2_mean]register_new_city) / 2))) + prop_regnew_auto * (((2*[temp_3_mean]_cons + 2*[temp_4_mean]_cons + 2*[temp_3_mean]register_new_automatically + 2*[temp_4_mean]register_new_automatically + [temp_3_mean]treatment_ER_regnew_auto + [temp_4_mean]treatment_ER_regnew_auto + [temp_3_mean]treatment_LR_regnew_auto + [temp_4_mean]treatment_LR_regnew_auto) / 2 - (2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_automatically + 2*[temp_2_mean]register_new_automatically + [temp_1_mean]treatment_ER_regnew_auto + [temp_2_mean]treatment_ER_regnew_auto + [temp_1_mean]treatment_LR_regnew_auto + [temp_2_mean]treatment_LR_regnew_auto) / 2) / ((2*[temp_1_mean]_cons + 2*[temp_2_mean]_cons + 2*[temp_1_mean]register_new_automatically + 2*[temp_2_mean]register_new_automatically + [temp_1_mean]treatment_ER_regnew_auto + [temp_2_mean]treatment_ER_regnew_auto + [temp_1_mean]treatment_LR_regnew_auto + [temp_2_mean]treatment_LR_regnew_auto) / 2) - ((([temp_3_mean]_cons + [temp_4_mean]_cons + [temp_3_mean]register_new_automatically + [temp_4_mean]register_new_automatically) / 2 - ([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_automatically + [temp_2_mean]register_new_automatically) / 2) / (([temp_1_mean]_cons + [temp_2_mean]_cons + [temp_1_mean]register_new_automatically + [temp_2_mean]register_new_automatically) / 2))), post

estout temp_R4 temp_R9 temp_R10 using "$appendix/TableA6_DeclineTurnout.xls", append cells(b(label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Difference between newly reg. citizens in treatment groups and control group, controlling for initial registration status") mlabel("All Treatment" "Canvassing" "Home Registration")

estimates clear

* TABLE A8 *

use "Registration&Turnout_Analyse.dta", clear

*Impact on the participation of already registered voters
*All people registered at this address prior to the visit pooled together: previously registered, newly registered registered before the start of the experiment
keep if ((register_2011 == 1 & register_2012 == 1) | (register_new == 1 & register_date_2012 ~= . & register_date_2012 < treatment_earlyvisit_startdate & register_motive_2012 ~= "Inscription d'office")) & sample_household == 1

su vote_pres_1st if treatment_groups == "Control"
local mean_control=r(mean)
ivreg2 vote_pres_1st treatment_any indiv_gender indiv_age register_1112_hh address_totalmailbox ${controlsstrate}, cl(cluster) 
quietly outreg2 using "$appendix\TableA8_ImpactPreviouslyRegistered.xls", nonote se replace nolabel addstat("control mean", `mean_control') adec(3) bdec(3)

foreach var of varlist vote_pres_2nd vote_leg_1st vote_leg_2nd vote_average vote_any {
su `var' if treatment_groups == "Control"
local mean_control=r(mean)
ivreg2 `var' treatment_any indiv_gender indiv_age register_1112_hh address_totalmailbox ${controlsstrate}, cl(cluster) 
quietly outreg2 using "$appendix\TableA8_ImpactPreviouslyRegistered.xls", nonote se append nolabel addstat("control mean", `mean_control') adec(3) bdec(3)
}

* TABLE A9 *

use "Registration&Turnout_Analyse.dta", clear

*Checking the characteristics of newly registered citizens in apartments which opened their door for a late home registration visit
keep if register_new == 1 & sample_household == 1 & treatment_latevisit == 1 & (treatment_ECLR == 1 | treatment_ERLR == 1)

* Similarity of individual types between ECLR and ERLR
ivreg2 indiv_gender treatment_ERLR if (treatment_ECLR == 1 | treatment_ERLR == 1), cl(cluster)
quietly outreg2 using "$appendix\TableA9_CharacteristicsERLR.xls", se replace nolabel bdec(3)

foreach var of varlist indiv_age indiv_birth_abroad address_newnames address_totalmailbox {
ivreg2 `var' treatment_ERLR if (treatment_ECLR == 1 | treatment_ERLR == 1), cl(cluster)
quietly outreg2 using "$appendix\TableA9_CharacteristicsERLR.xls", se append nolabel bdec(3)
}

* TABLE A10 *

use "Survey_Analyse.dta", clear

ivreg2 pol_general_index treatment_any, cl(cluster_s) 
outreg2 using "$appendix\TableA10_ImpactPoliticizationIndex.xls",nonote se replace nolabel bdec(3)
ivreg2 pol_general_index treatment_any ${controlsind}, cl(cluster_s) 
quietly outreg2 using "$appendix\TableA10_ImpactPoliticizationIndex.xls",nonote se append nolabel bdec(3)
ivreg2 pol_general_index treatment_EC treatment_LC treatment_ER treatment_LR treatment_ECLR treatment_ERLR, cl(cluster_s) 
quietly outreg2 using "$appendix\TableA10_ImpactPoliticizationIndex.xls",nonote se append nolabel bdec(3)
estimates store temp_store1
ivreg2 pol_general_index treatment_EC treatment_LC treatment_ER treatment_LR treatment_ECLR treatment_ERLR ${controlsind}, cl(cluster_s) 
quietly outreg2 using "$appendix\TableA10_ImpactPoliticizationIndex.xls",nonote se append nolabel bdec(3)
estimates store temp_store2


forvalues k=1/2 {
local temp_meter=4
foreach z in "(treatment_EC + treatment_LC + treatment_ER + treatment_LR + treatment_ECLR + treatment_ERLR)/6" "(treatment_EC + treatment_LC)/2" "(treatment_ER + treatment_LR)/2" "(treatment_ECLR + treatment_ERLR)/2" {
	forvalue i=1/4 {
	if `temp_meter'==`i' {
			estimates restore temp_store`k'
			lincomest `z'
			estimates store temp_`k'`temp_meter'
}
}
			local temp_meter=`temp_meter'-1
}
}

estout temp_13 temp_12 temp_11 using "$appendix/TableA10_LinearCombinationsOfEstimates.xls", replace cells(b( label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Index of politicization (Individual controls: No)") mlabel("(EC + LC)/2" "(ER+LR)/2" "(ECLR+ERLR)/2") stats(N)
estout temp_23 temp_22 temp_21 using "$appendix/TableA10_LinearCombinationsOfEstimates.xls", append cells(b( label("coef") fmt(%9.3f)) se(s par)) starlevels(* 0.1 ** 0.05 *** 0.01) title("Index of politicization (Individual controls: Yes)") mlabel("(EC + LC)/2" "(ER+LR)/2" "(ECLR+ERLR)/2") stats(N)


* TABLE A11 *

use "Survey_Analyse.dta", clear

local R1 "A1_gender indiv_survey_age indiv_survey_age2 A4_unemployed A4_inactive A10_nodegree A10_degree_infbac A10_degree_bac address_householdsize A14_nocouple A15_french_few A15_french_never A17_tenant_social A17_tenant_private A18_Income_inf700 A18_Income_inf1100 A18_Income_sup1500 A20_live_inf2 A20_live_inf5 A20_live_inf10 indiv_birth_abroad A25_otherdep A27_naturalization A29_othernationality F1_nonbeliever F3_practice_rare A7_tooearly A8_toolate"
local R3 "A1_gender_treat indiv_survey_age_treat indiv_survey_age2_treat A4_unemployed_treat A4_inactive_treat A10_nodegree_treat A10_degree_infbac_treat A10_degree_bac_treat address_householdsize_treat A14_nocouple_treat A15_french_few_treat A15_french_never_treat A17_tenant_social_treat A17_tenant_private_treat A18_Income_inf700_treat A18_Income_inf1100_treat A18_Income_sup1500_treat A20_live_inf2_treat A20_live_inf5_treat A20_live_inf10_treat indiv_birth_abroad_treat A25_otherdep_treat A27_naturalization_treat A29_othernationality_treat F1_nonbeliever_treat F3_practice_rare_treat A7_tooearly_treat A8_toolate_treat"
local R8 "A1_gender indiv_survey_age indiv_survey_age2 A4_unemployed A4_inactive A10_nodegree A10_degree_infbac A10_degree_bac address_householdsize A14_nocouple A15_french_few A15_french_never A17_tenant_social A17_tenant_private A18_Income_inf700 A18_Income_inf1100 A18_Income_sup1500 A20_live_inf2 A20_live_inf5 A20_live_inf10 indiv_birth_abroad A25_otherdep A27_naturalization A29_othernationality F1_nonbeliever F3_practice_rare A7_tooearly A8_toolate"
local R10 "A1_gender_canv indiv_survey_age_canv indiv_survey_age2_canv A4_unemployed_canv A4_inactive_canv A10_nodegree_canv A10_degree_infbac_canv A10_degree_bac_canv address_householdsize_canv A14_nocouple_canv A15_french_few_canv A15_french_never_canv A17_tenant_social_canv A17_tenant_private_canv A18_Income_inf700_canv A18_Income_inf1100_canv A18_Income_sup1500_canv A20_live_inf2_canv A20_live_inf5_canv A20_live_inf10_canv indiv_birth_abroad_canv A25_otherdep_canv A27_naturalization_canv A29_othernationality_canv F1_nonbeliever_canv F3_practice_rare_canv A7_tooearly_canv A8_toolate_canv"
local R12 "A1_gender_home indiv_survey_age_home indiv_survey_age2_home A4_unemployed_home A4_inactive_home A10_nodegree_home A10_degree_infbac_home A10_degree_bac_home address_householdsize_home A14_nocouple_home A15_french_few_home A15_french_never_home A17_tenant_social_home A17_tenant_private_home A18_Income_inf700_home A18_Income_inf1100_home A18_Income_sup1500_home A20_live_inf2_home A20_live_inf5_home A20_live_inf10_home indiv_birth_abroad_home A25_otherdep_home A27_naturalization_home A29_othernationality_home F1_nonbeliever_home F3_practice_rare_home A7_tooearly_home A8_toolate_home"
local R14 "A1_gender_double indiv_survey_age_double indiv_survey_age2_double A4_unemployed_double A4_inactive_double A10_nodegree_double A10_degree_infbac_double A10_degree_bac_double address_householdsize_double A14_nocouple_double A15_french_few_double A15_french_never_double A17_tenant_social_double A17_tenant_private_double A18_Income_inf700_double A18_Income_inf1100_double A18_Income_sup1500_double A20_live_inf2_double A20_live_inf5_double A20_live_inf10_double indiv_birth_abroad_double A25_otherdep_double A27_naturalization_double A29_othernationality_double F1_nonbeliever_double F3_practice_rare_double A7_tooearly_double A8_toolate_double"

local RegA "A1_gender indiv_survey_age indiv_survey_age2 A4_unemployed A4_inactive A10_nodegree A10_degree_infbac A10_degree_bac address_householdsize A14_nocouple A15_french_few A15_french_never A17_tenant_social A17_tenant_private A18_Income_inf700 A18_Income_inf1100 A18_Income_sup1500 A20_live_inf2 A20_live_inf5 A20_live_inf10 indiv_birth_abroad A25_otherdep A27_naturalization A29_othernationality F1_nonbeliever F3_practice_rare A7_tooearly A8_toolate A1_gender_treat indiv_survey_age_treat indiv_survey_age2_treat A4_unemployed_treat A4_inactive_treat A10_nodegree_treat A10_degree_infbac_treat A10_degree_bac_treat address_householdsize_treat A14_nocouple_treat A15_french_few_treat A15_french_never_treat A17_tenant_social_treat A17_tenant_private_treat A18_Income_inf700_treat A18_Income_inf1100_treat A18_Income_sup1500_treat A20_live_inf2_treat A20_live_inf5_treat A20_live_inf10_treat indiv_birth_abroad_treat A25_otherdep_treat A27_naturalization_treat A29_othernationality_treat F1_nonbeliever_treat F3_practice_rare_treat A7_tooearly_treat A8_toolate_treat treatment_any"
local RegB "A1_gender indiv_survey_age indiv_survey_age2 A4_unemployed A4_inactive A10_nodegree A10_degree_infbac A10_degree_bac address_householdsize A14_nocouple A15_french_few A15_french_never A17_tenant_social A17_tenant_private A18_Income_inf700 A18_Income_inf1100 A18_Income_sup1500 A20_live_inf2 A20_live_inf5 A20_live_inf10 indiv_birth_abroad A25_otherdep A27_naturalization A29_othernationality F1_nonbeliever F3_practice_rare A7_tooearly A8_toolate A1_gender_canv indiv_survey_age_canv indiv_survey_age2_canv A4_unemployed_canv A4_inactive_canv A10_nodegree_canv A10_degree_infbac_canv A10_degree_bac_canv address_householdsize_canv A14_nocouple_canv A15_french_few_canv A15_french_never_canv A17_tenant_social_canv A17_tenant_private_canv A18_Income_inf700_canv A18_Income_inf1100_canv A18_Income_sup1500_canv A20_live_inf2_canv A20_live_inf5_canv A20_live_inf10_canv indiv_birth_abroad_canv A25_otherdep_canv A27_naturalization_canv A29_othernationality_canv F1_nonbeliever_canv F3_practice_rare_canv A7_tooearly_canv A8_toolate_canv A1_gender_home indiv_survey_age_home indiv_survey_age2_home A4_unemployed_home A4_inactive_home A10_nodegree_home A10_degree_infbac_home A10_degree_bac_home address_householdsize_home A14_nocouple_home A15_french_few_home A15_french_never_home A17_tenant_social_home A17_tenant_private_home A18_Income_inf700_home A18_Income_inf1100_home A18_Income_sup1500_home A20_live_inf2_home A20_live_inf5_home A20_live_inf10_home indiv_birth_abroad_home A25_otherdep_home A27_naturalization_home A29_othernationality_home F1_nonbeliever_home F3_practice_rare_home A7_tooearly_home A8_toolate_home A1_gender_double indiv_survey_age_double indiv_survey_age2_double A4_unemployed_double A4_inactive_double A10_nodegree_double A10_degree_infbac_double A10_degree_bac_double address_householdsize_double A14_nocouple_double A15_french_few_double A15_french_never_double A17_tenant_social_double A17_tenant_private_double A18_Income_inf700_double A18_Income_inf1100_double A18_Income_sup1500_double A20_live_inf2_double A20_live_inf5_double A20_live_inf10_double indiv_birth_abroad_double A25_otherdep_double A27_naturalization_double A29_othernationality_double F1_nonbeliever_double F3_practice_rare_double A7_tooearly_double A8_toolate_double treatment_canvassing treatment_home treatment_double"

foreach z in reg_city register_any reg_address vote_average vote_any {
gen `z'_o=.
gen `z'_star=""
foreach w in RegA RegB {
gen `w'="`w'"
ivreg2 `z' ``w'', cl(cluster_s)
if `w'=="RegA" {
foreach k in 1 3 {
* Test of joint significance of all characteristics in Panel A
test `R`k''

replace `z'_o=r(chi2) if _n==`k'
replace `z'_o=r(p) if _n==`k'+1
replace `z'_o=round(`z'_o,0.1) if _n==`k'
replace `z'_o=round(`z'_o,0.001) if _n==`k'+1
replace `z'_star="*" if `z'_o<0.1 & _n==`k'+1
replace `z'_star="**" if `z'_o<0.05 & _n==`k'+1
replace `z'_star="***" if `z'_o<0.01 & _n==`k'+1
replace `z'_o=e(N) if _n==5
replace `z'_o=e(r2) if _n==6
}
}
if `w'=="RegB" {
foreach k in 8 10 12 14 {
* Test of joint significance of all characteristics in Panel B
test `R`k''

replace `z'_o=r(chi2) if _n==`k'
replace `z'_o=r(p) if _n==`k'+1
replace `z'_o=round(`z'_o,0.1) if _n==`k'
replace `z'_o=round(`z'_o,0.001) if _n==`k'+1
replace `z'_star="*" if `z'_o<0.1 & _n==`k'+1
replace `z'_star="**" if `z'_o<0.05 & _n==`k'+1
replace `z'_star="***" if `z'_o<0.01 & _n==`k'+1
replace `z'_o=e(N) if _n==20
replace `z'_o=e(r2) if _n==21
}
ivreg2 `z' ``w'', cl(cluster_s)
foreach var of varlist A1_gender indiv_survey_age indiv_survey_age2 A4_unemployed A4_inactive A10_nodegree A10_degree_infbac A10_degree_bac address_householdsize A14_nocouple A15_french_few A15_french_never A17_tenant_social A17_tenant_private A18_Income_inf700 A18_Income_inf1100 A18_Income_sup1500 A20_live_inf2 A20_live_inf5 A20_live_inf10 indiv_birth_abroad A25_otherdep A27_naturalization A29_othernationality F1_nonbeliever F3_practice_rare A7_tooearly A8_toolate {
* Test of joint significance of the difference between charateristics interacted with treatment dummies
test `var'_home=`var'_canv, acc

replace `z'_o=r(chi2) if _n==16
replace `z'_o=r(p) if _n==17
replace `z'_o=round(`z'_o,0.1) if _n==16
replace `z'_o=round(`z'_o,0.001) if _n==17
}
ivreg2 `z' ``w'', cl(cluster_s)
foreach var of varlist A1_gender indiv_survey_age indiv_survey_age2 A4_unemployed A4_inactive A10_nodegree A10_degree_infbac A10_degree_bac address_householdsize A14_nocouple A15_french_few A15_french_never A17_tenant_social A17_tenant_private A18_Income_inf700 A18_Income_inf1100 A18_Income_sup1500 A20_live_inf2 A20_live_inf5 A20_live_inf10 indiv_birth_abroad A25_otherdep A27_naturalization A29_othernationality F1_nonbeliever F3_practice_rare A7_tooearly A8_toolate {
test `var'_double=`var'_home, acc

replace `z'_o=r(chi2) if _n==18
replace `z'_o=r(p) if _n==19
replace `z'_o=round(`z'_o,0.1) if _n==18
replace `z'_o=round(`z'_o,0.001) if _n==19
replace `z'_star="*" if `z'_o<0.1 & _n==19
replace `z'_star="**" if `z'_o<0.05 & _n==19
replace `z'_star="***" if `z'_o<0.01 & _n==19
}
}
drop `w'
}
replace `z'_o=round(`z'_o,0.01) if _n==21 | _n==6
gen `z'_=string(`z'_o)
foreach k in 2 4 9 11 13 15 17 19 {
replace `z'_=`z'_+`z'_star if _n==`k'
replace `z'_=subinstr(`z'_,".","0.",1) if strpos(`z'_,".")==1
replace `z'_="" if _n>21
replace `z'_="" if _n==7

}
drop `z'_o
drop `z'_star
}

gen TableA11="(A) Constant" if _n==1
replace TableA11="(A) Any treatment group" if _n==3
replace TableA11="Observations" if _n==5
replace TableA11="R-squared" if _n==6
replace TableA11="(B) Constant" if _n==8
replace TableA11="(B) Door-to-door canvassing group" if _n==10
replace TableA11="(B) Home registration group" if _n==12
replace TableA11="(B) Two visits group" if _n==14
replace TableA11="(B) Home - Canv" if _n==16
replace TableA11="(B) Double - Home" if _n==18
replace TableA11="Observations" if _n==20
replace TableA11="R-squared" if _n==21

outsheet TableA11 reg_city_ register_any_ reg_address_ vote_average_ vote_any_ if _n<=21 using "$appendix\TableA11_ImpactOnSelection.xls",replace

* TABLE A12, PANEL A *

use "Survey_Analyse.dta", clear

* Voter left prediction using available variables for all the dataset
ivreg2 left A1_gender indiv_survey_age indiv_birth_abroad, cl(cluster_s)
quietly outreg2 using "$appendix\TableA12_PanelA_PredictorsVoteLeft.xls",nonote se replace nolabel bdec(3)
mat beta=e(b)
global left_g=beta[1,1]
global left_a=beta[1,2]
global left_b=beta[1,3]
global left_c=beta[1,4]


foreach var of varlist vote_left_pres_1st vote_left_pres_2nd vote_left_leg_1st vote_left_leg_2nd {
ivreg2 `var' A1_gender indiv_survey_age indiv_birth_abroad, cl(cluster_s)
quietly outreg2 using "$appendix\TableA12_PanelA_PredictorsVoteLeft.xls",nonote se append nolabel bdec(3)
mat beta=e(b)
global `var'_g=beta[1,1]
global `var'_a=beta[1,2]
global `var'_b=beta[1,3]
global `var'_c=beta[1,4]
}

* TABLE A12, PANEL A, robustness check *

use "Survey_Analyse.dta", clear

*This tests the robustness of the results to excluding precincts covered by partisan canvassers (mentioned in Online Appendix, p. 10)
ivreg2 left A1_gender indiv_survey_age indiv_birth_abroad if visitor_activist ~= 1, cl(cluster_s)
quietly outreg2 using "$appendix\TableA12_PanelA_PredictorsVoteLeft_RobustCheck.xls",nonote se replace nolabel bdec(3)
mat beta=e(b)
global leftR_g=beta[1,1]
global leftR_a=beta[1,2]
global leftR_b=beta[1,3]
global leftR_c=beta[1,4]

foreach var of varlist vote_left_pres_1st vote_left_pres_2nd vote_left_leg_1st vote_left_leg_2nd {
ivreg2 `var' A1_gender indiv_survey_age indiv_birth_abroad if visitor_activist ~= 1, cl(cluster_s)
quietly outreg2 using "$appendix\TableA12_PanelA_PredictorsVoteLeft_RobustCheck.xls",nonote se append nolabel bdec(3)
mat beta=e(b)
global `var'R_g=beta[1,1]
global `var'R_a=beta[1,2]
global `var'R_b=beta[1,3]
global `var'R_c=beta[1,4]
}

* Left/Right position and vote choice prediction using characteristics of respondents to Political Survey.
use "Registration&Turnout_Analyse.dta", clear

gen left= $left_c + indiv_gender * ($left_g ) + indiv_age_bis * ($left_a ) + indiv_birth_abroad * $left_b
gen vote_left_pres_1st= $vote_left_pres_1st_c + indiv_gender * ($vote_left_pres_1st_g ) + indiv_age_bis * ($vote_left_pres_1st_a ) + indiv_birth_abroad * $vote_left_pres_1st_b
gen vote_left_pres_2nd= $vote_left_pres_2nd_c + indiv_gender * ($vote_left_pres_2nd_g ) + indiv_age_bis * ($vote_left_pres_2nd_a ) + indiv_birth_abroad * $vote_left_pres_2nd_b
gen vote_left_leg_1st= $vote_left_leg_1st_c + indiv_gender * ($vote_left_leg_1st_g ) + indiv_age_bis * ($vote_left_leg_1st_a ) + indiv_birth_abroad * $vote_left_leg_1st_b
gen vote_left_leg_2nd= $vote_left_leg_2nd_c + indiv_gender * ($vote_left_leg_2nd_g ) + indiv_age_bis * ($vote_left_leg_2nd_a ) + indiv_birth_abroad * $vote_left_leg_2nd_b

gen left_R= $leftR_c + indiv_gender * ($leftR_g ) + indiv_age_bis * ($leftR_a ) + indiv_birth_abroad * $leftR_b
gen vote_left_pres_1st_R= $vote_left_pres_1stR_c + indiv_gender * ($vote_left_pres_1stR_g ) + indiv_age_bis * ($vote_left_pres_1stR_a ) + indiv_birth_abroad * $vote_left_pres_1stR_b
gen vote_left_pres_2nd_R= $vote_left_pres_2ndR_c + indiv_gender * ($vote_left_pres_2ndR_g ) + indiv_age_bis * ($vote_left_pres_2ndR_a ) + indiv_birth_abroad * $vote_left_pres_2ndR_b
gen vote_left_leg_1st_R= $vote_left_leg_1stR_c + indiv_gender * ($vote_left_leg_1stR_g ) + indiv_age_bis * ($vote_left_leg_1stR_a ) + indiv_birth_abroad * $vote_left_leg_1stR_b
gen vote_left_leg_2nd_R= $vote_left_leg_2ndR_c + indiv_gender * ($vote_left_leg_2ndR_g ) + indiv_age_bis * ($vote_left_leg_2ndR_a ) + indiv_birth_abroad * $vote_left_leg_2ndR_b

* TABLE A12, PANEL B *

* Selection of political preferences
keep if register_2012 == 1 & sample_address == 1
ivreg2 left treatment_any_register_new register_new if register_2012 == 1 & sample_address == 1 & (address_city == "Cergy" | address_city == "Sevran" | address_city == "SaintDenis" | address_city == "Montpellier"), cl(cluster)
quietly outreg2 using "$appendix\TableA12_PanelB_PoliticalPrefs.xls", nonote se replace nolabel bdec(3)

ivreg2 vote_left_pres_1st treatment_any_register_new register_new if register_2012 == 1 & sample_address == 1 & vote_pres_1st == 1 & (address_city == "Cergy" | address_city == "Sevran" | address_city == "SaintDenis" | address_city == "Montpellier"), cl(cluster)
quietly outreg2 using "$appendix\TableA12_PanelB_PoliticalPrefs.xls", nonote se append nolabel bdec(3)
ivreg2 vote_left_pres_2nd treatment_any_register_new register_new if register_2012 == 1 & sample_address == 1 & vote_pres_2nd == 1 & (address_city == "Cergy" | address_city == "Sevran" | address_city == "SaintDenis" | address_city == "Montpellier"), cl(cluster)
quietly outreg2 using "$appendix\TableA12_PanelB_PoliticalPrefs.xls", nonote se append nolabel bdec(3)
ivreg2 vote_left_leg_1st treatment_any_register_new register_new if register_2012 == 1 & sample_address == 1 & vote_leg_1st == 1 & (address_city == "Cergy" | address_city == "Sevran" | address_city == "SaintDenis" | address_city == "Montpellier"), cl(cluster)
quietly outreg2 using "$appendix\TableA12_PanelB_PoliticalPrefs.xls", nonote se append nolabel bdec(3)

ivreg2 vote_left_leg_2nd treatment_any_register_new register_new if register_2012 == 1 & sample_address == 1 & vote_leg_2nd == 1 & (address_city == "Cergy" | address_city == "Montpellier"), cl(cluster)
quietly outreg2 using "$appendix\TableA12_PanelB_PoliticalPrefs.xls", nonote se append nolabel bdec(3)

* TABLE A12, PANEL B, robustness check *

*This tests the robustness of the results to excluding precincts covered by partisan canvassers (mentioned in Online Appendix, p. 10)
ivreg2 left treatment_any_register_new register_new if register_2012 == 1 & sample_address == 1 & ((address_city == "Cergy" & address_pollingstation_id ~= 1 & address_pollingstation_id ~= 6 & address_pollingstation_id ~= 15 & address_pollingstation_id ~= 29) | address_city == "SaintDenis" | address_city == "Montpellier"), cl(cluster)
quietly outreg2 using "$appendix\TableA12_PanelB_PoliticalPrefs_RobustCheck.xls", nonote se replace nolabel bdec(3)
ivreg2 vote_left_pres_1st_R treatment_any_register_new register_new if register_2012 == 1 & sample_address == 1 & vote_pres_1st == 1 & ((address_city == "Cergy" & address_pollingstation_id ~= 1 & address_pollingstation_id ~= 6 & address_pollingstation_id ~= 15 & address_pollingstation_id ~= 29) | address_city == "SaintDenis" | address_city == "Montpellier"), cl(cluster)
quietly outreg2 using "$appendix\TableA12_PanelB_PoliticalPrefs_RobustCheck.xls", nonote se append nolabel bdec(3)
ivreg2 vote_left_pres_2nd_R treatment_any_register_new register_new if register_2012 == 1 & sample_address == 1 & vote_pres_2nd == 1 & ((address_city == "Cergy" & address_pollingstation_id ~= 1 & address_pollingstation_id ~= 6 & address_pollingstation_id ~= 15 & address_pollingstation_id ~= 29) | address_city == "SaintDenis" | address_city == "Montpellier"), cl(cluster)
quietly outreg2 using "$appendix\TableA12_PanelB_PoliticalPrefs_RobustCheck.xls", nonote se append nolabel bdec(3)
ivreg2 vote_left_leg_1st_R treatment_any_register_new register_new if register_2012 == 1 & sample_address == 1 & vote_leg_1st == 1 & ((address_city == "Cergy" & address_pollingstation_id ~= 1 & address_pollingstation_id ~= 6 & address_pollingstation_id ~= 15 & address_pollingstation_id ~= 29) | address_city == "SaintDenis" | address_city == "Montpellier"), cl(cluster)
quietly outreg2 using "$appendix\TableA12_PanelB_PoliticalPrefs_RobustCheck.xls", nonote se append nolabel bdec(3)
ivreg2 vote_left_leg_2nd_R treatment_any_register_new register_new if register_2012 == 1 & sample_address == 1 & vote_leg_2nd == 1 & ((address_city == "Cergy" & address_pollingstation_id ~= 1 & address_pollingstation_id ~= 6 & address_pollingstation_id ~= 15 & address_pollingstation_id ~= 29) | address_city == "SaintDenis" | address_city == "Montpellier"), cl(cluster)
quietly outreg2 using "$appendix\TableA12_PanelB_PoliticalPrefs_RobustCheck.xls", nonote se append nolabel bdec(3)

****************************

** Removing .txt files from the appendix directory :
cd "${appendix}"

local datafiles: dir "`appendix'" files "*.txt"
foreach datafile of local datafiles {
        rm `datafile'
}

****************************
