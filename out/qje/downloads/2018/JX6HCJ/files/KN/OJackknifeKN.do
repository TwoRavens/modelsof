
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

global b = 4

use DatKN, clear

matrix B = J($b,1,.)

global j = 1

*Table 2
foreach Y in Prod_Comm Prod_Points {
	foreach specification in "" "touchtype experiencedatabase concentration" {
		mycmd (award) reg `Y' award `specification' if treatment !=2, cluster(session1)
		}
	}

egen M = group(session1)
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
foreach Y in Prod_Comm Prod_Points {
	foreach specification in "" "touchtype experiencedatabase concentration" {
		mycmd1 (award) reg `Y' award `specification' if treatment !=2, cluster(session1)
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
save results\OJackknifeKN, replace




