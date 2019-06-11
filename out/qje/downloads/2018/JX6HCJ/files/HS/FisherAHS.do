
*randomizing at treatment level


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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', cluster(`cluster')
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatHS1, clear

matrix F = J(10,4,.)
matrix B = J(10,2,.)

global i = 1
*Table 1
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	ttest `demog', by(highqx) unequal
		matrix F[$i,1] = r(p), 0, r(df_t), 1
		matrix B[$i,1] = (r(mu_2)-r(mu_1), r(se))
	global i = $i + 1
	}

bysort randset: gen N = _n
sort N randset
global N = 10
mata Y = st_data((1,$N),"highqx")
generate Order = _n
generate double U = .

mata ResF = J($reps,10,.); ResD = J($reps,10,.); ResDF = J($reps,10,.); ResB = J($reps,10,.); ResSE = J($reps,10,.)
forvalues c = 1/$reps {
	matrix FF = J(10,3,.)
	matrix BB = J(10,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"highqx",Y)
	sort randset N
	quietly replace highqx = highqx[_n-1] if randset == randset[_n-1] 

global i = 1
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	quietly ttest `demog', by(highqx) unequal 
		matrix FF[$i,1] = r(p), 0, r(df_t)
		matrix BB[$i,1] = (r(mu_2)-r(mu_1), r(se))
	global i = $i + 1
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..10] = FF[.,1]'; ResD[`c',1..10] = FF[.,2]'; ResDF[`c',1..10] = FF[.,3]'
mata ResB[`c',1..10] = BB[.,1]'; ResSE[`c',1..10] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/10 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\FisherAltHS1, replace


***********************************

use DatHS2, clear

sum q3d
local twicesd=2*r(sd)

matrix F = J(6,4,.)
matrix B = J(6,2,.)

global i = 1
global j = 1
*Table 2
foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (highqx) reg q3d `regressors' `obs', cluster(randset)
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	mycmd (highqx) ologit q2sd `regressors', cluster(randset)
	}

bysort randset: gen N = _n
sort N randset
global N = 10
mata Y = st_data((1,$N),"highqx")
generate Order = _n
generate double U = .

mata ResF = J($reps,6,.); ResD = J($reps,6,.); ResDF = J($reps,6,.); ResB = J($reps,6,.); ResSE = J($reps,6,.)
forvalues c = 1/$reps {
	matrix FF = J(6,3,.)
	matrix BB = J(6,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"highqx",Y)
	sort randset N
	quietly replace highqx = highqx[_n-1] if randset == randset[_n-1] 

global i = 1
global j = 1
*Table 2
foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd1 (highqx) reg q3d `regressors' `obs', cluster(randset)
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	mycmd1 (highqx) ologit q2sd `regressors', cluster(randset)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..6] = FF[.,1]'; ResD[`c',1..6] = FF[.,2]'; ResDF[`c',1..6] = FF[.,3]'
mata ResB[`c',1..6] = BB[.,1]'; ResSE[`c',1..6] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/6 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\FisherAltHS2, replace

*****************************************************

use DatHS3, clear

matrix F = J(4,4,.)
matrix B = J(4,2,.)

global i = 1
global j = 1
*Table 3
foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (Qx) reg x `regressors' if certain==`cert' & px~=1, cluster(randset)
		}
	}

bysort randset: gen N = _n
sort N randset
global N = 10
mata Y = st_data((1,$N),"Qx")
generate Order = _n
generate double U = .

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,4,.); ResSE = J($reps,4,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(4,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Qx",Y)
	sort randset N
	quietly replace Qx = Qx[_n-1] if randset == randset[_n-1] 

global i = 1
global j = 1
*Table 3
foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd1 (Qx) reg x `regressors' if certain==`cert' & px~=1, cluster(randset)
		}
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..4] = BB[.,1]'; ResSE[`c',1..4] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\FisherAltHS3, replace

*****************************************


use ip\FisherAltHS2, clear
mkmat F1-F4 in 1/6, matrix(F2)
mkmat B1-B2 in 1/6, matrix(B2)
drop F1-F4 B1-B2 
forvalues i = 6(-1)1 {
	local j = `i' + 10
	rename ResF`i' ResF`j'
	rename ResD`i' ResD`j'
	rename ResDF`i' ResDF`j'
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
sort N
save a2, replace

use ip\FisherAltHS3, clear
mkmat F1-F4 in 1/4, matrix(F3)
mkmat B1-B2 in 1/4, matrix(B3)
drop F1-F4 B1-B2 
forvalues i = 4(-1)1 {
	local j = `i' + 16
	rename ResF`i' ResF`j'
	rename ResD`i' ResD`j'
	rename ResDF`i' ResDF`j'
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
sort N
save a3, replace

use ip\FisherAltHS1, clear
mkmat F1-F4 in 1/10, matrix(F1)
mkmat B1-B2 in 1/10, matrix(B1)
drop F1-F4 B1-B2 
forvalues i = 2/3 {
	sort N
	merge N using a`i'
	tab _m
	drop _m
	}
sort N
matrix F = F1 \ F2 \ F3
matrix B = B1 \ B2 \ B3
svmat double F
svmat double B
aorder
save results\FisherAHS, replace

erase a2.dta
erase a3.dta



