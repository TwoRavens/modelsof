
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', absorb(`absorb')
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
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
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

global reps = 640

global b = 16

use DatABHOT1, clear

matrix B = J(197,1,.)

global j = 1
*Table 3 
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID) areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea) 

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if hhea == `c'

global j = 1
*Table 3 
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
	}
mycmd1 (COMMUNITY HYBRID) areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea) 

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeABHOT1, replace

***********************************
***********************************

global b = 64

use DatABHOT2, clear

global j = 17
*Table 4
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg `k' COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg CONSUMPTION COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy if RTS==1, absorb(kecagroup) cluster(hhea) 

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if hhea == `c'

global j = 1
*Table 4
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd1 (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg `k' COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy, absorb(kecagroup) cluster(hhea)
	}
mycmd1 (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg CONSUMPTION COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy if RTS==1, absorb(kecagroup) cluster(hhea) 

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 17/80 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeABHOT2, replace

***********************************
***********************************

global b = 10

use DatABHOT3a, clear

global j = 81
*Table 6
foreach k in e_q6 e_q8 e_q14 e_q15num e_q17num {
	if ("`k'" == "e_q6" | "`k'" == "e_q8") {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
		}
	}

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"
preserve

drop if hhea == `c'

global j = 1
*Table 6
foreach k in e_q6 e_q8 e_q14 e_q15num e_q17num {
	if ("`k'" == "e_q6" | "`k'" == "e_q8") {
		mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
		}
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 81/90 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeABHOT3a, replace

***********************************
***********************************

global b = 18

use DatABHOT3b, clear

global j = 91
*Table 6
foreach k in c_q3 c_q11a D_add D_subtract ncomplain ndontagree ncomplain_receivedbyRT a_q7 method_meeting {
	if "`k'" ~= "D_add" & "`k'" ~= "D_subtract" & "`k'" ~= "a_q7" & "`k'" ~= "method_meeting" {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) robust
		}
	}

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if hhea == `c'

global j = 1
*Table 6
foreach k in c_q3 c_q11a D_add D_subtract ncomplain ndontagree ncomplain_receivedbyRT a_q7 method_meeting {
	if "`k'" ~= "D_add" & "`k'" ~= "D_subtract" & "`k'" ~= "a_q7" & "`k'" ~= "method_meeting" {
		mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) robust
		}
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 91/108 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeABHOT3b, replace

***********************************
***********************************

global b = 3

use DatABHOT3, clear

global j = 109
*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if hhea == `c'

global j = 1
*Table 7
mycmd1 (COMMUNITY HYBRID ELITE) areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 109/111 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeABHOT3, replace

***********************************
***********************************

global b = 31

use DatABHOT4, clear

global j = 112
*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if hhea == `c'

global j = 1
*Table 7
mycmd1 (COMMUNITY HYBRID ELITE) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 112/142 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeABHOT4, replace

***********************************
***********************************

global b = 9

use DatABHOT5, clear

global j = 143
*Table 8
mycmd (HYBRID random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB HYBRID random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB random_rank) areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if hhea == `c'

global j = 1
*Table 8
mycmd1 (HYBRID random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (random_rankHYB HYBRID random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (HYBRID random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (random_rankHYB random_rank) areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 143/151 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeABHOT5, replace

***********************************
***********************************

global b = 8

use DatABHOT6, clear

global j = 152
*Table 9
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
	}

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if hhea == `c'

global j = 1
*Table 9
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 152/159 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeABHOT6, replace

***********************************
***********************************

global b = 13

use DatABHOT7, clear

global j = 160
*Table 10
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if hhea == `c'

global j = 1
*Table 10
mycmd1 (HYBRID DAYMEETING ELITE POOREST10) areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd1 (HYBRID DAYMEETING ELITE POOREST10) areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 160/172 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeABHOT7, replace

***********************************
***********************************

global b = 5

use DatABHOT8, clear

global j = 173
*Table 10
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if hhea == `c'

global j = 1
*Table 10
mycmd1 (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 173/177 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeABHOT8, replace

***********************************
***********************************

global b = 20

use DatABHOT9, clear

global j = 178
*Table 10
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
	}

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if hhea == `c'

global j = 1
*Table 10
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd1 (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
	}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 178/197 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeABHOT9, replace

***********************************
***********************************
use ip\OJackknifeABHOT1, clear
foreach j in 2 3a 3b 3 4 5 6 7 8 9 {
	merge 1:1 N using ip\OJackknifeABHOT`j', nogenerate
	}
svmat double B
aorder
save results\OJackknifeABHOT, replace



