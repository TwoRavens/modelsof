

capture program drop mycmd
program define mycmd
	syntax anything [aw] [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	if ("`absorb'" == "") `anything' [`weight' `exp'] `if' `in', cluster(`cluster') `robust'
	if ("`absorb'" ~= "") `anything' [`weight' `exp'] `if' `in', cluster(`cluster') `robust' absorb(`absorb')
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		if ("`absorb'" == "") quietly `anything' [`weight' `exp'] if M ~= `i', cluster(`cluster') `robust'
		if ("`absorb'" ~= "") quietly `anything' [`weight' `exp'] if M ~= `i', cluster(`cluster') `robust' absorb(`absorb')
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			capture matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			}
		matrix F = J(1,3,.)
		capture testparm `testvars'
		if (_rc == 0) matrix F = r(p), r(drop), e(df_r)
		mata BB = st_matrix("BB"); F = st_matrix("F"); ResB[`i',1..$k] = BB[1..$k,1]'; ResSE[`i',1..$k] = BB[1..$k,2]'; ResF[`i',1..3] = F
		}
	quietly drop _all
	quietly set obs $N
	global kk = $j + $k - 1
	forvalues i = $j/$kk {
		quietly generate double ResB`i' = .
		}
	forvalues i = $j/$kk {
		quietly generate double ResSE`i' = .
		}
	quietly generate double ResF$i = .
	quietly generate double ResD$i = .
	quietly generate double ResDF$i = .
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	quietly svmat double B
	quietly rename B2 SE$i
	capture rename B1 B$i
	save ip\JK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
end


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


*******************


global cluster = "grouping_id"

global i = 1
global j = 1

*Part 1 - All regressions other than the one with measurement error correction in Table 4 

use DatGKN1, clear

*Table 4 (other than column 2) 
mycmd (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
mycmd (hand_i) areg scorerd hand_i _Ir* _Itourncat* [aw=wgt], robust cluster(grouping_id) absorb(player)

*Table 5 - Columns 2 - 5 (Col. 1 is repeat of Table 4) 
foreach var in drivdist putts greenrd {
	mycmd (`var'_i) areg scorerd `var'_i `var' _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
mycmd (putts_i greenrd_i drivdist_i) areg scorerd putts_i greenrd_i drivdist_i putts greenrd drivdist _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)

*Table 6 - (Col. 1 is repeat of Table 4)
foreach var of varlist hand_max hand_min tigeringrp hand_top10 hand_top25 hand_bot25 hand_bot10 {
	mycmd (`var') areg scorerd `var' handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
mycmd (hand_i hand_iXdiff) areg scorerd hand_i hand_iXdiff handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)

*Table 7
foreach spec in " " "_Igrp* _ItouXgrp_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_* _ItouXgrpQa*" {
	mycmd (score_i) areg scorerd score_i handicap _Ir* `spec' [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}

*Table 8 - (Col. 1 is repeat of earlier)
mycmd (hand_i handicapXhand_i) areg scorerd hand_i handicapXhand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
mycmd (hand_i first_yearXhand_i) areg scorerd hand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
mycmd (hand_i handicapXhand_i first_yearXhand_i) areg scorerd hand_i handicapXhand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt] , robust cluster(grouping_id) absorb(tourncat) 


***********************************

*Part 2: Measurement error corrected regression in Table 4 

use DatGKN2, clear

preserve
	meadjusted
	matrix B = results[2,1..2]
restore

global i = 23
global j = 30
global k = 1
global cluster = "grouping_id"

egen M = group($cluster)
quietly sum M
global N = r(max)
mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
forvalues i = 1/$N {
	display "`i'", _continue
	preserve
		quietly drop if M == `i'
		capture meadjusted
		if (_rc == 0) {
			capture mata B = st_matrix("results"); V = B[2,2]^2; B = B[2,1] 
			if (_rc == 0) {
				mata tt = B*invsym(V)*B
				mata ResF[`i',1..3] = chi2tail(1,tt[1,1]), 0, .
				mata ResB[`i',1] = B; ResSE[`i',1...] = sqrt(V)
				}
			}
	restore
	}

quietly drop _all
quietly set obs $N
global kk = $j + $k - 1
forvalues i = $j/$kk {
	quietly generate double ResB`i' = .
	}
forvalues i = $j/$kk {
	quietly generate double ResSE`i' = .
	}
quietly generate double ResF$i = .
quietly generate double ResD$i = .
quietly generate double ResDF$i = .
mata X = ResB, ResSE, ResF; st_store(.,.,X)
quietly svmat double B
quietly rename B2 SE$i
capture rename B1 B$i
save ip\JK$i, replace


use ip\JK1, clear
forvalues i = 2/23 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/23 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeGKN, replace

use results\JackknifeGKN, clear
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
foreach var in B1 B2 {
	quietly replace `var' = `var'[1] if _n >= 31 & _n <= 33
	}
aorder
save results\JackknifeGKN, replace




