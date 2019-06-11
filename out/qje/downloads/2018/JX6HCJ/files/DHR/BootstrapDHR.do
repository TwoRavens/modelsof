
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	tempvar touse newcluster
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust'
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
			capture `anything', cluster(`newcluster') `robust'
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


*******************

global cluster = "schid"

global i = 1
global j = 1

use DatDHR1, clear

*Combining Tables 2 and 6 into one randomization analysis with shortened code
foreach X in "RC==1" "above_score == 1" "above_score == 0" {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd (treat) regress open treat if `X' & `Y', cluster(schid)	
		}
	}

foreach X in inside interact_kids bbused {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd (treat) regress `X' treat if open == 1 & `Y', cluster(schid)
		}
	}

*************************************
*************************************

use DatDHR2a, clear

*Table 7 
foreach X in "if open == 1" "" "if open == 1 & drop == 0" "if drop == 0" "if drop == 0 & pre_writ == 0" "if drop == 0 & pre_writ == 1" {
	mycmd (treat) reg attendance treat `X', cluster(schid)
	mycmd (treatpre treatpost treatexp) reg attendance treatpre treatpost treatexp t_1-t_29 `X', cluster(schid)
	}

******************************
******************************

use DatDHR2b, clear

*Table 10 
foreach X in drop gov drop2 {
	mycmd (treat) reg `X' treat, cluster(schid)
	}

******************************
******************************

use DatDHR3a, clear

*Table 8
foreach X in mid_writ z_add_mid_math z_add_mid_lang z_add_mid_total {
	mycmd (treat) regress `X' treat, cluster(schid)
	}

******************************
******************************

use DatDHR3b, clear

foreach X in post_writ z_add_post_math z_add_post_lang z_add_post_total {
	mycmd (treat) regress `X' treat, cluster(schid)
	}

******************************
******************************

use DatDHR4a, clear

*Table 9a
mycmd (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
foreach X in math lang total {
	mycmd (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd (treat) regress z_add_mid_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd (treat) regress z_add_mid_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)
	}

******************************
******************************

use DatDHR4b, clear

*Table 9b
mycmd (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
foreach X in math lang total {
	mycmd (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)
	}
foreach S in 2 1 {
	mycmd (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)
		}
	}

******************************
******************************

use DatDHR4c, clear

*Table 9c
mycmd (treat) regress post_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
foreach X in math lang total {
	mycmd (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd (treat) regress z_add_post_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd (treat) regress z_add_post_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)
	}

******************************
******************************


use DatDHR4d, clear

*Table 9d
mycmd (treat) regress post_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
foreach X in math lang total {
	mycmd (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)
	}

foreach S in 2 1 {
	mycmd (treat) regress post_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)
		}
	}

******************************
******************************


use ip\BS1, clear
forvalues i = 2/91 {
	merge using ip\BS`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/91 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\BootstrapDHR, replace

