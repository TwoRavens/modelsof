clear
version 14.2

** Name: Registration&Turnout_VarCreation.do
** Date Created: 06/01/2017 by Christophe Misner (cmisner@povertyactionlab.org)
** Last Updated: 

* Data In: [Registration&Turnout.dta]
* Data Out: [Registration&Turnout_Analyse.dta]

* Purpose of do-file: Creating new variables for analysis

set mem 4g
set more off


* Setting file path

* global DIRECTORY "..."
global data "${DIRECTORY}/Data"

cd "${data}"


* Opening dataset

use "Registration&Turnout.dta", clear


* Define new variables

* Classification of 2012 newly registered depending on former registration : Registered at an old address in this city / In another city / Wasn't registered / Compulsory registered (aging 18, French majority).
gen register_new_city = (register_new == 1 & register_motive_2012 == "Changement d'adresse") if register_new == 1 & register_motive_2012 ~= "Inconnu"
gen register_new_othcity = (register_new == 1 & register_motive_2012 == "Arrivée dans la commune") if register_new == 1 & register_motive_2012 ~= "Inconnu"
gen register_new_unreg = (register_new == 1 & register_motive_2012 == "Première inscription") if register_new == 1 & register_motive_2012 ~= "Inconnu"
gen register_new_automatically = (register_new == 1 & register_motive_2012 == "Inscription d'office") if register_new == 1 & register_motive_2012 ~= "Inconnu"

* Creation of stratificaiton dummies
ta strate_id, gen(st)

* Begining date of the 1st visit
tostring treatment_earlyvisit_day, gen (temp_dayvisit)
replace temp_dayvisit = "" if temp_dayvisit == "."
tostring treatment_earlyvisit_month, gen (temp_monthvisit)
replace temp_monthvisit = "" if temp_monthvisit == "."
gen temp_beginvisit = temp_dayvisit + "/" + temp_monthvisit + "/" + "2011"
replace temp_beginvisit = "" if temp_dayvisit == "" | temp_monthvisit == ""
gen temp_beginvisit2 = date(temp_beginvisit,"DMY")
format temp_beginvisit2 %td
ta temp_beginvisit2
so address_city
by address_city: egen temp_startdatecity = min(temp_beginvisit2)
so address_city address_pollingstation_id
by address_city address_pollingstation_id: egen temp_startdatepolling = min(temp_beginvisit2)
gen treatment_earlyvisit_startdate = temp_startdatepolling
replace treatment_earlyvisit_startdate = temp_startdatecity if temp_startdatepolling == .
drop temp_dayvisit temp_monthvisit temp_beginvisit temp_beginvisit2 temp_startdatecity temp_startdatepolling
format treatment_earlyvisit_startdate %td
ta treatment_earlyvisit_startdate

* Begining date of the 2nd visit
tostring treatment_latevisit_day, gen (temp_dayvisit)
replace temp_dayvisit = "" if temp_dayvisit == "."
tostring treatment_latevisit_month, gen (temp_monthvisit)
replace temp_monthvisit = "" if temp_monthvisit == "."
gen temp_beginvisit = temp_dayvisit + "/" + temp_monthvisit + "/" + "2011"
replace temp_beginvisit = "" if temp_dayvisit == "" | temp_monthvisit == ""
gen temp_beginvisit2 = date(temp_beginvisit,"DMY")
format temp_beginvisit2 %td
ta temp_beginvisit2
so address_city
by address_city: egen temp_startdatecity = min(temp_beginvisit2)
so address_city address_pollingstation_id
by address_city address_pollingstation_id: egen temp_startdatepolling = min(temp_beginvisit2)
gen treatment_latevisit_startdate = temp_startdatepolling
replace treatment_latevisit_startdate = temp_startdatecity if temp_startdatepolling == .
drop temp_dayvisit temp_monthvisit temp_beginvisit temp_beginvisit2 temp_startdatecity temp_startdatepolling
format treatment_latevisit_startdate %td
ta treatment_latevisit_startdate

* Number of registered per household
so address_building_id address_household_id
by address_building_id address_household_id: egen register_new_hh = total(register_new)

* Making ranks of observation by buildings (In order to keep one observation per building for regressions per buildings)
so address_building_id
by address_building_id: gen address_building_rank = _n

