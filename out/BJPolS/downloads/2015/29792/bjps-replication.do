// ---------------------------bjps-replication.do------------------------------
// Title:     Who is afraid of conflict?
//            Replication script using data supplied by Schuck et al (2014)
// Authors:   Zoltan Fazekas & Erik Gahner Larsen
// Email:     zfa@sam.sdu.dk; egl@sam.sdu.dk
// Paper:     Media content and political behavior in observational research: A critical assessment
// Journal:   British Journal of Political Science
// Data:      Replication materials hosted on BJPS website, supplied by SVdV
// Stata v:   13.1
// Note:      Script to reproduce models
//
// ----------------------------------------------------------------------------

* Load data
* To install -usespss-: net from http://radyakin.org/transfer/usespss/beta
usespss "S0007123413000525sup001.sav"

* Include observations from Bulgaria on the covariates
// Gender
g gender_female_ny = gender_female
replace gender_female_ny = gender_female[_n-1] if gender_female == . & country == 95

// Education
g w2_DUMEDUCATION_ny = w2_DUMEDUCATION
replace w2_DUMEDUCATION_ny = w2_DUMEDUCATION[_n-1] if w2_DUMEDUCATION == . & country == 95

// Age
g qage_ny = qage
replace qage_ny = qage[_n+1] if qage == . & country == 95

// News conflict
g news_conflict_ny = news_conflict_new 
replace news_conflict_ny = news_conflict_new[_n-1] if news_conflict_new == . & country == 95

// News exposure
g news_exposure_ny = news_exposure
replace news_exposure_ny = news_exposure[_n-1] if news_exposure == . & country == 95

// Simultaneous elections
g elections_country_ny = elections_country
replace elections_country_ny = elections_country[_n-1] if elections_country == . & country == 95

// Polity evaluations
g v26_r_mean_ny = v26_r_mean
replace v26_r_mean_ny = v26_r_mean[_n-1] if v26_r_mean == . & country == 95

// Compulsory voting
g obl_voting_ny = obl_voting
replace obl_voting_ny = obl_voting[_n-1] if obl_voting == . & country == 95

// Direct contact
g directcontact_ny = directcontact
replace directcontact_ny = directcontact[_n+1] if directcontact == . & country == 95

// Indirect contact
g indirectcontact_ny = indirectcontact
replace indirectcontact_ny = indirectcontact[_n+1] if indirectcontact == . & country == 95

xtset country


// Table 3
g news_conflict_ny_z = .
g news_exposure_ny_z = .

levelsof country, local(levels) 
foreach l of local levels {
	su news_conflict_ny if country == `l' & turnout != .
	replace news_conflict_ny_z = (news_conflict_ny-r(mean))/r(sd) if country == `l' & turnout != .
	su news_exposure_ny if country == `l' & turnout != .
	replace news_exposure_ny_z = (news_exposure_ny-r(mean))/r(sd) if country == `l' & turnout != .
}

* Estimate models reported in Table 1
// News exposure only 
xtlogit turnout q8_1 w2_DUMEDUCATION_ny gender_female_ny qage_ny directcontact_ny indirectcontact_ny news_exposure_ny_z v26_r_mean_ny obl_voting_ny elections_country_ny
// News conflict only
xtlogit turnout q8_1 w2_DUMEDUCATION_ny gender_female_ny qage_ny directcontact_ny indirectcontact_ny news_conflict_ny_z v26_r_mean_ny obl_voting_ny elections_country_ny
// News exposure interaction 
xtmelogit turnout q8_1 w2_DUMEDUCATION_ny gender_female_ny qage_ny directcontact_ny indirectcontact_ny c.news_exposure_ny_z##c.v26_r_mean_ny obl_voting_ny elections_country_ny || country: news_exposure_ny_z
// News conflict interaction
xtmelogit turnout q8_1 w2_DUMEDUCATION_ny gender_female_ny qage_ny directcontact_ny indirectcontact_ny c.news_conflict_ny_z##c.v26_r_mean_ny obl_voting_ny elections_country_ny || country: news_conflict_ny_z

* Estimate models reported in Table SI.A1.
// Table 1 model
xtlogit turnout q8_1 w2_DUMEDUCATION gender_female qage directcontact indirectcontact news_exposure news_conflict_new v26_r_mean obl_voting elections_country
// Table 1 models - with Bulgaria
xtlogit turnout q8_1 w2_DUMEDUCATION_ny gender_female_ny qage_ny directcontact_ny indirectcontact_ny news_exposure_ny news_conflict_ny v26_r_mean_ny obl_voting_ny elections_country_ny
// Fixed-effects model
xtlogit turnout q8_1 w2_DUMEDUCATION gender_female qage directcontact indirectcontact news_conflict_new v26_r_mean obl_voting elections_country
// Fixed-effects model - with Bulgaria
xtlogit turnout q8_1 w2_DUMEDUCATION_ny gender_female_ny qage_ny directcontact_ny indirectcontact_ny news_conflict_ny v26_r_mean_ny obl_voting_ny elections_country_ny
// Random-effects model
xtmelogit turnout q8_1 w2_DUMEDUCATION gender_female qage directcontact indirectcontact news_conflict_new v26_r_mean obl_voting elections_country ||country: news_conflict_new
// Random-effects model - with Bulgaria
xtmelogit turnout q8_1 w2_DUMEDUCATION_ny gender_female_ny qage_ny directcontact_ny indirectcontact_ny news_conflict_ny v26_r_mean_ny obl_voting_ny elections_country_ny ||country: news_conflict_ny
// Cross-level interaction
xtlogit turnout q8_1 w2_DUMEDUCATION gender_female qage directcontact indirectcontact c.news_conflict_new##c.v26_r_mean obl_voting elections_country
// Cross-level interaction - with Bulgaria
xtlogit turnout q8_1 w2_DUMEDUCATION_ny gender_female_ny qage_ny directcontact_ny indirectcontact_ny c.news_conflict_ny##c.v26_r_mean_ny obl_voting_ny elections_country_ny
