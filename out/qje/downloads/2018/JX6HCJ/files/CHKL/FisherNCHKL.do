
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ll]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', `ll'
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
	syntax anything [if] [in] [, ll]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', `ll'
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
use DatCHKL, clear

matrix F = J(3,4,.)
matrix B = J(4,2,.)

global i = 1
global j = 1

*Table 7 
mycmd (dumconf dumnetb) tobit post_rating dumconf dumnetb pre_rating, ll 
mycmd (dumconf) tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
mycmd (dumnetb) tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 

generate N = _n
sort special N
global N = 381
mata Y = st_data((1,$N),("dumconf","dumnetb","expcondition"))
generate Order = _n
generate double U = .

mata ResF = J($reps,3,.); ResD = J($reps,3,.); ResDF = J($reps,3,.); ResB = J($reps,4,.); ResSE = J($reps,4,.)
forvalues c = 1/$reps {
	matrix FF = J(3,3,.)
	matrix BB = J(4,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),("dumconf","dumnetb","expcondition"),Y)

global i = 1
global j = 1

*Table 7 
mycmd1 (dumconf dumnetb) tobit post_rating dumconf dumnetb pre_rating, ll 
mycmd1 (dumconf) tobit post_rating dumconf pre_rating if expcondition != "netben", ll 
mycmd1 (dumnetb) tobit post_rating dumnetb pre_rating if expcondition != "conformity", ll 

mata FF = st_matrix("FF"); BB = st_matrix("BB")
mata ResF[`c',1..3] = FF[.,1]'; ResD[`c',1..3] = FF[.,2]'; ResDF[`c',1..3] = FF[.,3]'
mata ResB[`c',1..4] = BB[.,1]'; ResSE[`c',1..4] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF {
	forvalues i = 1/3 {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/4 {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
sort N
save results\FisherCHKL, replace



