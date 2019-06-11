
use DatDR2, clear

global individual_controls "bg_b1_age bg_female bg_female_married bg_provider bg_hyperbolic  bg_pat_now_impat_later bg_max_discount bg_n_roscas"
global individual_controls1 "bg_b1_age bg_female_married bg_provider bg_hyperbolic  bg_pat_now_impat_later bg_max_discount bg_n_roscas"

*Table 3 
global i = 1
reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, 
	estimates store M$i
	global i = $i + 1
reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, 
	estimates store M$i
	global i = $i + 1
reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, 
	estimates store M$i
	global i = $i + 1
reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, 
	estimates store M$i
	global i = $i + 1
reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, 
	estimates store M$i
	global i = $i + 1
reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, 
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3 M4 M5 M6, cluster(id_harp_rosca)
test safe_box locked_box health_pot health_savings multitreat
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

*Table 4 
global i = 1
reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 , 
	estimates store M$i
	global i = $i + 1
reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, 
	estimates store M$i
	global i = $i + 1
reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, 
	estimates store M$i
	global i = $i + 1
reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, 
	estimates store M$i
	global i = $i + 1

quietly suest M1 M2 M3 M4, cluster(id_harp_rosca)
test safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

*Table 5 
global i = 1
reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15, 
	estimates store M$i
	global i = $i + 1
reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, 
	estimates store M$i
	global i = $i + 1
reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, 
	estimates store M$i
	global i = $i + 1
reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, 	
	estimates store M$i
	global i = $i + 1

quietly suest M1 M2 M3 M4, cluster(id_harp_rosca)
test safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

*Eliminating colinear drops

*Table 9
global i = 1
reg fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1
	estimates store M$i
	global i = $i + 1
reg fol3_rosca_still_exists r_box r_health_pot r_health_savings rosbg_monthly_contrib STRATA2-STRATA15 if Sample == 1
	estimates store M$i
	global i = $i + 1
probit fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1
	estimates store M$i
	global i = $i + 1

quietly suest M1 M2 M3, robust
test [M1_mean]r_box [M2_mean]r_box [M2_mean]r_health_pot [M2_mean]r_health_savings [M3_fol3_rosca_still_exists]r_box [M3_fol3_rosca_still_exists]r_health_pot [M3_fol3_rosca_still_exists]r_health_savings
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 9)

generate double U = .
generate Order = _n
global N = 157
mata Y = st_data((1,$N),"Y2")
generate treatnum = .

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)  

	drop encouragement safe_box locked_box health_pot health_savings multitreat treatnum
	forvalues j = 0/3 {
		quietly replace treatment`j' = . if roscaid`j' ~= .
		}
	forvalues i = 1/5 {
		quietly replace bg_a19_harp_group`i' = . if bg_a19_harp_id`i' ~= . 
		}
	forvalues i = 1/$N {
		forvalues j = 0/3 {
			quietly replace treatment`j' = Y2[`i'] if roscaid`j' == Y3[`i']
			}
		forvalues j = 1/5 {
			quietly replace bg_a19_harp_group`j' = Y2[`i'] if bg_a19_harp_id`j' == Y3[`i']
			}
		}
*Data errors in original file - keep these - see Multiple.do
	quietly replace bg_a19_harp_group1 = 5 if id_respondent == 1143004 & bg_a19_harp_id1 == 1155
	quietly replace bg_a19_harp_group1 = 4 if id_respondent == 2019005 & bg_a19_harp_id1 == 2006
	quietly replace bg_a19_harp_group1 = 3 if id_respondent == 1143021 & bg_a19_harp_id1 == 1194
	quietly for any encouragement safe_box locked_box health_pot health_savings \ num 1/5 : gen X=1 if treatment0==Y \ replace X=0 if treatment0!=Y & treatment0!=. \ replace X=1 if treatment1==Y \ replace X=1 if treatment2==Y \ replace X=1 if treatment3==Y 
	forvalues i = 1/5 {
		quietly for any encouragement safe_box locked_box health_pot health_savings \ num 1/5 : replace X=1 if bg_a19_harp_group`i'==Y
		}
	quietly for any safe_box locked_box health_pot health_savings : replace encouragement=0 if X==1 
	quietly gen treatnum=safe_box+locked_box+health_pot+health_savings
	quietly gen multitreat=0 if treatnum<=1
	quietly replace multitreat=1 if treatnum>1&treatnum!=.
	foreach X in safe_box locked_box health_pot health_savings multitreat {
		quietly replace `X'_prov=bg_provider*`X'
		quietly replace `X'_pb=bg_hyperbolic*`X'
		quietly replace `X'_fmarry=bg_married*`X' if bg_female==1
		}
	quietly replace r_box = (treatment0 == 2 | treatment0 == 3)
	quietly replace r_health_pot = (treatment0 == 4)
	quietly replace r_health_savings = (treatment0 == 5)

*Table 3
global i = 1
quietly reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, 
	estimates store M$i
	global i = $i + 1
quietly reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, 
	estimates store M$i
	global i = $i + 1
quietly reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, 
	estimates store M$i
	global i = $i + 1
quietly reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, 
	estimates store M$i
	global i = $i + 1
quietly reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, 
	estimates store M$i
	global i = $i + 1
quietly reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4 M5 M6, cluster(id_harp_rosca)
if (_rc == 0) {
	capture test safe_box locked_box health_pot health_savings multitreat
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}

*Table 4 
global i = 1
quietly reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 , 
	estimates store M$i
	global i = $i + 1
quietly reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, 
	estimates store M$i
	global i = $i + 1
quietly reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, 
	estimates store M$i
	global i = $i + 1
quietly reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, 
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4, cluster(id_harp_rosca)
if (_rc == 0) {
	capture test safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry 
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

*Table 5 
global i = 1
quietly reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15, 
	estimates store M$i
	global i = $i + 1
quietly reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, 
	estimates store M$i
	global i = $i + 1
quietly reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, 
	estimates store M$i
	global i = $i + 1
quietly reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, 	
	estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3 M4, cluster(id_harp_rosca)
if (_rc == 0) {
	capture test safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry
	if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}

estimates clear

*Table 9
global i = 1
quietly reg fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1
	estimates store M$i
	global i = $i + 1
quietly reg fol3_rosca_still_exists r_box r_health_pot r_health_savings rosbg_monthly_contrib STRATA2-STRATA15 if Sample == 1
	estimates store M$i
	global i = $i + 1
capture probit fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1
	if (_rc == 0) estimates store M$i
	global i = $i + 1

capture suest M1 M2 M3, robust
if (_rc == 0) {
	capture test [M1_mean]r_box [M2_mean]r_box [M2_mean]r_health_pot [M2_mean]r_health_savings [M3_fol3_rosca_still_exists]r_box [M3_fol3_rosca_still_exists]r_health_pot [M3_fol3_rosca_still_exists]r_health_savings
	if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 9)
		}
	}

}

drop _all
set obs $reps
forvalues i = 1/20 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save results\FisherSuestDR2, replace









