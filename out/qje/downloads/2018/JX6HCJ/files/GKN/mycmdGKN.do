global cluster = "grouping_id"

************************************************

*Part 1

use DatGKN1, clear

capture drop n
bys player year: gen n = _n
summ handicap if n == 1, det
foreach j in 10 25 75 90 {
	global hand`j' = r(p`j')
	}

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

***********************************

*Part 2: Measurement error corrected regression in Table 4 

use DatGKN2, clear

mycmd (hand_i) meadjusted scorerd hand_i handicap _Ir* [aw=wgt], absorb(tourncat)


