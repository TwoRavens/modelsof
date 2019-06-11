
*All based upon files generously provided by Dupas and Robinson

*****************************************************

*They tested joint significance of safe_box locked_box health_pot health_savings, but not multitreat (Table 3)

************************************

do sampling&stratification_HARP

#delimit cr

*My Added Code
replace strata = 20 if eligible == 2
drop if eligible == 0
egen Strata = group(strata), label
keep a3_harp_id Strata Treatment
sort Strata a3_harp_id
tab Treatment, gen(T)
generate T = T1*1 + T2*2 + T3*3 + T4*4 + T5*5
capture label drop T
label define T 1 "PURE CONTROL" 2 "UNLOCKED BOX" 3 "LOCKBOX" 4 "HEALTH POT" 5 "HEALTH SAVINGS ACCOUNT"
label values T T
drop Treatment T1-T5
rename T Treatment
save Strata&Treatment, replace

*Getting treatment vector
use Strata&Treatment.dta, clear
mkmat Strata Treatment a3_harp_id, matrix(Y)

use HARP_ROSCA_finalmultipleaugmented, clear
gen bg_female_married=bg_female*bg_married
global individual_controls "bg_b1_age bg_female bg_female_married bg_provider bg_hyperbolic  bg_pat_now_impat_later bg_max_discount bg_n_roscas"
global individual_controls1 "bg_b1_age bg_female_married bg_provider bg_hyperbolic  bg_pat_now_impat_later bg_max_discount bg_n_roscas"

foreach X in safe_box locked_box health_pot health_savings multitreat {
	gen `X'_prov=bg_provider*`X'
	gen `X'_pb=bg_hyperbolic*`X'
	gen `X'_fmarry=bg_married*`X' if bg_female==1
	}
for any encouragement safe_box locked_box health_pot health_savings \ num 1/5: gen r_X=1 if strpos(group, "Y") \ replace r_X=0 if strpos(group, "Y")==0
gen r_box=1 if r_safe_box==1 | r_locked_box==1
replace r_box=0 if r_safe_box==0 & r_locked_box==0
*Note group == treatment0, will use this in randomization calculations below
tab group treatment0
*Note that this strata does not equal strata for id_harp_rosca listed in dataset (can compare with Strata&Treatment.dta)
*Not surprising given participants in multiple roscas and hence multiple strata
tab strata, gen(STRATA)
*Regressions in Table 9 depend upon order of data
sort id_harp_rosca
generate Sample = 1 if id_harp_rosca!=id_harp_rosca[_n-1]


*Table 3 - All okay

xi: reg fol2_amtinvest_healthproducts safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib i.strata, cluster(id_harp_rosca)
	reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)

xi: reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib i.strata $individual_controls, cluster(id_harp_rosca)
	reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)

xi: reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib i.strata, cluster(id_harp_rosca)
	reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)

xi: reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib i.strata $individual_controls, cluster(id_harp_rosca)
	reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)

xi: reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib i.strata, cluster(id_harp_rosca)
	reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)

xi: reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib i.strata $individual_controls, cluster(id_harp_rosca)
	reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)


*Table 4 - All okay

xi: reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib i.strata, cluster(id_harp_rosca)
	reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 , cluster(id_harp_rosca)

xi: reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib i.strata $individual_controls, cluster(id_harp_rosca)
	reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)

xi: reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib i.strata  if bg_female==1, cluster(id_harp_rosca)
	reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)

xi: reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib i.strata $individual_controls if bg_female==1, cluster(id_harp_rosca)
	reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)


*Table 5 - All okay

xi: reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib i.strata, cluster(id_harp_rosca)
	reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)

xi: reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib i.strata $individual_controls, cluster(id_harp_rosca)
	reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)

xi: reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib i.strata  if bg_female==1, cluster(id_harp_rosca)
	reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)

xi: reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib i.strata $individual_controls if bg_female==1, cluster(id_harp_rosca)
	reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)


*Table 9 - All okay

reg fol3_rosca_still_exists r_box r_health_pot r_health_savings if id_harp_rosca!=id_harp_rosca[_n-1]
	testparm r_box r_health_pot r_health_savings 

xi: reg fol3_rosca_still_exists r_box r_health_pot r_health_savings rosbg_monthly_contrib i.strata if id_harp_rosca!=id_harp_rosca[_n-1]
	reg fol3_rosca_still_exists r_box r_health_pot r_health_savings rosbg_monthly_contrib STRATA2-STRATA15 if id_harp_rosca!=id_harp_rosca[_n-1]

dprobit fol3_rosca_still_exists r_box r_health_pot r_health_savings if id_harp_rosca!=id_harp_rosca[_n-1]
	probit fol3_rosca_still_exists r_box r_health_pot r_health_savings if id_harp_rosca!=id_harp_rosca[_n-1]

svmat Y

save DatDR2, replace








