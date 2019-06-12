
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [pw aw] [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [pw aw] [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end


****************************************
****************************************

global b = 29

use DatGKN1, clear

matrix B = J(33,1,.)

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

egen M = group(grouping_id)
sum M
global reps = r(max)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if M == `c'

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

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeGKN1, replace

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

global b = 1

use DatGKN2, clear

meadjusted

matrix B[30,1] = results[2,1]

egen M = group(grouping_id)

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve
drop if M == `c'

	capture meadjusted
	if (_rc == 0) {
		capture matrix BB[1,1] = results[2,1]
		}

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 30/30 {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
gen N = _n
save ip\OJackknifeGKN2, replace

***************************
***************************

*Combine files

use ip\OJackknifeGKN1, clear
merge 1:1 N using ip\OJackknifeGKN2, nogenerate
svmat double B
save results\OJackknifeGKN, replace

*repeat results for table computations
use results\OJackknifeGKN, clear
forvalues i = 31/33 {
	gen double ResB`i' = ResB1
	}
quietly replace B1 = B1[1] if _n >= 31 & _n <= 33
aorder
save results\OJackknifeGKN, replace

