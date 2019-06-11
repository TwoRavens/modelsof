
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) re]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `re'
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

use DatCC2, clear

matrix F = J(2,4,.)
matrix B = J(8,2,.)

global i = 1
global j = 1

*Table 2 
mycmd (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh, re cluster(session)
mycmd (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh age18 age19 age20 age21 age22 gender raceAsian raceBlack raceHispanic raceMulti raceOther raisedAsia married employedFull employedPart onesib twosib moresib expensesSharedSpouse-expensesOther voted-volunteer, re cluster(session)

global i = 0

*Table 2
foreach var in ingroup outgroup inenh outenh {
	global i = $i + 1
	local a = "ingroup outgroup inenh outenh"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') xtreg effort ingroup outgroup inenh outenh, re cluster(session)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(session)
	}

foreach var in ingroup outgroup inenh outenh {
	global i = $i + 1
	local a = "ingroup outgroup inenh outenh"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') xtreg effort ingroup outgroup inenh outenh age18 age19 age20 age21 age22 gender raceAsian raceBlack raceHispanic raceMulti raceOther raisedAsia married employedFull employedPart onesib twosib moresib expensesSharedSpouse-expensesOther voted-volunteer, re cluster(session)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(session)
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
save results\FisherCondCC2, replace



