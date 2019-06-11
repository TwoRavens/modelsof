
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end


****************************************
****************************************

global b = 38

use DatIZ, clear

matrix B = J($b,1,.)

global j = 1

*Table 2
foreach a of varlist time1 time3 time7 time14 time28 time56 { 
	foreach b of varlist m1134 m1831 m2428 m3284 m5171 {
		mycmd (treatment) regress dmt treatment if `a'==1 & `b'==1
		}
	}

*Table 3
foreach condition in "" "if pv<fv" {
	foreach specification in "" "C2-FI8" "H2-H7" "C2-H7" {
		mycmd (treatment) regress pv treatment Y2-Y30 `specification' `condition', cluster(id)
		}
	}
	
egen M = group(id)
quietly sum M
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

global j = 1

*Table 2
foreach a of varlist time1 time3 time7 time14 time28 time56 { 
	foreach b of varlist m1134 m1831 m2428 m3284 m5171 {
		mycmd1 (treatment) regress dmt treatment if `a'==1 & `b'==1
		}
	}

*Table 3
foreach condition in "" "if pv<fv" {
	foreach specification in "" "C2-FI8" "H2-H7" "C2-H7" {
		mycmd1 (treatment) regress pv treatment Y2-Y30 `specification' `condition', cluster(id)
		}
	}
	
mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
svmat double B
gen N = _n
save results\OJackknifeIZ, replace



