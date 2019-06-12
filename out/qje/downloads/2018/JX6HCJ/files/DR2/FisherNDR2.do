
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************


*See files sampling&stratification_HARPAY.do and Multitreat.do which create strata and reproduce (create algorithm for) construction of treatment in main file
*File HARP_ROSCA_finalmultipleaugmented.dta is a modification of public use file HARP_ROSCA_final.dta created by these do files
*Strata&Treatment.dta is created in those files as well

*****************************************************

*They tested joint significance of safe_box locked_box health_pot  health_savings, but not multitreat (Table 3)

******************************************************

use DatDR2, clear

global individual_controls "bg_b1_age bg_female bg_female_married bg_provider bg_hyperbolic  bg_pat_now_impat_later bg_max_discount bg_n_roscas"
global individual_controls1 "bg_b1_age bg_female_married bg_provider bg_hyperbolic  bg_pat_now_impat_later bg_max_discount bg_n_roscas"

matrix F = J(17,4,.)
matrix B = J(179,2,.)

global i = 1
global j = 1

*Table 3 
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)

*Table 4 
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 , cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)

*Table 5 
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)

*Table 9
mycmd (r_box r_health_pot r_health_savings) reg fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1
mycmd (r_box r_health_pot r_health_savings) reg fol3_rosca_still_exists r_box r_health_pot r_health_savings rosbg_monthly_contrib STRATA2-STRATA15 if Sample == 1
mycmd (r_box r_health_pot r_health_savings) probit fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1

generate double U = .
generate Order = _n
global N = 157
mata Y = st_data((1,$N),"Y2")
generate treatnum = .

mata ResF = J($reps,17,.); ResD = J($reps,17,.); ResDF = J($reps,17,.); ResB = J($reps,179,.); ResSE = J($reps,179,.)
forvalues c = 1/$reps {
	matrix FF = J(17,3,.)
	matrix BB = J(179,2,.)
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

global i = 1
global j = 1

*Table 3 
mycmd1 (safe_box locked_box health_pot health_savings multitreat) reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd1 (safe_box locked_box health_pot health_savings multitreat) reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd1 (safe_box locked_box health_pot health_savings multitreat) reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd1 (safe_box locked_box health_pot health_savings multitreat) reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd1 (safe_box locked_box health_pot health_savings multitreat) reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd1 (safe_box locked_box health_pot health_savings multitreat) reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)

*Table 4 
mycmd1 (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 , cluster(id_harp_rosca)
mycmd1 (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd1 (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)
mycmd1 (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)

*Table 5 
mycmd1 (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd1 (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd1 (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)
mycmd1 (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)

*Table 9
mycmd1 (r_box r_health_pot r_health_savings) reg fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1
mycmd1 (r_box r_health_pot r_health_savings) reg fol3_rosca_still_exists r_box r_health_pot r_health_savings rosbg_monthly_contrib STRATA2-STRATA15 if Sample == 1
mycmd1 (r_box r_health_pot r_health_savings) probit fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..17] = FF[.,1]'; ResD[`c',1..17] = FF[.,2]'; ResDF[`c',1..17] = FF[.,3]'
mata ResB[`c',1..179] = BB[.,1]'; ResSE[`c',1..179] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/17 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/179 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherDR2, replace









