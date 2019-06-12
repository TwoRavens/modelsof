
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		`anything' `if' `in', `robust' absorb(`absorb')
		}
	else {
		`anything' `if' `in', `robust' 
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

use DatGRS, clear

matrix F = J(22,4,.)
matrix B = J(26,2,.)

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
	mycmd (highnumber) reg `var' highnumber COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust 
	}

*Table 7
foreach var in formal unemployment income {
	mycmd (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
	mycmd (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)
	}


global i = 0

*Table 4 
foreach specification in " " "indigenous naturalized dist*" {
	global i = $i + 1
	randcmdc ((highnumber) areg crimerate highnumber `specification' if cohort > 1957 & cohort < 1963, robust absorb(cohort)), treatvars(highnumber) strata(cohort) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

foreach specification in "cohort > 1928 & cohort < 1966" "cohort > 1928 & cohort < 1957" "cohort > 1956 & cohort < 1966" {
	global i = $i + 1
	randcmdc ((highnumber) areg crimerate highnumber if `specification', robust absorb(cohort)), treatvars(highnumber) strata(cohort) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 5 

*Can't individually randomize highnumber and hnmalvinas, given cohort are strata

forvalues j = 1/4 {
	global i = $i + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\a$i, replace
	restore
	}


foreach period in "cohort > 1928 & cohort < 1966" "cohort > 1956 & cohort < 1966" {
	foreach var in highnumber navy {
		global i = $i + 1
		local a = "highnumber navy"
		local a = subinstr("`a'","`var'","",1)
		capture drop NewStrata
		egen NewStrata = group(cohort `a')
		randcmdc ((`var') areg crimerate highnumber navy if `period', absorb(cohort) robust), treatvars(`var') strata(NewStrata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
		}
	}

*Table 6 - sm only available for 1958-1962, but highnumber missing for 1956 & 1957, so both regressions end up being 1958-1962
foreach var in arms property sexual murder threat drug whitecollar {
	global i = $i + 1
	randcmdc ((highnumber) reg `var' highnumber COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust), treatvars(highnumber) strata(cohort) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 7
foreach var in formal unemployment income {
	global i = $i + 1
	randcmdc ((highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)), treatvars(highnumber) strata(cohort) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	global i = $i + 1
	randcmdc ((highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)), treatvars(highnumber) strata(cohort) seed(1) saving(ip\a$i, replace) reps($reps) sample 
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
save results\FisherCondGRS, replace










