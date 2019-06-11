
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
	syntax anything [if] [in] [, cluster(string) absorb(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`absorb'" ~= "" & "`cluster'" ~= "") {
		quietly `anything' `if' `in', cluster(`cluster') absorb(`absorb') `robust'
		}
	else if ("`absorb'" ~= "") {
		quietly `anything' `if' `in', absorb(`absorb') `robust'
		}
	else {
		quietly `anything' `if' `in', cluster(`cluster') `robust'
		}
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatABHOT1, clear

matrix F = J(8,4,.)
matrix B = J(16,2,.)

global i = 1
global j = 1
*Table 3 
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID) areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea) 

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),("COMMUNITY", "HYBRID"))
generate double U = .
generate Order = _n

mata ResF = J($reps,8,.); ResD = J($reps,8,.); ResDF = J($reps,8,.); ResB = J($reps,16,.); ResSE = J($reps,16,.)
forvalues c = 1/$reps {
	matrix FF = J(8,3,.)
	matrix BB = J(16,2,.)
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

global i = 1
global j = 1
*Table 3 
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
	}
mycmd1 (COMMUNITY HYBRID) areg CONSUMPTION COMMUNITY HYBRID if RTS==1, absorb(kecagroup) cluster(hhea) 

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..8] = FF[.,1]'; ResD[`c',1..8] = FF[.,2]'; ResDF[`c',1..8] = FF[.,3]'
mata ResB[`c',1..16] = BB[.,1]'; ResSE[`c',1..16] = BB[.,2]'

}


drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/8 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/16 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherABHOT1, replace

*******************************************

use DatABHOT2, clear

matrix F = J(8,4,.)
matrix B = J(64,2,.)

global i = 1
global j = 1
*Table 4
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg `k' COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy, absorb(kecagroup) cluster(hhea)
	}
mycmd (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg CONSUMPTION COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy if RTS==1, absorb(kecagroup) cluster(hhea) 

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),("COMMUNITY", "HYBRID"))
generate double U = .
generate Order = _n

mata ResF = J($reps,8,.); ResD = J($reps,8,.); ResDF = J($reps,8,.); ResB = J($reps,64,.); ResSE = J($reps,64,.)
forvalues c = 1/$reps {
	matrix FF = J(8,3,.)
	matrix BB = J(64,2,.)
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
	quietly replace COMMUNITY_connectedness_dummy = COMMUNITY * connectedness_dummy
	quietly replace HYBRID_connectedness_dummy = HYBRID * connectedness_dummy
	quietly replace COMMUNITY_URBAN = COMMUNITY*urban_dummy
	quietly replace HYBRID_URBAN = HYBRID*urban_dummy
	quietly replace COMMUNITY_highINEQUALdummy=COMMUNITY*highINEQUALdummy
	quietly replace HYBRID_highINEQUALdummy=HYBRID*highINEQUALdummy

global i = 1
global j = 1
*Table 4
foreach k in MISTARGETDUMMY MISTARGETNONPOORDUMMY MISTARGETPOORDUMMY MISTARGETRICHDUMMY  MISTARGETMIDDLEDUMMY MISTARGETNEARPOORDUMMY  MISTARGETVERYPOORDUMMY {
	mycmd1 (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg `k' COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy, absorb(kecagroup) cluster(hhea)
	}
mycmd1 (COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy) areg CONSUMPTION COMMUNITY HYBRID COMMUNITY_URBAN HYBRID_URBAN COMMUNITY_highINEQUALdummy HYBRID_highINEQUALdummy COMMUNITY_connectedness_dummy HYBRID_connectedness_dummy urban_dummy highINEQUALdummy connectedness_dummy if RTS==1, absorb(kecagroup) cluster(hhea) 

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..8] = FF[.,1]'; ResD[`c',1..8] = FF[.,2]'; ResDF[`c',1..8] = FF[.,3]'
mata ResB[`c',1..64] = BB[.,1]'; ResSE[`c',1..64] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/8 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/64 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherABHOT2, replace


**************************************

use DatABHOT3a, clear

matrix F = J(5,4,.)
matrix B = J(10,2,.)

global i = 1
global j = 1
*Table 6
foreach k in e_q6 e_q8 e_q14 e_q15num e_q17num {
	if ("`k'" == "e_q6" | "`k'" == "e_q8") {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) cluster(hhea)
		}
	}

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),("COMMUNITY", "HYBRID"))
generate double U = .
generate Order = _n

