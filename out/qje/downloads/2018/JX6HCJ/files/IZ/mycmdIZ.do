global cluster = "id"

use DatIZ, clear

global i = 1
global j = 1

*Table 2
foreach a of varlist time1 time3 time7 time14 time28 time56 { 
	foreach b of varlist m1134 m1831 m2428 m3284 m5171 {
		mycmd (treatment) regress dmt treatment if `a'==1 & `b'==1, 
		}
	}

*Table 3
foreach condition in "" "if pv<fv" {
	foreach specification in "" "C2-FI8" "H2-H7" "C2-H7" {
		mycmd (treatment) regress pv treatment Y2-Y30 `specification' `condition', cluster(id)
		}
	}


