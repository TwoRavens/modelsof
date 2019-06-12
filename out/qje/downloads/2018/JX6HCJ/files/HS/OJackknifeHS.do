
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

global b = 10

use DatHS1, clear

matrix B = J(20,1,.)

global i = 1
*Table 1
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	ttest `demog', by(highqx) unequal
		matrix B[$i,1] = r(mu_2)-r(mu_1)
	global i = $i + 1
	}

egen M = group(id)
global reps = 183

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if M == `c'

global i = 1
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	capture ttest `demog', by(highqx) unequal 
	if (_rc == 0) {
		matrix BB[$i,1] = r(mu_2)-r(mu_1)
		}
	global i = $i + 1
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeHS1, replace

*******************************
*******************************

global b = 6

use DatHS2, clear

sum q3d
local twicesd=2*r(sd)

global j = 11
*Table 2
foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (highqx) reg q3d `regressors' `obs'
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	mycmd (highqx) ologit q2sd `regressors'
	}

egen M = group(id)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

global j = 1
*Table 2
foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd1 (highqx) reg q3d `regressors' `obs'
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	mycmd1 (highqx) ologit q2sd `regressors'
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 11/16 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeHS2, replace

*********************************
*********************************

global b = 4

use DatHS3, clear

global j = 17
*Table 3
foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (Qx) reg x `regressors' if certain==`cert' & px~=1, cluster(id)
		}
	}

egen M = group(id)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

global j = 1
*Table 3
foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd1 (Qx) reg x `regressors' if certain==`cert' & px~=1, cluster(id)
		}
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 17/20 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeHS3, replace

*********************************
*********************************

use ip\OJackknifeHS1, clear
merge 1:1 N using ip\OJackknifeHS2, nogenerate
merge 1:1 N using ip\OJackknifeHS3, nogenerate
aorder
svmat double B
save results\OJackknifeHS, replace





