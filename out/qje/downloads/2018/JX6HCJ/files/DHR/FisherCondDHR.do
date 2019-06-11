
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$ii,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$jj+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global ii = $ii + 1
global jj = $jj + $k
end

****************************************
****************************************

use DatDHR1, clear

matrix F = J(91,4,.)
matrix B = J(103,2,.)

global ii = 1
global jj = 1

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

***********************************************************************************************************;

*Table 3 - only treatment schools
*Table 4 - structural model, no stata do file code
*Table 5 - policy analysis

use DatDHR2a, clear

*Table 7 
foreach X in "if open == 1" "" "if open == 1 & drop == 0" "if drop == 0" "if drop == 0 & pre_writ == 0" "if drop == 0 & pre_writ == 1" {
	mycmd (treat) reg attendance treat `X', cluster(schid)
	mycmd (treatpre treatpost treatexp) reg attendance treatpre treatpost treatexp t_1-t_29 `X', cluster(schid)
	}

*****************************

use DatDHR2b, clear

*Table 10 
foreach X in drop gov drop2 {
	mycmd (treat) reg `X' treat, cluster(schid)
	}

***********************************************

use DatDHR3a, clear

*Table 8
foreach X in mid_writ z_add_mid_math z_add_mid_lang z_add_mid_total {
	mycmd (treat) regress `X' treat, cluster(schid)
	}

**************************************

use DatDHR3b, clear

foreach X in post_writ z_add_post_math z_add_post_lang z_add_post_total {
	mycmd (treat) regress `X' treat, cluster(schid)
	}

********************************************

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

****************************

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

*****************************

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

****************************

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


****************************
****************************
****************************



use DatDHR1, clear

global i = 0

*Combining Tables 2 and 6 into one randomization analysis with shortened code
foreach X in "RC==1" "above_score == 1" "above_score == 0" {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
	global i = $i + 1
		randcmdc ((treat) regress open treat if `X' & `Y', cluster(schid)	), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
		}
	}

foreach X in inside interact_kids bbused {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
	global i = $i + 1
		randcmdc ((treat) regress `X' treat if open == 1 & `Y', cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
		}
	}


***********************************************************************************************************;

*Table 3 - only treatment schools
*Table 4 - structural model, no stata do file code
*Table 5 - policy analysis

use DatDHR2a, clear

*Table 7 
foreach X in "if open == 1" "" "if open == 1 & drop == 0" "if drop == 0" "if drop == 0 & pre_writ == 0" "if drop == 0 & pre_writ == 1" {
	global i = $i + 1
		randcmdc ((treat) reg attendance treat `X', cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)

	forvalues j = 1/3 {
		global i = $i + 1
		preserve
			drop _all
			set obs $reps
			foreach var in ResB ResSE ResF {
				gen `var' = .
				}
			gen __0000001 = 0 if _n == 1
			gen __0000002 = 0 if _n == 1
			save ip\a$i, replace
		restore
		}	
	}


*****************************

use DatDHR2b, clear

*Table 10 
foreach X in drop gov drop2 {
	global i = $i + 1
		randcmdc ((treat) reg `X' treat, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	}

***********************************************

use DatDHR3a, clear

*Table 8
foreach X in mid_writ z_add_mid_math z_add_mid_lang z_add_mid_total {
	global i = $i + 1
		randcmdc ((treat) regress `X' treat, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	}

**************************************

use DatDHR3b, clear

foreach X in post_writ z_add_post_math z_add_post_lang z_add_post_total {
	global i = $i + 1
		randcmdc ((treat) regress `X' treat, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	}

********************************************

use DatDHR4a, clear

*Table 9a
global i = $i + 1
	randcmdc ((treat) regress mid_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
foreach X in math lang total {
	global i = $i + 1
		randcmdc ((treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	}
foreach X in math lang total {
	global i = $i + 1
		randcmdc ((treat) regress z_add_mid_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	}
foreach X in math lang total {
	global i = $i + 1
		randcmdc ((treat) regress z_add_mid_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	}

****************************

use DatDHR4b, clear

*Table 9b
	global i = $i + 1
		randcmdc ((treat) regress mid_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
foreach X in math lang total {
	global i = $i + 1
		randcmdc ((treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	}
foreach S in 2 1 {
global i = $i + 1
	randcmdc ((treat) regress mid_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	foreach X in math lang total {
	global i = $i + 1
		randcmdc ((treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
		}
	}

*****************************

use DatDHR4c, clear

*Table 9c
global i = $i + 1
	randcmdc ((treat) regress post_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)

foreach X in math lang total {
	global i = $i + 1
		randcmdc ((treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	}
foreach X in math lang total {
	global i = $i + 1
		randcmdc ((treat) regress z_add_post_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	}
foreach X in math lang total {
	global i = $i + 1
		randcmdc ((treat) regress z_add_post_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	}

****************************

use DatDHR4d, clear

*Table 9d
global i = $i + 1
	randcmdc ((treat) regress post_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
foreach X in math lang total {
	global i = $i + 1
		randcmdc ((treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	}

foreach S in 2 1 {
	global i = $i + 1
		randcmdc ((treat) regress post_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
	foreach X in math lang total {
	global i = $i + 1
		randcmdc ((treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)), treatvars(treat) seed(1) saving(ip\a$i, replace) reps($reps) sample groupvar(schid)
		}
	}

*********************************************



matrix T = J($i,2,.)
use ip\a1, clear
mkmat __* in 1/1, matrix(a)
drop __*
matrix T[1,1] = a
rename ResB ResB1
rename ResSE ResSE1
rename ResF ResF1
forvalues i = 2/$i {
	merge using ip\a`i'
	mkmat __* in 1/1, matrix(a)
	drop __* _m
	matrix T[`i',1] = a
	rename ResB ResB`i'
	rename ResSE ResSE`i'
	rename ResF ResF`i'
	}
svmat double F
svmat double B
svmat double T
gen N = _n
sort N
compress
aorder
save results\FisherCondDHR, replace

