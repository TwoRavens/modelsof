
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust asis fe]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `robust' `asis' `fe'
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
	syntax anything [if] [in] [, cluster(string) robust asis fe]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', cluster(`cluster') `robust' `asis' `fe'
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


use DatD1, clear

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil timegroup d05v1 d05v2"  

sort schoolid
merge schoolid using Sample2
tab _m
drop _m
sort N
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace


use ip\OBootstrapD1, clear
save ip\OBootstrapRedD1, replace


*******************************
*******************************

global a = 4
global b = 7

use DatD2, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global indiv_controls="age agemissing double8"
global school_controls="sdkcpe missingKCPE clsize girl8perboy8 G_promorate teacherperpupil d04v1 d04v2 d05v1 d05v2" 

global i = 1
global j = 1
mycmd (sampleSDT HIVtreat) reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd (sampleSDT) xtreg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) fe 
foreach X in unmarpreg marpreg {
	mycmd (sampleSDT HIVtreat) reg `X' sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
	}

sort schoolid
merge schoolid using Sample2
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
	drop schoolid
	rename obs schoolid

xtset schoolid

global i = 1
global j = 1
mycmd1 (sampleSDT HIVtreat) reg fertafter12 sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
mycmd1 (sampleSDT) xtreg fertafter12 sampleSDT HIVtreat cohort age agemissing double8 clsize girl8perboy8 d04v1 d04v2 d05v1 d05v2, cluster(schoolid) fe 
foreach X in unmarpreg marpreg {
	mycmd1 (sampleSDT HIVtreat) reg `X' sampleSDT HIVtreat sampleSD cohort ${indiv_controls} ${school_controls} DISTRICT2 DIVISION2-DIVISION6 DIVISION8 total_2km, cluster(schoolid)
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
save ip\OBootstrapRedD2, replace

*******************************
*******************************

forvalues i = 3/10 {
	use ip\OBootstrapD`i', clear
	save ip\OBootstrapRedD`i', replace
	}
	

**********************
**********************

matrix count = (4,4,8,26,10,10,3,1,2,2) \ (8,7,16,52,10,10,6,3,6,6) 

global f = count[1,1]
global b = count[2,1]

use ip\OBootstrapRedD1, clear
mkmat F1-F4 in 1/$f, matrix(F)
mkmat B1-B2 in 1/$b, matrix(B)
drop F1-F4 B1-B2 
sort N
save a1, replace

forvalues c = 2/10 {
	global f1 = count[1,`c']
	global b1 = count[2,`c']

	use ip\OBootstrapRedD`c', clear
	mkmat F1-F4 in 1/$f1, matrix(FF)
	mkmat B1-B2 in 1/$b1, matrix(BB)
	drop F1-F4 B1-B2 
	matrix F = F \ FF
	matrix B = B \ BB
	forvalues i = $f1(-1)1 {
		local j = `i' + $f
		rename ResFF`i' ResFF`j'
		rename ResF`i' ResF`j'
		rename ResDF`i' ResDF`j'
		rename ResD`i' ResD`j'
		}
	forvalues i = $b1(-1)1 {
		local j = `i' + $b
		rename ResB`i' ResB`j'
		rename ResSE`i' ResSE`j'
		}
	global f = $f + $f1
	global b = $b + $b1
	sort N
	save a`c', replace
	}

use a1, clear
forvalues c = 2/10 {
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
save results\OBootstrapRedD, replace

foreach file in aaa bbb aa bb cc dd ee ff gg hh ii jj a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 {
	capture erase `file'.dta
	}

*repeats, for table tests
use results\OBootstrapRedD, clear
foreach var in ResF ResD ResDF ResFF {
	generate double `var'71 = `var'17
	generate double `var'72 = `var'30
	}
foreach var in ResB ResSE {
	generate double `var'125 = `var'32
	generate double `var'126 = `var'33
	generate double `var'127 = `var'58
	generate double `var'128 = `var'69
	}
foreach var in F1 F2 F3 F4 {
	replace `var' = `var'[17] if _n == 71
	replace `var' = `var'[30] if _n == 72
	}
foreach var in B1 B2 {
	replace `var' = `var'[32] if _n == 125
	replace `var' = `var'[33] if _n == 126
	replace `var' = `var'[58] if _n == 127
	replace `var' = `var'[59] if _n == 128
	}
aorder
save results\OBootstrapRedD, replace



