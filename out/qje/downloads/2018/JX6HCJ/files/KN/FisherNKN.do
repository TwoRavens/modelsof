
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

use DatKN, clear

matrix F = J(4,4,.)
matrix B = J(4,2,.)

global i = 1
global j = 1

*Table 2
foreach Y in Prod_Comm Prod_Points {
	foreach specification in "" "touchtype experiencedatabase concentration" {
		mycmd (award) reg `Y' award `specification' if treatment !=2, cluster(session1)
		}
	}

bysort session1: gen N = _n
sort N session1
global N = 16
mata Y = st_data((1,$N),"award")
generate double U = .
generate Order = _n

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,4,.); ResSE = J($reps,4,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(4,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"award",Y)
	sort session1 N
	quietly replace award = award[_n-1] if session1 == session1[_n-1] 

global i = 1
global j = 1

*Table 2
foreach Y in Prod_Comm Prod_Points {
	foreach specification in "" "touchtype experiencedatabase concentration" {
		mycmd1 (award) reg `Y' award `specification' if treatment !=2, cluster(session1)
		}
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
save results\FisherKN, replace
	
