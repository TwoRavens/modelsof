clear
version 14.2
set more off
** Name: Survey_VarCreation.do
** Date Created: 06/15/2017 by Christophe Misner (cmisner@povertyactionlab.org)
** Last Updated: 

* Data In: [Survey.dta]
* Data Out: [Survey_Analyse.dta]

* Purpose of do-file: Creating new variables for analysis

set mem 4g
set more off


* Setting file path

*global DIRECTORY "..."
global data "${DIRECTORY}/Data"

cd "${data}"

* Opening dataset

use "Survey.dta", clear

* Gen x99 & x97 vars

foreach var of varlist _all {
capture confirm numeric variable `var'
if !_rc {
gen `var'x99= `var'==.d
gen `var'x97= `var'==.r
replace `var'=. if `var'==.d
replace `var'=. if `var'==.r
}
}
foreach var of varlist _all {
capture confirm string variable `var'
if !_rc {
gen `var'x99= `var'=="don't know"
gen `var'x97= `var'=="refusal"
replace `var'="" if `var'=="don't know"
replace `var'="" if `var'=="refusal"
}
}

foreach z in T_ visitor surveyor date cluster {
drop `z'*x99 `z'*x97
}

*Said to be register
gen register_any = (B1_reg== 1)
replace register_any = . if B1_reg== .

*Treatment type
gen treatment_any = (treatment_groups ~= "Control")
gen treatment_canvassing = (treatment_groups == "Early Canvassing" | treatment_groups == "Late Canvassing")
gen treatment_home = (treatment_groups == "Early home Registration" | treatment_groups == "Late home Registration")
gen treatment_double = (treatment_groups == "Early Canvassing and Late home Registration" | treatment_groups == "Early home Registration and Late home Registration")
gen treatment_EC = (treatment_groups == "Early Canvassing")
gen treatment_LC = (treatment_groups == "Late Canvassing")
gen treatment_ER = (treatment_groups == "Early home Registration")
gen treatment_LR = (treatment_groups == "Late home Registration")
gen treatment_ECLR = (treatment_groups == "Early Canvassing and Late home Registration")
gen treatment_ERLR = (treatment_groups == "Early home Registration and Late home Registration")

*Individual and household characteristics
gen A4_job = (A4a_activitytype == 1 | A4a_activitytype == 2 | A4a_activitytype == 12 | A4a_activitytype == 3 | A4a_activitytype == 4 | A4a_activitytype == 5) if A4a_activitytype ~= .
gen A4_unemployed = (A4a_activitytype == 6) if A4a_activitytype ~= .
gen A4_inactive = (A4a_activitytype == 7 | A4a_activitytype == 8 | A4a_activitytype == 9 | A4a_activitytype == 11) if A4a_activitytype ~= .
gen A10_nodegree = (A10a_degree== 1 | A10a_degree== 2) if A10a_degree~= . & A10a_degree~= 10
gen A10_degree_infbac = (A10a_degree== 3 | A10a_degree== 4) if A10a_degree~= . & A10a_degree~= 10
gen A10_degree_bac = (A10a_degree== 5 | A10a_degree== 6) if A10a_degree~= . & A10a_degree~= 10
gen A10_degree_supbac = (A10a_degree== 7 | A10a_degree== 8 | A10a_degree== 9 | A10a_degree== 11) if A10a_degree~= . & A10a_degree~= 10
gen address_householdsize = A11_adults_nb + A13_minors_nb if A11_adults_nb ~= . & A13_minors_nb ~= .
gen A14_couple = (A14_maritalstatus == 2 | A14_maritalstatus == 3 | A14_maritalstatus == 4) if A14_maritalstatus ~= .
gen A15_french_always = (A15_language == 1) if A15_language ~= .
gen A15_french_few = (A15_language == 3 | A15_language == 4) if A15_language ~= .
gen A15_french_never = (A15_language == 2) if A15_language ~= .
gen A17_owner = (A17_tenant == 1) if A17_tenant ~= .
gen A17_tenant_social = (A17_tenant == 2) if A17_tenant ~= .
gen A17_tenant_private = (A17_tenant == 3) if A17_tenant ~= .
gen A18_Income_inf700 = (A18_income_individual == 1) if A18_income_individual ~= .
gen A18_Income_inf1100 = (A18_income_individual == 2) if A18_income_individual ~= .
gen A18_Income_inf1500 = (A18_income_individual == 3) if A18_income_individual ~= .
gen A18_Income_sup1500 = (A18_income_individual == 4 | A18_income_individual == 5 | A18_income_individual == 6 | A18_income_individual == 7 | A18_income_individual == 8) if A18_income_individual ~= .
gen A20_live_inf2 = (A20_inhabit_duration == 1 | A20_inhabit_duration == 2 | A20_inhabit_duration == 3) if A20_inhabit_duration ~= .
gen A20_live_inf5 = (A20_inhabit_duration == 4) if A20_inhabit_duration ~= .
gen A20_live_inf10 = (A20_inhabit_duration == 5) if A20_inhabit_duration ~= .
gen A20_live_sup10 = (A20_inhabit_duration == 6) if A20_inhabit_duration ~= .
gen F3_practice_often = (F3_religion_practice == 1 | F3_religion_practice == 2) if F1_believe == 0 | (F1_believe == 1 & F3_religion_practice ~= .)
gen indiv_survey_age = 2012 - A3_birthdate
replace indiv_survey_age = indiv_survey_age / 10
gen indiv_survey_age2 = indiv_survey_age * indiv_survey_age
gen A14_nocouple = 1 - A14_couple
gen indiv_birth_abroad = 1 - A24a_birthcountry
gen A25_otherdep = 1 - A25_birth_samedep 
gen F1_nonbeliever = 1 - F1_believe
gen F3_practice_rare = 1 - F3_practice_often

