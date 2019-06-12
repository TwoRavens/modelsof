****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', 
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
	syntax anything [if] [in] [, cluster(string) robust ]
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

global b = 12

use DatFJP, clear

matrix B = J($b,1,.)

global j = 1
foreach var in taken_new tdeposits Dummy_Client_Income Talk_Fam {
	mycmd (tookup TookUp_muslim TookUp_Hindu_SC_Kat) ivreg `var' (tookup TookUp_muslim TookUp_Hindu_SC_Kat = Treated Treated_Hindu_SC_Kat Treated_muslim ) Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, cluster(t_group)
	}

egen M = group(t_group)
quietly sum M
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

global j = 1
foreach var in taken_new tdeposits Dummy_Client_Income Talk_Fam {
	mycmd1 (tookup TookUp_muslim TookUp_Hindu_SC_Kat) ivreg `var' (tookup TookUp_muslim TookUp_Hindu_SC_Kat = Treated Treated_Hindu_SC_Kat Treated_muslim ) Hindu_SC_Kat muslim SEWACENTER2-SEWACENTER4 TMONTH2-TMONTH8 SAMPLINGPHASE2, cluster(t_group)
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
save results\OJackknifeFJP, replace


