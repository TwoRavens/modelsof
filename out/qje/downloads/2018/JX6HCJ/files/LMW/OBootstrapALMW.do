
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ll robust cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', `ll' `robust' cluster(`cluster')
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
	syntax anything [if] [in] [, ll robust cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `ll' `robust' cluster(`cluster')
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


*clustering at treatment level

****************************************
****************************************

global a = 7
global b = 10

use DatLMW, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 1
mycmd (sorting) reg percshared sorting , cluster(session)
mycmd (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, cluster(session)
mycmd (sorting) tobit percshared sorting , ll cluster(session)
mycmd (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll cluster(session)
mycmd (sorting) probit percshared sorting , cluster(session)
mycmd (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, cluster(session)

*Table 2
mycmd (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, cluster(session)

gen Order = _n
sort session Order
gen N = 1
gen Dif = (session ~= session[_n-1])
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
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop session
	rename obs session

global i = 1
global j = 1

*Table 1
mycmd1 (sorting) reg percshared sorting , cluster(session)
mycmd1 (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, cluster(session)
mycmd1 (sorting) tobit percshared sorting , ll cluster(session)
mycmd1 (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll cluster(session)
mycmd1 (sorting) probit percshared sorting , cluster(session)
mycmd1 (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, cluster(session)

*Table 2
mycmd1 (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, cluster(session)

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
save results\OBootstrapALMW, replace

erase aa.dta
erase aaa.dta


use results\OBootstrapALMW, clear
gen double ResB11 = ResB1
gen double ResSE11 = ResSE1
foreach var in ResF ResFF ResD ResDF {
	gen double `var'8 = `var'1
	}
quietly replace B1 = B1[1] if _n == 11
quietly replace B2 = B2[1] if _n == 11
forvalues i = 1/4 {
	quietly replace F`i' = F`i'[1] if _n == 8
	}
aorder
save results\OBootstrapALMW, replace

