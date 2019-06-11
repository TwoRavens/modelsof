
*randomizing at authors' clustering level


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
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

use DatHS1, clear

matrix F = J(20,4,.)
matrix B = J(20,2,.)

global i = 1
global j = 1
*Table 1
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	ttest `demog', by(highqx) unequal
		matrix F[$i,1] = r(p), 0, r(df_t), 1
		matrix B[$i,1] = (r(mu_2)-r(mu_1), r(se))
	global i = $i + 1
	global j = $j + 1
	}

***********************************

use DatHS2, clear

sum q3d
local twicesd=2*r(sd)

*Table 2
foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (highqx) reg q3d `regressors' `obs'
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	mycmd (highqx) ologit q2sd `regressors'
	}

*****************************************************

use DatHS3, clear

*Table 3
foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (Qx) reg x `regressors' if certain==`cert' & px~=1, cluster(id)
		}
	}


*****************************************************
*****************************************************

use DatHS1, clear

global i = 0
*Table 1
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {

	global i = $i + 1
	ttest `demog', by(highqx) unequal
		matrix T = (r(mu_2)-r(mu_1), r(se))
preserve
	keep if `demog' ~= .
	mata T = st_data(.,"highqx"); ResB = J($reps,2,.)
	set seed 1
	forvalues j = 1/$reps {
		mata TT = jumble(T); st_store(.,"highqx",TT)
		quietly ttest `demog', by(highqx) unequal
		mata ResB[`j',1..2] = `r(mu_2)'-`r(mu_1)', `r(se)'
		}
	drop _all
	set obs $reps
	generate double ResB = .
	generate double ResSE = .
	mata st_store(.,.,ResB)
	generate double ResF = (ResB/ResSE)^2
	gen double __0000001 = T[1,1] if _n == 1
	gen double __0000002 = T[1,2] if _n == 1
	save ip\a$i, replace
restore
	}
		
***********************************

use DatHS2, clear

sum q3d
local twicesd=2*r(sd)

*Table 2
foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		global i = $i + 1
		randcmdc ((highqx) reg q3d `regressors' `obs'), treatvars(highqx) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	global i = $i + 1
	randcmdc ((highqx) ologit q2sd `regressors'), treatvars(highqx) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*****************************************************

use DatHS3, clear

*Table 3
foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		global i = $i + 1
		randcmdc ((Qx) reg x `regressors' if certain==`cert' & px~=1, cluster(id)), treatvars(Qx) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(id)
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
save results\FisherCondHS, replace


















