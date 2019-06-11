
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
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', cluster(`cluster')
	capture testparm `testvars'
	if (_rc == 0) {
		matrix FF[$i,1] = r(p), r(drop), e(df_r)
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

global N = 120

*****************************

use DatDHR1, clear

matrix F = J(24,4,.)
matrix B = J(24,2,.)

global i = 1
global j = 1

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

generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,24,.); ResD = J($reps,24,.); ResDF = J($reps,24,.); ResB = J($reps,24,.); ResSE = J($reps,24,.)
forvalues c = 1/$reps {
	matrix FF = J(24,3,.)
	matrix BB = J(24,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treat = Y2[`i'] if schid == Y1[`i']
		}

global i = 1
global j = 1

foreach X in "RC==1" "above_score == 1" "above_score == 0" {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd1 (treat) regress open treat if `X' & `Y', cluster(schid)	
		}
	}

foreach X in inside interact_kids bbused {
	foreach Y in "time > 1" "time < 9" "time > 8 & time < 16" "time > 15" {
		mycmd1 (treat) regress `X' treat if open == 1 & `Y', cluster(schid)
		}
	}
 
mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..24] = FF[.,1]'; ResD[`c',1..24] = FF[.,2]'; ResDF[`c',1..24] = FF[.,3]'
mata ResB[`c',1..24] = BB[.,1]'; ResSE[`c',1..24] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/24 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherDHR1, replace



***********************************************************************************************************;

*Table 3 - only treatment schools
*Table 4 - structural model, no stata do file code
*Table 5 - policy analysis


use DatDHR2a, clear

matrix F = J(12,4,.)
matrix B = J(24,2,.)

global i = 1
global j = 1

*Table 7 
foreach X in "if open == 1" "" "if open == 1 & drop == 0" "if drop == 0" "if drop == 0 & pre_writ == 0" "if drop == 0 & pre_writ == 1" {
	mycmd (treat) reg attendance treat `X', cluster(schid)
	mycmd (treatpre treatpost treatexp) reg attendance treatpre treatpost treatexp t_1-t_29 `X', cluster(schid)
	}

generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,12,.); ResD = J($reps,12,.); ResDF = J($reps,12,.); ResB = J($reps,24,.); ResSE = J($reps,24,.)
forvalues c = 1/$reps {
	matrix FF = J(12,3,.)
	matrix BB = J(24,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treat = Y2[`i'] if schid == Y1[`i']
		}
	quietly replace treatpre=treat*pretest
	quietly replace treatpost=treat*posttest
	quietly replace treatexp=treat*postexp

global i = 1
global j = 1

*Table 7 
foreach X in "if open == 1" "" "if open == 1 & drop == 0" "if drop == 0" "if drop == 0 & pre_writ == 0" "if drop == 0 & pre_writ == 1" {
	mycmd1 (treat) reg attendance treat `X', cluster(schid)
	mycmd1 (treatpre treatpost treatexp) reg attendance treatpre treatpost treatexp t_1-t_29 `X', cluster(schid)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..12] = FF[.,1]'; ResD[`c',1..12] = FF[.,2]'; ResDF[`c',1..12] = FF[.,3]'
mata ResB[`c',1..24] = BB[.,1]'; ResSE[`c',1..24] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/12 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/24 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherDHR2a, replace

*****************************

use DatDHR2b, clear

matrix F = J(3,4,.)
matrix B = J(3,2,.)

global i = 1
global j = 1

*Table 10 
foreach X in drop gov drop2 {
	mycmd (treat) reg `X' treat, cluster(schid)
	}

generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,3,.); ResD = J($reps,3,.); ResDF = J($reps,3,.); ResB = J($reps,3,.); ResSE = J($reps,3,.)
forvalues c = 1/$reps {
	matrix FF = J(3,3,.)
	matrix BB = J(3,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treat = Y2[`i'] if schid == Y1[`i']
		}

global i = 1
global j = 1

*Table 10 
foreach X in drop gov drop2 {
	mycmd1 (treat) reg `X' treat, cluster(schid)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..3] = FF[.,1]'; ResD[`c',1..3] = FF[.,2]'; ResDF[`c',1..3] = FF[.,3]'
mata ResB[`c',1..3] = BB[.,1]'; ResSE[`c',1..3] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/3 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherDHR2b, replace


***********************************************

use DatDHR3a, clear

matrix F = J(4,4,.)
matrix B = J(4,2,.)

global i = 1
global j = 1

*Table 8
foreach X in mid_writ z_add_mid_math z_add_mid_lang z_add_mid_total {
	mycmd (treat) regress `X' treat, cluster(schid)
	}

generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,4,.); ResSE = J($reps,4,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(4,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treat = Y2[`i'] if schid == Y1[`i']
		}

global i = 1
global j = 1

*Table 8
foreach X in mid_writ z_add_mid_math z_add_mid_lang z_add_mid_total {
	mycmd1 (treat) regress `X' treat, cluster(schid)
	}
  
mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..4] = BB[.,1]'; ResSE[`c',1..4] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherDHR3a, replace

**************************************

use DatDHR3b, clear

matrix F = J(4,4,.)
matrix B = J(4,2,.)

global i = 1
global j = 1

foreach X in post_writ z_add_post_math z_add_post_lang z_add_post_total {
	mycmd (treat) regress `X' treat, cluster(schid)
	}

generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,4,.); ResSE = J($reps,4,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(4,2,.) 
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treat = Y2[`i'] if schid == Y1[`i']
		}

global i = 1
global j = 1

foreach X in post_writ z_add_post_math z_add_post_lang z_add_post_total {
	mycmd1 (treat) regress `X' treat, cluster(schid)
	}
   
mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..4] = FF[.,1]'; ResD[`c',1..4] = FF[.,2]'; ResDF[`c',1..4] = FF[.,3]'
mata ResB[`c',1..4] = BB[.,1]'; ResSE[`c',1..4] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherDHR3b, replace

********************************************

use DatDHR4a, clear

matrix F = J(10,4,.)
matrix B = J(10,2,.)

global i = 1
global j = 1
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

generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,10,.); ResD = J($reps,10,.); ResDF = J($reps,10,.); ResB = J($reps,10,.); ResSE = J($reps,10,.)
forvalues c = 1/$reps {
	matrix FF = J(10,3,.)
	matrix BB = J(10,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treat = Y2[`i'] if schid == Y1[`i']
		}

global i = 1
global j = 1
*Table 9a
mycmd1 (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
foreach X in math lang total {
	mycmd1 (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd1 (treat) regress z_add_mid_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd1 (treat) regress z_add_mid_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..10] = FF[.,1]'; ResD[`c',1..10] = FF[.,2]'; ResDF[`c',1..10] = FF[.,3]'
mata ResB[`c',1..10] = BB[.,1]'; ResSE[`c',1..10] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/10 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherDHR4a, replace

****************************

use DatDHR4b, clear

matrix F = J(12,4,.)
matrix B = J(12,2,.)

global i = 1
global j = 1

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

generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,12,.); ResD = J($reps,12,.); ResDF = J($reps,12,.); ResB = J($reps,12,.); ResSE = J($reps,12,.)
forvalues c = 1/$reps {
	matrix FF = J(12,3,.)
	matrix BB = J(12,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treat = Y2[`i'] if schid == Y1[`i']
		}

global i = 1
global j = 1

*Table 9b
mycmd1 (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
foreach X in math lang total {
	mycmd1 (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)
	}
foreach S in 2 1 {
	mycmd1 (treat) regress mid_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd1 (treat) regress z_add_mid_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)
		}
	}
 
mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..12] = FF[.,1]'; ResD[`c',1..12] = FF[.,2]'; ResDF[`c',1..12] = FF[.,3]'
mata ResB[`c',1..12] = BB[.,1]'; ResSE[`c',1..12] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/12 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherDHR4b, replace

*****************************

use DatDHR4c, clear

matrix F = J(10,4,.)
matrix B = J(10,2,.)

global i = 1
global j = 1
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

generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,10,.); ResD = J($reps,10,.); ResDF = J($reps,10,.); ResB = J($reps,10,.); ResSE = J($reps,10,.)
forvalues c = 1/$reps {
	matrix FF = J(10,3,.)
	matrix BB = J(10,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treat = Y2[`i'] if schid == Y1[`i']
		}

global i = 1
global j = 1
*Table 9c
mycmd1 (treat) regress post_writ treat pre_math_v pre_math_w pre_writ, cluster(schid)
foreach X in math lang total {
	mycmd1 (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ, cluster(schid)
	}
foreach X in math lang total {
	mycmd1 (treat) regress z_add_post_`X' treat pre_`X'_v if pre_writ==0, cluster(schid)
	}
foreach X in math lang total {
	mycmd1 (treat) regress z_add_post_`X' treat pre_`X'_w if pre_writ==1, cluster(schid)
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..10] = FF[.,1]'; ResD[`c',1..10] = FF[.,2]'; ResDF[`c',1..10] = FF[.,3]'
mata ResB[`c',1..10] = BB[.,1]'; ResSE[`c',1..10] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/10 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherDHR4c, replace

****************************

use DatDHR4d, clear

matrix F = J(12,4,.)
matrix B = J(12,2,.)

global i = 1
global j = 1
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

generate Order = _n
generate double U = .
mata Y = st_data((1,$N),"Y2")

mata ResF = J($reps,12,.); ResD = J($reps,12,.); ResDF = J($reps,12,.); ResB = J($reps,12,.); ResSE = J($reps,12,.)
forvalues c = 1/$reps {
	matrix FF = J(12,3,.)
	matrix BB = J(12,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"Y2",Y)
	forvalues i = 1/$N {
		quietly replace treat = Y2[`i'] if schid == Y1[`i']
		}

global i = 1
global j = 1
*Table 9d
mycmd1 (treat) regress post_writ treat pre_math_v pre_math_w pre_writ block score infra, cluster(schid)
foreach X in math lang total {
	mycmd1 (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ block score infra, cluster(schid)
	}

foreach S in 2 1 {
	mycmd1 (treat) regress post_writ treat pre_math_v pre_math_w pre_writ if sex == `S', cluster(schid)
	foreach X in math lang total {
		mycmd1 (treat) regress z_add_post_`X' treat pre_`X'_v pre_`X'_w pre_writ if sex == `S', cluster(schid)
		}
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..12] = FF[.,1]'; ResD[`c',1..12] = FF[.,2]'; ResDF[`c',1..12] = FF[.,3]'
mata ResB[`c',1..12] = BB[.,1]'; ResSE[`c',1..12] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/12 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save ip\FisherDHR4d, replace

*********************************************

*Combining Files

use ip\FisherDHR1, clear
quietly sum F1
global k = r(N)
quietly sum B1
global kk = r(N)
mkmat F1-F4 in 1/$k, matrix(F)
mkmat B1-B2 in 1/$kk, matrix(B)
drop F1-F4 B1-B2 
sort N
save ip\a1, replace

foreach c in 2a 2b 3a 3b 4a 4b 4c 4d {
	use ip\FisherDHR`c', clear
	quietly sum F1
	global k1 = r(N)
	quietly sum B1
	global kk1 = r(N)
	mkmat F1-F4 in 1/$k1, matrix(FF)
	mkmat B1-B2 in 1/$kk1, matrix(BB)
	drop F1-F4 B1-B2 
	matrix F = F \ FF
	matrix B = B \ BB
	forvalues i = $k1(-1)1 {
		local j = `i' + $k
		rename ResF`i' ResF`j'
		rename ResDF`i' ResDF`j'
		rename ResD`i' ResD`j'
		}
	forvalues i = $kk1(-1)1 {
		local j = `i' + $kk
		rename ResB`i' ResB`j'
		rename ResSE`i' ResSE`j'
		}
	global k = $k + $k1
	global kk = $kk + $kk1
	sort N
	save ip\a`c', replace
	}

use ip\a1, clear
foreach c in 2a 2b 3a 3b 4a 4b 4c 4d {
	sort N
	merge N using ip\a`c'
	tab _m
	drop _m
	}
aorder
sort N
foreach j in F B {
	svmat double `j'
	}
save results\FisherDHR, replace






	




















