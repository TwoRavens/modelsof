
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', absorb(`absorb') cluster(`cluster')
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
	syntax anything [if] [in] [, absorb(string) cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', absorb(`absorb') cluster(`cluster')
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
global b = 16

use DatLLLPR, clear

egen Cluster = group(month date id), label

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table 3 
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_list, absorb(id) cluster(Cluster)
mycmd (small_gift large_gift warm_small warm_large) areg donation small_gift large_gift warm_small warm_large warm_list, absorb(id) cluster(Cluster)
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id) cluster(Cluster)
	
*Table 4 
mycmd (small_gift large_gift) areg give small_gift large_gift warm_list, absorb(id) cluster(Cluster)
mycmd (small_gift large_gift warm_small warm_large) areg give small_gift large_gift warm_small warm_large warm_list, absorb(id) cluster(Cluster)
mycmd (small_gift large_gift) areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id) cluster(Cluster)

gen Order = _n
sort Cluster Order
gen N = 1
gen Dif = (Cluster ~= Cluster[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.); ResDC = J($reps,$b,.); B = st_matrix("B")
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,3,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop Cluster
	rename obs Cluster


global i = 1
global j = 1

*Table 3 
mycmd1 (small_gift large_gift) areg donation small_gift large_gift warm_list, absorb(id) cluster(Cluster)
mycmd1 (small_gift large_gift warm_small warm_large) areg donation small_gift large_gift warm_small warm_large warm_list, absorb(id) cluster(Cluster)
mycmd1 (small_gift large_gift) areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id) cluster(Cluster)
	
*Table 4 
mycmd1 (small_gift large_gift) areg give small_gift large_gift warm_list, absorb(id) cluster(Cluster)
mycmd1 (small_gift large_gift warm_small warm_large) areg give small_gift large_gift warm_small warm_large warm_list, absorb(id) cluster(Cluster)
mycmd1 (small_gift large_gift) areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id) cluster(Cluster)

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
save results\OBootstrapALLLPR, replace

erase aa.dta
erase aaa.dta

