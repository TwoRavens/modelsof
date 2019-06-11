

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* xxx* Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
	quietly generate Ssample$i = e(sample)
	quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
	quietly predict double yyy$i if Ssample$i, resid
	local newtestvars = ""
	foreach var in `testvars' {
		quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
		quietly predict double xxx`var'$i if Ssample$i, resid
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	quietly reg yyy$i `newtestvars', noconstant
	estimates store M$i
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatR, clear

*Table 3 
global i = 0
foreach Y in 1 {
	foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_children_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) areg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', absorb(id) cluster(id)
		}
	}
foreach Y in 0 {
	foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) areg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', absorb(id) cluster(id)
		}
	}

quietly suest $M, cluster(id)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)
 
*Table 4 
global i = 0
foreach Y in 1 {
	foreach X in tot_flow_spouse_you_resp tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) areg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', absorb(id) cluster(id) 
		}
	}
foreach Y in 0 {
	foreach X in tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) areg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', absorb(id) cluster(id) 
		}
	}

quietly suest $M, cluster(id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)


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

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
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

*Table 3 
global i = 0
foreach Y in 1 {
	foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_children_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) areg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', absorb(id) cluster(id)
		}
	}
foreach Y in 0 {
	foreach X in expend_total_you_resp exp_total_private_you_resp exp_sharedfood_you_resp exp_medical_you_resp exp_allother_shared_you_resp exp_transport_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) areg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', absorb(id) cluster(id)
		}
	}

capture suest $M, cluster(id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}
 
*Table 4 
global i = 0
foreach Y in 1 {
	foreach X in tot_flow_spouse_you_resp tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) areg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', absorb(id) cluster(id) 
		}
	}
foreach Y in 0 {
	foreach X in tot_flow_other_you_resp lab_hrs_you_resp lab_income_you_resp bank_rosca_savings_you_resp savings_you_resp {
		mycmd (receive_shock_resp_150 receive_shock_sp_150) areg `X' receive_shock_resp_150 receive_shock_sp_150 week2-week14 if gender==`Y', absorb(id) cluster(id) 
		}
	}

capture suest $M, cluster(id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/10 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save results\FisherSuestR, replace






