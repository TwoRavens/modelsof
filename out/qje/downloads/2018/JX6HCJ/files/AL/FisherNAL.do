
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust logit]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`cluster'" ~= "") {
		`anything' `if' `in', cluster(`cluster') `logit'
		}
	else {
		`anything' `if' `in', `robust'
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
	syntax anything [if] [in] [, cluster(string) robust logit]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`cluster'" ~= "") {
		quietly `anything' `if' `in', cluster(`cluster') `logit'
		}
	else {
		quietly `anything' `if' `in', `robust'
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

*Part I - Tables 2 & 4 - 2001 regressions (treatment year only, not specification checks)

use DatAL1, clear

matrix F = J(32,4,.)
matrix B = J(32,2,0)

global i = 1
global j = 1
*Table 2
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g', cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g', logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, logit cluster(school_id)
	}

mycmd (treated) brl zakaibag treated semarab semrel, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel PAIR2-PAIR19, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel PAIR2-PAIR19, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, logit cluster(school_id)

*Table 4
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls50 if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p100 if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p50 if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	}

global N = 40
mata Y = st_data((1,$N),"Y2")
generate double U = .
generate Order = _n

mata ResF = J($reps,32,.); ResD = J($reps,32,.); ResDF = J($reps,32,.); ResB = J($reps,32,.); ResSE = J($reps,32,.)
forvalues c = 1/$reps {
	matrix FF = J(32,3,.)
	matrix BB = J(32,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U 
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}

global i = 1
global j = 1
*Table 2
foreach g in 0 1 {
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g', cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g', logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls50 b`g'ls75 b`g'ls100 educav educem ah4 ole5, logit cluster(school_id)
	}

mycmd1 (treated) brl zakaibag treated semarab semrel, cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel, logit cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel PAIR2-PAIR19, cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel PAIR2-PAIR19, logit cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, logit cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR2-PAIR19, logit cluster(school_id)

*Table 4
foreach g in 0 1 {
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls50 if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p100 if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p50 if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_p == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_p == 1, logit cluster(school_id)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..32] = FF[.,1]'; ResD[`c',1..32] = FF[.,2]'; ResDF[`c',1..32] = FF[.,3]'
mata ResB[`c',1..32] = BB[.,1]'; ResSE[`c',1..32] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/32 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherAL1, replace


********************************

*Part II:  Table 5 - First part 

use DatAL2, clear

matrix F = J(16,4,.)
matrix B = J(16,2,0)

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
	}

global N = 40
mata Y = st_data((1,$N),"Y2")
generate double U = .
generate Order = _n

mata ResF = J($reps,16,.); ResD = J($reps,16,.); ResDF = J($reps,16,.); ResB = J($reps,16,.); ResSE = J($reps,16,.)
forvalues c = 1/$reps {
	matrix FF = J(16,3,.)
	matrix BB = J(16,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}
	quietly replace treated = treated*year

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..16] = FF[.,1]'; ResD[`c',1..16] = FF[.,2]'; ResDF[`c',1..16] = FF[.,3]'
mata ResB[`c',1..16] = BB[.,1]'; ResSE[`c',1..16] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/16 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherAL2, replace

*****************************

*Part III: Table 5, second part

use DatAL3, clear

matrix F = J(16,4,.)
matrix B = J(16,2,0)

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
	}

global N = 40
mata Y = st_data((1,$N),"Y2")
generate double U = .
generate Order = _n

mata ResF = J($reps,16,.); ResD = J($reps,16,.); ResDF = J($reps,16,.); ResB = J($reps,16,.); ResSE = J($reps,16,.)
forvalues c = 1/$reps {
	matrix FF = J(16,3,.)
	matrix BB = J(16,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}
	quietly replace treated = treated*year

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls100 year S2-S39 if b`g'top_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'top_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls25 year S2-S39 if b`g'bot_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S2-S39 if b`g'bot_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p100 year S2-S39 if b`g'top_p == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'top_p == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p25 year S2-S39 if b`g'bot_p == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S2-S39 if b`g'bot_p == 1, robust
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..16] = FF[.,1]'; ResD[`c',1..16] = FF[.,2]'; ResDF[`c',1..16] = FF[.,3]'
mata ResB[`c',1..16] = BB[.,1]'; ResSE[`c',1..16] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/16 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherAL3, replace


*************

*Part IV: Table 5, third part

use DatAL4, clear

matrix F = J(16,4,.)
matrix B = J(16,2,0)

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'top_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'bot_ls == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'top_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S2-S39 if b`g'bot_p == 1, robust
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'bot_p == 1, robust
	}

