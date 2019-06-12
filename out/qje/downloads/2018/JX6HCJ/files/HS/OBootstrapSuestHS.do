
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ]
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

use DatHS1, clear

*Table 1

global i = 0
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	mycmd (highqx) reg `demog' highqx
	}

suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 1)
matrix B1 = B[1,1..$j]

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

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop id
	rename obs id

*Table 1

global i = 0
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	mycmd (highqx) reg `demog' highqx
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B1)*invsym(V)*(B[1,1..$j]-B1)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 1)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/5 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestHS1, replace


*********************************************


use DatHS2, clear

sum q3d
local twicesd=2*r(sd)

*Table 2
global i = 0
foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (highqx) reg q3d `regressors' `obs'
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	mycmd (highqx) ologit q2sd `regressors'
	}

suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 2)
matrix B2 = B[1,1..$j]

gen Order = _n
sort id Order
gen N = 1
gen Dif = (id ~= id[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save bb, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop id
	rename obs id

*Table 2
global i = 0
foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (highqx) reg q3d `regressors' `obs'
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	mycmd (highqx) ologit q2sd `regressors'
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B2)*invsym(V)*(B[1,1..$j]-B2)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
		}
	}
}

drop _all
set obs $reps
forvalues i = 6/10 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestHS2, replace

*********************************
*********************************

use DatHS3, clear

*Table 3
global i = 0
foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (Qx) reg x `regressors' if certain==`cert' & px~=1, cluster(id)
		}
	}

suest $M, cluster(id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)
matrix B3 = B[1,1..$j]

gen Order = _n
sort id Order
gen N = 1
gen Dif = (id ~= id[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save cc, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using cc
	drop id
	rename obs id

*Table 3
global i = 0
foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (Qx) reg x `regressors' if certain==`cert' & px~=1, cluster(id)
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
}

drop _all
set obs $reps
forvalues i = 11/15 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestHS3, replace

erase aa.dta
erase bb.dta
erase cc.dta
erase aaa.dta

*********************************
*********************************

use ip\OBootstrapSuestHS1, clear
merge 1:1 N using ip\OBootstrapSuestHS2, nogenerate
merge 1:1 N using ip\OBootstrapSuestHS3, nogenerate
drop F*
svmat double F
aorder
save results\OBootstrapSuestHS, replace

