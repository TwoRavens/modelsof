
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust logit iterate(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`iterate'" ~= "") {
		`anything' `if' `in', `robust' iterate(`iterate')
		}
	else {
		`anything' `if' `in', cluster(`cluster') `robust' `logit'
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
	syntax anything [if] [in] [, cluster(string) robust logit iterate(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	if ("`iterate'" ~= "") {
		capture `anything' `if' `in', `robust' iterate(`iterate')
		}
	else {
		capture `anything' `if' `in', cluster(`cluster') `robust' `logit'
		}
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			matrix V = V[1..$k,1..$k]
			matrix b = b[1,1..$k]
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) capture matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) capture matrix FF[$i,4] = chi2tail($k,f[1,1])
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

global a = 32
global b = 32

matrix F = J($a,4,.)
matrix B = J($b,2,.)

use DatAL1, clear

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
mycmd (treated) brl zakaibag treated semarab semrel PAIR*, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel PAIR*, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, logit cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR*, cluster(school_id)
mycmd (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR*, logit cluster(school_id)

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

sort school_id
merge school_id using Sample1
tab _m
drop _m
sort N
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop school_id
	rename obs school_id

	egen PP = group(PAIR*)
	drop PAIR*
	quietly tab PP, gen(PAIR)
	drop PAIR1
*These dummies become == 0 in many cases and their brl programme fails when has to drop a variable

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
mycmd1 (treated) brl zakaibag treated semarab semrel PAIR*, cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel PAIR*, logit cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5, logit cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR*, cluster(school_id)
mycmd1 (treated) brl zakaibag treated semarab semrel ls50 ls75 ls100 educav educem ah4 ole5 PAIR*, logit cluster(school_id)

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

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapAL1, replace

**************************
**************************

global a = 16
global b = 16

matrix F = J($a,4,.)
matrix B = J($b,2,.)

use DatAL2, clear

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S* if b`g'bot_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'bot_p == 1, robust iterate(50)
	}

sort school_id
merge school_id using Sample1
tab _m
drop _m
sort N
save bb, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop school_id
	rename obs school_id

	drop S*
	quietly tab school_id, gen(S)
	drop S1

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls100 year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls25 year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p100 year S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p25 year S* if b`g'bot_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'bot_p == 1, robust iterate(50)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapAL2, replace

**************************
**************************

global a = 16
global b = 16

matrix F = J($a,4,.)
matrix B = J($b,2,.)

use DatAL3, clear

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls100 year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls25 year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p100 year S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p25 year S* if b`g'bot_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'bot_p == 1, robust iterate(50)
	}

sort school_id
merge school_id using Sample1
tab _m
drop _m
sort N
save cc, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using cc
	drop school_id
	rename obs school_id

	drop S*
	quietly tab school_id, gen(S)
	drop S1

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls100 year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls25 year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'ls year S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p100 year S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p25 year S* if b`g'bot_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel b`g'p year S* if b`g'bot_p == 1, robust iterate(50)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapAL3, replace

**************************
**************************

global a = 16
global b = 16

matrix F = J($a,4,.)
matrix B = J($b,2,.)

use DatAL4, clear

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S* if b`g'top_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S* if b`g'top_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S* if b`g'bot_p == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S* if b`g'bot_p == 1, robust iterate(50)
	}

sort school_id
merge school_id using Sample1
tab _m
drop _m
sort N
save dd, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using dd
	drop school_id
	rename obs school_id

	drop S*
	quietly tab school_id, gen(S)
	drop S1

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls100 S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S* if b`g'top_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls25 S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'ls S* if b`g'bot_ls == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p100 S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S* if b`g'top_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p25 S* if b`g'bot_p == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab1 semarab2 semrel1 semrel2 year1 year2 b`g'p S* if b`g'bot_p == 1, robust iterate(50)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapAL4, replace

**************************
**************************

global a = 16
global b = 16

matrix F = J($a,4,.)
matrix B = J($b,2,.)

use DatAL5, clear

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

sort school_id
merge school_id using Sample1
tab _m
drop _m
sort N
save ee, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using ee
	drop school_id
	rename obs school_id

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

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapAL5, replace

**************************
**************************

global a = 16
global b = 16

matrix F = J($a,4,.)
matrix B = J($b,2,.)

use DatAL6, clear

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'top_lsq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S* if b`g'top_lsq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'bot_lsq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'ls S* if b`g'bot_lsq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'top_pq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S* if b`g'top_pq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year S* if b`g'bot_pq == 1, robust iterate(50)
	mycmd (treated) logit zakaibag treated semarab semrel year b`g'p S* if b`g'bot_pq == 1, robust iterate(50)
	}

sort school_id
merge school_id using Sample1
tab _m
drop _m
sort N
save ff, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using ff
	drop school_id
	rename obs school_id

	drop S*
	quietly tab school_id, gen(S)
	drop S1

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd1 (treated) logit zakaibag treated semarab semrel year S* if b`g'top_lsq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'ls S* if b`g'top_lsq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year S* if b`g'bot_lsq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'ls S* if b`g'bot_lsq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year S* if b`g'top_pq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'p S* if b`g'top_pq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year S* if b`g'bot_pq == 1, robust iterate(50)
	mycmd1 (treated) logit zakaibag treated semarab semrel year b`g'p S* if b`g'bot_pq == 1, robust iterate(50)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapAL6, replace

**************************
**************************

global a = 60
global b = 60

matrix F = J($a,4,.)
matrix B = J($b,2,.)

use DatAL7, clear

global i = 1
global j = 1
foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		mycmd (treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S* if boy == `g' & b`g'zak_`outcome' == 1, robust iterate(50)
		}
	}
foreach g in 0 1 {
	foreach year in 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			mycmd (treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

sort school_id
merge school_id using Sample1
tab _m
drop _m
sort N
save gg, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using gg
	drop school_id
	rename obs school_id

	drop S*
	quietly tab school_id, gen(S)
	drop S1

global i = 1
global j = 1
foreach g in 0 1 {
	foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
		mycmd1 (treated01) logit `outcome' treated01 semarab01 semrel01 b`g'ls100 year01 S* if boy == `g' & b`g'zak_`outcome' == 1, robust iterate(50)
		}
	}
foreach g in 0 1 {
	foreach year in 1 {
		foreach outcome in att18 att20 att22 att24 awr18 awr20 awr22 awr24 achv_math achv_eng achv_hib bag_cond_att18 bag_cond_att20 bag_cond_att22 bag_cond_att24 {
			mycmd1 (treated) brl `outcome' treated semarab semrel b`g'ls100 if year == `year' & boy == `g' & b`g'zak_`outcome' == 1, logit cluster(school_id)
			}
		}
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapAL7, replace

**************************
**************************

global a = 8
global b = 8

matrix F = J($a,4,.)
matrix B = J($b,2,.)

use DatAL8, clear

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	}

sort school_id
merge school_id using Sample1
tab _m
drop _m
sort N
save hh, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,2,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using hh
	drop school_id
	rename obs school_id

global i = 1
global j = 1
foreach g in 0 1 {
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls100 if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls50 if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 1, logit cluster(school_id)
	mycmd1 (treated) brl zakaibag treated b`g'bagB_00 semarab semrel b`g'ls if boy == `g' & b`g'top_ls == 0, logit cluster(school_id)
	}

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save ip\OBootstrapAL8, replace

**************************
**************************

*Part 9: Parts of Table 5 that appear in Table A5 (for joint tests)

use ip\OBootstrapAL2, clear
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
save ip\OBootstrapAL9, replace

**************************
**************************

use ip\OBootstrapAL1
quietly sum F1
global k = r(N)
quietly sum B1
global k1 = r(N)
mkmat F1-F4 in 1/$k, matrix(F)
mkmat B1-B2 in 1/$k1, matrix(B)

forvalues c = 2/9 {
	use ip\OBootstrapAL`c', clear
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
		quietly rename ResFF`i' ResFF`j'
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

use ip\OBootstrapAL1
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
save results\OBootstrapAL, replace

foreach file in aaa aa bb cc dd ee ff gg hh a2 a3 a4 a5 a6 a7 a8 a9 {
	capture erase `file'.dta
	}
















