
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		capture `anything' `if' `in', absorb(`absorb')
		}
	else {
		capture `anything' `if' `in', 
		}
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
	syntax anything [if] [in] [, absorb(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		capture `anything' `if' `in', absorb(`absorb')
		}
	else {
		capture `anything' `if' `in', 
		}
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

global b = 26

use DatGRS, clear
*These cohorts not used anywhere
drop if cohort < 1929 
drop if cohort > 1965

matrix B = J($b,1,.)

global i = 1
global j = 1

*Table 4 
foreach specification in " " "indigenous naturalized dist*" {
	mycmd (highnumber) areg crimerate highnumber `specification' if cohort > 1957 & cohort < 1963, robust absorb(cohort)
	}
foreach specification in "cohort > 1928 & cohort < 1966" "cohort > 1928 & cohort < 1957" "cohort > 1956 & cohort < 1966" {
	mycmd (highnumber) areg crimerate highnumber if `specification', robust absorb(cohort)
	}

*Table 5 
foreach specification in "hnmalvinas" "navy" {
	foreach period in "cohort > 1928 & cohort < 1966" "cohort > 1956 & cohort < 1966" {
		mycmd (highnumber `specification') areg crimerate highnumber `specification' if `period', absorb(cohort) robust
		}
	}

*Table 6 - sm only available for 1958-1962, but highnumber missing for 1956 & 1957, so both regressions end up being 1958-1962
foreach var in arms property sexual murder threat drug whitecollar {
	mycmd (sm) ivreg `var' (sm = highnumber) COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust 
	}

*Table 7
foreach var in formal unemployment income {
	mycmd (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
	mycmd (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)
	}

global reps = _N

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if _n == `c'

global j = 1

*Table 4 
foreach specification in " " "indigenous naturalized dist*" {
	mycmd1 (highnumber) areg crimerate highnumber `specification' if cohort > 1957 & cohort < 1963, robust absorb(cohort)
	}
foreach specification in "cohort > 1928 & cohort < 1966" "cohort > 1928 & cohort < 1957" "cohort > 1956 & cohort < 1966" {
	mycmd1 (highnumber) areg crimerate highnumber if `specification', robust absorb(cohort)
	}

*Table 5 
foreach specification in "hnmalvinas" "navy" {
	foreach period in "cohort > 1928 & cohort < 1966" "cohort > 1956 & cohort < 1966" {
		mycmd1 (highnumber `specification') areg crimerate highnumber `specification' if `period', absorb(cohort) robust
		}
	}

*Table 6 - sm only available for 1958-1962, but highnumber missing for 1956 & 1957, so both regressions end up being 1958-1962
foreach var in arms property sexual murder threat drug whitecollar {
	mycmd1 (sm) ivreg `var' (sm = highnumber) COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust 
	}

*Table 7
foreach var in formal unemployment income {
	mycmd1 (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
	mycmd1 (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)
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
save results\OJackknifeGRS, replace


