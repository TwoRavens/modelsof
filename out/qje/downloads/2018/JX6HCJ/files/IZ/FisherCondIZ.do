

*randomize at authors' level


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster')
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

use DatIZ, clear

matrix F = J(38,4,.)
matrix B = J(38,2,.)

global i = 1
global j = 1

*Table 2
foreach a of varlist time1 time3 time7 time14 time28 time56 { 
	foreach b of varlist m1134 m1831 m2428 m3284 m5171 {
		mycmd (treatment) regress dmt treatment if `a'==1 & `b'==1, 
		}
	}

*Table 3
foreach condition in "" "if pv<fv" {
	foreach specification in "" "C2-FI8" "H2-H7" "C2-H7" {
		mycmd (treatment) regress pv treatment Y2-Y30 `specification' `condition', cluster(id)
		}
	}

global i = 0

*Table 2
foreach a of varlist time1 time3 time7 time14 time28 time56 { 
	foreach b of varlist m1134 m1831 m2428 m3284 m5171 {
	global i = $i + 1
		randcmdc ((treatment) regress dmt treatment if `a'==1 & `b'==1, ), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(id)
		}
	}

*Table 3
foreach condition in "" "if pv<fv" {
	foreach specification in "" "C2-FI8" "H2-H7" "C2-H7" {
	global i = $i + 1
		randcmdc ((treatment) regress pv treatment Y2-Y30 `specification' `condition', cluster(id)), treatvars(treatment) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(id)
		}
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
save results\FisherCondIZ, replace