* Does people leave home more than 30mn before town hall opening?
* Does people return home more than 30mn after the closing of the town hall?
** Schedules :
* montpellier: 8h30, 17h30
* cergy: 8h30, 17h30
* saint-denis: 8h30, 17h30
* sevran: 8h30, 18h
gen A7_tooearly = (A7a_morningtime_hours < 8 | (A7a_morningtime_hours == 8 & A7b_morningtime_minutes == 0)) if A4a_activitytype == 6 | A4a_activitytype == 8 | A4a_activitytype == 9 | (A4a_activitytype ~= 6 & A4a_activitytype ~= 8 & A4a_activitytype ~= 9 & A7a_morningtime_hours ~= .)
gen A8_toolate = ((A8a_eveningtime_hours >= 18 & (address_city == "Montpellier" | address_city == "Cergy" | address_city == "SaintDenis")) | ((A8a_eveningtime_hours > 18 | (A8a_eveningtime_hours == 18 & A8b_eveningtime_minutes >= 30)) & address_city == "Sevran")) if A4a_activitytype == 6 | A4a_activitytype == 8 | A4a_activitytype == 9 | (A4a_activitytype ~= 6 & A4a_activitytype ~= 8 & A4a_activitytype ~= 9 & A8a_eveningtime_hours ~= .)

*For each var of varlist gen dummies by type of treatment group
foreach var in A1_gender indiv_survey_age indiv_survey_age2 A4_unemployed A4_inactive A10_nodegree A10_degree_infbac A10_degree_bac address_householdsize A14_nocouple A15_french_few A15_french_never A17_tenant_social A17_tenant_private A18_Income_inf700 A18_Income_inf1100 A18_Income_sup1500 A20_live_inf2 A20_live_inf5 A20_live_inf10 indiv_birth_abroad A25_otherdep A27_naturalization A29_othernationality F1_nonbeliever F3_practice_rare A7_tooearly A8_toolate{
gen `var'_treat = `var' * treatment_any
}

foreach var in A1_gender indiv_survey_age indiv_survey_age2 A4_unemployed A4_inactive A10_nodegree A10_degree_infbac A10_degree_bac address_householdsize A14_nocouple A15_french_few A15_french_never A17_tenant_social A17_tenant_private A18_Income_inf700 A18_Income_inf1100 A18_Income_sup1500 A20_live_inf2 A20_live_inf5 A20_live_inf10 indiv_birth_abroad A25_otherdep A27_naturalization A29_othernationality F1_nonbeliever F3_practice_rare A7_tooearly A8_toolate{
gen `var'_canv = `var' * treatment_canvassing
gen `var'_home = `var' * treatment_home
gen `var'_double = `var' * treatment_double
}

*Vote average
gen vote_average = (C9Aa_vote_pres1st + C9Ba_vote_pres2st + C9Ca_vote_leg1st + C9Da_vote_leg2st) / 4

*Has voted at least once
gen vote_any = (C9Aa_vote_pres1st == 1 | C9Ba_vote_pres2st == 1 | C9Ca_vote_leg1st == 1 | C9Da_vote_leg2st == 1) if C9Aa_vote_pres1st ~= . & C9Ba_vote_pres2st ~= . & C9Ca_vote_leg1st ~= . & C9Da_vote_leg2st ~= .

*Political interest
gen pol_interest = (C1_politicsinterest == 1 | C1_politicsinterest == 2)
replace pol_interest = . if C1_politicsinterest == . & C1_politicsinterestx97 == 0 & C1_politicsinterestx99 == 0

*Political interest trend
gen pol_interest_more = (C2_politicsinterest_trend == 1)
replace pol_interest_more = . if C2_politicsinterest_trend == . & C2_politicsinterest_trendx97 == 0 & C2_politicsinterest_trendx99 == 0

*Number of political topics mentionned
gen temp1 = (C7_1_politicaltopic1 ~= "")
gen temp2 = (C7_2_politicaltopic2 ~= "")
gen temp3 = (C7_3_politicaltopic3 ~= "")
gen temp4 = (C7_4_politicaltopic4 ~= "")
gen temp5 = (C7_5_politicaltopic5 ~= "")
gen pol_topics_nb = temp1 + temp2 + temp3 + temp4 + temp5
replace pol_topics_nb = . if C7_1_politicaltopic1 == "" & C7_1_politicaltopic1x97 == 0 & C7_1_politicaltopic1x99 == 0
replace pol_topics_nb = 0 if T_C7_notopic == 1
drop temp1 - temp5

*Number of stricking topics during campain mentionned
gen temp1 = (E11_1_polcampain_topic1 ~= "" & T_E11_1_notopic ~= 1)
gen temp2 = (E11_2_polcampain_topic2 ~= "" & T_E11_2_notopic ~= 1)
gen temp3 = (E11_3_polcampain_topic3 ~= "" & T_E11_3_notopic ~= 1)
gen temp4 = (E11_4_polcampain_topic4 ~= "" & T_E11_4_notopic ~= 1)
gen temp5 = (E11_5_polcampain_topic5 ~= "" & T_E11_5_notopic ~= 1)
gen pol_campain_topics_nb = temp1 + temp2 + temp3 + temp4 + temp5
replace pol_campain_topics_nb = . if E11_1_polcampain_topic1 == "" & E11_1_polcampain_topic1x97 == 0 & E11_1_polcampain_topic1x99 == 0
drop temp1 - temp5

*Position himself politically
gen pol_position = (C8_politicalorientation == 1 | C8_politicalorientation == 2 | C8_politicalorientation == 3 | C8_politicalorientation == 4 | C8_politicalorientation == 5)
replace pol_position = . if C8_politicalorientation == . & C8_politicalorientationx99 == 0 & C8_politicalorientationx97 == 0

/* 
Gen Index :
- Index of political interest (C1 & C2)

- First creation of political interest vars:
Interested in politics
More and more interested in politics
*/
foreach var in pol_interest pol_interest_more {
gen `var'_mean = `var'
foreach group in "Control" "Early Canvassing" "Late Canvassing" "Early home Registration" "Late home Registration" "Early Canvassing and Late home Registration" "Early home Registration and Late home Registration" {
su `var' if treatment_groups == "`group'"
scalar temp = r(mean)
replace `var'_mean = temp if `var' == . & treatment_groups == "`group'"
}
su `var'_mean if treatment_groups == "Control"
scalar mean = r(mean)
scalar sd = r(sd)
replace `var'_mean = (`var'_mean - mean) / sd
}
gen pol_interest_index = (pol_interest_mean + pol_interest_more_mean) / 2

