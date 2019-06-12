
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xxx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	unab anything: `anything'
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "`reg'" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xxx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xxx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************

matrix B = J(179,2,.)
global j = 1

use DatDR2, clear

global individual_controls "bg_b1_age bg_female bg_female_married bg_provider bg_hyperbolic  bg_pat_now_impat_later bg_max_discount bg_n_roscas"
global individual_controls1 "bg_b1_age bg_female_married bg_provider bg_hyperbolic  bg_pat_now_impat_later bg_max_discount bg_n_roscas"

*Table 3 
global i = 0
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings multitreat) reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)

quietly suest $M, cluster(id_harp_rosca)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

*Table 4 
global i = 0
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 , cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)

quietly suest $M, cluster(id_harp_rosca)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

*Table 5 
global i = 0
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)

quietly suest $M, cluster(id_harp_rosca)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

*Table 9
global i = 0
mycmd (r_box r_health_pot r_health_savings) reg fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1
mycmd (r_box r_health_pot r_health_savings) reg fol3_rosca_still_exists r_box r_health_pot r_health_savings rosbg_monthly_contrib STRATA2-STRATA15 if Sample == 1
mycmd (r_box r_health_pot r_health_savings) probit fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1

quietly suest $M, cluster(id_harp_rosca)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 9)

drop _all
svmat double F
svmat double B
save results/SuestDR2, replace






