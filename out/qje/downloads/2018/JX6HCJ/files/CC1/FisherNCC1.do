
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `robust'
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
	syntax anything [if] [in] [, cluster(string) robust]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', cluster(`cluster') `robust'
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
use DatCC1, clear

matrix F = J(2,4,.)
matrix B = J(2,2,.)

global i = 1
global j = 1

*Table 7 
mycmd (TICKET) probit Coop TICKET lagduration cycle2-cycle5 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2 & Period==1, cluster(session)
mycmd (TICKET) probit Coop TICKET lagduration cycle2-cycle5 periods* grimtrigger Lag1 Lag2 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2, cluster(session)

bysort session: gen N = _n
sort N session
global N = 4
mata Y = st_data((1,$N),"TICKET")
generate Order = _n
generate double U = .

mata ResF = J($reps,2,.); ResD = J($reps,2,.); ResDF = J($reps,2,.); ResB = J($reps,2,.); ResSE = J($reps,2,.)
forvalues c = 1/$reps {
	matrix FF = J(2,3,.)
	matrix BB = J(2,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort U in 1/$N
	mata st_store((1,$N),"TICKET",Y)
	sort session N
	quietly replace TICKET = TICKET[_n-1] if session == session[_n-1]

global i = 1
global j = 1

*Table 7 
mycmd1 (TICKET) probit Coop TICKET lagduration cycle2-cycle5 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2 & Period==1, cluster(session)
mycmd1 (TICKET) probit Coop TICKET lagduration cycle2-cycle5 periods* grimtrigger Lag1 Lag2 MALE Business EngScienceMath LowRiskAttitude HighRiskAttitude if type==2, cluster(session)

mata FF = st_matrix("FF"); BB = st_matrix("BB"); 
mata ResF[`c',1..2] = FF[.,1]'; ResD[`c',1..2] = FF[.,2]'; ResDF[`c',1..2] = FF[.,3]' 
mata ResB[`c',1..2] = BB[.,1]'; ResSE[`c',1..2] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResF ResD ResDF ResB ResSE {
	forvalues i = 1/2 {
		quietly generate double `j'`i' = .
		}
	}
mata st_store(.,.,(ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\FisherCC1, replace


