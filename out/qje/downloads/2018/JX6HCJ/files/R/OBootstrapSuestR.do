

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		matrix B = J(1,100,.)
		estimates clear
		global j = 0
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' [`weight' `exp'] if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' [`weight' `exp'] if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture reg yyy$i `newtestvars' [`weight' `exp'], noconstant
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
	else {
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' 
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		capture `cmd' `dep' `newtestvars' `anything' `if' `in', 
		if (_rc == 0) {
			estimates store M$i
			foreach var in `newtestvars' {
				global j = $j + 1
				matrix B[1,$j] = _b[`var']
				}
			}
		}
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
matrix B3 = B[1,1..$j] 

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
matrix B4 = B[1,1..$j]

gen Order = _n
sort id Order
gen N = 1
gen Dif = (id ~= id[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop id
	rename obs id

xtset id

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
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B3)*invsym(V)*(B[1,1..$j]-B3)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 3)
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
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B4)*invsym(V)*(B[1,1..$j]-B4)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 4)
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
save results\OBootstrapSuestR, replace

erase aa.dta
erase aaa.dta