* Making ranks of observation by households (In order to keep one observation per households for regressions per households)
so address_building_id address_household_id
by address_building_id address_household_id: gen address_household_rank = _n

* Number of newly register votes per households and per vote types
gen temp = vote_pres_1st
replace temp = 0 if register_new ~= 1
so address_building_id address_household_id
by address_building_id address_household_id: egen vote_pres_1st_regnew_hh = total(temp)
drop temp
gen temp = vote_pres_2nd
replace temp = 0 if register_new ~= 1
so address_building_id address_household_id
by address_building_id address_household_id: egen vote_pres_2nd_regnew_hh = total(temp)
drop temp
gen temp = vote_leg_1st
replace temp = 0 if register_new ~= 1
so address_building_id address_household_id
by address_building_id address_household_id: egen vote_leg_1st_regnew_hh = total(temp)
drop temp
gen temp = vote_leg_2nd
replace temp = 0 if register_new ~= 1
so address_building_id address_household_id
by address_building_id address_household_id: egen vote_leg_2nd_regnew_hh = total(temp)
drop temp

* Average participation of 2011 registered still registered in 2012 per buildings
gen temp = (register_2011 == 1 & register_2012 == 1)
so address_building_id
by address_building_id: egen temp_1 = total(temp)
drop temp
gen temp = vote_pres_1st
replace temp = 0 if register_2011 ~= 1
so address_building_id 
by address_building_id: egen temp_2 = total(temp)
drop temp
gen temp = vote_pres_2nd
replace temp = 0 if register_2011 ~= 1
so address_building_id 
by address_building_id: egen temp_3 = total(temp)
drop temp
gen temp = vote_leg_1st
replace temp = 0 if register_2011 ~= 1
so address_building_id 
by address_building_id: egen temp_4 = total(temp)
drop temp
gen temp = vote_leg_2nd
replace temp = 0 if register_2011 ~= 1
so address_building_id 
by address_building_id: egen temp_5 = total(temp)
drop temp
gen vote_register1112_avrg_building = (temp_2 + temp_3 + temp_4 + temp_5) / (4 * temp_1)
drop temp_1 temp_2 temp_3 temp_4 temp_5

* Number of 2011 registered still registered in 2012 per households
gen temp = (register_2011 == 1 & register_2012 == 1)
so address_building_id address_household_id
by address_building_id address_household_id: egen register_1112_hh = total(temp)
drop temp

* Cluster at the building level
gen cluster = address_building_id

* Dummies for treatment groups
gen treatment_EC = (treatment_groups == "Early Canvassing")
gen treatment_LC = (treatment_groups == "Late Canvassing")
gen treatment_ER = (treatment_groups == "Early home Registration")
gen treatment_LR = (treatment_groups == "Late home Registration")
gen treatment_ECLR = (treatment_groups == "Early Canvassing and Late home Registration")
gen treatment_ERLR = (treatment_groups == "Early home Registration and Late home Registration")
gen treatment_any = (treatment_groups == "Early Canvassing" | treatment_groups == "Late Canvassing" | treatment_groups == "Early home Registration" | treatment_groups == "Late home Registration" | treatment_groups == "Early Canvassing and Late home Registration" | treatment_groups == "Early home Registration and Late home Registration")

* Number of appartments included in the sample per address.
gen temp = (address_household_rank == 1 & sample_household == 1)
so address_building_id
by address_building_id: egen address_hh_sample = total(temp)
drop temp

* Treatment administrated by...
gen treatment_any_activist = treatment_any * visitor_activist
gen treatment_any_NGO = treatment_any * visitor_NGO
gen treatment_any_student = treatment_any * visitor_student

* Total types of new registered per household.
so address_building_id address_household_id
by address_building_id address_household_id: egen register_new_unreg_hh = total(register_new_unreg)
by address_building_id address_household_id: egen register_new_othcity_hh = total(register_new_othcity)
by address_building_id address_household_id: egen register_new_city_hh = total(register_new_city)
by address_building_id address_household_id: egen register_new_automatically_hh = total(register_new_automatically)

