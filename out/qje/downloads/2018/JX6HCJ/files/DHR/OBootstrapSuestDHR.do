
capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) ]
	if ($i == 0) {
		global M = ""
		global test = ""
		estimates clear
		capture drop xxx*
		matrix B = J(1,100,.)
		global j = 0
		}
	global i = $i + 1

	gettoken testvars anything: anything, match(match)
	gettoken cmd anything: anything
	gettoken dep anything: anything
	foreach var in `testvars' {
		local anything = subinstr("`anything'","`var'","",1)
		}
	local newtestvars = ""
	foreach var in `testvars' {
		quietly gen xxx`var'$i = `var'
		local newtestvars = "`newtestvars'" + " " + "xxx`var'$i"
		}
	capture `cmd' `dep' `newtestvars' `anything' [`weight' `exp'] `if' `in'
	if (_rc == 0) {
		estimates store M$i
		foreach var in `newtestvars' {
			global j = $j + 1
			matrix B[1,$j] = _b[`var']
			}
		}
	global M = "$M" + " " + "M$i"
	global test = "$test" + " " + "`newtestvars'"

end

****************************************
****************************************

use DatDHR1, clear

*Table 2
global i = 0
foreach X in "RC==1" "above_score == 1" "above_score == 0" {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd (treat) regress open treat if `X' & `Y', cluster(schid)	
		}
	}

quietly suest $M, cluster(schid)
test $test
matrix F = (r(p), r(drop), r(df), r(chi2), 2)
matrix B2 = B[1,1..$j]

*Table 6 
global i = 0
foreach X in inside interact_kids bbused {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd (treat) regress `X' treat if open == 1 & `Y', cluster(schid)
		}
	}

quietly suest $M, cluster(schid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)
matrix B6 = B[1,1..$j]

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResF = J($reps,10,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop schid
	rename obs schid

*Table 2
global i = 0
foreach X in "RC==1" "above_score == 1" "above_score == 0" {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd (treat) regress open treat if `X' & `Y', cluster(schid)	
		}
	}

capture suest $M, cluster(schid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B2)*invsym(V)*(B[1,1..$j]-B2)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 2)
		}
	}

*Table 6 
global i = 0
foreach X in inside interact_kids bbused {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd (treat) regress `X' treat if open == 1 & `Y', cluster(schid)
		}
	}

capture suest $M, cluster(schid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B6)*invsym(V)*(B[1,1..$j]-B6)'
		mata test = st_matrix("test"); ResF[`c',6..10] = (`r(p)', `r(drop)', `r(df)', test[1,1], 6)
		}
	}
}

drop _all
set obs $reps
forvalues i = 1/10 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestDHR1, replace


*************************************
*************************************

use DatDHR2a, clear

*Table 7 
global i = 0
foreach X in "if open == 1" "" "if open == 1 & drop == 0" "if drop == 0" "if drop == 0 & pre_writ == 0" "if drop == 0 & pre_writ == 1" {
	mycmd (treat) reg attendance treat `X', cluster(schid)
	mycmd (treatpre treatpost treatexp) reg attendance treatpre treatpost treatexp t_1-t_29 `X', cluster(schid)
	}

quietly suest $M, cluster(schid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 7)
matrix B7 = B[1,1..$j]

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save bb, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using bb
	drop schid
	rename obs schid

*Table 7 
global i = 0
foreach X in "if open == 1" "" "if open == 1 & drop == 0" "if drop == 0" "if drop == 0 & pre_writ == 0" "if drop == 0 & pre_writ == 1" {
	mycmd (treat) reg attendance treat `X', cluster(schid)
	mycmd (treatpre treatpost treatexp) reg attendance treatpre treatpost treatexp t_1-t_29 `X', cluster(schid)
	}

capture suest $M, cluster(schid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B7)*invsym(V)*(B[1,1..$j]-B7)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 7)
		}
	}
}

drop _all
set obs $reps
forvalues i = 11/15 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestDHR2a, replace


******************************
******************************

*dropping colinear

use DatDHR2b, clear

*Table 10 
global i = 0
*foreach X in drop gov drop2 {
foreach X in drop drop2 {
	mycmd (treat) reg `X' treat, cluster(schid)
	}