/* 
Gen Index :
- Index of political topics mentionned (C7 & E11)

- First creation of political topics vars:
Number of political topics mentionned
Number of political topics which marked the campain mentionned
*/
foreach var in pol_topics_nb pol_campain_topics_nb {
gen `var'_mean = `var'
foreach group in "Control" "Early Canvassing" "Late Canvassing" "Early home Registration" "Late home Registration" "Early Canvassing and Late home Registration" "Early home Registration and Late home Registration" {
su `var' if treatment_groups == "`group'"
scalar temp = r(mean)
replace `var'_mean = temp if `var' == . & treatment_groups == "`group'"
}
su `var'_mean if treatment_groups == "Control"
scalar mean = r(mean)
scalar sd = r(sd)
replace `var'_mean = (`var'_mean - mean) / sd
}
gen pol_topics_nb_index = (pol_topics_nb_mean + pol_campain_topics_nb_mean) / 2

/* 
Gen Index :
- Index of political positionnement (C8)

- First creation of political position vars:
Position himself politically
*/
foreach var in pol_position {
gen `var'_mean = `var'
foreach group in "Control" "Early Canvassing" "Late Canvassing" "Early home Registration" "Late home Registration" "Early Canvassing and Late home Registration" "Early home Registration and Late home Registration" {
su `var' if treatment_groups == "`group'"
scalar temp = r(mean)
replace `var'_mean = temp if `var' == . & treatment_groups == "`group'"
}
su `var'_mean if treatment_groups == "Control"
scalar mean = r(mean)
scalar sd = r(sd)
replace `var'_mean = (`var'_mean - mean) / sd
}
gen pol_position_index = pol_position_mean

/* 
- Gen Index :
Index of overall political follow (E1 & E4)
Index of media political follow (E7 & E9) 
Index of talk political follow (E8)

- First creation of political vars:
Followed presidential campain
Followed legislative campain
Watched pol programs on tv
Listened pol programs on radio
Read pol articles in newspaper
Read pol articles on internet
Recently spoked about politics with familly
Recently spoked about politics with friends
Recently spoked about politics with colleagues
Recently spoked about politics with neighboors
Watched between two round debate
*/
gen pol_follow_pres = (E1_prescamp_follow == 1 | E1_prescamp_follow == 2)
gen pol_follow_leg = (E4_legcamp_follow == 1 | E4_legcamp_follow == 2)
gen pol_tv = (E7a_politics_tv == 1 | E7a_politics_tv == 2)
gen pol_radio = (E7b_politics_radio == 1 | E7b_politics_radio == 2)
gen pol_newspaper = (E7c_politics_newspaper == 1 | E7c_politics_newspaper == 2)
gen pol_internet = (E7d_politics_internet == 1 | E7d_politics_internet == 2)
gen pol_spoke_familly = (E8a_spokepolitics_family == 1 | E8a_spokepolitics_family == 2)
gen pol_spoke_friends = (E8b_spokepolitics_friends == 1 | E8b_spokepolitics_friends == 2)
gen pol_spoke_colleagues = (E8c_spokepolitics_colleagues == 1 | E8c_spokepolitics_colleagues == 2)
gen pol_spoke_neighboors = (E8d_spokepolitics_neighbours == 1 | E8d_spokepolitics_neighbours == 2)
gen pol_debate = (E9_debat == 1)
foreach var in pol_follow_pres pol_follow_leg pol_tv pol_radio pol_newspaper pol_internet pol_spoke_familly pol_spoke_friends pol_spoke_colleagues pol_spoke_neighboors pol_debate{
gen `var'_mean = `var'
foreach group in "Control" "Early Canvassing" "Late Canvassing" "Early home Registration" "Late home Registration" "Early Canvassing and Late home Registration" "Early home Registration and Late home Registration" {
su `var' if treatment_groups == "`group'"
scalar temp = r(mean)
replace `var'_mean = temp if `var' == . & treatment_groups == "`group'"
}
su `var'_mean if treatment_groups == "Control"
scalar mean = r(mean)
scalar sd = r(sd)
replace `var'_mean = (`var'_mean - mean) / sd
}
gen pol_follow_overall_index = (pol_follow_pres_mean + pol_follow_leg_mean) / 2
gen pol_follow_media_index = (pol_tv_mean + pol_radio_mean + pol_newspaper_mean + pol_internet_mean + pol_debate_mean) / 5
gen pol_follow_talk_index = (pol_spoke_familly_mean + pol_spoke_friends_mean + pol_spoke_colleagues_mean + pol_spoke_neighboors_mean) / 5

