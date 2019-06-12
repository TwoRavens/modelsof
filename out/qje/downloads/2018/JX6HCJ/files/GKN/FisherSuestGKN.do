

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


****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [aw pw] [if] [in] [, robust cluster(string) absorb(string)]
	gettoken testvars anything: anything, match(match)

	if ($i == 0) {
		global M = ""
		global test = ""
		capture drop yyy* 
		capture drop xx* 
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
		if ("`absorb'" ~= "") quietly areg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `testvars' `anything' [`weight' `exp'] `if' `in', 
		quietly generate Ssample$i = e(sample)
		if ("`absorb'" ~= "") quietly areg `dep' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
		if ("`absorb'" == "") quietly reg `dep' `anything' [`weight' `exp'] if Ssample$i, 
		quietly predict double yyy$i if Ssample$i, resid
		local newtestvars = ""
		foreach var in `testvars' {
			if ("`absorb'" ~= "") quietly areg `var' `anything' [`weight' `exp'] if Ssample$i, absorb(`absorb')
			if ("`absorb'" == "") quietly reg `var' `anything' [`weight' `exp'] if Ssample$i, 
			quietly predict double xx`var'$i if Ssample$i, resid
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		quietly reg yyy$i `newtestvars' [`weight' `exp'], noconstant
		}
	else {
		`cmd' `dep' `testvars' `anything' `if' `in', 
		quietly generate Ssample$i = e(sample)
		local newtestvars = ""
		foreach var in `testvars' {
			quietly generate double xx`var'$i = `var' if Ssample$i
			local newtestvars = "`newtestvars'" + " " + "xx`var'$i"
			}
		`cmd' `dep' `newtestvars' `anything' `if' `in', 
		}
	estimates store M$i
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatGKN1, clear

capture drop n
bys player year: gen n = _n
summ handicap if n == 1, det
foreach j in 10 25 75 90 {
	global hand`j' = r(p`j')
	}

*Table 4 - without meadjusted, as these can't suest
global i = 0
mycmd (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
mycmd (hand_i) areg scorerd hand_i _Ir* _Itourncat* [aw=wgt], robust cluster(grouping_id) absorb(player)

quietly suest $M, cluster(grouping_id)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 4)

*Table 5 
global i = 0
foreach var in drivdist putts greenrd {
	mycmd (`var'_i) areg scorerd `var'_i `var' _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
mycmd (putts_i greenrd_i drivdist_i) areg scorerd putts_i greenrd_i drivdist_i putts greenrd drivdist _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
mycmd (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)

quietly suest $M, cluster(grouping_id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)

*Table 6 
global i = 0
foreach var of varlist hand_max hand_min tigeringrp hand_top10 hand_top25 hand_bot25 hand_bot10 {
	mycmd (`var') areg scorerd `var' handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
mycmd (hand_i hand_iXdiff) areg scorerd hand_i hand_iXdiff handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
mycmd (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)

quietly suest $M, cluster(grouping_id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

*Table 7
global i = 0
foreach spec in " " "_Igrp* _ItouXgrp_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_* _ItouXgrpQa*" {
	mycmd (score_i) areg scorerd score_i handicap  _Ir* `spec' [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}

quietly suest $M, cluster(grouping_id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)

*Table 8
global i = 0
mycmd (hand_i handicapXhand_i) areg scorerd hand_i handicapXhand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
mycmd (hand_i first_yearXhand_i) areg scorerd hand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
mycmd (hand_i handicapXhand_i first_yearXhand_i) areg scorerd hand_i handicapXhand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt] , robust cluster(grouping_id) absorb(tourncat) 
mycmd (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)

quietly suest $M, cluster(grouping_id)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 8)

*Follow author's clustering, but retain randomization method which is that (mostly) matched within cat
egen Strata = group(tourn cat round) 
egen Group = group(grouping_id) 
sort Strata OriginalOrder
rename OriginalOrder Order
mata Y = st_data(.,"Group")
generate double U = .

mata ResF = J($reps,25,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() 
	quietly sort Strata U 
	mata st_store(.,"Group",Y)
	quietly recalculate
	capture drop grouping_id
	quietly generate grouping_id = Group

*Table 4 - without meadjusted, as these can't suest
global i = 0
mycmd (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
mycmd (hand_i) areg scorerd hand_i _Ir* _Itourncat* [aw=wgt], robust cluster(grouping_id) absorb(player)

capture suest $M, cluster(grouping_id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 4)
		}
	}

*Table 5 
global i = 0
foreach var in drivdist putts greenrd {
	mycmd (`var'_i) areg scorerd `var'_i `var' _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
mycmd (putts_i greenrd_i drivdist_i) areg scorerd putts_i greenrd_i drivdist_i putts greenrd drivdist _Ir* if use_in_skill == 1 [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
mycmd (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)

capture suest $M, cluster(grouping_id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 5)
		}
	}

*Table 6 
global i = 0
foreach var of varlist hand_max hand_min tigeringrp hand_top10 hand_top25 hand_bot25 hand_bot10 {
	mycmd (`var') areg scorerd `var' handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}
mycmd (hand_i hand_iXdiff) areg scorerd hand_i hand_iXdiff handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
mycmd (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)

capture suest $M, cluster(grouping_id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',11..15] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 6)
		}
	}

*Table 7
global i = 0
foreach spec in " " "_Igrp* _ItouXgrp_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_*" "_ItouXMgrp_* _ItouXgrpS* _ItouXgrpC* _ItouXgrpQ_* _ItouXgrpQa*" {
	mycmd (score_i) areg scorerd score_i handicap  _Ir* `spec' [aw=wgt], robust cluster(grouping_id) absorb(tourncat)
	}

capture suest $M, cluster(grouping_id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',16..20] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 7)
		}
	}

*Table 8
global i = 0
mycmd (hand_i handicapXhand_i) areg scorerd hand_i handicapXhand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
mycmd (hand_i first_yearXhand_i) areg scorerd hand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat) 
mycmd (hand_i handicapXhand_i first_yearXhand_i) areg scorerd hand_i handicapXhand_i first_yearXhand_i handicap first_year _Ir* [aw=wgt] , robust cluster(grouping_id) absorb(tourncat) 
mycmd (hand_i) areg scorerd hand_i handicap _Ir* [aw=wgt], robust cluster(grouping_id) absorb(tourncat)

capture suest $M, cluster(grouping_id)
if (_rc == 0) {
	capture test $test
	if (_rc == 0) {
		mata ResF[`c',21..25] = (`r(p)', `r(drop)', `r(df)', `r(chi2)', 8)
		}
	}

}

drop _all
set obs $reps
forvalues i = 1/25 {
	quietly generate double ResF`i' = .
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
sort N
save results\FisherSuestGKN, replace