quietly suest $M, cluster(schid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 10)
matrix B10 = B[1,1..$j]

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save cc, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using cc
	drop schid
	rename obs schid

*Table 10 
global i = 0
foreach X in drop drop2 {
	mycmd (treat) reg `X' treat, cluster(schid)
	}

capture suest $M, cluster(schid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B10)*invsym(V)*(B[1,1..$j]-B10)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 10)
		}
	}
}

drop _all
set obs $reps
forvalues i = 16/20 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestDHR2b, replace


******************************
******************************

*dropping colinear

use DatDHR3a, clear
foreach X in mid_writ z_add_mid_math z_add_mid_lang z_add_mid_total {
	rename `X' A`X'
	}
rename treat Atreat
keep A* schid childno
sort schid childno
save a1, replace

use DatDHR3b, clear
foreach X in post_writ z_add_post_math z_add_post_lang z_add_post_total {
	rename `X' B`X'
	}
rename treat Btreat
keep B* schid childno
sort schid childno
save a2, replace

use a1, clear
merge schid childno using a2
drop _m
egen m = group(schid childno)
sort m
quietly replace Atreat = . if m == m[_n-1]

*Dropping colinear

*Table 8
global i = 0
*foreach X in Amid_writ Az_add_mid_math Az_add_mid_lang Az_add_mid_total {
foreach X in Amid_writ Az_add_mid_math Az_add_mid_lang {
	mycmd (Atreat) regress `X' Atreat, cluster(schid)
	}

*foreach X in Bpost_writ Bz_add_post_math Bz_add_post_lang Bz_add_post_total {
foreach X in Bpost_writ Bz_add_post_math Bz_add_post_lang {
	mycmd (Btreat) regress `X' Btreat, cluster(schid)
	}

quietly suest $M, cluster(schid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 8)
matrix B8 = B[1,1..$j]

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save dd, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using dd
	drop schid
	rename obs schid

*Table 8
global i = 0
foreach X in Amid_writ Az_add_mid_math Az_add_mid_lang {
	mycmd (Atreat) regress `X' Atreat, cluster(schid)
	}
foreach X in Bpost_writ Bz_add_post_math Bz_add_post_lang {
	mycmd (Btreat) regress `X' Btreat, cluster(schid)
	}

capture suest $M, cluster(schid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B8)*invsym(V)*(B[1,1..$j]-B8)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 8)
		}
	}
}

drop _all
set obs $reps
forvalues i = 21/25 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestDHR3, replace

******************************
******************************

use DatDHR4a, clear
foreach var in mid_writ treat pre_math_v pre_math_w pre_lang_v pre_lang_w pre_total_v pre_total_w pre_writ {
	rename `var' A`var'
	}
foreach X in math lang total {
	rename z_add_mid_`X' Az_add_mid_`X'
	}
keep A* schid childno
sort schid childno
save a1, replace

use DatDHR4b, clear
foreach var in mid_writ treat pre_math_v pre_math_w pre_lang_v pre_lang_w pre_total_v pre_total_w pre_writ block score infra sex {
	rename `var' B`var'
	}
foreach X in math lang total {
	rename z_add_mid_`X' Bz_add_mid_`X'
	}
keep B* schid childno
sort schid childno
save a2, replace

use DatDHR4c, clear
foreach var in post_writ treat pre_math_v pre_math_w pre_lang_v pre_lang_w pre_total_v pre_total_w pre_writ  {
	rename `var' C`var'
	}
foreach X in math lang total {
	rename z_add_post_`X' Cz_add_post_`X'
	}
