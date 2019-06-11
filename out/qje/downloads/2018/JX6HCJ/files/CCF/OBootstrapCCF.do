
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" == "") `anything' `if' `in', cluster(`cluster') `robust'
	if ("`absorb'" ~= "") `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
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
	if ("`absorb'" == "") capture `anything' `if' `in', cluster(`cluster') `robust'
	if ("`absorb'" ~= "") capture `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
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

use DatCCF1, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Tables 3 & 5
mycmd (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid) 
mycmd (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2-sited4 if date >= 23, absorb(name) cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named235 sited2-sited4 if date >= 23, cluster(billid)
mycmd (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2-sited4, absorb(name) cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named235 sited2-sited4, cluster(billid)

gen Order = _n
sort billid Order
gen N = 1
gen Dif = (billid ~= billid[_n-1])
replace N = N[_n-1] + Dif if _n > 1
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
	drop billid
	rename obs billid

global i = 1
global j = 1

*Tables 3 & 5
mycmd1 (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid) 
mycmd1 (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2-sited4 if date >= 23, absorb(name) cluster(billid)
mycmd1 (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd1 (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named235 sited2-sited4 if date >= 23, cluster(billid)
mycmd1 (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd1 (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2-sited4, absorb(name) cluster(billid)
mycmd1 (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd1 (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named235 sited2-sited4, cluster(billid)

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
save ip\OBootstrapCCF1, replace

*************************************
*************************************

global a = 8
global b = 16

use DatCCF2, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table 4 & 6
mycmd (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2 if date >= 23, absorb(name) cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named115 sited2 if date >= 23, cluster(billid)
mycmd (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2, absorb(name) cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named115 sited2, cluster(billid)

gen Order = _n
sort billid Order
gen N = 1
gen Dif = (billid ~= billid[_n-1])
replace N = N[_n-1] + Dif if _n > 1
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
	drop billid
	rename obs billid

global i = 1
global j = 1

*Table 4 & 6
mycmd1 (treat treattop5) reg p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd1 (treat treattop5) areg p treat treattop5 top5 totaldish lbill sited2 if date >= 23, absorb(name) cluster(billid)
mycmd1 (treat treattop5) probit p treat treattop5 top5 if date >= 23, cluster(billid)
mycmd1 (treat treattop5) probit p treat treattop5 top5 totaldish lbill named2-named115 sited2 if date >= 23, cluster(billid)
mycmd1 (treatafter treattop5after) reg p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd1 (treatafter treattop5after) areg p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill sited2, absorb(name) cluster(billid)
mycmd1 (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after, cluster(billid)
mycmd1 (treatafter treattop5after) probit p treatafter treattop5after treat treattop5 after top5 top5after totaldish lbill named2-named115 sited2, cluster(billid)

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
save ip\OBootstrapCCF2, replace

*************************************
*************************************


*Combining files

use ip\OBootstrapCCF2, clear
mkmat F1-F4 in 1/8, matrix(FF)
mkmat B1 B2 in 1/16, matrix(BB)
forvalues i = 8(-1)1 {
	local j = `i' + 8
	rename ResFF`i' ResFF`j'
	rename ResF`i' ResF`j'
	rename ResDF`i' ResDF`j'
	rename ResD`i' ResD`j'
	}
forvalues i = 16(-1)1 {
	local j = `i' + 16
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
drop F1-F4 B1 B2
sort N
save aa, replace

use ip\OBootstrapCCF1, clear
mkmat F1-F4 in 1/8, matrix(F)
mkmat B1 B2 in 1/16, matrix(B)
matrix F = F \ FF
matrix B = B \ BB
drop F1-F4 B1 B2
sort N
merge N using aa
tab _m
drop _m
sort N
svmat double F
svmat double B
save results\OBootstrapCCF, replace

erase aa.dta
erase aaa.dta