/*
- Gen Index :
Index of political preferences based on expressions of prefs (C9)

- First creation of political preferences vars:
Has a preference for 1st round of pres elections
Has a preference for 2nd round of pres elections
Has a preference for 1st round of leg elections
Has a preference for 2nd round of leg elections
*/
gen pol_preference_pres_round1 = (C9Ab_vote_pres1st_whox99 == 1 | C9Ac_vote_pres1st_ifwhox99 == 1 | C9Ab_vote_pres1st_whox97 == 1 | C9Ac_vote_pres1st_ifwhox97 == 1 | T_C9Ab_clean == "BLANC" | T_C9Ab_clean == "DE address_cityPIN" | T_C9Ac_clean == "AUBRY" | T_C9Ac_clean == "AUCUN" | T_C9Ac_clean == "BESANCENOT" | T_C9Ac_clean == "BLANC" | T_C9Ac_clean == "MONTEBOURG" | T_C9Ac_clean == "ROYAL" | T_C9Ac_clean == "STRAUSS-KAHN" | T_C9Ab_notcodable == 1 | T_C9Ab_imprecise == 1 | T_C9Ac_notcodable == 1 | T_C9Ac_imprecise == 1)
replace pol_preference_pres_round1 = 1 - pol_preference_pres_round1
replace pol_preference_pres_round1 = . if (C9Aa_vote_pres1st == . & C9Aa_vote_pres1stx97 == 0 & C9Aa_vote_pres1stx99 == 0) | (C9Aa_vote_pres1st == 1 & T_C9Ab_clean == "" & T_C9Ab_notcodable ~= 1 & T_C9Ab_imprecise ~= 1 & C9Ab_vote_pres1st_whox97 == 0 & C9Ab_vote_pres1st_whox99 == 0) | (C9Aa_vote_pres1st == 0 & T_C9Ac_clean == "" & T_C9Ac_notcodable ~= 1 & T_C9Ac_imprecise ~= 1 & C9Ac_vote_pres1st_ifwhox97 == 0 & C9Ac_vote_pres1st_ifwhox99 == 0)
gen pol_preference_pres_round2 = (C9Bb_vote_pres2st_whox99 == 1 | C9Bc_vote_pres2st_ifwhox99 == 1 | C9Bb_vote_pres2st_whox97 == 1 | C9Bc_vote_pres2st_ifwhox97 == 1 | T_C9Bb_clean == "BLANC" | T_C9Bb_clean == "LE PEN" | T_C9Bb_clean == "MELENCHON" | T_C9Bc_clean == "AUCUN" | T_C9Bc_clean == "BLANC" | T_C9Bc_clean == "JOLY" | T_C9Bc_clean == "LE PEN" | T_C9Bc_clean == "MELENCHON" | T_C9Bb_notcodable == 1 | T_C9Bb_imprecise == 1 | T_C9Bc_notcodable == 1 | T_C9Bc_imprecise == 1)
replace pol_preference_pres_round2 = 1 - pol_preference_pres_round2
replace pol_preference_pres_round2 = . if (C9Ba_vote_pres2st == . & C9Ba_vote_pres2stx97 == 0 & C9Ba_vote_pres2stx99 == 0) | (C9Ba_vote_pres2st == 1 & T_C9Bb_clean == "" & T_C9Bb_notcodable ~= 1 & T_C9Bb_imprecise ~= 1 & C9Bb_vote_pres2st_whox97 == 0 & C9Bb_vote_pres2st_whox99 == 0) | (C9Ba_vote_pres2st == 0 & T_C9Bc_clean == "" & T_C9Bc_notcodable ~= 1 & T_C9Bc_imprecise ~= 1 & C9Bc_vote_pres2st_ifwhox97 == 0 & C9Bc_vote_pres2st_ifwhox99 == 0)
gen pol_preference_leg_round1 = (C9Cb_vote_leg1st_whox99 == 1 | C9Cc_vote_leg1st_ifwhox99 == 1 | C9Cb_vote_leg1st_whox97 == 1 | C9Cc_vote_leg1st_ifwhox97 == 1 | T_C9Cb_clean == "AUCUN" | T_C9Cb_clean == "BLANC" | T_C9Cb_clean == "HOLLANDE" | T_C9Cb_clean == "MELENCHON" | T_C9Cb_clean == "ROYAL" | T_C9Cc_clean == "AUCUN" | T_C9Cc_clean == "BAYROU" | T_C9Cc_clean == "BLANC" | T_C9Cc_clean == "FILLON" | T_C9Cc_clean == "HOLLANDE" | T_C9Cc_clean == "LE PEN" | T_C9Cc_clean == "ROYAL" | T_C9Cc_clean == "MORIN" | T_C9Cc_clean == "SARKOZY" | T_C9Cb_notcodable == 1 | T_C9Cb_imprecise == 1 | T_C9Cc_notcodable == 1 | T_C9Cc_imprecise == 1)
replace pol_preference_leg_round1 = 1 - pol_preference_leg_round1
replace pol_preference_leg_round1 = . if (C9Ca_vote_leg1st == . & C9Ca_vote_leg1stx97 == 0 & C9Ca_vote_leg1stx99 == 0) | (C9Ca_vote_leg1st == 1 & T_C9Cb_clean == "" & T_C9Cb_notcodable ~= 1 & T_C9Cb_imprecise ~= 1 & C9Cb_vote_leg1st_whox97 == 0 & C9Cb_vote_leg1st_whox99 == 0) | (C9Ca_vote_leg1st == 0 & T_C9Cc_clean == "" & T_C9Cc_notcodable ~= 1 & T_C9Cc_imprecise ~= 1 & C9Cc_vote_leg1st_ifwhox97 == 0 & C9Cc_vote_leg1st_ifwhox99 == 0)
gen pol_preference_leg_round2 = (C9Db_vote_leg2st_whox99 == 1 | C9Dc_vote_leg2st_ifwhox99 == 1 | C9Db_vote_leg2st_whox97 == 1 | C9Dc_vote_leg2st_ifwhox97 == 1 | T_C9Db_clean == "BLANC" | T_C9Db_clean == "HOLLANDE" | T_C9Db_clean == "LAGARDE" | T_C9Db_clean == "ROYAL" | T_C9Dc_clean == "AUCUN" | T_C9Dc_clean == "BLANC" | T_C9Dc_clean == "FILLON" | T_C9Dc_clean == "HOLLANDE" | T_C9Dc_clean == "LE PEN" | T_C9Dc_clean == "MORIN" | T_C9Dc_clean == "ROYAL" | T_C9Dc_clean == "SARKOZY" | T_C9Db_notcodable == 1 | T_C9Db_imprecise == 1 | T_C9Dc_notcodable == 1 | T_C9Dc_imprecise == 1)
replace pol_preference_leg_round2 = 1 - pol_preference_leg_round2
replace pol_preference_leg_round2 = . if (C9Da_vote_leg2st == . & C9Da_vote_leg2stx97 == 0 & C9Da_vote_leg2stx99 == 0) | (C9Da_vote_leg2st == 1 & T_C9Db_clean == "" & T_C9Db_notcodable ~= 1 & T_C9Db_imprecise ~= 1 & C9Db_vote_leg2st_whox97 == 0 & C9Db_vote_leg2st_whox99 == 0) | (C9Da_vote_leg2st == 0 & T_C9Dc_clean == "" & T_C9Dc_notcodable ~= 1 & T_C9Dc_imprecise ~= 1 & C9Dc_vote_leg2st_ifwhox97 == 0 & C9Dc_vote_leg2st_ifwhox99 == 0)
foreach var in pol_preference_pres_round1 pol_preference_pres_round2 pol_preference_leg_round1 pol_preference_leg_round2 {
gen `var'_mean = `var'
foreach group in "Control" "Early Canvassing" "Late Canvassing" "Early home Registration" "Late home Registration" "Early Canvassing and Late home Registration" "Early home Registration and Late home Registration" {
su `var' if treatment_groups == "`group'"
scalar temp = r(mean)
replace `var'_mean = temp if `var' == . & treatment_groups == "`group'"
}
su `var'_mean if treatment_groups == "Control"
scalar mean = r(mean)
scalar sd = r(sd)
replace `var'_mean = (`var'_mean - mean) / sd
}
gen pol_preference_index = (pol_preference_pres_round1_mean + pol_preference_pres_round2_mean + pol_preference_leg_round1_mean + pol_preference_leg_round2_mean) / 4

