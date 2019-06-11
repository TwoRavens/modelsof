
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	unab testvars: `testvars'
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

*Keep in cluster(bfirm_club_id), although not used to calculate s.e. in their bootstrap, because could influence which observations are selected (because in original dataset have obs w/out this)

*Part I: Regressions in Panels A of all tables

use DatGGY1, clear

matrix F = J(232,4,.)
matrix B = J(232,2,.)

global i = 1
global j = 1
*Table 3
foreach outcome in approved any_loan {
	mycmd (fingerprint) reg `outcome' fingerprint D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
foreach outcome in total_owed {
	mycmd (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Table 4 
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	mycmd (fingerprint) reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}


gen Strata = .
forvalues i = 1/249 {
	local j = Y1[`i']
	quietly replace Strata = `j' if bfirm_club_id == Y3[`i']
	}


global i = 0
*Table 3
foreach outcome in approved any_loan {
	global i = $i + 1
		randcmdc ((fingerprint) reg `outcome' fingerprint D2-D32 if samp1 == 1, cluster(bfirm_club_id)), treatvars(fingerprint) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(bfirm_club_id)

	}
foreach outcome in total_owed {
	global i = $i + 1
		randcmdc ((fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)), treatvars(fingerprint) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(bfirm_club_id)

	}
*Table 4 
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	global i = $i + 1
		randcmdc ((fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)), treatvars(fingerprint) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(bfirm_club_id)

	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	global i = $i + 1
		randcmdc ((fingerprint) reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)), treatvars(fingerprint) strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(bfirm_club_id)
	}



	forvalues j = 1/203 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}


matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondGGY, replace