* Newly registered who received treatments.
gen treatment_any_register_new = register_new * treatment_any 
gen treatment_EC_register_new = register_new * treatment_EC
gen treatment_LC_register_new = register_new * treatment_LC
gen treatment_ER_register_new = register_new * treatment_ER
gen treatment_LR_register_new = register_new * treatment_LR
gen treatment_ECLR_register_new = register_new * treatment_ECLR
gen treatment_ERLR_register_new = register_new * treatment_ERLR

* Types of newly registered who received any treatment and different kind of treatment.
gen treatment_any_regnew_unreg = register_new_unreg * treatment_any 
gen treatment_any_regnew_othcity = register_new_othcity * treatment_any 
gen treatment_any_regnew_city = register_new_city * treatment_any 
gen treatment_any_regnew_auto = register_new_automatically * treatment_any 

foreach value in EC LC ER LR ECLR ERLR {
gen treatment_`value'_regnew_unreg = register_new_unreg * treatment_`value' 
gen treatment_`value'_regnew_othcity = register_new_othcity * treatment_`value' 
gen treatment_`value'_regnew_city = register_new_city * treatment_`value' 
gen treatment_`value'_regnew_auto = register_new_automatically * treatment_`value' 
}

* Average participation.
gen vote_average = (vote_pres_1st + vote_pres_2nd + vote_leg_1st + vote_leg_2nd) / 4

* Participated at any election.
egen vote_any = rmax(vote_pres_1st vote_pres_2nd vote_leg_1st vote_leg_2nd)
replace vote_any = . if vote_pres_1st == . | vote_pres_2nd == . | vote_leg_1st == . | vote_leg_2nd == .

* Birth localisation (other city but same department; other department but same region; other region).
gen indiv_birth_othercity = (indiv_birth_samedepartment == 1 & indiv_birth_samecity == 0) 
gen indiv_birth_otherdepartment = (indiv_birth_sameregion == 1 & indiv_birth_samedepartment == 0) 
gen indiv_birth_otherregion = (indiv_birth_abroad == 0 & indiv_birth_sameregion == 0) 

*(age/10)²
gen indiv_age_bis = indiv_age / 10
gen indiv_age2 = indiv_age_bis * indiv_age_bis

*Total number of people who registered at home per household.
so address_building_id address_household_id
by address_building_id address_household_id: egen register_home_hh = total(register_home)

*Average participation to the four election per household.
gen vote_regnew_average_hh = (vote_pres_1st_regnew_hh + vote_pres_2nd_regnew_hh + vote_leg_1st_regnew_hh + vote_leg_2nd_regnew_hh) / 4

*Classification of newly registered.

*	- At home and outside home (town hall) before the early visit started. Per person and total per household.
so address_building_id address_household_id
gen register_new_home_novisit = (register_home == 1 & register_date_2012 ~= . & register_date_2012 < treatment_earlyvisit_startdate)
gen register_new_out_novisit = (register_new == 1 & register_home ~= 1 & register_date_2012 ~= . & register_date_2012 < treatment_earlyvisit_startdate)
by address_building_id address_household_id: egen register_new_home_novisit_hh = total(register_new_home_novisit)
by address_building_id address_household_id: egen register_new_out_novisit_hh = total(register_new_out_novisit)

*	- At home and outside home (town hall) before the late visit started. Per person and total per household.
gen register_new_home_onevisit = (register_home == 1 & register_date_2012 ~= . & register_date_2012 < treatment_latevisit_startdate)
gen register_new_out_onevisit = (register_new == 1 & register_home ~= 1 & register_date_2012 ~= . & register_date_2012 < treatment_latevisit_startdate)
by address_building_id address_household_id: egen register_new_home_onevisit_hh = total(register_new_home_onevisit)
by address_building_id address_household_id: egen register_new_out_onevisit_hh = total(register_new_out_onevisit)

*	- At home and outside home (town hall). Per person and total per household.
gen register_new_home_twovisits = (register_home == 1)
gen register_new_out_twovisits = (register_new == 1 & register_home ~= 1)
by address_building_id address_household_id: egen register_new_home_twovisits_hh = total(register_new_home_twovisits)
by address_building_id address_household_id: egen register_new_out_twovisits_hh = total(register_new_out_twovisits)


* Ordering variables

#de ;

order 