keep C* schid childno
sort schid childno
save a3, replace

use DatDHR4d, clear
foreach var in post_writ treat pre_math_v pre_math_w pre_lang_v pre_lang_w pre_total_v pre_total_w pre_writ block score infra sex {
	rename `var' D`var'
	}
foreach X in math lang total {
	rename z_add_post_`X' Dz_add_post_`X'
	}
keep D* schid childno
sort schid childno
save a4, replace

use a1
forvalues i = 2/4 {
	merge schid childno using a`i'
	drop _m
	sort schid childno
	}
egen m = group(schid childno)
sort m
quietly replace Atreat = . if m == m[_n-1]
quietly replace Btreat = . if m == m[_n-1]
*they duplicated observations in files a3, a4 (can see this in paper by looking at gender counts in table)

global i = 0

*Table 9a
mycmd (Atreat) regress Amid_writ Atreat Apre_math_v Apre_math_w Apre_writ, cluster(schid)
foreach X in math lang total {
	mycmd (Atreat) regress Az_add_mid_`X' Atreat Apre_`X'_v Apre_`X'_w Apre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd (Atreat) regress Az_add_mid_`X' Atreat Apre_`X'_v if Apre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd (Atreat) regress Az_add_mid_`X' Atreat Apre_`X'_w if Apre_writ==1, cluster(schid)
	}

*Table 9b
mycmd (Btreat) regress Bmid_writ Btreat Bpre_math_v Bpre_math_w Bpre_writ Bblock Bscore Binfra, cluster(schid)
foreach X in math lang total {
	mycmd (Btreat) regress Bz_add_mid_`X' Btreat Bpre_`X'_v Bpre_`X'_w Bpre_writ Bblock Bscore Binfra, cluster(schid)
	}
foreach S in 2 1 {
	mycmd (Btreat) regress Bmid_writ Btreat Bpre_math_v Bpre_math_w Bpre_writ if Bsex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd (Btreat) regress Bz_add_mid_`X' Btreat Bpre_`X'_v Bpre_`X'_w Bpre_writ if Bsex == `S', cluster(schid)
		}
	}

*Table 9c
mycmd (Ctreat) regress Cpost_writ Ctreat Cpre_math_v Cpre_math_w Cpre_writ, cluster(schid)
foreach X in math lang total {
	mycmd (Ctreat) regress Cz_add_post_`X' Ctreat Cpre_`X'_v Cpre_`X'_w Cpre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd (Ctreat) regress Cz_add_post_`X' Ctreat Cpre_`X'_v if Cpre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd (Ctreat) regress Cz_add_post_`X' Ctreat Cpre_`X'_w if Cpre_writ==1, cluster(schid)
	}

*Table 9d
mycmd (Dtreat) regress Dpost_writ Dtreat Dpre_math_v Dpre_math_w Dpre_writ Dblock Dscore Dinfra, cluster(schid)
foreach X in math lang total {
	mycmd (Dtreat) regress Dz_add_post_`X' Dtreat Dpre_`X'_v Dpre_`X'_w Dpre_writ Dblock Dscore Dinfra, cluster(schid)
	}

foreach S in 2 1 {
	mycmd (Dtreat) regress Dpost_writ Dtreat Dpre_math_v Dpre_math_w Dpre_writ if Dsex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd (Dtreat) regress Dz_add_post_`X' Dtreat Dpre_`X'_v Dpre_`X'_w Dpre_writ if Dsex == `S', cluster(schid)
		}
	}

quietly suest $M, cluster(schid)
test $test
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 9)
matrix B9 = B[1,1..$j]

capture drop N
capture drop _m
sort schid
merge schid using Sample1
tab _m
drop _m
sort N
save ff, replace

mata ResF = J($reps,5,.)
forvalues c = 1/$reps {
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using ff
	drop schid
	rename obs schid


global i = 0

*Table 9a
mycmd (Atreat) regress Amid_writ Atreat Apre_math_v Apre_math_w Apre_writ, cluster(schid)
foreach X in math lang total {
	mycmd (Atreat) regress Az_add_mid_`X' Atreat Apre_`X'_v Apre_`X'_w Apre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd (Atreat) regress Az_add_mid_`X' Atreat Apre_`X'_v if Apre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd (Atreat) regress Az_add_mid_`X' Atreat Apre_`X'_w if Apre_writ==1, cluster(schid)
	}