/*
- Gen Index :
Index of knowledges about political figures (D7 & E12.a)
Index of knowledges about political parties (E12.b)
Index of knowledges about political event dates (E13 & E14)

- First creation of political knowledge vars:
Know mayor name
Know mayor pol party
Know who was in 3rd pos at 1st round of pres election
Know the party of the one who was in 3rd pos at 1st round of pres election
Know president name
Know president party
Know prime minister name
Know prime minister party
Know his deputy name
Know his deputy party name
Know which elections will take place in 2014
Know when will take place the next presidential elections
*/
gen pol_know_mayor = T_D7_uncertain ~= 1 & ((address_city == "Montpellier" & T_D7_clean == "MANDROUX") | (address_city == "Cergy" & T_D7_clean == "LEFEBVRE") | (address_city == "SaintDenis" & T_D7_clean == "PAILLARD") | (address_city == "Sevran" & T_D7_clean == "GATIGNON"))
replace pol_know_mayor = . if T_D7_clean == "" & T_D7_uncertain == . & D7_mayorx99 == 0 & D7_mayorx97 == 0
gen pol_know_party_mayor = T_D8_uncertain ~= 1 & ((address_city == "Montpellier" & (T_D8_clean == "PS" | T_D8_clean == "GAUCHE")) | (address_city == "Cergy" & (T_D8_clean == "PS" | T_D8_clean == "GAUCHE")) | (address_city == "SaintDenis" & (T_D8_clean == "PC" | T_D8_clean == "FRONT DE GAUCHE" | T_D8_clean == "EXTREME GAUCHE")) | (address_city == "Sevran" & (T_D8_clean == "EELV" | T_D8_clean == "VERTS")))
replace pol_know_party_mayor = . if T_D8_clean == "" & T_D8_uncertain == . & D8_mayor_polpartyx99 == 0 & D8_mayor_polpartyx97 == 0
gen pol_know_3rd_pos = (T_E12Aa_clean == "LE PEN" & T_E12Aa_imprecise ~= 1 & T_E12Aa_uncertain ~= 1)
replace pol_know_3rd_pos = . if T_E12Aa_clean == "" & T_E12Aa_imprecise == . & T_E12Aa_uncertain == . & E12Aa_candidate3rdx97 == 0 & E12Aa_candidate3rdx99 == 0
gen pol_know_party_3rd_pos = ((T_E12Ab_clean == "FN" | T_E12Ab_clean == "extrême-droite") & T_E12Ab_imprecise ~= 1 & T_E12Ab_uncertain ~= 1)
replace pol_know_party_3rd_pos = . if T_E12Ab_clean == "" & T_E12Ab_imprecise == . & T_E12Ab_uncertain == . & T_E12Ab_notcodable == . & E12Ab_candidate3rd_partyx97 == 0 & E12Ab_candidate3rd_partyx99 == 0
gen pol_know_president = (T_E12Ba_clean == "HOLLANDE" & T_E12Ba_imprecise ~= 1)
replace pol_know_president = . if T_E12Ba_clean == "" & T_E12Ba_imprecise == . & E12Ba_presrepx99 == 0
gen pol_know_party_president = ((T_E12Bb_clean == "PS" | T_E12Bb_clean == "gauche") & T_E12Bb_imprecise ~= 1 & T_E12Bb_uncertain ~= 1)
replace pol_know_party_president = . if T_E12Bb_clean == "" & T_E12Bb_imprecise == . & T_E12Bb_uncertain == . & T_E12Bb_notcodable == . & E12Bb_presrep_partyx97 == 0 & E12Bb_presrep_partyx99 == 0
gen pol_know_premier_minister = (T_E12Ca_clean == "AYRAULT" & T_E12Ca_imprecise ~= 1)
replace pol_know_premier_minister = . if T_E12Ca_clean == "" & T_E12Ca_imprecise == . & E12Ca_primeministerx97 == 0 & E12Ca_primeministerx99 == 0
gen pol_know_party_premier = ((T_E12Cb_clean == "PS" | T_E12Cb_clean == "gauche") & T_E12Cb_imprecise ~= 1 & T_E12Cb_uncertain ~= 1)
replace pol_know_party_premier = . if T_E12Cb_clean == "" & T_E12Cb_imprecise == . & T_E12Cb_uncertain == . & T_E12Cb_notcodable == . & E12Cb_primeminister_partyx97 == 0 & E12Cb_primeminister_partyx99 == 0
gen pol_know_deputy = T_E12Da_imprecise ~= 1 & ((address_city == "Montpellier" & (T_E12Da_clean == "ROUMEGAS" | T_E12Da_clean == "LE DAIN" | T_E12Da_clean == "DOMBRE-COSTE" | T_E12Da_clean == "ASSAF" | T_E12Da_clean == "VIGNAL")) | (address_city == "Cergy" & (T_E12Da_clean == "LEFEBVRE" | T_E12Da_clean == "PONIATOWSKI")) | (address_city == "SaintDenis" & (T_E12Da_clean == "HANOTIN" | T_E12Da_clean == "LE ROUX")) | (address_city == "Sevran" & (T_E12Da_clean == "ASENSI")))
replace pol_know_deputy = . if T_E12Da_clean == "" & T_E12Da_imprecise ~= 1 & T_E12Da_notcodable ~= 1 & E12Da_deputyx99 == 0 & E12Da_deputyx97 == 0
gen pol_know_party_deputy = T_E12Db_imprecise ~= 1 & T_E12Db_uncertain ~= 1 & ((address_city == "Montpellier" & (T_E12Db_clean == "PS" | T_E12Db_clean == "EELV" | T_E12Db_clean == "verts" | T_E12Db_clean == "gauche")) | (address_city == "Cergy" & (T_E12Db_clean == "PS" | T_E12Db_clean == "UMP" | T_E12Db_clean == "gauche" | T_E12Db_clean == "droite")) | (address_city == "SaintDenis" & (T_E12Db_clean == "PS" | T_E12Db_clean == "gauche")) | (address_city == "Sevran" & (T_E12Db_clean == "PC" | T_E12Db_clean == "Front de gauche" | T_E12Db_clean == "extrême-gauche")))
replace pol_know_party_deputy = . if T_E12Db_clean == "" & T_E12Db_imprecise == . & T_E12Db_uncertain == . & T_E12Db_notcodable == . & E12Db_deputy_partyx99 == 0 & E12Db_deputy_partyx97 == 0
gen pol_know_elections_2014 = T_E13_imprecise ~= 1 & T_E13_uncertain ~= 1 & (T_E13_european == 1 | T_E13_municipal == 1) & T_E13_cantonal ~= 1 & T_E13_legislative ~= 1 & T_E13_presidential ~= 1 & T_E13_regional ~= 1 & T_E13_senatorial ~= 1 
replace pol_know_elections_2014 = . if T_E13_notcodable == . & T_E13_uncertain == . & T_E13_imprecise == . & T_E13_cantonal == . & T_E13_european == . & T_E13_legislative == . & T_E13_municipal == . & T_E13_presidential == . & T_E13_regional == . & T_E13_senatorial == . & E13_elections_2014x99 == 0 & E13_elections_2014x97 == 0
gen pol_know_next_pres = (E14_nextpreselection_date == 2017)
replace pol_know_next_pres = . if E14_nextpreselection_date == . & E14_nextpreselection_datex97 == 0 & E14_nextpreselection_datex99 == 0
foreach var in pol_know_mayor pol_know_party_mayor pol_know_3rd_pos pol_know_party_3rd_pos pol_know_president pol_know_party_president pol_know_premier_minister pol_know_party_premier pol_know_deputy pol_know_party_deputy pol_know_elections_2014 pol_know_next_pres {
gen `var'_mean = `var'
foreach group in "Control" "Early Canvassing" "Late Canvassing" "Early home Registration" "Late home Registration" "Early Canvassing and Late home Registration" "Early home Registration and Late home Registration" {
su `var' if treatment_groups == "`group'"
scalar temp = r(mean)
replace `var'_mean = temp if `var' == . & treatment_groups == "`group'"
}
su `var'_mean if treatment_groups == "Control"
scalar mean = r(mean)
scalar sd = r(sd)
replace `var'_mean = (`var'_mean - mean) / sd
}

