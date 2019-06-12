
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" =="") `anything' `if' `in', `robust'
	if ("`absorb'" ~="") `anything' `if' `in', absorb(`absorb') `robust'
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
	syntax anything [if] [in] [, absorb(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" =="") capture `anything' `if' `in', `robust'
	if ("`absorb'" ~="") capture `anything' `if' `in', absorb(`absorb') `robust'
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

global a = 7
global b = 18

use DatMMW2, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table 2 
mycmd (treat1 treat2 treat3 treat4) reg tookup treat1 treat2 treat3 treat4, robust
mycmd (treat1 treat2 treat3 treat4) areg tookup treat1 treat2 treat3 treat4, robust absorb(strata)
*Table 3
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust

gen N = _n
sort N
save aa, replace

egen NN = max(N)
keep NN
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

*Table 2 
mycmd1 (treat1 treat2 treat3 treat4) reg tookup treat1 treat2 treat3 treat4, robust
mycmd1 (treat1 treat2 treat3 treat4) areg tookup treat1 treat2 treat3 treat4, robust absorb(strata)

*Table 3
mycmd1 (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd1 (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd1 (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd1 (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust
mycmd1 (treat3 treat4) probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust

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
save results\OBootstrapMMW2, replace

erase aa.dta
erase aaa.dta

