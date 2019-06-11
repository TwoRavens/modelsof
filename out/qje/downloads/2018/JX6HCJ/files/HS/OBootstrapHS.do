
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `robust'
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
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', cluster(`cluster') `robust'
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			matrix V = V[1..$k,1..$k]
			matrix b = b[1,1..$k]
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) capture matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) capture matrix FF[$i,4] = chi2tail($k,f[1,1])
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

global a = 10
global b = 10

use DatHS1, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
*Table 1
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	ttest `demog', by(highqx) unequal
		matrix VV =  r(se)^2
		mata V = st_matrix("VV"); L = _symeigenvalues(V); L = L[1,1], L[1,cols(L)], sum(ln(L),1), cols(L); st_matrix("L",L)
		matrix F[$i,1] = r(p), 0, r(df_t), 1
		matrix B[$i,1] = (r(mu_2)-r(mu_1), r(se))
	global i = $i + 1
	}

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

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($a,2,.)
	matrix FF = J($b,4,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop id
	rename obs id

global i = 1
foreach demog in q3b q3a q2b q2a px05_ px05p_ px1_ px1p_ px2_ px2p_ {
	capture ttest `demog', by(highqx) unequal 
	if (_rc == 0) {
		matrix BB[$i,1] = (r(mu_2)-r(mu_1), r(se))
		matrix FF[$i,1] = r(p), 0, r(df_t), Ftail(1,r(df_t),((r(mu_2)-r(mu_1)-B[$i,1])/r(se))^2) 
		}
	global i = $i + 1
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF ResB ResSE {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapHS1, replace

*******************************
*******************************

global a = 6
global b = 6

use DatHS2, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

sum q3d
local twicesd=2*r(sd)

global i = 1
global j = 1
*Table 2
foreach obs in "" "if q3d>=-`twicesd' & q3d <=`twicesd'" {
	foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (highqx) reg q3d `regressors' `obs'
		}
	}
foreach regressors in "highqx" "highqx female r_agemiss r_age r_age2 human econ othersoc day*" {
	mycmd (highqx) ologit q2sd `regressors'
	}

gen Order = _n
sort id Order
gen N = 1
gen Dif = (id ~= id[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save bb, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($a,2,.)
	matrix FF = J($b,4,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop id
	rename obs id

global i = 1
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

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF ResB ResSE {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapHS2, replace

*********************************
*********************************

global a = 4
global b = 4

use DatHS3, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 3
foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd (Qx) reg x `regressors' if certain==`cert' & px~=1, cluster(id)
		}
	}

gen Order = _n
sort id Order
gen N = 1
gen Dif = (id ~= id[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save cc, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($a,2,.)
	matrix FF = J($b,4,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using cc
	drop id
	rename obs id

global i = 1
global j = 1
*Table 3
foreach cert in 0 1 {
	foreach regressors in "Qx px" "Qx px female r_agemiss r_age r_age2 human econ othersoc day*" {
		mycmd1 (Qx) reg x `regressors' if certain==`cert' & px~=1, cluster(id)
		}
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF ResB ResSE {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapHS3, replace

*********************************
*********************************

use ip\OBootstrapHS2, clear
mkmat F1-F4 in 1/6, matrix(F2)
mkmat B1-B2 in 1/6, matrix(B2)
drop F1-F4 B1-B2 
forvalues i = 6(-1)1 {
	local j = `i' + 10
	rename ResFF`i' ResFF`j'
	rename ResF`i' ResF`j'
	rename ResD`i' ResD`j'
	rename ResDF`i' ResDF`j'
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
sort N
save a2, replace

use ip\OBootstrapHS3, clear
mkmat F1-F4 in 1/4, matrix(F3)
mkmat B1-B2 in 1/4, matrix(B3)
drop F1-F4 B1-B2 
forvalues i = 4(-1)1 {
	local j = `i' + 16
	rename ResFF`i' ResFF`j'
	rename ResF`i' ResF`j'
	rename ResD`i' ResD`j'
	rename ResDF`i' ResDF`j'
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
sort N
save a3, replace

use ip\OBootstrapHS1, clear
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
save results\OBootstrapHS, replace

foreach file in aa bb cc aaa a2 a3 {
	capture erase `file'.dta
	}