gen pol_knowledge_figures_index = (pol_know_mayor_mean + pol_know_3rd_pos_mean + pol_know_president_mean + pol_know_premier_minister_mean + pol_know_deputy_mean) / 5
gen pol_knowledge_parties_index = (pol_know_party_mayor_mean + pol_know_party_3rd_pos_mean + pol_know_party_president_mean + pol_know_party_premier_mean + pol_know_party_deputy_mean) / 5
gen pol_knowledge_dates_index = (pol_know_elections_2014_mean + pol_know_next_pres_mean)/ 2

/*
- Gen Index :
Index of perception about political impact in their life (F4 & F5)
Index of perception about politicians (F7 & F8)

- First creation of political perception vars:
Think politics have an impact on his life
Think he have a chance to receive any help from state
Think politicians are concerned about what he think
Trust politicians
*/
gen pol_perception_impact = (F4_politicsimpact == 1 | F4_politicsimpact == 2)
replace pol_perception_impact = . if F4_politicsimpact == . & F4_politicsimpactx99 == 0 & F4_politicsimpactx97 == 0
gen pol_perception_help = (F5_statehelps == 1 | F5_statehelps == 2)
replace pol_perception_help = . if F5_statehelps == . & F5_statehelpsx99 == 0 & F5_statehelpsx97 == 0
gen pol_perception_polfig_con = (F7_polconcern_people == 1 | F7_polconcern_people == 2)
replace pol_perception_polfig_con = . if F7_polconcern_people == . & F7_polconcern_peoplex99 == 0 & F7_polconcern_peoplex97 == 0
gen pol_perception_polfig_trust = (F8_trust_politicians == 1 | F8_trust_politicians == 2)
replace pol_perception_polfig_trust = . if F8_trust_politicians == . & F8_trust_politiciansx99 == 0 & F8_trust_politiciansx97 == 0

foreach var in pol_perception_impact pol_perception_help pol_perception_polfig_con pol_perception_polfig_trust{
gen `var'_mean = `var'
foreach group in "Control" "Early Canvassing" "Late Canvassing" "Early home Registration" "Late home Registration" "Early Canvassing and Late home Registration" "Early home Registration and Late home Registration" {
su `var' if treatment_groups == "`group'"
scalar temp = r(mean)
replace `var'_mean = temp if `var' == . & treatment_groups == "`group'"
}
su `var'_mean if treatment_groups == "Control"
scalar mean = r(mean)
scalar sd = r(sd)
replace `var'_mean = (`var'_mean - mean) / sd
}

gen pol_perception_impact_index = (pol_perception_impact_mean + pol_perception_help_mean) / 2
gen pol_perception_politicians_index = (pol_perception_polfig_con_mean + pol_perception_polfig_trust_mean) / 2

gen pol_general_index = (pol_interest_mean + pol_interest_more_mean + pol_topics_nb_mean + pol_campain_topics_nb_mean + pol_position_mean + pol_follow_pres_mean + pol_follow_leg_mean + pol_tv_mean + pol_radio_mean + pol_newspaper_mean + pol_internet_mean + pol_debate_mean + pol_spoke_familly_mean + pol_spoke_friends_mean + pol_spoke_colleagues_mean + pol_spoke_neighboors_mean + pol_preference_pres_round1_mean + pol_preference_pres_round2_mean + pol_preference_leg_round1_mean + pol_preference_leg_round2_mean + pol_know_mayor_mean + pol_know_3rd_pos_mean + pol_know_president_mean + pol_know_premier_minister_mean + pol_know_deputy_mean + pol_know_party_mayor_mean + pol_know_party_3rd_pos_mean + pol_know_party_president_mean + pol_know_party_premier_mean + pol_know_party_deputy_mean + pol_know_elections_2014_mean + pol_know_next_pres_mean + pol_perception_impact_mean + pol_perception_help_mean + pol_perception_polfig_con_mean + pol_perception_polfig_trust_mean) / 36

