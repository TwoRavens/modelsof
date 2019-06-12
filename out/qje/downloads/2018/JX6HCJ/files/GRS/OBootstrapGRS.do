
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		`anything' `if' `in', `robust' absorb(`absorb')
		}
	else {
		`anything' `if' `in', `robust' 
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
	syntax anything [if] [in] [, absorb(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		capture `anything' `if' `in', `robust' absorb(`absorb')
		}
	else {
		capture `anything' `if' `in', `robust' 
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

global a = 22
global b = 26

use DatGRS, clear
*These cohorts not used anywhere
drop if cohort < 1929 
drop if cohort > 1965

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table 4 
foreach specification in " " "indigenous naturalized dist*" {
	mycmd (highnumber) areg crimerate highnumber `specification' if cohort > 1957 & cohort < 1963, robust absorb(cohort)
	}
foreach specification in "cohort > 1928 & cohort < 1966" "cohort > 1928 & cohort < 1957" "cohort > 1956 & cohort < 1966" {
	mycmd (highnumber) areg crimerate highnumber if `specification', robust absorb(cohort)
	}

*Table 5 
foreach specification in "hnmalvinas" "navy" {
	foreach period in "cohort > 1928 & cohort < 1966" "cohort > 1956 & cohort < 1966" {
		mycmd (highnumber `specification') areg crimerate highnumber `specification' if `period', absorb(cohort) robust
		}
	}

*Table 6 - sm only available for 1958-1962, but highnumber missing for 1956 & 1957, so both regressions end up being 1958-1962
foreach var in arms property sexual murder threat drug whitecollar {
	mycmd (sm) ivreg `var' (sm = highnumber) COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust 
	}

*Table 7
foreach var in formal unemployment income {
	mycmd (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
	mycmd (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)
	}

gen N = _n
save aa, replace

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

global i = 1
global j = 1

*Table 4 
foreach specification in " " "indigenous naturalized dist*" {
	mycmd1 (highnumber) areg crimerate highnumber `specification' if cohort > 1957 & cohort < 1963, robust absorb(cohort)
	}
foreach specification in "cohort > 1928 & cohort < 1966" "cohort > 1928 & cohort < 1957" "cohort > 1956 & cohort < 1966" {
	mycmd1 (highnumber) areg crimerate highnumber if `specification', robust absorb(cohort)
	}

*Table 5 
foreach specification in "hnmalvinas" "navy" {
	foreach period in "cohort > 1928 & cohort < 1966" "cohort > 1956 & cohort < 1966" {
		mycmd1 (highnumber `specification') areg crimerate highnumber `specification' if `period', absorb(cohort) robust
		}
	}

*Table 6 - sm only available for 1958-1962, but highnumber missing for 1956 & 1957, so both regressions end up being 1958-1962
foreach var in arms property sexual murder threat drug whitecollar {
	mycmd1 (sm) ivreg `var' (sm = highnumber) COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust 
	}

*Table 7
foreach var in formal unemployment income {
	mycmd1 (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
	mycmd1 (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)
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
save results\OBootstrapGRS, replace

capture erase aa.dta
capture erase aaa.dta