indiv_id
indiv_age
indiv_age_bis
indiv_age2
indiv_gender
indiv_birth_abroad
indiv_birth_othercity
indiv_birth_otherdepartment
indiv_birth_otherregion
indiv_birth_samecity
indiv_birth_samedepartment
indiv_birth_sameregion


address_building_id
address_building_rank
address_city
address_hh_sample
address_household_id
address_household_rank
address_m2price
address_newnames
address_pollingstation_id
address_proximity
address_totalmailbox
cluster

register_1112_hh
register_2011
register_2012
register_date_2012
register_home
register_home_hh
register_motive_2012
register_new
register_new_automatically
register_new_automatically_hh
register_new_city
register_new_city_hh
register_new_hh
register_new_home_novisit
register_new_home_novisit_hh
register_new_home_onevisit
register_new_home_onevisit_hh
register_new_home_twovisits
register_new_home_twovisits_hh
register_new_othcity
register_new_othcity_hh
register_new_out_novisit
register_new_out_novisit_hh
register_new_out_onevisit
register_new_out_onevisit_hh
register_new_out_twovisits
register_new_out_twovisits_hh
register_new_unreg
register_new_unreg_hh

vote_any
vote_average

treatment_groups
treatment_any
treatment_any_activist
treatment_any_NGO
treatment_any_register_new
treatment_any_regnew_auto
treatment_any_regnew_city
treatment_any_regnew_othcity
treatment_any_regnew_unreg
treatment_any_student
treatment_earlyvisit
treatment_earlyvisit_day
treatment_earlyvisit_month
treatment_earlyvisit_startdate
treatment_latevisit
treatment_latevisit_day
treatment_latevisit_month
treatment_latevisit_startdate
treatment_EC
treatment_EC_register_new
treatment_EC_regnew_auto
treatment_EC_regnew_city
treatment_EC_regnew_othcity
treatment_EC_regnew_unreg
treatment_LC
treatment_LC_register_new
treatment_LC_regnew_auto
treatment_LC_regnew_city
treatment_LC_regnew_othcity
treatment_LC_regnew_unreg
treatment_ER
treatment_ER_register_new
treatment_ER_regnew_auto
treatment_ER_regnew_city
treatment_ER_regnew_othcity
treatment_ER_regnew_unreg
treatment_LR
treatment_LR_register_new
treatment_LR_regnew_auto
treatment_LR_regnew_city
treatment_LR_regnew_othcity
treatment_LR_regnew_unreg
treatment_ECLR
treatment_ECLR_register_new
treatment_ECLR_regnew_auto
treatment_ECLR_regnew_city
treatment_ECLR_regnew_othcity
treatment_ECLR_regnew_unreg
treatment_ERLR
treatment_ERLR_register_new
treatment_ERLR_regnew_auto
treatment_ERLR_regnew_city
treatment_ERLR_regnew_othcity
treatment_ERLR_regnew_unreg

visitor_activist
visitor_NGO
visitor_student

sample_address
sample_household

strate_id
st1
st10
st100
st101
st102
st103
st104
st105
st106
st107
st108
st109
st11
st110
st111
st112
st113
st114
st115
st116
st117
st118
st119
st12
st120
st121
st122
st123
st124
st125
st126
st127
st128
st129
st13
st130
st131
st132
st133
st134
st135
st136
st137
st138
st139
st14
st140
st141
st142
st143
st144
st145
st146
st147
st148
st149
st15
st150
st151
st152
st153
st154
st155
st156
st157
st158
st159
st16
st160
st161
st162
st17
st18
st19
st2
st20
st21
st22
st23
st24
st25
st26
st27
st28
st29
st3
st30
st31
st32
st33
st34
st35
st36
st37
st38
st39
st4
st40
st41
st42
st43
st44
st45
st46
st47
st48
st49
st5
st50
st51
st52
st53
st54
st55
st56
st57
st58
st59
st6
st60
st61
st62
st63
st64
st65
st66
st67
st68
st69
st7
st70
st71
st72
st73
st74
st75
st76
st77
st78
st79
st8
st80
st81
st82
st83
st84
st85
st86
st87
st88
st89
st9
st90
st91
st92
st93
st94
st95
st96
st97
st98
st99

;

#d cr

* Saving new dataset

save "Registration&Turnout_Analyse.dta", replace

***********************************************************************
