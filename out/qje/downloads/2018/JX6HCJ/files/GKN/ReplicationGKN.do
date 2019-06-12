
*****************

*Data analysis - some of the paper's reported partner characteristics are inconsistent with the actual partner's characteristics
*Will impute these "data errors" as the partner characteristics to be consistent when I rerandomize and calculater partner characteristics
*Moreover, some players for whom could have calculated partner characteristics don't actually calculate partner characteristics
*Will keep these players' partner characteristic data as . when rerandomize

use pga_data.dta, clear
gen N = 1
egen NN = sum(N), by(grouping_id)
generate hand = handicap
generate score = scorerd
foreach var in hand score putts drivdist greenrd {
	capture drop t tt
	quietly egen double t = sum(`var'), by(grouping_id)
	quietly egen double tt = count(`var'), by(grouping_id)
	gen double `var'_ii = (t - `var')/(tt-1)
	bysort NN: sum `var'_i `var'_ii
	}
*putts-greenrd have `var'_i where it is not possible to calculate
foreach var in hand score putts drivdist greenrd {
	sum `var'_ii `var'_i
	reg `var'_ii `var'_i
	capture drop t tt
	generate t = 1 if `var'_ii == . & `var'_i ~= .
	egen tt = max(t), by(grouping_id)
	list grouping_id NN player `var' `var'_i `var'_ii if tt == 1
	}
*There are many, many other cases where could have calculated partner characteristics but did not, e.g.
list greenrd* player if grouping_id == "906_2"
*This comes from the way calculate things, subtracting player's own value from sum (not in code, I inferred this and introduced it in code above)
*This automatically creates . when don't have player's own value