*Table 9b
mycmd (Btreat) regress Bmid_writ Btreat Bpre_math_v Bpre_math_w Bpre_writ Bblock Bscore Binfra, cluster(schid)
foreach X in math lang total {
	mycmd (Btreat) regress Bz_add_mid_`X' Btreat Bpre_`X'_v Bpre_`X'_w Bpre_writ Bblock Bscore Binfra, cluster(schid)
	}
foreach S in 2 1 {
	mycmd (Btreat) regress Bmid_writ Btreat Bpre_math_v Bpre_math_w Bpre_writ if Bsex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd (Btreat) regress Bz_add_mid_`X' Btreat Bpre_`X'_v Bpre_`X'_w Bpre_writ if Bsex == `S', cluster(schid)
		}
	}

*Table 9c
mycmd (Ctreat) regress Cpost_writ Ctreat Cpre_math_v Cpre_math_w Cpre_writ, cluster(schid)
foreach X in math lang total {
	mycmd (Ctreat) regress Cz_add_post_`X' Ctreat Cpre_`X'_v Cpre_`X'_w Cpre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd (Ctreat) regress Cz_add_post_`X' Ctreat Cpre_`X'_v if Cpre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd (Ctreat) regress Cz_add_post_`X' Ctreat Cpre_`X'_w if Cpre_writ==1, cluster(schid)
	}

*Table 9d
mycmd (Dtreat) regress Dpost_writ Dtreat Dpre_math_v Dpre_math_w Dpre_writ Dblock Dscore Dinfra, cluster(schid)
foreach X in math lang total {
	mycmd (Dtreat) regress Dz_add_post_`X' Dtreat Dpre_`X'_v Dpre_`X'_w Dpre_writ Dblock Dscore Dinfra, cluster(schid)
	}

foreach S in 2 1 {
	mycmd (Dtreat) regress Dpost_writ Dtreat Dpre_math_v Dpre_math_w Dpre_writ if Dsex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd (Dtreat) regress Dz_add_post_`X' Dtreat Dpre_`X'_v Dpre_`X'_w Dpre_writ if Dsex == `S', cluster(schid)
		}
	}

capture suest $M, cluster(schid)
if (_rc == 0) {
	capture test $test, matvlc(V)
	if (_rc == 0) {
		matrix test = (B[1,1..$j]-B9)*invsym(V)*(B[1,1..$j]-B9)'
		mata test = st_matrix("test"); ResF[`c',1..5] = (`r(p)', `r(drop)', `r(df)', test[1,1], 9)
		}
	}
}

drop _all
set obs $reps
forvalues i = 26/30 {
	quietly generate double ResF`i' = . 
	}
mata st_store(.,.,ResF)
svmat double F
gen N = _n
save ip\OBootstrapSuestDHR4, replace

**********************
**********************
drop _all
use ip\OBootstrapSuestDHR1
merge 1:1 N using ip\OBootstrapSuestDHR2a, nogenerate
merge 1:1 N using ip\OBootstrapSuestDHR2b, nogenerate
merge 1:1 N using ip\OBootstrapSuestDHR3, nogenerate
merge 1:1 N using ip\OBootstrapSuestDHR4, nogenerate
drop F*
svmat double F
aorder
save results\OBootstrapSuestDHR, replace

foreach file in a1 a2 a3 a4 aa aaa bb cc dd ff {
	capture erase `file'.dta
	}





