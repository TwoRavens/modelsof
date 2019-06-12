
*randomize at treatment level



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

use DatIZ, clear

matrix F = J(38,4,.)
matrix B = J(38,2,.)

global i = 1
global j = 1

*Table 2
foreach a of varlist time1 time3 time7 time14 time28 time56 { 
	foreach b of varlist m1134 m1831 m2428 m3284 m5171 {
		mycmd (treatment) regress dmt treatment if `a'==1 & `b'==1, cluster(Session)
		}
	}

*Table 3
foreach condition in "" "if pv<fv" {
	foreach specification in "" "C2-FI8" "H2-H7" "C2-H7" {
		mycmd (treatment) regress pv treatment Y2-Y30 `specification' `condition', cluster(Session)
		}
	}

bysort Session: gen N = _n
sort N Session
global N = 4
mata Y = st_data((1,$N),"treatment")
generate Order = _n
generate double U = .

mata ResF = J($reps,38,.); ResD = J($reps,38,.); ResDF = J($reps,38,.); ResB = J($reps,38,.); ResSE = J($reps,38,.)
forvalues c = 1/$reps {
	matrix FF = J(38,3,.)
	matrix BB = J(38,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"treatment",Y)
	sort Session N
	quietly replace treatment = treatment[_n-1] if Session == Session[_n-1]

global i = 1
global j = 1

*Table 2
foreach a of varlist time1 time3 time7 time14 time28 time56 { 
	foreach b of varlist m1134 m1831 m2428 m3284 m5171 {
		mycmd1 (treatment) regress dmt treatment if `a'==1 & `b'==1, cluster(Session)
		}
	}

*Table 3
foreach condition in "" "if pv<fv" {
	foreach specification in "" "C2-FI8" "H2-H7" "C2-H7" {
		mycmd1 (treatment) regress pv treatment Y2-Y30 `specification' `condition', cluster(Session)
		}
	}

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..38] = FF[.,1]'; ResD[`c',1..38] = FF[.,2]'; ResDF[`c',1..38] = FF[.,3]'
mata ResB[`c',1..38] = BB[.,1]'; ResSE[`c',1..38] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/38 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\FisherAIZ, replace





