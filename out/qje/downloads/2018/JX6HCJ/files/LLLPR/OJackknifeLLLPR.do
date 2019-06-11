
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', absorb(`absorb')
	capture testparm `testvars'
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
	syntax anything [if] [in] [, absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', absorb(`absorb')
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

global b = 16

use DatLLLPR, clear

matrix B = J($b,1,.)

global j = 1

*Table 3 
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_list, absorb(id)
mycmd (small_gift large_gift warm_small warm_large) areg donation small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd (small_gift large_gift) areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id)
	
*Table 4 
mycmd (small_gift large_gift) areg give small_gift large_gift warm_list, absorb(id)
mycmd (small_gift large_gift warm_small warm_large) areg give small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd (small_gift large_gift) areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id)

global reps = _N

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	if (ceil(`c'/50)*50 == `c') display "`c'"

preserve

drop if _n == `c'

global j = 1

*Table 3 
mycmd1 (small_gift large_gift) areg donation small_gift large_gift warm_list, absorb(id)
mycmd1 (small_gift large_gift warm_small warm_large) areg donation small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd1 (small_gift large_gift) areg donation small_gift large_gift warm_pVCM warm_pLotto, absorb(id)
	
*Table 4 
mycmd1 (small_gift large_gift) areg give small_gift large_gift warm_list, absorb(id)
mycmd1 (small_gift large_gift warm_small warm_large) areg give small_gift large_gift warm_small warm_large warm_list, absorb(id)
mycmd1 (small_gift large_gift) areg give small_gift large_gift warm_pVCM warm_pLotto, absorb(id)

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
save results\OJackknifeLLLPR, replace