*handicap & score consistent, the others slightly off
sort grouping_id
generate handback = hand
generate scoreback = score
foreach var in putts drivdist greenrd {
	display "`var'"
	generate `var'back = `var'
	capture drop t tt
	gen t = ln(`var'_ii/`var'_i)
	tab NN if abs(t) > .000001 & t ~= .
	tab NN if `var'_ii == . & `var'_i ~= .
	egen tt = max(t), by(grouping_id)
	replace `var'back = `var'_i[_n-1] if NN == 2 & abs(tt) > .000001 & tt ~= . & grouping_id == grouping_id[_n-1]
	replace `var'back = `var'_i[_n+1] if NN == 2 & abs(tt) > .000001 & tt ~= . & grouping_id == grouping_id[_n+1]
	replace `var'back = `var'_i[_n-1] if NN == 2 & `var'_ii[_n-1] == . & `var'_i[_n-1] ~= . & grouping_id == grouping_id[_n-1]
	replace `var'back = `var'_i[_n+1] if NN == 2 & `var'_ii[_n+1] == . & `var'_i[_n+1] ~= . & grouping_id == grouping_id[_n+1]
	}
drop *_ii
*Now doublechecking
foreach var in hand score putts drivdist greenrd {
	capture drop t tt
	quietly egen double t = sum(`var'back), by(grouping_id)
	quietly egen double tt = count(`var'back), by(grouping_id)
	gen double `var'_ii = (t - `var'back)/(tt-1) if `var' ~= .
	}
*Have to put in `var' ~= . condition because have imputed `var'back in cases where `var'_i was reported for partner but `var' was . (so partner has `var'_i but self does not)
foreach var in hand score putts drivdist greenrd {
	sum `var'_ii `var'_i
	reg `var'_ii `var'_i
	}
drop t tt *_ii
save pga_dataadd.dta, replace


*Paper's prep code (shortened - dropping bits that do not appear in later regressions, and adding in demeaning of first_year)

use pga_dataadd.dta, clear

foreach j in handicap hand_i putts drivdist greenrd first_year {
	sum `j', meanonly
	replace `j' = `j' - r(mean)
	}
gen tourncat = tourn + "_" + cat

bys player year: gen n = _n
summ handicap if n == 1, det
foreach j in 10 25 75 90 {
	global hand`j' = r(p`j')
	}
global hand25 = round($hand25, 1e-10)

capture drop myn
bys grouping_id: gen myn = _n
foreach j in hand_max hand_min hand_top10 hand_top25 hand_bot25 hand_bot10 {
	gen `j' = .
	}
sort grouping_id handicap
by grouping_id: replace hand_max = cond( (handicap[2] >= handicap[3] & handicap[2] < .) | missing(handicap[3]), handicap[2], handicap[3]) if _n == 1 & _N == 3
by grouping_id: replace hand_max = cond( (handicap[1] >= handicap[3] & handicap[1] < .) | missing(handicap[3]), handicap[1], handicap[3]) if _n == 2 & _N == 3
by grouping_id: replace hand_max = cond( (handicap[1] >= handicap[2] & handicap[1] < .) | missing(handicap[2]), handicap[1], handicap[2]) if _n == 3 & _N == 3
by grouping_id: replace hand_max = handicap[2] if _n == 1 & _N == 2
by grouping_id: replace hand_max = handicap[1] if _n == 2 & _N == 2
by grouping_id: replace hand_min = cond(handicap[2] < handicap[3], handicap[2], handicap[3]) if _n == 1 & _N == 3
by grouping_id: replace hand_min = cond(handicap[1] < handicap[3], handicap[1], handicap[3]) if _n == 2 & _N == 3
by grouping_id: replace hand_min = cond(handicap[1] < handicap[2], handicap[1], handicap[2]) if _n == 3 & _N == 3
by grouping_id: replace hand_min = handicap[2] if _n == 1 & _N == 2
by grouping_id: replace hand_min = handicap[1] if _n == 2 & _N == 2
by grouping_id: replace hand_top10 = handicap[2] < $hand10 | handicap[3] < $hand10 if _n == 1 & _N == 3
by grouping_id: replace hand_top10 = handicap[1] < $hand10 | handicap[3] < $hand10 if _n == 2 & _N == 3
by grouping_id: replace hand_top10 = handicap[1] < $hand10 | handicap[2] < $hand10 if _n == 3 & _N == 3
by grouping_id: replace hand_top10 = handicap[1] < $hand10 if _n == 2 & _N == 2
by grouping_id: replace hand_top10 = handicap[2] < $hand10 if _n == 1 & _N == 2
by grouping_id: replace hand_bot10 = (handicap[2] > $hand90) | (handicap[3] > $hand90) if _n == 1 & _N == 3
by grouping_id: replace hand_bot10 = (handicap[1] > $hand90) | (handicap[3] > $hand90) if _n == 2 & _N == 3
by grouping_id: replace hand_bot10 = (handicap[2] > $hand90) | (handicap[1] > $hand90) if _n == 3 & _N == 3
by grouping_id: replace hand_bot10 = (handicap[2] > $hand90) if _n == 1 & _N == 2
by grouping_id: replace hand_bot10 = (handicap[1] > $hand90) if _n == 2 & _N == 2
by grouping_id: replace hand_top25 = handicap[2] < $hand25 | handicap[3] < $hand25 if _n == 1 & _N == 3
by grouping_id: replace hand_top25 = handicap[1] < $hand25 | handicap[3] < $hand25 if _n == 2 & _N == 3
by grouping_id: replace hand_top25 = handicap[1] < $hand25 | handicap[2] < $hand25 if _n == 3 & _N == 3
by grouping_id: replace hand_top25 = handicap[2] < $hand25 if _n == 1 & _N == 2
by grouping_id: replace hand_top25 = handicap[1] < $hand25 if _n == 2 & _N == 2
by grouping_id: replace hand_bot25 = (handicap[2] > $hand75) | (handicap[3] > $hand75) if _n == 1 & _N == 3
by grouping_id: replace hand_bot25 = (handicap[1] > $hand75) | (handicap[3] > $hand75) if _n == 2 & _N == 3
by grouping_id: replace hand_bot25 = (handicap[2] > $hand75) | (handicap[1] > $hand75) if _n == 3 & _N == 3
by grouping_id: replace hand_bot25 = (handicap[2] > $hand75) if _n == 1 & _N ==2
by grouping_id: replace hand_bot25 = (handicap[1] > $hand75) if _n == 2 & _N ==2
by grouping_id: gen tempsize = _N
assert hand_min == hand_max if tempsize == 2  

assert handicap_c2 < .
gen wgt = 1 / (handicap_c2 / ntourn)
label variable wgt "Weight used in regressions; inverse of sampling error in player ability"

save aaa, replace


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

*Part 1 - All regressions other than the one with measurement error correction in Table 4 - All okay

*Compressed code - avoids loading and reloading files and adding and dropping dummies

use aaa, clear
generate OriginalOrder = _n
gen hand_iXdiff  = hand_i * (hand_i - handicap)
gen handicapXhand_i = handicap * hand_i
gen first_yearXhand_i = first_year * hand_i
gen tigerwoods = (player == "tiger woods")
sort round tourn teegprd1 player
by round tourn: gen grp = floor( (_n-1) / (_N / 3))
by round tourn: gen Mgrp = teegprd1 - teegprd1[1]
gen grpSq = Mgrp*Mgrp
gen grpCubed = Mgrp*Mgrp*Mgrp
gen grpQuart = Mgrp*Mgrp*Mgrp*Mgrp
gen grpQuint = Mgrp*Mgrp*Mgrp*Mgrp*Mgrp
*In randomization will assume that still play at same time, although now grouped with other players (who are playing at different times)
*In other words, this paper focuses on impact of randomized partners, so examine randomized distribution of partners, taking as given playing times
*Playing time taken as a non-randomized characteristic of the player

xi i.round i.tourncat i.tourn*i.grp i.tourn*Mgrp i.tourn*grpSq i.tourn*grpCubed i.tourn*grpQuart i.tourn*grpQuint
sort OriginalOrder
save DatGKN1, replace

*Table 4 (other than column 2) - All okay
areg scorerd handicap hand_i _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
areg scorerd hand_i _Ir* _Itourncat* [aw=wgt], robust cluster(grouping_id) absorb(player)

*Table 5 - Columns 2 - 5 (Col. 1 is repeat of Table 4) - All okay
foreach var in drivdist putts greenrd {
	areg scorerd `var' `var'_i _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
areg scorerd putts greenrd drivdist putts_i greenrd_i drivdist_i _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)

*Table 6 - All okay - (Col. 1 is repeat of Table 4)
foreach var of varlist hand_max hand_min tigeringrp hand_top10 hand_top25 hand_bot25 hand_bot10 {
	 areg scorerd handicap `var' _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
areg scorerd handicap hand_i hand_iXdiff _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)

*Table 7 - All okay
foreach spec in " " "_Igrp* _ItouXgrp_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_* _ItouXgrpQa*" {
	areg scorerd handicap score_i _Ir* `spec' [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}


*Table 8 - All okay - (Col. 1 is repeat of earlier)
areg scorerd handicap hand_i handicapXhand_i _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
areg scorerd handicap first_year hand_i first_yearXhand_i _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
areg scorerd handicap first_year hand_i handicapXhand_i first_yearXhand_i _Ir* [aw=wgt] , robust cluster(grouping_id) absorb(tourncat) 


***********************************

*Part 2: Measurement error corrected regression in Table 4 - All okay

*Shortening of their code 

use aaa, clear
gen OriginalOrder = _n
gen cons = 1
gen handicap_c2_var = handicap_c2
replace handicap_c2 = handicap_c2 / (ntourn)
capture drop myN
*Following code is essentially calculating by grouping_id (which is the intent)
bys teegprd1 round: gen myN = _N
bys teegprd1 round: egen sum_c2 = sum(handicap_c2_var / ( (myN - 1)^2 * ntourn))
gen hand_i_c2 = sum_c2 - handicap_c2_var / ( (myN - 1)^2 * ntourn)
replace handicap_c2_var = handicap_c2_var / ntourn
*Will not divide by ntourn in randomization formulas further below because of these divisions
xi i.round i.tourncat

sort OriginalOrder
save DatGKN2, replace

meadjusted

capture erase aaa.dta
drop _all

