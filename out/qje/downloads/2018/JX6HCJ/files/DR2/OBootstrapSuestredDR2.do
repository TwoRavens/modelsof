
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in'
	if (_rc == 0) {
		estimates store M$i
		foreach var in `newtestvars' {
			global j = $j + 1
			matrix B[1,$j] = _b[`var']
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatDR2, clear

global individual_controls "bg_b1_age bg_female bg_female_married bg_provider bg_hyperbolic  bg_pat_now_impat_later bg_max_discount bg_n_roscas"
global individual_controls1 "bg_b1_age bg_female_married bg_provider bg_hyperbolic  bg_pat_now_impat_later bg_max_discount bg_n_roscas"

*Table 3 
global i = 0
mycmd (safe_box locked_box health_pot health_savings) reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings) reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings) reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings) reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings) reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings) reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)

suest $M, cluster(id_harp_rosca)
test $test
matrix F = r(p), r(drop), r(df), r(chi2), 3
matrix B3 = B[1,1..$j]

*Table 4 
global i = 0
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 , cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)

suest $M, cluster(id_harp_rosca)
test $test
matrix F = F \(r(p), r(drop), r(df), r(chi2), 4)
matrix B4 = B[1,1..$j]

*Table 5 
global i = 0
mycmd (safe_box safe_box_prov safe_box_pb health_savings health_savings_prov health_savings_pb) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb health_savings health_savings_prov health_savings_pb) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)

suest $M, cluster(id_harp_rosca)
test $test
matrix F = F \(r(p), r(drop), r(df), r(chi2), 5)
matrix B5 = B[1,1..$j]

*Table 9
global i = 0
mycmd (r_box r_health_pot r_health_savings) reg fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1
mycmd (r_box r_health_pot r_health_savings) reg fol3_rosca_still_exists r_box r_health_pot r_health_savings rosbg_monthly_contrib STRATA2-STRATA15 if Sample == 1
mycmd (r_box r_health_pot r_health_savings) probit fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1

global list = subinstr("$test","xxxr_health_pot1","",1)
global list = subinstr("$list","xxxr_health_savings1","",1)
matrix B = B[1,1], B[1,4..9]
global j = $j - 2

suest $M, robust
test $list
matrix F = F \(r(p), r(drop), r(df), r(chi2), 9)
matrix B9 = B[1,1..$j]

gen Order = _n
sort id_harp_rosca Order
gen N = 1
gen Dif = (id_harp_rosca ~= id_harp_rosca[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop id_harp_rosca
	rename obs id_harp_rosca


*Table 3 
global i = 0
mycmd (safe_box locked_box health_pot health_savings) reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings) reg fol2_amtinvest_healthproducts safe_box locked_box health_pot health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings) reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings) reg fol2_illness_untreated_3mo safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings) reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box locked_box health_pot health_savings) reg fol2_reached_goal safe_box locked_box health_pot  health_savings multitreat rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)

capture suest $M, cluster(id_harp_rosca)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
		}
	}

*Table 4 
global i = 0
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 , cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry) reg fol2_amtinvest_healthproducts safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)

capture suest $M, cluster(id_harp_rosca)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
		}
	}

*Table 5 
global i = 0
mycmd (safe_box safe_box_prov safe_box_pb health_savings health_savings_prov health_savings_pb) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb health_savings health_savings_prov health_savings_pb) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb locked_box locked_box_prov locked_box_pb health_pot health_pot_prov health_pot_pb health_savings health_savings_prov health_savings_pb multitreat multitreat_prov multitreat_pb rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 if bg_female==1, cluster(id_harp_rosca)
mycmd (safe_box safe_box_prov safe_box_pb safe_box_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry) reg fol2_illness_untreated_3mo safe_box safe_box_prov safe_box_pb safe_box_fmarry locked_box locked_box_prov locked_box_pb locked_box_fmarry health_pot health_pot_prov health_pot_pb health_pot_fmarry health_savings health_savings_prov health_savings_pb health_savings_fmarry multitreat multitreat_prov multitreat_pb multitreat_fmarry rosbg_monthly_contrib STRATA2-STRATA15 $individual_controls1 if bg_female==1, cluster(id_harp_rosca)

capture suest $M, cluster(id_harp_rosca)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B5)*invsym(V)*(B[1,1..$j]-B5)'
		mata test = st_matrix("test"); ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', test[1,1], 5)
		}
	}

*Table 9
global i = 0
mycmd (r_box r_health_pot r_health_savings) reg fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1
mycmd (r_box r_health_pot r_health_savings) reg fol3_rosca_still_exists r_box r_health_pot r_health_savings rosbg_monthly_contrib STRATA2-STRATA15 if Sample == 1
mycmd (r_box r_health_pot r_health_savings) probit fol3_rosca_still_exists r_box r_health_pot r_health_savings if Sample == 1

capture suest $M, robust
if (_rc == 0) {
	capture test $list, matvlc(V)
	if (_rc == 0) {
		matrix B = B[1,1], B[1,4..9]
		global j = $j - 2
		matrix test = (B[1,1..$j]-B9)*invsym(V)*(B[1,1..$j]-B9)'
		mata test = st_matrix("test"); ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', test[1,1], 9)
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
save results\OBootstrapSuestRedDR2, replace

erase aa.dta
erase aaa.dta

