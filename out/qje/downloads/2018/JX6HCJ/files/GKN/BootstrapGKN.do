

capture program drop mycmd
program define mycmd
	syntax anything [aw] [if] [in] [, cluster(string) robust absorb(string)]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' [`weight' `exp'] `if' `in', cluster(`cluster') `robust' absorb(`absorb')
	testparm `testvars'
	global k = r(df)
	gen `touse' = e(sample)
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		preserve
			bsample if `touse', cluster($cluster) idcluster(`newcluster')
			capture `anything' [`weight' `exp'], cluster(`newcluster') `robust' absorb(`absorb')
			if (_rc == 0) {
			capture mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); B = B[1,1..$k]; V = V[1..$k,1..$k]
			capture testparm `testvars'
			if (_rc == 0 & r(df) == $k) {
				mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1])
				if (e(df_r) == .) mata ResF[`i',1..3] = `r(p)', chi2tail($k,t[1,1]), $k - `r(df)'
				if (e(df_r) ~= .) mata ResF[`i',1...] = `r(p)', Ftail($k,`e(df_r)',t[1,1]/$k), $k - `r(df)', `e(df_r)'
				mata ResB[`i',1...] = B; ResSE[`i',1...] = sqrt(diagonal(V))'
				}
				}
		restore
		}
	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
		global i = $i + 1
		global j = $j + $k
	restore
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





************************************************

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
	mata BB = st_matrix("B")
restore

global i = 23
global j = 30
global cluster = "grouping_id"

*Many missing (_rc ~= 0) because "inv(xx/_N - diag(A))" has missing values

	global k = 1
	mata ResF = J($reps,4,.); ResB = J($reps,$k,.); ResSE = J($reps,$k,.)
	set seed 1
	forvalues i = 1/$reps {
		display "`i'"
		preserve
			bsample, cluster($cluster) idcluster(`newcluster')
			capture meadjusted
			if (_rc == 0) {
			capture mata B = st_matrix("results"); V = B[2,2]^2; B = B[2,1] 
			if (_rc == 0) {
				mata t = (B-BB[1..$k,1]')*invsym(V)*(B'-BB[1..$k,1]); tt = B*invsym(V)*B'
				mata ResF[`i',1..3] = chi2tail($k,tt[1,1]), chi2tail($k,t[1,1]), 0
				mata ResB[`i',1...] = B; ResSE[`i',1...] = sqrt(V)
				}
				}
		restore
		}

	preserve
		quietly drop _all
		quietly set obs $reps
		quietly generate double ResF$i = .
		quietly generate double ResFF$i = .
		quietly generate double ResD$i = .
		quietly generate double ResDF$i = .
		global kk = $j + $k - 1
		forvalues i = $j/$kk {
			quietly generate double ResB`i' = .
			}
		forvalues i = $j/$kk {
			quietly generate double ResSE`i' = .
			}
		mata X = ResF, ResB, ResSE; st_store(.,.,X)
		quietly svmat double B
		quietly rename B2 SE$i
		capture rename B1 B$i
		save ip\BS$i, replace
		global i = $i + 1
		global j = $j + $k
	restore




***************************

use ip\BS1, clear
forvalues i = 2/23 {
	merge using ip\BS`i'
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
save results\BootstrapGKN, replace

use results\BootstrapGKN, clear
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
foreach var in B1 B2 {
	quietly replace `var' = `var'[1] if _n >= 31 & _n <= 33
	}
aorder
save results\BootstrapGKN, replace



