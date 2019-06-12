
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

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) re]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', cluster(`cluster') `re'
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
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

bysort session: gen N = _n
sort N session
global N = 18
mata Y = st_data((1,$N),("ingroup","outgroup","inenh","outenh"))
generate Order = _n
generate double U = .

mata ResF = J($reps,2,.); ResD = J($reps,2,.); ResDF = J($reps,2,.); ResB = J($reps,8,.); ResSE = J($reps,8,.)
forvalues c = 1/$reps {
	matrix FF = J(2,3,.)
	matrix BB = J(8,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("ingroup","outgroup","inenh","outenh"),Y)
	sort session N
	foreach j in ingroup outgroup inenh outenh {
		quietly replace `j' = `j'[_n-1] if session == session[_n-1]
		}
global i = 1
global j = 1

*Table 2 
mycmd1 (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh, re cluster(session)
mycmd1 (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh age18 age19 age20 age21 age22 gender raceAsian raceBlack raceHispanic raceMulti raceOther raisedAsia married employedFull employedPart onesib twosib moresib expensesSharedSpouse-expensesOther voted-volunteer, re cluster(session)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..2] = FF[.,1]'; ResD[`c',1..2] = FF[.,2]'; ResDF[`c',1..2] = FF[.,3]' 
mata ResB[`c',1..8] = BB[.,1]'; ResSE[`c',1..8] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/2 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/8 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\FisherCC2, replace





