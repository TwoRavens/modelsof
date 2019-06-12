
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
	capture `anything' `if' `in', cluster(`cluster') 
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

use DatCL, clear

matrix F = J(2,4,.)
matrix B = J(8,2,.)

global i = 1
global j = 1
*Table 7
mycmd (paintings chat oo within_subj) reg attach_to_gr paintings chat oo within_subj, cluster(date)
mycmd (paintings chat oo within_subj) ologit attach_to_gr paintings chat oo within_subj, cluster(date)

egen Session = group(date)
bys Session: gen N = _n
sort N Session
global N = 27
mata Y = st_data((1,$N),("paintings","chat","oo","within_subj"))
generate Order = _n
generate double U = .

mata ResF = J($reps,2,.); ResD = J($reps,2,.); ResDF = J($reps,2,.); ResB = J($reps,8,.); ResSE = J($reps,8,.)
forvalues c = 1/$reps {
	matrix FF = J(2,3,.)
	matrix BB = J(8,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("paintings","chat","oo","within_subj"),Y)
	sort Session N
	foreach j in paintings chat oo within_subj {
		quietly replace `j' = `j'[_n-1] if N > 1
		}

global i = 1
global j = 1
*Table 7
mycmd1 (paintings chat oo within_subj) reg attach_to_gr paintings chat oo within_subj, cluster(date)
mycmd1 (paintings chat oo within_subj) ologit attach_to_gr paintings chat oo within_subj, cluster(date)

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..2] = FF[.,1]'; ResD[`c',1..2] = FF[.,2]'; ResDF[`c',1..2] = FF[.,3]'
mata ResB[`c',1..8] = BB[.,1]'; ResSE[`c',1..8] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/2 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/8 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\FisherCL, replace

