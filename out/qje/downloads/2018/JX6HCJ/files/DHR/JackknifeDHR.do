

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string)]
	gettoken testvars anything: anything, match(match)
	if ("`absorb'" == "") `anything' `if' `in', cluster(`cluster') `robust'
	if ("`absorb'" ~= "") `anything' `if' `in', cluster(`cluster') `robust' absorb(`absorb')
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
		if ("`absorb'" == "") quietly `anything' if M ~= `i', cluster(`cluster') `robust'
		if ("`absorb'" ~= "") quietly `anything' if M ~= `i', cluster(`cluster') `robust' absorb(`absorb')
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

use ip\JK1, clear
forvalues i = 2/91 {
	merge using ip\JK`i'
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
save results\JackKnifeDHR, replace