mata ResF = J($reps,5,.); ResD = J($reps,5,.); ResDF = J($reps,5,.); ResB = J($reps,10,.); ResSE = J($reps,10,.)
forvalues c = 1/$reps {
	matrix FF = J(5,3,.)
	matrix BB = J(10,2,.)
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

global i = 1
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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..5] = FF[.,1]'; ResD[`c',1..5] = FF[.,2]'; ResDF[`c',1..5] = FF[.,3]'
mata ResB[`c',1..10] = BB[.,1]'; ResSE[`c',1..10] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/5 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/10 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherABHOT3a, replace


*************************************

use DatABHOT3b, clear

matrix F = J(9,4,.)
matrix B = J(18,2,.)

global i = 1
global j = 1
*Table 6
foreach k in c_q3 c_q11a D_add D_subtract ncomplain ndontagree ncomplain_receivedbyRT a_q7 method_meeting {
	if "`k'" ~= "D_add" & "`k'" ~= "D_subtract" & "`k'" ~= "a_q7" & "`k'" ~= "method_meeting" {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
		}
	else {
		mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup) robust
		}
	}

sort kecagroup hhea
generate Order = _n
generate double U = .
mata Y = st_data(.,("COMMUNITY","HYBRID"))

mata ResF = J($reps,9,.); ResD = J($reps,9,.); ResDF = J($reps,9,.); ResB = J($reps,18,.); ResSE = J($reps,18,.)
forvalues c = 1/$reps {
	matrix FF = J(9,3,.)
	matrix BB = J(18,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort kecagroup U
	mata st_store(.,("COMMUNITY","HYBRID"),Y)

global i = 1
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

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..9] = FF[.,1]'; ResD[`c',1..9] = FF[.,2]'; ResDF[`c',1..9] = FF[.,3]'
mata ResB[`c',1..18] = BB[.,1]'; ResSE[`c',1..18] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/9 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/18 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherABHOT3b, replace



*********************************************************************

use DatABHOT3, clear

matrix F = J(1,4,.)
matrix B = J(3,2,.)

global i = 1
global j = 1
*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)

sort kecagroup hhea
mata Y = st_data(.,("COMMUNITY","HYBRID","ELITE"))
generate Order = _n
generate double U = .

mata ResF = J($reps,1,.); ResD = J($reps,1,.); ResDF = J($reps,1,.); ResB = J($reps,3,.); ResSE = J($reps,3,.)
forvalues c = 1/$reps {
	matrix FF = J(1,3,.)
	matrix BB = J(3,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort kecagroup U
	mata st_store(.,("COMMUNITY","HYBRID","ELITE"),Y)

global i = 1
global j = 1
*Table 7
mycmd1 (COMMUNITY HYBRID ELITE) areg probattend COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..1] = FF[.,1]'; ResD[`c',1..1] = FF[.,2]'; ResDF[`c',1..1] = FF[.,3]'
mata ResB[`c',1..3] = BB[.,1]'; ResSE[`c',1..3] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/1 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/3 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherABHOT3, replace

***************************

use DatABHOT4, clear

matrix F = J(5,4,.)
matrix B = J(31,2,.)

global i = 1
global j = 1
*Table 7
mycmd (COMMUNITY HYBRID ELITE) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),("COMMUNITY", "HYBRID", "ELITE"))
generate double U = .
generate Order = _n

