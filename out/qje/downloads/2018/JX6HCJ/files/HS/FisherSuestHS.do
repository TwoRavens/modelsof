

use DatHS1, clear

*Table 1

global i = 1
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	reg `demog' highqx
	estimates store M$i
	global i = $i + 1
	}
suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, robust
test highqx
matrix F = (r(p), r(drop), r(df), r(chi2), 1)

bysort id: gen N = _n
sort N id
sum N if N == 1
global N = r(N)
mata Y = st_data((1,$N),"highqx")
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"highqx",Y)
	sort id N
	quietly replace highqx = highqx[_n-1] if id == id[_n-1] 

global i = 1
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	quietly reg `demog' highqx
	estimates store M$i
	global i = $i + 1
	}

capture suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10, cluster(id)
if (_rc == 0) {
	capture test highqx
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 1)
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
save ip\FisherSuestHS1, replace



***********************************

use DatHS2, clear

sum q3d
local twicesd=2*r(sd)

*Table 2

global i = 1

foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		reg q3d `regressors' `obs'
		estimates store M$i
		global i = $i + 1
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	ologit q2sd `regressors'
	estimates store M$i
	global i = $i + 1
	}

suest M1 M2 M3 M4 M5 M6, cluster(id)
test highqx
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 2)

bysort id: gen N = _n
sort N id
sum N if N == 1
global N = r(N)
mata Y = st_data((1,$N),"highqx")
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"highqx",Y)
	sort id N
	quietly replace highqx = highqx[_n-1] if id == id[_n-1] 

*Table 2

global i = 1

foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		quietly reg q3d `regressors' `obs'
		estimates store M$i
		global i = $i + 1
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	quietly ologit q2sd `regressors'
	estimates store M$i
	global i = $i + 1
	}

capture suest M1 M2 M3 M4 M5 M6, cluster(id)
if (_rc == 0) {
	capture test highqx
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 2)
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
save ip\FisherSuestHS2, replace

*****************************************************


use DatHS3, clear

*Table 3

global i = 1

foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		reg x `regressors' if certain==`cert' & px~=1, 
		estimates store M$i
		global i = $i + 1
		}
	}

suest M1 M2 M3 M4, cluster(id)
test Qx
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

bysort id: gen N = _n
sort N id
sum N if N == 1
global N = r(N)
mata Y = st_data((1,$N),"Qx")
generate Order = _n
generate double U = .

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Qx",Y)
	sort id N
	quietly replace Qx = Qx[_n-1] if id == id[_n-1] 

*Table 3

global i = 1

foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		quietly reg x `regressors' if certain==`cert' & px~=1, 
		estimates store M$i
		global i = $i + 1
		}
	}

capture suest M1 M2 M3 M4, cluster(id)
if (_rc == 0) {
	capture test Qx
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
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
save ip\FisherSuestHS3, replace

*****************************************

use ip\FisherSuestHS1, clear
merge 1:1 N using ip\FisherSuestHS2, nogenerate
merge 1:1 N using ip\FisherSuestHS3, nogenerate
aorder
drop F*
svmat double F
save results\FisherSuestHS, replace




