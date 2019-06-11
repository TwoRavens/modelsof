
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

global a = 24
global b = 24

use DatDHR1, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Combining Tables 2 and 6 into one randomization analysis with shortened code
foreach X in "RC==1" "above_score == 1" "above_score == 0" {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd (treat) regress open treat if `X' & `Y', cluster(schid)	
		}
	}

foreach X in inside interact_kids bbused {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd (treat) regress `X' treat if open == 1 & `Y', cluster(schid)
		}
	}

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop schid
	rename obs schid

global i = 1
global j = 1

*Combining Tables 2 and 6 into one randomization analysis with shortened code
foreach X in "RC==1" "above_score == 1" "above_score == 0" {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd1 (treat) regress open treat if `X' & `Y', cluster(schid)	
		}
	}

foreach X in inside interact_kids bbused {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd1 (treat) regress `X' treat if open == 1 & `Y', cluster(schid)
		}
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,( ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapDHR1, replace

*************************************
*************************************

global a = 12
global b = 24

use DatDHR2a, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table 7 
foreach X in "if open == 1" "" "if open == 1 & drop == 0" "if drop == 0" "if drop == 0 & pre_writ == 0" "if drop == 0 & pre_writ == 1" {
	mycmd (treat) reg attendance treat `X', cluster(schid)
	mycmd (treatpre treatpost treatexp) reg attendance treatpre treatpost treatexp t_1-t_29 `X', cluster(schid)
	}

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save bb, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop schid
	rename obs schid

global i = 1
global j = 1

*Table 7 
foreach X in "if open == 1" "" "if open == 1 & drop == 0" "if drop == 0" "if drop == 0 & pre_writ == 0" "if drop == 0 & pre_writ == 1" {
	mycmd1 (treat) reg attendance treat `X', cluster(schid)
	mycmd1 (treatpre treatpost treatexp) reg attendance treatpre treatpost treatexp t_1-t_29 `X', cluster(schid)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,( ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapDHR2a, replace

******************************
******************************

global a = 3
global b = 3

use DatDHR2b, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table 10 
foreach X in drop gov drop2 {
	mycmd (treat) reg `X' treat, cluster(schid)
	}

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save cc, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using cc
	drop schid
	rename obs schid

global i = 1
global j = 1

*Table 10 
foreach X in drop gov drop2 {
	mycmd1 (treat) reg `X' treat, cluster(schid)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,( ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapDHR2b, replace

******************************
******************************

global a = 4
global b = 4

use DatDHR3a, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table 8
foreach X in mid_writ z_add_mid_math z_add_mid_lang z_add_mid_total {
	mycmd (treat) regress `X' treat, cluster(schid)
	}

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save dd, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using dd
	drop schid
	rename obs schid

global i = 1
global j = 1

*Table 8
foreach X in mid_writ z_add_mid_math z_add_mid_lang z_add_mid_total {
	mycmd1 (treat) regress `X' treat, cluster(schid)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,( ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapDHR3a, replace

******************************
******************************

global a = 4
global b = 4

use DatDHR3b, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

foreach X in post_writ z_add_post_math z_add_post_lang z_add_post_total {
	mycmd (treat) regress `X' treat, cluster(schid)
	}

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save ee, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using ee
	drop schid
	rename obs schid


global i = 1
global j = 1

foreach X in post_writ z_add_post_math z_add_post_lang z_add_post_total {
	mycmd1 (treat) regress `X' treat, cluster(schid)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,( ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapDHR3b, replace

******************************
******************************

global a = 10
global b = 10

use DatDHR4a, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 9a
mycmd (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
foreach X in math lang total {
	mycmd (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd (treat) regress z_add_mid_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd (treat) regress z_add_mid_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)
	}

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save ff, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using ff
	drop schid
	rename obs schid


global i = 1
global j = 1
*Table 9a
mycmd1 (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
foreach X in math lang total {
	mycmd1 (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd1 (treat) regress z_add_mid_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd1 (treat) regress z_add_mid_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,( ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapDHR4a, replace

******************************
******************************

global a = 12
global b = 12

use DatDHR4b, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)


global i = 1
global j = 1

*Table 9b
mycmd (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
foreach X in math lang total {
	mycmd (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)
	}
foreach S in 2 1 {
	mycmd (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)
		}
	}

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save gg, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using gg
	drop schid
	rename obs schid

global i = 1
global j = 1

*Table 9b
mycmd1 (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
foreach X in math lang total {
	mycmd1 (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)
	}
foreach S in 2 1 {
	mycmd1 (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd1 (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)
		}
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,( ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapDHR4b, replace

******************************
******************************

global a = 10
global b = 10

use DatDHR4c, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 9c
mycmd (treat) regress post_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
foreach X in math lang total {
	mycmd (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd (treat) regress z_add_post_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd (treat) regress z_add_post_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)
	}

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save hh, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using hh
	drop schid
	rename obs schid

global i = 1
global j = 1
*Table 9c
mycmd1 (treat) regress post_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
foreach X in math lang total {
	mycmd1 (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd1 (treat) regress z_add_post_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd1 (treat) regress z_add_post_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,( ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapDHR4c, replace

******************************
******************************

global a = 12
global b = 12

use DatDHR4d, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 9d
mycmd (treat) regress post_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
foreach X in math lang total {
	mycmd (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)
	}

foreach S in 2 1 {
	mycmd (treat) regress post_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)
		}
	}

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save ii, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using ii
	drop schid
	rename obs schid

global i = 1
global j = 1
*Table 9d
mycmd1 (treat) regress post_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
foreach X in math lang total {
	mycmd1 (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)
	}

foreach S in 2 1 {
	mycmd1 (treat) regress post_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd1 (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)
		}
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,( ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapDHR4d, replace

**********************
**********************


*Combining Files

use ip\OBootstrapDHR1, clear
quietly sum F1
global k = r(N)
quietly sum B1
global kk = r(N)
mkmat F1-F4 in 1/$k, matrix(F)
mkmat B1-B2 in 1/$kk, matrix(B)
drop F1-F4 B1-B2
sort N
save a1, replace

foreach c in 2a 2b 3a 3b 4a 4b 4c 4d {
	use ip\OBootstrapDHR`c', clear
	quietly sum F1
	global k1 = r(N)
	quietly sum B1
	global kk1 = r(N)
	mkmat F1-F4 in 1/$k1, matrix(FF)
	mkmat B1-B2 in 1/$kk1, matrix(BB)
	drop F1-F4 B1-B2 
	matrix F = F \ FF
	matrix B = B \ BB
	forvalues i = $k1(-1)1 {
		local j = `i' + $k
		rename ResFF`i' ResFF`j'
		rename ResF`i' ResF`j'
		rename ResDF`i' ResDF`j'
		rename ResD`i' ResD`j'
		}
	forvalues i = $kk1(-1)1 {
		local j = `i' + $kk
		rename ResB`i' ResB`j'
		rename ResSE`i' ResSE`j'
		}
	global k = $k + $k1
	global kk = $kk + $kk1
	sort N
	save a`c', replace
	}

use a1, clear
foreach c in 2a 2b 3a 3b 4a 4b 4c 4d {
	sort N
	merge N using a`c'
	tab _m
	drop _m
	}
aorder
sort N
foreach j in F B {
	svmat double `j'
	}
save results\OBootstrapDHR, replace


foreach file in aa bb cc dd ee ff gg hh ii aaa a1 a2a a2b a3a a3b a4a a4b a4c a4d {
	capture erase `file'.dta
	}


