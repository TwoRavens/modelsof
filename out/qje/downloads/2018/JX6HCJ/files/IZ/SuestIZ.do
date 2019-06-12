
****************************************
****************************************

use DatIZ, clear

*Table 2
global i = 1
foreach a of varlist time1 time3 time7 time14 time28 time56 { 
	foreach b of varlist m1134 m1831 m2428 m3284 m5171 {
		regress dmt treatment if `a'==1 & `b'==1, 
		estimates store M$i
		global i = $i + 1
		}
	}

suest M1 M2 M3 M4 M5 M6 M7 M8 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M28 M29 M30, cluster(id)
test treatment 
matrix F = (r(p), r(drop), r(df), r(chi2), 2)


*Table 3
global i = 1
foreach condition in "" "if pv<fv" {
	foreach specification in "" "C2-FI8" "H2-H7" "C2-H7" {
		regress pv treatment Y2-Y30 `specification' `condition', 
		estimates store M$i
		global i = $i + 1
		}
	}

suest M1 M2 M3 M4 M5 M6 M7 M8, cluster(id)
test treatment 
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 3)

drop _all
svmat double F
save results/SuestIZ, replace


