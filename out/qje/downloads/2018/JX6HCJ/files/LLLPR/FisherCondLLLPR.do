
*randomizing at their assumed clustering level


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', absorb(`absorb')
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

*Treatment administered in blocks by solicitors, but authors don't cluster so as alternative randomize at obs level

use DatLLLPR.dta, clear

matrix F = J(6,4,.)
matrix B = J(16,2,.)

global i = 1
global j = 1

*Table 3 
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_list, absorb(id)
mycmd (small_gift large_gift warm_small warm_large) areg donation small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id)
	
*Table 4 
mycmd (small_gift large_gift) areg give small_gift large_gift warm_list, absorb(id)
mycmd (small_gift large_gift warm_small warm_large) areg give small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd (small_gift large_gift) areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id)
	
gen Order = _n

global i = 0
*Table 3
foreach var in small_gift large_gift {
	global i = $i + 1
	local a = "small_gift large_gift"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') areg donation small_gift large_gift warm_list, absorb(id)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}


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

foreach var in small_gift large_gift {
	global i = $i + 1
	local a = "small_gift large_gift"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

*Table 4
foreach var in small_gift large_gift {
	global i = $i + 1
	local a = "small_gift large_gift"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') areg give small_gift large_gift warm_list, absorb(id)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
	}

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

foreach var in small_gift large_gift {
	global i = $i + 1
	local a = "small_gift large_gift"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(`a')
	randcmdc ((`var') areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id)), treatvars(`var') strata(Strata) seed(1) saving(ip\a$i, replace) reps($reps) sample 
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
save results\FisherCondLLLPR, replace








