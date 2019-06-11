
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) fe]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster') `fe'
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


use DatR, clear

matrix F = J(26,4,.)
matrix B = J(52,2,.)

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
*Hence, randomize across females and then flip image onto male data

gsort gender -week id
*This covers weeks above week 0
global N = 848
generate Order = _n
generate double U = .
mata Y = st_data((1,$N),("receive_shock_resp","receive_shock_sp"))

mata ResF = J($reps,26,.); ResD = J($reps,26,.); ResDF = J($reps,26,.); ResB = J($reps,52,.); ResSE = J($reps,52,.)
forvalues c = 1/$reps {
	matrix FF = J(26,3,.)
	matrix BB = J(52,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U
	mata st_store((1,$N),("receive_shock_resp","receive_shock_sp"),Y)
	sort id week gender
	quietly replace receive_shock_resp = receive_shock_sp[_n-1] if gender == 1
	quietly replace receive_shock_sp = receive_shock_resp[_n-1] if gender == 1
	quietly replace receive_shock_resp_150 = receive_shock_resp*150
	quietly replace receive_shock_sp_150 = receive_shock_sp*150

global i = 1
global j = 1

*Table 3 
foreach Y in 1 0 {
	foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_children_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
		mycmd1 (receive_shock_resp_150 receive_shock_sp_150) xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', fe cluster(id)
		}
	}
 
*Table 4 
foreach Y in 1 0 {
	foreach X in tot_flow_spouse_you_resp tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
		mycmd1 (receive_shock_resp_150 receive_shock_sp_150) xtreg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', fe cluster(id) 
		}
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..26] = FF[.,1]'; ResD[`c',1..26] = FF[.,2]'; ResDF[`c',1..26] = FF[.,3]'
mata ResB[`c',1..52] = BB[.,1]'; ResSE[`c',1..52] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/26 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/52 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherR, replace






