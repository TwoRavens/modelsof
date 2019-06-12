
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ll hc3 robust vce(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', `ll' `hc3' `robust' vce(`vce')
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
	syntax anything [if] [in] [, ll hc3 robust vce(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `ll' `hc3' `robust' vce(`vce')
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
global b = 11

use DatLMW, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 1
mycmd (sorting) reg percshared sorting , hc3
mycmd (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, hc3
mycmd (sorting) tobit percshared sorting , ll vce(jackknife)
mycmd (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll vce(jackknife)	
mycmd (sorting) probit percshared sorting , robust
mycmd (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, robust

*Table 2
mycmd (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, hc3
mycmd (sorting) reg percshared sorting , hc3

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

*Table 1
mycmd1 (sorting) reg percshared sorting , hc3
mycmd1 (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, hc3
mycmd1 (sorting) tobit percshared sorting , ll vce(jackknife)
mycmd1 (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll vce(jackknife)	
mycmd1 (sorting) probit percshared sorting , robust
mycmd1 (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, robust

*Table 2
mycmd1 (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, hc3
mycmd1 (sorting) reg percshared sorting , hc3

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
save results\OBootstrapLMW, replace

erase aa.dta
erase aaa.dta

