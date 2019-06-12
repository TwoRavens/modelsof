
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, absorb(string) cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', absorb(`absorb') cluster(`cluster')
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
	syntax anything [if] [in] [, absorb(string) cluster(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	quietly `anything' `if' `in', absorb(`absorb') cluster(`cluster')
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

use DatOT, clear

matrix F = J(4,4,.)
matrix B = J(4,2,.)

global i = 1
global j = 1

mycmd (treatment) areg attendance treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd (treat_period) areg attendance treat_period period RESPID2-RESPID198 if after==1, cluster(respid) absorb(date_group)
mycmd (treatment) areg present_diary treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd (treat_period) areg present_diary treat_period period RESPID2-RESPID154 RESPID156-RESPID198 if after==1  , cluster(respid) absorb(date_group)

sort respid school_id
replace school_id = school_id[_n-1] if respid == respid[_n-1] & school_id == .
bysort school_id respid: gen N = _n
sort N school_id respid
global N = 198
generate Order = _n
generate U = .
mata Y = st_data((1,$N),"treatment")

mata ResF = J($reps,4,.); ResD = J($reps,4,.); ResDF = J($reps,4,.); ResB = J($reps,4,.); ResSE = J($reps,4,.)
forvalues c = 1/$reps {
	matrix FF = J(4,3,.)
	matrix BB = J(4,2,.)
	display "`c'"
	set seed `c'
	sort Order
	quietly replace U = uniform() in 1/$N
	sort school_id U in 1/$N
	mata st_store((1,$N),"treatment",Y)
	sort school_id respid N
	quietly replace treatment = treatment[_n-1] if respid == respid[_n-1] & school_id == school_id[_n-1] & N > 1
	quietly replace treat_period = treatment*period

global i = 1
global j = 1

mycmd1 (treatment) areg attendance treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd1 (treat_period) areg attendance treat_period period RESPID2-RESPID198 if after==1, cluster(respid) absorb(date_group)
mycmd1 (treatment) areg present_diary treatment b1_work_yn a1_age a3_grade score62 father_hindu a4_mother_edu SCH_TOT2-SCH_TOT4 d12_husband_edu i11_total_inc c1_mens_yn if after==1 , cluster(respid) absorb(date_group)
mycmd1 (treat_period) areg present_diary treat_period period RESPID2-RESPID154 RESPID156-RESPID198 if after==1  , cluster(respid) absorb(date_group)

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
save results\FisherOT, replace



