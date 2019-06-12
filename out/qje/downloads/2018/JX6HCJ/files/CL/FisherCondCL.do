
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

use DatCL, clear

matrix F = J(2,4,.)
matrix B = J(8,2,.)

global i = 1
global j = 1
*Table 7
mycmd (paintings chat oo within_subj) reg attach_to_gr paintings chat oo within_subj, cluster(date)
mycmd (paintings chat oo within_subj) ologit attach_to_gr paintings chat oo within_subj, cluster(date)

egen Session = group(date)

global i = 0

*Table 7
foreach var in paintings chat oo within_subj {
	global i = $i + 1
	local a = "paintings chat oo within_subj"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') reg attach_to_gr paintings chat oo within_subj, cluster(date)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(Session)
	}

foreach var in paintings chat oo within_subj {
	global i = $i + 1
	local a = "paintings chat oo within_subj"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') ologit attach_to_gr paintings chat oo within_subj, cluster(date)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(Session)
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
save results\FisherCondCL, replace



