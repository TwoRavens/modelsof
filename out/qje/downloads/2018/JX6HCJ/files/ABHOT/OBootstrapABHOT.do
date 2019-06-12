
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`cluster'" ~= "") {
		`anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
		}
	else {
		`anything' `if' `in', `robust' absorb(`absorb')
		}
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
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`cluster'" ~= "") {
		capture `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
		}
	else {
		capture `anything' `if' `in', `robust' absorb(`absorb')
		}
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

global a = 8
global b = 16

use DatABHOT1, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 3 
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID) areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea) 

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
	drop hhea
	rename obs hhea

global i = 1
global j = 1
*Table 3 
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
	}
mycmd1 (COMMUNITY HYBRID) areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea) 

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

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapABHOT1, replace

***********************************
***********************************

global a = 8
global b = 64

use DatABHOT2, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 4
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg `k' COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg CONSUMPTION COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy if RTS==1, absorb(kecagroup) cluster(hhea) 

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
	drop hhea
	rename obs hhea

global i = 1
global j = 1
*Table 4
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd1 (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg `k' COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy, absorb(kecagroup) cluster(hhea)
	}
mycmd1 (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg CONSUMPTION COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy if RTS==1, absorb(kecagroup) cluster(hhea) 

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
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapABHOT2, replace

***********************************
***********************************

global a = 5
global b = 10

use DatABHOT3a, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 6
foreach k in e_q6 e_q8 e_q14 e_q15num e_q17num {
	if ("`k'" == "e_q6" | "`k'" == "e_q8") {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
		}
	}

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
	drop hhea
	rename obs hhea

global i = 1
global j = 1
*Table 6
foreach k in e_q6 e_q8 e_q14 e_q15num e_q17num {
	if ("`k'" == "e_q6" | "`k'" == "e_q8") {
		mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
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
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapABHOT3a, replace

***********************************
***********************************

global a = 9
global b = 18

use DatABHOT3b, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 6
foreach k in c_q3 c_q11a D_add D_subtract ncomplain ndontagree ncomplain_receivedbyRT a_q7 method_meeting {
	if "`k'" ~= "D_add" & "`k'" ~= "D_subtract" & "`k'" ~= "a_q7" & "`k'" ~= "method_meeting" {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) robust
		}
	}

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
	drop hhea
	rename obs hhea

global i = 1
global j = 1
*Table 6
foreach k in c_q3 c_q11a D_add D_subtract ncomplain ndontagree ncomplain_receivedbyRT a_q7 method_meeting {
	if "`k'" ~= "D_add" & "`k'" ~= "D_subtract" & "`k'" ~= "a_q7" & "`k'" ~= "method_meeting" {
		mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) robust
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
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapABHOT3b, replace

***********************************
***********************************

global a = 1
global b = 3

use DatABHOT3, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)

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
	drop hhea
	rename obs hhea

global i = 1
global j = 1
*Table 7
mycmd1 (COMMUNITY HYBRID ELITE) areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)

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
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapABHOT3, replace

***********************************
***********************************

global a = 5
global b = 31

use DatABHOT4, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)

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
	drop hhea
	rename obs hhea

global i = 1
global j = 1
*Table 7
mycmd1 (COMMUNITY HYBRID ELITE) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)

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
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapABHOT4, replace

***********************************
***********************************

global a = 4
global b = 9

use DatABHOT5, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 8
mycmd (HYBRID random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB HYBRID random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB random_rank) areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

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
	drop hhea
	rename obs hhea

global i = 1
global j = 1
*Table 8
mycmd1 (HYBRID random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (random_rankHYB HYBRID random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (HYBRID random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (random_rankHYB random_rank) areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

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
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapABHOT5, replace

***********************************
***********************************

global a = 4
global b = 8

use DatABHOT6, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 9
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
	}

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
	drop hhea
	rename obs hhea

global i = 1
global j = 1
*Table 9
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
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
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapABHOT6, replace

***********************************
***********************************

global a = 3
global b = 13

use DatABHOT7, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 10
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)

sort N
save jj, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using jj
	drop hhea
	rename obs hhea

global i = 1
global j = 1
*Table 10
mycmd1 (HYBRID DAYMEETING ELITE POOREST10) areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd1 (HYBRID DAYMEETING ELITE POOREST10) areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)

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
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapABHOT7, replace

***********************************
***********************************

global a = 1
global b = 5

use DatABHOT8, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 10
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)

sort N
save kk, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using kk
	drop hhea
	rename obs hhea

global i = 1
global j = 1
*Table 10
mycmd1 (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)

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
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapABHOT8, replace

***********************************
***********************************

global a = 4
global b = 20

use DatABHOT9, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 10
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
	}

sort N
save ll, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using ll
	drop hhea
	rename obs hhea

global i = 1
global j = 1
*Table 10
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd1 (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
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
mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapABHOT9, replace

***********************************
***********************************

*Combining files

matrix count = (8,8,5,9,1,5,4,4,3,1,4) \ (16,64,10,18,3,31,9,8,13,5,20)

drop _all
use ip\OBootstrapABHOT1
global k = count[2,1]
global N = count[1,1]
mkmat F1-F4 in 1/$N, matrix(F)
mkmat B1 B2 in 1/$k, matrix(B)

local c = 2
foreach j in 2 3a 3b 3 4 5 6 7 8 9 {
	use ip\OBootstrapABHOT`j', clear
	sort N
	global k1 = count[2,`c']
	global N1 = count[1,`c']
	local c = `c' + 1
mkmat F1-F4 in 1/$N1, matrix(FF)
mkmat B1 B2 in 1/$k1, matrix(BB)
	matrix F = F \ FF
	matrix B = B \ BB
	drop F1-F4 B1-B2 
	forvalues i = $k1(-1)1 {
		local k = `i' + $k
		rename ResB`i' ResB`k'
		rename ResSE`i' ResSE`k'
		}
	forvalues i = $N1(-1)1 {
		local k = `i' + $N
		rename ResFF`i' ResFF`k'
		rename ResF`i' ResF`k'
		rename ResDF`i' ResDF`k'
		rename ResD`i' ResD`k'
		}
	global k = $k + $k1
	global N = $N + $N1
	save a`j', replace
	}

use ip\OBootstrapABHOT1, clear
drop F1-F4 B1-B2 
foreach j in 2 3a 3b 3 4 5 6 7 8 9 {
	sort N
	merge N using a`j'
	tab _m
	drop _m
	sort N
	}
aorder
svmat double F
svmat double B
save results\OBootstrapABHOT, replace


foreach j in a2 a3a a3b a3 a4 a5 a6 a7 a8 a9 aaa aa bb cc dd ee ff gg hh ii jj kk ll {
	capture erase `j'.dta
	}


