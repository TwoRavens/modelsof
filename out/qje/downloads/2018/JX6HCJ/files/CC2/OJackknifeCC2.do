
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) re]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `re'
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
	syntax anything [if] [in] [, cluster(string) re]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `re'
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

global b = 8

use DatCC2, clear

matrix B = J($b,1,.)

global j = 1

*Table 2 
mycmd (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh, re cluster(session)
mycmd (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh age18 age19 age20 age21 age22 gender raceAsian raceBlack raceHispanic raceMulti raceOther raisedAsia married employedFull employedPart onesib twosib moresib expensesSharedSpouse-expensesOther voted-volunteer, re cluster(session)

egen M = group(session)
sum M
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

global j = 1

*Table 2 
mycmd1 (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh, re cluster(session)
mycmd1 (ingroup outgroup inenh outenh) xtreg effort ingroup outgroup inenh outenh age18 age19 age20 age21 age22 gender raceAsian raceBlack raceHispanic raceMulti raceOther raisedAsia married employedFull employedPart onesib twosib moresib expensesSharedSpouse-expensesOther voted-volunteer, re cluster(session)

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
save results\OJackknifeCC2, replace