global N = 40
mata Y = st_data((1,$N),"Y2")
generate double U = .
generate Order = _n

mata ResF = J($reps,16,.); ResD = J($reps,16,.); ResDF = J($reps,16,.); ResB = J($reps,16,.); ResSE = J($reps,16,.)
forvalues c = 1/$reps {
	matrix FF = J(16,3,.)
	matrix BB = J(16,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}
	quietly replace treated = treated*year1

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S2-S39 if b`g'top_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'top_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S2-S39 if b`g'bot_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S2-S39 if b`g'bot_ls == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S2-S39 if b`g'top_p == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'top_p == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S2-S39 if b`g'bot_p == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S2-S39 if b`g'bot_p == 1, robust
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..16] = FF[.,1]'; ResD[`c',1..16] = FF[.,2]'; ResDF[`c',1..16] = FF[.,3]'
mata ResB[`c',1..16] = BB[.,1]'; ResSE[`c',1..16] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/16 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherAL4, replace


************************

*Part V:  Table 6 , top panel 2001

use DatAL5, clear

matrix F = J(16,4,.)
matrix B = J(16,2,0)

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	}

global N = 40
mata Y = st_data((1,$N),"Y2")
generate double U = .
generate Order = _n

mata ResF = J($reps,16,.); ResD = J($reps,16,.); ResDF = J($reps,16,.); ResB = J($reps,16,.); ResSE = J($reps,16,.)
forvalues c = 1/$reps {
	matrix FF = J(16,3,.)
	matrix BB = J(16,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'top_lsq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'ls if boy == `g' & b`g'bot_lsq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'top_pq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated semarab semrel b`g'p if boy == `g' & b`g'bot_pq == 1, logit cluster(school_id)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..16] = FF[.,1]'; ResD[`c',1..16] = FF[.,2]'; ResDF[`c',1..16] = FF[.,3]'
mata ResB[`c',1..16] = BB[.,1]'; ResSE[`c',1..16] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/16 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherAL5, replace


*******************

*Part VI:  Table 6, bottom panel

use DatAL6, clear

matrix F = J(16,4,.)
matrix B = J(16,2,0)

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'top_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'top_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'bot_lsq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'top_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'top_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_pq == 1, robust
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'bot_pq == 1, robust
	}

global N = 40
mata Y = st_data((1,$N),"Y2")
generate double U = .
generate Order = _n

mata ResF = J($reps,16,.); ResD = J($reps,16,.); ResDF = J($reps,16,.); ResB = J($reps,16,.); ResSE = J($reps,16,.)
forvalues c = 1/$reps {
	matrix FF = J(16,3,.)
	matrix BB = J(16,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}
	quietly replace treated = treated*year

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'top_lsq == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'top_lsq == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_lsq == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'ls S2-S39 if b`g'bot_lsq == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'top_pq == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'top_pq == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel year S2-S39 if b`g'bot_pq == 1, robust
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'p S2-S39 if b`g'bot_pq == 1, robust
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..16] = FF[.,1]'; ResD[`c',1..16] = FF[.,2]'; ResDF[`c',1..16] = FF[.,3]'
mata ResB[`c',1..16] = BB[.,1]'; ResSE[`c',1..16] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/16 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherAL6, replace


*************************

*Part 7 - Table 7 - 2001 and 2000/2001 regressions only (not 2000 regressions, following procedure for all such regressions in this paper)

use DatAL7, clear

matrix F = J(60,4,.)
matrix B = J(60,2,0)

global i = 1
global j = 1
foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		mycmd (treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S2-S39 if boy == `g' & b`g'zak_`outcome' == 1, robust
		}
	}
