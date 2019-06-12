
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xxx* 
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
			quietly predict double xxx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		quietly reg yyy$i `newtestvars', noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xxx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
	local i = 0
	foreach var in `newtestvars' {
		matrix B[$j+`i',1] = _b[`var'], _se[`var']
		local i = `i' + 1
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

global j = $j + $k
end

****************************************
****************************************

matrix B = J(197,2,.)
global j = 1

use DatABHOT1, clear

*Table 3 
global i = 0
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID) areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea) 

quietly suest $M, cluster(hhea)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

*******************************************

use DatABHOT2, clear

renpfix COMMUNITY_ CC

*Table 4
global i = 0
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID CCURBAN HYBRID_URBAN CChighINEQUALdummy HYBRID_highINEQUALdummy CCconnectedness_dummy HYBRID_connectedness_dummy) areg `k' COMMUNITY HYBRID CCURBAN HYBRID_URBAN CChighINEQUALdummy HYBRID_highINEQUALdummy CCconnectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID CCURBAN HYBRID_URBAN CChighINEQUALdummy HYBRID_highINEQUALdummy CCconnectedness_dummy HYBRID_connectedness_dummy) areg CONSUMPTION COMMUNITY HYBRID CCURBAN HYBRID_URBAN CChighINEQUALdummy HYBRID_highINEQUALdummy CCconnectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy if RTS==1, absorb(kecagroup) cluster(hhea) 

quietly suest $M, cluster(hhea)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 4)

**************************************

use DatABHOT3a, clear
keep e_q6 e_q8 e_q14 e_q15num e_q17num COMMUNITY HYBRID kecagroup hhea
bysort hhea: gen N = _n
sort hhea N
save a1, replace

use DatABHOT3b, clear
keep c_q3 c_q11a D_add D_subtract ncomplain ndontagree ncomplain_receivedbyRT a_q7 method_meeting COMMUNITY HYBRID kecagroup hhea
bysort hhea: gen N = _n
sort hhea N
merge hhea N using a1
tab _m


global i = 0

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
foreach k in c_q3 c_q11a D_add D_subtract ncomplain ndontagree ncomplain_receivedbyRT a_q7 method_meeting {
	if "`k'" ~= "D_add" & "`k'" ~= "D_subtract" & "`k'" ~= "a_q7" & "`k'" ~= "method_meeting" {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) robust
		}
	}

quietly suest $M, cluster(hhea)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)


*********************************************************************

use DatABHOT3, clear
keep probattend COMMUNITY HYBRID ELITE kecagroup hhea
bysort hhea: gen N = _n
sort hhea N
save a1, replace

use DatABHOT4, clear
drop N
bysort hhea: gen N = _n
sort hhea N
merge hhea N using a1
tab _m

global i = 0

*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)

*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)

quietly suest $M, cluster(hhea)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

**************************************

use DatABHOT5, clear

*Table 8
global i = 0
mycmd (HYBRID random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB HYBRID random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB random_rank) areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

quietly suest $M, cluster(hhea)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 8)


************************************

use DatABHOT6, clear

*Table 9
global i = 0
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
	}

quietly suest $M, robust
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 9)


***********************************************

use DatABHOT7, clear
capture drop N
bysort hhea: gen N = _n
sort hhea N
save a1, replace

use DatABHOT8, clear
keep MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10 kecagroup hhea
bysort hhea: gen N = _n
sort hhea N
save a2, replace

use DatABHOT9, clear
keep RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main COMMUNITY HYBRID DAYMEETING ELITE POOREST10 kecagroup hhea
bysort hhea: gen N = _n
sort hhea N
forvalues i = 1/2 {
	merge hhea N using a`i'
	tab _m
	drop _m
	sort hhea N
	}

global i = 0

*Table 10
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)

*Table 10
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)

*Table 10
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
	}


quietly suest $M, cluster(hhea)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 10)

drop _all
svmat double F
svmat double B
save results/SuestABHOT, replace