* prédiction du vote de left par variables disponibles pour toute la base
gen vote_left_pres_1st = (T_C9Ab_clean == "ARTHAUD" | T_C9Ab_clean == "EXTREME GAUCHE" | T_C9Ab_clean == "GAUCHE" | T_C9Ab_clean == "HOLLANDE" | T_C9Ab_clean == "JOLY" | T_C9Ab_clean == "MELENCHON" | T_C9Ab_clean == "POUTOU")
replace vote_left_pres_1st = . if T_C9Ab_clean == "" | T_C9Ab_clean == "BLANC" | reg_city ~= 1
gen vote_left_pres_2nd = (T_C9Bb_clean == "HOLLANDE")
replace vote_left_pres_2nd = . if T_C9Bb_clean == "" | T_C9Bb_clean == "LE PEN" | T_C9Bb_clean == "MELENCHON" | T_C9Bb_clean == "BLANC" | reg_city ~= 1
gen vote_left_leg_1st = (T_C9Cb_clean == "BRAOUEZEC" | T_C9Cb_clean == "CARIUS" | T_C9Cb_clean == "DOMBRE-COSTE" | T_C9Cb_clean == "EELV" | T_C9Cb_clean == "EXTREME GAUCHE" | T_C9Cb_clean == "FRONT DE GAUCHE" | T_C9Cb_clean == "GATIGNON" | T_C9Cb_clean == "GAUCHE" | T_C9Cb_clean == "HANOTIN" | T_C9Cb_clean == "KHOURY" | T_C9Cb_clean == "LE DAIN" | T_C9Cb_clean == "LEFEBVRE" | T_C9Cb_clean == "MAJDOUL" | T_C9Cb_clean == "PS" | T_C9Cb_clean == "ROUMEGAS" | T_C9Cb_clean == "SIBIEUDE" | T_C9Cb_clean == "TRINQUIER" | T_C9Cb_clean == "VERTS" | T_C9Cb_clean == "VUILLETET")
replace vote_left_leg_1st = . if T_C9Cb_clean == "" | T_C9Cb_clean == "GUILLEMET" | T_C9Cb_clean == "BLANC" | reg_city ~= 1
gen vote_left_leg_2nd = (T_C9Db_clean == "ASENSI" | T_C9Db_clean == "BRAOUEZEC" | T_C9Db_clean == "CARIUS" | T_C9Db_clean == "DOMBRE-COSTE" | T_C9Db_clean == "EELV" | T_C9Db_clean == "EXTREME GAUCHE" | T_C9Db_clean == "FRONT DE GAUCHE" | T_C9Db_clean == "GATIGNON" | T_C9Db_clean == "GAUCHE" | T_C9Db_clean == "HANOTIN" | T_C9Db_clean == "KHOURY" | T_C9Db_clean == "LE DAIN" | T_C9Db_clean == "LEFEBVRE" | T_C9Db_clean == "MAJDOUL" | T_C9Db_clean == "PS" | T_C9Db_clean == "ROUMEGAS" | T_C9Db_clean == "SIBIEUDE" | T_C9Db_clean == "TRINQUIER" | T_C9Db_clean == "VERTS" | T_C9Db_clean == "VUILLETET")
replace vote_left_leg_2nd = . if T_C9Db_clean == "" | T_C9Db_clean == "BLANC" | address_city == "SaintDenis" | address_city == "Sevran" | reg_city ~= 1
gen left = (C8_politicalorientation == 1 | C8_politicalorientation == 2) if C8_politicalorientation ~= . & C8_politicalorientation ~= 6
replace left = . if reg_city ~= 1

/*
Desciptive table vars :
set matsize 1063
quietly estpost summarize
estout using summary.xls, cells("mean count min max sd") replace
*/

*Ordering variables
foreach var of varlist _all {
foreach z in x97 x99 _treat _canv _home _double _mean {
capture confirm variable `var'`z'
if !_rc {
order `var' `var'`z'
}
}
}

#delimit _cr

order 

