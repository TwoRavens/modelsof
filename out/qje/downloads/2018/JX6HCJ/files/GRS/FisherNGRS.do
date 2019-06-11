
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "") {
		capture `anything' `if' `in', `robust' absorb(`absorb')
		}
	else {
		capture `anything' `if' `in', `robust' 
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
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

global i = 10
global j = 14

*Table 6 - sm only available for 1958-1962, but highnumber missing for 1956 & 1957, so both regressions end up being 1958-1962
foreach var in arms property sexual murder threat drug whitecollar {
	mycmd (sm) ivreg `var' (sm = highnumber) COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust 
	}

matrix FIV = F
matrix BIV = B


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

sort cohort idnumber
generate Order = _n
generate double U = .
mata Y = st_data(.,("highnumber","hnmalvinas","navy"))
*Draft numbers that were intermediate are coded as . and excluded from regression (see paper).  Randomize these as well as they are part of the treatment randomization (i.e. allocation of draft numbers)
*Only applies to specifications that include 1955 or post-1965 (3 regressions), (tab cohort highnumber to see this)

mata ResF = J($reps,22,.); ResD = J($reps,22,.); ResDF = J($reps,22,.); ResB = J($reps,26,.); ResSE = J($reps,26,.)
forvalues c = 1/$reps {
	matrix FF = J(22,3,.)
	matrix BB = J(26,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort cohort U 
	mata st_store(.,("highnumber","hnmalvinas","navy"),Y)

global i = 1
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
	mycmd1 (highnumber) reg `var' highnumber COHORT2-COHORT5 if cohort > 1956 & cohort < 1963, robust 
	}

*Table 7
foreach var in formal unemployment income {
	mycmd1 (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1963, robust absorb(cohort)
	mycmd1 (highnumber) areg `var' highnumber if cohort > 1956 & cohort < 1966, robust absorb(cohort)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..22] = FF[.,1]'; ResD[`c',1..22] = FF[.,2]'; ResDF[`c',1..22] = FF[.,3]'
mata ResB[`c',1..26] = BB[.,1]'; ResSE[`c',1..26] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/22 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/26 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
svmat double FIV
svmat double BIV
gen N = _n
sort N
save results\FisherGRS, replace