foreach g in 0 1 {
	foreach year in 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			mycmd (treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

global N = 40 
mata Y = st_data((1,$N),"Y2")
generate double U = .
generate Order = _n

mata ResF = J($reps,60,.); ResD = J($reps,60,.); ResDF = J($reps,60,.); ResB = J($reps,60,.); ResSE = J($reps,60,.)
forvalues c = 1/$reps {
	matrix FF = J(60,3,.)
	matrix BB = J(60,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}
	quietly replace treated01 = treated*year01

global i = 1
global j = 1
foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		mycmd1 (treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S2-S39 if boy == `g' & b`g'zak_`outcome' == 1, robust
		}
	}
foreach g in 0 1 {
	foreach year in 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			mycmd1 (treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..60] = FF[.,1]'; ResD[`c',1..60] = FF[.,2]'; ResDF[`c',1..60] = FF[.,3]'
mata ResB[`c',1..60] = BB[.,1]'; ResSE[`c',1..60] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/60 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherAL7, replace

************

*Part 8:  Table A5 - Regressions that are new (not reproducing Table 5) 

use DatAL8, clear

matrix F = J(8,4,.)
matrix B = J(8,2,0)

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	}

global N = 40
mata Y = st_data((1,$N),"Y2")
generate double U = .
generate Order = _n

mata ResF = J($reps,8,.); ResD = J($reps,8,.); ResDF = J($reps,8,.); ResB = J($reps,8,.); ResSE = J($reps,8,.)
forvalues c = 1/$reps {
	matrix FF = J(8,3,.)
	matrix BB = J(8,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort Y1 U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treated = Y2[`i'] if school_id == Y3[`i']
		}

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..8] = FF[.,1]'; ResD[`c',1..8] = FF[.,2]'; ResDF[`c',1..8] = FF[.,3]'
mata ResB[`c',1..8] = BB[.,1]'; ResSE[`c',1..8] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/8 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherAL8, replace

****************

*Part 9: Parts of Table 5 that appear in Table A5 (for joint tests)

use ip\FisherAL2, clear
foreach var in ResF ResD ResDF ResB ResSE {
	drop `var'5-`var'8 `var'13-`var'16
	forvalues i = 9/12 {
		local j = `i' - 4
		rename `var'`i' `var'`j'
		}
	}

mkmat F* in 1/4, matrix(F)
mkmat F* in 9/12, matrix(FF)
mkmat B* in 1/4, matrix(B)
mkmat B* in 9/12, matrix(BB)
matrix F = F \ FF
matrix B = B \ BB
drop F* B*
svmat double F
svmat double B
save ip\FisherAL9, replace

*****************

use ip\FisherAL1
quietly sum F1
global k = r(N)
quietly sum B1
global k1 = r(N)
mkmat F1-F4 in 1/$k, matrix(F)
mkmat B1-B2 in 1/$k1, matrix(B)

forvalues c = 2/9 {
	use ip\FisherAL`c', clear
	quietly sum F1
	global kk = r(N)
	quietly sum B1
	global kk1 = r(N)
	mkmat F1-F4 in 1/$kk, matrix(FF)
	mkmat B1-B2 in 1/$kk1, matrix(BB)
	matrix F = F \ FF
	matrix B = B \ BB
	forvalues i = $kk(-1)1 {
		local j = `i' + $k
		quietly rename ResF`i' ResF`j'
		quietly rename ResD`i' ResD`j'
		quietly rename ResDF`i' ResDF`j'
		}
	forvalues i = $kk1(-1)1 {
		local j = `i' + $k1
		quietly rename ResB`i' ResB`j'
		quietly rename ResSE`i' ResSE`j'
		}
	sort N
	drop F1-F4 B1-B2 
	save a`c', replace
	global k = $k + $kk
	global k1 = $k1 + $kk1
	}

use ip\FisherAL1
forvalues i = 2/9 {
	sort N
	merge N using a`i'
	tab _m
	drop _m
	}
sort N
drop F1-F4 B1-B2
svmat double F
svmat double B
aorder
save results\FisherAL, replace

forvalues i = 2/9 {
	capture erase a`i'.dta
	}













