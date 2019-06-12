
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ll]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', `ll'
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

use DatCHKL, clear

matrix F = J(3,4,.)
matrix B = J(4,2,.)

global i = 1
global j = 1

*Table 7 
mycmd (dumconf dumnetb) tobit post_rating dumconf dumnetb pre_rating, ll 
mycmd (dumconf) tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
mycmd (dumnetb) tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 

generate N = _n
sort special N

gen dumconfback = dumconf
gen dumnetbback = dumnetb

*Table 7
global i = 0
foreach var in dumconf dumnetb {
	global i = $i + 1
	capture drop Strata
	gen Strata = (expcondition == "control" | `var' == 1)
	randcmdc ((`var') tobit post_rating dumconf dumnetb pre_rating, ll), treatvars(`var') strata(special Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample calc1(replace dumconf = dumconfback if special == 1) calc2(replace dumnetb = dumnetbback if special == 1) 
	}

foreach var in dumconf {
	global i = $i + 1
	capture drop Strata
	gen Strata = (expcondition == "control" | `var' == 1)
	randcmdc ((`var') tobit post_rating dumconf pre_rating if Strata == 1, ll), treatvars(`var') strata(special Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample calc1(replace dumconf = dumconfback if special == 1) calc2(replace dumnetb = dumnetbback if special == 1)
	}

foreach var in dumnetb {
	global i = $i + 1
	capture drop Strata
	gen Strata = (expcondition == "control" | `var' == 1)
	randcmdc ((`var') tobit post_rating dumnetb pre_rating if Strata == 1, ll), treatvars(`var') strata(special Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample calc1(replace dumconf = dumconfback if special == 1) calc2(replace dumnetb = dumnetbback if special == 1)
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
save results\FisherCondCHKL, replace