A1_gender*
A2_french_nationality*
A3_birthdate*
A4a_activitytype*
A4b_activitytype_other*
A4_job*
A4_unemployed*
A4_inactive*
A5_occupation*
A7a_morningtime_hours*
A7b_morningtime_minutes*
A7_tooearly*
A8a_eveningtime_hours*
A8b_eveningtime_minutes*
A8_toolate*
A6_workhours*
A9_worksaturday*
A10a_degree*
A10b_degree_other*
A10_nodegree*
A10_degree_infbac*
A10_degree_bac*
A10_degree_supbac*
A11_adults_nb*
A12_adults_french_nb*
A13_minors_nb*
A14_maritalstatus*
A14_couple*
A14_nocouple*
A15_language*
A15_french_always*
A15_french_few*
A15_french_never*
A16_language_other*
A17_tenant*
A17_owner*
A17_tenant_social*
A17_tenant_private*
A18_income_individual*
A18_Income_inf700*
A18_Income_inf1100*
A18_Income_inf1500*
A18_Income_sup1500*
A19_income_household*
A20_inhabit_duration*
A20_live_inf2*
A20_live_inf5*
A20_live_inf10*
A20_live_sup10*
A21_trust_neighbourhood*
A22_similar_neighbourhood*
A23_trust*
A24a_birthcountry*
A25_birth_samedep*
A25_otherdep*
A27_naturalization*
A28a_naturalization_year*
A28b_naturalization_month*
A29_othernationality*
A30_othernationality_name*
B1_reg*
B2a_reg_city*
B2b_reg_othcity*
B3_reg_address*
B4_reg_lastdate*
B5_reg_way*
B6_1_reg_motive_what1*
B6_2_reg_motive_what2*
B6_3_reg_motive_what3*
B6_4_reg_motive_what_other*
B7_1_reg_motive_who1*
B7_2_reg_motive_who2*
B7_3_reg_motive_who3*
B8_reg_encourage*
B9_1_reg_encourage_who1*
B9_2_reg_encourage_who2*
B9_3_reg_encourage_who3*
B10_reg_othcity*
B11a_reg_othcity_name*
B11b_reg_othcity_depname*
B11c_reg_othcity_depcode*
B11bis_unreg_reasons_address*
B12a_unreg_reasons*
B12b_unreg_reasons_other*
B13_reg_future*
B14_reg_future_reasons*
B15_reg_deadline*
B16_reg_adults_nb*
C1_politicsinterest*
C2_politicsinterest_trend*
C3_politicschildhood*
C4_vote_parents*
C5a_birth_father*
C5b_birth_father_othdep*
C5c_birth_father_othcountry*
C6a_birth_mother*
C6b_birth_mother_othdep*
C6c_birth_mother_othcountry*
C7_1_politicaltopic1*
C7_2_politicaltopic2*
C7_3_politicaltopic3*
C7_4_politicaltopic4*
C7_5_politicaltopic5*
T_C7_notopic*
C8_politicalorientation*
C9Aa_vote_pres1st*
C9Ab_vote_pres1st_who*
T_C9Ab_clean*
T_C9Ab_notcodable*
T_C9Ab_imprecise*
C9Ac_vote_pres1st_ifwho*
T_C9Ac_clean*
T_C9Ac_notcodable*
T_C9Ac_imprecise*
C9Ba_vote_pres2st*
C9Bb_vote_pres2st_who*
T_C9Bb_clean*
T_C9Bb_notcodable*
T_C9Bb_imprecise*
C9Bc_vote_pres2st_ifwho*
T_C9Bc_clean*
T_C9Bc_notcodable*
T_C9Bc_imprecise*
C9Ca_vote_leg1st*
C9Cb_vote_leg1st_who*
T_C9Cb_clean*
T_C9Cb_notcodable*
T_C9Cb_imprecise*
C9Cc_vote_leg1st_ifwho*
T_C9Cc_clean*
T_C9Cc_notcodable*
T_C9Cc_imprecise*
C9Da_vote_leg2st*
C9Db_vote_leg2st_who*
T_C9Db_clean*
T_C9Db_imprecise*
T_C9Db_notcodable*
C9Dc_vote_leg2st_ifwho*
T_C9Dc_clean*
T_C9Dc_imprecise*
T_C9Dc_notcodable*
C9Ea_vote_abstmotive_pres*
C9Eb_vote_abstmotive_leg*
C10_vote_atleastone*
C11_1_vote_accompaniment*
C11_2_vote_accompaniment*
C11_3_vote_accompaniment*
D1_townhallvisit*
D2_1_townhallvisit_motive1*
D2_2_townhallvisit_motive2*
D2_3_townhallvisit_motive3*
D3_adminprocedures*
D4_adminprocedures_what*
D5_adminprocedures_where*
D6a_acqu_townhall*
D6b_acqu_townhall_lasttime*
D6a_acqu_electmumber*
D6b_acqu_electmumber_lasttime*
D7_mayor*
T_D7_clean*
T_D7_uncertain*
D8_mayor_polparty*
T_D8_clean*
T_D8_uncertain*
D9_part_neighbcouncil*
D10a_part_neighbcouncil_month*
D10b_part_neighbcouncil_year*
D11_newspaper_heard*
D12_newspaper_skimmed*
D13_newspaper_when*
D14_newspaper_article*
D15Aa_petition*
D15Ab_petition_date*
D15Ac_petition_object*
D15Ba_demonstration*
D15Bb_demonstration_date*
D15Bc_demonstration_object*
D15Ca_strike*
D15Cb_strike_date*
D15Cc_strike_object*
D15Da_syndicate*
D15Db_syndicate_date*
D15Dc_syndicate_object*
D15Ea_polparty*
D15Eb_polparty_date*
D15Ec_polparty_object*
D15Fa_association*
D15Fb_association_date*
D15Fc_association_object*
E1_prescamp_follow*
E2_prescamp_participate*
E3_prescamp_participate_how*
E4_legcamp_follow*
E5_legcamp_participate*
E6_legcamp_participate_how*
E7a_politics_tv*
E7b_politics_radio*
E7c_politics_newspaper*
E7d_politics_internet*
E8a_spokepolitics_family*
E8b_spokepolitics_friends*
E8c_spokepolitics_colleagues*
E8d_spokepolitics_neighbours*
E9_debat*
E10_campainopinion*
E11_1_polcampain_topic1*
E11_2_polcampain_topic2*
E11_3_polcampain_topic3*
E11_4_polcampain_topic4*
E11_5_polcampain_topic5*
T_E11_1_notopic*
T_E11_2_notopic*
T_E11_3_notopic*
T_E11_4_notopic*
T_E11_5_notopic*
E12Aa_candidate3rd*
T_E12Aa_clean*
T_E12Aa_imprecise*
T_E12Aa_uncertain*
E12Ab_candidate3rd_party*
T_E12Ab_clean*
T_E12Ab_uncertain*
T_E12Ab_imprecise*
T_E12Ab_notcodable*
E12Ba_presrep*
T_E12Ba_clean*
T_E12Ba_imprecise*
E12Bb_presrep_party*
T_E12Bb_clean*
T_E12Bb_uncertain*
T_E12Bb_imprecise*
T_E12Bb_notcodable*
E12Ca_primeminister*
T_E12Ca_clean*
T_E12Ca_imprecise*
E12Cb_primeminister_party*
T_E12Cb_clean*
T_E12Cb_uncertain*
T_E12Cb_imprecise*
T_E12Cb_notcodable*
E12Da_deputy*
T_E12Da_clean*
T_E12Da_imprecise*
T_E12Da_notcodable*
E12Db_deputy_party*
T_E12Db_clean*
T_E12Db_uncertain*
T_E12Db_imprecise*
T_E12Db_notcodable*
E13_elections_2014*
T_E13_notcodable*
T_E13_uncertain*
T_E13_imprecise*
T_E13_cantonal*
T_E13_european*
T_E13_legislative*
T_E13_municipal*
T_E13_presidential*
T_E13_regional*
T_E13_senatorial*
E14_nextpreselection_date*
F1_believe*
F1_nonbeliever*
F2_religion*
F3_religion_practice*
F3_practice_often*
F3_practice_rare*
F4_politicsimpact*
F5_statehelps*
F6_personalsituation*
F7_polconcern_people*
F8_trust_politicians*
G1_expressionlevel*
G2_otherpeople*
G3a_1_otherpeople_who1*
G3a_2_otherpeople_who2*
G3a_3_otherpeople_who3*
G3b_otherpeople_specify*
G4_otherpeople_help*
G5_surveyinterruption*
G6_surveyinterruption_why*
G7_comments*
indiv*
address*
reg*
pol*
vote*
left
treat*
visitor*
cluster*
surveyor*
date*
;

#d cr

* Saving new dataset

save "Survey_Analyse.dta", replace

***********************************************************************