mata ResF = J($reps,5,.); ResD = J($reps,5,.); ResDF = J($reps,5,.); ResB = J($reps,31,.); ResSE = J($reps,31,.)
forvalues c = 1/$reps {
	matrix FF = J(5,3,.)
	matrix BB = J(31,2,.)
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

global i = 1
global j = 1
*Table 7
mycmd1 (COMMUNITY HYBRID ELITE) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg MISTARGETDUMMY COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE C_elite_connectedness H_elite_connectedness E_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness) areg RTS COMMUNITY HYBRID ELITE ELITEHYBRID C_elite_connectedness H_elite_connectedness E_elite_connectedness E_H_elite_connectedness elite_connectedness, absorb(kecagroup) cluster(hhea)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..5] = FF[.,1]'; ResD[`c',1..5] = FF[.,2]'; ResDF[`c',1..5] = FF[.,3]'
mata ResB[`c',1..31] = BB[.,1]'; ResSE[`c',1..31] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/5 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/31 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherABHOT4, replace

**************************************

use DatABHOT5, clear

matrix F = J(4,4,.)
matrix B = J(9,2,.)

global i = 1
global j = 1
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

sort hhea rank
mata YY = st_data(.,"rank")

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),"HYBRID")
generate double U = .
generate Order = _n

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,9,.); ResSE = J($reps,9,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(9,2,.)
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

global i = 1
global j = 1
*Table 8
mycmd1 (HYBRID random_rank) areg MISTARGETDUMMY HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (random_rankHYB HYBRID random_rank) areg MISTARGETDUMMY random_rankHYB HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (HYBRID random_rank) areg RTS HYBRID random_rank, absorb(kecagroup) cluster(hhea)
mycmd1 (random_rankHYB random_rank) areg RTS random_rankHYB random_rank, absorb(kecagroup) cluster(hhea)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..9] = BB[.,1]'; ResSE[`c',1..9] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/9 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherABHOT5, replace


************************************

use DatABHOT6, clear

matrix F = J(4,4,.)
matrix B = J(8,2,.)

global i = 1
global j = 1
*Table 9
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
	}

sort kecagroup hhea
generate Order = _n
generate double U = .
mata Y = st_data(.,("COMMUNITY","HYBRID"))

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,8,.); ResSE = J($reps,8,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(8,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort kecagroup U
	mata st_store(.,("COMMUNITY","HYBRID"),Y)

global i = 1
global j = 1
*Table 9
foreach k in RANKCORRTREATCONSUMPTION_main RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd1 (COMMUNITY HYBRID) areg `k' COMMUNITY HYBRID, absorb(kecagroup)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..8] = BB[.,1]'; ResSE[`c',1..8] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/4 {
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
sort N
local file = "$file"
save ip\FisherABHOT6, replace

***********************************************

use DatABHOT7, clear

matrix F = J(3,4,.)
matrix B = J(13,2,.)

global i = 1
global j = 1
*Table 10
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd (HYBRID DAYMEETING ELITE POOREST10) areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)

sort kecagroup hhea
generate Order = _n
generate double U = .
mata Y = st_data(.,("COMMUNITY","HYBRID","DAYMEETING","ELITE","POOREST10"))

mata ResF = J($reps,3,.); ResD = J($reps,3,.); ResDF = J($reps,3,.); ResB = J($reps,13,.); ResSE = J($reps,13,.)
forvalues c = 1/$reps {
	matrix FF = J(3,3,.)
	matrix BB = J(13,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform()
	sort kecagroup U
	mata st_store(.,("COMMUNITY","HYBRID","DAYMEETING","ELITE","POOREST10"),Y)

global i = 1
global j = 1
*Table 10
mycmd1 (HYBRID DAYMEETING ELITE POOREST10) areg prob_total_HHattend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd1 (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg probattend COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)
mycmd1 (HYBRID DAYMEETING ELITE POOREST10) areg swomen_attend HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup) cluster(hhea)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..3] = FF[.,1]'; ResD[`c',1..3] = FF[.,2]'; ResDF[`c',1..3] = FF[.,3]'
mata ResB[`c',1..13] = BB[.,1]'; ResSE[`c',1..13] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/3 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/13 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherABHOT7, replace

**************************************************************************

use DatABHOT8, clear

matrix F = J(1,4,.)
matrix B = J(5,2,.)

global i = 1
global j = 1
*Table 10
mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)

