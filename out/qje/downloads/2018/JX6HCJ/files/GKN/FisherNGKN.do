
*randomizing at authors' clustered level


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, cluster(string) absorb(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' [`weight' `exp'] `if' `in', cluster(`cluster') absorb(`absorb') `robust'
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
	syntax anything [aw pw] [if] [in] [, cluster(string) absorb(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' [`weight' `exp'] `if' `in', cluster(`cluster') absorb(`absorb') `robust'
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


*Programme to recalculate all variables affected by randomization (& used in regressions) following randomization
capture program drop recalculate
program define recalculate
	foreach var in hand score putts drivdist greenrd {
		capture drop t tt
		egen double t = sum(`var'back), by(Group round)
		egen double tt = count(`var'back), by(Group round)
		gen double `var'_ii = (t - `var'back)/(tt-1) if `var' ~= . & tt > 1
		replace `var'_i = `var'_ii
		drop `var'_ii t tt
		}
	sum hand_i
	replace hand_i = hand_i - r(mean)
	
	capture drop myn
	bys Group round: gen myn = _n
	foreach j in hand_max hand_min hand_top10 hand_top25 hand_bot25 hand_bot10 {
		capture drop `j'
		gen `j' = .
		}
	capture drop tigeringrp
	egen tigeringrp = max(tigerwoods), by(Group round)
	replace tigeringrp = tigeringrp - tigerwoods
	sort Group round handicap
	by Group round: replace hand_max = cond( (handicap[2] >= handicap[3] & handicap[2] < .) | missing(handicap[3]), handicap[2], handicap[3]) if _n == 1 & _N == 3
	by Group round: replace hand_max = cond( (handicap[1] >= handicap[3] & handicap[1] < .) | missing(handicap[3]), handicap[1], handicap[3]) if _n == 2 & _N == 3
	by Group round: replace hand_max = cond( (handicap[1] >= handicap[2] & handicap[1] < .) | missing(handicap[2]), handicap[1], handicap[2]) if _n == 3 & _N == 3
	by Group round: replace hand_max = handicap[2] if _n == 1 & _N == 2
	by Group round: replace hand_max = handicap[1] if _n == 2 & _N == 2
	by Group round: replace hand_min = cond(handicap[2] < handicap[3], handicap[2], handicap[3]) if _n == 1 & _N == 3
	by Group round: replace hand_min = cond(handicap[1] < handicap[3], handicap[1], handicap[3]) if _n == 2 & _N == 3
	by Group round: replace hand_min = cond(handicap[1] < handicap[2], handicap[1], handicap[2]) if _n == 3 & _N == 3
	by Group round: replace hand_min = handicap[2] if _n == 1 & _N == 2
	by Group round: replace hand_min = handicap[1] if _n == 2 & _N == 2
	by Group round: replace hand_top10 = handicap[2] < $hand10 | handicap[3] < $hand10 if _n == 1 & _N == 3
	by Group round: replace hand_top10 = handicap[1] < $hand10 | handicap[3] < $hand10 if _n == 2 & _N == 3
	by Group round: replace hand_top10 = handicap[1] < $hand10 | handicap[2] < $hand10 if _n == 3 & _N == 3
	by Group round: replace hand_top10 = handicap[1] < $hand10 if _n == 2 & _N == 2
	by Group round: replace hand_top10 = handicap[2] < $hand10 if _n == 1 & _N == 2
	by Group round: replace hand_bot10 = (handicap[2] > $hand90) | (handicap[3] > $hand90) if _n == 1 & _N == 3
	by Group round: replace hand_bot10 = (handicap[1] > $hand90) | (handicap[3] > $hand90) if _n == 2 & _N == 3
	by Group round: replace hand_bot10 = (handicap[2] > $hand90) | (handicap[1] > $hand90) if _n == 3 & _N == 3
	by Group round: replace hand_bot10 = (handicap[2] > $hand90) if _n == 1 & _N == 2
	by Group round: replace hand_bot10 = (handicap[1] > $hand90) if _n == 2 & _N == 2
	by Group round: replace hand_top25 = handicap[2] < $hand25 | handicap[3] < $hand25 if _n == 1 & _N == 3
	by Group round: replace hand_top25 = handicap[1] < $hand25 | handicap[3] < $hand25 if _n == 2 & _N == 3
	by Group round: replace hand_top25 = handicap[1] < $hand25 | handicap[2] < $hand25 if _n == 3 & _N == 3
	by Group round: replace hand_top25 = handicap[2] < $hand25 if _n == 1 & _N == 2
	by Group round: replace hand_top25 = handicap[1] < $hand25 if _n == 2 & _N == 2
	by Group round: replace hand_bot25 = (handicap[2] > $hand75) | (handicap[3] > $hand75) if _n == 1 & _N == 3
	by Group round: replace hand_bot25 = (handicap[1] > $hand75) | (handicap[3] > $hand75) if _n == 2 & _N == 3
	by Group round: replace hand_bot25 = (handicap[2] > $hand75) | (handicap[1] > $hand75) if _n == 3 & _N == 3
	by Group round: replace hand_bot25 = (handicap[2] > $hand75) if _n == 1 & _N ==2
	by Group round: replace hand_bot25 = (handicap[1] > $hand75) if _n == 2 & _N ==2

	drop hand_iXdiff handicapXhand_i first_yearXhand_i 
	gen hand_iXdiff  = hand_i * (hand_i - handicap)
	gen handicapXhand_i = handicap * hand_i
	gen first_yearXhand_i = first_year * hand_i
end

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


************************************************

*Part 1

use DatGKN1, clear

capture drop n
bys player year: gen n = _n
summ handicap if n == 1, det
foreach j in 10 25 75 90 {
	global hand`j' = r(p`j')
	}

matrix F = J(22,4,.)
matrix B = J(29,2,.)

global i = 1
global j = 1
*Table 4 
mycmd (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
mycmd (hand_i) areg scorerd hand_i _Ir* _Itourncat* [aw=wgt], robust cluster(grouping_id) absorb(player)
*Table 5 
foreach var in drivdist putts greenrd {
	mycmd (`var'_i) areg scorerd `var'_i `var' _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
mycmd (putts_i greenrd_i drivdist_i) areg scorerd putts_i greenrd_i drivdist_i putts greenrd drivdist _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
*Table 6 
foreach var of varlist hand_max hand_min tigeringrp hand_top10 hand_top25 hand_bot25 hand_bot10 {
	mycmd (`var') areg scorerd `var' handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
mycmd (hand_i hand_iXdiff) areg scorerd hand_i hand_iXdiff handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
*Table 7
foreach spec in " " "_Igrp* _ItouXgrp_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_* _ItouXgrpQa*" {
	mycmd (score_i) areg scorerd score_i handicap  _Ir* `spec' [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
*Table 8
mycmd (hand_i handicapXhand_i) areg scorerd hand_i handicapXhand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
mycmd (hand_i first_yearXhand_i) areg scorerd hand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
mycmd (hand_i handicapXhand_i first_yearXhand_i) areg scorerd hand_i handicapXhand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt] , robust cluster(grouping_id) absorb(tourncat) 

*Follow author's clustering, but retain randomization method which is that (mostly) matched within cat
egen Strata = group(tourn cat round) 
egen Group = group(grouping_id) 
sort Strata OriginalOrder
rename OriginalOrder Order
mata Y = st_data(.,"Group")
generate double U = .

mata ResF = J($reps,22,.); ResD = J($reps,22,.); ResDF = J($reps,22,.); ResB = J($reps,29,.); ResSE = J($reps,29,.)
forvalues c = 1/$reps {
	matrix FF = J(22,3,.)
	matrix BB = J(29,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	quietly sort Strata U 
	mata st_store(.,"Group",Y)
	quietly recalculate
	capture drop grouping_id
	quietly generate grouping_id = Group

global i = 1
global j = 1
*Table 4 
mycmd1 (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
mycmd1 (hand_i) areg scorerd hand_i _Ir* _Itourncat* [aw=wgt], robust cluster(grouping_id) absorb(player)
*Table 5 
foreach var in drivdist putts greenrd {
	mycmd1 (`var'_i) areg scorerd `var'_i `var' _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
mycmd1 (putts_i greenrd_i drivdist_i) areg scorerd putts_i greenrd_i drivdist_i putts greenrd drivdist _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
*Table 6 
foreach var of varlist hand_max hand_min tigeringrp hand_top10 hand_top25 hand_bot25 hand_bot10 {
	mycmd1 (`var') areg scorerd `var' handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
mycmd1 (hand_i hand_iXdiff) areg scorerd hand_i hand_iXdiff handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
*Table 7
foreach spec in " " "_Igrp* _ItouXgrp_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_* _ItouXgrpQa*" {
	mycmd1 (score_i) areg scorerd score_i handicap  _Ir* `spec' [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
*Table 8
mycmd1 (hand_i handicapXhand_i) areg scorerd hand_i handicapXhand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
mycmd1 (hand_i first_yearXhand_i) areg scorerd hand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
mycmd1 (hand_i handicapXhand_i first_yearXhand_i) areg scorerd hand_i handicapXhand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt] , robust cluster(grouping_id) absorb(tourncat) 

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..22] = FF[.,1]'; ResD[`c',1..22] = FF[.,2]'; ResDF[`c',1..22] = FF[.,3]'
mata ResB[`c',1..29] = BB[.,1]'; ResSE[`c',1..29] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/22 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/29 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherGKN1, replace

***********************************

*Part 2: Measurement error corrected regression in Table 4 

use DatGKN2, clear

meadjusted

matrix F = J(1,4,.)
matrix B = J(1,2,.)

	matrix F[1,1] = chi2tail(1,(results[2,1]/results[2,2])^2), 0, . ,1
	matrix B[1,1] = results[2,1..2]

*Follow author's clustering, but retain randomization method which is that (mostly) matched within cat
egen Strata = group(tourn cat round) 
egen Group = group(grouping_id) 
sort Strata OriginalOrder
rename OriginalOrder Order
mata Y = st_data(.,"Group")
generate double U = .

mata ResF = J($reps,1,.); ResD = J($reps,1,.); ResDF = J($reps,1,.); ResB = J($reps,1,.); ResSE = J($reps,1,.)
forvalues c = 1/$reps {
	matrix FF = J(1,3,.)
	matrix BB = J(1,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	quietly sort Strata U 
	mata st_store(.,"Group",Y)
	capture drop grouping_id
	quietly generate grouping_id = Group

	capture drop t tt
	quietly egen double t = sum(handback), by(Group round)
	quietly egen double tt = count(handback), by(Group round)
	quietly gen double hand_ii = (t - handback)/(tt-1) if hand ~= . & tt > 1
	quietly replace hand_i = hand_ii
	quietly drop hand_ii t tt
	quietly sum hand_i
	quietly replace hand_i = hand_i - r(mean)

	capture drop myN sum_c2 hand_i_c2
	quietly bys Group round: gen myN = _N
	quietly bys Group round: egen sum_c2 = sum(handicap_c2_var / ( (myN - 1)^2) )
	quietly gen hand_i_c2 = sum_c2 - handicap_c2_var / ( (myN - 1)^2 )
	
	meadjusted

	matrix FF[1,1] = chi2tail(1,(results[2,1]/results[2,2])^2), 0, .
	matrix BB[1,1] = results[2,1..2]

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..1] = FF[.,1]'; ResD[`c',1..1] = FF[.,2]'; ResDF[`c',1..1] = FF[.,3]'
mata ResB[`c',1..1] = BB[.,1]'; ResSE[`c',1..1] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	quietly generate double `j'1 = .
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherGKN2, replace

***************************

*Combine files

use ip\FisherGKN2, clear
mkmat F1-F4 in 1/1, matrix(FF)
mkmat B1-B2 in 1/1, matrix(BB)
drop F1-F4 B1-B2 
foreach j in ResF ResD ResDF {
	rename `j'1 `j'23
	}
foreach j in ResB ResSE {
	rename `j'1 `j'30
	}
sort N
save a, replace

use ip\FisherGKN1, clear
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
*repeat results for table computations
foreach var in ResF ResD ResDF {
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
save results\FisherGKN, replace

capture erase a.dta



