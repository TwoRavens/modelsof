
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" == "") {
		quietly `anything' `if' `in', `robust'
		}
	else {
		quietly `anything' `if' `in', `robust' absorb(`absorb')
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

use DatMMW2, clear

matrix F = J(7,4,.)
matrix B = J(18,2,.)

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

sort strata sheno
generate Order = _n

*Table 2
global i = 0
foreach var in treat1 treat2 treat3 treat4 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treatgroup == 5 | `var' == 1)
	randcmdc ((`var') reg tookup treat1 treat2 treat3 treat4, robust), treatvars(`var') strata(strata Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in treat1 treat2 treat3 treat4 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treatgroup == 5 | `var' == 1)
	randcmdc ((`var') areg tookup treat1 treat2 treat3 treat4, robust absorb(strata)), treatvars(`var') strata(strata Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

*Table 3
foreach var in treat3 treat4 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat2 == 1 | `var' == 1)
	randcmdc ((`var') probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust), treatvars(`var') strata(strata Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in treat3 treat4 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat2 == 1 | `var' == 1)
	randcmdc ((`var') probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 edn digitspan knowscost if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust), treatvars(`var') strata(strata Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in treat3 treat4 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat2 == 1 | `var' == 1)
	randcmdc ((`var') probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 morethan15emp exceedprofthreshold if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust), treatvars(`var') strata(strata Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in treat3 treat4 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat2 == 1 | `var' == 1)
	randcmdc ((`var') probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 hyperbolic riskseeker if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust), treatvars(`var') strata(strata Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}

foreach var in treat3 treat4 {
	global i = $i + 1
	capture drop Strata
	gen Strata = (treat2 == 1 | `var' == 1)
	randcmdc ((`var') probit tookup treat3 treat4 colombo retail manuf morethan2emp registerplus lnsales publiclocal2 lnbusinessassets if treatgroup>=2 & treatgroup<=4 & getoffer==1, robust), treatvars(`var') strata(strata Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample
	}



matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondMMW2, replace