capture drop N
bysort hhea: gen N = _n
sort N kecagroup hhea
global N = 640
mata Y = st_data((1,$N),("COMMUNITY","HYBRID","DAYMEETING","ELITE","POOREST10"))
generate double U = .
generate Order = _n

mata ResF = J($reps,1,.); ResD = J($reps,1,.); ResDF = J($reps,1,.); ResB = J($reps,5,.); ResSE = J($reps,5,.)
forvalues c = 1/$reps {
	matrix FF = J(1,3,.)
	matrix BB = J(5,2,.)
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

global i = 1
global j = 1
*Table 10
mycmd1 (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg MISTARGETDUMMY COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)  cluster(hhea)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..1] = FF[.,1]'; ResD[`c',1..1] = FF[.,2]'; ResDF[`c',1..1] = FF[.,3]'
mata ResB[`c',1..5] = BB[.,1]'; ResSE[`c',1..5] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/1 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/5 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherABHOT8, replace


*****************************************************

use DatABHOT9, clear

matrix F = J(4,4,.)
matrix B = J(20,2,.)

global i = 1
global j = 1
*Table 10
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
	}

sort kecagroup hhea
generate Order = _n
generate double U = .
mata Y = st_data(.,("COMMUNITY", "HYBRID", "DAYMEETING", "ELITE", "POOREST10"))

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,20,.); ResSE = J($reps,20,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(20,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	sort kecagroup U
	mata st_store(.,("COMMUNITY", "HYBRID", "DAYMEETING", "ELITE", "POOREST10"),Y)

global i = 1
global j = 1
*Table 10
foreach k in RANKCORRTREATCONSUMPTION_main  RANKCORRTREATCOMMUNITY_main RANKCORRTREATCOMMUNITY_RT1 RANKCORRTREATSW02_main {
	mycmd1 (COMMUNITY HYBRID DAYMEETING ELITE POOREST10) areg `k' COMMUNITY HYBRID DAYMEETING ELITE POOREST10, absorb(kecagroup)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..20] = BB[.,1]'; ResSE[`c',1..20] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/20 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherABHOT9, replace

***************************************************

*Combining files

matrix count = (8,8,5,9,1,5,4,4,3,1,4) \ (16,64,10,18,3,31,9,8,13,5,20)

drop _all
use ip\FisherABHOT1
global k = count[2,1]
global N = count[1,1]
mkmat F1-F4 in 1/$N, matrix(F)
mkmat B1 B2 in 1/$k, matrix(B)

local c = 2
foreach j in 2 3a 3b 3 4 5 6 7 8 9 {
	use ip\FisherABHOT`j', clear
	sort N
	global k1 = count[2,`c']
	global N1 = count[1,`c']
	local c = `c' + 1
mkmat F1-F4 in 1/$N1, matrix(FF)
mkmat B1 B2 in 1/$k1, matrix(BB)
	matrix F = F \ FF
	matrix B = B \ BB
	drop F1-F4 B1-B2 
	forvalues i = $k1(-1)1 {
		local k = `i' + $k
		rename ResB`i' ResB`k'
		rename ResSE`i' ResSE`k'
		}
	forvalues i = $N1(-1)1 {
		local k = `i' + $N
		rename ResF`i' ResF`k'
		rename ResDF`i' ResDF`k'
		rename ResD`i' ResD`k'
		}
	global k = $k + $k1
	global N = $N + $N1
	save a`j', replace
	}

use ip\FisherABHOT1, clear
drop F1-F4 B1-B2 
foreach j in 2 3a 3b 3 4 5 6 7 8 9 {
	sort N
	merge N using a`j'
	tab _m
	drop _m
	sort N
	}
aorder
svmat double F
svmat double B
save results\FisherABHOT, replace


foreach j in 2 3a 3b 3 4 5 6 7 8 9 {
	capture erase a`j'.dta
	}


