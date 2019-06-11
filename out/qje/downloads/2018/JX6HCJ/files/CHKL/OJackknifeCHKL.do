
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ll]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', `ll'
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
	syntax anything [if] [in] [, ll]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `ll'
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

global b = 4

use DatCHKL, clear

matrix B = J($b,1,.)

global j = 1

*Table 7 
mycmd (dumconf dumnetb) tobit post_rating dumconf dumnetb pre_rating, ll 
mycmd (dumconf) tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
mycmd (dumnetb) tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 

global reps = _N
mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve
 	drop if _n == `c'
	global j = 1
	*Table 7 
	mycmd1 (dumconf dumnetb) tobit post_rating dumconf dumnetb pre_rating, ll 
	mycmd1 (dumconf) tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
	mycmd1 (dumnetb) tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 
	mata BB = st_matrix("BB"); ResB[`c',1...] = BB[1...,1]'
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
save results\OJackknifeCHKL, replace



