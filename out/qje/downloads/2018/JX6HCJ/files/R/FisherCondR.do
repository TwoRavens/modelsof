
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) fe]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `fe'
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

use DatR, clear

matrix F = J(26,4,.)
matrix B = J(52,2,.)

foreach var in receive_shock_resp receive_shock_sp receive_shock_resp_150 receive_shock_sp_150 {
	gen b`var' = `var'
	}
gen WW = (week == 0)

global i = 1
global j = 1

*Table 3 
foreach Y in 1 0 {
	foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_children_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', fe cluster(id)
		}
	}
 
*Table 4 
foreach Y in 1 0 {
	foreach X in tot_flow_spouse_you_resp tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', fe cluster(id) 
		}
	}

*No shocks week 0
*coding of shocks within couples are mirror images
*file is composed of couple pairs

gsort gender -week id
generate Order = _n

global i = 0

*Table 3 
foreach Y in 1 0 {
	foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_children_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
		foreach var in receive_shock_resp_150 receive_shock_sp_150 {
			global i = $i + 1
			capture drop Strata
			quietly replace b`var' = 0
			egen Strata = group(WW breceive_shock_resp_150 breceive_shock_sp_150)
			quietly replace b`var' = `var'
			randcmdc ((`var') xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', fe cluster(id)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}
		}
	}

*Table 4
foreach Y in 1 0 {
	foreach X in tot_flow_spouse_you_resp tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
		foreach var in receive_shock_resp_150 receive_shock_sp_150 {
			global i = $i + 1
			capture drop Strata
			quietly replace b`var' = 0
			egen Strata = group(WW breceive_shock_resp_150 breceive_shock_sp_150)
			quietly replace b`var' = `var'
			randcmdc ((`var') xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', fe cluster(id)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
			}
		}
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
save results\FisherCondR, replace





