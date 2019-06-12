
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

use DatABHOT1, clear

sort N
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

foreach file in 1 2 3a 3b 3 4 6 7 8 9 {
	use ip\OBootstrapABHOT`file', clear
	save ip\OBootstrapRedABHOT`file', replace
	}

***********************************
***********************************

global a = 4
global b = 6

use DatABHOT5, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 8
mycmd (random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
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
mycmd1 (random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (random_rankHYB random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
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
save ip\OBootstrapRedABHOT5, replace

***********************************
***********************************

*Combining files

matrix count = (8,8,5,9,1,5,4,4,3,1,4) \ (16,64,10,18,3,31,6,8,13,5,20)

drop _all
use ip\OBootstrapRedABHOT1
global k = count[2,1]
global N = count[1,1]
mkmat F1-F4 in 1/$N, matrix(F)
mkmat B1 B2 in 1/$k, matrix(B)

local c = 2
foreach j in 2 3a 3b 3 4 5 6 7 8 9 {
	use ip\OBootstrapRedABHOT`j', clear
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

use ip\OBootstrapRedABHOT1, clear
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
save results\OBootstrapRedABHOT, replace


foreach j in a2 a3a a3b a3 a4 a5 a6 a7 a8 a9 aaa aa bb cc dd ee ff gg hh ii jj kk ll {
	capture erase `j'.dta
	}


