****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

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
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

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

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),("COMMUNITY", "HYBRID"))
generate double U = .
generate Order = _n

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N kecagroup U in 1/$N
	mata st_store((1,$N),("COMMUNITY","HYBRID"),Y)
	sort hhea N
	foreach j in COMMUNITY HYBRID {
		quietly replace `j' = `j'[_n-1] if hhea == hhea[_n-1] & N > 1
		}

global i = 0
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID) areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea) 

capture suest $M, cluster(hhea)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 3)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/5 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestABHOT1, replace

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

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),("COMMUNITY", "HYBRID"))
generate double U = .
generate Order = _n

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N kecagroup U in 1/$N
	mata st_store((1,$N),("COMMUNITY", "HYBRID"),Y)
	sort hhea N
	foreach j in COMMUNITY HYBRID {
		quietly replace `j' = `j'[_n-1] if hhea == hhea[_n-1] & N > 1
		}
	quietly replace CCconnectedness_dummy = COMMUNITY * connectedness_dummy
	quietly replace HYBRID_connectedness_dummy = HYBRID * connectedness_dummy
	quietly replace CCURBAN = COMMUNITY*urban_dummy
	quietly replace HYBRID_URBAN = HYBRID*urban_dummy
	quietly replace CChighINEQUALdummy=COMMUNITY*highINEQUALdummy
	quietly replace HYBRID_highINEQUALdummy=HYBRID*highINEQUALdummy

*Table 4
global i = 0
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID CCURBAN HYBRID_URBAN CChighINEQUALdummy HYBRID_highINEQUALdummy CCconnectedness_dummy HYBRID_connectedness_dummy) areg `k' COMMUNITY HYBRID CCURBAN HYBRID_URBAN CChighINEQUALdummy HYBRID_highINEQUALdummy CCconnectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID CCURBAN HYBRID_URBAN CChighINEQUALdummy HYBRID_highINEQUALdummy CCconnectedness_dummy HYBRID_connectedness_dummy) areg CONSUMPTION COMMUNITY HYBRID CCURBAN HYBRID_URBAN CChighINEQUALdummy HYBRID_highINEQUALdummy CCconnectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy if RTS==1, absorb(kecagroup) cluster(hhea) 

capture suest $M, cluster(hhea)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}
}

drop _all
set obs $reps
forvalues i = 6/10 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestABHOT2, replace


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

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),("COMMUNITY", "HYBRID"))
generate double U = .
generate Order = _n

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N kecagroup U in 1/$N
	mata st_store((1,$N),("COMMUNITY","HYBRID"),Y)
	sort hhea N
	foreach j in COMMUNITY HYBRID {
		quietly replace `j' = `j'[_n-1] if hhea == hhea[_n-1] & N > 1
		}

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

capture suest $M, cluster(hhea)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
		}
	}
}

drop _all
set obs $reps
forvalues i = 11/15 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestABHOT3, replace

**************************************

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
mycmd (COMMUNITY HYBRID ELITE) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)

quietly suest $M, cluster(hhea)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),("COMMUNITY", "HYBRID", "ELITE"))
generate double U = .
generate Order = _n

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N kecagroup U in 1/$N
	mata st_store((1,$N),("COMMUNITY","HYBRID","ELITE"),Y)
	sort hhea N
	foreach j in COMMUNITY HYBRID ELITE {
		quietly replace `j' = `j'[_n-1] if hhea == hhea[_n-1] & N > 1
		}
	quietly replace ELITEHYBRID = ELITE*HYBRID
	quietly replace C_elite_connectedness = COMMUNITY * elite_connectedness
	quietly replace H_elite_connectedness = HYBRID * elite_connectedness
	quietly replace E_elite_connectedness = ELITE * elite_connectedness
	quietly replace E_H_elite_connectedness = ELITEHYBRID * elite_connectedness

global i = 0
*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)

capture suest $M, cluster(hhea)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 7)
		}
	}
}

drop _all
set obs $reps
forvalues i = 16/20 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestABHOT4, replace

**************************************

use DatABHOT5, clear

*Table 8
global i = 0
mycmd (HYBRID random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB HYBRID random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB random_rank) areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

*removing colinear elements
global test = subinstr("$test","xxxrandom_rank3","",1)

quietly suest $M, cluster(hhea)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 8)

sort hhea rank
mata YY = st_data(.,"rank")

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),"HYBRID")
generate double U = .
generate Order = _n

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N kecagroup U in 1/$N
	mata st_store((1,$N),"HYBRID",Y)
	sort hhea N
	quietly replace HYBRID = HYBRID[_n-1] if hhea == hhea[_n-1] & N > 1
	quietly replace U = uniform()
	sort hhea U
	mata st_store(.,"random_rank",YY)
	quietly replace random_rankHYB=random_rank*HYBRID

*Table 8
global i = 0
mycmd (HYBRID random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB HYBRID random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd (random_rankHYB random_rank) areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

global test = subinstr("$test","xxxrandom_rank3","",1)

capture suest $M, cluster(hhea)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 8)
		}
	}
}

drop _all
set obs $reps
forvalues i = 21/25 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestABHOT5, replace

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

sort kecagroup hhea
generate Order = _n
generate double U = .
mata Y = st_data(.,("COMMUNITY","HYBRID"))

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort kecagroup U
	mata st_store(.,("COMMUNITY","HYBRID"),Y)

*Table 9
global i = 0
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
	}

capture suest $M, robust
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 9)
		}
	}
}

drop _all
set obs $reps
forvalues i = 26/30 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestABHOT6, replace

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
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
	}

quietly suest $M, cluster(hhea)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 10)

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),("COMMUNITY","HYBRID","DAYMEETING","ELITE","POOREST10"))
generate double U = .
generate Order = _n

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort N kecagroup U in 1/$N
	mata st_store((1,$N),("COMMUNITY","HYBRID","DAYMEETING","ELITE","POOREST10"),Y)
	sort hhea N
	foreach j in COMMUNITY HYBRID DAYMEETING ELITE POOREST10 {
		quietly replace `j' = `j'[_n-1] if hhea == hhea[_n-1] & N > 1
		}

global i = 0
*Table 10
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
	}

capture suest $M, cluster(hhea)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 10)
		}
	}
}

drop _all
set obs $reps
forvalues i = 31/35 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save ip\FisherSuestABHOT7, replace

**************************************************************************

use ip\FisherSuestABHOT1, clear
forvalues i = 2/7 {
	merge 1:1 N using ip\FisherSuestABHOT`i', nogenerate
	}
drop F*
svmat double F
aorder
save results\FisherSuestABHOT, replace




