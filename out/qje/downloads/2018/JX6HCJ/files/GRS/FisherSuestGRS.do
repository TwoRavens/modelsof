

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
		capture drop Ssample*
		estimates clear
		}
	global i = $i + 1

	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	if ("`cmd'" == "reg" | "`cmd'" == "areg" | "`cmd'" == "regress") {
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatGRS, clear

*Table 4 
global i = 0
foreach specification in " " "indigenous naturalized dist*" {
	mycmd (highnumber) areg crimerate highnumber `specification' if cohort > 1957 & cohort < 1963, robust absorb(cohort)
	}
foreach specification in "cohort > 1928 & cohort < 1966" "cohort > 1928 & cohort < 1957" "cohort > 1956 & cohort < 1966" {
	mycmd (highnumber) areg crimerate highnumber if `specification', robust absorb(cohort)
	}

quietly suest $M, robust
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 4)

*dropping colinear

*Table 5 
global i = 0
foreach specification in "hnmalvinas" "navy" {
	foreach period in "cohort > 1928 & cohort < 1966" "cohort > 1956 & cohort < 1966" {
		mycmd (highnumber `specification') areg crimerate highnumber `specification' if `period', absorb(cohort) robust
		}
	}

quietly suest $M, robust
test xxhighnumber1 xxhighnumber2 xxhnmalvinas2 xxhighnumber3 xxnavy3 xxhighnumber4 xxnavy4
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

*Examine these with intent to treat, as can't do suest for ivregs
*Table 6 - sm only available for 1958-1962, but highnumber missing for 1956 & 1957, so both regressions end up being 1958-1962
global i = 0
foreach var in arms property sexual murder threat drug whitecollar {
	mycmd (highnumber) reg `var' highnumber COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust 
	}
quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

*Table 7
global i = 0
foreach var in formal unemployment income {
	mycmd (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
	mycmd (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)
	}

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

sort cohort idnumber
generate Order = _n
generate double U = .
mata Y = st_data(.,("highnumber","hnmalvinas","navy"))
*Draft numbers that were intermediate are coded as . and excluded from regression (see paper).  Randomize these as well as they are part of the treatment randomization (i.e. allocation of draft numbers)
*Only applies to specifications that include 1955 or post-1965 (3 regressions), (tab cohort highnumber to see this)

mata ResF = J($reps,20,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort cohort U 
	mata st_store(.,("highnumber","hnmalvinas","navy"),Y)


*Table 4 
global i = 0
foreach specification in " " "indigenous naturalized dist*" {
	mycmd (highnumber) areg crimerate highnumber `specification' if cohort > 1957 & cohort < 1963, robust absorb(cohort)
	}
foreach specification in "cohort > 1928 & cohort < 1966" "cohort > 1928 & cohort < 1957" "cohort > 1956 & cohort < 1966" {
	mycmd (highnumber) areg crimerate highnumber if `specification', robust absorb(cohort)
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

*Table 5 
global i = 0
foreach specification in "hnmalvinas" "navy" {
	foreach period in "cohort > 1928 & cohort < 1966" "cohort > 1956 & cohort < 1966" {
		mycmd (highnumber `specification') areg crimerate highnumber `specification' if `period', absorb(cohort) robust
		}
	}

capture suest $M, robust
if (_rc == 0) {
	capture test xxhighnumber1 xxhighnumber2 xxhnmalvinas2 xxhighnumber3 xxnavy3 xxhighnumber4 xxnavy4
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}


*Table 6 - sm only available for 1958-1962, but highnumber missing for 1956 & 1957, so both regressions end up being 1958-1962
global i = 0
foreach var in arms property sexual murder threat drug whitecollar {
	mycmd (highnumber) reg `var' highnumber COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust 
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
		}
	}

*Table 7
global i = 0
foreach var in formal unemployment income {
	mycmd (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
	mycmd (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 7)
		}
	}
}


drop _all
set obs $reps
forvalues i = 1/20 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save results\FisherSuestGRS, replace



