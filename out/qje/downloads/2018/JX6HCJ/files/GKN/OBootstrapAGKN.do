*Clustering at treatment level

****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [pw aw] [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' [`weight' `exp'] `if' `in', cluster(`cluster') `robust' absorb(`absorb')
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
	syntax anything [pw aw] [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' [`weight' `exp'] `if' `in', cluster(`cluster') `robust' absorb(`absorb')
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

global a = 22
global b = 29

use DatGKN1, clear

egen Group = group(grouping_id) if round == 1
sort tourn player round
replace Group = Group[_n-1] if player == player[_n-1] & round == 2 & tourn == tourn[_n-1]
*Two players who entered in second round in a tournament, were matched together and will always be matched together
replace Group = 10000 if round == 2 & round[_n-1] ~= 1

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1
*Table 4 
mycmd (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(Group) absorb(tourncat)
mycmd (hand_i) areg scorerd hand_i _Ir* _Itourncat* [aw=wgt], robust cluster(Group) absorb(player)
*Table 5 
foreach var in drivdist putts greenrd {
	mycmd (`var'_i) areg scorerd `var'_i `var' _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(Group) absorb(tourncat)
	}
mycmd (putts_i greenrd_i drivdist_i) areg scorerd putts_i greenrd_i drivdist_i putts greenrd drivdist _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(Group) absorb(tourncat)
*Table 6 
foreach var of varlist hand_max hand_min tigeringrp hand_top10 hand_top25 hand_bot25 hand_bot10 {
	mycmd (`var') areg scorerd `var' handicap _Ir* [aw=wgt], robust cluster(Group) absorb(tourncat)
	}
mycmd (hand_i hand_iXdiff) areg scorerd hand_i hand_iXdiff handicap _Ir* [aw=wgt], robust cluster(Group) absorb(tourncat)
*Table 7
foreach spec in " " "_Igrp* _ItouXgrp_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_* _ItouXgrpQa*" {
	mycmd (score_i) areg scorerd score_i handicap  _Ir* `spec' [aw=wgt], robust cluster(Group) absorb(tourncat)
	}
*Table 8
mycmd (hand_i handicapXhand_i) areg scorerd hand_i handicapXhand_i handicap _Ir* [aw=wgt], robust cluster(Group) absorb(tourncat) 
mycmd (hand_i first_yearXhand_i) areg scorerd hand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt], robust cluster(Group) absorb(tourncat) 
mycmd (hand_i handicapXhand_i first_yearXhand_i) areg scorerd hand_i handicapXhand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt] , robust cluster(Group) absorb(tourncat) 

capture drop N 
capture drop NN
rename OriginalOrder Order
sort Group Order
gen N = 1
gen Dif = (Group ~= Group[_n-1])
replace N = N[_n-1] + Dif if _n > 1
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
	drop Group
	rename obs Group

global i = 1
global j = 1
*Table 4 
mycmd1 (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(Group) absorb(tourncat)
mycmd1 (hand_i) areg scorerd hand_i _Ir* _Itourncat* [aw=wgt], robust cluster(Group) absorb(player)
*Table 5 
foreach var in drivdist putts greenrd {
	mycmd1 (`var'_i) areg scorerd `var'_i `var' _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(Group) absorb(tourncat)
	}
mycmd1 (putts_i greenrd_i drivdist_i) areg scorerd putts_i greenrd_i drivdist_i putts greenrd drivdist _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(Group) absorb(tourncat)
*Table 6 
foreach var of varlist hand_max hand_min tigeringrp hand_top10 hand_top25 hand_bot25 hand_bot10 {
	mycmd1 (`var') areg scorerd `var' handicap _Ir* [aw=wgt], robust cluster(Group) absorb(tourncat)
	}
mycmd1 (hand_i hand_iXdiff) areg scorerd hand_i hand_iXdiff handicap _Ir* [aw=wgt], robust cluster(Group) absorb(tourncat)
*Table 7
foreach spec in " " "_Igrp* _ItouXgrp_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_* _ItouXgrpQa*" {
	mycmd1 (score_i) areg scorerd score_i handicap  _Ir* `spec' [aw=wgt], robust cluster(Group) absorb(tourncat)
	}
*Table 8
mycmd1 (hand_i handicapXhand_i) areg scorerd hand_i handicapXhand_i handicap _Ir* [aw=wgt], robust cluster(Group) absorb(tourncat) 
mycmd1 (hand_i first_yearXhand_i) areg scorerd hand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt], robust cluster(Group) absorb(tourncat) 
mycmd1 (hand_i handicapXhand_i first_yearXhand_i) areg scorerd hand_i handicapXhand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt] , robust cluster(Group) absorb(tourncat) 

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
save ip\OBootstrapAGKN1, replace

*******************************
*******************************

*Programme to estimate measurement error adjusted coefficients and covariance matrix (shortened version of their code)
capture program drop meadjusted
program define meadjusted

	matrix accum xx = handicap hand_i cons _I* [aw=wgt], noconstant
	matrix vecaccum xy = scorerd handicap hand_i cons _I* [aw=wgt], noconstant
	matrix vecaccum A = wgt handicap_c2 hand_i_c2
	matrix A = A[1,1..2]/A[1,3], J(1,colsof(xx)-colsof(A)+1,0)
	matrix pi = invsym(xx /_N - diag(A)) * (xy' / _N)

	local v = 1
	capture drop nu_hat
	gen nu_hat = scorerd
	foreach var of varlist handicap hand_i cons _I* {
		qui replace nu_hat = nu_hat - pi[`v',1] * `var'
		local v = `v' + 1
		}
	capture drop W_*
	local v = 1
	foreach var of varlist handicap hand_i cons _I* {
		qui gen W_`v' = `var' * nu_hat
		if (`v' <= 2) quietly replace W_`v' = W_`v' - `var'_c2 * pi[`v',1]
		local v = `v' + 1
		}
	matrix accum W = W_* [aw=wgt], noconstant
	matrix Var = (1/_N)*invsym(xx/_N - diag(A))*(W/_N)*invsym(xx/_N - diag(A))
	mata V = st_matrix("Var"); V = diagonal(V); V = sqrt(V); st_matrix("sd",V)
	matrix results = (pi[1..3,1], sd[1..3,1])
	matrix rownames results = handicap hand_i cons
	matrix colnames results = beta_hat std_err
	matrix list results

end

global a = 1
global b = 1

use DatGKN2, clear

egen Group = group(grouping_id) if round == 1
sort tourn player round
replace Group = Group[_n-1] if player == player[_n-1] & round == 2 & tourn == tourn[_n-1]
*Two players who entered in second round in a tournament, were matched together and will always be matched together
replace Group = 10000 if round == 2 & round[_n-1] ~= 1

meadjusted

matrix F = chi2tail(1,(results[2,1]/results[2,2])^2), 0, ., 1
matrix B = results[2,1..2]

capture drop N 
capture drop NN
rename OriginalOrder Order
sort Group Order
gen N = 1
gen Dif = (Group ~= Group[_n-1])
replace N = N[_n-1] + Dif if _n > 1
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
	drop Group
	rename obs Group

	capture meadjusted
	if (_rc == 0) {
		capture matrix FF[1,1] = chi2tail(1,(results[2,1]/results[2,2])^2), 0, ., chi2tail(1,((results[2,1]-B[1,1])/results[2,2])^2)
		capture matrix BB[1,1] = results[2,1..2]
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
save ip\OBootstrapAGKN2, replace

***************************
***************************

*Combine files

use ip\OBootstrapAGKN2, clear
mkmat F1-F4 in 1/1, matrix(FF)
mkmat B1-B2 in 1/1, matrix(BB)
drop F1-F4 B1-B2 
foreach j in ResFF ResF ResD ResDF {
	rename `j'1 `j'23
	}
foreach j in ResB ResSE {
	rename `j'1 `j'30
	}
sort N
save a, replace

use ip\OBootstrapAGKN1, clear
mkmat F1-F4 in 1/22, matrix(F)
mkmat B1-B2 in 1/29, matrix(B)
drop F1-F4 B1-B2 
sort N
merge N using a
tab _m
drop _m
sort N
matrix F = F \ FF
matrix B = B \ BB
svmat double F
svmat double B
aorder
save results\OBootstrapAGKN, replace

foreach file in a aa aaa bb {
	capture erase `file'.dta
	}


use results\OBootstrapAGKN, clear
foreach var in ResF ResD ResDF ResFF {
	forvalues i = 24/26 {
		gen double `var'`i' = `var'1
		}
	}
forvalues i = 31/33 {
	foreach var in ResB ResSE {
		gen double `var'`i' = `var'1
		}
	}
foreach var in F1 F2 F3 F4 {
	quietly replace `var' = `var'[1] if _n >= 24 & _n <= 26
	}
foreach var in B1 B2 {
	quietly replace `var' = `var'[1] if _n >= 31 & _n <= 33
	}
aorder
save results\OBootstrapAGKN, replace



