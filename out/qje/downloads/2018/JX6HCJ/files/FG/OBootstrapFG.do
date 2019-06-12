
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

global a = 6
global b = 6

use DatFG1, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

mycmd (high) areg totrev high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg totrev high exp block2 block3, absorb(fahrer) cluster(fahrer) 
mycmd (high) areg shifts high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd (high) areg shifts high exp block2 block3, absorb(fahrer) cluster(fahrer)

capture drop _m
sort fahrer
merge fahrer using Sample1
tab _m
sort N
drop _m
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
	drop fahrer
	rename obs fahrer

global i = 1
global j = 1

mycmd1 (high) areg totrev high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd1 (high) areg totrev high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd1 (high) areg totrev high exp block2 block3, absorb(fahrer) cluster(fahrer) 
mycmd1 (high) areg shifts high block2 block3 if maxhigh==1, absorb(fahrer) cluster(fahrer)
mycmd1 (high) areg shifts high block2 block3 if vebli==1, absorb(fahrer) cluster(fahrer)
mycmd1 (high) areg shifts high exp block2 block3, absorb(fahrer) cluster(fahrer)

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
save ip\OBootstrapFG1, replace

****************************************
****************************************

global a = 4
global b = 7

use DatFG2, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 5 
mycmd (high) areg lnum high lnten female, absorb(datum) cluster(datum) 
mycmd (high) areg lnum high lnten fdum*, absorb(datum) cluster(datum) 
*Table 6 
mycmd (high_la high_not) areg lnum high_la high_not lnten fdum*, absorb(datum) cluster(datum) 
mycmd (high_la1 high_la2 high_not0) areg lnum high_la1 high_la2 high_not0 lnten fdum*, absorb(datum) cluster(datum) 

capture drop _m
sort fahrer
merge fahrer using Sample1
tab _m
sort N
drop _m
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
	drop fahrer
	rename obs fahrer

	drop if lnum == .
	drop fdum*
	quietly tab fahrer, gen(fdum)
	drop fdum1

global i = 1
global j = 1
*Table 5 
mycmd1 (high) areg lnum high lnten female, absorb(datum) cluster(datum) 
mycmd1 (high) areg lnum high lnten fdum*, absorb(datum) cluster(datum) 
*Table 6 
mycmd1 (high_la high_not) areg lnum high_la high_not lnten fdum*, absorb(datum) cluster(datum) 
mycmd1 (high_la1 high_la2 high_not0) areg lnum high_la1 high_la2 high_not0 lnten fdum*, absorb(datum) cluster(datum) 

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
save ip\OBootstrapFG2, replace

******************************
******************************

use ip\OBootstrapFG2, clear
mkmat F1-F4 in 1/4, matrix(F2)
mkmat B1-B2 in 1/7, matrix(B2)
drop F1-F4 B1 B2 
forvalues i = 4(-1)1 {
	local j = `i' + 6
	rename ResFF`i' ResFF`j'
	rename ResF`i' ResF`j'
	rename ResDF`i' ResDF`j'
	rename ResD`i' ResD`j'
	}
forvalues i = 7(-1)1 {
	local j = `i' + 6
	rename ResB`i' ResB`j'
	rename ResSE`i' ResSE`j'
	}
sort N
save a, replace

use ip\OBootstrapFG1, clear
mkmat F1-F4 in 1/6, matrix(F1)
mkmat B1-B2 in 1/6, matrix(B1)
drop F1-F4 B1 B2 
sort N
merge N using a
tab _m
drop _m
sort N
aorder
matrix F = F1 \ F2
matrix B = B1 \ B2
svmat double B
svmat double F
save results\OBootstrapFG, replace

foreach file in aaa aa a bb {
	capture erase `file'.dta
	}











