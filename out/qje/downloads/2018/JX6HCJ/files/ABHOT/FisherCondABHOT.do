
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) absorb(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "" & "`cluster'" ~= "") {
		`anything' `if' `in', cluster(`cluster') absorb(`absorb') `robust'
		}
	else if ("`absorb'" ~= "") {
		`anything' `if' `in', absorb(`absorb') `robust'
		}
	else {
		`anything' `if' `in', cluster(`cluster') `robust'
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$ii,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$jj+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global ii = $ii + 1
global jj = $jj + $k
end

****************************************
****************************************

use DatABHOT1, clear

matrix F = J(52,4,.)
matrix B = J(197,2,.)

global ii = 1
global jj = 1

*Table 3 
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID) areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea) 

global c = 0
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY MISTARGETVERYPOORDUMMY {
	foreach var in COMMUNITY HYBRID {
		global c = $c + 1
		capture drop Strata
		gen Strata = (maintreatment == 1 | `var' == 1)
		randcmdc ((`var') areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(kecagroup Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample groupvar(hhea)
		}
	}

foreach var in COMMUNITY HYBRID {
	global c = $c + 1
	capture drop Strata
	gen Strata = (maintreatment == 1 | `var' == 1)
	randcmdc ((`var') areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(kecagroup Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample groupvar(hhea)
	}


*******************************************

use DatABHOT2, clear

*Table 4
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg `k' COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg CONSUMPTION COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy if RTS==1, absorb(kecagroup) cluster(hhea) 

forvalues j = 1/64 {
	global c = $c + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\c$c, replace
	restore
	}

**************************************

use DatABHOT3a, clear

*Table 6
foreach k in e_q6 e_q8 e_q14 e_q15num e_q17num {
	if ("`k'" == "e_q6" | "`k'" == "e_q8") {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
		}
	}

*Table 6
foreach k in e_q6 e_q8 e_q14 e_q15num e_q17num {
	if ("`k'" == "e_q6" | "`k'" == "e_q8") {
		foreach var in COMMUNITY HYBRID {
			global c = $c + 1
			capture drop Strata
			gen Strata = (maintreatment == 1 | `var' == 1)
			randcmdc ((`var') areg `k' COMMUNITY HYBRID, absorb(kecagroup)), treatvars(`var') strata(kecagroup Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample groupvar(hhea)
			}
		}
	else {
		foreach var in COMMUNITY HYBRID {
			global c = $c + 1
			capture drop Strata
			gen Strata = (maintreatment == 1 | `var' == 1)
			randcmdc ((`var') areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(kecagroup Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample groupvar(hhea)
			}
		}
	}


*************************************

use DatABHOT3b, clear

*Table 6
foreach k in c_q3 c_q11a D_add D_subtract ncomplain ndontagree ncomplain_receivedbyRT a_q7 method_meeting {
	if "`k'" ~= "D_add" & "`k'" ~= "D_subtract" & "`k'" ~= "a_q7" & "`k'" ~= "method_meeting" {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) robust
		}
	}

foreach k in c_q3 c_q11a D_add D_subtract ncomplain ndontagree ncomplain_receivedbyRT a_q7 method_meeting {
	if "`k'" ~= "D_add" & "`k'" ~= "D_subtract" & "`k'" ~= "a_q7" & "`k'" ~= "method_meeting" {
		foreach var in COMMUNITY HYBRID {
			global c = $c + 1
			capture drop Strata
			gen Strata = (maintreatment == 1 | `var' == 1)
			randcmdc ((`var') areg `k' COMMUNITY HYBRID, absorb(kecagroup)), treatvars(`var') strata(kecagroup Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample 
			}
		}
	else {
		foreach var in COMMUNITY HYBRID {
			global c = $c + 1
			capture drop Strata
			gen Strata = (maintreatment == 1 | `var' == 1)
			randcmdc ((`var') areg `k' COMMUNITY HYBRID, absorb(kecagroup) robust), treatvars(`var') strata(kecagroup Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample 
			}
		}
	}


*********************************************************************

use DatABHOT3, clear

*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)

*Table 7
foreach var in COMMUNITY HYBRID ELITE {
	global c = $c + 1
	local a = "COMMUNITY HYBRID ELITE"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(kecagroup `a')
	randcmdc ((`var') areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample 
	}

***************************

use DatABHOT4, clear

*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)

*Table 7
foreach var in COMMUNITY HYBRID ELITE {
	global c = $c + 1
	local a = "COMMUNITY HYBRID ELITE"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(kecagroup `a')
	randcmdc ((`var') areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample groupvar(hhea)
	}

forvalues j = 1/28 {
	global c = $c + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\c$c, replace
	restore
	}

**************************************

use DatABHOT5, clear

*Table 8
mycmd (HYBRID random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB HYBRID random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB random_rank) areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

*Note last column doesn't include HYBRID (should, but doesn't).  If include doesn't match reported table - error in their code
*Note coefficient becomes insignificant when HYBRID is added, as in reported, but not used, specification
areg RTS random_rank random_rankHYB HYBRID, absorb(kecagroup) cluster(hhea)
*Note second column does include HYBRID.  If don't doesn't match table
areg MISTARGETDUMMY random_rank random_rankHYB, absorb(kecagroup) cluster(hhea)


foreach var in HYBRID {
	global c = $c + 1
	capture drop Strata
	egen Strata = group(kecagroup)
	randcmdc ((`var') areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample groupvar(hhea) 
	}

foreach var in random_rank {
	global c = $c + 1
	capture drop Strata
	egen Strata = group(kecagroup hhea)
	randcmdc ((`var') areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample 
	}


forvalues j = 1/3 {
	global c = $c + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\c$c, replace
	restore
	}

foreach var in HYBRID {
	global c = $c + 1
	capture drop Strata
	egen Strata = group(kecagroup)
	randcmdc ((`var') areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample groupvar(hhea)
	}

foreach var in random_rank {
	global c = $c + 1
	capture drop Strata
	egen Strata = group(kecagroup hhea)
	randcmdc ((`var') areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample 
	}

forvalues j = 1/2 {
	global c = $c + 1
	preserve
		drop _all
		set obs $reps
		foreach var in ResB ResSE ResF {
			gen `var' = .
			}
		gen __0000001 = 0 if _n == 1
		gen __0000002 = 0 if _n == 1
		save ip\c$c, replace
	restore
	}


************************************

*One obs per hhea

use DatABHOT6, clear

*Table 9
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
	}

*Table 9
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	foreach var in COMMUNITY HYBRID {
		global c = $c + 1
		local a = "COMMUNITY HYBRID"
		local a = subinstr("`a'","`var'","",1)
		capture drop Strata
		egen Strata = group(kecagroup `a')
		randcmdc ((`var') areg `k' COMMUNITY HYBRID, absorb(kecagroup)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample 
		}
	}



***********************************************

*One obs per hhea

use DatABHOT7, clear

*Table 10
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)

*Table 10
foreach var in HYBRID DAYMEETING ELITE POOREST10 {
	global c = $c + 1
	local a = "HYBRID DAYMEETING ELITE POOREST10"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(kecagroup `a')
	randcmdc ((`var') areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample 
	}

foreach var in COMMUNITY HYBRID DAYMEETING ELITE POOREST10 {
	global c = $c + 1
	local a = "COMMUNITY HYBRID DAYMEETING ELITE POOREST10"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(kecagroup `a')
	randcmdc ((`var') areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample 
	}

foreach var in HYBRID DAYMEETING ELITE POOREST10 {
	global c = $c + 1
	local a = "HYBRID DAYMEETING ELITE POOREST10"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(kecagroup `a')
	randcmdc ((`var') areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample 
	}


**************************************************************************

use DatABHOT8, clear

*Table 10
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)

*Table 10
foreach var in COMMUNITY HYBRID DAYMEETING ELITE POOREST10 {
	global c = $c + 1
	local a = "COMMUNITY HYBRID DAYMEETING ELITE POOREST10"
	local a = subinstr("`a'","`var'","",1)
	capture drop Strata
	egen Strata = group(kecagroup `a')
	randcmdc ((`var') areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample groupvar(hhea) 
	}


*****************************************************

*One obs per hhea

use DatABHOT9, clear

*Table 10
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
	}

*Table 10
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	foreach var in COMMUNITY HYBRID DAYMEETING ELITE POOREST10 {
		global c = $c + 1
		local a = "COMMUNITY HYBRID DAYMEETING ELITE POOREST10"
		local a = subinstr("`a'","`var'","",1)
		capture drop Strata
		egen Strata = group(kecagroup `a')
		randcmdc ((`var') areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)), treatvars(`var') strata(Strata) seed(1) saving(ip\c$c, replace) reps($reps) sample 
		}
	}


***************************************************

matrix T = J($c,2,.)
use ip\c1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$c {
	display "`i'"
	merge using ip\c`i'
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
save results\FisherCondABHOT, replace









